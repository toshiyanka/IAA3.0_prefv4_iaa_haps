class CCAgentSIPResponder extends ovm_component;
	//from FSM
	analysis_fifo #(PowerGatingMonitorSeqItem) monitor_i;
	//To arbiter
	ovm_analysis_port #(CCAgentResponseSeqItem) ap;  

	PowerGatingMonitorSeqItem x;
	CCAgentSequencer targetSequencer;

   `ovm_component_utils(CCAgentSIPResponder)

	function new(string name, ovm_component parent);        
  		//parent constructor
 		super.new(name, parent);
		monitor_i = new({name,"monitor_i"});
		ap = new({name,"ap"}, this);
	endfunction

	function void build();
		super.build();
	endfunction: build

	task run();
		forever begin
			monitor_i.get(x);
			sendRsp(x);
		end
	endtask: run

	local task sendRsp(PowerGatingMonitorSeqItem x);
			CCAgentResponseSeqItem temp;
		
		   	if(x.state == PowerGating::UGFET && x.evnt != PowerGating::VNN_ACK_ASD && x.evnt != PowerGating::VNN_ACK_DSD) begin
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::SIP_UG_FLOW;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse !== 1'b1) begin
					ap.write(temp);
				end
		   	end
		   	if(x.state == PowerGating::PG_HS && x.evnt != PowerGating::VNN_ACK_ASD && x.evnt != PowerGating::VNN_ACK_DSD) begin
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::SIP_PG_FLOW;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse !== 1'b1)
				ap.write(temp);
		   	end			   
		   	if(x.evnt == PowerGating::VNN_ACK_ASD) begin
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = x.evnt;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse !== 1'b1)
				ap.write(temp);
		   	end		
		   	if(x.evnt == PowerGating::VNN_ACK_DSD) begin
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = x.evnt;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse !== 1'b1)
				ap.write(temp);
		   	end		

	endtask: sendRsp

    /*********************************************************************
    * Specifies the target sequencer this responder sends its responses to
    *********************************************************************/
    virtual function setTargetSequencer(CCAgentSequencer target);
        targetSequencer = target;
    endfunction: setTargetSequencer

endclass: CCAgentSIPResponder
