// cct.20150909 from PCIE3201509090088BEKB0.tar drop
//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------
//
//  $Id: cxt_iosf_tgt_cntrl.sv,v 1.188 2014/07/31 20:44:32 albion Exp $
//
//  PROJECT : CCT-PCIE3
//  DATE    : $Date: 2014/07/31 20:44:32 $
//
//  Functional description:
//      PCIE IOSF Primary Channel Target Control Block
//----------------------------------------------------------------------------

module hqm_iosf_tgt_cntrl 

    import hqm_sif_csr_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;
#( 
    parameter int D_WIDTH           = 255, // Primary Channel Databus Width
    parameter int PORTS             = 1,
    parameter int VC                = 1,
    parameter int MAX_LEN           = 63,
    parameter int PBG_TIMING        = 0,
    parameter bit TGT_CMDPARCHK_DIS = 0,
    parameter bit TGT_DATPARCHK_DIS = 0,
    parameter int GEN_ECRC          = 0,
    parameter int DROP_ECRC         = 1
) (
    //============================================================
    // IOSF Target Clocks and Resets
    //============================================================

    input  logic                                prim_nonflr_clk,
    input  logic                                prim_gated_rst_b,
    input  logic [2:0]                          prim_ism_agent,

    //================================================================
    // IOSF Target Primary Interface to Fabric 
    //================================================================

    input hqm_iosf_tgt_cput_t                   iosf_tgt_cput,
    input hqm_iosf_tgt_cmd_t                    iosf_tgt_cmd,
    input hqm_iosf_tgt_data_t                   iosf_tgt_data,

    //================================================================
    // IOSF Target Interface to Txn Layer Queues
    //================================================================

    output hqm_iosf_tgtq_cmddata_t              iosf_tgtq_cmddata,

    // MC and MBAR interface with parity
    //----------------------------------

    output hqm_iosf_tgtq_hdrbits_t              iosf_tgtq_hdrbits,

    input logic                                 credit_init_in_progress,

    //=====================================================================
    // Target Idle Conditions 
    //=====================================================================

    output logic                                tgt_idle,

    //====================================================================
    // Master grant signals
    //===================================================================

    input hqm_iosf_gnt_t                        mstr_iosf_gnt,

    //====================================================================
    // NOA
    //===================================================================

    output logic [23:0]                         noa_tgtcntrl
);

logic                           data_en;
logic [MAX_LEN:0]               data_count_ff, data_count_nxt;
logic [8:0]                     data_ptr_offset_ff, data_ptr_offset_nxt;
logic [1:0]                     data_fc_d;
logic [`HQM_L2(VC)-1:0]         data_vc_d;
logic                           has_data_d, has_data;
logic                           tgt_cpar_err_iosf;
logic [`HQM_L2P1(PORTS)-1:0]    data_port_d;         
logic                           tgt_dpar_err;   

// Error Check signals

logic [3:0]                     dec_type;
logic [2:0]                     dec_bits;
logic [15:0]                    bdfnum_nc;
logic                           up_dn_cfg;
logic [1:0]                     cpl_fc;
logic                           cpl_flag, cpl_flag_d, cpl_flag_nxt;

//=============================================================
// Variables for Timing fix for PBG
//=============================================================

hqm_iosf_tgtq_cmddata_t         iosf_tgtq_cmddata_d, iosf_tgtq_cmddata_ff;
hqm_iosf_tgtq_cmddata_t         iosf_tgtq_cmddata_d_sai;
hqm_iosf_tgtq_hdrbits_t         iosf_tgtq_hdrbits_d, iosf_tgtq_hdrbits_ff;
    
// 2DW/1DW data width support

logic                           cdata_capture, cdata_capture_ff, cdata_capture_3ff;

logic [((D_WIDTH==31)? 1: 0):0] cdata_capture_cnt_ff, cdata_capture_cnt;
logic [((D_WIDTH==31)? 2: 0):0] cdata_parity_ff, cdata_parity_d;
logic [((D_WIDTH==31)?95:63):0] iosf_data_d, iosf_data_ff;

hqm_pcie_type_e_t               ttype_nc;
hqm_pcie_msg_code_e_t           mcode_nc;

//================================================================

//-----------
//Flops
//-----------

// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,data_count_ff,data_count_nxt);
// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,data_ptr_offset_ff,data_ptr_offset_nxt);
// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,iosf_tgtq_cmddata_d.data_fc,data_fc_d);
// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,iosf_tgtq_cmddata_d.data_port,data_port_d);
// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,iosf_tgtq_cmddata_d.data_vc,data_vc_d);
// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,has_data,has_data_d);
// Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,'0,cpl_flag,cpl_flag_nxt);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  data_count_ff                 <= '0;
  data_ptr_offset_ff            <= '0;
  iosf_tgtq_cmddata_d.data_fc   <= '0;
  iosf_tgtq_cmddata_d.data_port <= '0;
  iosf_tgtq_cmddata_d.data_vc   <= '0;
  has_data                      <= '0;
  cpl_flag                      <= '0;
 end else begin
  data_count_ff                 <= data_count_nxt;
  data_ptr_offset_ff            <= data_ptr_offset_nxt;
  iosf_tgtq_cmddata_d.data_fc   <= data_fc_d;
  iosf_tgtq_cmddata_d.data_port <= data_port_d;
  iosf_tgtq_cmddata_d.data_vc   <= data_vc_d;
  has_data                      <= has_data_d;
  cpl_flag                      <= cpl_flag_nxt;
 end
end

//================================================================================
// TIMING FLOP STAGE for PBG
//================================================================================

generate
    if ( PBG_TIMING == 1 ) begin: pbg_timing

        // Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,iosf_tgtq_cmddata_ff,iosf_tgtq_cmddata_d);
        // Replaced: `HQM_ARFF(prim_nonflr_clk,prim_gated_rst_b,0,iosf_tgtq_hdrbits_ff,iosf_tgtq_hdrbits_d);

        always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
         if (~prim_gated_rst_b) begin
          iosf_tgtq_cmddata_ff <= '0;
          iosf_tgtq_hdrbits_ff <= '0;
         end else if ((prim_ism_agent == `HQM_ACTIVE) || (prim_ism_agent == `HQM_IDLE_REQ)) begin
          iosf_tgtq_cmddata_ff <= iosf_tgtq_cmddata_d; 
          iosf_tgtq_hdrbits_ff <= iosf_tgtq_hdrbits_d; 
         end
        end

    end else begin : no_flop_stage

        always_comb iosf_tgtq_cmddata_ff = '0;
        always_comb iosf_tgtq_hdrbits_ff = '0;

    end
endgenerate

//================================================================================
// TIMING  MUX STAGE for PBG
//================================================================================

always_comb begin
   if (PBG_TIMING == 1) begin
      iosf_tgtq_cmddata = iosf_tgtq_cmddata_ff;
      iosf_tgtq_hdrbits = iosf_tgtq_hdrbits_ff;
    end else begin
      iosf_tgtq_cmddata = iosf_tgtq_cmddata_d;
      iosf_tgtq_hdrbits = iosf_tgtq_hdrbits_d;
    end
end//always_comb  

//-------------
//Combinatorial
//-------------

hqm_iosf_tgt_cmd_t iosf_tgt_cmd_sai_nc;

