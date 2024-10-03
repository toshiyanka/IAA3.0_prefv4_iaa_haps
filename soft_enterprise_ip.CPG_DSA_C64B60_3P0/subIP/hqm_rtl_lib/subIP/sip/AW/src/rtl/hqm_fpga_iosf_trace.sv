module hqm_fpga_iosf_trace # (
     parameter SBE_DATAWIDTH = 8
    ,parameter MAX_DATA_LEN = 9
    ,parameter RS_WIDTH = 0
    ,parameter AGENT_WIDTH = 0
    ,parameter DST_ID_WIDTH = 13
    ,parameter MMAX_ADDR = 63
    ,parameter SRC_ID_WIDTH = 13
    ,parameter SAI_WIDTH = 7
    ,parameter PASIDTLP_WIDTH = 22
    ,parameter MD_WIDTH = 255
    ,parameter MDP_WIDTH = 0
    ,parameter TMAX_ADDR = 63
    ,parameter TD_WIDTH = 255
    ,parameter TDP_WIDTH = 0
) (
  input logic i2c_clk
, input logic i2c_rst_n
, input logic [ ( 32 ) - 1 : 0 ] i2c_ctrl
, output  logic [ ( 32 ) - 1 : 0 ] i2c_data

    //---------------------------------------------------------------------------------------------
    // IOSF Sideband CDC signals

    ,input  logic                                   side_pok
    ,input  logic                                   side_clk
    ,input  logic                                   side_clkreq
    ,input  logic                                   side_clkack
    ,input  logic                                   side_rst_b
    ,input  logic   [2:0]                           gpsb_side_ism_fabric
    ,input  logic   [2:0]                           gpsb_side_ism_agent
    ,input  logic                                   side_pwrgate_pmc_wake

    //---------------------------------------------------------------------------------------------
    // Egress port interface to the IOSF Sideband Channel

    ,input  logic                                   gpsb_mpccup
    ,input  logic                                   gpsb_mnpcup

    ,input  logic                                   gpsb_mpcput
    ,input  logic                                   gpsb_mnpput
    ,input  logic                                   gpsb_meom
    ,input  logic   [SBE_DATAWIDTH-1:0]             gpsb_mpayload
    ,input  logic                                   gpsb_mparity

    //---------------------------------------------------------------------------------------------
    // Ingress port interface to the IOSF Sideband Channel

    ,input  logic                                   gpsb_tpccup
    ,input  logic                                   gpsb_tnpcup

    ,input  logic                                   gpsb_tpcput
    ,input  logic                                   gpsb_tnpput
    ,input  logic                                   gpsb_teom
    ,input  logic   [SBE_DATAWIDTH-1:0]             gpsb_tpayload
    ,input  logic                                   gpsb_tparity

    //---------------------------------------------------------------------------------------------
    // IOSF Primary CDC signals

    ,input  wire                                    prim_pok
    ,input  wire                                    prim_freerun_clk
    ,input  wire                                    prim_gated_clk
    ,input  wire                                    prim_nonflr_clk
    ,input  wire                                    prim_clkreq
    ,input  wire                                    prim_clkack
    ,input  wire                                    prim_clk_enable
    ,input  wire                                    prim_clk_enable_cdc
    ,input  wire                                    prim_clk_enable_sys
    ,input  wire                                    prim_clk_ungate
    ,input  wire                                    prim_rst_b
    ,input  wire                                    prim_gated_rst_b
    ,input  wire    [2:0]                           prim_ism_fabric
    ,input  wire    [2:0]                           prim_ism_agent
    ,input  wire                                    prim_pwrgate_pmc_wake

    ,input  wire                                    flr_triggered

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Request Bus Signals

    ,input  wire                                    req_put                 // req: Request Put
    ,input  wire    [1:0]                           req_rtype               // req: Request Type
    ,input  wire                                    req_cdata               // req: Request Contains Data
    ,input  wire    [MAX_DATA_LEN:0]                req_dlen                // req: Request Data Length
    ,input  wire    [3:0]                           req_tc                  // req: Request Traffic Class
    ,input  wire                                    req_ns                  // req: Request Non-Snoop
    ,input  wire                                    req_ro                  // req: Request Relaxed Order
    ,input  wire                                    req_ido                 // opt: Req ID Based Ordering
    ,input  wire    [15:0]                          req_id                  // opt: Req ID Based Ordering
    ,input  wire                                    req_locked              // req: Request Locked
    ,input  wire                                    req_chain               // opt: Request Chain
    ,input  wire                                    req_opp                 // opt: Request Opportunistic
    ,input  wire    [RS_WIDTH:0]                    req_rs                  // opt: Request Root_Space
    ,input  wire    [AGENT_WIDTH:0]                 req_agent               // opt: Request agent Speccapture_ific
    ,input  wire    [DST_ID_WIDTH:0]                req_dest_id             // opt: Destination ID (src dec)

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Speccapture_ific Control Signals

    ,input  wire                                    gnt                     // req: Grant
    ,input  wire    [1:0]                           gnt_rtype               // req: Grant Request Type
    ,input  wire    [1:0]                           gnt_type                // req: Grant Type

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Command Signals

    ,input  wire    [1:0]                           mfmt                    // req: Fmt
    ,input  wire    [4:0]                           mtype                   // req: Type
    ,input  wire    [3:0]                           mtc                     // req: Traffic Class
    ,input  wire                                    mth                     // opt: Transaction Hint
    ,input  wire                                    mep                     // opt: Error Present
    ,input  wire                                    mro                     // req: Relaxed Ordering
    ,input  wire                                    mns                     // req: Non-Snoop
    ,input  wire                                    mido                    // opt: ID Based Ordering
    ,input  wire    [1:0]                           mat                     // opt: Adrs Translation Svc
    ,input  wire    [9:0]                           mlength                 // req: Length
    ,input  wire    [15:0]                          mrqid                   // req: Requester ID
    ,input  wire    [7:0]                           mtag                    // req: Tag
    ,input  wire    [3:0]                           mlbe                    // req: Last DW Byte Enable
    ,input  wire    [3:0]                           mfbe                    // req: First DW Byte Enable
    ,input  wire    [MMAX_ADDR:0]                   maddress                // req: Address
    ,input  wire    [RS_WIDTH:0]                    mrs                     // opt: Root Space of address
    ,input  wire                                    mtd                     // opt: TLP Digest
    ,input  wire    [31:0]                          mecrc                   // opt: End to End CRC
    ,input  wire                                    mcparity                // req: Command Parity
    ,input  wire    [SRC_ID_WIDTH:0]                msrc_id                 // opt: Source ID (peer-to-peer)
    ,input  wire    [DST_ID_WIDTH:0]                mdest_id                // opt: Destination ID (src dec)
    ,input  wire    [SAI_WIDTH:0]                   msai                    // opt: Sec Attr of Initiator
    ,input  wire    [PASIDTLP_WIDTH:0]              mpasidtlp               // opt: Process Address Space ID TLP
    ,input  wire                                    mrsvd1_7                // opt: Tag[9]
    ,input  wire                                    mrsvd1_3                // opt: Tag[8]

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Data Signals

    ,input  wire    [MD_WIDTH:0]                    mdata                   // req: Data
    ,input  wire    [MDP_WIDTH:0]                   mdparity                // req: Data Parity

    //---------------------------------------------------------------------------------------------
    // IOSF Primary 3.4 Target Interface - Credit Exchange Signals

    ,input  wire                                    credit_put              // req: Credit Update Put
    ,input  wire    [1:0]                           credit_rtype            // req: CUP Request Type
    ,input  wire                                    credit_cmd              // req: Cmd  Cred Increment
    ,input  wire    [2:0]                           credit_data             // req: Data Cred Increment

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Decode Signals

    ,input  wire                                    tdec                    // req: Target Decode
    ,input wire    [0:0]                           hit                     // opt: Hit
    ,input wire    [0:0]                           sub_hit                 // opt: Subtractive Hit

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Command Interface

    ,input  wire                                    cmd_put                 // req: Command Put
    ,input  wire    [1:0]                           cmd_rtype               // req: Put Request Type
    ,input  wire                                    cmd_nfs_err             // opt: Non-Func Specific Err
    ,input  wire    [1:0]                           tfmt                    // req: Fmt
    ,input  wire    [4:0]                           ttype                   // req: Type
    ,input  wire    [3:0]                           ttc                     // req: Traffic Class
    ,input  wire                                    tth                     // opt: Transaction Hint
    ,input  wire                                    tep                     // opt: Error Present
    ,input  wire                                    tro                     // req: Relaxed Ordering
    ,input  wire                                    tns                     // req: Non-Snoop
    ,input  wire                                    tido                    // opt: ID Based Ordering
    ,input  wire                                    tchain                  // opt: Chain
    ,input  wire    [1:0]                           tat                     // opt: Adrs Translation Svc
    ,input  wire    [9:0]                           tlength                 // req: Length
    ,input  wire    [15:0]                          trqid                   // req: Requester ID
    ,input  wire    [7:0]                           ttag                    // req: Tag
    ,input  wire    [3:0]                           tlbe                    // req: Last DW Byte Enable
    ,input  wire    [3:0]                           tfbe                    // req: First DW Byte Enable
    ,input  wire    [TMAX_ADDR:0]                   taddress                // req: Address
    ,input  wire    [RS_WIDTH:0]                    trs                     // opt: root space of address
    ,input  wire                                    ttd                     // opt: TLP Digest
    ,input  wire    [31:0]                          tecrc                   // opt: End to End CRC
    ,input  wire                                    tcparity                // opt: Command Parity
    ,input  wire    [SRC_ID_WIDTH:0]                tsrc_id                 // opt: Source ID (peer-to-peer)
    ,input  wire    [DST_ID_WIDTH:0]                tdest_id                // opt: Destination ID (src dec)
    ,input  wire    [SAI_WIDTH:0]                   tsai                    // opt: Sec Attr of Initiator
    ,input  wire    [PASIDTLP_WIDTH:0]              tpasidtlp               // opt: Process Address Space ID TLP
    ,input  wire                                    trsvd1_7                // opt: Tag[9]
    ,input  wire                                    trsvd1_3                // opt: Tag[8]

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Data Interface

    ,input  wire    [TD_WIDTH:0]                    tdata                   // req: Data
    ,input  wire    [TDP_WIDTH:0]                   tdparity                // opt: Data Parity

    //---------------------------------------------------------------------------------------------
    // APB interface

    ,input logic                                   psel
    ,input logic                                   penable
    ,input logic                                   pwrite
    ,input logic   [31:0]                          paddr
    ,input logic   [31:0]                          pwdata
    ,input logic   [19:0]                          puser

    ,input  logic                                   pready
    ,input  logic                                   pslverr
    ,input  logic   [31:0]                          prdata
    ,input  logic                                   prdata_par

    //---------------------------------------------------------------------------------------------
    // MASTER interface

    ,input logic [1:0]          pm_state
    ,input  logic                                   pm_fsm_d0tod3_ok
    ,input  logic                                   pm_fsm_d3tod0_ok
    ,input  logic                                   pm_fsm_in_run
    ,input  logic                                   pm_allow_ing_drop

    ,input  logic                                   hqm_proc_reset_done
    ,input  logic                                   hqm_proc_idle
    ,input  logic                                   hqm_flr_prep

    ,input logic                                   master_ctl_load
    ,input logic [31:0]                            master_ctl

    ,input logic                                   master_trigger_ctl_load
    ,input logic [31:0]                            master_trigger_ctl

) ;

