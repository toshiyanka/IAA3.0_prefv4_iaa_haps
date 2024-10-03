class PGCBAgentFabricResponder extends ovm_component;

	analysis_fifo #(PowerGatingMonitorSeqItem) monitor_i;

	PowerGatingMonitorSeqItem x;
	PGCBAgentSequencer targetSequencer;

   `ovm_component_utils(PGCBAgentFabricResponder)

	function new(string name, ovm_component parent);        
  		//parent constructor
 		super.new(name, parent);
		monitor_i = new({name,"monitor_i"});		
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
			PGCBAgentResponseSeqItem temp;
		   if(x.state == PowerGating::ACKEX) begin
				temp = PGCBAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::FAB_PG_ACK_DSD;
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
		   if(x.state == PowerGating::ACKID) begin
				temp = PGCBAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::FAB_PG_ACK;
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
		   if(x.state == PowerGating::NACK1) begin
				temp = PGCBAgentResponseSeqItem::type_id::create("responsex");
				temp.randomize();
				temp.cmd = PowerGating::FAB_PG_NACK_DSD;
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
    virtual function setTargetSequencer(PGCBAgentSequencer target);
        targetSequencer = target;
    endfunction: setTargetSequencer

endclass: PGCBAgentFabricResponder
