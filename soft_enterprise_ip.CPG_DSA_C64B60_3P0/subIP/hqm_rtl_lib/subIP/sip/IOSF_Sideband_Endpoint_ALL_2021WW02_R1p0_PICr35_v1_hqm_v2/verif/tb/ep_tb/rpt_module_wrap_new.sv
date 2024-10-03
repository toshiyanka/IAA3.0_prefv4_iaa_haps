module rpt_module_wrap
#(
parameter INTERNALPLDBIT = 31,
parameter MOD_NAME = 0,
parameter SPLIT_COMBO = 0,
parameter NUM_REPEATER_FLOPS = 0)
(
	mmsg_pcirdy_ep,
	mmsg_npirdy_ep,
    mmsg_pcparity_ep,
	mmsg_npparity_ep,
	mmsg_pceom_ep,
	mmsg_npeom_ep,
	mmsg_pcpayload_ep,
	mmsg_nppayload_ep,
	mmsg_pctrdy_ep,
	mmsg_nptrdy_ep,
	mmsg_pcmsgip_ep,
	mmsg_npmsgip_ep,
	mmsg_pcsel_ep,
	mmsg_npsel_ep,

	tmsg_pcfree_ep,
	tmsg_npfree_ep,
	tmsg_npclaim_ep,
	tmsg_pcput_ep,
	tmsg_npput_ep,
    tmsg_pcparity_ep,
    tmsg_npparity_ep,
	tmsg_pcmsgip_ep,
	tmsg_npmsgip_ep,
	tmsg_pceom_ep,
	tmsg_npeom_ep,

	tmsg_pcpayload_ep,
	tmsg_nppayload_ep,

	tmsg_pccmpl_ep,
	tmsg_npvalid_ep,
	tmsg_pcvalid_ep,

	mmsg_pcirdy_ip,
	mmsg_npirdy_ip,
    mmsg_pcparity_ip,
	mmsg_npparity_ip,
	mmsg_pceom_ip,
	mmsg_npeom_ip,
	mmsg_pcpayload_ip,
	mmsg_nppayload_ip,
	mmsg_pctrdy_ip,
	mmsg_nptrdy_ip,
	mmsg_pcmsgip_ip,
	mmsg_npmsgip_ip,
	mmsg_pcsel_ip,
	mmsg_npsel_ip,

	tmsg_pcfree_ip,
	tmsg_npfree_ip,
	tmsg_npclaim_ip,
	tmsg_pcput_ip,
	tmsg_npput_ip,
    tmsg_pcparity_ip,
    tmsg_npparity_ip,
	tmsg_pcmsgip_ip,
	tmsg_npmsgip_ip,
	tmsg_pceom_ip,
	tmsg_npeom_ip,

	tmsg_pcpayload_ip,
	tmsg_nppayload_ip,

	tmsg_pccmpl_ip,
	tmsg_npvalid_ip,
	tmsg_pcvalid_ip,
    clk,
    rst
);

	 output logic 	mmsg_pcirdy_ep;
	 output logic 	mmsg_npirdy_ep;
     output logic 	mmsg_pcparity_ep;
	 output logic 	mmsg_npparity_ep;
	 output logic 	mmsg_pceom_ep;
	 output logic 	mmsg_npeom_ep;
	 output logic [INTERNALPLDBIT:0]	mmsg_pcpayload_ep;
	 output logic [INTERNALPLDBIT:0]	mmsg_nppayload_ep;
	 output logic 	mmsg_pctrdy_ip;
	 output logic 	mmsg_nptrdy_ip;
	 output logic 	mmsg_pcmsgip_ip;
	 output logic 	mmsg_npmsgip_ip;
	 output logic 	mmsg_pcsel_ip;
	 output logic 	mmsg_npsel_ip;

	 output logic 	tmsg_pcfree_ep;
	 output logic 	tmsg_npfree_ep;
	 output logic 	tmsg_npclaim_ep;
	 output logic 	tmsg_pcput_ip;
	 output logic 	tmsg_npput_ip;
     output logic 	tmsg_pcparity_ip;
     output logic 	tmsg_npparity_ip;
	 output logic 	tmsg_pcmsgip_ip;
	 output logic 	tmsg_npmsgip_ip;
	 output logic 	tmsg_pceom_ip;
	 output logic 	tmsg_npeom_ip;
	 output logic [INTERNALPLDBIT:0]	tmsg_pcpayload_ip;
	 output logic [INTERNALPLDBIT:0]	tmsg_nppayload_ip;
	 output logic 	tmsg_pccmpl_ip;
	 output logic 	tmsg_npvalid_ip;
	 output logic 	tmsg_pcvalid_ip;

	 input logic 	mmsg_pctrdy_ep;
	 input logic 	mmsg_nptrdy_ep;
	 input logic 	mmsg_pcmsgip_ep;
	 input logic 	mmsg_npmsgip_ep;
	 input logic 	mmsg_pcsel_ep;
	 input logic 	mmsg_npsel_ep;
	 input logic 	mmsg_pcirdy_ip;
	 input logic 	mmsg_npirdy_ip;
     input logic 	mmsg_pcparity_ip;
	 input logic 	mmsg_npparity_ip;
	 input logic 	mmsg_pceom_ip;
	 input logic 	mmsg_npeom_ip;
	 input logic [INTERNALPLDBIT:0]	mmsg_pcpayload_ip;
	 input logic [INTERNALPLDBIT:0]	mmsg_nppayload_ip;

	 input logic 	tmsg_pcput_ep;
	 input logic 	tmsg_npput_ep;
     input logic 	tmsg_pcparity_ep;
     input logic 	tmsg_npparity_ep;
	 input logic 	tmsg_pcmsgip_ep;
	 input logic 	tmsg_npmsgip_ep;
	 input logic 	tmsg_pceom_ep;
	 input logic 	tmsg_npeom_ep;
	 input logic [INTERNALPLDBIT:0]	tmsg_pcpayload_ep;
	 input logic [INTERNALPLDBIT:0]	tmsg_nppayload_ep;
	 input logic 	tmsg_pccmpl_ep;
	 input logic 	tmsg_npvalid_ep;
	 input logic 	tmsg_pcvalid_ep;
	 input logic 	tmsg_pcfree_ip;
	 input logic 	tmsg_npfree_ip;
	 input logic 	tmsg_npclaim_ip;
     input logic    clk;
     input logic    rst;

	 logic 	mmsg_pcirdy_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npirdy_loc_ep [NUM_REPEATER_FLOPS+1];
     logic 	mmsg_pcparity_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npparity_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pceom_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npeom_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	mmsg_pcpayload_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	mmsg_nppayload_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pctrdy_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_nptrdy_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pcmsgip_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npmsgip_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pcsel_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npsel_loc_ip [NUM_REPEATER_FLOPS+1];

	 logic 	tmsg_pcfree_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npfree_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npclaim_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pcput_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npput_loc_ip [NUM_REPEATER_FLOPS+1];
     logic 	tmsg_pcparity_loc_ip [NUM_REPEATER_FLOPS+1];
     logic 	tmsg_npparity_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pcmsgip_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npmsgip_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pceom_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npeom_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	tmsg_pcpayload_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	tmsg_nppayload_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pccmpl_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npvalid_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pcvalid_loc_ip [NUM_REPEATER_FLOPS+1];

	 logic 	mmsg_pctrdy_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_nptrdy_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pcmsgip_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npmsgip_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pcsel_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npsel_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pcirdy_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npirdy_loc_ip [NUM_REPEATER_FLOPS+1];
     logic 	mmsg_pcparity_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npparity_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_pceom_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	mmsg_npeom_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	mmsg_pcpayload_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	mmsg_nppayload_loc_ip [NUM_REPEATER_FLOPS+1];

	 logic 	tmsg_pcput_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npput_loc_ep [NUM_REPEATER_FLOPS+1];
     logic 	tmsg_pcparity_loc_ep [NUM_REPEATER_FLOPS+1];
     logic 	tmsg_npparity_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pcmsgip_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npmsgip_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pceom_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npeom_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	tmsg_pcpayload_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic [INTERNALPLDBIT:0]	tmsg_nppayload_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pccmpl_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npvalid_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pcvalid_loc_ep [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_pcfree_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npfree_loc_ip [NUM_REPEATER_FLOPS+1];
	 logic 	tmsg_npclaim_loc_ip [NUM_REPEATER_FLOPS+1];
     genvar loop;
//input tie up
assign 	mmsg_pctrdy_loc_ep[0] 	= 	mmsg_pctrdy_ep;
assign 	mmsg_nptrdy_loc_ep[0] 	= 	mmsg_nptrdy_ep;
assign 	mmsg_pcmsgip_loc_ep[0] 	= 	mmsg_pcmsgip_ep;
assign 	mmsg_npmsgip_loc_ep[0] 	= 	mmsg_npmsgip_ep;
assign 	mmsg_pcsel_loc_ep[0] 	= 	mmsg_pcsel_ep;
assign 	mmsg_npsel_loc_ep[0] 	= 	mmsg_npsel_ep;
assign  mmsg_pcirdy_loc_ip[NUM_REPEATER_FLOPS] 	=     mmsg_pcirdy_ip;
assign 	mmsg_npirdy_loc_ip[NUM_REPEATER_FLOPS] 	= 	mmsg_npirdy_ip;
assign  mmsg_pcparity_loc_ip[NUM_REPEATER_FLOPS] 	=     mmsg_pcparity_ip;
assign 	mmsg_npparity_loc_ip[NUM_REPEATER_FLOPS] 	= 	mmsg_npparity_ip;
assign 	mmsg_pceom_loc_ip[NUM_REPEATER_FLOPS] 	= 	mmsg_pceom_ip;
assign 	mmsg_npeom_loc_ip[NUM_REPEATER_FLOPS] 	= 	mmsg_npeom_ip;
assign 	mmsg_pcpayload_loc_ip[NUM_REPEATER_FLOPS] 	= 	mmsg_pcpayload_ip;
assign 	mmsg_nppayload_loc_ip[NUM_REPEATER_FLOPS] 	= 	mmsg_nppayload_ip;

assign 	tmsg_pcput_loc_ep[0] 	= 	tmsg_pcput_ep;
assign 	tmsg_npput_loc_ep[0] 	= 	tmsg_npput_ep;
assign 	tmsg_pcparity_loc_ep[0] 	= 	tmsg_pcparity_ep;
assign 	tmsg_npparity_loc_ep[0] 	= 	tmsg_npparity_ep;
assign 	tmsg_pcmsgip_loc_ep[0] 	= 	tmsg_pcmsgip_ep;
assign 	tmsg_npmsgip_loc_ep[0] 	= 	tmsg_npmsgip_ep;
assign 	tmsg_pceom_loc_ep[0] 	= 	tmsg_pceom_ep;
assign 	tmsg_npeom_loc_ep[0] 	= 	tmsg_npeom_ep;
assign  tmsg_pcpayload_loc_ep[0] 	=     tmsg_pcpayload_ep;
assign 	tmsg_nppayload_loc_ep[0] 	= 	tmsg_nppayload_ep;
assign  tmsg_pccmpl_loc_ep[0] 	=     tmsg_pccmpl_ep;
assign 	tmsg_npvalid_loc_ep[0] 	= 	tmsg_npvalid_ep;
assign 	tmsg_pcvalid_loc_ep[0] 	= 	tmsg_pcvalid_ep;
assign  tmsg_pcfree_loc_ip[NUM_REPEATER_FLOPS] 	=     tmsg_pcfree_ip;
assign 	tmsg_npfree_loc_ip[NUM_REPEATER_FLOPS] 	= 	tmsg_npfree_ip;
assign 	tmsg_npclaim_loc_ip[NUM_REPEATER_FLOPS] 	= 	tmsg_npclaim_ip;

//output tie up
assign  mmsg_pcirdy_ep	=     mmsg_pcirdy_loc_ep[0];
assign 	mmsg_npirdy_ep	= 	mmsg_npirdy_loc_ep[0];
assign  mmsg_pcparity_ep	=     mmsg_pcparity_loc_ep[0];
assign 	mmsg_npparity_ep	= 	mmsg_npparity_loc_ep[0];
assign 	mmsg_pceom_ep	= 	mmsg_pceom_loc_ep[0];
assign 	mmsg_npeom_ep	= 	mmsg_npeom_loc_ep[0];
assign 	mmsg_pcpayload_ep	= 	mmsg_pcpayload_loc_ep[0];
assign 	mmsg_nppayload_ep	= 	mmsg_nppayload_loc_ep[0];
assign  mmsg_pctrdy_ip	=     mmsg_pctrdy_loc_ip[NUM_REPEATER_FLOPS];
assign 	mmsg_nptrdy_ip	= 	mmsg_nptrdy_loc_ip[NUM_REPEATER_FLOPS];
assign 	mmsg_pcmsgip_ip	= 	mmsg_pcmsgip_loc_ip[NUM_REPEATER_FLOPS];
assign 	mmsg_npmsgip_ip	= 	mmsg_npmsgip_loc_ip[NUM_REPEATER_FLOPS];
assign 	mmsg_pcsel_ip	= 	mmsg_pcsel_loc_ip[NUM_REPEATER_FLOPS];
assign 	mmsg_npsel_ip	= 	mmsg_npsel_loc_ip[NUM_REPEATER_FLOPS];

assign  tmsg_pcfree_ep	=     tmsg_pcfree_loc_ep[0];
assign 	tmsg_npfree_ep	= 	tmsg_npfree_loc_ep[0];
assign 	tmsg_npclaim_ep	= 	tmsg_npclaim_loc_ep[0];
assign  tmsg_pcput_ip	=     tmsg_pcput_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_npput_ip	= 	tmsg_npput_loc_ip[NUM_REPEATER_FLOPS];
assign  tmsg_pcparity_ip	=     tmsg_pcparity_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_npparity_ip	= 	tmsg_npparity_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_pcmsgip_ip	= 	tmsg_pcmsgip_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_npmsgip_ip	= 	tmsg_npmsgip_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_pceom_ip	= 	tmsg_pceom_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_npeom_ip	= 	tmsg_npeom_loc_ip[NUM_REPEATER_FLOPS];
assign  tmsg_pcpayload_ip	=     tmsg_pcpayload_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_nppayload_ip	= 	tmsg_nppayload_loc_ip[NUM_REPEATER_FLOPS];
assign  tmsg_pccmpl_ip	=     tmsg_pccmpl_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_npvalid_ip	= 	tmsg_npvalid_loc_ip[NUM_REPEATER_FLOPS];
assign 	tmsg_pcvalid_ip	= 	tmsg_pcvalid_loc_ip[NUM_REPEATER_FLOPS];

if(NUM_REPEATER_FLOPS == 0) begin
			assign	mmsg_pcirdy_loc_ep[0] = mmsg_pcirdy_loc_ip[0];
			assign	mmsg_npirdy_loc_ep[0] = mmsg_npirdy_loc_ip[0];
            assign	mmsg_pcparity_loc_ep[0] = mmsg_pcparity_loc_ip[0];
			assign	mmsg_npparity_loc_ep[0] = mmsg_npparity_loc_ip[0];
			assign	mmsg_pceom_loc_ep[0] = mmsg_pceom_loc_ip[0];
			assign  mmsg_npeom_loc_ep[0] = mmsg_npeom_loc_ip[0];
			assign	mmsg_pcpayload_loc_ep[0] = mmsg_pcpayload_loc_ip[0];
			assign	mmsg_nppayload_loc_ep[0] = mmsg_nppayload_loc_ip[0];

			assign	mmsg_pctrdy_loc_ip[0] = mmsg_pctrdy_loc_ep[0];
			assign	mmsg_nptrdy_loc_ip[0] = mmsg_nptrdy_loc_ep[0];
			assign	mmsg_pcmsgip_loc_ip[0] = mmsg_pcmsgip_loc_ep[0];
			assign  mmsg_npmsgip_loc_ip[0] = mmsg_npmsgip_loc_ep[0];
			assign	mmsg_pcsel_loc_ip[0] = mmsg_pcsel_loc_ep[0];
			assign	mmsg_npsel_loc_ip[0]	= mmsg_npsel_loc_ep[0];
		
			assign	tmsg_pcvalid_loc_ip[0] = tmsg_pcvalid_loc_ep[0];
			assign	tmsg_npvalid_loc_ip[0] = tmsg_npvalid_loc_ep[0];
			assign	tmsg_pcfree_loc_ep[0] = tmsg_pcfree_loc_ip[0];
			assign	tmsg_npfree_loc_ep[0] = tmsg_npfree_loc_ip[0];
			assign	tmsg_npclaim_loc_ep[0] = tmsg_npclaim_loc_ip[0];
			assign	tmsg_pcput_loc_ip[0] = tmsg_pcput_loc_ep[0];
			assign	tmsg_npput_loc_ip[0] = tmsg_npput_loc_ep[0];
            assign	tmsg_pcparity_loc_ip[0] = tmsg_pcparity_loc_ep[0];
			assign	tmsg_npparity_loc_ip[0] = tmsg_npparity_loc_ep[0];
			assign	tmsg_pcmsgip_loc_ip[0] = tmsg_pcmsgip_loc_ep[0];
			assign	tmsg_npmsgip_loc_ip[0] = tmsg_npmsgip_loc_ep[0];
			assign	tmsg_pceom_loc_ip[0] = tmsg_pceom_loc_ep[0];
			assign	tmsg_npeom_loc_ip[0] = tmsg_npeom_loc_ep[0];
			assign	tmsg_pcpayload_loc_ip[0] = tmsg_pcpayload_loc_ep[0];
			assign	tmsg_nppayload_loc_ip[0] = tmsg_nppayload_loc_ep[0];
			assign	tmsg_pccmpl_loc_ip[0] = tmsg_pccmpl_loc_ep[0];						
end


generate 
	for( loop = 0 ; loop < NUM_REPEATER_FLOPS ; loop++) begin
            if(MOD_NAME == 0) begin
			    sberepmux_wrap #(
                .SPLIT_COMBO(SPLIT_COMBO),
			    .INTERNALPLDBIT(INTERNALPLDBIT)
   			    )
   			    i_sberepmux_wrap (
  			    .agent_clk    (clk),
  			    .agent_rst_b  (rst)  ,			   
  			    .sbi_sbe_tmsg_pcfree_ip     ( tmsg_pcfree_loc_ip[loop+1]          ),
  			    .sbi_sbe_tmsg_npfree_ip     ( tmsg_npfree_loc_ip[loop+1]                    ),
  			    .sbi_sbe_tmsg_npclaim_ip    ( tmsg_npclaim_loc_ip[loop+1]                   ),
  			    .sbe_sbi_tmsg_pcput_ip      ( tmsg_pcput_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_npput_ip      ( tmsg_npput_loc_ip[loop+1]                             ),
                .sbe_sbi_tmsg_pcparity_ip   ( tmsg_pcparity_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_npparity_ip   ( tmsg_npparity_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ip    ( tmsg_pcmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_tmsg_npmsgip_ip    ( tmsg_npmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_tmsg_pceom_ip      ( tmsg_pceom_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_npeom_ip      ( tmsg_npeom_loc_ip[loop+1]                            ),
  			    .sbe_sbi_tmsg_pcpayload_ip  (tmsg_pcpayload_loc_ip[loop+1]                         ),
  			    .sbe_sbi_tmsg_nppayload_ip  ( tmsg_nppayload_loc_ip[loop+1]                         ),
  			    .sbe_sbi_tmsg_pccmpl_ip     ( tmsg_pccmpl_loc_ip[loop+1]                            ),


  			    .sbi_sbe_mmsg_pcirdy_ip     ( mmsg_pcirdy_loc_ip[loop+1]                    ),
  			    .sbi_sbe_mmsg_npirdy_ip     ( mmsg_npirdy_loc_ip[loop+1]                    ),
                .sbi_sbe_mmsg_pcparity_ip     ( mmsg_pcparity_loc_ip[loop+1]                    ),
  			    .sbi_sbe_mmsg_npparity_ip     ( mmsg_npparity_loc_ip[loop+1]                    ),
  			    .sbi_sbe_mmsg_pceom_ip      ( mmsg_pceom_loc_ip[loop+1]                     ),
  			    .sbi_sbe_mmsg_npeom_ip      ( mmsg_npeom_loc_ip[loop+1]                     ),
  			    .sbi_sbe_mmsg_pcpayload_ip  ( mmsg_pcpayload_loc_ip[loop+1]                 ),
  			    .sbi_sbe_mmsg_nppayload_ip  ( mmsg_nppayload_loc_ip[loop+1]                 ),
  			    .sbe_sbi_mmsg_pctrdy_ip     ( mmsg_pctrdy_loc_ip[loop+1]                            ),
  			    .sbe_sbi_mmsg_nptrdy_ip     ( mmsg_nptrdy_loc_ip[loop+1]                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ip    ( mmsg_pcmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_mmsg_npmsgip_ip    ( mmsg_npmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_mmsg_pcsel_ip      ( mmsg_pcsel_loc_ip[loop+1]                     ),
  			    .sbe_sbi_mmsg_npsel_ip      ( mmsg_npsel_loc_ip[loop+1]                     ),
  			    .sbe_sbi_tmsg_pcvalid_ip    ( tmsg_pcvalid_loc_ip[loop+1]                           ),
  			    .sbe_sbi_tmsg_npvalid_ip    ( tmsg_npvalid_loc_ip[loop+1]                         ),

  			    .sbi_sbe_tmsg_pcfree_ep     ( tmsg_pcfree_loc_ep[loop]                    ),
  			    .sbi_sbe_tmsg_npfree_ep     ( tmsg_npfree_loc_ep[loop]                    ),
  			    .sbi_sbe_tmsg_npclaim_ep    ( tmsg_npclaim_loc_ep[loop]                   ),
  			    .sbe_sbi_tmsg_pcput_ep      ( tmsg_pcput_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_npput_ep      ( tmsg_npput_loc_ep[loop]                             ),
                .sbe_sbi_tmsg_pcparity_ep   ( tmsg_pcparity_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_npparity_ep   ( tmsg_npparity_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ep    ( tmsg_pcmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_tmsg_npmsgip_ep    ( tmsg_npmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_tmsg_pceom_ep      ( tmsg_pceom_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_npeom_ep      ( tmsg_npeom_loc_ep[loop]                            ),
  			    .sbe_sbi_tmsg_pcpayload_ep  ( tmsg_pcpayload_loc_ep[loop]                         ),
  			    .sbe_sbi_tmsg_nppayload_ep  ( tmsg_nppayload_loc_ep[loop]                         ),
  			    .sbe_sbi_tmsg_pccmpl_ep     ( tmsg_pccmpl_loc_ep[loop]                            ),
  			    .fscan_rstbypen          ( 1'b0                         ), 
  			    .fscan_byprst_b          ( 1'b1                         ), 
  			    .fscan_mode              ( 1'b0                             ),
  			    .fscan_shiften           ( 1'b0                          ),
  			    .fscan_clkungate_syn     ( 1'b0                    ),
			   
  			    .sbi_sbe_mmsg_pcirdy_ep     ( mmsg_pcirdy_loc_ep[loop]                    ),
  			    .sbi_sbe_mmsg_npirdy_ep     ( mmsg_npirdy_loc_ep[loop]                    ),
                .sbi_sbe_mmsg_pcparity_ep     ( mmsg_pcparity_loc_ep[loop]                    ),
  			    .sbi_sbe_mmsg_npparity_ep     ( mmsg_npparity_loc_ep[loop]                    ),
  			    .sbi_sbe_mmsg_pceom_ep      ( mmsg_pceom_loc_ep[loop]                     ),
  			    .sbi_sbe_mmsg_npeom_ep      ( mmsg_npeom_loc_ep[loop]                     ),
  			    .sbi_sbe_mmsg_pcpayload_ep  ( mmsg_pcpayload_loc_ep[loop]                 ),
  			    .sbi_sbe_mmsg_nppayload_ep  ( mmsg_nppayload_loc_ep[loop]                 ),
  			    .sbe_sbi_mmsg_pctrdy_ep     ( mmsg_pctrdy_loc_ep[loop]                            ),
  			    .sbe_sbi_mmsg_nptrdy_ep     ( mmsg_nptrdy_loc_ep[loop]                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ep    ( mmsg_pcmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_mmsg_npmsgip_ep    ( mmsg_npmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_mmsg_pcsel_ep      ( mmsg_pcsel_loc_ep[loop]                     ),
  			    .sbe_sbi_mmsg_npsel_ep      ( mmsg_npsel_loc_ep[loop]                     ),
  			    .sbe_sbi_tmsg_pcvalid_ep    ( tmsg_pcvalid_loc_ep[loop]                           ),
  			    .sbe_sbi_tmsg_npvalid_ep    ( tmsg_npvalid_loc_ep[loop]                         ) 			   
 			    );   			 
            end
            else if(MOD_NAME == 1) begin
                sberepmux_wrap #(
                .SPLIT_COMBO(SPLIT_COMBO),
			    .INTERNALPLDBIT(INTERNALPLDBIT)
   			    )
   			    i_sberepmux_wrap (
  			    .agent_clk    (ccu_if.clk[1]),
  			    .agent_rst_b  (endpoint_reset && rst_b)  ,			   
  			    .sbi_sbe_tmsg_pcfree_ip     ( 1'b0          ),
  			    .sbi_sbe_tmsg_npfree_ip     ( 1'b0                    ),
  			    .sbi_sbe_tmsg_npclaim_ip    ( 1'b0                   ),
  			    .sbe_sbi_tmsg_pcput_ip      (                              ),
  			    .sbe_sbi_tmsg_npput_ip      (                              ),
                .sbe_sbi_tmsg_pcparity_ip      (                              ),
  			    .sbe_sbi_tmsg_npparity_ip      (                              ),
  			    .sbe_sbi_tmsg_pcmsgip_ip    (                            ),
  			    .sbe_sbi_tmsg_npmsgip_ip    (                            ),
  			    .sbe_sbi_tmsg_pceom_ip      (                              ),
  			    .sbe_sbi_tmsg_npeom_ip      (                             ),
  			    .sbe_sbi_tmsg_pcpayload_ip  (                         ),
  			    .sbe_sbi_tmsg_nppayload_ip  (                          ),
  			    .sbe_sbi_tmsg_pccmpl_ip     (                             ),


  			    .sbi_sbe_mmsg_pcirdy_ip     ( 1'b0                    ),
  			    .sbi_sbe_mmsg_npirdy_ip     ( mmsg_npirdy_loc_ip[loop+1]                    ),
                .sbi_sbe_mmsg_pcparity_ip   ( 1'b0                    ),
  			    .sbi_sbe_mmsg_npparity_ip   ( mmsg_npparity_loc_ip[loop+1]                    ),
  			    .sbi_sbe_mmsg_pceom_ip      (1'b0                     ),
  			    .sbi_sbe_mmsg_npeom_ip      ( mmsg_npeom_loc_ip[loop+1]                     ),
  			    .sbi_sbe_mmsg_pcpayload_ip  ( 'h0                 ),
  			    .sbi_sbe_mmsg_nppayload_ip  ( mmsg_nppayload_loc_ip[loop+1]                 ),
  			    .sbe_sbi_mmsg_pctrdy_ip     (                             ),
  			    .sbe_sbi_mmsg_nptrdy_ip     ( mmsg_nptrdy_loc_ip[loop+1]                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ip    (                           ),
  			    .sbe_sbi_mmsg_npmsgip_ip    ( mmsg_npmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_mmsg_pcsel_ip      (                      ),
  			    .sbe_sbi_mmsg_npsel_ip      ( mmsg_npsel_loc_ip[loop+1]                     ),
  			    .sbe_sbi_tmsg_pcvalid_ip    (                            ),
  			    .sbe_sbi_tmsg_npvalid_ip    (                          ),

  			    .sbi_sbe_tmsg_pcfree_ep     (                     ),
  			    .sbi_sbe_tmsg_npfree_ep     (                     ),
  			    .sbi_sbe_tmsg_npclaim_ep    (                    ),
  			    .sbe_sbi_tmsg_pcput_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npput_ep      ( 1'b0                             ),
                .sbe_sbi_tmsg_pcparity_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npparity_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_npmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_pceom_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npeom_ep      ( 1'b0                            ),
  			    .sbe_sbi_tmsg_pcpayload_ep  ( 'h0                         ),
  			    .sbe_sbi_tmsg_nppayload_ep  ( 'h0                         ),
  			    .sbe_sbi_tmsg_pccmpl_ep     ( 1'b0                            ),
  			    .fscan_rstbypen          ( 1'b0                         ), 
  			    .fscan_byprst_b          ( 1'b1                         ), 
  			    .fscan_mode              ( 1'b0                             ),
  			    .fscan_shiften           ( 1'b0                          ),
  			    .fscan_clkungate_syn     ( 1'b0                    ),
			   
  			    .sbi_sbe_mmsg_pcirdy_ep     (                     ),
  			    .sbi_sbe_mmsg_npirdy_ep     ( mmsg_npirdy_loc_ep[loop]                    ),
                .sbi_sbe_mmsg_pcparity_ep   (                     ),
  			    .sbi_sbe_mmsg_npparity_ep   ( mmsg_npparity_loc_ep[loop]                    ),
  			    .sbi_sbe_mmsg_pceom_ep      (                      ),
  			    .sbi_sbe_mmsg_npeom_ep      ( mmsg_npeom_loc_ep[loop]                     ),
  			    .sbi_sbe_mmsg_pcpayload_ep  (                  ),
  			    .sbi_sbe_mmsg_nppayload_ep  ( mmsg_nppayload_loc_ep[loop]                 ),
  			    .sbe_sbi_mmsg_pctrdy_ep     ( 1'b0                            ),
  			    .sbe_sbi_mmsg_nptrdy_ep     ( mmsg_nptrdy_loc_ep[loop]                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_mmsg_npmsgip_ep    ( mmsg_npmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_mmsg_pcsel_ep      ( 1'b0                     ),
  			    .sbe_sbi_mmsg_npsel_ep      ( mmsg_npsel_loc_ep[loop]                     ),
  			    .sbe_sbi_tmsg_pcvalid_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_npvalid_ep    ( 1'b0                         ) 			   
 			    );
                
            end
            else if(MOD_NAME == 2) begin
                sberepmux_wrap #(
                .SPLIT_COMBO(SPLIT_COMBO),
			    .INTERNALPLDBIT(INTERNALPLDBIT)
   			    )
   			    i_sberepmux_wrap (
  			    .agent_clk    (ccu_if.clk[1]),
  			    .agent_rst_b  (endpoint_reset && rst_b)  ,			   
  			    .sbi_sbe_tmsg_pcfree_ip     ( 1'b0          ),
  			    .sbi_sbe_tmsg_npfree_ip     ( 1'b0                    ),
  			    .sbi_sbe_tmsg_npclaim_ip    ( 1'b0                   ),
  			    .sbe_sbi_tmsg_pcput_ip      (                              ),
  			    .sbe_sbi_tmsg_npput_ip      (                              ),
                .sbe_sbi_tmsg_pcparity_ip   (                              ),
  			    .sbe_sbi_tmsg_npparity_ip   (                              ),
  			    .sbe_sbi_tmsg_pcmsgip_ip    (                            ),
  			    .sbe_sbi_tmsg_npmsgip_ip    (                            ),
  			    .sbe_sbi_tmsg_pceom_ip      (                              ),
  			    .sbe_sbi_tmsg_npeom_ip      (                             ),
  			    .sbe_sbi_tmsg_pcpayload_ip  (                         ),
  			    .sbe_sbi_tmsg_nppayload_ip  (                          ),
  			    .sbe_sbi_tmsg_pccmpl_ip     (                             ),


  			    .sbi_sbe_mmsg_pcirdy_ip     ( mmsg_pcirdy_loc_ip[loop+1]                    ),
  			    .sbi_sbe_mmsg_npirdy_ip     ( 1'b0                    ),
                .sbi_sbe_mmsg_pcparity_ip   ( mmsg_pcparity_loc_ip[loop+1]                    ),
  			    .sbi_sbe_mmsg_npparity_ip   ( 1'b0                    ),
  			    .sbi_sbe_mmsg_pceom_ip      ( mmsg_pceom_loc_ip[loop+1]                     ),
  			    .sbi_sbe_mmsg_npeom_ip      ( 1'b0                     ),
  			    .sbi_sbe_mmsg_pcpayload_ip  ( mmsg_pcpayload_loc_ip[loop+1]                 ),
  			    .sbi_sbe_mmsg_nppayload_ip  ( 'h0                 ),
  			    .sbe_sbi_mmsg_pctrdy_ip     ( mmsg_pctrdy_loc_ip[loop+1]                            ),
  			    .sbe_sbi_mmsg_nptrdy_ip     (                             ),
  			    .sbe_sbi_mmsg_pcmsgip_ip    ( mmsg_pcmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_mmsg_npmsgip_ip    (                            ),
  			    .sbe_sbi_mmsg_pcsel_ip      ( mmsg_pcsel_loc_ip[loop+1]                     ),
  			    .sbe_sbi_mmsg_npsel_ip      (                      ),
  			    .sbe_sbi_tmsg_pcvalid_ip    (                            ),
  			    .sbe_sbi_tmsg_npvalid_ip    (                          ),

  			    .sbi_sbe_tmsg_pcfree_ep     (                     ),
  			    .sbi_sbe_tmsg_npfree_ep     (                     ),
  			    .sbi_sbe_tmsg_npclaim_ep    (                    ),
  			    .sbe_sbi_tmsg_pcput_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npput_ep      ( 1'b0                             ),
                .sbe_sbi_tmsg_pcparity_ep   ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npparity_ep   ( 1'b0                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_npmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_pceom_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npeom_ep      ( 1'b0                            ),
  			    .sbe_sbi_tmsg_pcpayload_ep  ( 'h0                         ),
  			    .sbe_sbi_tmsg_nppayload_ep  ( 'h0                         ),
  			    .sbe_sbi_tmsg_pccmpl_ep     ( 1'b0                            ),
  			    .fscan_rstbypen          ( 1'b0                         ), 
  			    .fscan_byprst_b          ( 1'b1                         ), 
  			    .fscan_mode              ( 1'b0                             ),
  			    .fscan_shiften           ( 1'b0                          ),
  			    .fscan_clkungate_syn     ( 1'b0                    ),
			   
  			    .sbi_sbe_mmsg_pcirdy_ep     ( mmsg_pcirdy_loc_ep[loop]                    ),
  			    .sbi_sbe_mmsg_npirdy_ep     (                     ),
                .sbi_sbe_mmsg_pcparity_ep   ( mmsg_pcparity_loc_ep[loop]                    ),
  			    .sbi_sbe_mmsg_npparity_ep   (                     ),
  			    .sbi_sbe_mmsg_pceom_ep      ( mmsg_pceom_loc_ep[loop]                     ),
  			    .sbi_sbe_mmsg_npeom_ep      (                      ),
  			    .sbi_sbe_mmsg_pcpayload_ep  ( mmsg_pcpayload_loc_ep[loop]                 ),
  			    .sbi_sbe_mmsg_nppayload_ep  (                  ),
  			    .sbe_sbi_mmsg_pctrdy_ep     ( mmsg_pctrdy_loc_ep[loop]                            ),
  			    .sbe_sbi_mmsg_nptrdy_ep     ( 1'b0                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ep    ( mmsg_pcmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_mmsg_npmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_mmsg_pcsel_ep      ( mmsg_pcsel_loc_ep[loop]                     ),
  			    .sbe_sbi_mmsg_npsel_ep      ( 1'b0                     ),
  			    .sbe_sbi_tmsg_pcvalid_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_npvalid_ep    ( 1'b0                         ) 			   
 			    );
            end
            else if(MOD_NAME == 3) begin
                sberepmux_wrap #(
                .SPLIT_COMBO(SPLIT_COMBO),
			    .INTERNALPLDBIT(INTERNALPLDBIT)
   			    )
   			    i_sberepmux_wrap (
  			    .agent_clk    (ccu_if.clk[1]),
  			    .agent_rst_b  (endpoint_reset && rst_b)  ,			   
  			    .sbi_sbe_tmsg_pcfree_ip     ( 1'b0          ),
  			    .sbi_sbe_tmsg_npfree_ip     ( tmsg_npfree_loc_ip[loop+1]                    ),
  			    .sbi_sbe_tmsg_npclaim_ip    ( tmsg_npclaim_loc_ip[loop+1]                   ),
  			    .sbe_sbi_tmsg_pcput_ip      (                              ),
  			    .sbe_sbi_tmsg_npput_ip      ( tmsg_npput_loc_ip[loop+1]                             ),
                .sbe_sbi_tmsg_pcparity_ip   (                              ),
  			    .sbe_sbi_tmsg_npparity_ip   ( tmsg_npparity_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ip    (                            ),
  			    .sbe_sbi_tmsg_npmsgip_ip    ( tmsg_npmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_tmsg_pceom_ip      (                              ),
  			    .sbe_sbi_tmsg_npeom_ip      ( tmsg_npeom_loc_ip[loop+1]                            ),
  			    .sbe_sbi_tmsg_pcpayload_ip  (                         ),
  			    .sbe_sbi_tmsg_nppayload_ip  ( tmsg_nppayload_loc_ip[loop+1]                         ),
  			    .sbe_sbi_tmsg_pccmpl_ip     (                             ),


  			    .sbi_sbe_mmsg_pcirdy_ip     ( 1'b0                    ),
  			    .sbi_sbe_mmsg_npirdy_ip     ( 1'b0                    ),
                .sbi_sbe_mmsg_pcparity_ip   ( 1'b0                    ),
  			    .sbi_sbe_mmsg_npparity_ip   ( 1'b0                    ),
  			    .sbi_sbe_mmsg_pceom_ip      ( 1'b0                     ),
  			    .sbi_sbe_mmsg_npeom_ip      ( 1'b0                     ),
  			    .sbi_sbe_mmsg_pcpayload_ip  ( 'h0                 ),
  			    .sbi_sbe_mmsg_nppayload_ip  ( 'h0                 ),
  			    .sbe_sbi_mmsg_pctrdy_ip     (                            ),
  			    .sbe_sbi_mmsg_nptrdy_ip     (                             ),
  			    .sbe_sbi_mmsg_pcmsgip_ip    (                            ),
  			    .sbe_sbi_mmsg_npmsgip_ip    (                            ),
  			    .sbe_sbi_mmsg_pcsel_ip      (                      ),
  			    .sbe_sbi_mmsg_npsel_ip      (                      ),
  			    .sbe_sbi_tmsg_pcvalid_ip    (                            ),
  			    .sbe_sbi_tmsg_npvalid_ip    ( tmsg_npvalid_loc_ip[loop+1]                         ),

  			    .sbi_sbe_tmsg_pcfree_ep     (                     ),
  			    .sbi_sbe_tmsg_npfree_ep     ( tmsg_npfree_loc_ep[loop]                    ),
  			    .sbi_sbe_tmsg_npclaim_ep    ( tmsg_npclaim_loc_ep[loop]                   ),
  			    .sbe_sbi_tmsg_pcput_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npput_ep      ( tmsg_npput_loc_ep[loop]                             ),
                .sbe_sbi_tmsg_pcparity_ep   ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npparity_ep   ( tmsg_npparity_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_npmsgip_ep    ( tmsg_npmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_tmsg_pceom_ep      ( 1'b0                             ),
  			    .sbe_sbi_tmsg_npeom_ep      ( tmsg_npeom_loc_ep[loop]                            ),
  			    .sbe_sbi_tmsg_pcpayload_ep  ( 'h0                         ),
  			    .sbe_sbi_tmsg_nppayload_ep  ( tmsg_nppayload_loc_ep[loop]                         ),
  			    .sbe_sbi_tmsg_pccmpl_ep     ( 1'b0                            ),
  			    .fscan_rstbypen          ( 1'b0                         ), 
  			    .fscan_byprst_b          ( 1'b1                         ), 
  			    .fscan_mode              ( 1'b0                             ),
  			    .fscan_shiften           ( 1'b0                          ),
  			    .fscan_clkungate_syn     ( 1'b0                    ),
			   
  			    .sbi_sbe_mmsg_pcirdy_ep     (                     ),
  			    .sbi_sbe_mmsg_npirdy_ep     (                     ),
                .sbi_sbe_mmsg_pcparity_ep   (                     ),
  			    .sbi_sbe_mmsg_npparity_ep   (                     ),
  			    .sbi_sbe_mmsg_pceom_ep      (                      ),
  			    .sbi_sbe_mmsg_npeom_ep      (                     ),
  			    .sbi_sbe_mmsg_pcpayload_ep  (                  ),
  			    .sbi_sbe_mmsg_nppayload_ep  (                  ),
  			    .sbe_sbi_mmsg_pctrdy_ep     ( 1'b0                            ),
  			    .sbe_sbi_mmsg_nptrdy_ep     ( 1'b0                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_mmsg_npmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_mmsg_pcsel_ep      ( 1'b0                     ),
  			    .sbe_sbi_mmsg_npsel_ep      ( 1'b0                     ),
  			    .sbe_sbi_tmsg_pcvalid_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_npvalid_ep    ( tmsg_npvalid_loc_ep[loop]                         ) 			   
 			    );
                
            end
            else begin
                sberepmux_wrap #(
                .SPLIT_COMBO(SPLIT_COMBO),
			    .INTERNALPLDBIT(INTERNALPLDBIT)
   			    )
   			    i_sberepmux_wrap (
  			    .agent_clk    (ccu_if.clk[1]),
  			    .agent_rst_b  (endpoint_reset && rst_b)  ,			   
  			    .sbi_sbe_tmsg_pcfree_ip     ( tmsg_pcfree_loc_ip[loop+1]          ),
  			    .sbi_sbe_tmsg_npfree_ip     ( 1'b0                    ),
  			    .sbi_sbe_tmsg_npclaim_ip    ( 1'b0                   ),
  			    .sbe_sbi_tmsg_pcput_ip      ( tmsg_pcput_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_npput_ip      (                              ),
                .sbe_sbi_tmsg_pcparity_ip   ( tmsg_pcparity_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_npparity_ip   (                              ),
  			    .sbe_sbi_tmsg_pcmsgip_ip    ( tmsg_pcmsgip_loc_ip[loop+1]                           ),
  			    .sbe_sbi_tmsg_npmsgip_ip    (                            ),
  			    .sbe_sbi_tmsg_pceom_ip      ( tmsg_pceom_loc_ip[loop+1]                             ),
  			    .sbe_sbi_tmsg_npeom_ip      (                             ),
  			    .sbe_sbi_tmsg_pcpayload_ip  (tmsg_pcpayload_loc_ip[loop+1]                         ),
  			    .sbe_sbi_tmsg_nppayload_ip  (                          ),
  			    .sbe_sbi_tmsg_pccmpl_ip     ( tmsg_pccmpl_loc_ip[loop+1]                            ),


  			    .sbi_sbe_mmsg_pcirdy_ip     ( 1'b0                    ),
  			    .sbi_sbe_mmsg_npirdy_ip     ( 1'b0                    ),
                .sbi_sbe_mmsg_pcparity_ip   ( 1'b0                    ),
  			    .sbi_sbe_mmsg_npparity_ip   ( 1'b0                    ),
  			    .sbi_sbe_mmsg_pceom_ip      ( 1'b0                     ),
  			    .sbi_sbe_mmsg_npeom_ip      ( 1'b0                     ),
  			    .sbi_sbe_mmsg_pcpayload_ip  ( 'h0                 ),
  			    .sbi_sbe_mmsg_nppayload_ip  ( 'h0                 ),
  			    .sbe_sbi_mmsg_pctrdy_ip     (                            ),
  			    .sbe_sbi_mmsg_nptrdy_ip     (                             ),
  			    .sbe_sbi_mmsg_pcmsgip_ip    (                            ),
  			    .sbe_sbi_mmsg_npmsgip_ip    (                            ),
  			    .sbe_sbi_mmsg_pcsel_ip      (                      ),
  			    .sbe_sbi_mmsg_npsel_ip      (                      ),
  			    .sbe_sbi_tmsg_pcvalid_ip    ( tmsg_pcvalid_loc_ip[loop+1]                           ),
  			    .sbe_sbi_tmsg_npvalid_ip    (                          ),

  			    .sbi_sbe_tmsg_pcfree_ep     ( tmsg_pcfree_loc_ep[loop]                    ),
  			    .sbi_sbe_tmsg_npfree_ep     (                     ),
  			    .sbi_sbe_tmsg_npclaim_ep    (                    ),
  			    .sbe_sbi_tmsg_pcput_ep      ( tmsg_pcput_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_npput_ep      ( 1'b0                             ),
                .sbe_sbi_tmsg_pcparity_ep   ( tmsg_pcparity_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_npparity_ep   ( 1'b0                             ),
  			    .sbe_sbi_tmsg_pcmsgip_ep    ( tmsg_pcmsgip_loc_ep[loop]                           ),
  			    .sbe_sbi_tmsg_npmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_tmsg_pceom_ep      ( tmsg_pceom_loc_ep[loop]                             ),
  			    .sbe_sbi_tmsg_npeom_ep      ( 1'b0                            ),
  			    .sbe_sbi_tmsg_pcpayload_ep  ( tmsg_pcpayload_loc_ep[loop]                         ),
  			    .sbe_sbi_tmsg_nppayload_ep  ( 'h0                         ),
  			    .sbe_sbi_tmsg_pccmpl_ep     ( tmsg_pccmpl_loc_ep[loop]                            ),
  			    .fscan_rstbypen          ( 1'b0                         ), 
  			    .fscan_byprst_b          ( 1'b1                         ), 
  			    .fscan_mode              ( 1'b0                             ),
  			    .fscan_shiften           ( 1'b0                          ),
  			    .fscan_clkungate_syn     ( 1'b0                    ),
			   
  			    .sbi_sbe_mmsg_pcirdy_ep     (                     ),
  			    .sbi_sbe_mmsg_npirdy_ep     (                     ),
                .sbi_sbe_mmsg_pcparity_ep   (                     ),
  			    .sbi_sbe_mmsg_npparity_ep   (                     ),
  			    .sbi_sbe_mmsg_pceom_ep      (                      ),
  			    .sbi_sbe_mmsg_npeom_ep      (                     ),
  			    .sbi_sbe_mmsg_pcpayload_ep  (                  ),
  			    .sbi_sbe_mmsg_nppayload_ep  (                  ),
  			    .sbe_sbi_mmsg_pctrdy_ep     ( 1'b0                            ),
  			    .sbe_sbi_mmsg_nptrdy_ep     ( 1'b0                            ),
  			    .sbe_sbi_mmsg_pcmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_mmsg_npmsgip_ep    ( 1'b0                           ),
  			    .sbe_sbi_mmsg_pcsel_ep      ( 1'b0                     ),
  			    .sbe_sbi_mmsg_npsel_ep      ( 1'b0                     ),
  			    .sbe_sbi_tmsg_pcvalid_ep    ( tmsg_pcvalid_loc_ep[loop]                           ),
  			    .sbe_sbi_tmsg_npvalid_ep    ( 1'b0                         ) 			   
 			    );

            end

		if(loop>0) begin	
 	        assign	mmsg_pcirdy_loc_ip[loop] = mmsg_pcirdy_loc_ep[loop];
			assign	mmsg_npirdy_loc_ip[loop] = mmsg_npirdy_loc_ep[loop];
            assign	mmsg_pcparity_loc_ip[loop] = mmsg_pcparity_loc_ep[loop];
			assign	mmsg_npparity_loc_ip[loop] = mmsg_npparity_loc_ep[loop];
			assign	mmsg_pceom_loc_ip[loop] = mmsg_pceom_loc_ep[loop];
			assign  mmsg_npeom_loc_ip[loop] = mmsg_npeom_loc_ep[loop];
			assign	mmsg_pcpayload_loc_ip[loop] = mmsg_pcpayload_loc_ep[loop];
			assign	mmsg_nppayload_loc_ip[loop] = mmsg_nppayload_loc_ep[loop];

			assign	mmsg_pctrdy_loc_ep[loop] = mmsg_pctrdy_loc_ip[loop];
			assign	mmsg_nptrdy_loc_ep[loop] = mmsg_nptrdy_loc_ip[loop];
			assign	mmsg_pcmsgip_loc_ep[loop] = mmsg_pcmsgip_loc_ip[loop];
			assign  mmsg_npmsgip_loc_ep[loop] = mmsg_npmsgip_loc_ip[loop];
			assign	mmsg_pcsel_loc_ep[loop] = mmsg_pcsel_loc_ip[loop];
			assign	mmsg_npsel_loc_ep[loop]	= mmsg_npsel_loc_ip[loop];
		
			assign	tmsg_pcvalid_loc_ep[loop] = tmsg_pcvalid_loc_ip[loop];
			assign	tmsg_npvalid_loc_ep[loop] = tmsg_npvalid_loc_ip[loop];
			assign	tmsg_pcfree_loc_ip[loop] = tmsg_pcfree_loc_ep[loop];
			assign	tmsg_npfree_loc_ip[loop] = tmsg_npfree_loc_ep[loop];
			assign	tmsg_npclaim_loc_ip[loop] = tmsg_npclaim_loc_ep[loop];
			assign	tmsg_pcput_loc_ep[loop] = tmsg_pcput_loc_ip[loop];
			assign	tmsg_npput_loc_ep[loop] = tmsg_npput_loc_ip[loop];
            assign	tmsg_pcparity_loc_ep[loop] = tmsg_pcparity_loc_ip[loop];
			assign	tmsg_npparity_loc_ep[loop] = tmsg_npparity_loc_ip[loop];
			assign	tmsg_pcmsgip_loc_ep[loop] = tmsg_pcmsgip_loc_ip[loop];
			assign	tmsg_npmsgip_loc_ep[loop] = tmsg_npmsgip_loc_ip[loop];
			assign	tmsg_pceom_loc_ep[loop] = tmsg_pceom_loc_ip[loop];
			assign	tmsg_npeom_loc_ep[loop] = tmsg_npeom_loc_ip[loop];
			assign	tmsg_pcpayload_loc_ep[loop] = tmsg_pcpayload_loc_ip[loop];
			assign	tmsg_nppayload_loc_ep[loop] = tmsg_nppayload_loc_ip[loop];
			assign	tmsg_pccmpl_loc_ep[loop] = tmsg_pccmpl_loc_ip[loop];			
		end	
 	end
 endgenerate
endmodule :rpt_module_wrap
