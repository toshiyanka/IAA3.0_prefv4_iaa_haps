// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_csr
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Thursday December 11, 2008
// -- Description :
// The CSR FUB contains the instantiation for all physical and
// virtual CSR functions.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_pf_vf_cfg

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic                                       prim_nonflr_clk
    ,input  logic                                       prim_gated_rst_b

    ,input  logic                                       quiesce_qualifier

    // PCIe type - 0 = RCIEP, 1 = regular endpoint

    ,input  logic                                       strap_hqm_is_reg_ep

    ,input  logic                                       strap_hqm_completertenbittagen

    // hqm_pf_cfg request signals

    ,input  logic                                       hqm_csr_pf0_rst_n
    ,input  logic                                       hqm_csr_pf0_pwr_rst_n
    ,input  hqm_rtlgen_pkg_v12::cfg_req_32bit_t         hqm_csr_pf0_req
    ,output hqm_rtlgen_pkg_v12::cfg_ack_32bit_t         hqm_csr_pf0_ack

    ,output logic                                       ppmcsr_wr_stall

    ,input  logic                                       flr_treatment_vec

    //-----------------------------------------------------------------
    // Inputs
    //-----------------------------------------------------------------

    ,input  logic                                       pm_deassert_intx    // Remove legacy interrupts on FLR

    ,input  logic                                       np_trans_pending

    // Error Status

    ,input  pcists_t                                    csr_pcists          
    ,input  ppaerucm_t                                  csr_ppaerucs        
    ,input  ppaercm_t                                   csr_ppaercs         
    ,input  logic                                       err_urd_vec         // Unsupported request error vector
    ,input  logic                                       err_fed_vec         // fatal error vector
    ,input  logic                                       err_ned_vec         // non-fatal error vector
    ,input  logic                                       err_ced_vec         // Correctable error vector

    // CSR STATUS PF0

    ,input  logic [31:0]                                csr_pf0_ppaerhdrlog0_hdrlogdw0_s    // CSR Status Input Signal
    ,input  logic [31:0]                                csr_pf0_ppaerhdrlog1_hdrlogdw1_s    // CSR Status Input Signal
    ,input  logic [31:0]                                csr_pf0_ppaerhdrlog2_hdrlogdw2_s    // CSR Status Input Signal
    ,input  logic [31:0]                                csr_pf0_ppaerhdrlog3_hdrlogdw3_s    // CSR Status Input Signal
    ,input  hqm_pasidtlp_t                              csr_pf0_ppaertlppflog0

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    ,output logic                                       flr_function0
    ,output logic                                       ps_d0_to_d3
    ,input  pm_fsm_t                                    pm_state

    // BARS

    ,output logic[`HQM_CSR_BAR_SIZE-1:0]                func_pf_bar                 // BAR address for PF0 SRAM
    ,output logic[`HQM_CSR_BAR_SIZE-1:0]                csr_pf_bar                  // BAR address for PF0 CSR space

    // MSI/Interrupts

    ,output logic                                       ri_bme_rxl                  // function's bus master enable
    ,output logic                                       csr_pmsixctl_msie_wxp       // Control output for MSIX enable
    ,output logic                                       csr_pmsixctl_fm_wxp         // MSIX per function mask

    // Power Management

    ,output logic[1:0]                                  csr_pf0_ppmcsr_ps_c         // PF0 power management state

    // Function Level Reset

    ,output logic                                       csr_pdc_start_flr           // Function level reset

    // CSR Control Outputs

    ,output logic                                       csr_pcicmd_mem              // Memory enable from PCICMD CSR
    ,output logic                                       csr_pcicmd_io               // IO enable from PCICMD CSR

    ,output logic[2:0]                                  ri_mps_rxp                  // Maximum Payload size.

    // Error Source Control

    ,output csr_data_t                                  csr_pcists_clr              // PCISTS clear error
    ,output csr_data_t                                  csr_ppaerucs_clr            // PPAERUCS clear error
    ,output ppaerucm_t                                  csr_ppaerucs_c              // Uncorrectable error contorl

    // HSD 4727745 - added support for ANFES for virtual functions

    ,output csr_data_t                                  csr_ppaercs_clr             // PPAERCS clear error
    ,output ppaerucm_t                                  csr_ppaerucm_wp             // Uncorrectable error mask registexr
    ,output ppaercm_t                                   csr_ppaercm_wp              // Correctable error mask registers
    ,output ppaerctlcap_t                               csr_ppaerctlcap_wp          // AER Capability Registers
    ,output pcicmd_t                                    csr_pcicmd_wp               // Device command register
    ,output ppdcntl_t                                   csr_ppdcntl_wp              // Device command register
    ,output ppaerucm_t                                  csr_ppaerucsev              // Uncorrectable error severity

    ,output logic                                       csr_ppdcntl_ero             // Enable Relaxed Ordering
    ,output logic                                       csr_pasid_enable            // SCIOV enable

    // SetID Information

    ,input  logic [15:0]                                strap_hqm_device_id
    ,input  logic [7:0]                                 revision_id_fuses

    ,output logic                                       ats_enabled
);

hqm_rtlgen_pkg_v12::cfg_req_32bit_t                     hqm_csr_pf0_req_int;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t                     hqm_csr_pf0_ack_int;

// PPMCSR write detect and stall

ppmcsr_dly_t                                                ppmcsr_wr_dly;
logic                                                       ppmcsr_wr;

logic                                                       csr_ppdstat_urd_s;  
logic                                                       csr_ppdstat_fed_s;  
logic                                                       csr_ppdstat_ned_s;  
logic                                                       csr_ppdstat_ced_s;  

// Detect zero length accesses to PF

logic                                                       pf_block_zero_length_acc;

// Detect accesses to link registers when strap_hqm_is_reg_ep==0

logic                                                       pf_block_link_reg_acc;

// First Error Pointers

csr_ppaerctlcap_ferrp_t                                     csr_ppaerctlcap_ferrp_rp; 

// Advanced Error Reporting UNcorrectable Error Control Signals

ppaerucm_t                                                  csr_ppaerucs_c_rxp; // Uncorrectable error contorl

genvar i;

// PPDCNTL Edge Detect Flops

logic                                                       err_urd_vec_ff;     // Correctable error vector
logic                                                       err_ned_vec_ff;     // Correctable error vector
logic                                                       err_fed_vec_ff;     // Correctable error vector
logic                                                       err_ced_vec_ff;     // Correctable error vector

// PCISTS Edge detect flops

pcists_t                                                    csr_pcists_f;       // PCISTS error signals

// strap/SetIDValue values

logic [15:0]                                                device_id_in;
logic [7:0]                                                 revision_id_in;

hqm_pf_cfg_pkg::load_AER_CAP_CORR_ERR_STATUS_t              load_aer_cap_corr_err_status;               // RW/1C/V/P
hqm_pf_cfg_pkg::load_AER_CAP_UNCORR_ERR_STATUS_t            load_aer_cap_uncorr_err_status;             // RW/1C/V/P
hqm_pf_cfg_pkg::load_AER_CAP_CONTROL_t                      load_aer_cap_control;
hqm_pf_cfg_pkg::load_AER_CAP_HEADER_LOG_0_t                 load_aer_cap_header_log_0;
hqm_pf_cfg_pkg::load_AER_CAP_HEADER_LOG_1_t                 load_aer_cap_header_log_1;
hqm_pf_cfg_pkg::load_AER_CAP_HEADER_LOG_2_t                 load_aer_cap_header_log_2;
hqm_pf_cfg_pkg::load_AER_CAP_HEADER_LOG_3_t                 load_aer_cap_header_log_3;
hqm_pf_cfg_pkg::load_AER_CAP_TLP_PREFIX_LOG_0_t             load_aer_cap_tlp_prefix_log_0;
hqm_pf_cfg_pkg::load_DEVICE_STATUS_t                        load_device_status;                         // RW/1C/V/P
hqm_pf_cfg_pkg::load_PCIE_CAP_DEVICE_STATUS_t               load_pcie_cap_device_status;                // RW/1C/V/P

