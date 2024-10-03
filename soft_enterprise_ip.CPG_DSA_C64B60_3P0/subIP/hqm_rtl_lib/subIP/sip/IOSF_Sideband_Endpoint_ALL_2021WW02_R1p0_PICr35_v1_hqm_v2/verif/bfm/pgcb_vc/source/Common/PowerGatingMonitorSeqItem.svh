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


class PowerGatingMonitorSeqItem extends ovm_sequence_item; 

	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	time startTime;
	PowerGating::Event_e evnt;
	PowerGating::Cycle typ;
	PowerGating::MonitorState state;
	int source;
	string sourceName;
	int fabricIndex;

	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================

	`ovm_object_utils_begin(PowerGatingMonitorSeqItem)
	`ovm_object_utils_end
	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================

	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================

	
	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name = "PowerGatingMonitorSeqItem");
		super.new(name);
	endfunction : new



	/**************************************************************************
	*  @brief : description of what this method does
	**************************************************************************/
	virtual function string toString();
		//string msg;		
		//$sformat(msg,"start: %t, state: %08s",startTime, state);
		//If the base sequence item did not support formatting of its data, you could perform that here.
		string str;
		str = "";


		if(this.typ.name() == "POK") begin
	   		//POK
			$sformat(str,"| time = %11.1f ns| cycle = %3s | name = %4s | index = %2d | event = %17s |", this.startTime/getTimeDivisor(), this.typ.name(), this.sourceName, this.source, this.evnt.name()); 
	   	end
	   	else if (this.typ.name() == "MSG")  begin
	   		//Reset and Others
			$sformat(str,"| time = %11.1f ns| cycle = %3s | name = %4s | index = %2s | %4s is in %13s state", this.startTime/getTimeDivisor(), this.typ.name(), this.sourceName, "--", this.sourceName, this.state);
		end
		
	   	else begin
	   		//Reset and Others
			$sformat(str,"| time = %11.1f ns| cycle = %3s | name = %4s | index = %2d | event = %17s |", this.startTime/getTimeDivisor(), this.typ.name(), this.sourceName, this.source, this.evnt.name());
		end
		return(str);
	endfunction : toString
	/**************************************************************************
	*  @brief : description of what this method does
	**************************************************************************/
	function int getTimeDivisor();
    	time t = 1ns;
     	case (t)
           	1: return 1;  // ns
           	1000: return 1000;  // ps
          	1000000: return 1000000;  // fs
           default: `ovm_fatal(get_full_name(), "getTimeDivisor(): failed to determine time unit")
    	endcase
	endfunction: getTimeDivisor
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


endclass : PowerGatingMonitorSeqItem 
