// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name  : hqm_msg_wrapper
// -- Author       : 
// -- Project      : CPM 1.7 (Bell Creek)
// -- Description  :
// -- 
// --   This files instances the Fuse Puller and TGT Message and MST 
// --   Message handler logic.
// --
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_msg_wrapper 

    import hqm_sif_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*;
#(

  // SB SAI Extended Header Params
  parameter TX_EXT_HEADER_SUPPORT            = HQMIOSF_TX_EXT_HEADER_SUPPORT                        , 
  parameter NUM_TX_EXT_HEADERS               = HQMIOSF_NUM_TX_EXT_HEADERS                           , // number of extended headers to send 
  parameter RX_EXT_HEADER_SUPPORT            = HQMIOSF_RX_EXT_HEADER_SUPPORT                        , // set to nonzero if extended headers can be received.
  parameter NUM_RX_EXT_HEADERS               = HQMIOSF_NUM_RX_EXT_HEADERS                           , // number of extended headers to receive
  parameter [NUM_RX_EXT_HEADERS:0][7:0] 
                           RX_EXT_HEADER_IDS = HQMIOSF_RX_EXT_HEADER_IDS                            , 

  // SB Target Params
  parameter MAXTRGTADDR                      = HQMEPSB_MAX_TGT_ADR                                  , // Maximum address/data bits supported by the
  parameter MAXTRGTDATA                      = HQMEPSB_MAX_TGT_DAT                                    // master register access interface
  ) (
  // Clock gating ISM Signals Clock/Reset Signals
  input  logic                               ipclk                                                  , 
  input  logic                               ip_rst_b                                               , 
  output logic                               sbi_sbe_clkreq                                         , 
  output logic                               sbi_sbe_idle                                           , 

  // SAI for tx
  input  logic [SAI_WIDTH:0]                 strap_hqm_cmpl_sai                                     ,

  input  logic [15:0]                        strap_hqm_gpsb_srcid                                   ,
  input  logic                               strap_hqm_16b_portids                                  ,

  // Target interface to the AGENT block
  output logic                               sbi_sbe_tmsg_pcfree                                    , // 
  output logic                               sbi_sbe_tmsg_npfree                                    , // 
  output logic                               sbi_sbe_tmsg_npclaim                                   , // 
  input  logic                               sbe_sbi_tmsg_pcput                                     , // 
  input  logic                               sbe_sbi_tmsg_npput                                     , // 
  input  logic                               sbe_sbi_tmsg_pcmsgip                                   , // unused
  input  logic                               sbe_sbi_tmsg_npmsgip                                   , // 
  input  logic                               sbe_sbi_tmsg_pceom                                     , // 
  input  logic                               sbe_sbi_tmsg_npeom                                     , // 
  input  logic [31:0]                        sbe_sbi_tmsg_pcpayload                                 , // 
  input  logic [31:0]                        sbe_sbi_tmsg_nppayload                                 , // 
  input  logic                               sbe_sbi_tmsg_pccmpl                                    , // 

  // Master interface to the AGENT block
  output logic [ 1:0]                        sbi_sbe_mmsg_pcirdy                                    , // 
  output logic                               sbi_sbe_mmsg_npirdy                                    , // 
  output logic [ 1:0]                        sbi_sbe_mmsg_pceom                                     , // 
  output logic                               sbi_sbe_mmsg_npeom                                     , // 
  output logic [ 1:0][31:0]                  sbi_sbe_mmsg_pcpayload                                 , // 
  output logic [31:0]                        sbi_sbe_mmsg_nppayload                                 , // 
  input  logic                               sbe_sbi_mmsg_pctrdy                                    , // 
  input  logic                               sbe_sbi_mmsg_nptrdy                                    , // 
  input  logic                               sbe_sbi_mmsg_pcmsgip                                   , // unused
  input  logic [ 1:0]                        sbe_sbi_mmsg_pcsel                                     , // 
  input  logic                               sbe_sbi_mmsg_npsel                                     , // 

  // EP Fuses               , Straps, and Global Constants
  input  logic [EARLY_FUSES_BITS_TOT-1:0]    early_fuses                                            ,
  output hqm_sif_fuses_t                     sb_ep_fuses                                            , // Contains all fuses and straps
  output logic                               ip_ready                                               , 

  // Ingress Target Message Interface - Msg for the IP
  output hqm_sb_tgt_msg_t                    tgt_ip_msg                                             , // Tgt to IP Msg struct
  input  logic                               ip_tgt_msg_trdy                                        , // handshake for Tgt to IP  

  // Egress Target Completion Interface - Cmp from the IP
  input  hqm_sb_tgt_cmsg_t                   ip_tgt_cmsg                                            , // IP to Tgt Cmp Msg
  output logic                               tgt_ip_cmsg_free                                       , // Available free space for Cmp 

  // Ingress Master Completion Interface - Cmp to the IP
  output hqm_sb_ep_cmp_t                     tgt_ip_cmsg                                            ,

  // Egress Master Message Interface - Msg from the IP
  input  hqm_ep_sb_msg_t                     ip_mst_msg                                             , 
  output logic                               mst_ip_msg_trdy                                        ,     

  // Reset Prep Handling Interface
  input  logic                               sif_gpsb_quiesce_req                                   , // Tell Sideband to UR NPs and Drop Ps on its target
  output logic                               sif_gpsb_quiesce_ack                                     // Tell RI_IOSF_SB that the TGT is URing/Dropping NP/P

  );

  //--------------------------------------------------------------------------
  // Local Parameter definition
  //--------------------------------------------------------------------------

  // The redfuse and the ctl fuses and straps. Then subtract out the straps
  localparam FUSE_BITS_TOT                   = EARLY_FUSES_BITS_TOT                                 ;
  
  localparam FUSE_BYTES_TOT                  = ((FUSE_BITS_TOT % 8) > 0) ?
                                               ((FUSE_BITS_TOT / 8) + 1) :
                                                (FUSE_BITS_TOT / 8)                                 ; 

  //--------------------------------------------------------------------------
  // Interconnecting signals
  //--------------------------------------------------------------------------
  logic                                      fp_fuse_done_nxt                                       ; 
  logic                                      fp_fuse_done                                           ; 
  logic [(FUSE_BYTES_TOT*8)-1:0]             fp_fuses                                               ; 
  
  logic                                      sb_tmsg_pcfree                                         ; 
  logic                                      sb_tmsg_npfree                                         ; 
  logic                                      sb_tmsg_npclaim                                        ; 
  
  logic                                      mmsg_pcirdy_tgt                                        ; 
  logic                                      mmsg_pcirdy_mstr                                       ; 
  logic                                      mmsg_pceom_tgt                                         ; 
  logic                                      mmsg_pceom_mstr                                        ; 
  logic [31:0]                               mmsg_pcpayload_tgt                                     ; 
  logic [31:0]                               mmsg_pcpayload_mstr                                    ; 
  logic                                      idle_target                                            ; 
  logic                                      idle_master                                            ; 
  logic                                      mmsg_npirdy                                            ; 
  logic                                      mmsg_npeom                                             ; 
  logic [31:0]                               mmsg_nppayload                                         ; 
  
  logic                                      sb_tmsg_pcput                                          ; 
  logic                                      sb_tmsg_npput                                          ; 
  logic                                      sb_mmsg_pcsel                                          ; 
  logic [14:0]                               m_dbgbus_nc                                            ; 
  logic [15:0]                               t_dbgbus_nc                                            ; 

  // SB Data for the IP returned a FLIT at a time                                                     // FIFO Data Format:                                   
  logic [0:0]                                wad                                                    ;
  logic [FUSE_BITS_TOT-1:0]                  fp_data                                                ;
  logic                                      wen_fuse                                               ; // frame qualified FUSE_G0

  // Signals needed for the Iosf Shim (IP) to handshake with the Fuse Puller (FP)
  logic [2:0]                                tcnt_nxt                                               ;
  logic [2:0]                                tcnt                                                   ;

  assign tcnt_nxt = (tcnt < 3'd7) ? (tcnt + 3'd1) : tcnt;
  assign fp_fuse_done_nxt = (tcnt>0);

  always_ff @(posedge ipclk or negedge ip_rst_b) 
    begin: req_seq_cnt_flop_reset_p
      if(ip_rst_b == 1'b0)
        tcnt <= '0;
      else
        tcnt <= tcnt_nxt;
    end

  always_ff @(posedge ipclk or negedge ip_rst_b) 
    begin: dp_handshake_flop_reset_p
      if(ip_rst_b == 1'b0)
        begin
          fp_fuse_done <= '0;
          ip_ready <= '0;
        end
      else
        begin
          fp_fuse_done <= fp_fuse_done_nxt;
          ip_ready <= fp_fuse_done;
        end
    end

  //--------------------------------------------------------------------------
  // Capture Streamed Fuse and Strap Data
  //--------------------------------------------------------------------------

  assign wad = 1'd0 ;
  assign fp_data = early_fuses;
  assign wen_fuse = ~fp_fuse_done; 

  // Memory Structure to capture the stream of fuse and strap data from the fuse
  // puller and create a bit vector representing their values.

  hqm_fp_capture #(

     .DEFAULT   (HQMEP_FUSES_DEFAULT_VALUES)
    ,.WIDTH     (FUSE_BITS_TOT)
    ,.DEPTH     (1) 

  ) i_hqm_fp_capture_fuses (

     .ipclk     (ipclk)
    ,.ip_rst_b  (ip_rst_b)
    ,.wad       (wad)
    ,.wen       (wen_fuse)
    ,.wdi       (fp_data)
    ,.rda       (fp_fuses)
  );

  // This extracts the individual fuses out for sending to the RI.

  assign sb_ep_fuses                         = fp_fuses[FUSE_BITS_TOT-1:0]                          ; 

  //--------------------------------------------------------------------------
  // Muxing of Fuse Puller and Sb_tgt/Sb_mstr
  //--------------------------------------------------------------------------
  always_comb begin
    sbi_sbe_tmsg_pcfree                      = sb_tmsg_pcfree         ; 
    sbi_sbe_tmsg_npfree                      = sb_tmsg_npfree         ; 
    sbi_sbe_tmsg_npclaim                     = sb_tmsg_npclaim        ; 

    // nCPM supports posted for FP and SBE_TGT completions and posted
    // messages from EP
    sbi_sbe_mmsg_pcirdy                      = {mmsg_pcirdy_mstr,mmsg_pcirdy_tgt} ; //Do not send out IP READY MSG
    sbi_sbe_mmsg_pceom                       = {mmsg_pceom_mstr,mmsg_pceom_tgt} ;//Do not send out IP READY MSG
    sbi_sbe_mmsg_pcpayload                   = {mmsg_pcpayload_mstr,mmsg_pcpayload_tgt};

    // In BEK non-posted Write support for SpiWrite is added
    sbi_sbe_mmsg_npirdy                      = mmsg_npirdy            ; 
    sbi_sbe_mmsg_npeom                       = mmsg_npeom             ; 
    sbi_sbe_mmsg_nppayload                   = mmsg_nppayload         ; 

    // Combine all idle indicator and from EP
    sbi_sbe_idle                             = idle_target & idle_master & 
                                               ~ip_mst_msg.irdy       ;

    sbi_sbe_clkreq                           = ~sbi_sbe_idle          ;
  end

  // Suppress messaging to Fuse Plug or Sideband Target based on fuse plug
  // Valid bits
  always_comb begin
    sb_tmsg_pcput                            = sbe_sbi_tmsg_pcput    ; 
    sb_tmsg_npput                            = sbe_sbi_tmsg_npput    ; 
    sb_mmsg_pcsel                            = sbe_sbi_mmsg_pcsel[0] ; 
  end

  //--------------------------------------------------------------------------
  // Instantiantion of "widgets" 
  //--------------------------------------------------------------------------

  hqm_sb_mstr #(
    .NUM_TX_EHDRS                            (NUM_TX_EXT_HEADERS                                   )  
    ) i_hqm_sb_mstr (                                    
    // Clock/Reset/Idle Signals                          
    .clk                                     (ipclk                                                ), 
    .rst_b                                   (ip_rst_b                                             ), 
    .mst_idle                                (idle_master                                          ), 

    // Interface to SBE Base Endpoint
    .mst_sbe_mmsg_npirdy                     (mmsg_npirdy                                          ), 
    .mst_sbe_mmsg_npeom                      (mmsg_npeom                                           ), 
    .mst_sbe_mmsg_nppayload                  (mmsg_nppayload                                       ), 
    .sbe_mst_mmsg_nptrdy                     (sbe_sbi_mmsg_nptrdy                                  ), 
    .sbe_mst_mmsg_npsel                      (sbe_sbi_mmsg_npsel                                   ), 
    .mst_sbe_mmsg_pcirdy                     (mmsg_pcirdy_mstr                                     ), 
    .mst_sbe_mmsg_pceom                      (mmsg_pceom_mstr                                      ), 
    .mst_sbe_mmsg_pcpayload                  (mmsg_pcpayload_mstr                                  ), 
    .sbe_mst_mmsg_pctrdy                     (sbe_sbi_mmsg_pctrdy                                  ),                    
    .sbe_mst_mmsg_pcsel                      (sbe_sbi_mmsg_pcsel[1]                                ),                    

    // Constants used in generating egress messages
    .strap_hqm_gpsb_srcid                    (strap_hqm_gpsb_srcid                                 ), // Source Port ID
    .strap_hqm_16b_portids                   (strap_hqm_16b_portids                                ), // Use 16b port IDs

    // Interface to the IP
    .ip_mst_msg                              (ip_mst_msg                                           ), // Incoming Message from RI
    .mst_ip_msg_trdy                         (mst_ip_msg_trdy                                      ), // Current Message has been taken

    // Debug bus
    .mst_dbgbus                              (m_dbgbus_nc                                          )  
    );
  
  hqm_sb_tgt #(
    .MAXTRGTADDR                             (MAXTRGTADDR                                          ), 
    .MAXTRGTDATA                             (MAXTRGTDATA                                          ), 
    .RX_EXT_HEADER_SUPPORT                   (RX_EXT_HEADER_SUPPORT                                ), 
    .TX_EXT_HEADER_SUPPORT                   (TX_EXT_HEADER_SUPPORT                                ), 
    .NUM_RX_EXT_HEADERS                      (NUM_RX_EXT_HEADERS                                   ), 
    .RX_EXT_HEADER_IDS                       (RX_EXT_HEADER_IDS                                    ), 
    .NUM_TX_EXT_HEADERS                      (NUM_TX_EXT_HEADERS                                   )  
    ) i_hqm_sb_tgt (
    // Clock/Reset/Idle Signals                          
    .clk                                     (ipclk                                                ), 
    .rst_b                                   (ip_rst_b                                             ), 
    .tgt_idle                                (idle_target                                          ), 

    // Constant used for generating Egress Completions
    .strap_hqm_cmpl_sai                      (strap_hqm_cmpl_sai                                   ), // SAI values to use for RI->SB Completions
    .strap_hqm_16b_portids                   (strap_hqm_16b_portids                                ), // Use 16b port IDs
    
    // Interface to the target side of the base endpoint
    .tgt_sbe_tmsg_pcfree                     (sb_tmsg_pcfree                                       ), 
    .tgt_sbe_tmsg_npfree                     (sb_tmsg_npfree                                       ), 
    .tgt_sbe_tmsg_npclaim                    (sb_tmsg_npclaim                                      ), 
    .sbe_tgt_tmsg_pcput                      (sb_tmsg_pcput                                        ), // sbe_sbi_tmsg_pcput      
    .sbe_tgt_tmsg_npput                      (sb_tmsg_npput                                        ), // sbe_sbi_tmsg_npput      
    .sbe_tgt_tmsg_pcmsgip                    (sbe_sbi_tmsg_pcmsgip                                 ), // 
    .sbe_tgt_tmsg_npmsgip                    (sbe_sbi_tmsg_npmsgip                                 ), // 
    .sbe_tgt_tmsg_pceom                      (sbe_sbi_tmsg_pceom                                   ), // 
    .sbe_tgt_tmsg_npeom                      (sbe_sbi_tmsg_npeom                                   ), // 
    .sbe_tgt_tmsg_pcpayload                  (sbe_sbi_tmsg_pcpayload                               ), // 
    .sbe_tgt_tmsg_nppayload                  (sbe_sbi_tmsg_nppayload                               ), // 
    .sbe_tgt_tmsg_pccmpl                     (sbe_sbi_tmsg_pccmpl                                  ), // 

    // Interface to the master side of the base endpoint
    .sbe_tgt_mmsg_pcsel                      (sb_mmsg_pcsel                                        ), // sbe_sbi_mmsg_pcsel[0]   
    .sbe_tgt_mmsg_pctrdy                     (sbe_sbi_mmsg_pctrdy                                  ), 
    .sbe_tgt_mmsg_pcmsgip                    (sbe_sbi_mmsg_pcmsgip                                 ), 
    .tgt_sbe_mmsg_pcirdy                     (mmsg_pcirdy_tgt                                      ), 
    .tgt_sbe_mmsg_pceom                      (mmsg_pceom_tgt                                       ), 
    .tgt_sbe_mmsg_pcpayload                  (mmsg_pcpayload_tgt                                   ), 

    // Ingress Message Interface - message provided to the IP
    .tgt_ip_msg                              (tgt_ip_msg                                           ), // 
    .ip_tgt_msg_trdy                         (ip_tgt_msg_trdy                                      ), // Handshake back for tgt_ip_msg

    // Ingress Completion Interface - completion provided to the IP
    .tgt_ip_cmsg                             (tgt_ip_cmsg                                          ),
    
    // Egress Completion Interface  - completion provided by the IP
    .ip_tgt_cmsg                             (ip_tgt_cmsg                                          ), // 
    .tgt_ip_cmsg_free                        (tgt_ip_cmsg_free                                     ), // Available free space for ip_tgt_cmsg 

    // Reset Prep Handling Interface
    .sif_gpsb_quiesce_req                    (sif_gpsb_quiesce_req                                 ), // Tell Sideband to UR NPs and Drop Ps on its target
    .sif_gpsb_quiesce_ack                    (sif_gpsb_quiesce_ack                                 ), // Tell RI_IOSF_SB that the TGT is URing/Dropping NP/P

    // Debug bus
    .tgt_dbgbus                              (t_dbgbus_nc                                          )
    );
  
endmodule  : hqm_msg_wrapper 