hqm_pf_cfg_pkg::new_AER_CAP_CORR_ERR_STATUS_t               new_aer_cap_corr_err_status;                // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_UNCORR_ERR_STATUS_t             new_aer_cap_uncorr_err_status;              // RW/1C/V/P
hqm_pf_cfg_pkg::new_DEVICE_STATUS_t                         new_device_status;                          // RW/1C/V/P
hqm_pf_cfg_pkg::new_PCIE_CAP_DEVICE_STATUS_t                new_pcie_cap_device_status;                 // RW/1C/V/P
hqm_pf_cfg_pkg::new_DEVICE_ID_t                             new_device_id;                              // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_HEADER_LOG_0_t                  new_aer_cap_header_log_0;                   // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_HEADER_LOG_1_t                  new_aer_cap_header_log_1;                   // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_HEADER_LOG_2_t                  new_aer_cap_header_log_2;                   // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_HEADER_LOG_3_t                  new_aer_cap_header_log_3;                   // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_TLP_PREFIX_LOG_0_t              new_aer_cap_tlp_prefix_log_0;               // RW/1C/V/P
hqm_pf_cfg_pkg::new_REVISION_ID_CLASS_CODE_t                new_revision_id_class_code;                 // RW/1C/V/P
hqm_pf_cfg_pkg::new_AER_CAP_CONTROL_t                       new_aer_cap_control;                        // RW/1C/V/P
hqm_pf_cfg_pkg::new_HEADER_TYPE_t                           pf_new_header_type;
hqm_pf_cfg_pkg::new_PCIE_CAP_t                              pf_new_pcie_cap;

hqm_pf_cfg_pkg::FUNC_BAR_L_t                                func_bar_l;
hqm_pf_cfg_pkg::FUNC_BAR_U_t                                func_bar_u;
hqm_pf_cfg_pkg::CSR_BAR_L_t                                 csr_bar_l_nc;
hqm_pf_cfg_pkg::CSR_BAR_U_t                                 csr_bar_u;
hqm_pf_cfg_pkg::MSIX_CAP_CONTROL_t                          msix_cap_control;
hqm_pf_cfg_pkg::MSIX_CAP_PBA_OFFSET_BIR_t                   msix_cap_pba_offset_bir_nc;
hqm_pf_cfg_pkg::MSIX_CAP_TABLE_OFFSET_BIR_t                 msix_cap_table_offset_bir_nc;
hqm_pf_cfg_pkg::AER_CAP_CONTROL_t                           aer_cap_control;                            // RW/1C/V/P
hqm_pf_cfg_pkg::AER_CAP_CORR_ERR_MASK_t                     aer_cap_corr_err_mask;
hqm_pf_cfg_pkg::AER_CAP_UNCORR_ERR_STATUS_t                 aer_cap_uncorr_err_status;                  // RW/1C/V/P
hqm_pf_cfg_pkg::AER_CAP_UNCORR_ERR_MASK_t                   aer_cap_uncorr_err_mask;
hqm_pf_cfg_pkg::AER_CAP_UNCORR_ERR_SEV_t                    aer_cap_uncorr_err_sev;
hqm_pf_cfg_pkg::DEVICE_COMMAND_t                            device_command;
hqm_pf_cfg_pkg::DEVICE_STATUS_t                             device_status_nc;             
hqm_pf_cfg_pkg::PCIE_CAP_DEVICE_CONTROL_t                   pcie_cap_device_control;
hqm_pf_cfg_pkg::PCIE_CAP_DEVICE_CONTROL_2_t                 pcie_cap_device_control_2_nc;
hqm_pf_cfg_pkg::PCIE_CAP_LINK_CAP_t                         pcie_cap_link_cap_nc;
hqm_pf_cfg_pkg::PCIE_CAP_LINK_CONTROL_t                     pcie_cap_link_control_nc;
hqm_pf_cfg_pkg::PCIE_CAP_LINK_STATUS_t                      pcie_cap_link_status_nc;
hqm_pf_cfg_pkg::PM_CAP_CONTROL_STATUS_t                     pm_cap_control_status;                      // RW/1C/V/P
hqm_pf_cfg_pkg::SUBSYSTEM_VENDOR_ID_t                       subsystem_vendor_id;
hqm_pf_cfg_pkg::REVISION_ID_CLASS_CODE_t                    revision_id_class_code_nc;                  // RW/1C/V/P

hqm_pf_cfg_pkg::ACS_CAP_t                                   pf_acs_cap_nc;
hqm_pf_cfg_pkg::ACS_CAP_CONTROL_t                           pf_acs_cap_control_nc;
hqm_pf_cfg_pkg::ACS_CAP_ID_t                                pf_acs_cap_id_nc;
hqm_pf_cfg_pkg::ACS_CAP_VERSION_NEXT_PTR_t                  pf_acs_cap_version_next_ptr_nc;
hqm_pf_cfg_pkg::ATS_CAP_t                                   pf_ats_cap_nc;
hqm_pf_cfg_pkg::ATS_CAP_CONTROL_t                           pf_ats_cap_control;
hqm_pf_cfg_pkg::ATS_CAP_ID_t                                pf_ats_cap_id_nc;
hqm_pf_cfg_pkg::ATS_CAP_VERSION_NEXT_PTR_t                  pf_ats_cap_version_next_ptr_nc;
hqm_pf_cfg_pkg::CACHE_LINE_SIZE_t                           pf_cache_line_size_nc;
hqm_pf_cfg_pkg::CAP_PTR_t                                   pf_cap_ptr_nc;
hqm_pf_cfg_pkg::PCIE_CAP_DEVICE_CAP_2_t                     pf_pcie_cap_device_cap_2_nc;
hqm_pf_cfg_pkg::new_PCIE_CAP_DEVICE_CAP_2_t                 pf_new_pcie_cap_device_cap_2;
hqm_pf_cfg_pkg::DEVICE_ID_t                                 pf_device_id_nc;
hqm_pf_cfg_pkg::HEADER_TYPE_t                               pf_header_type_nc;
hqm_pf_cfg_pkg::INT_LINE_t                                  pf_int_line_nc;
hqm_pf_cfg_pkg::INT_PIN_t                                   pf_int_pin_nc;
hqm_pf_cfg_pkg::MSIX_CAP_ID_t                               pf_msix_cap_id_nc;
hqm_pf_cfg_pkg::MSIX_CAP_NEXT_CAP_PTR_t                     pf_msix_cap_next_cap_ptr_nc;
hqm_pf_cfg_pkg::AER_CAP_CORR_ERR_STATUS_t                   pf_aer_cap_corr_err_status_nc;
hqm_pf_cfg_pkg::AER_CAP_HEADER_LOG_0_t                      pf_aer_cap_header_log_0_nc;
hqm_pf_cfg_pkg::AER_CAP_HEADER_LOG_1_t                      pf_aer_cap_header_log_1_nc;
hqm_pf_cfg_pkg::AER_CAP_HEADER_LOG_2_t                      pf_aer_cap_header_log_2_nc;
hqm_pf_cfg_pkg::AER_CAP_HEADER_LOG_3_t                      pf_aer_cap_header_log_3_nc;
hqm_pf_cfg_pkg::AER_CAP_TLP_PREFIX_LOG_0_t                  pf_aer_cap_tlp_prefix_log_0_nc;
hqm_pf_cfg_pkg::AER_CAP_TLP_PREFIX_LOG_1_t                  pf_aer_cap_tlp_prefix_log_1_nc;
hqm_pf_cfg_pkg::AER_CAP_TLP_PREFIX_LOG_2_t                  pf_aer_cap_tlp_prefix_log_2_nc;
hqm_pf_cfg_pkg::AER_CAP_TLP_PREFIX_LOG_3_t                  pf_aer_cap_tlp_prefix_log_3_nc;
hqm_pf_cfg_pkg::PCIE_CAP_ID_t                               pf_pcie_cap_id_nc;
hqm_pf_cfg_pkg::AER_CAP_ID_t                                pf_aer_cap_id_nc;
hqm_pf_cfg_pkg::AER_CAP_VERSION_NEXT_PTR_t                  pf_aer_cap_version_next_ptr_nc;
hqm_pf_cfg_pkg::PCIE_CAP_NEXT_CAP_PTR_t                     pf_pcie_cap_next_cap_ptr_nc;
hqm_pf_cfg_pkg::PCIE_CAP_t                                  pf_pcie_cap_nc;
hqm_pf_cfg_pkg::PCIE_CAP_DEVICE_CAP_t                       pf_pcie_cap_device_cap_nc;
hqm_pf_cfg_pkg::PCIE_CAP_DEVICE_STATUS_t                    pf_pcie_cap_device_status_nc;
hqm_pf_cfg_pkg::PM_CAP_t                                    pf_pm_cap_nc;
hqm_pf_cfg_pkg::PM_CAP_ID_t                                 pf_pm_cap_id_nc;
hqm_pf_cfg_pkg::PM_CAP_NEXT_CAP_PTR_t                       pf_pm_cap_next_cap_ptr_nc;
hqm_pf_cfg_pkg::SUBSYSTEM_ID_t                              pf_subsystem_id_nc;
hqm_pf_cfg_pkg::VENDOR_ID_t                                 pf_vendor_id_nc;

