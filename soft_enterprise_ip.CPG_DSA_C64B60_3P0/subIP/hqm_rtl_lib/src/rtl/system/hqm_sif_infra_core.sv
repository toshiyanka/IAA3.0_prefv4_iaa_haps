//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// HQM System Interface infrastructure support logic
// -------------------------------------------------------------------
`include "hqm_system_def.vh"

module hqm_sif_infra_core

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    input  logic                                hqm_inp_gated_clk ,
    output logic                                hqm_inp_gated_rst_n ,
    input  logic                                hqm_gated_rst_b ,

    output logic                                prim_gated_wflr_rst_b_primary ,

    //---------------------------------------------------------------------------------------------
    // IOSF Primary CDC signals

    input  logic                                prim_freerun_clk ,
    input  logic                                prim_gated_clk ,
    input  logic                                prim_nonflr_clk ,
    input  logic                                prim_gated_rst_b ,

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Request Bus Signals (for smon only)

    input  logic                                req_put ,               // req: Request Put
    input  logic   [1:0]                        req_rtype ,             // req: Request Type
    input  logic   [MAX_DATA_LEN:0]             req_dlen ,              // req: Request Data Length

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Specific Control Signals (for smon only) ,

    input  logic                                gnt ,                   // req: Grant
    input  logic   [1:0]                        gnt_rtype ,             // req: Grant Request Type
    input  logic   [1:0]                        gnt_type ,              // req: Grant Type

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Master Command Signals (for smon only)

    input  logic   [1:0]                        mfmt ,                  // req: Fmt
    input  logic   [4:0]                        mtype ,                 // req: Type
    input  logic   [9:0]                        mlength ,               // req: Length

    //---------------------------------------------------------------------------------------------
    // IOSF Primary 3.4 Target Interface - Credit Exchange Signals (for smon only)

    input  logic                                credit_put ,            // req: Credit Update Put
    input  logic   [1:0]                        credit_rtype ,          // req: CUP Request Type
    input  logic                                credit_cmd ,            // req: Cmd  Cred Increment
    input  logic   [2:0]                        credit_data ,           // req: Data Cred Increment

    //---------------------------------------------------------------------------------------------
    // IOSF Primary Target Command Interface (for smon only)

    input  logic                                cmd_put ,               // req: Command Put
    input  logic   [1:0]                        cmd_rtype ,             // req: Put Request Type
    input  logic   [1:0]                        tfmt ,                  // req: Fmt
    input  logic   [4:0]                        ttype ,                 // req: Type
    input  logic   [9:0]                        tlength ,               // req: Length

    //---------------------------------------------------------------------------------------------
    // System HCW Enqueue interface

    input  logic                                hcw_enq_in_ready ,
    output logic                                hcw_enq_in_ready_qual ,

    output logic                                hcw_enq_in_v ,
    input  logic                                hcw_enq_in_v_prequal ,
    input  hqm_system_enq_data_in_t             hcw_enq_in_data ,           // smon only

    //---------------------------------------------------------------------------------------------
    // System Posted Request interface

    output logic                                mask_posted ,

    //---------------------------------------------------------------------------------------------
    // System Alarm Interrupt interface

    input  logic                                sif_alarm_ready ,

    output logic                                sif_alarm_v ,
    output aw_alarm_t                           sif_alarm_data ,

    //---------------------------------------------------------------------------------------------
    // IOSF Control interface to hqm_system

    output logic                                pci_cfg_sciov_en ,              // Scalable IO Virtualization enable

    output logic                                pci_cfg_pmsixctl_msie ,         // MSIX global enable
    output logic                                pci_cfg_pmsixctl_fm ,           // MSIX global mask

    //---------------------------------------------------------------------------------------------
    // MASTER interface

    input  logic                                pm_fsm_in_run ,
    input  logic                                pm_allow_ing_drop ,

    input  logic                                hqm_proc_reset_done ,
    input  logic                                hqm_flr_prep ,

    //---------------------------------------------------------------------------------------------
    // CFG Master

    input  hqm_sif_csr_pkg::hqm_sif_csr_sai_export_t  hqm_sif_csr_sai_export ,

    input  hqm_rtlgen_pkg_v12::cfg_req_32bit_t  hqm_csr_ext_mmio_req ,
    input  logic                                hqm_csr_ext_mmio_req_apar ,
    input  logic                                hqm_csr_ext_mmio_req_dpar ,

    output hqm_rtlgen_pkg_v12::cfg_ack_32bit_t  hqm_csr_ext_mmio_ack ,
    output logic [1:0]                          hqm_csr_ext_mmio_ack_err ,


    input  CFG_MASTER_TIMEOUT_t                 cfg_master_timeout ,

    output  logic                               cfgm_timeout_error ,

    output new_CFGM_STATUS_t                    cfgm_status ,
    output new_CFGM_STATUS2_t                   cfgm_status2 ,

    output logic                                cfgm_idle ,

    //---------------------------------------------------------------------------------------------
    // APB interface

    output logic                                psel ,
    output logic                                penable ,
    output logic                                pwrite ,
    output logic   [31:0]                       paddr ,
    output logic   [31:0]                       pwdata ,
    output logic   [19:0]                       puser ,

    input  logic                                pready ,
    input  logic                                pslverr ,
    input  logic   [31:0]                       prdata ,
    input  logic                                prdata_par ,

    //---------------------------------------------------------------------------------------------
    // DFX interface

    input  logic                                fscan_rstbypen ,
    input  logic                                fscan_byprst_b ,

    //---------------------------------------------------------------------------------------------
    // Alarms

    input  logic                                ri_fifo_overflow ,
    input  logic                                mstr_fifo_overflow ,
    input  logic                                ri_fifo_underflow ,
    input  logic                                mstr_fifo_underflow ,
    input  logic [5:0]                          ri_fifo_afull ,
    input  logic [2:0]                          mstr_fifo_afull ,

    input  logic [2:0]                          mstr_db_status_in_stalled ,
    input  logic [5:0]                          ri_db_status_in_stalled ,
    input  logic [2:0]                          mstr_db_status_in_taken ,
    input  logic [5:0]                          ri_db_status_in_taken ,
    input  logic [2:0]                          mstr_db_status_out_stalled ,
    input  logic [5:0]                          ri_db_status_out_stalled ,

    output logic [31:0]                         int_serial_status,

    output load_SIF_ALARM_ERR_t                 set_sif_alarm_err ,
    input  SIF_ALARM_ERR_t                      sif_alarm_err ,
    input  logic                                ri_parity_alarm ,
    input  load_RI_PARITY_ERR_t                 set_ri_parity_err ,
    input  logic                                rf_ipar_error ,
    input  logic                                sif_parity_alarm ,
    input  logic [8:0]                          set_sif_parity_err_mstr ,
    input  load_DEVTLB_ATS_ERR_t                set_devtlb_ats_err ,
    input  logic                                devtlb_ats_alarm ,

    input  logic                                timeout_error ,
    input  logic   [9:0]                        timeout_syndrome ,

    input  logic                                sb_ep_parity_err_sync ,

    input  logic                                cpl_error ,

    //---------------------------------------------------------------------------------------------
    // idle / clocks

    input  logic                                hqm_idle ,

    output logic                                int_idle ,

    //---------------------------------------------------------------------------------------------
    // csr

    input  logic                                csr_pmsixctl_msie_wxp ,         // Control output for MSIX enable
    input  logic                                csr_pmsixctl_fm_wxp ,           // MSIX global mask

    input  logic                                csr_pasid_enable ,

    input  logic                                cds_smon_event ,
    input  logic [31:0]                         cds_smon_comp ,

    //---------------------------------------------------------------------------------------------
    // cfg

    output hqm_sif_csr_hc_rvalid_t              cfg_rvalid ,
    output hqm_sif_csr_hc_wvalid_t              cfg_wvalid ,
    output hqm_sif_csr_hc_error_t               cfg_error ,
    output hqm_sif_csr_hc_reg_read_t            cfg_rdata ,
    input  hqm_sif_csr_hc_re_t                  cfg_re ,
    input  hqm_sif_csr_handcoded_t              cfg_we ,
    input  logic   [47:0]                       cfg_addr ,
    input  hqm_sif_csr_hc_reg_write_t           cfg_wdata ,

    //---------------------------------------------------------------------------------------------
    // flr

    input  logic [3:0]                          flr_triggered_wl_infra ,
    input  logic                                flr_treatment
);

//-----------------------------------------------------------------------------------------------------
// Receive and Transmit Interface signals

// Reset, Reset related, and Clock gate related

logic [3:0]                             prim_gated_wflr_rst_b ;

logic                                   fifo_overflow ;
logic                                   fifo_underflow ;

logic                                   int_up_ready_nc ;
logic   [1:0]                           out_smon_interrupt_nc ;

//-----------------------------------------------------------------------------------------------------
// Local hqm_clk resets from hqm_master

hqm_AW_reset_sync_scan i_hqm_inp_gated_rst_n (

     .clk               (hqm_inp_gated_clk)
    ,.rst_n             (hqm_gated_rst_b)
    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    ,.rst_n_sync        (hqm_inp_gated_rst_n)
);

//-----------------------------------------------------------------------------------------------------
// Resets

// Lint Note15 jbdiethe 030152015
// Error 70023
//  "combinational logic drives asynchronous set/reset pin"
// This is the standard muxing arrangement used for fscan reset bypass
// Its required for proper reset generation.

// Added scan bypass mux for below reset signal (HSD 4728227)

logic [3:0] prim_gated_wflr_rst_b_pre;

assign prim_gated_wflr_rst_b_pre = {4{prim_gated_rst_b}} & flr_triggered_wl_infra;

hqm_AW_reset_mux #(.WIDTH(4)) i_prim_gated_wflr_rst_b (

     .rst_in_n          (prim_gated_wflr_rst_b_pre)
    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    ,.rst_out_n         (prim_gated_wflr_rst_b)
);

assign prim_gated_wflr_rst_b_primary = prim_gated_wflr_rst_b [0] ;

//-----------------------------------------------------------------------------------------------------
// Shields up logic

logic       pm_allow_ing_drop_q;
logic       pm_fsm_in_run_q;
logic       hqm_flr_prep_q;
logic       hqm_proc_reset_done_q;

logic       drop_ingress;
logic       mask_ingress;
logic       mask_ingress_q;

logic       sif_alarm_ready_qual;
logic       sif_alarm_v_prequal;

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  pm_fsm_in_run_q       <= '0;
  pm_allow_ing_drop_q   <= '1;
  hqm_flr_prep_q        <= '0;
  hqm_proc_reset_done_q <= '0;
  mask_ingress_q        <= '0;
 end else begin
  pm_fsm_in_run_q       <= pm_fsm_in_run;
  pm_allow_ing_drop_q   <= pm_allow_ing_drop;
  hqm_flr_prep_q        <= hqm_flr_prep;
  hqm_proc_reset_done_q <= hqm_proc_reset_done;
  mask_ingress_q        <= mask_ingress;
 end
end

assign drop_ingress = pm_allow_ing_drop_q & ~pm_fsm_in_run_q;
assign mask_ingress = drop_ingress | hqm_flr_prep_q | ~hqm_proc_reset_done_q;

assign hcw_enq_in_v = hcw_enq_in_v_prequal & ~mask_ingress;
assign sif_alarm_v  = sif_alarm_v_prequal & ~mask_ingress;

assign hcw_enq_in_ready_qual = (hcw_enq_in_ready & ~mask_ingress) | drop_ingress;
assign sif_alarm_ready_qual  = (sif_alarm_ready  & ~mask_ingress) | drop_ingress;

// These need to be on the hqm_inp_gated_clk version of the qualifiers

hqm_AW_sync_rst1 i_mask_posted (

     .clk       (hqm_inp_gated_clk)
    ,.rst_n     (hqm_inp_gated_rst_n)
    ,.data      (mask_ingress_q)
    ,.data_sync (mask_posted)
);

//-----------------------------------------------------------------------------------------------------
// Alarm interrupt interface

assign fifo_overflow  = |{mstr_fifo_overflow,  ri_fifo_overflow};
assign fifo_underflow = |{mstr_fifo_underflow, ri_fifo_underflow};

localparam NUM_INF = 1;
localparam NUM_COR = 1;
localparam NUM_UNC = 10;

logic           [NUM_INF-1:0]   sif_alarm_inf_v;
aw_alarm_syn_t  [NUM_INF-1:0]   sif_alarm_inf_data;
logic           [NUM_COR-1:0]   sif_alarm_cor_v;
aw_alarm_syn_t  [NUM_COR-1:0]   sif_alarm_cor_data;
logic           [NUM_UNC-1:0]   sif_alarm_unc_v;
aw_alarm_syn_t  [NUM_UNC-1:0]   sif_alarm_unc_data;

assign sif_alarm_inf_v    = '0;
assign sif_alarm_inf_data = '0;
assign sif_alarm_cor_v    = '0;
assign sif_alarm_cor_data = '0;

assign sif_alarm_unc_v    = {
                              devtlb_ats_alarm                                          //  9
                             ,cpl_error                                                 //  8 CA or UR
                             ,rf_ipar_error                                             //  7
                             ,(|hqm_csr_ext_mmio_ack_err)                               //  6
                             ,sif_parity_alarm                                          //  5
                             ,ri_parity_alarm                                           //  4
                             ,(sb_ep_parity_err_sync & ~sif_alarm_err.SB_EP_PARITY_ERR) //  3
                             ,(fifo_overflow         & ~sif_alarm_err.FIFO_OVERFLOW)    //  2
                             ,(fifo_underflow        & ~sif_alarm_err.FIFO_UNDERFLOW)   //  1
                             ,timeout_error                                             //  0
};

aw_alarm_msix_map_t alarm_msix_map;

assign alarm_msix_map = HQM_ALARM;

assign sif_alarm_unc_data = {// msix_map[2:0], rtype[1:0], rid[7:0]
                              {alarm_msix_map                                           //  9 Devtlb error
                              ,{(10-$bits(set_devtlb_ats_err)){1'b0}}
                              ,set_devtlb_ats_err
                              }
                             ,{alarm_msix_map, 2'd0, 8'd0}                              //  8 Cpl error
                             ,{alarm_msix_map, 2'd0, 8'd0}                              //  7
                             ,{alarm_msix_map, 2'd0, 4'd0                               //  6 APB  parity/timeout
                              ,hqm_csr_ext_mmio_ack.read_valid
                              ,hqm_csr_ext_mmio_ack.write_valid
                              ,hqm_csr_ext_mmio_ack_err
                              }
                              // These next 2 use {rtype, rid} as a first error indication
                             ,{alarm_msix_map                                           //  5 SIF parity
                              ,{(10-$bits(set_sif_parity_err_mstr)){1'b0}}
                              ,set_sif_parity_err_mstr       
                              }
                             ,{alarm_msix_map                                           //  4 RI   parity
                              ,{(10-$bits(set_ri_parity_err)){1'b0}}
                              ,set_ri_parity_err
                              }
                             ,{alarm_msix_map, 2'd0, 8'd0}                              //  3 SB   parity
                             ,{alarm_msix_map, 2'd0, 8'd0}                              //  2 FIFO overflow
                             ,{alarm_msix_map, 2'd0, 8'd0}                              //  1 FIFO underflow
                             ,{alarm_msix_map, timeout_syndrome}                        //  0 Timeout
};

assign set_sif_alarm_err  = sif_alarm_unc_v;

hqm_AW_int_serializer #(

     .NUM_INF                       (NUM_INF)
    ,.NUM_COR                       (NUM_COR)
    ,.NUM_UNC                       (NUM_UNC)

) i_int_serializer (

     .hqm_inp_gated_clk             (prim_gated_clk)                                //I: INT_SER
    ,.hqm_inp_gated_rst_n           (prim_gated_rst_b)
    ,.rst_prep                      ('0)                                            //I: INT_SER

    ,.unit                          (4'd0)                                          //I: INT_SER

    ,.inf_v                         (sif_alarm_inf_v)                               //I: INT_SER
    ,.inf_data                      (sif_alarm_inf_data)                            //I: INT_SER

    ,.cor_v                         (sif_alarm_cor_v)                               //I: INT_SER
    ,.cor_data                      (sif_alarm_cor_data)                            //I: INT_SER

    ,.unc_v                         (sif_alarm_unc_v)                               //I: INT_SER
    ,.unc_data                      (sif_alarm_unc_data)                            //I: INT_SER

    ,.int_up_ready                  (int_up_ready_nc)                               //O: INT_SER
    ,.int_up_v                      ('0)                                            //I: INT_SER
    ,.int_up_data                   ('0)                                            //I: INT_SER

    ,.int_down_ready                (sif_alarm_ready_qual)                          //I: INT_SER
    ,.int_down_v                    (sif_alarm_v_prequal)                           //O: INT_SER
    ,.int_down_data                 (sif_alarm_data)                                //O: INT_SER

    ,.status                        (int_serial_status)                             //O: INT_SER
    ,.int_idle                      (int_idle)                                      //O: INT_SER
);

//-----------------------------------------------------------------------------------------------------
// SMON logic

localparam SMON_WIDTH = 17;

logic   [9:0]                           smon_cfg_write_q;
logic   [9:0]                           smon_cfg_read_q;
logic   [31:0]                          smon_cfg_wdata_q;
logic                                   smon_cfg_addr_q;
logic   [31:0]                          smon_cfg_rdata[19:0];

logic   [ SMON_WIDTH    -1:0]           smon_v;
logic   [(SMON_WIDTH*32)-1:0]           smon_comp;
logic   [(SMON_WIDTH*32)-1:0]           smon_val;
logic   [1:0]                           smon_enabled;

logic                                   hcw_enq_in_ready_q;
logic                                   hcw_enq_in_v_q;
logic [$bits(hcw_enq_in_data)-1:64]     hcw_enq_in_data_q;
logic                                   credit_put_q;
logic   [1:0]                           credit_rtype_q;
logic                                   credit_cmd_q;
logic   [2:0]                           credit_data_q;
logic                                   req_put_q;
logic   [1:0]                           req_rtype_q;
logic   [9:0]                           req_dlen_q;
logic                                   gnt_q;
logic                                   gnt_qq;
logic   [1:0]                           gnt_rtype_q;
logic   [1:0]                           gnt_rtype_qq;
logic   [1:0]                           gnt_type_q;
logic   [1:0]                           gnt_type_qq;
logic   [1:0]                           mfmt_q;
logic   [4:0]                           mtype_q;
logic   [9:0]                           mlength_q;
logic                                   cmd_put_q;
logic   [1:0]                           cmd_rtype_q;
logic   [1:0]                           tfmt_q;
logic   [4:0]                           ttype_q;
logic   [9:0]                           tlength_q;
logic   [31:0]                          fifo_afull_q;
logic                                   pslverr_q;
logic                                   pready_q;
logic                                   hqm_idle_q;
logic                                   sif_alarm_ready_q;
logic                                   sif_alarm_v_q;
aw_alarm_t                              sif_alarm_data_q;
logic                                   cds_smon_event_q;
logic   [31:0]                          cds_smon_comp_q;

always_ff @(posedge prim_gated_clk or negedge prim_gated_wflr_rst_b[1]) begin
 if (~prim_gated_wflr_rst_b[1]) begin
  smon_cfg_write_q      <= '0;
  smon_cfg_read_q       <= '0;
 end else begin
  smon_cfg_write_q      <= {(&cfg_we.AW_SMON_COMP_MASK1)
                           ,(&cfg_we.AW_SMON_COMP_MASK0)
                           ,(&cfg_we.AW_SMON_MAXIMUM_TIMER)
                           ,(&cfg_we.AW_SMON_TIMER)
                           ,(&cfg_we.AW_SMON_ACTIVITYCOUNTER1)
                           ,(&cfg_we.AW_SMON_ACTIVITYCOUNTER0)
                           ,(&cfg_we.AW_SMON_COMPARE1)
                           ,(&cfg_we.AW_SMON_COMPARE0)
                           ,(&cfg_we.AW_SMON_CONFIGURATION1)
                           ,(&cfg_we.AW_SMON_CONFIGURATION0)
                           } & ~{10{(|smon_cfg_write_q)}};
  smon_cfg_read_q       <= {(&cfg_re.AW_SMON_COMP_MASK1)
                           ,(&cfg_re.AW_SMON_COMP_MASK0)
                           ,(&cfg_re.AW_SMON_MAXIMUM_TIMER)
                           ,(&cfg_re.AW_SMON_TIMER)
                           ,(&cfg_re.AW_SMON_ACTIVITYCOUNTER1)
                           ,(&cfg_re.AW_SMON_ACTIVITYCOUNTER0)
                           ,(&cfg_re.AW_SMON_COMPARE1)
                           ,(&cfg_re.AW_SMON_COMPARE0)
                           ,(&cfg_re.AW_SMON_CONFIGURATION1)
                           ,(&cfg_re.AW_SMON_CONFIGURATION0)
                           } & ~{10{(|smon_cfg_read_q)}};
 end
end

always_ff @(posedge prim_gated_clk or negedge prim_gated_wflr_rst_b[2]) begin
  if (~prim_gated_wflr_rst_b[2]) begin
    hqm_idle_q                  <= '0;
    hcw_enq_in_ready_q          <= '0;
    hcw_enq_in_v_q              <= '0;
    credit_put_q                <= '0;
    req_put_q                   <= '0;
    gnt_q                       <= '0;
    gnt_qq                      <= '0;
    cmd_put_q                   <= '0;
    sif_alarm_ready_q           <= '0;
    sif_alarm_v_q               <= '0;
    cds_smon_event_q            <= '0;
    cds_smon_comp_q             <= '0;
  end else begin
    hqm_idle_q                  <= hqm_idle;
    if (|smon_enabled) begin
      hcw_enq_in_ready_q        <= hcw_enq_in_ready_qual;
      hcw_enq_in_v_q            <= hcw_enq_in_v;
      credit_put_q              <= credit_put;
      req_put_q                 <= req_put;
      gnt_q                     <= gnt;
      gnt_qq                    <= gnt_q;
      cmd_put_q                 <= cmd_put;
      sif_alarm_ready_q         <= sif_alarm_ready_qual;
      sif_alarm_v_q             <= sif_alarm_v;
      cds_smon_event_q          <= cds_smon_event;
      cds_smon_comp_q           <= cds_smon_comp;
    end
  end
end

always_ff @(posedge prim_gated_clk) begin
 smon_cfg_wdata_q <= cfg_wdata.AW_SMON_TIMER;
 smon_cfg_addr_q  <= cfg_addr[6];
 if ((|smon_enabled) & ~flr_treatment) begin
  hcw_enq_in_data_q           <= hcw_enq_in_data[$bits(hcw_enq_in_data)-1:64];
  credit_rtype_q              <= credit_rtype;
  credit_cmd_q                <= credit_cmd;
  credit_data_q               <= credit_data;
  req_rtype_q                 <= req_rtype;
  req_dlen_q                  <= req_dlen;
  gnt_rtype_q                 <= gnt_rtype;
  gnt_rtype_qq                <= gnt_rtype_q;
  gnt_type_q                  <= gnt_type;
  gnt_type_qq                 <= gnt_type_q;
  mfmt_q                      <= mfmt;
  mtype_q                     <= mtype;
  mlength_q                   <= mlength;
  cmd_rtype_q                 <= cmd_rtype;
  tfmt_q                      <= tfmt;
  ttype_q                     <= ttype;
  tlength_q                   <= tlength;
  sif_alarm_data_q            <= sif_alarm_data;

  fifo_afull_q                <= {1'b0                              // 31
                                 ,1'b0                              // 30
                                 ,1'b0                              // 29
                                 ,1'b0                              // 28
                                 ,1'b0                              // 27
                                 ,1'b0                              // 26
                                 ,1'b0                              // 25
                                 ,1'b0                              // 24
                                 ,1'b0                              // 23
                                 ,1'b0                              // 22
                                 ,1'b0                              // 21
                                 ,1'b0                              // 20
                                 ,1'b0                              // 19
                                 ,1'b0                              // 18
                                 ,1'b0                              // 17
                                 ,1'b0                              // 16
                                 ,1'b0                              // 15
                                 ,1'b0                              // 14
                                 ,1'b0                              // 13
                                 ,1'b0                              // 12
                                 ,1'b0                              // 11
                                 ,1'b0                              // 10
                                 ,1'b0                              //  9
                                 ,mstr_fifo_afull                   //  8 p_rl_cq_fifo
                                                                    //  7 ibcpl_data_fifo
                                                                    //  6 ibcpl_hdr_fifo
                                 ,ri_fifo_afull                     //  5 ri_phdr_fifo
                                                                    //  4 ri_pdata_fifo
                                                                    //  3 ri_nphdr_fifo
                                                                    //  2 ri_npdata_fifo
                                                                    //  1 ri_ioq_fifo
                                                                    //  0 obcpl_fifo
                                 };

  pslverr_q                   <= pslverr;
  pready_q                    <= pready;
 end
end

assign cfg_rvalid.VISA_SW_CONTROL = '0;
assign cfg_wvalid.VISA_SW_CONTROL = '0;
assign cfg_error.VISA_SW_CONTROL  = '0;
assign cfg_rdata.VISA_SW_CONTROL  = '0;

assign cfg_rvalid.AW_SMON_COMP_MASK1        = smon_cfg_read_q[9];
assign cfg_rvalid.AW_SMON_COMP_MASK0        = smon_cfg_read_q[8];
assign cfg_rvalid.AW_SMON_MAXIMUM_TIMER     = smon_cfg_read_q[7];
assign cfg_rvalid.AW_SMON_TIMER             = smon_cfg_read_q[6];
assign cfg_rvalid.AW_SMON_ACTIVITYCOUNTER1  = smon_cfg_read_q[5];
assign cfg_rvalid.AW_SMON_ACTIVITYCOUNTER0  = smon_cfg_read_q[4];
assign cfg_rvalid.AW_SMON_COMPARE1          = smon_cfg_read_q[3];
assign cfg_rvalid.AW_SMON_COMPARE0          = smon_cfg_read_q[2];
assign cfg_rvalid.AW_SMON_CONFIGURATION1    = smon_cfg_read_q[1];
assign cfg_rvalid.AW_SMON_CONFIGURATION0    = smon_cfg_read_q[0];

assign cfg_wvalid.AW_SMON_COMP_MASK1        = smon_cfg_write_q[9];
assign cfg_wvalid.AW_SMON_COMP_MASK0        = smon_cfg_write_q[8];
assign cfg_wvalid.AW_SMON_MAXIMUM_TIMER     = smon_cfg_write_q[7];
assign cfg_wvalid.AW_SMON_TIMER             = smon_cfg_write_q[6];
assign cfg_wvalid.AW_SMON_ACTIVITYCOUNTER1  = smon_cfg_write_q[5];
assign cfg_wvalid.AW_SMON_ACTIVITYCOUNTER0  = smon_cfg_write_q[4];
assign cfg_wvalid.AW_SMON_COMPARE1          = smon_cfg_write_q[3];
assign cfg_wvalid.AW_SMON_COMPARE0          = smon_cfg_write_q[2];
assign cfg_wvalid.AW_SMON_CONFIGURATION1    = smon_cfg_write_q[1];
assign cfg_wvalid.AW_SMON_CONFIGURATION0    = smon_cfg_write_q[0];

assign cfg_error.AW_SMON_COMP_MASK1         = '0;
assign cfg_error.AW_SMON_COMP_MASK0         = '0;
assign cfg_error.AW_SMON_MAXIMUM_TIMER      = '0;
assign cfg_error.AW_SMON_TIMER              = '0;
assign cfg_error.AW_SMON_ACTIVITYCOUNTER1   = '0;
assign cfg_error.AW_SMON_ACTIVITYCOUNTER0   = '0;
assign cfg_error.AW_SMON_COMPARE1           = '0;
assign cfg_error.AW_SMON_COMPARE0           = '0;
assign cfg_error.AW_SMON_CONFIGURATION1     = '0;
assign cfg_error.AW_SMON_CONFIGURATION0     = '0;

assign cfg_rdata.AW_SMON_COMP_MASK1         = (smon_cfg_addr_q) ? smon_cfg_rdata[19] : smon_cfg_rdata[9];
assign cfg_rdata.AW_SMON_COMP_MASK0         = (smon_cfg_addr_q) ? smon_cfg_rdata[18] : smon_cfg_rdata[8];
assign cfg_rdata.AW_SMON_MAXIMUM_TIMER      = (smon_cfg_addr_q) ? smon_cfg_rdata[17] : smon_cfg_rdata[7];
assign cfg_rdata.AW_SMON_TIMER              = (smon_cfg_addr_q) ? smon_cfg_rdata[16] : smon_cfg_rdata[6];
assign cfg_rdata.AW_SMON_ACTIVITYCOUNTER1   = (smon_cfg_addr_q) ? smon_cfg_rdata[15] : smon_cfg_rdata[5];
assign cfg_rdata.AW_SMON_ACTIVITYCOUNTER0   = (smon_cfg_addr_q) ? smon_cfg_rdata[14] : smon_cfg_rdata[4];
assign cfg_rdata.AW_SMON_COMPARE1           = (smon_cfg_addr_q) ? smon_cfg_rdata[13] : smon_cfg_rdata[3];
assign cfg_rdata.AW_SMON_COMPARE0           = (smon_cfg_addr_q) ? smon_cfg_rdata[12] : smon_cfg_rdata[2];
assign cfg_rdata.AW_SMON_CONFIGURATION1     = (smon_cfg_addr_q) ? smon_cfg_rdata[11] : smon_cfg_rdata[1];
assign cfg_rdata.AW_SMON_CONFIGURATION0     = (smon_cfg_addr_q) ? smon_cfg_rdata[10] : smon_cfg_rdata[0];

assign smon_v    = {
                    cds_smon_event_q                                            // 16   CDS transaction
                   ,cpl_error                                                   // 15   CA or UR
                   ,1'b1                                                        // 14   APB
                   ,1'b1                                                        // 13   FIFO afulls
                   ,cmd_put_q                                                   // 12   Command puts
                   ,gnt_qq                                                      // 11   Grants
                   ,req_put_q                                                   // 10   Request puts
                   ,credit_put_q                                                //  9   Credit puts cmd
                   ,credit_put_q                                                //  8   Credit puts data
                   ,hqm_idle_q                                                  //  7   Idle
                   ,1'b1                                                        //  6   DB input stalls
                   ,1'b1                                                        //  5   DB output stalls
                   ,1'b1                                                        //  4   DB output takens
                   ,(sif_alarm_ready_q  & sif_alarm_v_q)                        //  3   iosf alarms
                   ,(hcw_enq_in_ready_q & hcw_enq_in_v_q)                       //  2   iosf hcw enq port
                   ,(hcw_enq_in_ready_q & hcw_enq_in_v_q)                       //  1   iosf hcw enq ms
                   ,(hcw_enq_in_ready_q & hcw_enq_in_v_q)                       //  0   iosf hcw enq ls
};

assign smon_comp = {
                    cds_smon_comp_q                                             // 16
                   ,32'd0                                                       // 15
                   ,{pwdata[2:0]                                                // 14 [31:29]
                    ,pslverr_q                                                  // 14 [28]
                    ,pready_q                                                   // 14 [27]
                    ,pwrite                                                     // 14 [26]
                    ,penable                                                    // 14 [25]
                    ,psel                                                       // 14 [24]
                    ,paddr[31:24]                                               // 14 [23:16]
                    ,paddr[15:0]                                                // 14 [15:0]
                    }
                   ,fifo_afull_q                                                // 13
                   ,{23'd0, ttype_q, tfmt_q, cmd_rtype_q}                       // 12
                   ,{21'd0, mtype_q, mfmt_q, gnt_type_qq, gnt_rtype_qq}         // 11
                   ,{30'd0, req_rtype_q}                                        // 10
                   ,{30'd0, credit_rtype_q}                                     //  9
                   ,{30'd0, credit_rtype_q}                                     //  8
                   ,32'd0                                                       //  7
                   ,{22'd0
                    ,mstr_db_status_in_stalled                                  //  6 b9:7
                    ,ri_db_status_in_stalled                                    //  6 b6:1
                    ,int_serial_status[13]}                                     //  6 b0
                   ,{22'd0
                    ,mstr_db_status_out_stalled                                 //  5 b9:7
                    ,ri_db_status_out_stalled                                   //  5 b6;1
                    ,int_serial_status[11]}                                     //  5 b0
                   ,{22'd0
                    ,mstr_db_status_in_taken                                    //  4 b9:7
                    ,ri_db_status_in_taken                                      //  4 b6;1
                    ,int_serial_status[10]}                                     //  4 b0
                   ,{{(32-$bits(sif_alarm_data_q)){1'b0}}
                    ,sif_alarm_data_q}                                          //  3
                   ,hcw_enq_in_data_q[159:128]                                  //  2
                   ,hcw_enq_in_data_q[127:96]                                   //  1
                   ,hcw_enq_in_data_q[ 95:64]                                   //  0
};

assign smon_val  = {
                    32'd1                                                       // 16
                   ,32'd1                                                       // 15
                   ,32'd1                                                       // 14
                   ,32'd1                                                       // 13
                   ,{22'd0, tlength_q}                                          // 12
                   ,{22'd0, mlength_q}                                          // 11
                   ,{22'd0, req_dlen_q}                                         // 10
                   ,{31'd0, credit_cmd_q}                                       //  9
                   ,{29'd0, credit_data_q}                                      //  8
                   ,32'd1                                                       //  7
                   ,32'd1                                                       //  6
                   ,32'd1                                                       //  5
                   ,32'd1                                                       //  4
                   ,32'd1                                                       //  3
                   ,32'd16                                                      //  2
                   ,32'd16                                                      //  1
                   ,32'd16                                                      //  0

};

hqm_AW_smon_mask #(.WIDTH(SMON_WIDTH)) i_smon0 (

     .clk                   (prim_gated_clk)
    ,.rst_n                 (prim_gated_wflr_rst_b[3])
    ,.disable_smon          (1'b0)

    ,.in_smon_cfg0_write    (smon_cfg_write_q[0] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg1_write    (smon_cfg_write_q[1] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg2_write    (smon_cfg_write_q[2] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg3_write    (smon_cfg_write_q[3] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg4_write    (smon_cfg_write_q[4] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg5_write    (smon_cfg_write_q[5] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg6_write    (smon_cfg_write_q[6] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg7_write    (smon_cfg_write_q[7] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg8_write    (smon_cfg_write_q[8] & ~smon_cfg_addr_q)        
    ,.in_smon_cfg9_write    (smon_cfg_write_q[9] & ~smon_cfg_addr_q)        

    ,.in_smon_cfg_wdata     (smon_cfg_wdata_q)

    ,.out_smon_cfg0_data    (smon_cfg_rdata[0])
    ,.out_smon_cfg1_data    (smon_cfg_rdata[1])
    ,.out_smon_cfg2_data    (smon_cfg_rdata[2])
    ,.out_smon_cfg3_data    (smon_cfg_rdata[3])
    ,.out_smon_cfg4_data    (smon_cfg_rdata[4])
    ,.out_smon_cfg5_data    (smon_cfg_rdata[5])
    ,.out_smon_cfg6_data    (smon_cfg_rdata[6])
    ,.out_smon_cfg7_data    (smon_cfg_rdata[7])
    ,.out_smon_cfg8_data    (smon_cfg_rdata[8])
    ,.out_smon_cfg9_data    (smon_cfg_rdata[9])

    ,.in_mon_v              (smon_v)
    ,.in_mon_comp           (smon_comp)
    ,.in_mon_val            (smon_val)

    ,.out_smon_interrupt    (out_smon_interrupt_nc[0])                      
    ,.out_smon_enabled      (smon_enabled[0])
);

hqm_AW_smon_mask #(.WIDTH(SMON_WIDTH)) i_smon1 (

     .clk                   (prim_gated_clk)
    ,.rst_n                 (prim_gated_wflr_rst_b[3])
    ,.disable_smon          (1'b0)

    ,.in_smon_cfg0_write    (smon_cfg_write_q[0] & smon_cfg_addr_q)         
    ,.in_smon_cfg1_write    (smon_cfg_write_q[1] & smon_cfg_addr_q)         
    ,.in_smon_cfg2_write    (smon_cfg_write_q[2] & smon_cfg_addr_q)         
    ,.in_smon_cfg3_write    (smon_cfg_write_q[3] & smon_cfg_addr_q)         
    ,.in_smon_cfg4_write    (smon_cfg_write_q[4] & smon_cfg_addr_q)         
    ,.in_smon_cfg5_write    (smon_cfg_write_q[5] & smon_cfg_addr_q)         
    ,.in_smon_cfg6_write    (smon_cfg_write_q[6] & smon_cfg_addr_q)         
    ,.in_smon_cfg7_write    (smon_cfg_write_q[7] & smon_cfg_addr_q)         
    ,.in_smon_cfg8_write    (smon_cfg_write_q[8] & smon_cfg_addr_q)         
    ,.in_smon_cfg9_write    (smon_cfg_write_q[9] & smon_cfg_addr_q)         

    ,.in_smon_cfg_wdata     (smon_cfg_wdata_q)

    ,.out_smon_cfg0_data    (smon_cfg_rdata[10])
    ,.out_smon_cfg1_data    (smon_cfg_rdata[11])
    ,.out_smon_cfg2_data    (smon_cfg_rdata[12])
    ,.out_smon_cfg3_data    (smon_cfg_rdata[13])
    ,.out_smon_cfg4_data    (smon_cfg_rdata[14])
    ,.out_smon_cfg5_data    (smon_cfg_rdata[15])
    ,.out_smon_cfg6_data    (smon_cfg_rdata[16])
    ,.out_smon_cfg7_data    (smon_cfg_rdata[17])
    ,.out_smon_cfg8_data    (smon_cfg_rdata[18])
    ,.out_smon_cfg9_data    (smon_cfg_rdata[19])

    ,.in_mon_v              (smon_v)
    ,.in_mon_comp           (smon_comp)
    ,.in_mon_val            (smon_val)

    ,.out_smon_interrupt    (out_smon_interrupt_nc[1])                      
    ,.out_smon_enabled      (smon_enabled[1])
);

//-----------------------------------------------------------------------------------------------------
// Signals that need to cross clock domains between hqm_sif <-> hqm_system

// These individual control bits need to be synced from the prim_gated_clk to the hqm_inp_gated_clk
// If they are combinatorial, flop them first.  Not considering reg outputs just ANDed with
// flr_treatment_vec as being combinatorial.

hqm_AW_sync_rst0 #(.WIDTH(2)) i_system_out_syncs0 (

     .clk           (hqm_inp_gated_clk)
    ,.rst_n         (hqm_inp_gated_rst_n)
    ,.data          ({csr_pasid_enable
                     ,csr_pmsixctl_msie_wxp
                    })
    ,.data_sync     ({pci_cfg_sciov_en
                     ,pci_cfg_pmsixctl_msie
                    })
);

hqm_AW_sync_rst0 #(.WIDTH(1)) i_freerun_out_syncs0 (

     .clk           (hqm_inp_gated_clk)
    ,.rst_n         (hqm_inp_gated_rst_n)
    ,.data          (csr_pmsixctl_fm_wxp)
    ,.data_sync     (pci_cfg_pmsixctl_fm)
);

//-----------------------------------------------------------------------------------------------------
// APB Interface

hqm_sif_cfg_master i_hqm_sif_cfg_master (

     .prim_gated_clk                        (prim_gated_clk)                        //I: CFGM
    ,.prim_gated_rst_b                      (prim_gated_rst_b)                      //I: CFGM

    ,.flr_triggered_wl                      (flr_triggered_wl_infra[0])             //I: CFGM

    //---------------------------------------------------------------------------------------------
    // CFG interface

    ,.hqm_sif_csr_sai_export                (hqm_sif_csr_sai_export)                //I: CFGM

    ,.hqm_csr_ext_mmio_req                  (hqm_csr_ext_mmio_req)                  //I: CFGM
    ,.hqm_csr_ext_mmio_req_apar             (hqm_csr_ext_mmio_req_apar)             //I: CFGM
    ,.hqm_csr_ext_mmio_req_dpar             (hqm_csr_ext_mmio_req_dpar)             //I: CFGM

    ,.hqm_csr_ext_mmio_ack                  (hqm_csr_ext_mmio_ack)                  //O: CFGM
    ,.hqm_csr_ext_mmio_ack_err              (hqm_csr_ext_mmio_ack_err)              //O: CFGM

    ,.cfg_master_timeout                    (cfg_master_timeout)                    //I: CFGM

    ,.cfgm_timeout_error                    (cfgm_timeout_error)                    //O: CFGM

    ,.cfgm_idle                             (cfgm_idle)                             //O: CFGM
    ,.cfgm_status                           (cfgm_status)                           //O: CFGM
    ,.cfgm_status2                          (cfgm_status2)                          //O: CFGM

    //---------------------------------------------------------------------------------------------
    // APB interface

    ,.psel                                  (psel)                                  //O: CFGM
    ,.penable                               (penable)                               //O: CFGM
    ,.pwrite                                (pwrite)                                //O: CFGM
    ,.paddr                                 (paddr)                                 //O: CFGM
    ,.pwdata                                (pwdata)                                //O: CFGM
    ,.puser                                 (puser)                                 //O: CFGM

    ,.pready                                (pready)                                //I: CFGM
    ,.pslverr                               (pslverr)                               //I: CFGM
    ,.prdata                                (prdata)                                //I: CFGM
    ,.prdata_par                            (prdata_par)                            //I: CFGM
);

//-----------------------------------------------------------------------------------------------------

// VCS coverage off

`ifndef INTEL_SVA_OFF

    // Synchronizer validation controls

    logic [31:0] metastability_seed;
    logic        en_metastability_testing;

    initial begin
      metastability_seed       = '0;
      en_metastability_testing = '0;
    end

`endif

// VCS coverage on

endmodule // hqm_sif_infra_core
