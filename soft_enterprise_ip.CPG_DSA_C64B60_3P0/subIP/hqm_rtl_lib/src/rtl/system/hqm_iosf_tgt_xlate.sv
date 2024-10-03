// NOTE: Log history is at end of file
//----------------------------------------------------------------------
// Date Created : 07/14/2011
// Author       : 
// Project      : hqm 
//-----------------------------------------------------------------------------
// Description: Original code devloped by P.Fleming for Blazecreek. IOSF
//              target command translates into link layer format that will be
//              consumed by EP's ri_tlq.  Once the transaction is consumed,
//              RI returns credit updates that is interpret back into IOSF
//              format.
//-----------------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_iosf_tgt_xlate

  import hqm_sif_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;
(
    //--------------------------------------------------------------------------
    // Transaction Decode Logic To RI                                         
    //
    //   lli_phdr_val       : Posted transaction received and translated.
    //   lli_phdr           : Contains translated IOSF command and qualifiers
    //                     
    //   lli_nphdr_val      : Non-posted transaction received and translated.
    //   lli_nphdr          : Contains translated IOSF command and qualifiers.
    //                     
    //   lli_cplhdr_val     : Completion received for an Inbound NP request. 
    //   lli_cplhdr         : Contains translated IOSF command and qualifiers
    //                     
    //   lli_pdata_push     : Posted data available
    //   lli_npdata_push    : Non-posted data available
    //   lli_cpldata_push   : Completion data available 
    //   lli_pkt_data       : Data associated with the IOSF transaction 
    //   iosf_tgt_crd_dec   : Credit consumed by the target interface
    //                     
    //   iosf_tgtq_cmddata  : IOSF Target Command packet
    //
    //--------------------------------------------------------------------------

    // clocks and reset

    input  logic                    prim_nonflr_clk                         , // IOSF clock
    input  logic                    prim_gated_rst_b                        , // Active low reset

    input  logic                    strap_hqm_completertenbittagen          ,

    // Parity Check Enable

    input  logic                    ep_iosfp_parchk_en_rl                   ,

    // Incoming cmd and data from the iosf target, also outgoing credits

    input  hqm_iosf_tgtq_cmddata_t  iosf_tgtq_cmddata                       , 
                                                                              // Fields of this structure are not consumed. Its an inherent 
                                                                              // disavantage of structures, still a new is not made just for
                                                                              // thise case. Its not functional problem.
                                                                              // Some fields were intentionally sidebanded as a timing fix.
    output hqm_iosf_tgt_crd_t       iosf_tgt_crd_dec                        , 
    input  logic                    fuse_proc_disable                       ,

    // LLI interface to the RI

    output logic                    lli_phdr_val                            , 
    output tdl_phdr_t               lli_phdr                                , 

    output logic                    lli_nphdr_val                           , 
    output tdl_nphdr_t              lli_nphdr                               , 

    output logic                    lli_cplhdr_val                          , 
    output tdl_cplhdr_t             lli_cplhdr                              , 
    output logic                    lli_pdata_push                          , 
    output logic                    lli_npdata_push                         , 
    output logic                    lli_cpldata_push                        , 
    output ri_bus_width_t           lli_pkt_data                            , 
    output ri_bus_par_t             lli_pkt_data_par                        , 

    // Error signals
    output logic                    iosf_ep_cpar_err                        , // Cmd Hdr parity error detected
    output logic                    iosf_ep_tecrc_err                       , // HSD 4727748 - add support for TECRC error
    output errhdr_t                 iosf_ep_chdr_w_err
);

  //-------------------------------------------------------------------------
  //        Internal Signals Declaration
  //-------------------------------------------------------------------------
  
  logic [6:0]                       pcie_cmd                                ; 
  logic                             pcie_cmd_wdata                          ;
  hqm_pcie_type_e_t                 pcicmd_e                                ; 

  logic                             cmd_phdr_wr                             ; // For the "to RI cmd" calc logic
  logic                             cmd_phdr_msgd                           ; // Invalidate request (MsgD code=1)
  logic                             cmd_nphdr_mem_rd                        ;
  logic                             cmd_nphdr_cfg_wr                        ;
  logic                             cmd_nphdr_cfg_rd                        ;

  logic                             iosf_ep_cpar_err_i                      ; // header parity error
  logic                             iosf_ep_tecrc_err_i                     ;
  logic                             iosf_ep_stop_and_scream                 ; // HSD 5314129 - added to allow EP to stop and 
                                                                                       //  scream in case of CPAR error
  assign pcie_cmd                   = {iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.fmt,
                                       iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.ttype}             ;

  assign pcie_cmd_wdata             = f_hqm_ttype_has_data(pcie_cmd)                            ;

  assign pcicmd_e                   = hqm_pcie_type_e_t'(pcie_cmd)                              ;

  //--------------------------------------------------------------------------
  // IOSF -> RI Translation
  //--------------------------------------------------------------------------

  always_comb begin : IOSF_TO_RI

      //-----------------------------------------------------------------------
      // Posted-Requests
      //-----------------------------------------------------------------------

      lli_phdr_val                  = iosf_tgtq_cmddata.push_cmd & 
                                      (iosf_tgtq_cmddata.cmd_fc == `HQM_FC_P) &
                                      (!(iosf_ep_cpar_err | iosf_ep_stop_and_scream) )          ; // HSD 5314129 - stop and scream in case of CPAR error

      if (f_hqm_ttype_4dw_hdr(pcie_cmd)) begin // 4DW

          lli_phdr.addr             = {{(64-(TMAX_ADDR+1)){1'b0}}
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.addr[TMAX_ADDR:2]
                                      ,2'd0}                                                    ; 
          lli_phdr.tag              = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.tag                 ; 
          lli_phdr.reqid            = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.rqid                ; 
          lli_phdr.endbe            = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.lbe                 ; 
          lli_phdr.startbe          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.fbe                 ; 
          lli_phdr.length           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.len[$bits(lli_phdr.length)-1:0]; 
          lli_phdr.poison           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.ep                  ; 
          lli_phdr.sai              = iosf_tgtq_cmddata.sai                                     ;

      end else begin // 3DW

          lli_phdr.addr             = {32'd0
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.addr[31:2]
                                      ,2'd0}                                                    ;
          lli_phdr.tag              = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.tag                 ; 
          lli_phdr.reqid            = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.rqid                ; 
          lli_phdr.endbe            = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.lbe                 ; 
          lli_phdr.startbe          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.fbe                 ; 
          lli_phdr.length           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.len[$bits(lli_phdr.length)-1:0]; 
          lli_phdr.poison           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.ep                  ; 
          lli_phdr.sai              = iosf_tgtq_cmddata.sai                                     ;

      end

      // bllem 12/15/2011 lli_phdr.poison = '0                                                  ; 
      // updated cmd decoding for following HSDs - need to ensure only the transactions we 
      // support are encoded, rest go to UR.
      // HSD 5020298 - not receiving UR for IO transactions
      // HSD 4727715 - not receiving UR for CFGRD/WR1 transactions
      // HSD 4727717 - not receiving UR for atomic transactions
      // HSD 4728244 - unsupported requests not returning data
      // jbdiethe: I could have sai be just ignored, however I
      // I decided I want them treated like posted URs, dropped, but
      // errors logged if applicable. I actually have tried both.

      // The only MsgD we support is an invalidate request (ID routed, msgcode=1, len=64b).

      cmd_phdr_msgd                 = (pcicmd_e == HQM_MSGD2) &
                                      (iosf_tgtq_cmddata.cmd_pcie_hdr.pciemsg.len == 10'h002) &
                                      (iosf_tgtq_cmddata.cmd_pcie_hdr.pciemsg.msgcode == 8'h01) ;

      cmd_phdr_wr                   = ((pcicmd_e == HQM_MWR3) | (pcicmd_e == HQM_MWR4))         ; // posted write

      lli_phdr.cmd                  = (cmd_phdr_msgd) ? 
                                       ((fuse_proc_disable) ?
                                        `HQM_TDL_PHDR_USR_D  : `HQM_TDL_PHDR_MSG_D) : 
                                      ((cmd_phdr_wr) ? 
                                       ((fuse_proc_disable) ?
                                        `HQM_TDL_PHDR_USR_D  : `HQM_TDL_PHDR_WR) : 
                                       ((pcie_cmd_wdata) ? 
                                        `HQM_TDL_PHDR_USR_D  : `HQM_TDL_PHDR_USR_ND))           ;  

      lli_phdr.pasidtlp             = iosf_tgtq_cmddata.pasidtlp                                ; 
      lli_phdr.fmt                  = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.fmt                 ; 
      lli_phdr.ttype                = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.ttype               ; 

      lli_phdr.cmdlen_par           = ^{lli_phdr.cmd
                                       ,lli_phdr.fmt
                                       ,lli_phdr.ttype
                                       ,lli_phdr.length};

      lli_phdr.addr_par             = {(^lli_phdr.addr[TMAX_ADDR:32])
                                      ,(^lli_phdr.addr[31:0])};

      lli_phdr.par                  = {(^{lli_phdr.pasidtlp
                                         ,lli_phdr.sai
                                         ,lli_phdr.poison})
                                      ,(^{lli_phdr.tag
                                         ,lli_phdr.reqid
                                         ,lli_phdr.endbe
                                         ,lli_phdr.startbe})};
    
      lli_pdata_push                = (iosf_tgtq_cmddata.data_fc == `HQM_FC_P) &                  // (~cpar_tecrc_err_f) &
                                       iosf_tgtq_cmddata.push_data                              ; // HSD5313791 Passing the erred data to the RI

      //-----------------------------------------------------------------------
      // Non-posted requests
      //-----------------------------------------------------------------------

      lli_nphdr_val                 = iosf_tgtq_cmddata.push_cmd &
                                      (iosf_tgtq_cmddata.cmd_fc == `HQM_FC_NP) &
                                      (!(iosf_ep_cpar_err | iosf_ep_stop_and_scream) )          ; // HSD 5314129 - stop and scream in case of CPAR error

      // CfgWr0/Rd0 - IOSF block converts the cfg request info so pcie64 cannot be used for cfg types.  

      lli_nphdr                     = '0                                                        ;

      if ((pcicmd_e == HQM_CFGWR0) || (pcicmd_e == HQM_CFGRD0)) begin

          // CFG Requests

          lli_nphdr.addr            = {32'd0
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.bus
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.dev
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.funcn
                                      ,4'd0
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.extregnum
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.regnum}           ;
          lli_nphdr.attr            = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.attr               ;
          lli_nphdr.tc              = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.tc                 ;
          lli_nphdr.tag             = {(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.rsvd3)              // trsvd1_7 (tag[9])
                                      ,(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.rsvd2)              // trsvd1_3 (tag[8])
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.tag}              ; 
          lli_nphdr.reqid           = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.rqid               ; 
          lli_nphdr.endbe           = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.lbe                ; 
          lli_nphdr.startbe         = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.fbe                ; 
          lli_nphdr.length          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.len[$bits(lli_nphdr.length)-1:0];
          lli_nphdr.poison          = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecfg.ep                 ;
          lli_nphdr.sai             = iosf_tgtq_cmddata.sai                                     ;

      end else if (f_hqm_ttype_4dw_hdr(pcie_cmd)) begin // 4DW

          lli_nphdr.addr            = {{(64-(TMAX_ADDR+1)){1'b0}}
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.addr[TMAX_ADDR:2]} ;
          lli_nphdr.attr            = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.attr                ;
          lli_nphdr.tc              = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.tc                  ;
          lli_nphdr.tag             = {(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.rsvd3)               // trsvd1_7 (tag[9])
                                      ,(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.rsvd2)               // trsvd1_3 (tag[8])
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.tag}               ; 
          lli_nphdr.reqid           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.rqid                ; 
          lli_nphdr.endbe           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.lbe                 ; 
          lli_nphdr.startbe         = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.fbe                 ; 
          lli_nphdr.length          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.len[$bits(lli_nphdr.length)-1:0]; 
          lli_nphdr.poison          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.ep                  ;
          lli_nphdr.sai             = iosf_tgtq_cmddata.sai                                     ;

      end else begin // 3DW

          lli_nphdr.addr            = {32'd0
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.addr[31:2]}        ;
          lli_nphdr.attr            = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.attr                ;
          lli_nphdr.tc              = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.tc                  ;
          lli_nphdr.tag             = {(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.rsvd3)               // trsvd1_7 (tag[9])
                                      ,(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.rsvd2)               // trsvd1_3 (tag[8])
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.tag}               ; 
          lli_nphdr.reqid           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.rqid                ; 
          lli_nphdr.endbe           = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.lbe                 ; 
          lli_nphdr.startbe         = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.fbe                 ; 
          lli_nphdr.length          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.len[$bits(lli_nphdr.length)-1:0]; 
          lli_nphdr.poison          = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie32.ep                  ;
          lli_nphdr.sai             = iosf_tgtq_cmddata.sai                                     ;

      end

      // updated cmd decoding for following HSDs - need to ensure only the transactions we 
      // support are encoded, rest go to UR
      // HSD 5020298 - not receiving UR for IO transactions
      // HSD 4727715 - not receiving UR for CFGRD/WR1 transactions
      // HSD 4727717 - not receiving UR for atomic transactions
      //bllem 1/6/12 lli_nphdr.poison     = '0                                                  ; 

      cmd_nphdr_mem_rd              = ((pcicmd_e == HQM_MRD3) | (pcicmd_e == HQM_MRD4));       // non-posted req, mem rd
      cmd_nphdr_cfg_wr              =  (pcicmd_e == HQM_CFGWR0);                               // non-posted req, cfg wr
      cmd_nphdr_cfg_rd              =  (pcicmd_e == HQM_CFGRD0);                               // non-posted req, cfg rd

      lli_nphdr.cmd                 = (cmd_nphdr_mem_rd) ? 
                                       ((fuse_proc_disable) ?
                                        `HQM_TDL_NPHDR_USR_ND : `HQM_TDL_NPHDR_MEM_RD) : 
                                      ((cmd_nphdr_cfg_wr) ? 
                                       ((fuse_proc_disable) ?
                                        `HQM_TDL_NPHDR_USR_D  : `HQM_TDL_NPHDR_CFG_WR) :
                                      ((cmd_nphdr_cfg_rd) ? 
                                       ((fuse_proc_disable) ?
                                        `HQM_TDL_NPHDR_USR_ND : `HQM_TDL_NPHDR_CFG_RD) :
                                      ((pcie_cmd_wdata) ? 
                                        `HQM_TDL_NPHDR_USR_D  : `HQM_TDL_NPHDR_USR_ND)))        ;

      lli_nphdr.pasidtlp            = iosf_tgtq_cmddata.pasidtlp                                ; 
      lli_nphdr.fmt                 = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.fmt                 ; 
      lli_nphdr.ttype               = iosf_tgtq_cmddata.cmd_pcie_hdr.pcie64.ttype               ; 

      lli_nphdr.cmdlen_par          = ^{lli_nphdr.cmd
                                       ,lli_nphdr.fmt
                                       ,lli_nphdr.ttype
                                       ,lli_nphdr.length};

      lli_nphdr.addr_par            = {(^lli_nphdr.addr[TMAX_ADDR:32])
                                      ,(^lli_nphdr.addr[31:2])};

      lli_nphdr.par                 = {(^{lli_nphdr.pasidtlp
                                         ,lli_nphdr.sai
                                         ,lli_nphdr.attr
                                         ,lli_nphdr.tc})
                                      ,(^{lli_nphdr.poison
                                         ,lli_nphdr.tag
                                         ,lli_nphdr.reqid
                                         ,lli_nphdr.endbe
                                         ,lli_nphdr.startbe})};

      lli_npdata_push               = (iosf_tgtq_cmddata.data_fc == `HQM_FC_NP) &                 // (~cpar_tecrc_err_f) &
                                       iosf_tgtq_cmddata.push_data                              ; // HSD5313791 Passing the data to the RI

      //-----------------------------------------------------------------------
      // Completion
      //-----------------------------------------------------------------------
      lli_cplhdr_val                = iosf_tgtq_cmddata.push_cmd &
                                      (iosf_tgtq_cmddata.cmd_fc == `HQM_FC_C) &
                                      (!(iosf_ep_cpar_err | iosf_ep_stop_and_scream) )          ; // HSD 5314129 - stop and scream in case of CPAR error

      lli_cplhdr                    = '0                                                        ;
      lli_cplhdr.tc                 = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.tc                 ;
      lli_cplhdr.ido                = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.attr2              ;
      lli_cplhdr.ro                 = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.attr[1]            ;
      lli_cplhdr.ns                 = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.attr[0]            ;
      lli_cplhdr.poison             = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.ep                 ;
      lli_cplhdr.rid                = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.rqid               ; // Actually the requestor ID
      lli_cplhdr.cid                = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.cplid              ; // The real completer ID
      lli_cplhdr.addr               = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.lowaddr[1:0]       ; 
      lli_cplhdr.bc                 = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.bytecnt            ; 
      lli_cplhdr.status             = ((pcicmd_e == HQM_CPLLK) || (pcicmd_e == HQM_CPLDLK)) ?              // Force unsupported CplLk/CplDLk to 7
                                       3'd7 :
                                      (((iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.cplstat == 3'd3) ||
                                        (iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.cplstat >= 3'd5)) ? 3'd1 : // Force unsupported encodings to UR
                                      iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.cplstat)           ;          // Otherwise pass actual status
      lli_cplhdr.length             = iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.len                ; 
      lli_cplhdr.wdata              = pcie_cmd[6]                                               ; 
      lli_cplhdr.tag                = {(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.rsvd3)              // trsvd1_7 (tag[9])
                                      ,(strap_hqm_completertenbittagen &
                                        iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.rsvd2)              // trsvd1_3 (tag[8])
                                      ,iosf_tgtq_cmddata.cmd_pcie_hdr.pciecpl.tag}              ; 

      lli_cpldata_push              = (iosf_tgtq_cmddata.data_fc == `HQM_FC_C) &                  // (~cpar_tecrc_err_f) &
                                       iosf_tgtq_cmddata.push_data                              ; // HSD5313791 Passing the data to the RI


      lli_pkt_data                  = (iosf_tgtq_cmddata.push_data) ? 
                                       iosf_tgtq_cmddata.data : '0                              ; 
      lli_pkt_data_par              =  iosf_tgtq_cmddata.data_par                               ;

  end : IOSF_TO_RI

  //--------------------------------------------------------------------------
  // Description: Converts ri credit update to CCT's iosf credit update 
  //              equivalent
  //--------------------------------------------------------------------------

  logic [9:0] dwlength;

  always_comb begin : CRD_DECREMENT

      dwlength                      = (lli_phdr_val)  ? lli_phdr.length  :
                                      (lli_nphdr_val) ? lli_nphdr.length : 10'd0                ;

      iosf_tgt_crd_dec.dcreditup    = pcie_cmd_wdata & (lli_phdr_val | lli_nphdr_val)           ;
      iosf_tgt_crd_dec.dcredit_port = '0                                                        ;
      iosf_tgt_crd_dec.dcredit_vc   = '0                                                        ;
      iosf_tgt_crd_dec.dcredit_fc   = {1'b0, (pcie_cmd_wdata & lli_nphdr_val)}                  ; // 0:P, 1:NP
      iosf_tgt_crd_dec.dcredit      = (pcie_cmd_wdata & (lli_phdr_val | lli_nphdr_val)) ?
                                        (dwlength[9:2] + {7'd0, (|dwlength[1:0])}) : 8'd0       ; // Number of 4 DW credits when valid

      iosf_tgt_crd_dec.ccreditup    = lli_phdr_val | lli_nphdr_val                              ;
      iosf_tgt_crd_dec.ccredit_port = '0                                                        ;
      iosf_tgt_crd_dec.ccredit_vc   = '0                                                        ;
      iosf_tgt_crd_dec.ccredit_fc   = {1'b0, lli_nphdr_val}                                     ; // 0:P, 1:NP
      iosf_tgt_crd_dec.ccredit      = lli_phdr_val | lli_nphdr_val                              ; // Always 1 when valid

      // Infinite completion credits 

  end : CRD_DECREMENT

  //--------------------------------------------------------------------------
  // Description: IOSF RX Primary Channel Parity Error Capture
  //--------------------------------------------------------------------------
    
    // Capture Cmd Header Parity Error
    assign iosf_ep_cpar_err_i                = iosf_tgtq_cmddata.cpar_err & ep_iosfp_parchk_en_rl        ;
    assign iosf_ep_cpar_err                  = iosf_tgtq_cmddata.push_cmd & iosf_ep_cpar_err_i &
                                                    ~iosf_ep_stop_and_scream;
    
    // HSD 4727748 - add support for TECRC error
    assign iosf_ep_tecrc_err_i               = iosf_tgtq_cmddata.tecrc_error                             ;
    assign iosf_ep_tecrc_err                 = iosf_tgtq_cmddata.push_cmd & iosf_ep_tecrc_err_i &
                                                    ~iosf_ep_stop_and_scream;

    assign iosf_ep_chdr_w_err.header         = {iosf_tgtq_cmddata.cmd_pcie_hdr[ 31:  0]
                                               ,iosf_tgtq_cmddata.cmd_pcie_hdr[ 63: 32]
                                               ,iosf_tgtq_cmddata.cmd_pcie_hdr[ 95: 64]
                                               ,iosf_tgtq_cmddata.cmd_pcie_hdr[127: 96]};
    assign iosf_ep_chdr_w_err.pasidtlp       = iosf_tgtq_cmddata.pasidtlp                                ;
    
  // HSD 5314129 - stop and scream in case of CPAR error
  always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b) begin : STOP_AND_SCREAM_BIT 
      if (~prim_gated_rst_b) 
          iosf_ep_stop_and_scream           <= '0                                                        ;
      else if (iosf_ep_cpar_err)
          // Store bit and do not reset
          iosf_ep_stop_and_scream           <= 1'b1                                                      ;
      else
          // Keep stop and scream bit and don't allow it to reset
          iosf_ep_stop_and_scream           <= iosf_ep_stop_and_scream                                   ;
      
          
  end :  STOP_AND_SCREAM_BIT

endmodule : hqm_iosf_tgt_xlate

