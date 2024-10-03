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
  
Write your wordy description here.PowerGating
================================================================================
*/


class CCAgentResponseSeqItem extends PowerGatingSeqItem; 

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================

	//rand int delay;
	rand bit noResponse;
	rand int delay_pg_ack;
	rand int delay_restore;
	rand int delay_restore_ack; 
	rand int delay_ug_ack;
	rand int delay_fab_ug_req;
	rand int delay_fet_en;
	rand int delay_fet_dis;
	rand int delay_vnn_ack; 

	constraint noResponse_c { 
		noResponse == 0; 
	}
	constraint delay_pg_ack_c { 
		//delay_pg_ack >= 0; delay_pg_ack < 6;
		delay_pg_ack dist {
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}
	constraint delay_vnn_ack_c { 
		delay_vnn_ack dist {
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}

	constraint delay_restore_c {
		delay_restore dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}
		
	constraint delay_restore_ack_c {
		delay_restore_ack dist{
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}

			
	constraint delay_ug_ack_c { 
		//delay_ug_ack >= 0; delay_ug_ack < 6;
		delay_ug_ack dist {
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}

	
	constraint delay_fab_ug_req_c { 
		//delay_fab_ug_req >= 0; delay_fab_ug_req < 6;
		delay_fab_ug_req dist {
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};
		}


		
	constraint delay_fet_en_c { 
		//delay_fet_en >= 0; delay_fet_en < 6;
		delay_fet_en dist {
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};

		}	
	constraint delay_fet_dis_c { 
		//delay_fet_dis >= 0; delay_fet_dis < 6;
		delay_fet_dis dist {
		[0:1] 		:/ 10,
		[2:10] 		:/ 80,
		[11:1000] 	:/ 10};

		}	
	
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(CCAgentResponseSeqItem)
		//`ovm_field_int(delay , OVM_ALL_ON)
		`ovm_field_int(noResponse , OVM_ALL_ON)
        `ovm_field_int( delay_pg_ack , OVM_ALL_ON)
        `ovm_field_int( delay_vnn_ack , OVM_ALL_ON)

        `ovm_field_int( delay_restore , OVM_ALL_ON) 


        `ovm_field_int( delay_restore_ack , OVM_ALL_ON) 
        `ovm_field_int( delay_ug_ack , OVM_ALL_ON)
        `ovm_field_int( delay_fab_ug_req , OVM_ALL_ON)
        `ovm_field_int( delay_fet_en , OVM_ALL_ON)
        `ovm_field_int( delay_fet_dis , OVM_ALL_ON)
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
	function new(string name="CCAgentXaction");
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
	/*virtual task waitForComplete(time timeout = 0);
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
	*/

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



endclass : CCAgentResponseSeqItem 
