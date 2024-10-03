
interface PowerGatingResetIF;
	logic clk;
	logic reset_b;
endinterface

interface PowerGatingSIPIF;
	parameter int NUM_SIDE 	= 1;
	parameter int NUM_PRIM 	= 1;
	parameter int NUM_D3 	= 1;
	parameter int NUM_D0I3	= 1;
	parameter int NUM_VNN_ACK_REQ	= 1;

	logic clk;
	logic reset_b;
	logic pmc_ip_sw_pg_req_b;
	logic ip_pmc_pg_req_b;
   	logic pmc_ip_pg_ack_b;
	logic pmc_ip_restore_b;
	logic pmc_ip_pg_wake;
	logic[NUM_SIDE-1:0] side_pok;
	logic[NUM_PRIM-1:0] prim_pok;
	logic[NUM_SIDE-1:0] side_rst_b;
	logic[NUM_VNN_ACK_REQ-1:0] pmc_ip_vnn_ack;
	logic[NUM_VNN_ACK_REQ-1:0] ip_pmc_vnn_req;
	logic[NUM_PRIM-1:0] prim_rst_b;	
	logic[NUM_D3-1:0] ip_pmc_d3;
	logic[NUM_D0I3-1:0] ip_pmc_d0i3;

	logic fdfx_pgcb_bypass;
	logic fdfx_pgcb_ovr;
	logic jtag_tck;

	logic restore_next_wake;

	logic fet_en_b;
	logic fet_en_ack_b;

/*	time t1;
	//TODO: remove this
	//sequence s1(time t1);
	//local variable passing is not supported in VCS. So cannot use sequence.
	always @(posedge ip_pmc_pg_req_b iff reset_b === 1) begin
		if(ip_pmc_pg_req_b === 1)  t1 = $time;
		//##1 ($rose(pmc_ip_pg_ack_b) [->1]) ##1 pmc_ip_pg_ack_b; 
	end
	//sequence
	property p1;
		@(posedge clk) disable iff(reset_b !== 1) $rose(pmc_ip_pg_ack_b) |-> $time-t1 < 20us;
		//ip_pmc_pg_req_b ##[0:$] ($rose(pmc_ip_pg_ack_b) [->1]) ##1 $time-t1 < 2ns; 
	endproperty

	max_hs: assert property (p1) else $display("OVM_ERROR: Max handshake failed");
*/
/*	max_hs: assert property (
		@(posedge clk) 
		disable iff(reset_b === 0 || $fell(ip_pmc_pg_req_b)) 
		($rose(ip_pmc_pg_req_b), t1 = $time) 
		|-> 
			(##[0:200000] $rose(pmc_ip_pg_ack_b), t2 = $time) 
		|-> 
			t2-t1 < 2ns	
	) else $display("OVM_ERROR: Max handshake failed");
*/
endinterface: PowerGatingSIPIF


interface PowerGatingFabricIF;
	logic clk;
	logic reset_b;
	logic fab_pmc_idle;
	logic pmc_fab_pg_rdy_req_b;
	logic fab_pmc_pg_rdy_ack_b;
	logic fab_pmc_pg_rdy_nack_b;
endinterface: PowerGatingFabricIF

