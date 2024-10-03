class CCAgentArbiter extends ovm_component;
	virtual PowerGatingNoParamIF vif;
	virtual PowerGatingResetIF reset_if;
	ovm_analysis_imp #(CCAgentResponseSeqItem, CCAgentArbiter) monitor_i;	
	CCAgentSequencer targetSequencer;
	PowerGatingConfig cfg;

	CCAgentResponseSeqItem gateRequestQ[$];
	CCAgentResponseSeqItem vnnReqRequestQ[$];
	CCAgentResponseSeqItem unGateRequestQ[$];
	CCAgentResponseSeqItem FETRequestQ[$];
	int ungate_priority[$];

   `ovm_component_utils(CCAgentArbiter)

	function new(string name, ovm_component parent);        
  		//parent constructor
 		super.new(name, parent);
		monitor_i = new({name,"monitor_i"}, this);
	endfunction	
	function void build();
		super.build();
	endfunction: build	
    function void setCfg (PowerGatingConfig cfg_arg);
        cfg = cfg_arg;
    endfunction: setCfg	

	function setVIF(virtual PowerGatingNoParamIF vif_arg);
		vif = vif_arg;
	endfunction: setVIF	
	function setResetVIF(virtual PowerGatingResetIF vif_arg);
		reset_if = vif_arg;
	endfunction: setResetVIF	
	
	virtual function void write(CCAgentResponseSeqItem x);
		if(x.cmd == PowerGating::SIP_UG_FLOW) begin
			unGateRequestQ.push_front(x);
			if(cfg.phase == PowerGating::PHASE_1) 
				ungate_priority.push_front(cfg.cfg_sip_pgcb[x.source].ungate_priority);
			else
				ungate_priority.push_front(cfg.cfg_sip_pgcb_all[x.source].ungate_priority);

		end
		else if(x.cmd == PowerGating::FAB_UG_FLOW) begin
			unGateRequestQ.push_front(x);
			ungate_priority.push_front(cfg.cfg_fab_pgcb[x.source].ungate_priority);
		end
		else if (x.cmd == PowerGating::SIP_PG_FLOW || x.cmd == PowerGating::FAB_PG_FLOW)begin
			gateRequestQ.push_front(x);
		end
		else if (x.cmd == PowerGating::VNN_ACK_ASD || x.cmd == PowerGating::VNN_ACK_DSD)begin
			vnnReqRequestQ.push_front(x);
		end
	endfunction : write	

	virtual task run();
		if(cfg.phase == PowerGating::PHASE_1) begin
			if (vif.reset_b !== 1) begin
				@(posedge vif.reset_b);
			end
		end
		else begin
			if (reset_if.reset_b !== 1) begin
				@(posedge reset_if.reset_b);
			end
		end
		forever begin
			fork
				sendItem();
				waitForFETMode();
				waitForReset();
			join_any
			disable fork;
		end
	endtask: run

	virtual task waitForFETMode();
		forever begin
			@(cfg.fetONMode);
			for(int i = 0; i < cfg.num_fet; i ++) begin
				if(cfg.fetONMode[i] == 0 && cfg.fetONMode_prev[i] == 1) begin
					CCAgentResponseSeqItem rsp;
					rsp = CCAgentResponseSeqItem::type_id::create("responsex");
					rsp.randomize();
					rsp.cmd = PowerGating::RESET_FET_ON_MODE;
					rsp.source = i;
					FETRequestQ.push_front(rsp);
				end
				cfg.fetONMode_prev[i] = cfg.fetONMode[i];
			end
		end
	endtask: waitForFETMode


	virtual task waitForReset();
		if(cfg.phase == PowerGating::PHASE_1) 
			@(negedge vif.reset_b);
		else
			@(negedge reset_if.reset_b);

		gateRequestQ = {};
		vnnReqRequestQ = {};
		unGateRequestQ = {};
		ungate_priority = {};
		FETRequestQ = {};
	endtask: waitForReset

	task sendItem();
		forever begin
			CCAgentResponseSeqItem arb_item;
			if(cfg.phase == PowerGating::PHASE_1) 
				cfg.arb_sem.get(1);
			else
				cfg.arb_sem_c.get(1);

			wait (gateRequestQ.size() != 0 || unGateRequestQ.size() != 0 || vnnReqRequestQ.size() != 0  || FETRequestQ.size() != 0);
			arbitrate(arb_item);
			if(arb_item != null) begin
				fork
				begin
					targetSequencer.execute_item(arb_item);
				end
				join_none
			end			
		end
	endtask	
	function arbitrate(output CCAgentResponseSeqItem item_arg);
		int num;
		//chjeck the FET requests
		if(FETRequestQ.size() != 0) begin
			item_arg = FETRequestQ[0];
			FETRequestQ.delete(0);	
		end
		//check if there are ungate requests
		else if(unGateRequestQ.size() != 0) begin
			if(cfg.GetRandomPriorityMode()) begin
				if(unGateRequestQ.size() != 0) begin
					num = $urandom_range(0, unGateRequestQ.size()-1);			
					item_arg = unGateRequestQ[num];
					unGateRequestQ.delete(num);
				end
			end
			else begin
				int j;
				int index;
				if(cfg.no_sip) begin
					j = cfg.num_fab_pgcb + 1;					
				end
				else if (cfg.no_fab) begin
					j = cfg.num_sip_pgcb + 1;					
				end
				else begin
					j = cfg.num_sip_pgcb + cfg.num_fab_pgcb + 1;
				end
				foreach(unGateRequestQ[i]) begin
					if(ungate_priority[i] < j) begin
						j = ungate_priority[i];
						index = i;
					end
				end
				item_arg = unGateRequestQ[index];
				unGateRequestQ.delete(index);				
				ungate_priority.delete(index);
			end
		end
		else if (gateRequestQ.size() != 0) begin
			item_arg = gateRequestQ[0];
			gateRequestQ.delete(0);	
		end
		else if (vnnReqRequestQ.size() != 0) begin
			item_arg = vnnReqRequestQ[0];
			vnnReqRequestQ.delete(0);	
		end

	endfunction
   

    /*********************************************************************
    * Specifies the target sequencer this responder sends its responses to
    *********************************************************************/
    virtual function setTargetSequencer(CCAgentSequencer target);
        targetSequencer = target;
    endfunction: setTargetSequencer

endclass: CCAgentArbiter