always_comb begin

    //-----------------------------
    // Clock Gating Idle Conditions
    //-----------------------------

    tgt_idle = ~credit_init_in_progress & ~iosf_tgt_cput.cmd_put & ~has_data_d &
               ~iosf_tgtq_cmddata.push_cmd & ~iosf_tgtq_cmddata.push_data;

    //------------------------------------------
    //Check command parity error from IOSF first
    //------------------------------------------

    iosf_tgt_cmd_sai_nc = iosf_tgt_cmd;
    tgt_cpar_err_iosf   = f_hqm_cmd_parerr_iosf(iosf_tgt_cmd);

    //===============================================================
    // Error check type decode
    //===============================================================

    dec_type = f_hqm_tgtdec_typedec   ({iosf_tgt_cmd.tfmt, iosf_tgt_cmd.ttype});
    dec_bits = f_hqm_tgtdec_decbits   ({iosf_tgt_cmd.tfmt, iosf_tgt_cmd.ttype});

    ttype_nc = hqm_pcie_type_e_t'     ({iosf_tgt_cmd.tfmt, iosf_tgt_cmd.ttype});
    mcode_nc = hqm_pcie_msg_code_e_t' ({iosf_tgt_cmd.tlbe, iosf_tgt_cmd.tfbe});

    // Default case : set cmd and data bits to 0
    //----------------------------------

    tgt_dpar_err                       = '0;
    iosf_tgtq_cmddata_d.push_cmd       = '0;
    iosf_tgtq_cmddata_d.cmd_port       = '0;
    iosf_tgtq_cmddata_d.cmd_vc         = '0;
    iosf_tgtq_cmddata_d.cmd_fc         = '0;
    iosf_tgtq_cmddata_d.cmd_ptr_offset = '0;
    iosf_tgtq_cmddata_d.cmd_pcie_hdr   = '0;
    iosf_tgtq_cmddata_d.ecrc           = '0;
    iosf_tgtq_cmddata_d.hdr_par        = '0;
    iosf_tgtq_cmddata_d.push_data      = '0;
    data_en                            = '0;
    iosf_tgtq_cmddata_d.alldw_data     = '0;
    iosf_tgtq_cmddata_d.data_par       = '0;
    iosf_tgtq_cmddata_d.cpar_err       = '0;
    iosf_tgtq_cmddata_d.dpar_err       = '0;
    iosf_tgtq_cmddata_d.tecrc_error    = '0;
    iosf_tgtq_cmddata_d.data           = '0;
    iosf_tgtq_cmddata_d.data_ptr_offset= '0;
    iosf_tgtq_cmddata_d.sai            = '0;
    iosf_tgtq_cmddata_d.pasidtlp       = '0;
    data_vc_d                          = '0;
    data_port_d                        = '0;
    data_fc_d                          = iosf_tgtq_cmddata_d.data_fc;
    iosf_tgtq_hdrbits_d                = '0;
    bdfnum_nc                          = '0;
    up_dn_cfg                          = '0;
    cpl_fc                             = 2'b11;
    cpl_flag_d                         = '0;
    cpl_flag_nxt                       = cpl_flag && ~(mstr_iosf_gnt.gnt &&
                                         (mstr_iosf_gnt.gtype == 2'b00) && (mstr_iosf_gnt.rtype == 2'b10));
    data_count_nxt                     = '0;
    data_ptr_offset_nxt                = '0;
    iosf_tgtq_cmddata_d_sai            = '0;

    //==========================================================================================================
    // CASE 1
    //----------------------------------------------------------------------------------------------------------
    // Valid put from IOSF fabric
    //==========================================================================================================

    if (iosf_tgt_cput.cmd_put & ((prim_ism_agent == `HQM_ACTIVE) || (prim_ism_agent == `HQM_IDLE_REQ))) begin

        // SAI passthrough

        iosf_tgtq_cmddata_d.sai        = iosf_tgt_cmd.tsai;
        iosf_tgtq_cmddata_d.pasidtlp   = iosf_tgt_cmd.tpasidtlp;

        //============================================================================
        // MALFORM CHECKS
        //============================================================================
        
        // MPS Malform check
        //------------------
        data_count_nxt     = ((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1)? iosf_tgt_cmd.tlength : data_count_ff;
        data_ptr_offset_nxt= ((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1)? '0 : data_ptr_offset_ff ; 


        iosf_tgtq_cmddata_d.push_cmd    = iosf_tgt_cput.cmd_put; 

        //=============================================================================================================
        //ECN #9 cmd_rtype change
        //-----------------------
        iosf_tgtq_cmddata_d.cmd_fc          = iosf_tgt_cput.cmd_rtype;
        iosf_tgtq_cmddata_d.ecrc            = (DROP_ECRC & ~GEN_ECRC) ? '0 : iosf_tgt_cmd.tecrc;
        iosf_tgtq_cmddata_d.cmd_ptr_offset  = '0;

//=============================================
// ASSERTIONS for IOSF Fabric CMD
//=============================================
//CMD PUT to Invalid Channel (vc, port)
//--------------------------
//CMD PUT Invalid rtype
//-----------------------

        //======================================================================
        // ERROR CHECKS
        //=====================================================================
        cpl_fc             =   f_hqm_flowclass      (iosf_tgt_cmd.tfmt, 
                                                     iosf_tgt_cmd.ttype);
        cpl_flag_d         =   f_hqm_vrp_cplflag    (cpl_fc);

        cpl_flag_nxt       = cpl_flag_d | 
                            (cpl_flag &&  
                            ~(mstr_iosf_gnt.gnt &&
                            (mstr_iosf_gnt.gtype == 2'b00) && (mstr_iosf_gnt.rtype == 2'b10)));

        bdfnum_nc          =   f_hqm_tgtdec_bdfnum (dec_type, 
                                                iosf_tgt_cmd.taddress[31:0], 
                                                iosf_tgt_cmd.trqid);  

        // Format Header from Fabric Cmd bus
        //============================================================================================================

        case ({iosf_tgt_cmd.tfmt,iosf_tgt_cmd.ttype})

            `HQM_CPL,`HQM_CPLD,`HQM_CPLLK,`HQM_CPLDLK : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pciecpl   = f_hqm_iosf_pcie_cplhdr (iosf_tgt_cmd);    
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pciecpl.td = '0; 
            end        
                      
            `HQM_CFGRD0, `HQM_CFGWR0, `HQM_CFGRD1, `HQM_CFGWR1 : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pciecfg   = f_hqm_iosf_pcie_cfghdr (iosf_tgt_cmd);    
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pciecfg.td = '0; 
            end

            `HQM_MRD32, `HQM_LTMRD32, `HQM_MRDLK32, `HQM_MWR32, `HQM_LTMWR32, `HQM_NPMWR32 : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie32    = f_hqm_iosf_pcie_mem32hdr(iosf_tgt_cmd);
        
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie32.td = '0; 
            end 

            `HQM_FETCHADD32, `HQM_SWAP32, `HQM_CAS32 : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcieatm32 = f_hqm_iosf_pcie_atm32hdr (iosf_tgt_cmd);
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcieatm32.td = '0; 
            end
    
            `HQM_MRD64, `HQM_LTMRD64, `HQM_MRDLK64, `HQM_MWR64, `HQM_LTMWR64, `HQM_NPMWR64 : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie64    = f_hqm_iosf_pcie_mem64hdr (iosf_tgt_cmd);

                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie64.td = '0; 
            end
    
            `HQM_FETCHADD64, `HQM_SWAP64, `HQM_CAS64 : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcieatm64 = f_hqm_iosf_pcie_atm64hdr (iosf_tgt_cmd);

                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcieatm64.td = '0; 
            end
    
            `HQM_IORD, `HQM_IOWR : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcieio    = f_hqm_iosf_pcie_iohdr (iosf_tgt_cmd);
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcieio.td = '0; 
            end
    
            `HQM_MSG_RC,    `HQM_MSG_AD,  `HQM_MSG_ID,  `HQM_MSG_BC, `HQM_MSG_TERM,  `HQM_MSG_5,   `HQM_MSG_6,   `HQM_MSG_7, 
                `HQM_MSGD_RC,   `HQM_MSGD_AD, `HQM_MSGD_ID, `HQM_MSGD_BC, `HQM_MSGD_TERM, `HQM_MSGD_5,  `HQM_MSGD_6,  `HQM_MSGD_7 : begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pciemsg   = f_hqm_iosf_pcie_msghdr (iosf_tgt_cmd);
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pciemsg.td = '0; 
            end

            default: begin
              if (iosf_tgt_cmd.tfmt[0]) begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie64    = f_hqm_iosf_pcie_mem64hdr (iosf_tgt_cmd);
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie64.td = '0; 
              end else begin
                iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie32    = f_hqm_iosf_pcie_mem32hdr (iosf_tgt_cmd);
                if (DROP_ECRC & ~GEN_ECRC) iosf_tgtq_cmddata_d.cmd_pcie_hdr.pcie32.td = '0; 
              end
            end

        endcase    

        // Collate hdrbits_d signals
        //---------------------------

        // PCR 272014 - SAI support HACK

        iosf_tgtq_cmddata_d_sai = iosf_tgtq_cmddata_d;

        // Calculate parity:

        iosf_tgtq_cmddata_d.hdr_par      = f_hqm_cmd_parity(iosf_tgtq_cmddata_d_sai.cmd_pcie_hdr.pcie32, 
                                                               tgt_cpar_err_iosf,
                                                               TGT_CMDPARCHK_DIS);

        iosf_tgtq_hdrbits_d.hdrpar_err   = (TGT_CMDPARCHK_DIS) ?  1'b0 : tgt_cpar_err_iosf;   

        iosf_tgtq_cmddata_d.cpar_err     = iosf_tgtq_hdrbits_d.hdrpar_err;
        
        iosf_tgtq_cmddata_d.tecrc_error  = iosf_tgt_cmd.tecrc_error;    // HSD 4727748 - add support for TECRC error

        iosf_tgtq_hdrbits_d.par          = 1'b0;
    
        // Generate Data related information from header, so can be output the next cycle when data arrives
        //--------------------------------------------------------------------------------------------------

        if (iosf_tgt_cmd.tfmt[1] && iosf_tgt_cput.cmd_put) begin
            //ECN #9 cmd_rtype change
            data_fc_d                       = iosf_tgt_cput.cmd_rtype;
            iosf_tgtq_hdrbits_d.int_txn     = 1'b0;
            iosf_tgtq_hdrbits_d.par         = ^({iosf_tgtq_hdrbits_d.int_txn,
                                                 iosf_tgtq_hdrbits_d.drop, 
                                                 iosf_tgtq_hdrbits_d.ur,
                                                 iosf_tgtq_hdrbits_d.ca,  
                                                 iosf_tgtq_hdrbits_d.uc,
                                                 iosf_tgtq_hdrbits_d.atomic_eb,
                                                 iosf_tgtq_hdrbits_d.cfg, 
                                                 iosf_tgtq_hdrbits_d.invpage,
                                                 iosf_tgtq_hdrbits_d.cfg1to0,
                                                 iosf_tgtq_hdrbits_d.acsvioln,
                                                 iosf_tgtq_hdrbits_d.hdrpar_err});  
        end
    end // end cmd_put CASE 1

//==============================================
//ASSERTIONS for IOSF Fabric Data
//==============================================

// Data on invalid cycle 
//----------------------
//(last data can overlap only with next CMD PUT w/Data or can overlap with CMD PUT with no data)

//================================================================================================================
      
//Invalid port, vc check
// Do not issue Ack when no internal credit available?
//
   //end // End processing of header cmd_put loop

    //Data is set on next clock cycle
    //------------------------------
    //==============================================================================================================
    //CASE 1
    //------------------------------------------------------------------------------------------------------------- 
    //Data from Fabric  or config agent
    //==============================================================================================================

    if ( (has_data && (|data_count_ff)) || (iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])) begin
        data_count_nxt      = ((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1)? iosf_tgt_cmd.tlength : data_count_ff;
        data_ptr_offset_nxt = ((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1)? '0 : data_ptr_offset_ff ; 

        // expand for 1 and 2 DW.

        if (has_data && (|data_count_ff)) begin

            iosf_tgtq_cmddata_d.data_ptr_offset    = data_ptr_offset_ff;

            case (D_WIDTH)

                511 : begin
                    data_count_nxt                         = (data_count_ff <= 10'd16) ? 
                                                                (((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1) ? 
                                                                    iosf_tgt_cmd.tlength : '0): (data_count_ff - 10'd16) ; 

                    // Last flit of data and we got a new command pushed in.  Need to load the offset pointer.

                    if ((data_count_ff <= 10'd16) & (iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1]))
                        data_ptr_offset_nxt = '0;
                    else if (data_count_ff > 10'd12)
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd6;
                    else if (data_count_ff > 10'd8)
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd4;
                    else if (data_count_ff > 10'd4)
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd2;
                    else
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd1;

                    if (data_count_ff <= 10'd4)
                        iosf_tgtq_cmddata_d.alldw_data     = 2'b00;
                    else if (data_count_ff <= 10'd8)
                        iosf_tgtq_cmddata_d.alldw_data     = 2'b01;
                    else if (data_count_ff <= 10'd12)
                        iosf_tgtq_cmddata_d.alldw_data     = 2'b10;
                    else
                        iosf_tgtq_cmddata_d.alldw_data     = 2'b11;

                    data_en                                = 1'b1;
                    iosf_tgtq_cmddata_d.push_data          = 1'b1;
                    iosf_tgtq_cmddata_d.data               = iosf_tgt_data.data;                      
                    iosf_tgtq_cmddata_d.data_par           = f_hqm_data_parity(iosf_tgt_data.data, 
                                                                           iosf_tgt_data.dparity,
                                                                           '0,
                                                                           up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                           tgt_dpar_err);
                   iosf_tgtq_cmddata_d.dpar_err            = tgt_dpar_err;
                end

                255 : begin
                    data_count_nxt                         = (data_count_ff <= 10'd8) ? 
                                                                (((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1) ? 
                                                                    iosf_tgt_cmd.tlength : '0): (data_count_ff - 10'd8) ; 

                    if ((data_count_ff <= 10'd8) & (iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1]))
                        data_ptr_offset_nxt = '0;
                    else if (data_count_ff > 10'd4)
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd2;
                    else
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd1;

                    iosf_tgtq_cmddata_d.alldw_data         = (data_count_ff > 10'd4)? 2'b01: 2'b00;
                    data_en                                = 1'b1;
                    iosf_tgtq_cmddata_d.push_data          = 1'b1;
                    iosf_tgtq_cmddata_d.data               = iosf_tgt_data.data;                      
                    iosf_tgtq_cmddata_d.data_par           = f_hqm_data_parity(iosf_tgt_data.data, 
                                                                           iosf_tgt_data.dparity,
                                                                           '0,
                                                                           up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                           tgt_dpar_err);
                   iosf_tgtq_cmddata_d.dpar_err            = tgt_dpar_err;

                end

                127 : begin
                    data_count_nxt                         = (data_count_ff <= 10'd4) ? 
                                                                (((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1) ?
                                                                    iosf_tgt_cmd.tlength : '0): (data_count_ff - 10'd4) ; 

                    if ((data_count_ff <= 10'd4) & (iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1]))
                        data_ptr_offset_nxt = '0;
                    else
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd1;

                    // 4DW - alldw will always be zero

                    iosf_tgtq_cmddata_d.alldw_data         = 0;
                    data_en                                = 1'b1;
                    iosf_tgtq_cmddata_d.push_data          = 1'b1;

                    // If we have 4DW's of data or less left then this is the last data

                    iosf_tgtq_cmddata_d.data               = iosf_tgt_data.data;                      
                    iosf_tgtq_cmddata_d.data_par           = f_hqm_data_parity(iosf_tgt_data.data, 
                                                                           iosf_tgt_data.dparity,
                                                                           '0,
                                                                           up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                           tgt_dpar_err);
                   iosf_tgtq_cmddata_d.dpar_err           = tgt_dpar_err;
                end

                63 : begin
                    data_count_nxt                         = (data_count_ff <= 10'd2) ?
                                                                (((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1) ?
                                                                    iosf_tgt_cmd.tlength : '0): (data_count_ff - 10'd2) ; 

                    // No root port with D_WIDTH of 63 so this is un-tested.

                    if ((data_count_ff <= 10'd2) & (iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1]))
                        data_ptr_offset_nxt = '0;
                        // Since we are gathering data off of IOSF need to qualify the increment with the capture flag
                    else if (~cdata_capture_ff)
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd1;
                    else
                        data_ptr_offset_nxt = data_ptr_offset_ff;

                    // 2DW - alldw will always be zero

                    iosf_tgtq_cmddata_d.alldw_data         = 0;
                    data_en                                = 1'b1;

                    // Only push data if we are not capturing it into the internal flops

                    iosf_tgtq_cmddata_d.push_data          = ~cdata_capture_ff;

                    // If we have 2DW's of data or less left then this is the last data

                    // If the data is 2DW or less then there is no need to store data,
                    // just send it through otherwise mux the correct data in.

                    if ((data_count_ff > 10'd2) | cdata_capture_3ff) begin
                        iosf_tgtq_cmddata_d.data           = {128'd0, iosf_tgt_data.data[63:0], iosf_data_ff};
                        iosf_tgtq_cmddata_d.data_par       = f_hqm_data_parity(iosf_tgtq_cmddata_d.data, 
                                                                           (iosf_tgt_data.dparity ^ cdata_parity_ff), '0, up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                            tgt_dpar_err);
                    end else begin
                        iosf_tgtq_cmddata_d.data[63:0]     = iosf_tgt_data.data[63:0];
                        iosf_tgtq_cmddata_d.data_par       = f_hqm_data_parity(iosf_tgtq_cmddata_d.data, 
                                                                           iosf_tgt_data.dparity, '0, up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                           tgt_dpar_err);
                    end

                    iosf_tgtq_cmddata_d.dpar_err           = tgt_dpar_err;
                end

                default : begin // 31
                    data_count_nxt                         = (data_count_ff <= 10'd1) ?
                                                                (((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1) ?
                                                                    iosf_tgt_cmd.tlength : '0): data_count_ff - 10'd1 ; 

                    // No root port with D_WIDTH of 31 so this is un-tested.

                    if (iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])
                        data_ptr_offset_nxt = '0;
                        // Since we are gathering data off of IOSF need to qualify the increment with the capture flag
                    else if ((cdata_capture_cnt_ff == 1'b1) | (data_count_ff <= 10'd1)) 
                        data_ptr_offset_nxt = data_ptr_offset_ff + 9'd1;
                    else
                        data_ptr_offset_nxt = data_ptr_offset_ff;

                    // 1DW - alldw will always be zero

                    iosf_tgtq_cmddata_d.alldw_data         = 0;
                    data_en                                = 1'b1;

                    // Only push data if we are not capturing it into the internal flops

                    iosf_tgtq_cmddata_d.push_data          = (cdata_capture_cnt_ff == 1'b1) | (data_count_ff <= 10'd1);    

                    // If we have 1DW's of data or less left then this is the last data

                    // If the data is 1DW or less then there is no need to store data,
                    // just send it through otherwise mux the correct data in.

                    if (cdata_capture_cnt_ff == 1'b0) begin
                        iosf_tgtq_cmddata_d.data[31:0]     = iosf_tgt_data.data[31:0];
                        iosf_tgtq_cmddata_d.data_par       = f_hqm_data_parity(iosf_tgtq_cmddata_d.data, 
                                                                           iosf_tgt_data.dparity, '0, up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                           tgt_dpar_err);
                    end else begin
                        iosf_tgtq_cmddata_d.data[63:0]     = {iosf_tgt_data.data[31:0], iosf_data_ff[31:0]};
                        iosf_tgtq_cmddata_d.data_par       = f_hqm_data_parity(iosf_tgtq_cmddata_d.data, 
                                                                           (iosf_tgt_data.dparity ^ (^cdata_parity_ff[0])), '0, up_dn_cfg, TGT_DATPARCHK_DIS,
                                                                           tgt_dpar_err);
                    end

                    iosf_tgtq_cmddata_d.dpar_err           = tgt_dpar_err;
                end

            endcase
        end  // Data from previous clk cycle of cput from IOSF
           //en/d //data from CASE1 
           
//==============================================================================================================
//CASE 4 & 2 
//-------------------------------------------------------------------------------------------------------------
//Data from Error Block : None
//Data from UR/CA : None
//==============================================================================================================

        //CASE 3
        //-------------------------------------------------------------------------------------------------------------
        //Data from MSI
        //==============================================================================================================

        if ((iosf_tgt_cput.cmd_put && iosf_tgt_cmd.tfmt[1])==1'b1) begin
                        data_count_nxt = iosf_tgt_cmd.tlength;
        end

    end //if CASE 1 IOSF SWF data or  CASE 3 Config Data

end

always_comb begin: has_data_d_gen_p
    //=============================
    // Data Length 
    //--------------
    has_data_d = (iosf_tgt_cput.cmd_put & iosf_tgt_cmd.tfmt[1]) | data_en;
end

//////////////////////////////////////////////////////////////////////////////////
// Capture data and parity info from IOSF bus
//////////////////////////////////////////////////////////////////////////////////
generate
    if (D_WIDTH == 63) begin : D63

        always_comb begin
            if (iosf_tgt_cput.cmd_put & iosf_tgt_cmd.tfmt[1] & (data_count_nxt > 10'd2)) begin
                cdata_capture = 1'b1;
            end else if (iosf_tgt_cput.cmd_put & iosf_tgt_cmd.tfmt[1] & (data_count_nxt <= 10'd2)) begin
                cdata_capture = 1'b0;
            end else if (data_count_nxt <= 10'd2) begin
                cdata_capture = 1'b0;
            end else if (data_count_nxt == 10'd0) begin
                cdata_capture = '0;
            end else begin
                cdata_capture = ~cdata_capture_ff;
            end
        end

        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,0,cdata_capture_ff,cdata_capture,1);
        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,0,cdata_capture_3ff,cdata_capture_ff,1);
        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,'0,iosf_data_ff,iosf_tgt_data.data[63:0],cdata_capture_ff);
        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,'0,cdata_parity_ff,iosf_tgt_data.dparity,cdata_capture_ff);

        always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
         if (~prim_gated_rst_b) begin
          cdata_capture_ff  <= '0;
          iosf_data_ff      <= '0;
          cdata_capture_3ff <= '0;
          cdata_parity_ff   <= '0;
         end else begin
          cdata_capture_ff  <= cdata_capture;
          cdata_capture_3ff <= cdata_capture_ff;
          if (cdata_capture_ff) begin
           iosf_data_ff     <= iosf_tgt_data.data[63:0];
           cdata_parity_ff  <= iosf_tgt_data.dparity;
          end
         end
        end

        always_comb begin
            cdata_capture_cnt       = '0;
            cdata_capture_cnt_ff    = '0;
            iosf_data_d             = '0;
            cdata_parity_d          = '0;
        end

    end else if (D_WIDTH == 31) begin : D31

        always_comb begin
            if (iosf_tgt_cput.cmd_put & iosf_tgt_cmd.tfmt[1] & (data_count_nxt > 10'd1)) begin
                cdata_capture = 1'b1;
            end else if (iosf_tgt_cput.cmd_put & iosf_tgt_cmd.tfmt[1] & (data_count_nxt <= 10'd1)) begin
                cdata_capture = 1'b0;
            end else if (data_count_nxt <= 10'd1) begin
                cdata_capture = 1'b0;
            end else if (data_count_nxt == 10'd0) begin
                cdata_capture = '0;
            end else begin
                cdata_capture = cdata_capture_cnt_ff == 2'b11;
            end
        end

        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,0,cdata_capture_ff,cdata_capture,1);
        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,0,cdata_capture_3ff,cdata_capture_ff,1);

        always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
         if (~prim_gated_rst_b) begin
          cdata_capture_ff  <= '0;
          cdata_capture_3ff <= '0;
         end else begin
          cdata_capture_ff  <= cdata_capture;
          cdata_capture_3ff <= cdata_capture_ff;
         end
        end

        // Data counter is used to control the mux as we store 1DW of data/parity into our
        // internal registers.

        always_comb begin
            if (cdata_capture) cdata_capture_cnt = '0;
            else if (iosf_tgt_cput.cmd_put & iosf_tgt_cmd.tfmt[1] & (data_count_nxt <= 10'd1))
                cdata_capture_cnt = '0;
            else if (has_data) cdata_capture_cnt = cdata_capture_cnt_ff + 1;
            else cdata_capture_cnt = '0;
        end

        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,0,cdata_capture_cnt_ff,cdata_capture_cnt,1);

        always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
         if (~prim_gated_rst_b) begin
          cdata_capture_cnt_ff <= '0;
         end else begin
          cdata_capture_cnt_ff <= cdata_capture_cnt;
         end
        end

        always_comb begin

            // Capture the data

            iosf_data_d = iosf_data_ff;

            case (cdata_capture_cnt_ff)
                2'b00 : iosf_data_d[31:00] = iosf_tgt_data.data;
                2'b01 : iosf_data_d[63:32] = iosf_tgt_data.data;
                2'b10 : iosf_data_d[95:64] = iosf_tgt_data.data;
            endcase

            // Capture the parity

            cdata_parity_d = cdata_parity_ff;

            case (cdata_capture_cnt_ff)
                2'b00 : cdata_parity_d[0] = iosf_tgt_data.dparity;
                2'b01 : cdata_parity_d[1] = iosf_tgt_data.dparity;
                2'b10 : cdata_parity_d[2] = iosf_tgt_data.dparity;
            endcase
        end

        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,'0,iosf_data_ff,iosf_data_d,1);
        // Replaced: `HQM_ARFF_ENB(prim_nonflr_clk,prim_gated_rst_b,'0,cdata_parity_ff,cdata_parity_d,1);

        always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
         if (~prim_gated_rst_b) begin
          iosf_data_ff    <= '0;
          cdata_parity_ff <= '0;
         end else begin
          iosf_data_ff    <= iosf_data_d;
          cdata_parity_ff <= cdata_parity_d;
         end
        end

    end else begin : D255_127

        always_comb begin
            cdata_capture           = '0;
            cdata_capture_ff        = '0;
            cdata_capture_3ff       = '0;
            cdata_capture_cnt       = '0;
            cdata_capture_cnt_ff    = '0;
            iosf_data_ff            = '0;
            iosf_data_d             = '0;
            cdata_parity_ff         = '0;
            cdata_parity_d          = '0;
        end

    end
endgenerate
    
//================================================================
// NOA signals
//---------------------------------------------------------------

always_comb begin
    noa_tgtcntrl = { dec_bits                  // 23:21
                    ,dec_type                  // 20:17
                    ,tgt_idle                  // 16
                    ,iosf_tgt_cput.cmd_rtype   // 15:14
                    ,iosf_tgt_cput.cmd_put     // 13
                    ,iosf_tgt_cmd.tfmt         // 12:11
                    ,has_data                  // 10
                    ,data_count_ff             // 9:0
    };
end

endmodule

