
/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================


  Author          : Alamelu Ramaswamy
  Email           : 
  Phone           : 916-377-2848
  Date            : July 18th, 2012
================================================================================
  Description     : A simple example printer class.
  
There are several ways to build tracker functionality and several advanced 
  features that can be added to a tracker. In OVM, you could build a Printer
  class within the Agent that subscribes to the analysis port of the Monitor
  (which is what was done here). You could encapsulate the printing 
  functionality, including formatting and i/o, within the monitor itself.
  You could even put the printing functionality completely outside the agent.
  
  The variables in Tracker emulation boil down to:
  	1) Who does the formatting of the string 
		(The Xaction, the monitor, or the printer)
	2) Where does the file handling reside:
		(the monitor, a special printer class per agent, or a singleton printer)
	3) Who handles ensuring that a multi-cycle transaction is done before it
	   gets printed? Who handles ordering of printing, essentially.
	        (The monitor, the printer, or some sort of interposer, like a spooler)
	4) Do you also handle printing of error messages?
	5) If so, do you support shutting off a given error message after it has
	   occured N times? (thereby preventing a disk-space issue)
	6) Do you handle multiple time formats, or are flexible with respect to them?
	7) Do you print headers and documentation pointers?
	
  I intend to build/resurrect CGPrinter with some added/optional support for spooling.
  I am also considering building a singleton printer which returns an analysis fifo pointer
    for every filehandle it opens, and launches a thread for processing transactions from that
    fifo.