typedef struct packed {

    logic                                   side_pok ;
    logic                                   side_clk ;
    logic                                   side_clkreq ;
    logic                                   side_clkack ;
    logic                                   side_rst_b ;
    logic   [2:0]                           gpsb_side_ism_fabric ;
    logic   [2:0]                           gpsb_side_ism_agent ;
    logic                                   side_pwrgate_pmc_wake ;

    //---------------------------------------------------------------------------------------------
    // Egress port interface to the IOSF Sideband Channel

    logic                                   gpsb_mpccup ;
    logic                                   gpsb_mnpcup ;

    logic                                   gpsb_mpcput ;
    logic                                   gpsb_mnpput ;
    logic                                   gpsb_meom ;
    logic   [SBE_DATAWIDTH-1:0]             gpsb_mpayload ;
    logic                                   gpsb_mparity ;

    //---------------------------------------------------------------------------------------------
    // Ingress port interface to the IOSF Sideband Channel

    logic                                   gpsb_tpccup ;
    logic                                   gpsb_tnpcup ;

    logic                                   gpsb_tpcput ;
    logic                                   gpsb_tnpput ;
    logic                                   gpsb_teom ;
    logic   [SBE_DATAWIDTH-1:0]             gpsb_tpayload ;
    logic                                   gpsb_tparity ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary CDC signals

    logic                                    prim_pok ;
    logic                                    prim_freerun_clk ;
    logic                                    prim_gated_clk ;
    logic                                    prim_nonflr_clk ;
    logic                                    prim_clkreq ;
    logic                                    prim_clkack ;
    logic                                    prim_clk_enable ;
    logic                                    prim_clk_enable_cdc ;
    logic                                    prim_clk_enable_sys ;
    logic                                    prim_clk_ungate ;
    logic                                    prim_rst_b ;
    logic                                    prim_gated_rst_b ;
    logic    [2:0]                           prim_ism_fabric ;
    logic    [2:0]                           prim_ism_agent ;
    logic                                    prim_pwrgate_pmc_wake ;

    logic                                    flr_triggered ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Request Bus Signals

    logic                                    req_put         ;   
    logic    [1:0]                           req_rtype         ; 
    logic                                    req_cdata          ;
    logic    [MAX_DATA_LEN:0]                req_dlen           ;
    logic    [3:0]                           req_tc             ;
    logic                                    req_ns             ;
    logic                                    req_ro             ;
    logic                                    req_ido            ;
    logic    [15:0]                          req_id             ;
    logic                                    req_locked         ;
    logic                                    req_chain          ;
    logic                                    req_opp            ;
    logic    [RS_WIDTH:0]                    req_rs             ;
    logic    [AGENT_WIDTH:0]                 req_agent          ;
    logic    [DST_ID_WIDTH:0]                req_dest_id        ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Speccapture_ific Control Signals

    logic                                    gnt                ;
    logic    [1:0]                           gnt_rtype          ;
    logic    [1:0]                           gnt_type           ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Command Signals

    logic    [1:0]                           mfmt               ;
    logic    [4:0]                           mtype              ;
    logic    [3:0]                           mtc                ;
    logic                                    mth                ;
    logic                                    mep                ;
    logic                                    mro                ;
    logic                                    mns                ;
    logic                                    mido               ;
    logic    [1:0]                           mat                ;
    logic    [9:0]                           mlength            ;
    logic    [15:0]                          mrqid              ;
    logic    [7:0]                           mtag               ;
    logic    [3:0]                           mlbe               ;
    logic    [3:0]                           mfbe               ;
    logic    [MMAX_ADDR:0]                   maddress           ;
    logic    [RS_WIDTH:0]                    mrs                ;
    logic                                    mtd                ;
    logic    [31:0]                          mecrc              ;
    logic                                    mcparity           ;
    logic    [SRC_ID_WIDTH:0]                msrc_id            ;
    logic    [DST_ID_WIDTH:0]                mdest_id           ;
    logic    [SAI_WIDTH:0]                   msai               ;
    logic    [PASIDTLP_WIDTH:0]              mpasidtlp          ;
    logic                                    mrsvd1_7           ;
    logic                                    mrsvd1_3           ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Data Signals

    logic    [MD_WIDTH:0]                    mdata              ;
    logic    [MDP_WIDTH:0]                   mdparity           ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary 3.4 Target Interface - Credit Exchange Signals

    logic                                    credit_put         ;
    logic    [1:0]                           credit_rtype       ;
    logic                                    credit_cmd         ;
    logic    [2:0]                           credit_data        ;


    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Decode Signals

    logic                                   tdec               ;
    logic    [0:0]                           hit                ;
    logic    [0:0]                           sub_hit            ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Command Interface

    logic                                   cmd_put            ;
    logic   [1:0]                           cmd_rtype          ;
    logic                                   cmd_nfs_err        ;
    logic   [1:0]                           tfmt               ;
    logic   [4:0]                           ttype              ;
    logic   [3:0]                           ttc                ;
    logic                                   tth                ;
    logic                                   tep                ;
    logic                                   tro                ;
    logic                                   tns                ;
    logic                                   tido               ;
    logic                                   tchain             ;
    logic   [1:0]                           tat                ;
    logic   [9:0]                           tlength            ;
    logic   [15:0]                          trqid              ;
    logic   [7:0]                           ttag               ;
    logic   [3:0]                           tlbe               ;
    logic   [3:0]                           tfbe               ;
    logic   [TMAX_ADDR:0]                   taddress           ;
    logic   [RS_WIDTH:0]                    trs                ;
    logic                                   ttd                ;
    logic   [31:0]                          tecrc              ;
    logic                                   tcparity           ;
    logic   [SRC_ID_WIDTH:0]                tsrc_id            ;
    logic   [DST_ID_WIDTH:0]                tdest_id           ;
    logic   [SAI_WIDTH:0]                   tsai               ;
    logic   [PASIDTLP_WIDTH:0]              tpasidtlp          ;
    logic                                   trsvd1_7           ;
    logic                                   trsvd1_3           ;

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Data Interface

    logic   [TD_WIDTH:0]                    tdata              ;
    logic   [TDP_WIDTH:0]                   tdparity           ;


    //---------------------------------------------------------------------------------------------
    // APB interface

    logic                                   psel        ;
    logic                                   penable        ;
    logic                                   pwrite        ;
    logic   [31:0]                          paddr        ;
    logic   [31:0]                          pwdata        ;
    logic   [19:0]                          puser        ;

    logic                                   pready        ;
    logic                                   pslverr        ;
    logic   [31:0]                          prdata        ;
    logic                                   prdata_par        ;


    //---------------------------------------------------------------------------------------------
    // MASTER interface

    logic [1:0]          pm_state ;
    logic                                   pm_fsm_d0tod3_ok ;
    logic                                   pm_fsm_d3tod0_ok ;
    logic                                   pm_fsm_in_run ;
    logic                                   pm_allow_ing_drop ;

    logic                                   hqm_proc_reset_done ;
    logic                                   hqm_proc_idle ;
    logic                                   hqm_flr_prep ;

    logic                                   master_ctl_load ;
    logic [31:0]                            master_ctl ;

    logic                                   master_trigger_ctl_load ;
    logic [31:0]                            master_trigger_ctl ;

    logic [ ( 32 ) - 1 : 0 ] timer_f ;

} capture_t;

