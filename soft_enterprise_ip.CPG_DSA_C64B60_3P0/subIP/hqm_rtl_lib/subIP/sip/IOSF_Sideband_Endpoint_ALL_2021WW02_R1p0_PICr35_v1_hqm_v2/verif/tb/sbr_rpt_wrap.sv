
module sbr_rpt_wrap
    #(
        parameter PAYLOAD_WIDTH = 8,
        parameter NUM_RPT = 1
    )
    (
	   input logic 			    mnpput_agt,
	   input logic 			    mpcput_agt,
	   output logic 		    mnpcup_agt,
	   output logic 		    mpccup_agt,
	   input logic 			    meom_agt,
	   input logic [PAYLOAD_WIDTH-1:0]  mpayload_agt,
	   
	   output logic 		    tnpput_agt,
	   output logic 		    tpcput_agt,
	   input logic 			    tnpcup_agt,
	   input logic 			    tpccup_agt,
	   output logic 		    teom_agt,
	   output logic [PAYLOAD_WIDTH-1:0] tpayload_agt,
	   
	   input logic [2:0] 		    side_ism_agent_agt,
	   output logic [2:0] 		    side_ism_fabric_agt,
	   input logic 			    pok_agt,
	   
	  // Between repeater and router
	  //
	   output logic 		    mnpput_rtr,
	   output logic 		    mpcput_rtr,
	   input logic 			    mnpcup_rtr,
	   input logic 			    mpccup_rtr,
	   output logic 		    meom_rtr,
	   output logic [PAYLOAD_WIDTH-1:0] mpayload_rtr,
	   
	   
	   input logic 			    tnpput_rtr,
	   input logic 			    tpcput_rtr,
	   output logic 		    tnpcup_rtr,
	   output logic 		    tpccup_rtr,
	   input logic 			    teom_rtr,
	   input logic [PAYLOAD_WIDTH-1:0]  tpayload_rtr,
	   
	   output logic [2:0] 		    side_ism_agent_rtr,
	   input logic [2:0] 		    side_ism_fabric_rtr,
	   output logic 		    pok_rtr,
	
	   input logic 			    clk
    );

	logic	mnpput_loc_agt[NUM_RPT+1];
	logic	mpcput_loc_agt[NUM_RPT+1];
	logic	mnpcup_loc_agt[NUM_RPT+1];
	logic	mpccup_loc_agt[NUM_RPT+1];
	logic	meom_loc_agt[NUM_RPT+1];
	logic[PAYLOAD_WIDTH-1:0]	mpayload_loc_agt[NUM_RPT+1];
			
	logic	tnpput_loc_agt[NUM_RPT+1];
	logic	tpcput_loc_agt[NUM_RPT+1];
	logic	tnpcup_loc_agt[NUM_RPT+1];
	logic	tpccup_loc_agt[NUM_RPT+1];
	logic	teom_loc_agt[NUM_RPT+1];
	logic[PAYLOAD_WIDTH-1:0]	tpayload_loc_agt[NUM_RPT+1];
			
	logic[2:0]	side_ism_agent_loc_agt[NUM_RPT+1];
	logic[2:0]	side_ism_fabric_loc_agt[NUM_RPT+1];
	logic	pok_loc_agt[NUM_RPT+1];
			
	
	logic	mnpput_loc_rtr[NUM_RPT+1];
	logic	mpcput_loc_rtr[NUM_RPT+1];
	logic	mnpcup_loc_rtr[NUM_RPT+1];
	logic	mpccup_loc_rtr[NUM_RPT+1];
	logic	meom_loc_rtr[NUM_RPT+1];
	logic[PAYLOAD_WIDTH-1:0]	mpayload_loc_rtr[NUM_RPT+1];
			
	logic	tnpput_loc_rtr[NUM_RPT+1];
	logic	tpcput_loc_rtr[NUM_RPT+1];
	logic	tnpcup_loc_rtr[NUM_RPT+1];
	logic	tpccup_loc_rtr[NUM_RPT+1];
	logic	teom_loc_rtr[NUM_RPT+1];
	logic[PAYLOAD_WIDTH-1:0]	tpayload_loc_rtr[NUM_RPT+1];
			
	logic[2:0]	side_ism_agent_loc_rtr[NUM_RPT+1];
	logic[2:0]	side_ism_fabric_loc_rtr[NUM_RPT+1];
	logic	pok_loc_rtr[NUM_RPT+1];
    genvar  loop;

//tie up inputs
	assign mnpput_loc_agt[NUM_RPT] = mnpput_agt;
	assign mpcput_loc_agt[NUM_RPT] = mpcput_agt;
	assign meom_loc_agt[NUM_RPT] = meom_agt;
	assign mpayload_loc_agt[NUM_RPT] = mpayload_agt;
	assign tnpcup_loc_agt[NUM_RPT] = tnpcup_agt;
	assign tpccup_loc_agt[NUM_RPT] = tpccup_agt;
	assign side_ism_agent_loc_agt[NUM_RPT] = side_ism_agent_agt;
	assign pok_loc_agt[NUM_RPT] = pok_agt;

	assign mnpcup_loc_rtr[0] = mnpcup_rtr;
	assign mpccup_loc_rtr[0] = mpccup_rtr;
	assign tnpput_loc_rtr[0] = tnpput_rtr;
	assign tpcput_loc_rtr[0] = tpcput_rtr;
	assign teom_loc_rtr[0] = teom_rtr;
	assign tpayload_loc_rtr[0] = tpayload_rtr;
	assign side_ism_fabric_loc_rtr[0] = side_ism_fabric_rtr;

