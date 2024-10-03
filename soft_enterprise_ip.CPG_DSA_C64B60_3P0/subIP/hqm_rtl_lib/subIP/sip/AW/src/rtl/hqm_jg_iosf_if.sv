module hqm_jg_iosf_if

     import
// collage-pragma translate_off
            hqm_system_pkg::*, hqm_system_type_pkg::*, hqm_system_csr_pkg::*, hqm_func_per_vf_pkg::*, hqm_msix_mem_pkg::*,
// collage-pragma translate_on
            hqm_iosf_pkg::*, hqm_AW_pkg::*, hqm_pkg::*;
(
     input logic clk
    ,input logic rst_n

//i_dut.i_hqm_iosf_core.i_hqm_ri.i_ri_pf_vf_cfg.func_pf_bar
//i_dut.i_hqm_iosf_core.i_hqm_ri.i_ri_pf_vf_cfg.csr_pf_bar
//i_dut.i_hqm_iosf_core.i_hqm_ri.i_ri_pf_vf_cfg.func_vf_bar
,input logic [63:0] CFG_func_pf_bar
,input logic [63:0] CFG_csr_pf_bar
,input logic [63:0] CFG_func_vf_bar


    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Command Interface
    
    ,output logic                                   cmd_put
    ,output logic   [1:0]                           cmd_rtype               // req: Put Request Type
    ,output logic                                   cmd_nfs_err             // opt: Non-Func Specific Err
    ,output logic   [1:0]                           tfmt                    // req: Fmt
    ,output logic   [4:0]                           ttype                   // req: Type
    ,output logic   [3:0]                           ttc                     // req: Traffic Class
    ,output logic                                   tth                     // opt: Transaction Hint
    ,output logic                                   tep                     // opt: Error Present
    ,output logic                                   tro                     // req: Relaxed Ordering
    ,output logic                                   tns                     // req: Non-Snoop
    ,output logic                                   tido                    // opt: ID Based Ordering
    ,output logic                                   tchain                  // opt: Chain
    ,output logic   [1:0]                           tat                     // opt: Adrs Translation Svc
    ,output logic   [9:0]                           tlength                 // req: Length
    ,output logic   [15:0]                          trqid                   // req: Requester ID
    ,output logic   [7:0]                           ttag                    // req: Tag
    ,output logic   [3:0]                           tlbe                    // req: Last DW Byte Enable
    ,output logic   [3:0]                           tfbe                    // req: First DW Byte Enable
    ,output logic   [TMAX_ADDR:0]                   taddress                // req: Address
    ,output logic   [RS_WIDTH:0]                    trs                     // opt: root space of address
    ,output logic                                   ttd                     // opt: TLP Digest
    ,output logic   [31:0]                          tecrc                   // opt: End to End CRC
    ,output logic                                   tcparity                // opt: Command Parity
    ,output logic   [SRC_ID_WIDTH:0]                tsrc_id                 // opt: Source ID (peer-to-peer)
    ,output logic   [DST_ID_WIDTH:0]                tdest_id                // opt: Destination ID (src dec)
    ,output logic   [SAI_WIDTH:0]                   tsai                    // opt: Sec Attr of Initiator
    ,output logic   [PASIDTLP_WIDTH:0]              tpasidtlp               // opt: Process Address Space ID TLP
    ,output logic                                   trsvd1_7                // opt: Tag[9]
    ,output logic                                   trsvd1_3                // opt: Tag[8]
    
    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Data Interface
    
    ,output logic   [TD_WIDTH:0]                    tdata                   // req: Data
    ,output logic   [TDP_WIDTH:0]                   tdparity                // opt: Data Parity

    //-----------------------------------------------------------------------------------------------------
    // IOSF HCW enqueue interface
    
    ,output  logic                                  hcw_enq_in_ready

    ,input  logic                                   hcw_enq_in_v
    ,input  logic [BITS_HCW_ENQ_IN_DATA_T-1:0]      hcw_enq_in_data

    //---------------------------------------------------------------------------------------------
    // APB interface

    ,input  logic                                   psel
    ,input  logic                                   penable
    ,input  logic                                   pwrite
    ,input  logic   [31:0]                          paddr
    ,input  logic   [31:0]                          pwdata
    ,input  logic   [19:0]                          puser

    ,output logic                                   pready
    ,output logic                                   pslverr
    ,output logic   [31:0]                          prdata
    ,output logic                                   prdata_par

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Request Bus Signals

    ,input  logic                                   req_put                 // req: Request Put
    ,input  logic   [1:0]                           req_rtype               // req: Request Type
    ,input  logic                                   req_cdata               // req: Request Contains Data
    ,input  logic   [MAX_DATA_LEN:0]                req_dlen                // req: Request Data Length
    ,input  logic   [3:0]                           req_tc                  // req: Request Traffic Class
    ,input  logic                                   req_ns                  // req: Request Non-Snoop
    ,input  logic                                   req_ro                  // req: Request Relaxed Order
    ,input  logic                                   req_ido                 // opt: Req ID Based Ordering
    ,input  logic   [15:0]                          req_id                  // opt: Req ID Based Ordering
    ,input  logic                                   req_locked              // req: Request Locked
    ,input  logic                                   req_chain               // opt: Request Chain
    ,input  logic                                   req_opp                 // opt: Request Opportunistic
    ,input  logic   [RS_WIDTH:0]                    req_rs                  // opt: Request Root_Space
    ,input  logic   [AGENT_WIDTH:0]                 req_agent               // opt: Request agent Specific
    ,input  logic   [DST_ID_WIDTH:0]                req_dest_id             // opt: Destination ID (src dec)

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Specific Control Signals

    ,output logic                                   gnt                     // req: Grant
    ,output logic   [1:0]                           gnt_rtype               // req: Grant Request Type
    ,output logic   [1:0]                           gnt_type                // req: Grant Type

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Command Signals

    ,input  logic   [1:0]                           mfmt                    // req: Fmt
    ,input  logic   [4:0]                           mtype                   // req: Type
    ,input  logic   [3:0]                           mtc                     // req: Traffic Class
    ,input  logic                                   mth                     // opt: Transaction Hint
    ,input  logic                                   mep                     // opt: Error Present
    ,input  logic                                   mro                     // req: Relaxed Ordering
    ,input  logic                                   mns                     // req: Non-Snoop
    ,input  logic                                   mido                    // opt: ID Based Ordering
    ,input  logic   [1:0]                           mat                     // opt: Adrs Translation Svc
    ,input  logic   [9:0]                           mlength                 // req: Length
    ,input  logic   [15:0]                          mrqid                   // req: Requester ID
    ,input  logic   [7:0]                           mtag                    // req: Tag
    ,input  logic   [3:0]                           mlbe                    // req: Last DW Byte Enable
    ,input  logic   [3:0]                           mfbe                    // req: First DW Byte Enable
    ,input  logic   [MMAX_ADDR:0]                   maddress                // req: Address
    ,input  logic   [RS_WIDTH:0]                    mrs                     // opt: Root Space of address
    ,input  logic                                   mtd                     // opt: TLP Digest
    ,input  logic   [31:0]                          mecrc                   // opt: End to End CRC
    ,input  logic                                   mcparity                // req: Command Parity
    ,input  logic   [SRC_ID_WIDTH:0]                msrc_id                 // opt: Source ID (peer-to-peer)
    ,input  logic   [DST_ID_WIDTH:0]                mdest_id                // opt: Destination ID (src dec)
    ,input  logic   [SAI_WIDTH:0]                   msai                    // opt: Sec Attr of Initiator
    ,input  logic   [PASIDTLP_WIDTH:0]              mpasidtlp               // opt: Process Address Space ID TLP
    ,input  logic                                   mrsvd1_7                // opt: Tag[9]
    ,input  logic                                   mrsvd1_3                // opt: Tag[8]

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Data Signals

    ,input  logic   [MD_WIDTH:0]                    mdata                   // req: Data
    ,input  logic   [MDP_WIDTH:0]                   mdparity                // req: Data Parity

    //---------------------------------------------------------------------------------------------
    // IOSF Non-Posted interface
    ,input  logic                                   phdr_fifo_afull
    ,output logic                                   phdr_fifo_push
    ,output HqmPhCmd_t                              phdr_fifo_push_data
    
    ,input  logic                                   pdata_fifo_afull
    ,output logic                                   pdata_fifo_push
    ,output CdData_t                                pdata_fifo_push_data


//Credit init is part of reset seqeunce reset_seq.txt, this module is held in reset until the sequnece complete, need to model credit externally 
, input [ ( 4 * 8 ) - 1 : 0 ] prim_cmd_credit_cnt_q
, input [ ( 4 * 8 ) - 1 : 0 ] prim_dat_credit_cnt_q



);

//====================================================================================================
//====================================================================================================
//  REQ - GNT MODEL
logic gnt_rand_issue ;