localparam DEPTH = 32 ;
logic trigger;
logic [ ( 32 ) - 1 : 0 ] timer_f , timer_nxt ;
logic [ ( 32 ) - 1 : 0 ] word_f , word_nxt ;
capture_t capture_mem_f  [ ( DEPTH ) - 1 : 0 ] ;
capture_t capture_mem_nxt  [ ( DEPTH ) - 1 : 0 ] ;
capture_t capture_if_f ;
capture_t capture_if_nxt ;
always_ff @(posedge i2c_clk or negedge i2c_rst_n) begin
  if ( ~ i2c_rst_n ) begin
    timer_f <= '0 ;
    word_f <= '0 ;
    for (int i=0; i<DEPTH; i=i+1) begin
      capture_mem_f [ i ] <= '0 ;
    end
    capture_if_f <= '0 ;
  end else begin
    timer_f <= timer_nxt ;
    word_f <= word_nxt ;
    for (int i=0; i<DEPTH; i=i+1) begin
      capture_mem_f [ i ] <= capture_mem_nxt [ i ] ;
    end
    capture_if_f <= capture_if_nxt ;
  end
end

always_comb begin

  //default value
  i2c_data = '0;
  word_nxt = word_f ;
  for (int i=0; i<DEPTH; i=i+1) begin
    capture_mem_nxt [ i ] = capture_mem_f [ i ] ;
  end
  timer_nxt = timer_f + 32'd1 ;

  //load interface into if storage register
  capture_if_nxt = capture_if_f ;
  capture_if_nxt.side_pok = side_pok ;
  capture_if_nxt.side_clk = side_clk ;
  capture_if_nxt.side_clkreq = side_clkreq ;
  capture_if_nxt.side_clkack = side_clkack ;
  capture_if_nxt.side_rst_b = side_rst_b ;
  capture_if_nxt.gpsb_side_ism_fabric = gpsb_side_ism_fabric ;
  capture_if_nxt.gpsb_side_ism_agent = gpsb_side_ism_agent ;
  capture_if_nxt.side_pwrgate_pmc_wake = side_pwrgate_pmc_wake ;
  capture_if_nxt.gpsb_mpccup = gpsb_mpccup ;
  capture_if_nxt.gpsb_mnpcup = gpsb_mnpcup ;
  capture_if_nxt.gpsb_mpcput = gpsb_mpcput ;
  capture_if_nxt.gpsb_mnpput = gpsb_mnpput ;
  capture_if_nxt.gpsb_meom = gpsb_meom ;
  capture_if_nxt.gpsb_mpayload = gpsb_mpayload ;
  capture_if_nxt.gpsb_mparity = gpsb_mparity ;
  capture_if_nxt.gpsb_tpccup = gpsb_tpccup ;
  capture_if_nxt.gpsb_tnpcup = gpsb_tnpcup ;
  capture_if_nxt.gpsb_tpcput = gpsb_tpcput ;
  capture_if_nxt.gpsb_tnpput = gpsb_tnpput ;
  capture_if_nxt.gpsb_teom = gpsb_teom ;
  capture_if_nxt.gpsb_tpayload = gpsb_tpayload ;
  capture_if_nxt.gpsb_tparity = gpsb_tparity ;
  capture_if_nxt.prim_pok = prim_pok ;
  capture_if_nxt.prim_freerun_clk = prim_freerun_clk ;
  capture_if_nxt.prim_gated_clk = prim_gated_clk ;
  capture_if_nxt.prim_nonflr_clk = prim_nonflr_clk ;
  capture_if_nxt.prim_clkreq = prim_clkreq ;
  capture_if_nxt.prim_clkack = prim_clkack ;
  capture_if_nxt.prim_clk_enable = prim_clk_enable ;
  capture_if_nxt.prim_clk_enable_cdc = prim_clk_enable_cdc ;
  capture_if_nxt.prim_clk_enable_sys = prim_clk_enable_sys ;
  capture_if_nxt.prim_clk_ungate = prim_clk_ungate ;
  capture_if_nxt.prim_rst_b = prim_rst_b ;
  capture_if_nxt.prim_gated_rst_b = prim_gated_rst_b ;
  capture_if_nxt.prim_ism_fabric = prim_ism_fabric ;
  capture_if_nxt.prim_ism_agent = prim_ism_agent ;
  capture_if_nxt.prim_pwrgate_pmc_wake = prim_pwrgate_pmc_wake ;
  capture_if_nxt.flr_triggered = flr_triggered ;
  capture_if_nxt.req_put = req_put ;
  capture_if_nxt.req_rtype = req_rtype ;
  capture_if_nxt.req_cdata = req_cdata ;
  capture_if_nxt.req_dlen = req_dlen ;
  capture_if_nxt.req_tc = req_tc ;
  capture_if_nxt.req_ns = req_ns ;
  capture_if_nxt.req_ro = req_ro ;
  capture_if_nxt.req_ido = req_ido ;
  capture_if_nxt.req_id = req_id ;
  capture_if_nxt.req_locked = req_locked ;
  capture_if_nxt.req_chain = req_chain ;
  capture_if_nxt.req_opp = req_opp ;
  capture_if_nxt.req_rs = req_rs ;
  capture_if_nxt.req_agent = req_agent ;
  capture_if_nxt.req_dest_id = req_dest_id ;
  capture_if_nxt.gnt = gnt ;
  capture_if_nxt.gnt_rtype = gnt_rtype ;
  capture_if_nxt.gnt_type = gnt_type ;
  capture_if_nxt.mfmt = mfmt ;
  capture_if_nxt.mtype = mtype ;
  capture_if_nxt.mtc = mtc ;
  capture_if_nxt.mth = mth ;
  capture_if_nxt.mep = mep ;
  capture_if_nxt.mro = mro ;
  capture_if_nxt.mns = mns ;
  capture_if_nxt.mido = mido ;
  capture_if_nxt.mat = mat ;
  capture_if_nxt.mlength = mlength ;
  capture_if_nxt.mrqid = mrqid ;
  capture_if_nxt.mtag = mtag ;
  capture_if_nxt.mlbe = mlbe ;
  capture_if_nxt.mfbe = mfbe ;
  capture_if_nxt.maddress = maddress ;
  capture_if_nxt.mrs = mrs ;
  capture_if_nxt.mtd = mtd ;
  capture_if_nxt.mecrc = mecrc ;
  capture_if_nxt.mcparity = mcparity ;
  capture_if_nxt.msrc_id = msrc_id ;
  capture_if_nxt.mdest_id = mdest_id ;
  capture_if_nxt.msai = msai ;
  capture_if_nxt.mpasidtlp = mpasidtlp ;
  capture_if_nxt.mrsvd1_7 = mrsvd1_7 ;
  capture_if_nxt.mrsvd1_3 = mrsvd1_3 ;
  capture_if_nxt.mdata = mdata ;
  capture_if_nxt.mdparity = mdparity ;
  capture_if_nxt.credit_put = credit_put ;
  capture_if_nxt.credit_rtype = credit_rtype ;
  capture_if_nxt.credit_cmd = credit_cmd ;
  capture_if_nxt.credit_data = credit_data ;
  capture_if_nxt.tdec = tdec ;
  capture_if_nxt.hit = hit ;
  capture_if_nxt.sub_hit = sub_hit ;
  capture_if_nxt.cmd_put = cmd_put ;
  capture_if_nxt.cmd_rtype = cmd_rtype ;
  capture_if_nxt.cmd_nfs_err = cmd_nfs_err ;
  capture_if_nxt.tfmt = tfmt ;
  capture_if_nxt.ttype = ttype ;
  capture_if_nxt.ttc = ttc ;
  capture_if_nxt.tth = tth ;
  capture_if_nxt.tep = tep ;
  capture_if_nxt.tro = tro ;
  capture_if_nxt.tns = tns ;
  capture_if_nxt.tido = tido ;
  capture_if_nxt.tchain = tchain ;
  capture_if_nxt.tat = tat ;
  capture_if_nxt.tlength = tlength ;
  capture_if_nxt.trqid = trqid ;
  capture_if_nxt.ttag = ttag ;
  capture_if_nxt.tlbe = tlbe ;
  capture_if_nxt.tfbe = tfbe ;
  capture_if_nxt.taddress = taddress ;
  capture_if_nxt.trs = trs ;
  capture_if_nxt.ttd = ttd ;
  capture_if_nxt.tecrc = tecrc ;
  capture_if_nxt.tcparity = tcparity ;
  capture_if_nxt.tsrc_id = tsrc_id ;
  capture_if_nxt.tdest_id = tdest_id ;
  capture_if_nxt.tsai = tsai ;
  capture_if_nxt.tpasidtlp = tpasidtlp ;
  capture_if_nxt.trsvd1_7 = trsvd1_7 ;
  capture_if_nxt.trsvd1_3 = trsvd1_3 ;
  capture_if_nxt.tdata = tdata ;
  capture_if_nxt.tdparity = tdparity ;
  capture_if_nxt.psel = psel ;
  capture_if_nxt.penable = penable ;
  capture_if_nxt.pwrite = pwrite ;
  capture_if_nxt.paddr = paddr ;
  capture_if_nxt.pwdata = pwdata ;
  capture_if_nxt.puser = puser ;
  capture_if_nxt.pready = pready ;
  capture_if_nxt.pslverr = pslverr ;
  capture_if_nxt.prdata = prdata ;
  capture_if_nxt.prdata_par = prdata_par ;
  capture_if_nxt.pm_state = pm_state ;
  capture_if_nxt.pm_fsm_d0tod3_ok = pm_fsm_d0tod3_ok ;
  capture_if_nxt.pm_fsm_d3tod0_ok = pm_fsm_d3tod0_ok ;
  capture_if_nxt.pm_fsm_in_run = pm_fsm_in_run ;
  capture_if_nxt.pm_allow_ing_drop = pm_allow_ing_drop ;
  capture_if_nxt.hqm_proc_reset_done = hqm_proc_reset_done ;
  capture_if_nxt.hqm_proc_idle = hqm_proc_idle ;
  capture_if_nxt.hqm_flr_prep = hqm_flr_prep ;
  capture_if_nxt.master_ctl_load = master_ctl_load ;
  capture_if_nxt.master_ctl = master_ctl ;
  capture_if_nxt.master_trigger_ctl_load = master_trigger_ctl_load ;
  capture_if_nxt.master_trigger_ctl = master_trigger_ctl ;
  capture_if_nxt.timer_f = timer_f ;

  //....................................................................................................
  //drive I2C status output controlled by I2C control input
  // i2c_ctrl 
  //          [ 07 : 00 ] : 32b index to storage word (use strucutre for bit decode )
  //          [ 15 : 08 ] : storage word address
  //          [ 23 : 16 ] : resource to read : 0:read storage 1:read IF 2:read current storage ptr 3:read current timer value
  //          [ 30 : 24 ] : trigger event 0:any, 1:rst,put,pok,ack,  2:IOSF gnt,credit,smd,req  3:apb psel,penable,pready
  //          [ 31 : 31 ] : 1=reset

  //decode resource to read using I2C control
  i2c_data = capture_mem_f [ i2c_ctrl[15:8] ] [ ( i2c_ctrl[7:0] * 32 ) +: 32 ] ;
  if ( i2c_ctrl[23:16] == 2'd1 ) begin
    i2c_data = capture_if_f [ ( i2c_ctrl[7:0] * 32 ) +: 32 ] ;
  end
  if ( i2c_ctrl[23:16] == 2'd2 ) begin
    i2c_data = word_f ;
  end
  if ( i2c_ctrl[23:16] == 2'd3 ) begin
    i2c_data = timer_f ;
  end

  //decode trigger using I2C control
  trigger =  ( capture_if_nxt !=  capture_if_f ) ;
  if ( i2c_ctrl[30:24] == 7'd1 ) begin
    trigger = ( ( capture_if_nxt.side_rst_b !=  capture_if_f.side_rst_b ) 
              | ( capture_if_nxt.side_clkack !=  capture_if_f.side_clkack )
              | ( capture_if_nxt.side_clkreq !=  capture_if_f.side_clkreq )
              | ( capture_if_nxt.side_pok !=  capture_if_f.side_pok )
              | ( capture_if_nxt.gpsb_side_ism_agent !=  capture_if_f.gpsb_side_ism_agent ) 
              | ( capture_if_nxt.gpsb_side_ism_fabric !=  capture_if_f.gpsb_side_ism_fabric )
              | ( capture_if_nxt.prim_ism_agent !=  capture_if_f.prim_ism_agent ) 
              | ( capture_if_nxt.prim_ism_fabric !=  capture_if_f.prim_ism_fabric )
              | ( capture_if_nxt.prim_rst_b !=  capture_if_f.prim_rst_b )
              | ( capture_if_nxt.prim_pok !=  capture_if_f.prim_pok )
              | ( capture_if_nxt.prim_clkack !=  capture_if_f.prim_clkack )
              | ( capture_if_nxt.prim_clkreq !=  capture_if_f.prim_clkreq )
              | ( capture_if_nxt.gpsb_mnpcup !=  capture_if_f.gpsb_mnpcup )
              | ( capture_if_nxt.gpsb_mpccup !=  capture_if_f.gpsb_mpccup )
              | ( capture_if_nxt.gpsb_tnpcup !=  capture_if_f.gpsb_tnpcup )
              | ( capture_if_nxt.gpsb_tpccup !=  capture_if_f.gpsb_tpccup )
              | ( capture_if_nxt.gpsb_tnpput !=  capture_if_f.gpsb_tnpput )
              | ( capture_if_nxt.gpsb_tpcput !=  capture_if_f.gpsb_tpcput )
              | ( capture_if_nxt.gpsb_mnpput !=  capture_if_f.gpsb_mnpput )
              | ( capture_if_nxt.gpsb_mpcput !=  capture_if_f.gpsb_mpcput )
              | ( capture_if_nxt.credit_put !=  capture_if_f.credit_put )
              | ( capture_if_nxt.cmd_put !=  capture_if_f.cmd_put )
              ) ;
  end
  if ( i2c_ctrl[30:24] == 7'd2 ) begin
    trigger = ( gnt
              | capture_if_f.gnt 
              | credit_put
              | capture_if_f.credit_put
              | cmd_put
              | capture_if_f.cmd_put
              | req_put
              | capture_if_f.req_put
              ) ;
  end
  if ( i2c_ctrl[30:24] == 7'd3 ) begin
    trigger = ( ( capture_if_nxt.psel != capture_if_f.psel )
              | ( capture_if_nxt.penable != capture_if_f.penable )
              | ( capture_if_nxt.pready != capture_if_f.pready )
              ) ;
  end

  // capture using trigger
  if ( trigger ) begin
    word_nxt = word_f + 32'd1 ;
    capture_mem_nxt [ word_f ] = capture_if_nxt ;
  end

  //reset state controlled by I2C
  if ( i2c_ctrl [ 31 ] ) begin
    timer_nxt = '0 ;
    word_nxt = '0 ;
    for (int i=0; i<DEPTH; i=i+1) begin
      capture_mem_nxt [ i ] = capture_mem_f [ i ] ;
    end
    capture_if_nxt = '0 ;
    i2c_data = 32'h20190509 ;
  end

end

endmodule