hqm_pf_cfg_pkg::DVSEC_CAP_ID_t                              dvsec_cap_id_nc;
hqm_pf_cfg_pkg::DVSEC_CAP_VERSION_NEXT_PTR_t                dvsec_cap_version_next_ptr_nc;
hqm_pf_cfg_pkg::DVSEC_HDR1_t                                dvsec_hdr1_nc;
hqm_pf_cfg_pkg::DVSEC_HDR2_t                                dvsec_hdr2_nc;

hqm_pf_cfg_pkg::PASID_CAP_t                                 pasid_cap_nc;
hqm_pf_cfg_pkg::PASID_CAP_ID_t                              pasid_cap_id_nc;
hqm_pf_cfg_pkg::PASID_CAP_VERSION_NEXT_PTR_t                pasid_cap_version_next_ptr_nc;
hqm_pf_cfg_pkg::PASID_CONTROL_t                             pasid_control;

hqm_pf_cfg_pkg::SCIOV_CAP_t                                 sciov_cap_nc;
hqm_pf_cfg_pkg::SCIOV_IMS_t                                 sciov_ims_nc;
hqm_pf_cfg_pkg::SCIOV_SUPP_PGSZ_t                           sciov_supp_pgsz_nc;
hqm_pf_cfg_pkg::SCIOV_SYS_PGSZ_t                            sciov_sys_pgsz_nc;

hqm_pf_cfg_pkg::AER_CAP_ROOT_ERROR_COMMAND_t                aer_cap_root_error_command_nc;
hqm_pf_cfg_pkg::AER_CAP_ROOT_ERROR_STATUS_t                 aer_cap_root_error_status_nc;
hqm_pf_cfg_pkg::AER_CAP_ERROR_SOURCE_IDENT_t                aer_cap_error_source_ident_nc;

logic load_sticky_regs;

// Handle special cases when accessing registers that are different between RCIEP and a standard PCIE EP

always_comb begin : pf0_reg_p

  hqm_csr_pf0_req_int       = hqm_csr_pf0_req;
  hqm_csr_pf0_ack           = hqm_csr_pf0_ack_int;

  // Protect loading of PF sticky regs during ResetPrep or PF FLR

  if (pf_block_zero_length_acc | pf_block_link_reg_acc |
      quiesce_qualifier        | flr_treatment_vec) begin

    hqm_csr_pf0_req_int.valid       = 1'b0;
    hqm_csr_pf0_ack.data            = '0;
    hqm_csr_pf0_ack.sai_successfull = 1'b1;

    if (hqm_csr_pf0_req.opcode == hqm_rtlgen_pkg_v12::CFGWR) begin
      hqm_csr_pf0_ack.write_valid = 1'b1;
    end else begin
      hqm_csr_pf0_ack.read_valid = 1'b1;
    end

  end

end

always_comb begin

  pf_new_pcie_cap_device_cap_2            = '0;
  pf_new_pcie_cap_device_cap_2.CMP10BTAGS = strap_hqm_completertenbittagen;

end

//  Instance CSR module wrapper

assign load_sticky_regs = ~quiesce_qualifier & ~flr_treatment_vec;

assign load_aer_cap_control          = {$bits(load_aer_cap_control)         {load_sticky_regs}};
assign load_aer_cap_header_log_0     = {$bits(load_aer_cap_header_log_0)    {load_sticky_regs}};
assign load_aer_cap_header_log_1     = {$bits(load_aer_cap_header_log_1)    {load_sticky_regs}};
assign load_aer_cap_header_log_2     = {$bits(load_aer_cap_header_log_2)    {load_sticky_regs}};
assign load_aer_cap_header_log_3     = {$bits(load_aer_cap_header_log_3)    {load_sticky_regs}};
assign load_aer_cap_tlp_prefix_log_0 = {$bits(load_aer_cap_tlp_prefix_log_0){load_sticky_regs}};

