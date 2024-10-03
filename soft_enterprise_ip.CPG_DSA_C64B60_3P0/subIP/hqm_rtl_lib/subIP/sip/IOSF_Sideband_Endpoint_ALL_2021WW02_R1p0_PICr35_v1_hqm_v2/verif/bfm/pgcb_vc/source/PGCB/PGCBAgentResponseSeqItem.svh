/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : 
  Email           : 
  Phone           : 
  Date            : 

================================================================================
  Description     : One line description of this class
  
Write your wordy description here.
================================================================================
*/


class PGCBAgentResponseSeqItem extends PowerGatingSeqItem; 

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================

	//rand int delay;
	rand bit noResponse;
	rand int delay_ug_req ;
	rand int delay_pg_req;
	rand int delay_fab_pg_ack;
	rand int delay_fab_nack;
	rand int delay_fab_ug_ack;
	rand int delay_fet_en_ack;
	rand bit send_fab_nack;

	constraint noResponse_c { 
		noResponse == 0; 
	}
	
	constraint delay_ug_req_c {
		delay_ug_req dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}	
	constraint delay_pg_req_c {
		delay_pg_req dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}	
	constraint delay_fab_pg_ack_c {
		delay_fab_pg_ack dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}
	constraint delay_fab_nack_c {
		delay_fab_nack dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}
	constraint delay_fab_ug_ack_c {
		delay_fab_ug_ack dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}
	constraint delay_fet_en_ack_c {
		delay_fet_en_ack dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}
	constraint send_fab_nack_c {
		send_fab_nack dist{
		[0:0] 		:/ 70,
		[1:1] 		:/ 30};
		}

	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(PGCBAgentResponseSeqItem)
		//`ovm_field_int(delay , OVM_ALL_ON)
		`ovm_field_int(noResponse , OVM_ALL_ON)
	`ovm_object_utils_end


	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
	protected bit complete = 0;

	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================

	
	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name="PGCBAgentXaction");
		super.new(name);
	endfunction : new

	/**************************************************************************
	*  @brief : marks the seq item complete.
	**************************************************************************/
	virtual function void setComplete();
		complete = 1;
	endfunction : setComplete

	/**************************************************************************
	*  @brief : description of what this method does
	**************************************************************************/
	virtual function string toString();
		string msg;		
		$sformat(msg,"start: %t, cmd: %08s, num: %02d",startTime, cmd, source);

	endfunction : toString


	/**************************************************************************
	*  @brief : description of what this method does
	**************************************************************************/
	virtual function string toTrackerLine();
		string msg;		
		$sformat(msg,"start: %t, cmd: %08s, num: %02d",startTime, cmd, source);

	endfunction : toTrackerLine


	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================

	/**************************************************************************
	*  @brief : Wait for Complete bit to be set, with optional timeout. Fatal if timeout triggers.
	**************************************************************************/
	virtual task waitForComplete(time timeout = 0);
	        if (timeout > 0) begin
	            fork
	                #timeout;
	                wait(complete);
	            join_any;
	            disable fork;
		    if (!complete) begin
			`ovm_fatal(get_full_name(),"WaitForComplete timeout triggered. Triggering fatal to prevent test hang.");
		    end
	        end else begin
	            wait(complete);
	        end
	endtask: waitForComplete

	//=========================================================================
	// PROTECTED FUNCTIONS
	//=========================================================================

	//=========================================================================
	// PROTECTED TASKS
	//=========================================================================





	//=========================================================================
	// PRIVATE FUNCTIONS
	//=========================================================================


	

	//=========================================================================
	// PRIVATE TASKS
	//=========================================================================



endclass : PGCBAgentResponseSeqItem 
