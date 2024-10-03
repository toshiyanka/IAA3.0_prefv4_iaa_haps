
/****************************************************
1.	Interface for Messages
	a.	This is the driver that dirver the message interface for IOSF SBI but I think each checker should subscribe to the analysis port instead of using this interface because it might be hard to comprehend all the parameters of a message. 
	b.	This interface will be used the same as the RALInterface.
2.	Maintenance
	a.	No maintenance necessary

*****************************************************/


class MessageDriver extends ovm_driver;
	`ovm_component_utils(MessageDriver)// register component to the factory
	/*bit new_msg;
	logic[7:0] opcode;
	logic[7:0] dest_pid;
	logic[7:0] src_pid;
	*/

	virtual MessageIF msgIF;

	analysis_fifo#(iosfsbm_cm::xaction) fb_agt_monitor;
	analysis_fifo#(iosfsbm_cm::xaction) agt_fb_monitor;

	
	local iosfsbm_cm::xaction Packet_in; // Transactions from input monitor
	
	// define constructor
	function new( string name , ovm_component parent = null ); 
		super.new( name , parent );
	endfunction //new

	function void build();
		ovm_object temp;
		sla_vif_container #(virtual MessageIF) msgIFContainer;
		fb_agt_monitor= new("fb-agt Monitor Analysis FIFO"); // create analysis fifos to connect to analysis ports of interest
		agt_fb_monitor = new("agt-fb Monitor Analysis FIFO"); 
		
		
		assert(get_config_object("MsgIF", temp));		
		assert($cast(msgIFContainer, temp));
		msgIF = msgIFContainer.get_v_if();
		`ovm_info(get_type_name(), {"MsgIF"," MAPPED"}, OVM_HIGH)

		Packet_in= new;
	endfunction// build

	task run();
		fork
			fab_to_agt();
			agt_to_fab();			
		join_none
	endtask:run


	task fab_to_agt();
		forever begin
			fb_agt_monitor.get(Packet_in); 
			//ovm_report_info("Scoreboard",$psprintf("Received Packet-in = %s", Packet_in.sprint_header()));
			msgIF.opcode = Packet_in.opcode;
			msgIF.dest_pid = Packet_in.dest_pid;
			msgIF.src_pid = Packet_in.src_pid;
			msgIF.tag = Packet_in.tag;
			msgIF.new_msg = ~msgIF.new_msg;			
			
		end
	endtask:fab_to_agt

	task agt_to_fab();
		forever begin
			agt_fb_monitor.get(Packet_in); 
			msgIF.opcode = Packet_in.opcode;
		  	msgIF.dest_pid = Packet_in.dest_pid;
		  	msgIF.src_pid = Packet_in.src_pid;
			msgIF.tag = Packet_in.tag;
			msgIF.new_msg = ~msgIF.new_msg;

		end		
	endtask: agt_to_fab
endclass: MessageDriver