hqm_pf_cfg i_hqm_pf_cfg (

     .gated_clk                                 (prim_nonflr_clk)
    ,.rtl_clk                                   (prim_nonflr_clk)
    ,.hqm_csr_pf0_pwr_rst_n                     (hqm_csr_pf0_pwr_rst_n)
    ,.hqm_csr_pf0_rst_n                         (hqm_csr_pf0_rst_n)
    ,.prim_gated_rst_b                          (prim_gated_rst_b)
    ,.req                                       (hqm_csr_pf0_req_int)

    ,.load_AER_CAP_CORR_ERR_STATUS              (load_aer_cap_corr_err_status)
    ,.load_AER_CAP_UNCORR_ERR_STATUS            (load_aer_cap_uncorr_err_status)
    ,.load_AER_CAP_CONTROL                      (load_aer_cap_control)
    ,.load_AER_CAP_HEADER_LOG_0                 (load_aer_cap_header_log_0)
    ,.load_AER_CAP_HEADER_LOG_1                 (load_aer_cap_header_log_1)
    ,.load_AER_CAP_HEADER_LOG_2                 (load_aer_cap_header_log_2)
    ,.load_AER_CAP_HEADER_LOG_3                 (load_aer_cap_header_log_3)
    ,.load_AER_CAP_TLP_PREFIX_LOG_0             (load_aer_cap_tlp_prefix_log_0)
    ,.load_DEVICE_STATUS                        (load_device_status)
    ,.load_PCIE_CAP_DEVICE_STATUS               (load_pcie_cap_device_status)

    ,.new_DEVICE_ID                             (new_device_id)
    ,.new_AER_CAP_CORR_ERR_STATUS               (new_aer_cap_corr_err_status)
    ,.new_AER_CAP_CONTROL                       (new_aer_cap_control)
    ,.new_AER_CAP_HEADER_LOG_0                  (new_aer_cap_header_log_0)
    ,.new_AER_CAP_HEADER_LOG_1                  (new_aer_cap_header_log_1)
    ,.new_AER_CAP_HEADER_LOG_2                  (new_aer_cap_header_log_2)
    ,.new_AER_CAP_HEADER_LOG_3                  (new_aer_cap_header_log_3)
    ,.new_AER_CAP_TLP_PREFIX_LOG_0              (new_aer_cap_tlp_prefix_log_0)
    ,.new_AER_CAP_UNCORR_ERR_STATUS             (new_aer_cap_uncorr_err_status)
    ,.new_DEVICE_STATUS                         (new_device_status)
    ,.new_PCIE_CAP_DEVICE_STATUS                (new_pcie_cap_device_status)
    ,.new_REVISION_ID_CLASS_CODE                (new_revision_id_class_code)
    ,.new_HEADER_TYPE                           (pf_new_header_type)
    ,.new_PCIE_CAP                              (pf_new_pcie_cap)
    ,.new_PCIE_CAP_DEVICE_CAP_2                 (pf_new_pcie_cap_device_cap_2)

    ,.ack                                       (hqm_csr_pf0_ack_int)

    ,.ACS_CAP                                   (pf_acs_cap_nc)
    ,.ACS_CAP_CONTROL                           (pf_acs_cap_control_nc)
    ,.ACS_CAP_ID                                (pf_acs_cap_id_nc)
    ,.ACS_CAP_VERSION_NEXT_PTR                  (pf_acs_cap_version_next_ptr_nc)
    ,.ATS_CAP                                   (pf_ats_cap_nc)
    ,.ATS_CAP_CONTROL                           (pf_ats_cap_control)
    ,.ATS_CAP_ID                                (pf_ats_cap_id_nc)
    ,.ATS_CAP_VERSION_NEXT_PTR                  (pf_ats_cap_version_next_ptr_nc)
    ,.FUNC_BAR_L                                (func_bar_l)
    ,.FUNC_BAR_U                                (func_bar_u)
    ,.CACHE_LINE_SIZE                           (pf_cache_line_size_nc)
    ,.CAP_PTR                                   (pf_cap_ptr_nc)
    ,.PCIE_CAP_DEVICE_CAP_2                     (pf_pcie_cap_device_cap_2_nc)
    ,.PCIE_CAP_DEVICE_CONTROL_2                 (pcie_cap_device_control_2_nc)
    ,.PCIE_CAP_LINK_CAP                         (pcie_cap_link_cap_nc)
    ,.PCIE_CAP_LINK_CONTROL                     (pcie_cap_link_control_nc)
    ,.PCIE_CAP_LINK_STATUS                      (pcie_cap_link_status_nc)
    ,.DEVICE_ID                                 (pf_device_id_nc)
    ,.HEADER_TYPE                               (pf_header_type_nc)
    ,.INT_LINE                                  (pf_int_line_nc)
    ,.INT_PIN                                   (pf_int_pin_nc)
    ,.CSR_BAR_L                                 (csr_bar_l_nc)
    ,.CSR_BAR_U                                 (csr_bar_u)
    ,.MSIX_CAP_ID                               (pf_msix_cap_id_nc)
    ,.MSIX_CAP_CONTROL                          (msix_cap_control)
    ,.MSIX_CAP_NEXT_CAP_PTR                     (pf_msix_cap_next_cap_ptr_nc)
    ,.MSIX_CAP_PBA_OFFSET_BIR                   (msix_cap_pba_offset_bir_nc)
    ,.MSIX_CAP_TABLE_OFFSET_BIR                 (msix_cap_table_offset_bir_nc)
    ,.AER_CAP_CORR_ERR_MASK                     (aer_cap_corr_err_mask)
    ,.AER_CAP_CORR_ERR_STATUS                   (pf_aer_cap_corr_err_status_nc)
    ,.AER_CAP_CONTROL                           (aer_cap_control)
    ,.AER_CAP_HEADER_LOG_0                      (pf_aer_cap_header_log_0_nc)
    ,.AER_CAP_HEADER_LOG_1                      (pf_aer_cap_header_log_1_nc)
    ,.AER_CAP_HEADER_LOG_2                      (pf_aer_cap_header_log_2_nc)
    ,.AER_CAP_HEADER_LOG_3                      (pf_aer_cap_header_log_3_nc)
    ,.AER_CAP_TLP_PREFIX_LOG_0                  (pf_aer_cap_tlp_prefix_log_0_nc)
    ,.AER_CAP_TLP_PREFIX_LOG_1                  (pf_aer_cap_tlp_prefix_log_1_nc)
    ,.AER_CAP_TLP_PREFIX_LOG_2                  (pf_aer_cap_tlp_prefix_log_2_nc)
    ,.AER_CAP_TLP_PREFIX_LOG_3                  (pf_aer_cap_tlp_prefix_log_3_nc)
    ,.AER_CAP_UNCORR_ERR_MASK                   (aer_cap_uncorr_err_mask)
    ,.AER_CAP_UNCORR_ERR_STATUS                 (aer_cap_uncorr_err_status)
    ,.AER_CAP_UNCORR_ERR_SEV                    (aer_cap_uncorr_err_sev)
    ,.DEVICE_COMMAND                            (device_command)
    ,.PCIE_CAP_ID                               (pf_pcie_cap_id_nc)
    ,.AER_CAP_ID                                (pf_aer_cap_id_nc)
    ,.AER_CAP_VERSION_NEXT_PTR                  (pf_aer_cap_version_next_ptr_nc)
    ,.DEVICE_STATUS                             (device_status_nc)
    ,.PCIE_CAP_NEXT_CAP_PTR                     (pf_pcie_cap_next_cap_ptr_nc)
    ,.PCIE_CAP                                  (pf_pcie_cap_nc)
    ,.PCIE_CAP_DEVICE_CAP                       (pf_pcie_cap_device_cap_nc)
    ,.PCIE_CAP_DEVICE_CONTROL                   (pcie_cap_device_control)
    ,.PCIE_CAP_DEVICE_STATUS                    (pf_pcie_cap_device_status_nc)
    ,.PM_CAP                                    (pf_pm_cap_nc)
    ,.PM_CAP_ID                                 (pf_pm_cap_id_nc)
    ,.PM_CAP_NEXT_CAP_PTR                       (pf_pm_cap_next_cap_ptr_nc)
    ,.PM_CAP_CONTROL_STATUS                     (pm_cap_control_status)
    ,.REVISION_ID_CLASS_CODE                    (revision_id_class_code_nc)
    ,.SUBSYSTEM_ID                              (pf_subsystem_id_nc)
    ,.SUBSYSTEM_VENDOR_ID                       (subsystem_vendor_id)
    ,.VENDOR_ID                                 (pf_vendor_id_nc)

    ,.DVSEC_CAP_ID                              (dvsec_cap_id_nc)
    ,.DVSEC_CAP_VERSION_NEXT_PTR                (dvsec_cap_version_next_ptr_nc)
    ,.DVSEC_HDR1                                (dvsec_hdr1_nc)
    ,.DVSEC_HDR2                                (dvsec_hdr2_nc)

    ,.PASID_CAP                                 (pasid_cap_nc)
    ,.PASID_CAP_ID                              (pasid_cap_id_nc)
    ,.PASID_CAP_VERSION_NEXT_PTR                (pasid_cap_version_next_ptr_nc)
    ,.PASID_CONTROL                             (pasid_control)

    ,.SCIOV_CAP                                 (sciov_cap_nc)
    ,.SCIOV_IMS                                 (sciov_ims_nc)
    ,.SCIOV_SUPP_PGSZ                           (sciov_supp_pgsz_nc)
    ,.SCIOV_SYS_PGSZ                            (sciov_sys_pgsz_nc)

    ,.AER_CAP_ROOT_ERROR_COMMAND                (aer_cap_root_error_command_nc)
    ,.AER_CAP_ROOT_ERROR_STATUS                 (aer_cap_root_error_status_nc)
    ,.AER_CAP_ERROR_SOURCE_IDENT                (aer_cap_error_source_ident_nc)

); //    i_hqm_pf_cfg

assign ats_enabled = pf_ats_cap_control.ATSE;

hqm_AW_unused_bits i_pf_unused (   

    .a  (|{pf_acs_cap_nc
          ,pf_acs_cap_control_nc
          ,pf_acs_cap_id_nc
          ,pf_acs_cap_version_next_ptr_nc
          ,pf_ats_cap_nc
          ,pf_ats_cap_control.ATSSTU
          ,pf_ats_cap_id_nc
          ,pf_ats_cap_version_next_ptr_nc
          ,pf_cache_line_size_nc
          ,pf_cap_ptr_nc
          ,pf_pcie_cap_device_cap_2_nc
          ,pf_device_id_nc
          ,pf_header_type_nc
          ,pf_int_line_nc
          ,pf_int_pin_nc
          ,pf_msix_cap_id_nc
          ,pf_msix_cap_next_cap_ptr_nc
          ,pf_aer_cap_corr_err_status_nc
          ,pf_aer_cap_header_log_0_nc
          ,pf_aer_cap_header_log_1_nc
          ,pf_aer_cap_header_log_2_nc
          ,pf_aer_cap_header_log_3_nc
          ,pf_aer_cap_tlp_prefix_log_0_nc
          ,pf_aer_cap_tlp_prefix_log_1_nc
          ,pf_aer_cap_tlp_prefix_log_2_nc
          ,pf_aer_cap_tlp_prefix_log_3_nc
          ,pf_pcie_cap_id_nc
          ,pf_aer_cap_id_nc
          ,pf_aer_cap_version_next_ptr_nc
          ,pf_pcie_cap_next_cap_ptr_nc
          ,pf_pcie_cap_nc
          ,pf_pcie_cap_device_cap_nc
          ,pf_pcie_cap_device_status_nc
          ,pf_pm_cap_nc
          ,pf_pm_cap_id_nc
          ,pf_pm_cap_next_cap_ptr_nc
          ,pf_subsystem_id_nc
          ,pf_vendor_id_nc
          ,pcie_cap_device_control.MRS
          ,dvsec_cap_id_nc
          ,dvsec_cap_version_next_ptr_nc
          ,dvsec_hdr1_nc
          ,dvsec_hdr2_nc
          ,pasid_cap_nc
          ,pasid_cap_id_nc
          ,pasid_cap_version_next_ptr_nc
          ,pasid_control.PRIV_MODE_ENABLE
          ,pasid_control.EXEC_PERM_ENABLE
          ,sciov_cap_nc
          ,sciov_ims_nc
          ,sciov_supp_pgsz_nc
          ,sciov_sys_pgsz_nc
          ,pcie_cap_link_cap_nc
          ,pcie_cap_link_control_nc
          ,pcie_cap_link_status_nc
          ,aer_cap_root_error_command_nc
          ,aer_cap_root_error_status_nc
          ,aer_cap_error_source_ident_nc
          ,msix_cap_pba_offset_bir_nc
          ,msix_cap_table_offset_bir_nc
          ,device_status_nc
          ,pcie_cap_device_control_2_nc
          ,revision_id_class_code_nc
        })
);