================================================================================
*/
class PowerGatingPrinter extends ovm_component; // extends ovm_printer;


	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	analysis_fifo #(PowerGatingMonitorSeqItem) printQueue;  // analysis fifo that gets hooked up to the analysis_port of the Monitor.

	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
	//protected bit _spoolingEnabled;           // 1: Spooling Enabled; 0:Spooling Disabled (Default); TODO: this isn't implemented yet.
	protected string _filename;               // tracker file name; defaults to {name}_Trk.out

	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================
	local int _fileHandle;                     // no one else should need the file handle
	local int _lineCount;                      // used to determine when to print the header
	local const int HEADERCOUNT = 57;          // Arbitrary value copied from original CCTrkPrinter
	local PowerGatingConfig cfg;
	local int totalPGCB;
	local PowerGatingSIPFSM sipFSM[];
	local PowerGatingFabricFSM fabFSM[];
	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_component_utils_begin(PowerGatingPrinter)
	`ovm_component_utils_end
	


	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new (name, parent);
		
		//_filename = {_filename,".out"};
			printQueue = new({name, "PrintQueue"}, this);
		//If you were building a printer that could accept seq items from multiple sources you could either
		//  a) make separate printQueues and have some sort of arbitration scheme    OR
		//  b) just have each source monitor write to the printers analysis fifo	
	endfunction: new

	/**************************************************************************
	*  @brief : builds an analysis fifo which will be connected by the Agent to the Monitor
	**************************************************************************/
	virtual function void build();
		super.build();
	endfunction : build

	/**************************************************************************
	*  @brief : standard connect method
	**************************************************************************/
	virtual function void connect();
		super.connect();
		
		//Connection of the Printer to the Monitor is done in the Agent. Nothing to do here.
		
	endfunction : connect

    function void setCfg (PowerGatingConfig cfg_arg);
        cfg = cfg_arg;
    endfunction: setCfg

    function void setTrackerName (string name_arg);
        _filename = name_arg;
    endfunction: setTrackerName	

	function setSIPFSM(PowerGatingSIPFSM sipFSM_arg[$]);
		sipFSM = sipFSM_arg;
	endfunction: setSIPFSM
	function setFabFSM(PowerGatingFabricFSM fabFSM_arg[$]);
		fabFSM = fabFSM_arg;
	endfunction: setFabFSM

	function int getTimeDivisor();
    	time t = 1ns;
     	case (t)
           	1: return 1;  // ns
           	1000: return 1000;  // ps
          	1000000: return 1000000;  // fs
           default: `ovm_fatal(get_full_name(), "getTimeDivisor(): failed to determine time unit")
    	endcase
	endfunction: getTimeDivisor



	function void printError(string message);
		$fdisplay(_fileHandle, message);
	endfunction: printError	

	/**************************************************************************
	*  @brief : Grabs the preformatted tracker line from the sequence item and prints it to the tracker file.
	*
	*  @param itemToPrint_arg : sequence item to be printed
	**************************************************************************/
	virtual function void printToTracker(PowerGatingMonitorSeqItem x);

		string trackerLine;
		
		//If the base sequence item did not support formatting of its data, you could perform that here.
		string str, statusStr, statusStrInd;
		str = "";
		statusStr = "";
		statusStrInd = "";
	
		//col change
		if(cfg.phase == PowerGating::PHASE_1) begin
		//END col change
		if(cfg.no_sip == 0) begin
			for (int i = 0 ; i < cfg.num_sip_pgcb; i++) begin
				$sformat(statusStrInd," %05s |", sipFSM[i].state);
				statusStr = {statusStr,statusStrInd};
			end
		end
		if(cfg.no_fab == 0) begin
			for (int i = 0 ; i < cfg.num_fab_pgcb; i++) begin
				$sformat(statusStrInd," %05s |", fabFSM[i].state);
				statusStr = {statusStr,statusStrInd};
			end
		end
		end


		if(x.typ.name() == "POK") begin
	   		//POK
			$sformat(str,"|%11.1f ns| %3s | %4s | %2d |%17s |%s", x.startTime/getTimeDivisor(), x.typ.name(), x.sourceName, x.source, x.evnt.name(), statusStr); 
	   	end
	   	else if (x.typ.name() == "MSG")  begin
	   		//Reset and Others
			$sformat(str,"|%11.1f ns| %3s | %4s | %2s | %4s is in %13s state", x.startTime/getTimeDivisor(), x.typ.name(), x.sourceName, "--", x.sourceName, x.state);
		end
		
	   	else begin
	   		//Reset and Others
			$sformat(str,"|%11.1f ns| %3s | %4s | %2d |%17s |%s", x.startTime/getTimeDivisor(), x.typ.name(), x.sourceName, x.source, x.evnt.name(), statusStr);
		end
		printLine(str);
	endfunction : printToTracker

	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================

	/**************************************************************************
	*  @brief : Standard run method
	**************************************************************************/
	virtual task run();
		PowerGatingMonitorSeqItem seqItem;

	//ALAMELU - COLLAGE
		openTrackerFileForPrinting({_filename,".out"});
	
		forever begin
			printQueue.get(seqItem); //get seqItem from the analysis port that should have been connected to the monitor
			printToTracker(seqItem);
		end
		
			
	endtask : run


	//=========================================================================
	// PROTECTED FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief : opens a tracker file for printing
	*
	*  @param fileName_arg : name of the tracker file to be opened for printing
	**************************************************************************/
	protected virtual function void openTrackerFileForPrinting(string fileName_arg);
		string errorMsg;

		if (_fileHandle != 0) begin
			$sformat(errorMsg,"File was already opened! Filename: %s",fileName_arg);
			`ovm_fatal(get_full_name(), errorMsg);
		end

		// open the file for writing
		_fileHandle = $fopen(fileName_arg,"w");

		// check for success
		if (_fileHandle == 0) begin
			$sformat(errorMsg,"Could not open file: %s",fileName_arg);
			`ovm_fatal(get_full_name(), errorMsg);
		end

		if(cfg.no_sip === 1) begin
			totalPGCB = cfg.num_fab_pgcb;
		end
		else if(cfg.no_fab === 1) begin
			totalPGCB = cfg.num_sip_pgcb;
		end
		else begin
			totalPGCB = (cfg.num_fab_pgcb + cfg.num_sip_pgcb);	
		end
		// print file header and the first header as well
		printTrackerInfo();
		//printConfig();
		printHeader();
	endfunction : openTrackerFileForPrinting

	/**************************************************************************
	* Prints a tracker header
	**************************************************************************/

	local function void printHeader();

		string str, headStr, headStrInd;
		bit stateDone;

		printDivider();
		stateDone = 0;

		//col change
		if(cfg.phase == PowerGating::PHASE_1) begin
		//END col change
		for (int i = 0 ; i < totalPGCB; i++) begin
			if ((totalPGCB - i) == 1)  $sformat(headStrInd,"       |");
			else if(i == totalPGCB/2 && stateDone == 0) begin
				$sformat(headStrInd," STATE ");
				stateDone = 1;
			end
			else if(i == (totalPGCB/2 -1) && stateDone == 0) begin
				$sformat(headStrInd,"  STATE ");
				stateDone = 1;
			end
			else $sformat(headStrInd,"        ");
			headStr = {headStr,headStrInd};
		end
		end
		$sformat(str,"|              |     | NAME |    |                  |%s", headStr);
		printLine(str);
		

		headStr = "";
		//col change
		if(cfg.phase == PowerGating::PHASE_1) begin
		//END col change
		for (int i = 0 ; i < totalPGCB; i++) begin
			if ((totalPGCB - i) == 1)  $sformat(headStrInd,"       |");
			else $sformat(headStrInd,"        ");
			headStr = {headStr,headStrInd};
		end
		end
		$sformat(str,"|              |     | PGCB |    |                  |%s", headStr);
		printLine(str);
		$sformat(str,"|              |     | /IP  |SRC |                  |%s", headStr);
		printLine(str);


		headStr = "";
	//col change
	if(cfg.phase == PowerGating::PHASE_1) begin
	//END col change
	if(cfg.no_sip == 0) begin
		for (int i = 0 ; i < cfg.num_sip_pgcb; i++) begin
			$sformat(headStrInd," %05s |",cfg.cfg_sip_pgcb[i].name);
			headStr = {headStr,headStrInd};
		end
	end
	if(cfg.no_fab == 0) begin
		for (int i = 0 ; i < cfg.num_fab_pgcb; i++) begin
			if ((cfg.num_fab_pgcb - i) == 1)  $sformat(headStrInd," %05s |", cfg.cfg_fab_pgcb[i].name);
			else $sformat(headStrInd," %05s |",cfg.cfg_fab_pgcb[i].name);
			headStr = {headStr,headStrInd};
		end
	end
	end
		$sformat(str,"|     TIME     | TYP | /FET | IN |       EVENT      |%s", headStr);
		printLine(str);
		printDivider();

	endfunction: printHeader
	/**************************************************************************
	* Prints a tracker divider line
	**************************************************************************/
	local function void printDivider();
		string str, divStr, divStrInd;
		//Code to print LC header divider
	//col change
	if(cfg.phase == PowerGating::PHASE_1) begin
	//END col change
		for (int i = 0 ; i < totalPGCB; i++) begin
			$sformat(divStrInd,"========");
			divStr = {divStr,divStrInd};
		end
	end
		$sformat(str,"=====================================================%s", divStr);
		printLine(str);
	endfunction: printDivider	

	/**************************************************************************
	* Prints a header with information on the tracker.
	**************************************************************************/
	protected function void printTrackerInfo();
		string str;
		printDivider();
		$sformat(str,"Tracker(%s) : Instance(%s)", get_type_name(), get_name());
		printLine(str);
		printDivider();
	endfunction: printTrackerInfo
	//=========================================================================
	// PROTECTED TASKS
	//=========================================================================

	//=========================================================================
	// PRIVATE FUNCTIONS
	//=========================================================================
	/**************************************************************************
	* Prints a line to the tracker file
	**************************************************************************/
	local function void printLine(string line);

		//Make sure filehandle exists (file opened) then write tracker line
		if (_fileHandle != 0) begin
			// check if header needs to be printed
			if (_lineCount >= HEADERCOUNT) begin
				_lineCount = 0;
				printHeader();
			end
			$fdisplay(_fileHandle,line);
			_lineCount++;
		end else begin
			string errorMsg;
			$sformat(errorMsg,"Tried to print before opening the tracker file for writing. Filename: %s",_filename);
			`ovm_fatal(get_full_name(), errorMsg);
		end
	endfunction: printLine
	/**************************************************************************
	* Converts an int type to a string showing the same value
	**************************************************************************/
	local function string intToStr(int number);
		string retString;
		retString.itoa(number);
		return retString;
	endfunction: intToStr
	//=========================================================================
	// PRIVATE TASKS
	//=========================================================================

endclass : PowerGatingPrinter


