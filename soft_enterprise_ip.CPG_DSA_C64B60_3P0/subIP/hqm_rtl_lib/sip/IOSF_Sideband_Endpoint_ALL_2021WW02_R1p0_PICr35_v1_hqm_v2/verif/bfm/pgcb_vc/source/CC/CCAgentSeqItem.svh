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


class CCAgentSeqItem extends PowerGatingSeqItem; 

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================

	rand int delay;

	constraint delay_c {
		delay >= 0; delay < 20;
	}

	constraint cmd_c {
		cmd inside 
		{PowerGating::SW_PG_REQ, 
		PowerGating::DEASSERT_SW_PG_REQ, 
		PowerGating::PMC_SIP_WAKE,
		PowerGating::FAB_PG_REQ,
		PowerGating::FAB_UG_REQ,
		PowerGating::PMC_SIP_WAKE_ALL,
		PowerGating::SET_FET_ON_MODE,
		PowerGating::RESET_FET_ON_MODE,
		PowerGating::DEASSERT_PMC_SIP_WAKE,
		PowerGating::DEASSERT_PMC_SIP_WAKE_ALL,
		PowerGating::SIP_RESTORE_NEXT_WAKE,
		PowerGating::DEASSERT_SIP_RESTORE,
		PowerGating::SIP_RESTORE,
		PowerGating::FDFX_BYPASS_ASD,
		PowerGating::FDFX_BYPASS_DSD,
		PowerGating::FDFX_OVR_ASD,
		PowerGating::FDFX_OVR_DSD,
		PowerGating::VNN_ACK_DSD,
		PowerGating::VNN_ACK_ASD,
		PowerGating::VNN_REQ_DSD,
		PowerGating::VNN_REQ_ASD,
		PowerGating::SIDE_RST_DSD,
		PowerGating::SIDE_RST_ASD,
		PowerGating::PRIM_RST_DSD,
		PowerGating::PRIM_RST_ASD		
	};
	}
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(CCAgentSeqItem)
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
		$sformat(msg,"cmd: %08s, source: %02d, delay: %04d: delayComplete: %04d", cmd, source, delay, delayComplete);
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



endclass : CCAgentSeqItem 
