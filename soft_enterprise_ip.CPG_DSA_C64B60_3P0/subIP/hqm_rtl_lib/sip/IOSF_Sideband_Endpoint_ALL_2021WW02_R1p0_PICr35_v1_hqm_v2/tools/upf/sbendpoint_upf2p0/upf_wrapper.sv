

// The parameters here were copied directly from the RTL. Any changes to the 
// default values (or new params) in the RTL should also be updated here as well.
// Mismatches between this parameter list and the true list in the RTL may 
// prevent power linting of a valid RTL configuration.. Hopefully, the parameters
// will change infrequently enough for this not to be a problem. If the 
// 
// One method for resolving this is to group the parameters in a "pm" file to be 
// included in the RTL. This would enable this wrapper to include that file as 
// well, keeping the RTL and wrapper in sync.
//
// I apologize in advance to future maintainers of this code. Unfortunately, 
// I didn't have the time to risk changing the RTL for a proper resolution.  

module endpoint_wrapper 
  #(
    parameter MAXPLDBIT    = 7, // Maximum payload bit, should be 7, 15 or 31
    parameter NPQUEUEDEPTH = 4, // Ingress queue depth, NP
    parameter PCQUEUEDEPTH = 4, // Ingress queue depth, PC
    parameter CUP2PUT1CYC  = 0, // deprecated.  setting ignored
    parameter LATCHQUEUES  = 0, // 0 = flop-based queues, 1 = latch-based queues
    parameter MAXPCTRGT    = 0, // Maximum posted/completion target agent number
    parameter MAXNPTRGT    = 0, // Maximum non-posted        target agent number
    parameter MAXPCMSTR    = 0, // Maximum posted/completion master agent number
    parameter MAXNPMSTR    = 0, // Maximum non-posted        master agent number
    parameter ASYNCENDPT   = 0, // Asynchronous endpoint=1, 0 otherwise
    parameter ASYNCIQDEPTH = 2, // Asynchronous ingress FIFO queue depth
    parameter ASYNCEQDEPTH = 2, // Asynchronous egress FIFO queue depth
    parameter TARGETREG    = 1, // Target Register Access Agent 1=Enable/0=Disable
    parameter MASTERREG    = 1, // Master Register Access Agent 1=Enable/0=Disable
    parameter MAXTRGTADDR  = 31, // Maximum target register access address bit
    parameter MAXTRGTDATA  = 63, // Maximum target register access data bit
    parameter MAXMSTRADDR  = 31, // Maximum master register access address bit
    parameter MAXMSTRDATA  = 63, // Maximum master register access data bit
    parameter VALONLYMODEL = 0, // deprecated.  setting ignored.
    parameter DUMMY_CLKBUF = 0, // set to 1 to insert a dummy clkbuf, needed for 
    // some CPU scan flows.
    parameter RX_EXT_HEADER_SUPPORT = 0, // indicate whether agent supports receiving extended headers
    parameter NUM_RX_EXT_HEADERS    = 0, // number of headers agent supports receiving.
    parameter [NUM_RX_EXT_HEADERS:0][6:0] RX_EXT_HEADER_IDS = 0, // header IDs the agent supports.  any others are discarded.
    parameter TX_EXT_HEADER_SUPPORT = 0,
    parameter NUM_TX_EXT_HEADERS = 0,
    parameter DISABLE_COMPLETION_FENCING = 0,
    // following are VISA insertion parameters, used for inserting VISA on the endpoint itself.
    // this is not the intended flow for end-users, but is present for VISA verify flow on endpoint collateral.
    // intended flow for end-users is to take provided signal list and integrate with overall signal list for
    // the design for inserting VISA at the top design level.
    parameter SBE_VISA_ID_PARAM = 11,
    parameter NUMBER_OF_BITS_PER_LANE = 8,
    parameter NUMBER_OF_VISAMUX_MODULES = 1,
    parameter NUMBER_OF_OUTPUT_LANES = (NUMBER_OF_VISAMUX_MODULES == 1)? 2 : NUMBER_OF_VISAMUX_MODULES,
    parameter SKIP_ACTIVEREQ = 1, // set to 1 to skip ACTIVE_REQ, per IOSF 1.0 
    parameter PIPEISMS       = 0, // set to 1 to pipeline fabric ism inputs
    parameter PIPEINPS       = 0, // set to 1 to pipeline all put-cup-eom-payload inputs
    parameter USYNC_ENABLE   = 0  // set to 1 to enable deterministic clock crossing
   )
   (input clk, 
    input rst_b); 



   localparam TBE_WIDTH = MAXTRGTDATA == 31 ? 3 : 7;
   localparam MBE_WIDTH = MAXMSTRDATA == 31 ? 3 : 7;
   localparam TADR_WIDTH = MAXTRGTADDR < 15 ? 15 : MAXTRGTADDR > 47 ? 47 : MAXTRGTADDR;
   localparam MADR_WIDTH = MAXMSTRADDR < 15 ? 15 : MAXMSTRADDR > 47 ? 47 : MAXMSTRADDR;


   logic temp_reg;

   logic                 gated_side_clk;
   logic [2:0]           side_ism_agent;
   logic                 side_clkreq;
   logic                 sbe_clkreq;
   logic                 sbe_clk_valid;
   logic                 mpcput;
   logic                 mnpput;
   logic                 meom;
   logic [MAXPLDBIT:0]   mpayload;
   logic                 tpccup;
   logic                 tnpcup;

   logic                 tmsg_pcput;
   logic                 tmsg_npput;
   logic                 tmsg_pcmsgip;
   logic                 tmsg_npmsgip;
   logic                 tmsg_pceom;
   logic                 tmsg_npeom;
   logic [MAXPLDBIT:0]   tmsg_pcpayload;
   logic [MAXPLDBIT:0]   tmsg_nppayload;
   logic                 tmsg_pccmpl;
   logic                 tmsg_npvalid;
   logic                 tmsg_pcvalid;

   logic                 mmsg_pctrdy;
   logic                 mmsg_nptrdy;
   logic                 mmsg_pcmsgip;
   logic                 mmsg_npmsgip;
   logic [MAXPCMSTR:0]   mmsg_pcsel;
   logic [MAXNPMSTR:0]   mmsg_npsel;

   logic                 treg_irdy;
   logic                 treg_np;
   logic [7:0]           treg_dest;
   logic [7:0]           treg_source;
   logic [7:0]           treg_opcode;
   logic                 treg_addrlen;
   logic [2:0]           treg_bar;
   logic [2:0]           treg_tag;
   logic [TBE_WIDTH:0]   treg_be;
   logic [7:0]           treg_fid;
   logic [TADR_WIDTH:0]  treg_addr;
   logic [MAXTRGTDATA:0] treg_wdata;
   logic                 treg_eh;
   logic [NUM_RX_EXT_HEADERS:0][31:0] treg_ext_header;
   logic                 treg_eh_discard;


   logic                 mreg_trdy;
   logic                 mreg_pmsgip;
   logic                 mreg_nmsgip;



   always @(posedge clk or negedge rst_b) begin
      if (rst_b == 0) 
         temp_reg <= 0;
      else
         temp_reg <= ^{
                       gated_side_clk,
                       side_ism_agent,
                       side_clkreq,
                       sbe_clkreq,
                       sbe_clk_valid,
                       mpcput,
                       mnpput,
                       meom,
                       mpayload,
                       tpccup,
                       tnpcup,
                       
                       tmsg_pcput,
                       tmsg_npput,
                       tmsg_pcmsgip,
                       tmsg_npmsgip,
                       tmsg_pceom,
                       tmsg_npeom,
                       tmsg_pcpayload,
                       tmsg_nppayload,
                       tmsg_pccmpl,
                       tmsg_npvalid,
                       tmsg_pcvalid,
                       
                       mmsg_pctrdy,
                       mmsg_nptrdy,
                       mmsg_pcmsgip,
                       mmsg_npmsgip,
                       mmsg_pcsel,
                       mmsg_npsel,
                       
                       treg_irdy,
                       treg_np,
                       treg_dest,
                       treg_source,
                       treg_opcode,
                       treg_addrlen,
                       treg_bar,
                       treg_tag,
                       treg_be,
                       treg_fid,
                       treg_addr,
                       treg_wdata,
                       treg_eh,
                       treg_ext_header,
                       treg_eh_discard
                      };

   end



   sbendpoint #( // lintra s-80017
    .MAXPLDBIT               ( MAXPLDBIT                              ),
    .NPQUEUEDEPTH            ( NPQUEUEDEPTH                           ),
    .PCQUEUEDEPTH            ( PCQUEUEDEPTH                           ),
    .CUP2PUT1CYC             ( CUP2PUT1CYC                            ),
    .LATCHQUEUES             ( LATCHQUEUES                            ),
    .MAXPCTRGT               ( MAXPCTRGT                              ),
    .MAXNPTRGT               ( MAXNPTRGT                              ),
    .MAXPCMSTR               ( MAXPCMSTR                              ),
    .MAXNPMSTR               ( MAXNPMSTR                              ),
    .ASYNCENDPT              ( ASYNCENDPT                             ),
    .ASYNCIQDEPTH            ( ASYNCIQDEPTH                           ),
    .ASYNCEQDEPTH            ( ASYNCEQDEPTH                           ),
    .TARGETREG               ( TARGETREG                              ),
    .MASTERREG               ( MASTERREG                              ),
    .MAXTRGTADDR             ( MAXTRGTADDR                            ),
    .MAXTRGTDATA             ( MAXTRGTDATA                            ),
    .MAXMSTRADDR             ( MAXMSTRADDR                            ),
    .MAXMSTRDATA             ( MAXMSTRDATA                            ),
    .VALONLYMODEL            ( VALONLYMODEL                           ),
    .DUMMY_CLKBUF            ( DUMMY_CLKBUF                           ),
    .RX_EXT_HEADER_SUPPORT   ( RX_EXT_HEADER_SUPPORT                  ),
    .NUM_RX_EXT_HEADERS      ( NUM_RX_EXT_HEADERS                     ),
    .RX_EXT_HEADER_IDS       ( RX_EXT_HEADER_IDS                      ),
    .TX_EXT_HEADER_SUPPORT   ( TX_EXT_HEADER_SUPPORT                  ),
    .NUM_TX_EXT_HEADERS      ( NUM_TX_EXT_HEADERS                     ),
    .DISABLE_COMPLETION_FENCING ( DISABLE_COMPLETION_FENCING          ),
    .SBE_VISA_ID_PARAM       ( SBE_VISA_ID_PARAM                      ),
    .NUMBER_OF_BITS_PER_LANE ( NUMBER_OF_BITS_PER_LANE                ),
    .NUMBER_OF_VISAMUX_MODULES ( NUMBER_OF_VISAMUX_MODULES            ),
    .NUMBER_OF_OUTPUT_LANES  ( NUMBER_OF_OUTPUT_LANES                 ),
    .SKIP_ACTIVEREQ          ( SKIP_ACTIVEREQ                         ),
    .PIPEISMS                ( PIPEISMS                               ),
    .PIPEINPS                ( PIPEINPS                               ),
    .USYNC_ENABLE            ( USYNC_ENABLE                           )
    )
   i_sbendpoint
   (
   .side_clk           (),
   .gated_side_clk     (gated_side_clk), //out
   .side_rst_b         (),

   .agent_clk          (),
   .usyncselect        (),
   .side_usync         (),
   .agent_usync        (),

   .agent_clkreq       (),
   .agent_idle         (),
   .side_ism_fabric    (),
   .side_ism_agent     (side_ism_agent), //out
   .side_clkreq        (side_clkreq), //out
   .side_clkack        (),
   .side_ism_lock_b    (),

   .sbe_clkreq         (sbe_clkreq), //out
   .sbe_idle           (sbe_clkreq), //out
   .sbe_clk_valid      (sbe_clk_valid), //out

   .mpccup             (),
   .mnpcup             (),
   .mpcput             (mpcput), //out
   .mnpput             (mnpput), //out
   .meom               (meom), //out
   .mpayload           (mpayload), //out

   .tpccup             (tpccup), //out
   .tnpcup             (tnpcup), //out
   .tpcput             (),
   .tnpput             (),
   .teom               (),
   .tpayload           (),


   .tmsg_pcfree        (),
   .tmsg_npfree        (),
   .tmsg_npclaim       (),
   .tmsg_pcput         (tmsg_pcput), //out
   .tmsg_npput         (tmsg_npput), //out
   .tmsg_pcmsgip       (tmsg_pcmsgip), //out
   .tmsg_npmsgip       (tmsg_npmsgip), //out
   .tmsg_pceom         (tmsg_pceom), //out
   .tmsg_npeom         (tmsg_npeom), //out
   .tmsg_pcpayload     (tmsg_pcpayload), //out
   .tmsg_nppayload     (tmsg_nppayload), //out
   .tmsg_pccmpl        (tmsg_pccmpl), //out
   .tmsg_npvalid       (tmsg_npvalid), //out
   .tmsg_pcvalid       (tmsg_pcvalid), //out

   .mmsg_pcirdy        (),
   .mmsg_npirdy        (),
   .mmsg_pceom         (),
   .mmsg_npeom         (),
   .mmsg_pcpayload     (),
   .mmsg_nppayload     (),
   .mmsg_pctrdy        (mmsg_pctrdy), //out
   .mmsg_nptrdy        (mmsg_nptrdy), //out
   .mmsg_pcmsgip       (mmsg_pcmsgip), //out
   .mmsg_npmsgip       (mmsg_npmsgip), //out
   .mmsg_pcsel         (mmsg_pcsel), //out
   .mmsg_npsel         (mmsg_npsel), //out

   .treg_trdy          (),
   .treg_cerr          (),
   .treg_rdata         (),
   .treg_irdy          (treg_irdy), //out
   .treg_np            (treg_np), //out
   .treg_dest          (treg_dest), //out
   .treg_source        (treg_source), //out
   .treg_opcode        (treg_opcode), //out
   .treg_addrlen       (treg_addrlen), //out
   .treg_bar           (treg_bar), //out
   .treg_tag           (treg_tag), //out
   .treg_be            (treg_be), //out
   .treg_fid           (treg_fid), //out
   .treg_addr          (treg_addr), //out
   .treg_wdata         (treg_wdata), //out
   .treg_eh            (treg_eh), //out
   .treg_ext_header    (treg_ext_header), //out
   .treg_eh_discard    (treg_eh_discard), //out


   .mreg_irdy          (),
   .mreg_npwrite       (),
   .mreg_dest          (),
   .mreg_source        (),
   .mreg_opcode        (),
   .mreg_addrlen       (),
   .mreg_bar           (),
   .mreg_tag           (),
   .mreg_be            (),
   .mreg_fid           (),
   .mreg_addr          (),
   .mreg_wdata         (),
   .mreg_trdy          (mreg_trdy), //out
   .mreg_pmsgip        (mreg_pmsgip), //out
   .mreg_nmsgip        (mreg_nmsgip), //out

   .tx_ext_headers     (),

   .cgctrl_idlecnt     (),
   .cgctrl_clkgaten    (),
   .cgctrl_clkgatedef  (),

   .visa_all_disable   (),
   .visa_customer_disable (),
   .avisa_data_out     (),
   .avisa_clk_out      (), //out
   .visa_ser_cfg_in    (), //out

   .visa_port_tier1_sb (), //out
   .visa_fifo_tier1_sb (), //out
   .visa_fifo_tier1_ag (), //out
   .visa_agent_tier1_ag (), //out
   .visa_reg_tier1_ag  (), //out


   .visa_port_tier2_sb (), //out
   .visa_fifo_tier2_sb (), //out
   .visa_fifo_tier2_ag (), //out
   .visa_agent_tier2_ag (), //out
   .visa_reg_tier2_ag  (), //out

   .jta_clkgate_ovrd   (),
   .jta_force_clkreq   (),
   .jta_force_idle     (),
   .jta_force_notidle  (),
   .jta_force_creditreq (),
   .fscan_latchopen     (),
   .fscan_latchclosed_b (),
   .fscan_clkungate     (),
   .fscan_clkungate_syn (),
   .fscan_rstbypen      (),
   .fscan_byprst_b      (),
   .fscan_mode          (),
   .fscan_shiften       (),

   .fdfx_rst_b          ()

   );




endmodule


