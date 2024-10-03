

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

module sbe_wrapper 
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
   (
   // Clock/Reset Signals
   side_clk, 
   gated_side_clk,
   side_rst_b,
   
   agent_clk,    // AGENT clock/reset, only used
   //                             agent_rst_b,  // for asynch endpoint

   usyncselect,
   side_usync,
   agent_usync,

   // Clock gating ISM Signals (endpoint)
   agent_clkreq,
   agent_idle,
   side_ism_fabric,
   side_ism_agent,
   side_clkreq,
   side_clkack,
   side_ism_lock_b,  // SBC-PCN-002 - New ISM Lock for Power gating flows
   
   // Clock gating ISM Signals (agent block)
   sbe_clkreq,
   sbe_idle,
   sbe_clk_valid,
   
   // Egress port interface to the IOSF Sideband Channel
   mpccup,        //
   mnpcup,        //
   mpcput,        //
   mnpput,        //
   meom,          //
   mpayload,      //
   
   // Ingress port interface to the IOSF Sideband Channel
   tpccup,        //
   tnpcup,        //
   tpcput,        //
   tnpput,        //
   teom,          //
   tpayload,      //
   
   // Target interface to the agent block
   tmsg_pcfree,   //
   tmsg_npfree,   //
   tmsg_npclaim,  //
   tmsg_pcput,    //
   tmsg_npput,    //
   tmsg_pcmsgip,  //
   tmsg_npmsgip,  //
   tmsg_pceom,    //
   tmsg_npeom,    //
   tmsg_pcpayload,//
   tmsg_nppayload,//
   tmsg_pccmpl,   //
   tmsg_npvalid,
   tmsg_pcvalid,
   
   // Master interface to the agent block
   mmsg_pcirdy,   //
   mmsg_npirdy,   //
   mmsg_pceom,    //
   mmsg_npeom,    //
   mmsg_pcpayload,//
   mmsg_nppayload,//
   mmsg_pctrdy,   //
   mmsg_nptrdy,   //
   mmsg_pcmsgip,  //
   mmsg_npmsgip,  //
   mmsg_pcsel,    //
   mmsg_npsel,    //
   
   // Target Register Access Interface
   // From the agent block:
   treg_trdy,     // Ready to complete
   // register access msg
   treg_cerr,     // Completion error
   treg_rdata,    // Read data
   // From the endpoint
   treg_irdy,     // Endpoint ready
   treg_np,       // 1=non-posted/0=posted
   treg_dest,     // Destination Port ID
   treg_source,   // Source Port ID
   treg_opcode,   // Reg access opcode
   treg_addrlen,  // Address length
   treg_bar,      // Selected BAR
   treg_tag,      // Transaction tag
   treg_be,       // Byte enables
   treg_fid,      // Function ID
   treg_addr,     // Address
   treg_wdata,    // Write data
   treg_eh,       //   state of 'eh' bit in standard header
   treg_ext_header, // received extended headers
   treg_eh_discard, // indicates unsupported header discarded
   
   // Master Register Access Interface
   // From the agent block:
   mreg_irdy,     // Reg access msg ready
   mreg_npwrite,  // Np=1 / posted=0 write
   mreg_dest,     // Destination Port ID
   mreg_source,   // Source Port ID
   mreg_opcode,   // Reg Access Opcode
   mreg_addrlen,  // Address length
   mreg_bar,      // Selected BAR
   mreg_tag,      // Transaction tag
   mreg_be,       // Byte enables
   mreg_fid,      // Function ID
   mreg_addr,     // Address
   mreg_wdata,    // Write data
   // From the endpoint:
   mreg_trdy,     // Target (endpnt) ready
   mreg_pmsgip,   // Message in-progress
   mreg_nmsgip,   // indicators
   // non-posted message
   // extended header inputs.
   tx_ext_headers,
   
   // Config register Inputs
   cgctrl_idlecnt,   // Config
   cgctrl_clkgaten,  // registers
   cgctrl_clkgatedef,
   
   // DFx          
   visa_all_disable,
   visa_customer_disable,
   avisa_data_out,
   avisa_clk_out,
   visa_ser_cfg_in,
     
   visa_port_tier1_sb,      // VISA debug candidates
   visa_fifo_tier1_sb,     // high priority
   visa_fifo_tier1_ag,
   visa_agent_tier1_ag,
   visa_reg_tier1_ag,
  
   visa_port_tier2_sb,       // VISA debug candidates
   visa_fifo_tier2_sb,     // low priority
   visa_fifo_tier2_ag,
   visa_agent_tier2_ag,
   visa_reg_tier2_ag,
   
   jta_clkgate_ovrd, // JTAG overrides
   jta_force_clkreq, //
   jta_force_idle,   //
   jta_force_notidle,//
   jta_force_creditreq,
   fscan_latchopen,     //
   fscan_latchclosed_b, //
   fscan_clkungate,      // scan mode clock gate override
   fscan_clkungate_syn,
   fscan_rstbypen,
   fscan_byprst_b,
   fscan_mode,
   fscan_shiften,

   fdfx_rst_b            // New reset for VISA ULM
    ); 

