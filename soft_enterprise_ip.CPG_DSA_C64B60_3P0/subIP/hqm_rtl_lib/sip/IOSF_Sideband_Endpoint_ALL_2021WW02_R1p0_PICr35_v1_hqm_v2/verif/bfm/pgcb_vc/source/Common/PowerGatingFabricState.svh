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


class PowerGatingFabricState extends ovm_sequence_item; 

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	time startTime;
	rand PowerGating::FabricState state;
	rand int source;

	constraint source_c {
		source >= 0; source < 128;
		}

	
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_object_utils_begin(PowerGatingFabricState)
		`ovm_field_int(state , OVM_ALL_ON)
		`ovm_field_int(source , OVM_ALL_ON)
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
	function new(string name = "PowerGatingFabricState");
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
		$sformat(msg,"start: %t, state: %08s",startTime, state);

	endfunction : toString


	/**************************************************************************
	*  @brief : description of what this method does
	**************************************************************************/
	virtual function string toTrackerLine();
		string msg;		
		$sformat(msg,"start: %t, state: %08s",startTime, state);


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


endclass : PowerGatingFabricState 