//tie up outputs
	assign mnpcup_agt = mnpcup_loc_agt[NUM_RPT];
	assign mpccup_agt = mpccup_loc_agt[NUM_RPT];
	assign tnpput_agt = tnpput_loc_agt[NUM_RPT];
	assign tpcput_agt = tpcput_loc_agt[NUM_RPT];
	assign teom_agt = teom_loc_agt[NUM_RPT];
	assign tpayload_agt = tpayload_loc_agt[NUM_RPT];
	assign side_ism_fabric_agt = side_ism_fabric_loc_agt[NUM_RPT];

	assign mnpput_rtr = mnpput_loc_rtr[0];
	assign mpcput_rtr = mpcput_loc_rtr[0];
	assign meom_rtr = meom_loc_rtr[0];
	assign mpayload_rtr = mpayload_loc_rtr[0];
	assign tnpcup_rtr = tnpcup_loc_rtr[0];
	assign tpccup_rtr = tpccup_loc_rtr[0];
	assign side_ism_agent_rtr = side_ism_agent_loc_rtr[0];
	assign pok_rtr = pok_loc_rtr[0];

    generate
        for( loop = 0 ; loop < NUM_RPT ; loop++) begin
            sbr_rpt #(
                .PAYLOAD_WIDTH(PAYLOAD_WIDTH)
            )
            i_sbr_rpt(
                .clk(clk),
                .mnpput_agt(mnpput_loc_agt[loop+1]),
                .mpcput_agt(mpcput_loc_agt[loop+1]),
                .mnpcup_agt(mnpcup_loc_agt[loop+1]),
                .mpccup_agt(mpccup_loc_agt[loop+1]),
                .meom_agt(meom_loc_agt[loop+1]),
                .mpayload_agt(mpayload_loc_agt[loop+1]),
                .tnpput_agt(tnpput_loc_agt[loop+1]),
                .tpcput_agt(tpcput_loc_agt[loop+1]),
                .tnpcup_agt(tnpcup_loc_agt[loop+1]),
                .tpccup_agt(tpccup_loc_agt[loop+1]),
                .teom_agt(teom_loc_agt[loop+1]),
                .tpayload_agt(tpayload_loc_agt[loop+1]),
                .side_ism_agent_agt(side_ism_agent_loc_agt[loop+1]),
                .side_ism_fabric_agt(side_ism_fabric_loc_agt[loop+1]),
                .pok_agt(pok_loc_agt[loop+1]),
				.mnpput_rtr(mnpput_loc_rtr[loop]),
				.mpcput_rtr(mpcput_loc_rtr[loop]),
				.mnpcup_rtr(mnpcup_loc_rtr[loop]),
				.mpccup_rtr(mpccup_loc_rtr[loop]),
				.meom_rtr(meom_loc_rtr[loop]),
				.mpayload_rtr(mpayload_loc_rtr[loop]),
				.tnpput_rtr(tnpput_loc_rtr[loop]),
				.tpcput_rtr(tpcput_loc_rtr[loop]),
				.tnpcup_rtr(tnpcup_loc_rtr[loop]),
				.tpccup_rtr(tpccup_loc_rtr[loop]),
				.teom_rtr(teom_loc_rtr[loop]),
				.tpayload_rtr(tpayload_loc_rtr[loop]),
				.side_ism_agent_rtr(side_ism_agent_loc_rtr[loop]),
				.side_ism_fabric_rtr(side_ism_fabric_loc_rtr[loop]),
				.pok_rtr(pok_loc_rtr[loop])
            );
            if(loop > 0) begin
                assign mnpput_loc_agt[loop] = mnpput_loc_rtr[loop];
                assign mpcput_loc_agt[loop] = mpcput_loc_rtr[loop];
                assign mnpcup_loc_rtr[loop] = mnpcup_loc_agt[loop];
                assign mpccup_loc_rtr[loop] = mpccup_loc_agt[loop];
                assign meom_loc_agt[loop] = meom_loc_rtr[loop];
                assign mpayload_loc_agt[loop] = mpayload_loc_rtr[loop];
                assign tnpput_loc_rtr[loop] = tnpput_loc_agt[loop];
                assign tpcput_loc_rtr[loop] = tpcput_loc_agt[loop];
                assign tnpcup_loc_agt[loop] = tnpcup_loc_rtr[loop];
                assign tpccup_loc_agt[loop] = tpccup_loc_rtr[loop];
                assign teom_loc_rtr[loop] = teom_loc_agt[loop];
                assign tpayload_loc_rtr[loop] = tpayload_loc_agt[loop];
                assign side_ism_agent_loc_agt[loop] = side_ism_agent_loc_rtr[loop];
                assign side_ism_fabric_loc_rtr[loop] = side_ism_fabric_loc_agt[loop];
                assign pok_loc_agt[loop] = pok_loc_rtr[loop];
            end
        end
    endgenerate
endmodule