always_comb begin: csr_out_assign_p

 if (flr_treatment_vec) begin
   csr_pf_bar  = '0;
   func_pf_bar = '0;
 end else begin
   csr_pf_bar  = {csr_bar_u, 32'h0};
   func_pf_bar = {func_bar_u.ADDR, func_bar_l.ADDR_L, 26'h0};    // size of RAM is 64MB
 end

end // always_comb csr_out_assign_p

// DC is having issues with the buffering due to the fan out of csr_rd_offset.

// ------------------------------------------------------------------------
// Vector Control Outputs for Readability
// ------------------------------------------------------------------------
always_comb begin: control_vec_out_p

    // MSIX Enable Control Output for all Physical Functions.
    csr_pmsixctl_msie_wxp = msix_cap_control.MSIXEN & ~flr_treatment_vec;

    // MSIX Function Mask Control Output for all Physical Functions.
    csr_pmsixctl_fm_wxp = msix_cap_control.FM & ~flr_treatment_vec;

end // always_comb control_vec_out_p

// ------------------------------------------------------------------------
// GIGE Function Level Reset
// ------------------------------------------------------------------------
always_comb begin: csr_pdctl_flr_p

    csr_pdc_start_flr = pcie_cap_device_control.STARTFLR & ~flr_treatment_vec;

end // always_comb csr_pdctl_flr_p

// ------------------------------------------------------------------------
// Bus master enable
// ------------------------------------------------------------------------
always_comb begin: ri_bme_p

    ri_bme_rxl = device_command.BM & ~flr_treatment_vec;

end // always ri_bme_p

// ------------------------------------------------------------------------
// Uncorrectable Error Mask
// ------------------------------------------------------------------------
always_comb begin: csr_ppaerucm_p
    csr_ppaerucm_wp.ieunc = aer_cap_uncorr_err_mask.IEUNC;   // reset=1
    csr_ppaerucm_wp.ur    = aer_cap_uncorr_err_mask.UR;
    csr_ppaerucm_wp.ecrcc = aer_cap_uncorr_err_mask.ECRCC;
    csr_ppaerucm_wp.mtlp  = aer_cap_uncorr_err_mask.MTLP;
    csr_ppaerucm_wp.ro    = aer_cap_uncorr_err_mask.RO;
    csr_ppaerucm_wp.ec    = aer_cap_uncorr_err_mask.EC;
    csr_ppaerucm_wp.ca    = aer_cap_uncorr_err_mask.CA;
    csr_ppaerucm_wp.ct    = aer_cap_uncorr_err_mask.CT;
    csr_ppaerucm_wp.fcpes = aer_cap_uncorr_err_mask.FCPES;
    csr_ppaerucm_wp.ptlpr = aer_cap_uncorr_err_mask.PTLPR;
    csr_ppaerucm_wp.dlpe  = aer_cap_uncorr_err_mask.DLPE;
end // always_comb csr_ppaerucm_p

// ------------------------------------------------------------------------
// Device Command Register Error Control
// ------------------------------------------------------------------------
always_comb begin: csr_pcicmd_p
    csr_pcicmd_wp.ser = ~flr_treatment_vec & device_command.SER;
    csr_pcicmd_wp.per = ~flr_treatment_vec & device_command.PER;
end // always_comb csr_pcicmd_p

// ------------------------------------------------------------------------
// Ordering enable bits
// ------------------------------------------------------------------------
always_comb begin: csr_ppdcntl_ordering_p
  csr_ppdcntl_ero   =  flr_treatment_vec | pcie_cap_device_control.ERO;          // Enable Relaxed Ordering reset=1
end

// ------------------------------------------------------------------------
// Device Error Control Register
// ------------------------------------------------------------------------
always_comb begin: csr_ppdcntl_p
    csr_ppdcntl_wp.ero  =  flr_treatment_vec | pcie_cap_device_control.ERO;   // reset=1
    csr_ppdcntl_wp.urro = ~flr_treatment_vec & pcie_cap_device_control.URRO;
    csr_ppdcntl_wp.fere = ~flr_treatment_vec & pcie_cap_device_control.FERE;
    csr_ppdcntl_wp.nere = ~flr_treatment_vec & pcie_cap_device_control.NERE;
    csr_ppdcntl_wp.cere = ~flr_treatment_vec & pcie_cap_device_control.CERE;
    csr_ppdcntl_wp.ens  =  flr_treatment_vec | pcie_cap_device_control.ENS;   // reset=1
end // always_comb csr_ppdcntl_p

// ------------------------------------------------------------------------
// AER Correctable Mask
// ------------------------------------------------------------------------
always_comb begin: csr_ppaercm_p
    // HQM version
    csr_ppaercm_wp.anfes  = aer_cap_corr_err_mask.ANFES; // reset=1
    csr_ppaercm_wp.rtts   = aer_cap_corr_err_mask.RTTS;
    csr_ppaercm_wp.rnrs   = aer_cap_corr_err_mask.RNRS;
    csr_ppaercm_wp.bdllps = aer_cap_corr_err_mask.BDLLPS;
    csr_ppaercm_wp.dlpe   = aer_cap_corr_err_mask.DLPE;
    csr_ppaercm_wp.res    = aer_cap_corr_err_mask.RES;
    csr_ppaercm_wp.iecor  = aer_cap_corr_err_mask.IECOR; // reset=1
end // always_comb csr_ppaercm_p

// ------------------------------------------------------------------------
// AER Control Capabilities
// ------------------------------------------------------------------------
always_comb begin: csr_ppaerctlcap_p

    csr_ppaerctlcap_wp.rnrs      = aer_cap_control.ECRCCE;
    csr_ppaerctlcap_wp.bdllps    = aer_cap_control.ECRCCC;
    csr_ppaerctlcap_wp.dlpe      = aer_cap_control.ECRCGE;
    csr_ppaerctlcap_wp.ecrcgc    = aer_cap_control.ECRCGC;
    csr_ppaerctlcap_wp.ecrccc    = aer_cap_control.ECRCCC;
    csr_ppaerctlcap_wp.ecrcce    = aer_cap_control.ECRCCE;

end // always_comb csr_ppaerctlcap_p

// ------------------------------------------------------------------------
// AER Uncorrectable Error Severity
// ------------------------------------------------------------------------
always_comb begin: csr_ppaerucsev_p
    csr_ppaerucsev.ieunc         = aer_cap_uncorr_err_sev.IEUNC; // reset=1
    csr_ppaerucsev.ur            = aer_cap_uncorr_err_sev.UR;
    csr_ppaerucsev.ecrcc         = aer_cap_uncorr_err_sev.ECRCC;
    csr_ppaerucsev.mtlp          = aer_cap_uncorr_err_sev.MTLP;  // reset=1
    csr_ppaerucsev.ro            = aer_cap_uncorr_err_sev.RO;    // reset=1
    csr_ppaerucsev.ec            = aer_cap_uncorr_err_sev.EC;
    csr_ppaerucsev.ca            = aer_cap_uncorr_err_sev.CA;
    csr_ppaerucsev.ct            = aer_cap_uncorr_err_sev.CT;
    csr_ppaerucsev.fcpes         = aer_cap_uncorr_err_sev.FCPES; // reset=1
    csr_ppaerucsev.ptlpr         = aer_cap_uncorr_err_sev.PTLPR;
    csr_ppaerucsev.dlpe          = aer_cap_uncorr_err_sev.DLPE;  // reset=1
end // always csr_ppaerucsev_p

//-----------------------------------------------------------------
// Check for FLR write - DCN 90006 - FLR to be tied to secondary bus reset
//-----------------------------------------------------------------

// Need to flag when setting the startflr bit so we can track when we send out the completion for this
// write on the IOSF bus.  Need to hold off actually doing the FLR until the completion has been sent
// so the transaction is completed before we nuke the state that would send the completion.

assign flr_function0 = hqm_csr_pf0_req.valid & hqm_csr_pf0_req.opcode[0] & ~flr_treatment_vec &
                       (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
                        hqm_pf_cfg_pkg::PCIE_CAP_DEVICE_CONTROL_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]) &
                       (hqm_csr_pf0_req.be[1]    == 1'b1) &     // FLR is bit 15, so BE[1]==1 is needed
                       (hqm_csr_pf0_req.data[15] == 1'b1);      // FLR is bit 15, so data[15]==1 is needed

// Need to flag when changing the power state from D0 -> D3 so we can track when we send out the completion
// for this write on the IOSF bus.  Need to hold off actually doing the power state transition until after
// we send out the completion so we ensure that the pipe is flushed of previous transactions that may have
// been pending in the TI.  Don't want the subsequent hqm reset assertion to potentially nuke the push
// side logic of the dual clock FIFOs when there would still be work for the pop side to do.

assign ps_d0_to_d3   = hqm_csr_pf0_req.valid & hqm_csr_pf0_req.opcode[0] & ~flr_treatment_vec &
                       (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
                        hqm_pf_cfg_pkg::PM_CAP_CONTROL_STATUS_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]) &
                       (hqm_csr_pf0_req.be[0]     == 1'b1)  &   // PS is bits[1:0], so BE[0]==1 is needed
                       (hqm_csr_pf0_req.data[1:0] == 2'b11) &   // PS is bits[1:0], so data[1:0]==3 is needed
                       (pm_state                  == PM_FSM_D0ACT);

//-----------------------------------------------------------------
// Check for zero length access to PF registers
//-----------------------------------------------------------------
assign pf_block_zero_length_acc     = hqm_csr_pf0_req.valid & (hqm_csr_pf0_req.be == '0);

//-----------------------------------------------------------------
// Check for access to link registers when strap_hqm_is_reg_ep is 0
//-----------------------------------------------------------------
always_comb begin: pf_block_link_reg_acc_p
  pf_block_link_reg_acc      =  (~strap_hqm_is_reg_ep) &
                                hqm_csr_pf0_req.valid &
                                ( (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] == hqm_pf_cfg_pkg::PCIE_CAP_LINK_CAP_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]) ||
                                  (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] == hqm_pf_cfg_pkg::PCIE_CAP_LINK_CONTROL_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]) ||
                                  (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] == hqm_pf_cfg_pkg::PCIE_CAP_LINK_STATUS_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2])
                                );