logic gnt_fifo_push ;
logic [(2)-1:0] gnt_fifo_push_data ;
logic gnt_fifo_pop ;
logic [(2)-1:0] gnt_fifo_pop_data ;
logic gnt_fifo_empty ;
hqm_jg_fifo #(
.DEPTH(64) //TODO: more than # of channel credits
,.DWIDTH(2)
) i_gnt_fifo (
.clk (clk)
,.rst_n (rst_n)
,.empty ( gnt_fifo_empty )
,.full ( )
,.push ( gnt_fifo_push )
,.push_data ( gnt_fifo_push_data )
,.pop ( gnt_fifo_pop )
,.pop_data ( gnt_fifo_pop_data )
);

always_comb begin

  gnt = '0 ;
  gnt_type = 2'd0 ; // 00: Transaction : The transaction is granted. The agent will drive the command and data if required, unload the transaction from the queue, and increment the corresponding request QID credit counter.
  gnt_rtype = '0 ;

  gnt_fifo_push = '0 ;
  gnt_fifo_push_data = '0 ;
  gnt_fifo_pop = '0 ;

  if ( req_put ) begin
    gnt_fifo_push = 1'b1 ;
    gnt_fifo_push_data = req_rtype ;
  end
  if ( ~gnt_fifo_empty
     & gnt_rand_issue
     ) begin
    gnt_fifo_pop = 1'b1 ;

    gnt = 1'b1 ;
    gnt_rtype = gnt_fifo_pop_data ;
  end
end

logic gnt_f1 , gnt_f2 , gnt_f3 , gnt_f4 ;
logic [1:0] gnt_rtype_f1 , gnt_rtype_f2 , gnt_rtype_f3 , gnt_rtype_f4 ;
logic [1:0] gnt_type_f1 , gnt_type_f2 , gnt_type_f3 , gnt_type_f4 ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    gnt_f1 <= '0 ;
    gnt_f2 <= '0 ;
    gnt_f3 <= '0 ;
    gnt_f4 <= '0 ;

    gnt_rtype_f1 <= '0 ;
    gnt_rtype_f2 <= '0 ;
    gnt_rtype_f3 <= '0 ;
    gnt_rtype_f4 <= '0 ;

    gnt_type_f1 <= '0 ;
    gnt_type_f2 <= '0 ;
    gnt_type_f3 <= '0 ;
    gnt_type_f4 <= '0 ;
  end
  else begin
    gnt_f1 <= gnt ;
    gnt_f2 <= gnt_f1 ;
    gnt_f3 <= gnt_f2 ;
    gnt_f4 <= gnt_f3 ;

    gnt_rtype_f1 <= gnt_rtype ;
    gnt_rtype_f2 <= gnt_rtype_f1 ;
    gnt_rtype_f3 <= gnt_rtype_f2 ;
    gnt_rtype_f4 <= gnt_rtype_f3 ;

    gnt_type_f1 <= gnt_type ;
    gnt_type_f2 <= gnt_type_f1 ;
    gnt_type_f3 <= gnt_type_f2 ;
    gnt_type_f4 <= gnt_type_f3 ;
  end
end
//====================================================================================================
//====================================================================================================

//====================================================================================================
//====================================================================================================
// APB model
logic apb_rand_issue ;

logic apb_fifo_push ;
logic [(32)-1:0] apb_fifo_push_data ;
logic apb_fifo_pop ;
logic [(32)-1:0] apb_fifo_pop_data ;
logic apb_fifo_empty ;
hqm_jg_fifo #(
.DEPTH(2)
,.DWIDTH(32)
) i_apb_fifo (
.clk (clk)
,.rst_n (rst_n)
,.empty ( apb_fifo_empty )
,.full ( )
,.push ( apb_fifo_push )
,.push_data ( apb_fifo_push_data )
,.pop ( apb_fifo_pop )
,.pop_data ( apb_fifo_pop_data )
);

logic [ ( ( 256 ) - 1 ) : 0 ] [ ( 32 ) - 1 : 0 ] abp_ram_f ;
logic [ ( ( 256 ) - 1 ) : 0 ] [ ( 32 ) - 1 : 0 ] abp_ram_nxt ;
logic pready_nxt , pready_f ;
logic pslverr_nxt , pslverr_f ;
logic [31:0] prdata_nxt , prdata_f ;
logic prdata_par_nxt , prdata_par_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    abp_ram_f <= '0 ;
    pready_f <= '0 ;
    pslverr_f <= '0 ;
    prdata_f <= '0 ;
    prdata_par_f <= '0 ;
  end
  else begin
    abp_ram_f <= abp_ram_nxt ;
    pready_f <= pready_nxt ;
    pslverr_f <= pslverr_nxt ;
    prdata_f <= prdata_nxt ;
    prdata_par_f <= prdata_par_nxt ;
  end
end

always_comb begin
  pready = pready_f & penable ;
  pslverr = pslverr_f ;
  prdata_par = prdata_par_f ;
  prdata = prdata_f ;

  pready_nxt = pready_f ; 
  pslverr_nxt = pslverr_f ;
  prdata_par_nxt = prdata_par_f ;
  prdata_nxt = prdata_f ;

  abp_ram_nxt = abp_ram_f ; 

  apb_fifo_push = '0 ;
  apb_fifo_push_data = '0 ;
  apb_fifo_pop = '0 ;

  if ( pready_f ) begin
    if ( ~penable ) begin
      pready_nxt = 1'b0 ;
    end
  end

  if ( apb_rand_issue & psel & penable & pwrite ) begin
    abp_ram_nxt [ {paddr[31:28],paddr[5:2]} ] = pwdata ;
    pready_nxt = 1'b1 ;
  end

  if ( apb_rand_issue & psel & penable & ~pwrite ) begin
    apb_fifo_push = 1'b1 ;
    apb_fifo_push_data = abp_ram_f [ {paddr[31:28],paddr[5:2]} ] ;
  end
  if ( ~ apb_fifo_empty ) begin
     apb_fifo_pop = 1'b1 ;
     pready_nxt = 1'b1 ;
     pslverr_nxt = 1'b0 ;
     prdata_par_nxt = ^ ( apb_fifo_pop_data ) ;
     prdata_nxt = apb_fifo_pop_data ;
  end
end
//====================================================================================================
//====================================================================================================


//====================================================================================================
//====================================================================================================
// MODEL

// { cmd_rtype[1:0] }
// 00: Posted
// 01: Non-Posted
// 10: Completion
// 11: Reserved

// { tfmt[1:0] , ttype[4:0] }
//    Fmt: Specifies the format:
//    00: 3 DW header, no data
//    01: 4 DW header, no data
//    10: 3 DW header, with data
//    11: 4 DW header, with data
// Transaction Name 	Rtype 	Fmt[1:0]:Type[4:0] 	Description
// MRd32 		NP  	   0(00)  00(00000) 	32 bit Memory Read Request
// MRd64 		NP 	   1(01)  00(00000) 	64-bit Memory Read Request
// LTMRd32 		NP 	   0(00)  07(00111) 	32 bit LT Memory Read Request.
// LTMRd64 		NP 	   1(01)  07(00111) 	64-bit LT Memory Read Request
// MRdLk32 		NP 	   0(00)  01(00001) 	32-bit Locked Memory Read Request
// MRdLk64 		NP 	   1(01)  01(00001) 	64-bit Locked Memory Read Request
// MWr32 		P 	   2(10)  00(00000) 	32-bit Memory Write Request
// MWr64 		P 	   3(11)  00(00000) 	64-bit Memory Write Request
// LTMWr32 		P 	   2(10)  07(00111) 	32-bit LT Memory Write Request
// LTMWr64 		P 	   3(11)  07(00111) 	64-bit LT Memory Write Request
// NPMWr32 		NP 	   2(10)  27(11011) 	32 bit Non Posted Memory Write
// NPMWr64 		NP 	   3(11)  27(11011) 	64 bit Non Posted Memory Write
// IORd 		NP 	   0(00)  02(00010) 	IO Read Request
// IOWr 		NP 	   2(10)  02(00010) 	IO Write Request
// CfgRd0 		NP 	   0(00)  04(00100) 	Configuration Read Type 0
// CfgWr0 		NP 	   2(10)  04(00100) 	Configuration Write Type 0
// CfgRd1 		NP 	   0(00)  05(00101) 	Configuration Read Type 1
// CfgWr1 		NP 	   2(10)  05(00101) 	Configuration Write Type 1
// Cpl 			C 	   0(00)  10(01010) 	Completion without Data.
// CplD 		C 	   2(10)  10(01010) 	Completion with Data.
// CplLk 		C 	   0(00)  11(01011) 	Completion for a Locked Memory Read without Data
// CplDLk 		C 	   2(10)  11(01011) 	Completion for a Locked Memory Read with Data.
// FetchAdd32 		NP 	   2(10)  12(01100) 	32-bit Fetch and Add Atomic Op Request
// FetchAdd64 		NP 	   3(11)  12(01100) 	64-bit Fetch and Add Atomic Op Request
// Swap32 		NP 	   2(10)  13(01101) 	32-bit Unconditional Swap AtomicOp Request
// Swap64 		NP 	   3(11)  13(01101) 	64-bit Unconditional Swap AtomicOp Request
// CAS32 		NP 	   2(10)  14(01110) 	32-bit Compare and Swap AtomicOp Request
// CAS64 		NP 	   3(11)  14(01110) 	64-bit Compare and Swap AtomicOp Request
// Msg 			P 	   1(01)  xx(10...) 	Message Request. The sub-field r[2:0] specify a message routing mechanism.  
// MsgD 		P 	   3(11)  xx(10...) 	Message Request with Data. The sub-field r[2:0] specify a message routing mechanism.