`include "sbcglobal_params.vm"
`include "sbcstruct_local.vm"


   localparam TBE_WIDTH = MAXTRGTDATA == 31 ? 3 : 7;
   localparam MBE_WIDTH = MAXMSTRDATA == 31 ? 3 : 7;
   localparam TADR_WIDTH = MAXTRGTADDR < 15 ? 15 : MAXTRGTADDR > 47 ? 47 : MAXTRGTADDR;
   localparam MADR_WIDTH = MAXMSTRADDR < 15 ? 15 : MAXMSTRADDR > 47 ? 47 : MAXMSTRADDR;




  input  logic                           side_clk; 
  output logic                           gated_side_clk;
  input  logic                           side_rst_b;

  input  logic                           agent_clk;    // AGENT clock/reset; only used
//  input  logic                           agent_rst_b;  // for asynch endpoint

  input  logic                           usyncselect;
  input  logic                           side_usync;
  input  logic                           agent_usync;

  // Clock gating ISM Signals (endpoint)
  input  logic                           agent_clkreq;
  input  logic                           agent_idle;
  input  logic                     [2:0] side_ism_fabric;
  output logic                     [2:0] side_ism_agent;
  output logic                           side_clkreq;
  input  logic                           side_clkack;
  input  logic                           side_ism_lock_b; // SBC-PCN-002 - Sideband ISM Lock signal
  
  // Clock gating ISM Signals (agent block)
  output logic                           sbe_clkreq;
  output logic                           sbe_idle;
  output logic                           sbe_clk_valid;
  
  // Egress port interface to the IOSF Sideband Channel
  input  logic                           mpccup;        //
  input  logic                           mnpcup;        //
  output logic                           mpcput;        //
  output logic                           mnpput;        //
  output logic                           meom;          //
  output logic    [MAXPLDBIT:0]          mpayload;      //

  // Ingress port interface to the IOSF Sideband Channel
  output logic                           tpccup;        //
  output logic                           tnpcup;        //
  input  logic                           tpcput;        //
  input  logic                           tnpput;        //
  input  logic                           teom;          //
  input  logic    [MAXPLDBIT:0]          tpayload;      //

  // Target interface to the agent block
  input  logic             [MAXPCTRGT:0] tmsg_pcfree;   //
  input  logic             [MAXNPTRGT:0] tmsg_npfree;   //
  input  logic             [MAXNPTRGT:0] tmsg_npclaim;  //
  output logic                           tmsg_pcput;    //
  output logic                           tmsg_npput;    //
  output logic                           tmsg_pcmsgip;  //
  output logic                           tmsg_npmsgip;  //
  output logic                           tmsg_pceom;    //
  output logic                           tmsg_npeom;    //
  output logic                    [31:0] tmsg_pcpayload;//
  output logic                    [31:0] tmsg_nppayload;//
  output logic                           tmsg_pccmpl;   //
  output logic                           tmsg_npvalid;
  output logic                           tmsg_pcvalid;

  // Master interface to the agent block
  input  logic             [MAXPCMSTR:0] mmsg_pcirdy;   //
  input  logic             [MAXNPMSTR:0] mmsg_npirdy;   //
  input  logic             [MAXPCMSTR:0] mmsg_pceom;    //
  input  logic             [MAXNPMSTR:0] mmsg_npeom;    //
  input  logic       [32*MAXPCMSTR+31:0] mmsg_pcpayload;//
  input  logic       [32*MAXNPMSTR+31:0] mmsg_nppayload;//
  output logic                           mmsg_pctrdy;   //
  output logic                           mmsg_nptrdy;   //
  output logic                           mmsg_pcmsgip;  //
  output logic                           mmsg_npmsgip;  //
  output logic             [MAXPCMSTR:0] mmsg_pcsel;    //
  output logic             [MAXNPMSTR:0] mmsg_npsel;    //

  // Target Register Access Interface
                                                        // From the agent block:
  input  logic                           treg_trdy;     // Ready to complete
                                                        // register access msg
  input  logic                           treg_cerr;     // Completion error
  input  logic [MAXTRGTDATA:0]           treg_rdata;    // Read data
                                                        // From the endpoint
  output logic                           treg_irdy;     // Endpoint ready
  output logic                           treg_np;       // 1=non-posted/0=posted
  output logic                     [7:0] treg_dest;     // Destination Port ID
  output logic                     [7:0] treg_source;   // Source Port ID
  output logic                     [7:0] treg_opcode;   // Reg access opcode
  output logic                           treg_addrlen;  // Address length
  output logic                     [2:0] treg_bar;      // Selected BAR
  output logic                     [2:0] treg_tag;      // Transaction tag
  output logic [TBE_WIDTH:0]             treg_be;       // Byte enables
  output logic                     [7:0] treg_fid;      // Function ID
  output logic [TADR_WIDTH:0]            treg_addr;     // Address
  output logic [MAXTRGTDATA:0]           treg_wdata;    // Write data
  output logic                           treg_eh;       //   state of 'eh' bit in standard header
  output logic [NUM_RX_EXT_HEADERS:0][31:0] treg_ext_header; // received extended headers
  output logic                           treg_eh_discard; // indicates unsupported header discarded
   
  // Master Register Access Interface
                                                        // From the agent block:
  input  logic                           mreg_irdy;     // lintra s-0527, s-70036 Reg access msg ready
  input  logic                           mreg_npwrite;  // lintra s-0527, s-70036 Np=1 / posted=0 write
  input  logic                     [7:0] mreg_dest;     // lintra s-0527, s-70036 Destination Port ID
  input  logic                     [7:0] mreg_source;   // lintra s-0527, s-70036 Source Port ID
  input  logic                     [7:0] mreg_opcode;   // lintra s-0527, s-70036 Reg Access Opcode
  input  logic                           mreg_addrlen;  // lintra s-0527, s-70036 Address length
  input  logic                     [2:0] mreg_bar;      // lintra s-0527, s-70036 Selected BAR
  input  logic                     [2:0] mreg_tag;      // lintra s-0527, s-70036 Transaction tag
  input  logic [MBE_WIDTH:0]             mreg_be;       // lintra s-0527, s-70036 Byte enables
  input  logic                     [7:0] mreg_fid;      // lintra s-0527, s-70036 Function ID
  input  logic [MADR_WIDTH:0]            mreg_addr;     // lintra s-0527, s-70036 Address
  input  logic [MAXMSTRDATA:0]           mreg_wdata;    // lintra s-0527, s-70036 Write data
                                                        // From the endpoint:
  output logic                           mreg_trdy;     // Target (endpnt) ready
  output logic                           mreg_pmsgip;   // Message in-progress
  output logic                           mreg_nmsgip;   // indicators
                                                        // non-posted message
  // extended header inputs.
  input  logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers;
  
  // Config register Inputs
  input  logic                     [7:0] cgctrl_idlecnt;   // Config
  input  logic                           cgctrl_clkgaten;  // registers
  input  logic                           cgctrl_clkgatedef;
                  
  // DFx          
  input logic                                                                visa_all_disable;      // lintra s-0527, s-70036 "Used when ULM is inserted into endpoint"
  input logic                                                                visa_customer_disable; // lintra s-0527, s-70036 "Used when ULM is inserted into endpoint"
  output logic [(NUMBER_OF_OUTPUT_LANES-1):0][(NUMBER_OF_BITS_PER_LANE-1):0] avisa_data_out;        // lintra s-2058 "Used when ULM is inserted into endpoint"
  output logic [(NUMBER_OF_OUTPUT_LANES-1):0]                                avisa_clk_out;         // lintra s-2058 "Used when ULM is inserted into endpoint"
  input logic [2:0]                                                          visa_ser_cfg_in;       // lintra s-0527, s-70036 "Used when ULM is inserted into endpoint"
  
  output visa_port_tier1                 visa_port_tier1_sb;      // VISA debug candidates
  output visa_epfifo_tier1_sb            visa_fifo_tier1_sb;     // high priority
  output visa_epfifo_tier1_ag            visa_fifo_tier1_ag;
  output visa_agent_tier1                visa_agent_tier1_ag; 
  output visa_reg_tier1                  visa_reg_tier1_ag;
  
  output visa_port_tier2                 visa_port_tier2_sb;       // VISA debug candidates
  output visa_epfifo_tier2_sb            visa_fifo_tier2_sb;     // low priority
  output visa_epfifo_tier2_ag            visa_fifo_tier2_ag;
  output visa_agent_tier2                visa_agent_tier2_ag;
  output visa_reg_tier2                  visa_reg_tier2_ag;

  input  logic                           jta_clkgate_ovrd; // JTAG overrides
  input  logic                           jta_force_clkreq; //
  input  logic                           jta_force_idle;   //
  input  logic                           jta_force_notidle;//
  input  logic                           jta_force_creditreq;
  input  logic                           fscan_latchopen;     //
  input  logic                           fscan_latchclosed_b; //
  input  logic                           fscan_clkungate;      // scan mode clock gate override
  input  logic                           fscan_clkungate_syn;
  input  logic                           fscan_rstbypen;
  input  logic                           fscan_byprst_b;
  input  logic                           fscan_shiften;
  input  logic                           fscan_mode;
  input  logic                           fdfx_rst_b; // lintra s-0527, s-70036 "Used by VISA ULM when inserted"



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
   .side_clk           (side_clk),
   .gated_side_clk     (gated_side_clk), //out
   .side_rst_b         (side_rst_b),

   .agent_clk          (agent_clk),
   .usyncselect        (usyncselect),
   .side_usync         (side_usync),
   .agent_usync        (agent_usync),

   .agent_clkreq       (agent_clkreq),
   .agent_idle         (agent_idle),
   .side_ism_fabric    (side_ism_fabric),
   .side_ism_agent     (side_ism_agent), //out
   .side_clkreq        (side_clkreq), //out
   .side_clkack        (side_clkack),
   .side_ism_lock_b    (side_ism_lock_b),

   .sbe_clkreq         (sbe_clkreq), //out
   .sbe_idle           (sbe_idle), //out
   .sbe_clk_valid      (sbe_clk_valid), //out

   .mpccup             (mpccup),
   .mnpcup             (mnpcup),
   .mpcput             (mpcput), //out
   .mnpput             (mnpput), //out
   .meom               (meom), //out
   .mpayload           (mpayload), //out

   .tpccup             (tpccup), //out
   .tnpcup             (tnpcup), //out
   .tpcput             (tpcput),
   .tnpput             (tnpput),
   .teom               (teom),
   .tpayload           (tpayload),


   .tmsg_pcfree        (tmsg_pcfree),
   .tmsg_npfree        (tmsg_npfree),
   .tmsg_npclaim       (tmsg_npclaim),
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

   .mmsg_pcirdy        (mmsg_pcirdy),
   .mmsg_npirdy        (mmsg_npirdy),
   .mmsg_pceom         (mmsg_pceom),
   .mmsg_npeom         (mmsg_npeom),
   .mmsg_pcpayload     (mmsg_pcpayload),
   .mmsg_nppayload     (mmsg_nppayload),
   .mmsg_pctrdy        (mmsg_pctrdy), //out
   .mmsg_nptrdy        (mmsg_nptrdy), //out
   .mmsg_pcmsgip       (mmsg_pcmsgip), //out
   .mmsg_npmsgip       (mmsg_npmsgip), //out
   .mmsg_pcsel         (mmsg_pcsel), //out
   .mmsg_npsel         (mmsg_npsel), //out

   .treg_trdy          (treg_trdy),
   .treg_cerr          (treg_cerr),
   .treg_rdata         (treg_rdata),
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


   .mreg_irdy          (mreg_irdy),
   .mreg_npwrite       (mreg_npwrite),
   .mreg_dest          (mreg_dest),
   .mreg_source        (mreg_source),
   .mreg_opcode        (mreg_opcode),
   .mreg_addrlen       (mreg_addrlen),
   .mreg_bar           (mreg_bar),
   .mreg_tag           (mreg_tag),
   .mreg_be            (mreg_be),
   .mreg_fid           (mreg_fid),
   .mreg_addr          (mreg_addr),
   .mreg_wdata         (mreg_wdata),
   .mreg_trdy          (mreg_trdy), //out
   .mreg_pmsgip        (mreg_pmsgip), //out
   .mreg_nmsgip        (mreg_nmsgip), //out

   .tx_ext_headers     (tx_ext_headers),

   .cgctrl_idlecnt     (cgctrl_idlecnt),
   .cgctrl_clkgaten    (cgctrl_clkgaten),
   .cgctrl_clkgatedef  (cgctrl_clkgatedef),

   .visa_all_disable   (visa_all_disable),
   .visa_customer_disable (visa_customer_disable),
   .avisa_data_out     (avisa_data_out),
   .avisa_clk_out      (avisa_clk_out), //out
   .visa_ser_cfg_in    (visa_ser_cfg_in), //out

   .visa_port_tier1_sb (visa_port_tier1_sb), //out
   .visa_fifo_tier1_sb (visa_fifo_tier1_sb), //out
   .visa_fifo_tier1_ag (visa_fifo_tier1_ag), //out
   .visa_agent_tier1_ag (visa_agent_tier1_ag), //out
   .visa_reg_tier1_ag  (visa_reg_tier1_ag), //out


   .visa_port_tier2_sb (visa_port_tier2_sb), //out
   .visa_fifo_tier2_sb (visa_fifo_tier2_sb), //out
   .visa_fifo_tier2_ag (visa_fifo_tier2_ag), //out
   .visa_agent_tier2_ag (visa_agent_tier2_ag), //out
   .visa_reg_tier2_ag  (visa_reg_tier2_ag), //out

   .jta_clkgate_ovrd   (jta_clkgate_ovrd),
   .jta_force_clkreq   (jta_force_clkreq),
   .jta_force_idle     (jta_force_idle),
   .jta_force_notidle  (jta_force_notidle),
   .jta_force_creditreq (jta_force_creditreq),
   .fscan_latchopen     (fscan_latchopen),
   .fscan_latchclosed_b (fscan_latchclosed_b),
   .fscan_clkungate     (fscan_clkungate),
   .fscan_clkungate_syn (fscan_clkungate_syn),
   .fscan_rstbypen      (fscan_rstbypen),
   .fscan_byprst_b      (fscan_byprst_b),
   .fscan_mode          (fscan_mode),
   .fscan_shiften       (fscan_shiften),

   .fdfx_rst_b          (fdfx_rst_b)

   );




endmodule


