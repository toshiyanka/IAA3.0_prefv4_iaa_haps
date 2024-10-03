interface ReadIF;
	parameter int NUM_SIP = 32;
	parameter int NUM_FAB = 32;
	parameter int NUM_FET = 32;
	parameter int NUM_SW_ENT = 32;
	logic[NUM_SIP-1:0] pmc_ip_sw_pg_req_b;

	logic[NUM_SIP-1:0] ip_pmc_save_req_b;
	logic[NUM_SIP-1:0] pmc_ip_save_ack_b;	
	logic[NUM_SIP-1:0] ip_pmc_pg_req_b;
	logic[NUM_SIP-1:0] pmc_ip_pg_ack_b;
	logic[NUM_SIP-1:0] pmc_ip_pg_wake;

	//Is this needed??
	logic[NUM_SIP-1:0] ip_fabric_pok;

	logic[NUM_FAB-1:0] fab_pmc_idle;
	logic[NUM_FAB-1:0] pmc_fab_pg_req;
	logic[NUM_FAB-1:0] fab_pmc_pg_ack;
	logic[NUM_FAB-1:0] fab_pmc_pg_nack;
	//logic fab_fet_en_b[NUM_FAB-1:0];

	logic[NUM_FET-1:0] fet_en_b;
	logic[NUM_FET-1:0] fet_en_ack_b[NUM_FET-1:0];


endinterface: ReadIF