logic [ ( ( 256 ) - 1 ) : 0 ] [ ( 32 ) - 1 : 0 ] MODEL_cfg_ram_f ;
logic [ ( ( 256 ) - 1 ) : 0 ] [ ( 32 ) - 1 : 0 ] MODEL_cfg_ram_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    MODEL_cfg_ram_f <= '0 ;
  end
  else begin
    MODEL_cfg_ram_f <= MODEL_cfg_ram_nxt ;
  end
end

typedef struct packed {
logic [1:0] mfmt ;
logic [4:0] mtype ;
logic [3:0] mtc ;
logic mth ;
logic mep ;
logic mro ;
logic mns ;
logic mido ;
logic [1:0] mat ;
logic [9:0] mlength ;
logic [15:0] mrqid ;
logic [7:0] mtag ;
logic [3:0] mlbe ;
logic [3:0] mfbe ;
logic [MMAX_ADDR:0] maddress ;
logic [RS_WIDTH:0] mrs ;
logic mtd ;
logic [31:0] mecrc ;
logic mcparity ;
logic [SRC_ID_WIDTH:0] msrc_id ;
logic [DST_ID_WIDTH:0] mdest_id ;
logic [SAI_WIDTH:0] msai ;
logic [PASIDTLP_WIDTH:0] mpasidtlp ;
logic mrsvd1_7 ;
logic mrsvd1_3 ;
} master_cmd_t ;

