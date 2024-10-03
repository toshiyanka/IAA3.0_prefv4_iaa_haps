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


class PGCBAgentSeqItem extends PowerGatingSeqItem; 

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	/*time startTime;
	rand PowerGating::Event_e cmd;
	rand int source;
	*/
	rand int delay;
	//rand int delay_fet_en;

	constraint delay_c {
		delay >= 0; delay < 20;
	}
	/*constraint delay_fet_en_c {
		delay_fet_en > 0; delay_fet_en < 20;
	
	}
	*/	
	constraint cmd_c {
		cmd inside 
		{
			//PowerGating::SIP_SAVE_REQ, 
		//PowerGating::SIP_SAVE_ABORT_REQ,
		PowerGating::SIP_PG_REQ,
		PowerGating::SIP_UG_REQ,
		PowerGating::FAB_IDLE,
		PowerGating::FAB_IDLE_EXIT,
		PowerGating::SIP_INACC_PG,
		//Alamelu POK changes
		PowerGating::VNN_REQ_DSD,
		PowerGating::VNN_REQ_ASD,
		PowerGating::SIDE_POK_ASD,
		PowerGating::SIDE_POK_DSD,
		PowerGating::PRIM_POK_ASD,
		PowerGating::PRIM_POK_DSD


	};
	}
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(PGCBAgentSeqItem)
		`ovm_field_int(delay , OVM_ALL_ON)
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
		$sformat(msg,"cmd: %08s, source: %02d, delay: %04d: delayComplete: %04d",cmd, source, delay, delayComplete);
		return msg;

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



endclass : PGCBAgentSeqItem 
