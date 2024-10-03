class TestScoreboard extends ovm_scoreboard;
	`ovm_component_utils(TestScoreboard)// register component to the factory

	analysis_fifo#(PowerGatingMonitorSeqItem) monitor;

	
	local PowerGatingMonitorSeqItem Packet_in; // Transactions from input monitor
	
	// define constructor
	function new( string name , ovm_component parent = null ); 
		super.new( name , parent );
	endfunction //new

	function void build();
		ovm_object temp;
		monitor= new("power FIFO"); // create analysis fifos to connect to analysis ports of interes
		Packet_in= new;
	endfunction// build

	task run();
		forever begin
			string str1, str2;
			monitor.get(Packet_in);
			$sformat(str1,"TYP = %3s, EVENT = %10s, SOURCE_NAME = %4s, STATE = %5s", Packet_in.typ, Packet_in.evnt, Packet_in.sourceName, Packet_in.state);
			str1 = Packet_in.toString();
			//print it out
			ovm_report_info(get_full_name(), {" \n SCOREBOARD TRANSACTION: ", str1});
			//$display({"SCOREBOARD TRANSACTION:  ", str1});
		end
	endtask:run


endclass: TestScoreboard
