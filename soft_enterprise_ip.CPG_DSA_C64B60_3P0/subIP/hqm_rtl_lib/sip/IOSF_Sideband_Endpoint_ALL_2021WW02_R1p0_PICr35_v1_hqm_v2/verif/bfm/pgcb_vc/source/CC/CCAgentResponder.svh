class CCAgentResponder extends ovm_component;

	analysis_fifo #(PowerGatingMonitorSeqItem) monitor_i;
	ovm_analysis_port #(CCAgentResponseSeqItem) ap; 
	PowerGatingMonitorSeqItem x;
	CCAgentSequencer targetSequencer;

   `ovm_component_utils(CCAgentResponder)

	function new(string name, ovm_component parent);        
  		//parent constructor
 		super.new(name, parent);
		monitor_i = new({name, "monitor_i"}, this);
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
		   if(x.state == PowerGating::IDHYS) begin
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::FAB_PG_REQ_HYS;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse == 1'b0) begin
					fork
						targetSequencer.execute_item(temp);
					join_none
				end
		   end
		   if(x.state == PowerGating::REQ_1) begin
				//temp = new();
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::FAB_UG_REQ;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse == 1'b0) begin
					fork
						targetSequencer.execute_item(temp);
					join_none
				end
		   end

		   if(x.state == PowerGating::IDEXI) begin
				//temp = new();
				temp = CCAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::FAB_UG_REQ;
				temp.source = x.source;
				//col change
				temp.sourceName = x.sourceName;
				//END col change				
				temp.startTime = x.startTime;
				if(temp.noResponse == 1'b0) begin
					fork
						targetSequencer.execute_item(temp);
					join_none
				end
		   end
	   
	endtask: sendRsp

    /*********************************************************************
    * Specifies the target sequencer this responder sends its responses to
    *********************************************************************/
    virtual function setTargetSequencer(CCAgentSequencer target);
        targetSequencer = target;
    endfunction: setTargetSequencer

endclass: CCAgentResponder