end // pf_block_link_reg_acc_p

// ------------------------------------------------------------------------
// PCISTS Clear Detect
// ------------------------------------------------------------------------
always_comb begin: csr_pcists_clr_p

    // The RW1C bits in this CSR are cleared with a write of one
    // to the individual field. Here we detect all writes of one for
    // each bit in the CSR for each function. This information is
    // passed to the error FUB and used to clear the status
    // of a given error.
    // CPM1.75 - updated to add byte enables to data so it only gets cleared if
    // PCISTS is the target (not PPCICMD)

    csr_pcists_clr = {(hqm_csr_pf0_req.data[31:24] &
                         {8{hqm_csr_pf0_req.be[3]}}),
                         {(hqm_csr_pf0_req.data[23:16] & {8{hqm_csr_pf0_req.be[2]}})},
                         16'b0} &
                        {`HQM_CSR_SIZE{hqm_csr_pf0_req.valid & ~flr_treatment_vec &
                         (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
                          hqm_pf_cfg_pkg::DEVICE_STATUS_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2])}};

end // always_comb csr_pcistst_clr_p

// ------------------------------------------------------------------------
// PPAERUCS Clear Detect
// ------------------------------------------------------------------------
always_comb begin: csr_ppaerucs_clr_p

    // The RW1C bits in this CSR are cleared with a write of one
    // to the individual field. Here we detect all writes of one for
    // each bit in the CSR for each function. This information is
    // passed to the error FUB and used to clear the status
    // of a given error.

    csr_ppaerucs_clr = { {(hqm_csr_pf0_req.data[31:24] & {8{hqm_csr_pf0_req.be[3]}})},
                            {(hqm_csr_pf0_req.data[23:16] & {8{hqm_csr_pf0_req.be[2]}})},
                            {(hqm_csr_pf0_req.data[15:8]  & {8{hqm_csr_pf0_req.be[1]}})},
                            {(hqm_csr_pf0_req.data[7:0]   & {8{hqm_csr_pf0_req.be[0]}})}
                          } &
                          {`HQM_CSR_SIZE{hqm_csr_pf0_req.valid & ~flr_treatment_vec &
                                        (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
                                         hqm_pf_cfg_pkg::AER_CAP_UNCORR_ERR_STATUS_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2])
                          }};

end // always_comb csr_ppaerucs_clr_p