logic MODEL_master_cmd_cfg_in_valid ;
logic MODEL_master_cmd_cfg_in_taken ;
master_cmd_t MODEL_master_cmd_cfg_in_data ;
logic MODEL_master_cmd_cfg_out_valid ;
logic MODEL_master_cmd_cfg_out_taken ;
master_cmd_t MODEL_master_cmd_cfg_out_data ;
hqm_jg_transfer_checker # (
          .DEPTH                                ( 32 )
        , .DATA_WIDTH                           ( $bits ( MODEL_master_cmd_cfg_out_data )  )
        , .DATA_MASK                            ( 0 )
        , .NUM_INPUT                            ( 1 )
        , .NUM_OUTPUT                           ( 1 )
        , .NUM_DROP                             ( 1 )
        , .NUM_RESET                            ( 1 )
        , .NUM_STALL                            ( 1 )
        , .CHECK_HANG                           ( 1 ) //0:none, 1:(#queued operations > 0 ) & (#cycles since last out_v event > threshold)
        , .CHECK_HANG_THRESH                    ( 24 )
        , .CHECK_IN_HANG                        ( 1 ) //0:none, 1:in_valid asserted > threshold with no in_taken
        , .CHECK_IN_HANG_THRESH                 ( 16 )
        , .CHECK_OUT_HANG                       ( 1 ) //0:none, 1:out_valid asserted > threshold with no out_taken
        , .CHECK_OUT_HANG_THRESH                ( 16 )
        , .CHECK_OUT_MISS                       ( 1 ) //0:none, 1:out_valid issued with no data stored in hqm_jg_transfer_checker
        , .CHECK_DROP_MISS                      ( 1 ) //0:none, 1:drop_valid issued & no data match
        , .CHECK_ORDER_EXISTS                   ( 1 ) //0:none, 1:out_valid issued & out_data does not hit in storage
        , .CHECK_ORDER_OLDEST                   ( 1 ) //0:none, 1:out_valid issued & out_data is not the oldest data in storage
        , .CHECK_OF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_UF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_IN_V                           ( 1 ) //0:none, 1:in_valid deasserts before taken
        , .CHECK_IN_DATA                        ( 1 ) //0:none, 1:in_data changes before taken
        , .CHECK_OUT_V                          ( 1 ) //0:none, 1:out_valid deasserts before taken
        , .CHECK_OUT_DATA                       ( 1 ) //0:none, 1:out_data changes before taken
) i_hqm_jg_transfer_checker_MODEL_master_cmd_cfg (
          .clk                                  ( clk )
        , .rst_n                                ( rst_n )
        , .in_valid                             ( MODEL_master_cmd_cfg_in_valid )
        , .in_taken                             ( MODEL_master_cmd_cfg_in_taken )
        , .in_data                              ( MODEL_master_cmd_cfg_in_data  )
        , .out_valid                            ( MODEL_master_cmd_cfg_out_valid )
        , .out_taken                            ( MODEL_master_cmd_cfg_out_taken )
        , .out_data                             ( MODEL_master_cmd_cfg_out_data )
        , .drop_valid                           ( '0 )
        , .drop_data                            ( '0 )
        , .reset_count_valid                    ( 1'b0 )
        , .stall_count_valid                    ( 1'b0 )
) ;

logic MODEL_master_data_cfg_in_valid ;
logic MODEL_master_data_cfg_in_taken ;
logic [MD_WIDTH:0] MODEL_master_data_cfg_in_data ;
logic MODEL_master_data_cfg_out_valid ;
logic MODEL_master_data_cfg_out_taken ;
logic [MD_WIDTH:0] MODEL_master_data_cfg_out_data ;
hqm_jg_transfer_checker # (
          .DEPTH                                ( 32 )
        , .DATA_WIDTH                           ( $bits ( MODEL_master_data_cfg_out_data )  )
        , .DATA_MASK                            ( 0 )
        , .NUM_INPUT                            ( 1 )
        , .NUM_OUTPUT                           ( 1 )
        , .NUM_DROP                             ( 1 )
        , .NUM_RESET                            ( 1 )
        , .NUM_STALL                            ( 1 )
        , .CHECK_HANG                           ( 1 ) //0:none, 1:(#queued operations > 0 ) & (#cycles since last out_v event > threshold)
        , .CHECK_HANG_THRESH                    ( 24 )
        , .CHECK_IN_HANG                        ( 1 ) //0:none, 1:in_valid asserted > threshold with no in_taken
        , .CHECK_IN_HANG_THRESH                 ( 16 )
        , .CHECK_OUT_HANG                       ( 1 ) //0:none, 1:out_valid asserted > threshold with no out_taken
        , .CHECK_OUT_HANG_THRESH                ( 16 )
        , .CHECK_OUT_MISS                       ( 1 ) //0:none, 1:out_valid issued with no data stored in hqm_jg_transfer_checker
        , .CHECK_DROP_MISS                      ( 1 ) //0:none, 1:drop_valid issued & no data match
        , .CHECK_ORDER_EXISTS                   ( 1 ) //0:none, 1:out_valid issued & out_data does not hit in storage
        , .CHECK_ORDER_OLDEST                   ( 1 ) //0:none, 1:out_valid issued & out_data is not the oldest data in storage
        , .CHECK_OF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_UF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_IN_V                           ( 1 ) //0:none, 1:in_valid deasserts before taken
        , .CHECK_IN_DATA                        ( 1 ) //0:none, 1:in_data changes before taken
        , .CHECK_OUT_V                          ( 1 ) //0:none, 1:out_valid deasserts before taken
        , .CHECK_OUT_DATA                       ( 1 ) //0:none, 1:out_data changes before taken
) i_hqm_jg_transfer_checker_MODEL_master_data_cfg (
          .clk                                  ( clk )
        , .rst_n                                ( rst_n )
        , .in_valid                             ( MODEL_master_data_cfg_in_valid )
        , .in_taken                             ( MODEL_master_data_cfg_in_taken )
        , .in_data                              ( MODEL_master_data_cfg_in_data  )
        , .out_valid                            ( MODEL_master_data_cfg_out_valid )
        , .out_taken                            ( MODEL_master_data_cfg_out_taken )
        , .out_data                             ( MODEL_master_data_cfg_out_data )
        , .drop_valid                           ( '0 )
        , .drop_data                            ( '0 )
        , .reset_count_valid                    ( 1'b0 )
        , .stall_count_valid                    ( 1'b0 )
) ;

logic MODEL_master_cmd_hcw_in_valid ;
logic MODEL_master_cmd_hcw_in_taken ;
master_cmd_t MODEL_master_cmd_hcw_in_data ;
logic MODEL_master_cmd_hcw_out_valid ;
logic MODEL_master_cmd_hcw_out_taken ;
master_cmd_t MODEL_master_cmd_hcw_out_data ;
hqm_jg_transfer_checker # (
          .DEPTH                                ( 32 )
        , .DATA_WIDTH                           ( $bits ( MODEL_master_cmd_hcw_out_data )  )
        , .DATA_MASK                            ( 0 )
        , .NUM_INPUT                            ( 1 )
        , .NUM_OUTPUT                           ( 1 )
        , .NUM_DROP                             ( 1 )
        , .NUM_RESET                            ( 1 )
        , .NUM_STALL                            ( 1 )
        , .CHECK_HANG                           ( 1 ) //0:none, 1:(#queued operations > 0 ) & (#cycles since last out_v event > threshold)
        , .CHECK_HANG_THRESH                    ( 24 )
        , .CHECK_IN_HANG                        ( 1 ) //0:none, 1:in_valid asserted > threshold with no in_taken
        , .CHECK_IN_HANG_THRESH                 ( 16 )
        , .CHECK_OUT_HANG                       ( 1 ) //0:none, 1:out_valid asserted > threshold with no out_taken
        , .CHECK_OUT_HANG_THRESH                ( 16 )
        , .CHECK_OUT_MISS                       ( 1 ) //0:none, 1:out_valid issued with no data stored in hqm_jg_transfer_checker
        , .CHECK_DROP_MISS                      ( 1 ) //0:none, 1:drop_valid issued & no data match
        , .CHECK_ORDER_EXISTS                   ( 1 ) //0:none, 1:out_valid issued & out_data does not hit in storage
        , .CHECK_ORDER_OLDEST                   ( 1 ) //0:none, 1:out_valid issued & out_data is not the oldest data in storage
        , .CHECK_OF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_UF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_IN_V                           ( 1 ) //0:none, 1:in_valid deasserts before taken
        , .CHECK_IN_DATA                        ( 1 ) //0:none, 1:in_data changes before taken
        , .CHECK_OUT_V                          ( 1 ) //0:none, 1:out_valid deasserts before taken
        , .CHECK_OUT_DATA                       ( 1 ) //0:none, 1:out_data changes before taken
) i_hqm_jg_transfer_checker_MODEL_master_cmd_hcw (
          .clk                                  ( clk )
        , .rst_n                                ( rst_n )
        , .in_valid                             ( MODEL_master_cmd_hcw_in_valid )
        , .in_taken                             ( MODEL_master_cmd_hcw_in_taken )
        , .in_data                              ( MODEL_master_cmd_hcw_in_data  )
        , .out_valid                            ( MODEL_master_cmd_hcw_out_valid )
        , .out_taken                            ( MODEL_master_cmd_hcw_out_taken )
        , .out_data                             ( MODEL_master_cmd_hcw_out_data )
        , .drop_valid                           ( '0 )
        , .drop_data                            ( '0 )
        , .reset_count_valid                    ( 1'b0 )
        , .stall_count_valid                    ( 1'b0 )
) ;

logic MODEL_master_data_hcw_in_valid ;
logic MODEL_master_data_hcw_in_taken ;
logic [MD_WIDTH:0] MODEL_master_data_hcw_in_data ;
logic MODEL_master_data_hcw_out_valid ;
logic MODEL_master_data_hcw_out_taken ;
logic [MD_WIDTH:0] MODEL_master_data_hcw_out_data ;
hqm_jg_transfer_checker # (
          .DEPTH                                ( 32 )
        , .DATA_WIDTH                           ( $bits ( MODEL_master_data_hcw_out_data )  )
        , .DATA_MASK                            ( 0 )
        , .NUM_INPUT                            ( 1 )
        , .NUM_OUTPUT                           ( 1 )
        , .NUM_DROP                             ( 1 )
        , .NUM_RESET                            ( 1 )
        , .NUM_STALL                            ( 1 )
        , .CHECK_HANG                           ( 1 ) //0:none, 1:(#queued operations > 0 ) & (#cycles since last out_v event > threshold)
        , .CHECK_HANG_THRESH                    ( 24 )
        , .CHECK_IN_HANG                        ( 1 ) //0:none, 1:in_valid asserted > threshold with no in_taken
        , .CHECK_IN_HANG_THRESH                 ( 16 )
        , .CHECK_OUT_HANG                       ( 1 ) //0:none, 1:out_valid asserted > threshold with no out_taken
        , .CHECK_OUT_HANG_THRESH                ( 16 )
        , .CHECK_OUT_MISS                       ( 1 ) //0:none, 1:out_valid issued with no data stored in hqm_jg_transfer_checker
        , .CHECK_DROP_MISS                      ( 1 ) //0:none, 1:drop_valid issued & no data match
        , .CHECK_ORDER_EXISTS                   ( 1 ) //0:none, 1:out_valid issued & out_data does not hit in storage
        , .CHECK_ORDER_OLDEST                   ( 1 ) //0:none, 1:out_valid issued & out_data is not the oldest data in storage
        , .CHECK_OF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_UF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_IN_V                           ( 1 ) //0:none, 1:in_valid deasserts before taken
        , .CHECK_IN_DATA                        ( 1 ) //0:none, 1:in_data changes before taken
        , .CHECK_OUT_V                          ( 1 ) //0:none, 1:out_valid deasserts before taken
        , .CHECK_OUT_DATA                       ( 1 ) //0:none, 1:out_data changes before taken
) i_hqm_jg_transfer_checker_MODEL_master_data_hcw (
          .clk                                  ( clk )
        , .rst_n                                ( rst_n )
        , .in_valid                             ( MODEL_master_data_hcw_in_valid )
        , .in_taken                             ( MODEL_master_data_hcw_in_taken )
        , .in_data                              ( MODEL_master_data_hcw_in_data  )
        , .out_valid                            ( MODEL_master_data_hcw_out_valid )
        , .out_taken                            ( MODEL_master_data_hcw_out_taken )
        , .out_data                             ( MODEL_master_data_hcw_out_data )
        , .drop_valid                           ( '0 )
        , .drop_data                            ( '0 )
        , .reset_count_valid                    ( 1'b0 )
        , .stall_count_valid                    ( 1'b0 )
) ;

logic [(4)-1:0] MODEL_enq_data_hcw_in_valid ;
logic [(4)-1:0] MODEL_enq_data_hcw_in_taken ;
logic [(4*BITS_HCW_ENQ_IN_DATA_T)-1:0] MODEL_enq_data_hcw_in_data ;
logic MODEL_enq_data_hcw_out_valid ;
logic MODEL_enq_data_hcw_out_taken ;
logic [BITS_HCW_ENQ_IN_DATA_T-1:0] MODEL_enq_data_hcw_out_data ;
hqm_jg_transfer_checker # (
          .DEPTH                                ( 32 )
        , .DATA_WIDTH                           ( $bits ( MODEL_enq_data_hcw_out_data )  )
        , .DATA_MASK                            ( 0 )
        , .NUM_INPUT                            ( 4 )
        , .NUM_OUTPUT                           ( 1 )
        , .NUM_DROP                             ( 1 )
        , .NUM_RESET                            ( 1 )
        , .NUM_STALL                            ( 1 )
        , .CHECK_HANG                           ( 1 ) //0:none, 1:(#queued operations > 0 ) & (#cycles since last out_v event > threshold)
        , .CHECK_HANG_THRESH                    ( 24 )
        , .CHECK_IN_HANG                        ( 1 ) //0:none, 1:in_valid asserted > threshold with no in_taken
        , .CHECK_IN_HANG_THRESH                 ( 16 )
        , .CHECK_OUT_HANG                       ( 1 ) //0:none, 1:out_valid asserted > threshold with no out_taken
        , .CHECK_OUT_HANG_THRESH                ( 16 )
        , .CHECK_OUT_MISS                       ( 1 ) //0:none, 1:out_valid issued with no data stored in hqm_jg_transfer_checker
        , .CHECK_DROP_MISS                      ( 1 ) //0:none, 1:drop_valid issued & no data match
        , .CHECK_ORDER_EXISTS                   ( 1 ) //0:none, 1:out_valid issued & out_data does not hit in storage
        , .CHECK_ORDER_OLDEST                   ( 1 ) //0:none, 1:out_valid issued & out_data is not the oldest data in storage
        , .CHECK_OF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_UF                             ( 1 ) //0:none, 1:storage counter has overflow or underflow
        , .CHECK_IN_V                           ( 1 ) //0:none, 1:in_valid deasserts before taken
        , .CHECK_IN_DATA                        ( 1 ) //0:none, 1:in_data changes before taken
        , .CHECK_OUT_V                          ( 1 ) //0:none, 1:out_valid deasserts before taken
        , .CHECK_OUT_DATA                       ( 1 ) //0:none, 1:out_data changes before taken
) i_hqm_jg_transfer_checker_MODEL_enq_data_hcw (
          .clk                                  ( clk )
        , .rst_n                                ( rst_n )
        , .in_valid                             ( MODEL_enq_data_hcw_in_valid )
        , .in_taken                             ( MODEL_enq_data_hcw_in_taken )
        , .in_data                              ( MODEL_enq_data_hcw_in_data  )
        , .out_valid                            ( MODEL_enq_data_hcw_out_valid )
        , .out_taken                            ( MODEL_enq_data_hcw_out_taken )
        , .out_data                             ( MODEL_enq_data_hcw_out_data )
        , .drop_valid                           ( '0 )
        , .drop_data                            ( '0 )
        , .reset_count_valid                    ( 1'b0 )
        , .stall_count_valid                    ( 1'b0 )
) ;
//====================================================================================================
//====================================================================================================









//====================================================================================================
//====================================================================================================

//--------------------------------------------------
// TARGET INTERFACE
typedef struct packed {
logic [1:0] cmd_rtype ;
logic cmd_nfs_err ;
logic [1:0] tfmt ;
logic [4:0] ttype ;
logic [3:0] ttc ;
logic tth ;
logic tep ;
logic tro ;
logic tns ;
logic tido ;
logic tchain ;
logic [1:0] tat ;
logic [9:0] tlength ;
logic [15:0] trqid ;
logic [7:0] ttag ;
logic [3:0] tlbe ;
logic [3:0] tfbe ;
logic [TMAX_ADDR:0] taddress ;
logic [RS_WIDTH:0] trs ;
logic ttd ;
logic [31:0] tecrc ;
logic tcparity ;
logic [SRC_ID_WIDTH:0] tsrc_id ;
logic [DST_ID_WIDTH:0] tdest_id ;
logic [SAI_WIDTH:0] tsai ;
logic [PASIDTLP_WIDTH:0] tpasidtlp ;
logic trsvd1_7 ;
logic trsvd1_3 ;
} target_cmd_t ;

logic [ ( 32 ) - 1 : 0 ] target_cmd_counter_f , target_cmd_counter_nxt ;
logic [ ( 32 ) - 1 : 0 ] target_data_counter_f , target_data_counter_nxt , target_data_counter_p1 , target_data_counter_p2 , target_data_counter_p3 , target_data_counter_p4 ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    target_cmd_counter_f <= '0 ;
    target_data_counter_f <= '0 ;

  end
  else begin
    target_cmd_counter_f <= target_cmd_counter_nxt ;
    target_data_counter_f <= target_data_counter_nxt ;

  end
end

localparam TARGET_BEAT_DATA = 2 ;
localparam TARGET_DEPTH_ADDR = 16 ;
localparam TARGET_DWIDTH_ADDR = $bits(target_cmd_t) ;
localparam TARGET_DEPTH_DATA = TARGET_DEPTH_ADDR * TARGET_BEAT_DATA ;
localparam TARGET_DWIDTH_DATA = TD_WIDTH+1 +1 ;
localparam TARGET_DWIDTH_ID = 8 ;
logic target_full ;
logic target_fifo_addr_push ;
target_cmd_t target_fifo_addr_push_data ;
logic [ ( TARGET_BEAT_DATA ) - 1 : 0 ] target_fifo_data_push ;
logic [ ( TARGET_BEAT_DATA * TARGET_DWIDTH_DATA ) - 1 : 0 ] target_fifo_data_push_data ;
logic target_fifo_addr_pop ;
logic target_fifo_addr_pop_datav ;
target_cmd_t target_fifo_addr_pop_data ;
logic target_fifo_data_pop ;
logic target_fifo_data_pop_datav ;
logic [ ( TARGET_DWIDTH_DATA ) - 1 : 0 ] target_fifo_data_pop_data ;
hqm_jg_addrdata_fifo #(
 .DEPTH_ADDR ( TARGET_DEPTH_ADDR )
, .DWIDTH_ADDR ( TARGET_DWIDTH_ADDR )
, .DEPTH_DATA ( TARGET_DEPTH_DATA )
, .DWIDTH_DATA ( TARGET_DWIDTH_DATA )
, .BEAT_DATA ( TARGET_BEAT_DATA )
, .DWIDTH_ID ( TARGET_DWIDTH_ID )
) i_target (
 .clk ( clk )
, .rst_n ( rst_n )
, .full ( target_full )
, .fifo_addr_push ( target_fifo_addr_push )
, .fifo_addr_push_data ( target_fifo_addr_push_data )
, .fifo_data_push ( target_fifo_data_push )
, .fifo_data_push_data ( target_fifo_data_push_data )
, .fifo_addr_pop ( target_fifo_addr_pop )
, .fifo_addr_pop_datav ( target_fifo_addr_pop_datav )
, .fifo_addr_pop_data ( target_fifo_addr_pop_data )
, .fifo_data_pop ( target_fifo_data_pop )
, .fifo_data_pop_datav ( target_fifo_data_pop_datav )
, .fifo_data_pop_data ( target_fifo_data_pop_data )
) ;

//target general random
logic [ ( 64 ) - 1 : 0 ] target_rand ;

//target select command
logic [ ( 4 ) - 1 : 0 ] target_rand_mod ;

//target CFG & CSR random addr control
logic [ ( 32 ) - 1 : 0 ] target_rand_iosf_cfg_addr ;
logic [ ( 28 ) - 1 : 0 ] target_rand_iosf_int_mmio_csr_addr ;
logic [ ( 4 ) - 1 : 0 ] target_rand_iosf_ext_mmio_csr_addr3128 ;
logic [ ( 28 ) - 1 : 0 ] target_rand_iosf_ext_mmio_csr_addr ;

//target HCW random variables
logic [ ( 8 ) - 1 : 0 ] target_rand_hcw_dir_pp ;
logic [ ( 8 ) - 1 : 0 ] target_rand_hcw_ldb_pp ;
logic [ ( 1 ) - 1 : 0 ] target_rand_hcw_is_ldb ;
logic [ ( 1 ) - 1 : 0 ] target_rand_hcw_is_nm_pf ;
logic [ ( 4 ) - 1 : 0 ] target_rand_hcw_cl ;
logic [ ( 6 ) - 1 : 0 ] target_rand_hcw_1hcw_addr ;
logic [ ( 6 ) - 1 : 0 ] target_rand_hcw_2hcw_addr ;
logic [ ( 6 ) - 1 : 0 ] target_rand_hcw_3hcw_addr ;
logic [ ( 6 ) - 1 : 0 ] target_rand_hcw_4hcw_addr ;

//--------------------------------------------------
// SCHEDULE INTERFACE
logic [ ( 32 ) - 1 : 0 ] schedule_cmd_counter_f , schedule_cmd_counter_nxt ;
logic [ ( 32 ) - 1 : 0 ] schedule_data_counter_f , schedule_data_counter_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin
  if ( ~ rst_n ) begin
    schedule_cmd_counter_f <= '0 ;
    schedule_data_counter_f <= '0 ;

  end
  else begin
    schedule_cmd_counter_f <= schedule_cmd_counter_nxt ;
    schedule_data_counter_f <= schedule_data_counter_nxt ;

  end
end

localparam SCHEDULE_BEAT_DATA = 2 ;
localparam SCHEDULE_DEPTH_ADDR = 16 ;
localparam SCHEDULE_DWIDTH_ADDR = $bits(HqmPhCmd_t) ;
localparam SCHEDULE_DEPTH_DATA = SCHEDULE_DEPTH_ADDR * SCHEDULE_BEAT_DATA ;
localparam SCHEDULE_DWIDTH_DATA = $bits(CdData_t) ;
localparam SCHEDULE_DWIDTH_ID = 8 ;
logic schedule_full ;
logic schedule_fifo_addr_push ;
HqmPhCmd_t schedule_fifo_addr_push_data ;
logic [ ( SCHEDULE_BEAT_DATA ) - 1 : 0 ] schedule_fifo_data_push ;
logic [ ( SCHEDULE_BEAT_DATA * SCHEDULE_DWIDTH_DATA ) - 1 : 0 ] schedule_fifo_data_push_data ;
CdData_t schedule_fifo_data_push_data_0 , schedule_fifo_data_push_data_1 ;
logic schedule_fifo_addr_pop ;
logic schedule_fifo_addr_pop_datav ;
HqmPhCmd_t schedule_fifo_addr_pop_data ;
logic schedule_fifo_data_pop ;
logic schedule_fifo_data_pop_datav ;
CdData_t schedule_fifo_data_pop_data ;
hqm_jg_addrdata_fifo #(
 .DEPTH_ADDR ( SCHEDULE_DEPTH_ADDR )
, .DWIDTH_ADDR ( SCHEDULE_DWIDTH_ADDR )
, .DEPTH_DATA ( SCHEDULE_DEPTH_DATA )
, .DWIDTH_DATA ( SCHEDULE_DWIDTH_DATA )
, .BEAT_DATA ( SCHEDULE_BEAT_DATA )
, .DWIDTH_ID ( SCHEDULE_DWIDTH_ID )
, .PROTOCOL ( 1 )
) i_schedule (
 .clk ( clk )
, .rst_n ( rst_n )
, .full ( schedule_full )
, .fifo_addr_push ( schedule_fifo_addr_push )
, .fifo_addr_push_data ( schedule_fifo_addr_push_data )
, .fifo_data_push ( schedule_fifo_data_push )
, .fifo_data_push_data ( schedule_fifo_data_push_data )
, .fifo_addr_pop ( schedule_fifo_addr_pop )
, .fifo_addr_pop_datav ( schedule_fifo_addr_pop_datav )
, .fifo_addr_pop_data ( schedule_fifo_addr_pop_data )
, .fifo_data_pop ( schedule_fifo_data_pop )
, .fifo_data_pop_datav ( schedule_fifo_data_pop_datav )
, .fifo_data_pop_data ( schedule_fifo_data_pop_data )
) ;

//schedule general random
logic [ ( 4 ) - 1 : 0 ] schedule_rand_mod ;

//target HCW random variables
logic [ ( 23 ) - 1 : 0 ] schedule_passidtlp ;
logic schedule_ldb_cq ;
logic [ ( 5 ) - 1 : 0 ] schedule_rid ;

logic [ ( 8 ) - 1 : 0 ] schedule_data_counter_p1 ;
logic [ ( 8 ) - 1 : 0 ] schedule_data_counter_p2 ;
logic [ ( 8 ) - 1 : 0 ] schedule_data_counter_p3 ;
logic [ ( 8 ) - 1 : 0 ] schedule_data_counter_p4 ;




always_comb begin


//----------------------------------------------------------------------------------------------------
// MODEL for CFG & CSR access 
  MODEL_cfg_ram_nxt = MODEL_cfg_ram_f ;

  MODEL_master_cmd_cfg_in_valid = '0 ;
  MODEL_master_cmd_cfg_in_taken = '0 ;
  MODEL_master_cmd_cfg_in_data = '0 ;
  MODEL_master_cmd_cfg_out_valid = '0 ;
  MODEL_master_cmd_cfg_out_taken = '0 ;
  MODEL_master_cmd_cfg_out_data = '0 ;

  MODEL_master_data_cfg_in_valid = '0 ;
  MODEL_master_data_cfg_in_taken = '0 ;
  MODEL_master_data_cfg_in_data = '0 ;
  MODEL_master_data_cfg_out_valid = '0 ;
  MODEL_master_data_cfg_out_taken = '0 ;
  MODEL_master_data_cfg_out_data = '0 ;

//----------------------------------------------------------------------------------------------------
// MODEL for HCW sched access
  MODEL_master_cmd_hcw_in_valid = '0 ;
  MODEL_master_cmd_hcw_in_taken = '0 ;
  MODEL_master_cmd_hcw_in_data = '0 ;
  MODEL_master_cmd_hcw_out_valid = '0 ;
  MODEL_master_cmd_hcw_out_taken = '0 ;
  MODEL_master_cmd_hcw_out_data = '0 ;
  
  MODEL_master_data_hcw_in_valid = '0 ;
  MODEL_master_data_hcw_in_taken = '0 ;
  MODEL_master_data_hcw_in_data = '0 ;
  MODEL_master_data_hcw_out_valid = '0 ;
  MODEL_master_data_hcw_out_taken = '0 ;
  MODEL_master_data_hcw_out_data = '0 ;

//----------------------------------------------------------------------------------------------------
// MODEL for HCW enqueue access
  MODEL_enq_data_hcw_in_valid = '0 ;
  MODEL_enq_data_hcw_in_taken = '0 ;
  MODEL_enq_data_hcw_in_data = '0 ;
  MODEL_enq_data_hcw_out_valid = '0 ;
  MODEL_enq_data_hcw_out_taken = '0 ;
  MODEL_enq_data_hcw_out_data = '0 ;






//----------------------------------------------------------------------------------------------------
// DRIVE target state
  target_cmd_counter_nxt = target_cmd_counter_f ;
  if ( target_cmd_counter_nxt == 32'hffffffff ) begin target_cmd_counter_nxt = 32'h00; end
  target_data_counter_nxt = target_data_counter_f ;
  target_data_counter_p1 = target_data_counter_f + 32'd1 ;
  target_data_counter_p2 = target_data_counter_f + 32'd2 ;
  target_data_counter_p3 = target_data_counter_f + 32'd3 ;
  target_data_counter_p4 = target_data_counter_f + 32'd4 ;

  target_fifo_addr_push = '0 ;
  target_fifo_addr_push_data = '0 ;
  target_fifo_addr_pop = '0 ;
  target_fifo_data_push = '0 ;
  target_fifo_data_push_data = '0 ;
  target_fifo_data_pop = '0 ;

//TODO: override for DEBUF
target_rand_mod = 4'd0 ;

  if ( ( ~ target_full ) 
     ) begin

    //----------------------------------------------------------------------------------------------------
    // Completion Access

    if ( target_rand_mod == 4'd1 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd2 ;
      target_fifo_addr_push_data.tfmt                     = 2'd0 ;
      target_fifo_addr_push_data.ttype                    = 5'd10 ;
      target_fifo_addr_push_data.tlength                  = 10'd0 ;
      target_fifo_addr_push_data.taddress                 = { target_rand  } ;
    end
  
    // Completion w/ Data (1DW)
    if ( target_rand_mod == 4'd2 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd2 ;
      target_fifo_addr_push_data.tfmt                     = 2'd2 ;
      target_fifo_addr_push_data.ttype                    = 5'd10 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.taddress                 = { target_rand  } ;
  
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 224'd0 , target_data_counter_nxt } ;
    end

    //----------------------------------------------------------------------------------------------------
    // CFG Access

    //--------------------------------------------------
    // Non-Posted CfgRd0 (1DW)
    if ( target_rand_mod == 4'd3 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd1 ;
      target_fifo_addr_push_data.tfmt                     = 2'd0 ;
      target_fifo_addr_push_data.ttype                    = 5'd4 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.taddress[31:0]           = target_rand_iosf_cfg_addr ;
    end
  
    // Non-Posted CfgWr0 (1DW)
    if ( target_rand_mod == 4'd4 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd1 ;
      target_fifo_addr_push_data.tfmt                     = 2'd2 ;
      target_fifo_addr_push_data.ttype                    = 5'd4 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.taddress[31:0]           = target_rand_iosf_cfg_addr ;
  
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 224'd0 , target_data_counter_nxt } ;
    end

    //----------------------------------------------------------------------------------------------------
    // MMIO CSR Access

    //--------------------------------------------------
    // Posted MWr32 (1DW) : IOSF Internal MMIO CSR write
    if ( target_rand_mod == 4'd5 ) begin
      target_fifo_addr_push                               = 1'b1 ; 
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd2 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_csr_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[31:28]          = 4'd0 ;
      target_fifo_addr_push_data.taddress[27:0]           = target_rand_iosf_int_mmio_csr_addr ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 224'd0 , target_data_counter_nxt } ;
    end
    // Non-Posted MRd32 (1DW) : IOSF Internal MMIO CSR read
    if ( target_rand_mod == 4'd6 ) begin
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push                               = 1'b1 ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd1 ;
      target_fifo_addr_push_data.tfmt                     = 2'd0 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_csr_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[31:28]          = 4'd0 ;
      target_fifo_addr_push_data.taddress[27:0]           = target_rand_iosf_int_mmio_csr_addr ;
    end


    //----------------------------------------------------------------------------------------------------
    // MMIO CSR Access

    //non zero CSR bar requires MWr64 & MRd64 to access externio MMIO
    //--------------------------------------------------
    // Posted MWr64 (1DW) : IOSF External MMIO CSR write
    if ( target_rand_mod == 4'd7 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_csr_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[31:28]          = target_rand_iosf_ext_mmio_csr_addr3128 ;
      target_fifo_addr_push_data.taddress[27:0]           = target_rand_iosf_ext_mmio_csr_addr ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 224'd0 , target_data_counter_nxt } ;
    end
    // Non-Posted MRd64 (1DW) : IOSF External MMIO CSR read
    if ( target_rand_mod == 4'd8 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd1 ;
      target_fifo_addr_push_data.tfmt                     = 2'd1 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_csr_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[31:28]          = target_rand_iosf_ext_mmio_csr_addr3128 ;
      target_fifo_addr_push_data.taddress[27:0]           = target_rand_iosf_ext_mmio_csr_addr ;
    end


    //----------------------------------------------------------------------------------------------------
    // HCW enqueue

    //--------------------------------------------------
    // Posted MWr64 (1DW) :  PF enqueue 1 HCW
    if ( target_rand_mod == 4'd9 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_1hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd1 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 128'd0  , 96'd0,target_data_counter_p1 } ;
    end
    //--------------------------------------------------
    // Posted MWr64 (1DW) : PF enqueue 2 HCW
    if ( target_rand_mod == 4'd10 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd2 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_2hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd2 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p2  , 96'd0,target_data_counter_p1 } ;
    end

    //--------------------------------------------------
    // Posted MWr64 (1DW) : PF enqueue 3 HCW
    if ( target_rand_mod == 4'd11 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd3 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'hf ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_3hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd3 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p2  , 96'd0,target_data_counter_p1 } ;
      target_fifo_data_push [ ( 1 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 1 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 128'd0  , 96'd0,target_data_counter_p3 } ;
    end

    //--------------------------------------------------
    // Posted MWr64 (1DW) : PF enqueue 4 HCW
    if ( target_rand_mod == 4'd12 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd4 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'hf ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_pf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_4hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd3 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p2  , 96'd0,target_data_counter_p1 } ;
      target_fifo_data_push [ ( 1 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 1 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p4  , 96'd0,target_data_counter_p3 } ;
    end

    //--------------------------------------------------
    // Posted MWr64 (1DW) : VF enqueue 1 HCW
    if ( target_rand_mod == 4'd13 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd1 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_vf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_1hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd1 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 128'd0  , 96'd0,target_data_counter_p1 } ;
    end
    //--------------------------------------------------
    // Posted MWr64 (1DW) : VF enqueue 2 HCW
    if ( target_rand_mod == 4'd14 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd2 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'h0 ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_vf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_2hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd2 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p2  , 96'd0,target_data_counter_p1 } ;
    end

    //--------------------------------------------------
    // Posted MWr64 (1DW) : VF enqueue 3 HCW
    if ( target_rand_mod == 4'd15 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd3 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'hf ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_vf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_3hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd3 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p2  , 96'd0,target_data_counter_p1 } ;
      target_fifo_data_push [ ( 1 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 1 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 128'd0  , 96'd0,target_data_counter_p3 } ;
    end

    //--------------------------------------------------
    // Posted MWr64 (1DW) : VF enqueue 4 HCW
    if ( target_rand_mod == 4'd16 ) begin
      target_fifo_addr_push                               = 1'b1 ;
      target_cmd_counter_nxt = target_cmd_counter_nxt + 32'd1 ;
      target_fifo_addr_push_data.ttag                     = target_cmd_counter_nxt[7:0] ;
      target_fifo_addr_push_data.cmd_rtype                = 2'd0 ;
      target_fifo_addr_push_data.tfmt                     = 2'd3 ;
      target_fifo_addr_push_data.ttype                    = 5'd0 ;
      target_fifo_addr_push_data.tlength                  = 10'd4 ;
      target_fifo_addr_push_data.tfbe                     = 4'hf ;
      target_fifo_addr_push_data.tlbe                     = 4'hf ;
      target_fifo_addr_push_data.taddress[63:32]          = CFG_func_vf_bar[63:32] ;
      target_fifo_addr_push_data.taddress[21]             = target_rand_hcw_is_nm_pf ;
      target_fifo_addr_push_data.taddress[20]             = target_rand_hcw_is_ldb ;
      target_fifo_addr_push_data.taddress[19:12]          = target_rand_hcw_is_ldb ? target_rand_hcw_ldb_pp : target_rand_hcw_dir_pp ;
      target_fifo_addr_push_data.taddress[9:6]            = target_rand_hcw_cl ;
      target_fifo_addr_push_data.taddress[5:0]            = target_rand_hcw_4hcw_addr ;
      target_data_counter_nxt = target_data_counter_nxt + 32'd3 ;
      target_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 0 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p2  , 96'd0,target_data_counter_p1 } ;
      target_fifo_data_push [ ( 1 * 1 ) +: 1 ]            = 1'b1 ;
      target_fifo_data_push_data [ ( 1 * TARGET_DWIDTH_DATA ) +: TARGET_DWIDTH_DATA ] = { 1'b0 , 96'd0,target_data_counter_p4  , 96'd0,target_data_counter_p3 } ;
    end
  end


  //
  cmd_put = '0 ;
  cmd_rtype = '0 ;
  cmd_nfs_err = '0 ;
  tfmt = '0 ;
  ttype = '0 ;
  ttc = '0 ;
  tth = '0 ;
  tep = '0 ;
  tro = '0 ;
  tns = '0 ;
  tido = '0 ;
  tchain = '0 ;
  tat = '0 ;
  tlength = '0 ;
  trqid = '0 ;
  ttag = '0 ;
  tlbe = '0 ;
  tfbe = '0 ;
  taddress = '0 ;
  trs = '0 ;
  ttd = '0 ;
  tecrc = '0 ;
  tcparity = '0 ;
  tsrc_id = '0 ;
  tdest_id = '0 ;
  tsai = '0 ;
  tpasidtlp = '0 ;
  trsvd1_7 = '0 ;
  trsvd1_3 = '0 ;
  tdata = '0 ;
  tdparity = '0 ;
  
  if ( target_fifo_addr_pop_datav
     & ( ( ( target_fifo_addr_pop_data.cmd_rtype == 2'd0 ) & ( prim_cmd_credit_cnt_q[0*8 +: 8] > 8'd0 ) & ( prim_dat_credit_cnt_q[0*8 +: 8] > 8'd0 ) )
       | ( ( target_fifo_addr_pop_data.cmd_rtype == 2'd1 ) & ( prim_cmd_credit_cnt_q[1*8 +: 8] > 8'd0 ) & ( prim_dat_credit_cnt_q[1*8 +: 8] > 8'd0 ) )
       | ( ( target_fifo_addr_pop_data.cmd_rtype == 2'd2 ) & ( prim_cmd_credit_cnt_q[2*8 +: 8] > 8'd0 ) & ( prim_dat_credit_cnt_q[2*8 +: 8] > 8'd0 ) )
       | ( ( target_fifo_addr_pop_data.cmd_rtype == 2'd3 ) & ( prim_cmd_credit_cnt_q[3*8 +: 8] > 8'd0 ) & ( prim_dat_credit_cnt_q[3*8 +: 8] > 8'd0 ) )
       )
     ) begin
    target_fifo_addr_pop = 1'b1 ;
    cmd_put = 1'b1 ;
    cmd_rtype = target_fifo_addr_pop_data.cmd_rtype ;
    cmd_nfs_err = target_fifo_addr_pop_data.cmd_nfs_err ;
    tfmt = target_fifo_addr_pop_data.tfmt ;
    ttype = target_fifo_addr_pop_data.ttype ;
    ttc = target_fifo_addr_pop_data.ttc ;
    tth = target_fifo_addr_pop_data.tth ;
    tep = target_fifo_addr_pop_data.tep ;
    tro = target_fifo_addr_pop_data.tro ;
    tns = target_fifo_addr_pop_data.tns ;
    tido = target_fifo_addr_pop_data.tido ;
    tchain = target_fifo_addr_pop_data.tchain ;
    tat = target_fifo_addr_pop_data.tat ;
    tlength = target_fifo_addr_pop_data.tlength ;
    trqid = target_fifo_addr_pop_data.trqid ;
    ttag = target_fifo_addr_pop_data.ttag ;
    tlbe = target_fifo_addr_pop_data.tlbe ;
    tfbe = target_fifo_addr_pop_data.tfbe ;
    taddress = target_fifo_addr_pop_data.taddress ;
    trs = target_fifo_addr_pop_data.trs ;
    ttd = target_fifo_addr_pop_data.ttd ;
    tecrc = target_fifo_addr_pop_data.tecrc ;
    tcparity = ^{target_fifo_addr_pop_data.tfmt,target_fifo_addr_pop_data.ttype,target_fifo_addr_pop_data.ttc,target_fifo_addr_pop_data.tep,target_fifo_addr_pop_data.tro,target_fifo_addr_pop_data.tns,target_fifo_addr_pop_data.tido,target_fifo_addr_pop_data.tth,target_fifo_addr_pop_data.tat,target_fifo_addr_pop_data.tlength,target_fifo_addr_pop_data.trqid,target_fifo_addr_pop_data.ttag,target_fifo_addr_pop_data.tlbe,target_fifo_addr_pop_data.tfbe,target_fifo_addr_pop_data.taddress,target_fifo_addr_pop_data.trs,target_fifo_addr_pop_data.ttd,target_fifo_addr_pop_data.tpasidtlp,target_fifo_addr_pop_data.trsvd1_7,target_fifo_addr_pop_data.trsvd1_3};

    tsrc_id = target_fifo_addr_pop_data.tsrc_id ;
    tdest_id = target_fifo_addr_pop_data.tdest_id ;
    tsai = target_fifo_addr_pop_data.tsai ;
    tpasidtlp = target_fifo_addr_pop_data.tpasidtlp ;
    trsvd1_7 = target_fifo_addr_pop_data.trsvd1_7 ;
    trsvd1_3 = target_fifo_addr_pop_data.trsvd1_3 ;
  end
  if ( target_fifo_data_pop_datav ) begin
    target_fifo_data_pop = 1'b1 ;
    { tdparity , tdata } = target_fifo_data_pop_data ;
  end















//----------------------------------------------------------------------------------------------------
// DRIVE schedule state
  schedule_cmd_counter_nxt = schedule_cmd_counter_f ;
  schedule_data_counter_nxt = schedule_data_counter_f ;

  schedule_fifo_addr_push = '0 ;
  schedule_fifo_addr_push_data = '0 ;
  schedule_fifo_addr_pop = '0 ;
  schedule_fifo_data_push = '0 ;
  schedule_fifo_data_push_data = '0 ;
  schedule_fifo_data_pop = '0 ;

  schedule_data_counter_p1 = schedule_data_counter_f + 32'd1 ;
  schedule_data_counter_p2 = schedule_data_counter_f + 32'd2 ;
  schedule_data_counter_p3 = schedule_data_counter_f + 32'd3 ;
  schedule_data_counter_p4 = schedule_data_counter_f + 32'd4 ;

  schedule_fifo_data_push_data_0 = '0 ;
  schedule_fifo_data_push_data_1 = '0 ;

//TODO: override for DEBUF
schedule_rand_mod = 4'd1 ;

  if ( ( ~ schedule_full )
     ) begin

    //--------------------------------------------------
    //  1 HCW
    if ( schedule_rand_mod == 4'd1 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = schedule_ldb_cq ;
      schedule_fifo_addr_push_data.wtype                    = '0 ;
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd16 ;
      schedule_fifo_addr_push_data.add                      = { 28'd0 , schedule_cmd_counter_nxt , 2'd0 } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd1 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 128'd0  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
    end

    //--------------------------------------------------
    //  2 HCW
    if ( schedule_rand_mod == 4'd2 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = schedule_ldb_cq ;
      schedule_fifo_addr_push_data.wtype                    = '0 ;
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd32 ;
      schedule_fifo_addr_push_data.add                      = { 30'd0 , schedule_cmd_counter_nxt } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd2 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 96'd0,schedule_data_counter_p2  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
    end

    //--------------------------------------------------
    //  3 HCW
    if ( schedule_rand_mod == 4'd3 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = schedule_ldb_cq ;
      schedule_fifo_addr_push_data.wtype                    = '0 ;
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd48 ;
      schedule_fifo_addr_push_data.add                      = { 30'd0 , schedule_cmd_counter_nxt } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd3 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b0 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 96'd0,schedule_data_counter_p2  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push_data_1.sop                    = 1'b0 ;
      schedule_fifo_data_push_data_1.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_1.error                  = 1'b0 ;
      schedule_fifo_data_push_data_1.data                   = { 128'd0  , 96'd0,schedule_data_counter_p3 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_1.eop , schedule_fifo_data_push_data_1.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
      schedule_fifo_data_push [ ( 1 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 1 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_1 ;
    end

    //--------------------------------------------------
    //  4 HCW
    if ( schedule_rand_mod == 4'd4 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = schedule_ldb_cq ;
      schedule_fifo_addr_push_data.wtype                    = '0 ;
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd64 ;
      schedule_fifo_addr_push_data.add                      = { 30'd0 , schedule_cmd_counter_nxt } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd4 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b0 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 96'd0,schedule_data_counter_p2  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push_data_1.sop                    = 1'b0 ;
      schedule_fifo_data_push_data_1.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_1.error                  = 1'b0 ;
      schedule_fifo_data_push_data_1.data                   = {  96'd0,schedule_data_counter_p4  , 96'd0,schedule_data_counter_p3 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_1.eop , schedule_fifo_data_push_data_1.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
      schedule_fifo_data_push [ ( 1 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 1 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_1 ;
    end

    //--------------------------------------------------
    //  MSI
    if ( schedule_rand_mod == 4'd5 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = schedule_ldb_cq ;
      schedule_fifo_addr_push_data.wtype                    = 2'd1 ; 
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd4 ;
      schedule_fifo_addr_push_data.add                      = { 30'd0 , schedule_cmd_counter_nxt } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd1 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 128'd0  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
    end

    //--------------------------------------------------
    //  MSI-X
    if ( schedule_rand_mod == 4'd6 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = '0 ;
      schedule_fifo_addr_push_data.wtype                    = 2'd2 ; 
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd4 ;
      schedule_fifo_addr_push_data.add                      = { 30'd0 , schedule_cmd_counter_nxt } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd1 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 128'd0  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
    end

    //--------------------------------------------------
    //  IMS
    if ( schedule_rand_mod == 4'd7 ) begin
      schedule_fifo_addr_push                               = 1'b1 ;
      schedule_cmd_counter_nxt = schedule_cmd_counter_nxt + 32'd1 ;
      schedule_fifo_addr_push_data.invalid                  = 1'b0 ;
      schedule_fifo_addr_push_data.ldb_cq                   = '0 ;
      schedule_fifo_addr_push_data.wtype                    = 2'd3 ; 
      schedule_fifo_addr_push_data.ro                       = '0 ;
      schedule_fifo_addr_push_data.spare                    = '0 ;
      schedule_fifo_addr_push_data.pasidtlp                 = schedule_passidtlp ;
      schedule_fifo_addr_push_data.rid                      = schedule_rid ;
      schedule_fifo_addr_push_data.length                   = 7'd4 ;
      schedule_fifo_addr_push_data.add                      = { 30'd0 , schedule_cmd_counter_nxt } ;
      schedule_fifo_addr_push_data.tc_sel                   = '0 ;
      schedule_fifo_addr_push_data.par                      = ^ { schedule_fifo_addr_push_data.invalid ,schedule_fifo_addr_push_data.ldb_cq ,schedule_fifo_addr_push_data.wtype ,schedule_fifo_addr_push_data.ro ,schedule_fifo_addr_push_data.spare ,schedule_fifo_addr_push_data.pasidtlp ,schedule_fifo_addr_push_data.rid ,schedule_fifo_addr_push_data.tc_sel } ;
      schedule_fifo_addr_push_data.len_par                  = ^ { schedule_fifo_addr_push_data.length } ;
      schedule_fifo_addr_push_data.add_par                  = ^ { schedule_fifo_addr_push_data.add } ;

      schedule_data_counter_nxt = schedule_data_counter_nxt + 32'd1 ;
      schedule_fifo_data_push_data_0.sop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.eop                    = 1'b1 ;
      schedule_fifo_data_push_data_0.error                  = 1'b0 ;
      schedule_fifo_data_push_data_0.data                   = { 128'd0  , 96'd0,schedule_data_counter_p1 } ;
      schedule_fifo_data_push_data_0.dpar                   = ^ { schedule_fifo_data_push_data_0.eop , schedule_fifo_data_push_data_0.data } ;
      schedule_fifo_data_push [ ( 0 * 1 ) +: 1 ]            = 1'b1 ;
      schedule_fifo_data_push_data [ ( 0 * SCHEDULE_DWIDTH_DATA ) +: SCHEDULE_DWIDTH_DATA ] = schedule_fifo_data_push_data_0 ;
    end


  end

  //
  phdr_fifo_push = '0 ;
  phdr_fifo_push_data = '0 ;
  pdata_fifo_push = '0 ;
  pdata_fifo_push_data = '0 ;

  if ( schedule_fifo_addr_pop_datav
     & ~ phdr_fifo_afull
     ) begin
    phdr_fifo_push               = schedule_fifo_addr_pop_datav ;
    phdr_fifo_push_data          = schedule_fifo_addr_pop_data ;
    schedule_fifo_addr_pop       = 1'b1 ;
  end

  if ( schedule_fifo_data_pop_datav
     & ~ pdata_fifo_afull
     ) begin
    pdata_fifo_push              = schedule_fifo_data_pop_datav ;
    pdata_fifo_push_data         = schedule_fifo_data_pop_data ;
    schedule_fifo_data_pop       = 1'b1 ;
  end

end
//====================================================================================================
//====================================================================================================


































//====================================================================================================
//====================================================================================================
// COVERAGE
logic [ 31 : 0 ] total_f , total_nxt ;
always_ff @(posedge clk or negedge rst_n) begin
 if (~rst_n) begin
 total_f <= '0 ;
 end else begin
 total_f <= total_nxt ;
 end
end
assign total_nxt = total_f + 32'd1 ;



cover_hqm_jg_iosf_target_rand_mod_00: cover property( @( posedge clk ) disable iff( ~rst_n )   (                              ( target_fifo_addr_push & ( target_rand_mod == 4'd0 ) )     ) );
cover_hqm_jg_iosf_target_rand_mod_07: cover property( @( posedge clk ) disable iff( ~rst_n )   (                              ( target_fifo_addr_push & ( target_rand_mod == 4'd7 ) )     ) );

cover_hqm_jg_iosf_schedule_rand_mod_00: cover property( @( posedge clk ) disable iff( ~rst_n )   (                              ( schedule_fifo_addr_push & ( schedule_rand_mod == 4'd0 ) )     ) );
cover_hqm_jg_iosf_schedule_rand_mod_01: cover property( @( posedge clk ) disable iff( ~rst_n )   (                              ( schedule_fifo_addr_push & ( schedule_rand_mod == 4'd1 ) )     ) );

cover_hqm_jg_iosf_if_cmd_put_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( cmd_put ) );
cover_hqm_jg_iosf_if_cmd_put_04: cover property( @( posedge clk ) disable iff( ~rst_n ) ( (total_f > 32'd5) & $past(cmd_put,4)   ) );
cover_hqm_jg_iosf_if_cmd_put_14: cover property( @( posedge clk ) disable iff( ~rst_n ) ( (total_f > 32'd15) & $past(cmd_put,14)   ) );
cover_hqm_jg_iosf_if_req_put_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( req_put ) );
cover_hqm_jg_iosf_if_psel_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( psel ) );
cover_hqm_jg_iosf_if_psel_14: cover property( @( posedge clk ) disable iff( ~rst_n ) ( (total_f > 32'd15) & $past(psel,14) ) );
cover_hqm_jg_iosf_if_penable_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( penable ) );
cover_hqm_jg_iosf_if_pready_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( pready ) );
cover_hqm_jg_iosf_if_hcw_enq_in_v_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( hcw_enq_in_v ) );
cover_hqm_jg_iosf_if_phdr_fifo_push_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( phdr_fifo_push ) );
cover_hqm_jg_iosf_if_pdata_fifo_push_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( pdata_fifo_push ) );
cover_hqm_jg_iosf_if_pdata_fifo_push_14: cover property( @( posedge clk ) disable iff( ~rst_n ) ( (total_f > 32'd15) & $past(pdata_fifo_push,14) ) );
cover_hqm_jg_iosf_if_gnt_00: cover property( @( posedge clk ) disable iff( ~rst_n ) ( gnt ) );
cover_hqm_jg_iosf_if_gnt_14: cover property( @( posedge clk ) disable iff( ~rst_n ) ( (total_f > 32'd15) & $past(gnt,14) ) );



endmodule