// ------------------------------------------------------------------------
// PPAERCS Clear Detect
// ------------------------------------------------------------------------
always_comb begin: csr_ppaercs_clr_p

    // The RW1C bits in this CSR are cleared with a write of one
    // to the individual field. Here we detect all writes of one for
    // each bit in the CSR for each function. This information is
    // passed to the error FUB and used to clear the status
    // of a given error.

    csr_ppaercs_clr = { {(hqm_csr_pf0_req.data[31:24] & {8{hqm_csr_pf0_req.be[3]}})},
                           {(hqm_csr_pf0_req.data[23:16] & {8{hqm_csr_pf0_req.be[2]}})},
                           {(hqm_csr_pf0_req.data[15:8]  & {8{hqm_csr_pf0_req.be[1]}})},
                           {(hqm_csr_pf0_req.data[7:0]   & {8{hqm_csr_pf0_req.be[0]}})}
                         } &
                         {`HQM_CSR_SIZE{hqm_csr_pf0_req.valid & ~flr_treatment_vec &
                                       (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
                                        hqm_pf_cfg_pkg::AER_CAP_CORR_ERR_STATUS_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2])
                         }};

end // always_comb csr_ppaercs_clr_p

// ------------------------------------------------------------------------
// Error Status Inputs to AER uncorrectable Error CSR's
// ------------------------------------------------------------------------
always_comb begin: csr_ppaerucs_p

    // PF0 Error Status to CSR's
    // PPAERUCS load signals
    load_aer_cap_uncorr_err_status.UR    = csr_ppaerucs.ur    & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.ECRCC = csr_ppaerucs.ecrcc & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.MTLP  = csr_ppaerucs.mtlp  & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.EC    = csr_ppaerucs.ec    & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.CA    = csr_ppaerucs.ca    & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.CT    = csr_ppaerucs.ct    & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.IEUNC = csr_ppaerucs.ieunc & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_uncorr_err_status.PTLPR = csr_ppaerucs.ptlpr & ~quiesce_qualifier & ~flr_treatment_vec;

    // PPAERUCS new signals
    new_aer_cap_uncorr_err_status.UR     = 1'b1;
    new_aer_cap_uncorr_err_status.ECRCC  = 1'b1;
    new_aer_cap_uncorr_err_status.MTLP   = 1'b1;
    new_aer_cap_uncorr_err_status.EC     = 1'b1;
    new_aer_cap_uncorr_err_status.CA     = 1'b1;
    new_aer_cap_uncorr_err_status.CT     = 1'b1;
    new_aer_cap_uncorr_err_status.PTLPR  = 1'b1;
    new_aer_cap_uncorr_err_status.IEUNC  = 1'b1;

    // PPAERCS load signals
    load_aer_cap_corr_err_status.ANFES   = csr_ppaercs.anfes & ~quiesce_qualifier & ~flr_treatment_vec;
    load_aer_cap_corr_err_status.IECOR   = csr_ppaercs.iecor & ~quiesce_qualifier & ~flr_treatment_vec;
    // PPAERCS new signals
    new_aer_cap_corr_err_status.ANFES    = 1'b1;
    new_aer_cap_corr_err_status.IECOR    = 1'b1;

    csr_ppaerucs_c.ieunc = aer_cap_uncorr_err_status.IEUNC;
    csr_ppaerucs_c.ur    = aer_cap_uncorr_err_status.UR;
    csr_ppaerucs_c.ecrcc = aer_cap_uncorr_err_status.ECRCC;
    csr_ppaerucs_c.mtlp  = aer_cap_uncorr_err_status.MTLP;
    csr_ppaerucs_c.ro    = aer_cap_uncorr_err_status.RO;
    csr_ppaerucs_c.ec    = aer_cap_uncorr_err_status.EC;
    csr_ppaerucs_c.ca    = aer_cap_uncorr_err_status.CA;
    csr_ppaerucs_c.ct    = aer_cap_uncorr_err_status.CT;
    csr_ppaerucs_c.fcpes = aer_cap_uncorr_err_status.FCPES;
    csr_ppaerucs_c.ptlpr = aer_cap_uncorr_err_status.PTLPR;
    csr_ppaerucs_c.dlpe  = aer_cap_uncorr_err_status.DLPE;

end // always_comb csr_ppaerucs_p

// ------------------------------------------------------------------------
// PCICMD CSR
// ------------------------------------------------------------------------
always_comb begin: csr_pcicmd_mem_p

    csr_pcicmd_mem = device_command.MEM & ~flr_treatment_vec;
    csr_pcicmd_io  = device_command.IO  & ~flr_treatment_vec;

end // always_comb csr_pcicmd_mem_p

// ------------------------------------------------------------------------
// Flop PCISTS CSRs to create edge detect since it comes from a flop
// ------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pcists_edge_det_f

    // A simple shift counter which is used to stall the completions
    // of the write to the PPMCSR CSR. CSR_PPMCSR_DLY controls the
    // number of clocks we wait after the write is initiated.
    if(!prim_gated_rst_b) begin

        csr_pcists_f.dpe   <= '0;
        csr_pcists_f.sse   <= '0;
        csr_pcists_f.rma   <= '0;
        csr_pcists_f.rta   <= '0;
        csr_pcists_f.sta   <= '0;
        csr_pcists_f.mdpe  <= '0;

    end else begin

        csr_pcists_f.dpe   <= csr_pcists.dpe;
        csr_pcists_f.sse   <= csr_pcists.sse;
        csr_pcists_f.rma   <= csr_pcists.rma;
        csr_pcists_f.rta   <= csr_pcists.rta;
        csr_pcists_f.sta   <= csr_pcists.sta;
        csr_pcists_f.mdpe  <= csr_pcists.mdpe;

    end

end // pcists_edge_det_f

// ------------------------------------------------------------------------
// Error Status for PCISTS CSRs
// ------------------------------------------------------------------------
always_comb begin: csr_pcists_p

    // HQM version
    // load signals
    load_device_status.DPE = csr_pcists.dpe && !(csr_pcists_f.dpe);
    load_device_status.SSE = csr_pcists.sse && !(csr_pcists_f.sse);
    load_device_status.RMA = csr_pcists.rma && !(csr_pcists_f.rma);
    load_device_status.RTA = csr_pcists.rta && !(csr_pcists_f.rta);
    load_device_status.STA = csr_pcists.sta && !(csr_pcists_f.sta);
    load_device_status.MDPE = csr_pcists.mdpe && !(csr_pcists_f.mdpe);
    new_device_status.INTSTS = '0;
    // new signals
    new_device_status.DPE = 1'b1;
    new_device_status.SSE = 1'b1;
    new_device_status.RMA = 1'b1;
    new_device_status.RTA = 1'b1;
    new_device_status.STA = 1'b1;
    new_device_status.MDPE = 1'b1;

end // always_comb

// ------------------------------------------------------------------------
// Maximum Payload Size
// The MPS value maybe programmed to any of the supported sizes: 128B-2048B,
// but the only values presented to TI will be 128B or 256B.
//
// jbdiethe: With the removal of the fuse Straps RSVD 111 for this register
// means 64B mode
// ------------------------------------------------------------------------
always_comb begin: csr_ppdcntl_mps_p

    ri_mps_rxp =  (flr_treatment_vec) ? '0 :
                  (pcie_cap_device_control.MPS== 3'b111) ?  3'b111 :
                   {1'b0,pcie_cap_device_control.MPS[1:0]};

end // always_comb csr_ppdcntl_mps_p

// ------------------------------------------------------------------------
// Power Management Write Detect
// ------------------------------------------------------------------------
always_comb begin: ppmcsr_wr_p

    // When a write to PPMCSR.PS is executed, the power state of the EP is
    // changed. This takes several clocks for the CSR write to execute and
    // then the power management status to propogate out to the PM state
    // machine and the power state to be updated. The outbound completion
    // generated from an update to the power state must have the power
    // state status of the CSR after the write is executed. This requires
    // that the CSR write must stall until the power management state is
    // updated before sending out the OBC. Here we detect the write to PPMCSR
    ppmcsr_wr = hqm_csr_pf0_req.valid &&
                (hqm_csr_pf0_req.addr.cfg.offset[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] == hqm_pf_cfg_pkg::PM_CAP_CONTROL_STATUS_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]);

end // always_comb ppmcsr_wr_p

// ------------------------------------------------------------------------
// PPMCSR Write Stall
// ------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: ppmcsr_wr_dly_p

    // A simple shift counter which is used to stall the completions
    // of the write to the PPMCSR CSR. CSR_PPMCSR_DLY controls the
    // number of clocks we wait after the write is initiated.
    if(!prim_gated_rst_b)
        ppmcsr_wr_dly <= '0;
    else if(ppmcsr_wr)
        ppmcsr_wr_dly <= {`HQM_CSR_PPMCSR_DLY{1'b1}};
    else if(|ppmcsr_wr_dly)
        ppmcsr_wr_dly <= {1'b0, ppmcsr_wr_dly[`HQM_CSR_PPMCSR_DLY-1:1]};
    else
        ppmcsr_wr_dly <= ppmcsr_wr_dly;

end // always_ff ppmcsr_wr_dly_p

// ------------------------------------------------------------------------
// PPMCSR Write Stall
// ------------------------------------------------------------------------
always_comb begin: ppmcsr_wr_stall_p

    // After a write to the PPMCSR register, we must stall the OBC so that
    // the write status has time to update the power management state machine
    // thus allowing the power state status in the OBC header to reflect
    // the power state AFTER the completion of the CSR write. Also, in the event
    // that there were any legacy interrupts asserted, they must be de-asserted,
    // and a de-assert message sent before the CSR write completion
    ppmcsr_wr_stall = (|{ppmcsr_wr_dly, pm_deassert_intx});

end // always_comb ppmcsr_wr_stall_p

// ------------------------------------------------------------------------
// Flopped PPDSTAT Logic for EDGE Detect
// ------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_vec_ff_p

    if(!prim_gated_rst_b) begin
        err_urd_vec_ff <= '0;
        err_fed_vec_ff <= '0;
        err_ned_vec_ff <= '0;
        err_ced_vec_ff <= '0;
    end else begin
        err_urd_vec_ff <= err_urd_vec;
        err_fed_vec_ff <= err_fed_vec;
        err_ned_vec_ff <= err_ned_vec;
        err_ced_vec_ff <= err_ced_vec;
    end // if not reset

end // always_ff err_vec_ff_p


// ------------------------------------------------------------------------
// CSR PPDSTAT Unsupported Request Status
// ------------------------------------------------------------------------
always_comb begin: csr_ppdstat_urd_p

    // For each function, set the PPDSTAT URD status input when an error
    // is detected for the function.
    if(err_urd_vec && !err_urd_vec_ff)
        csr_ppdstat_urd_s = 1'b1;
    else
        // HSD 4727842 - don't need to loop back values, RW1C works correctly
        csr_ppdstat_urd_s = 1'b0;        // csr_ppdstat_urd_c[i];

end // alway_comb csr_ppdstat_urd_p

// ------------------------------------------------------------------------
// CSR PPDSTAT Fatal Error Status
// ------------------------------------------------------------------------
always_comb begin: csr_ppdstat_fed_p

    // For each function, set the PPDSTAT fatal error status input when an error
    // is detected for the function.
    if(err_fed_vec && !err_fed_vec_ff)
        csr_ppdstat_fed_s = 1'b1;
    else
        // HSD 4727842 - don't need to loop back values, RW1C works correctly
        csr_ppdstat_fed_s = 1'b0;        // csr_ppdstat_fed_c[i];

end // alway_comb csr_ppdstat_fed_p

// ------------------------------------------------------------------------
// CSR PPDSTAT Non-Fatal Error Status
// ------------------------------------------------------------------------
always_comb begin: csr_ppdstat_ned_p

    // For each function, set the PPDSTAT non-fatal error status input when an error
    // is detected for the function.
    if(err_ned_vec && !err_ned_vec_ff)
        csr_ppdstat_ned_s = 1'b1;
    else
        // HSD 4727842 - don't need to loop back values, RW1C works correctly
        csr_ppdstat_ned_s = 1'b0;        // csr_ppdstat_ned_c[i];

end // alway_comb csr_ppdstat_ned_p

// ------------------------------------------------------------------------
// CSR PPDSTAT Correctable Error Status
// ------------------------------------------------------------------------
always_comb begin: csr_ppdstat_ced_p
    // For each function, set the PPDSTAT correctable error status input when an error
    // is detected for the function.
    if(err_ced_vec && !err_ced_vec_ff)
        csr_ppdstat_ced_s = 1'b1;
    else
        // HSD 4727842 - don't need to loop back values, RW1C works correctly
        csr_ppdstat_ced_s = 1'b0;        // csr_ppdstat_ced_c[i];

end // always_ff csr_ppdstat_ced_p

// ------------------------------------------------------------------------
// Alternative requester ID and SRIOV enable
// ------------------------------------------------------------------------
always_comb begin: csr_pasid_enable_p

    csr_pasid_enable = pasid_control.PASID_ENABLE & ~flr_treatment_vec;

end // always_comb csr_pasid_enable_p

// ------------------------------------------------------------------------
// PPD STATUS CSR Status
// ------------------------------------------------------------------------
always_comb begin: ppdstat_sts_p

    // HSD 4727842 - PFIEERRUNCSTSR not cleared by writing all 1's.  Need to fix load and new signals.
    // HQM version of signals
    // load signals
    load_pcie_cap_device_status.URD = csr_ppdstat_urd_s;
    load_pcie_cap_device_status.FED = csr_ppdstat_fed_s;
    load_pcie_cap_device_status.NED = csr_ppdstat_ned_s;
    load_pcie_cap_device_status.CED = csr_ppdstat_ced_s;
    // new signals
    new_pcie_cap_device_status.URD  = 1'b1;
    new_pcie_cap_device_status.FED  = 1'b1;
    new_pcie_cap_device_status.NED  = 1'b1;
    new_pcie_cap_device_status.CED  = 1'b1;

end // always_comb ppdstat_sts_p


// ------------------------------------------------------------------------
// TRANSACTION PENDING
// ------------------------------------------------------------------------
always_comb begin: ppdstat_tp_p

    new_pcie_cap_device_status.TP = np_trans_pending;
end

assign device_id_in      = strap_hqm_device_id;
assign revision_id_in    = revision_id_fuses;

//------------------------------------------------------------------------
// FIRST ERROR POINTER: Binary to Decimal index decoder
// Identifies per function bit position of error reported from PPAERUCS
// with priority MUX as per from PCIe SPEC
// ------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge hqm_csr_pf0_pwr_rst_n) begin : csr_pprctlcp_ferrp0_p

  if (~hqm_csr_pf0_pwr_rst_n) begin

    csr_ppaerucs_c_rxp       <= '0;
    csr_ppaerctlcap_ferrp_rp <= '0;

  // Protect loading of PF sticky regs during ResetPrep or PF FLR

  end else if (~quiesce_qualifier & ~flr_treatment_vec) begin

    csr_ppaerucs_c_rxp       <= csr_ppaerucs_c;

    // For each function, set the First Error Pointer when a rising edge of a
    // new unmasked error is detected for the function and it is the first
    // unmasked error.
    // Clear the first Error pointer when PPAERUCS has been cleared.

    if (((csr_ppaerucs_c     & ~csr_ppaerucm_wp) != '0) &
        ((csr_ppaerucs_c_rxp & ~csr_ppaerucm_wp) == '0)) begin

      // Use same priority as the err_log_hdr in ri_err

           if (csr_ppaerucs_c.ct    && !csr_ppaerucm_wp.ct)    csr_ppaerctlcap_ferrp_rp <= 5'b01110;
      else if (csr_ppaerucs_c.ro    && !csr_ppaerucm_wp.ro)    csr_ppaerctlcap_ferrp_rp <= 5'b10001;
      else if (csr_ppaerucs_c.fcpes && !csr_ppaerucm_wp.fcpes) csr_ppaerctlcap_ferrp_rp <= 5'b01101;
      else if (csr_ppaerucs_c.dlpe  && !csr_ppaerucm_wp.dlpe)  csr_ppaerctlcap_ferrp_rp <= 5'b00100;
      else if (csr_ppaerucs_c.ecrcc && !csr_ppaerucm_wp.ecrcc) csr_ppaerctlcap_ferrp_rp <= 5'b10011;
      else if (csr_ppaerucs_c.mtlp  && !csr_ppaerucm_wp.mtlp)  csr_ppaerctlcap_ferrp_rp <= 5'b10010;
      else if (csr_ppaerucs_c.ur    && !csr_ppaerucm_wp.ur)    csr_ppaerctlcap_ferrp_rp <= 5'b10100;
      else if (csr_ppaerucs_c.ca    && !csr_ppaerucm_wp.ca)    csr_ppaerctlcap_ferrp_rp <= 5'b01111;
      else if (csr_ppaerucs_c.ec    && !csr_ppaerucm_wp.ec)    csr_ppaerctlcap_ferrp_rp <= 5'b10000;
      else if (csr_ppaerucs_c.ptlpr && !csr_ppaerucm_wp.ptlpr) csr_ppaerctlcap_ferrp_rp <= 5'b01100;
      else if (csr_ppaerucs_c.ieunc && !csr_ppaerucm_wp.ieunc) csr_ppaerctlcap_ferrp_rp <= 5'b10110;

    end else if ((csr_ppaerucs_c == '0) & (|csr_ppaerctlcap_ferrp_rp)) begin

      // HSD 5314996/5315019 - TFEP can't be cleared
      // When PPAERUCS is cleared, Reset the First Error Pointer

      csr_ppaerctlcap_ferrp_rp <= '0;

    end

  end

end // always_ff // csr_pprctlcp_ferrp0_p

//------------------------------------------------------------------------
// SRDL based signal reassignments
// -----------------------------------------------------------------------
always_comb begin: hqm_signals

    // added eas 0.82 - signal needs to be controllable

    new_aer_cap_control.TFEP                = csr_ppaerctlcap_ferrp_rp;
    new_aer_cap_control.TLPPFLOGP           = csr_pf0_ppaertlppflog0.fmt2;

    pf_new_header_type.MFD                  = '0;

    pf_new_pcie_cap.DPT                     = strap_hqm_is_reg_ep ? 4'b0000 : 4'b1001;

    csr_pf0_ppmcsr_ps_c                     = (flr_treatment_vec) ? '0 : pm_cap_control_status.PS;    // PF0 power management state

    new_aer_cap_header_log_0.HDRLOGDW0      = csr_pf0_ppaerhdrlog0_hdrlogdw0_s;
    new_aer_cap_header_log_1.HDRLOGDW1      = csr_pf0_ppaerhdrlog1_hdrlogdw1_s;
    new_aer_cap_header_log_2.HDRLOGDW2      = csr_pf0_ppaerhdrlog2_hdrlogdw2_s;
    new_aer_cap_header_log_3.HDRLOGDW3      = csr_pf0_ppaerhdrlog3_hdrlogdw3_s;

    new_aer_cap_tlp_prefix_log_0.TLPPFLOG0  = {{csr_pf0_ppaertlppflog0.fmt2                             // Byte 0
                                               ,2'd0
                                               ,csr_pf0_ppaertlppflog0.fmt2
                                               ,3'd0
                                               ,csr_pf0_ppaertlppflog0.fmt2}
                                              ,{csr_pf0_ppaertlppflog0.pm_req                           // Byte 1
                                               ,csr_pf0_ppaertlppflog0.exe_req
                                               ,2'd0
                                               ,csr_pf0_ppaertlppflog0.pasid[19:16]}
                                              , csr_pf0_ppaertlppflog0.pasid[15:8]                      // Byte 2
                                              , csr_pf0_ppaertlppflog0.pasid[ 7:0]                      // Byte 3
                                              };

    new_device_id.DID                               = device_id_in;
    {new_revision_id_class_code.RIDU,
     new_revision_id_class_code.RIDL}               = revision_id_in;

end

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Assertions
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// PROTOS & COVERAGE
//-------------------------------------------------------------------------
// - Hot reset when there are pending CSR reads/writes (Execute reset
//   with pending CSR reads/writes, come out of reset and successfully
//   execute a CSR read/write); !prim_gated_rst_b &
//   ri.ri_lli_ctl.csr_wr_wp, csr_read_wp (w/  csr_mem_mapped_wp=1/0, and
//   all functions; csr_wr_func_wxp, csr_rd_rund_wxp), iosf_csr_cmd_blk,
//   ri.ri_int.msix_tbl_wr, msix_tbl_rd.
// - FLR reset when there are pending CSR reads/writes (Execute reset
//   with pending CSR reads/writes, come out of reset and successfully
//   execute a CSR read/write); !ri_flr_rxp &
//   ri.ri_lli_ctl.csr_wr_wp, csr_read_wp (w/  csr_mem_mapped_wp=1/0, and
//   all functions; csr_wr_func_wxp, csr_rd_rund_wxp), iosf_csr_cmd_blk,
//   ri.ri_int.msix_tbl_wr, msix_tbl_rd.
// - Verify that after an FLR to each of the functions that the funtions
//   is put back into the pf*_pm_state=D0ACT and that the following
//   events to the given function are executed; csr_wr_wxp, csr_rd_wxp,
//   csr_cb_stall, csr_vf_write_wp, csr_mm_write, csr_pf_write, msi_cmd_req,
//   intx_req, int2me_req

endmodule // hqm_ri_pf_vf_cfg

