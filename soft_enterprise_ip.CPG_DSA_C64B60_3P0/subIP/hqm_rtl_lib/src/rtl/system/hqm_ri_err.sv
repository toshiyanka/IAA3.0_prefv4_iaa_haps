// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_err
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Wednesday Oct 21, 2009
// -- Description :
// -- The Error FUB (hqm_ri_err) is responsible for collecting and collating
// -- all the error signals in the receive interface and direct them
// -- to the appropriate error status register as well as signaling
// -- when a message should be sent due to an error.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_err

  import hqm_AW_pkg::*, hqm_sif_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*;

(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic                   prim_nonflr_clk
    ,input  logic                   prim_gated_rst_b

    ,input  logic                   hard_rst_np                     // Hard CSR reset
    ,input  logic                   soft_rst_np                     // Soft CSR reset
    ,input  logic                   quiesce_qualifier   
    ,input  logic                   flr_treatment_vec               // FLR qualifier
    ,input  logic [7:0]             current_bus                     

    //-----------------------------------------------------------------
    // Inputs
    //-----------------------------------------------------------------

    // Command Scheduling

    ,input  logic                   cds_err_msg_gnt                 // Error message scheduled
    ,input  cbd_hdr_t               cds_err_hdr                     // Header of transaction that generated
                                                                    // an error in command/decode & schedule

    // Error Source Signals

    ,input  logic                   cds_npusr_err_wp                // Non posted unsupported request detection
    ,input  logic                   cds_pusr_err_wp                 // Posted unsupported request detection
    ,input  logic                   cds_usr_in_cpl                  // Unsupported request that generated a completion
    ,input  logic                   cds_cfg_usr_func                // Unsupported function detection
    ,input  logic                   cds_bar_decode_err_wp           // Address did not hit a valid BAR
    ,input  logic                   lli_cpar_err_wp                 // Cmd Hdr parity error detected
    ,input  logic                   lli_tecrc_err_wp                // HSD 4727748 - add support for TECRC error
    ,input  errhdr_t                lli_chdr_w_err_wp
    ,input  logic                   poisoned_wr_sent                // HSD 5314547 - MDPE not getting set when CPM receives poison completion
    ,input  logic                   cds_poison_err_wp               // Config transaction poisoned
    ,input  logic                   cds_malform_pkt                 // Malformed packet

    ,input  logic                   cpl_poisoned                    // Completion poisoned
    ,input  logic                   cpl_unexpected                  // Unexpected completion
    ,input  tdl_cplhdr_t            cpl_error_hdr                          

    ,input  logic                   cpl_timeout                     // Completion timeout
    ,input  logic [8:0]             cpl_timeout_synd                // Completion timeout syndrome

    // Error Source Control

    ,input  ppaerucm_t              csr_ppaerucm_wp                 // Uncorrectable error mask registexr
    ,input  ppaerucm_t              csr_ppaerucsev                  // AER Severity
    ,input  ppaercm_t               csr_ppaercm_wp                  // Correctable error mask registers
    ,input  ppaerctlcap_t           csr_ppaerctlcap_wp              // AER Capability Registers
    ,input  pcicmd_t                csr_pcicmd_wp                   // Device command register
    ,input  ppdcntl_t               csr_ppdcntl_wp                  // Device command register
    ,input  csr_data_t              csr_pcists_clr                  // PCISTS clear error
    ,input  csr_data_t              csr_ppaerucs_clr                // PPAERUCS clear error
    ,input  ppaerucm_t              csr_ppaerucs_c                  // Uncorrectable error contorl
    ,input  csr_data_t              csr_ppaercs_clr                 // PPAERCS clear error

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    ,output logic                   err_urd_vec                     // Per function vector for the unsupported request errors
    ,output logic                   err_fed_vec                     // Fatal error detect
    ,output logic                   err_ned_vec                     // Non-fatal error detect
    ,output logic                   err_ced_vec                     // Correctable error detect
    ,output pcists_t                csr_pcists                      // PCISTS CSRs for all functions
    ,output ppaerucm_t              csr_ppaerucs                    // Uncorrectable AER status
    ,output ppaercm_t               csr_ppaercs                     // Correctable AER status
    ,output csr_data_t              err_hdr_log0                    // AER header log0
    ,output csr_data_t              err_hdr_log1                    // AER header log1
    ,output csr_data_t              err_hdr_log2                    // AER header log2
    ,output csr_data_t              err_hdr_log3                    // AER header log3
    ,output hqm_pasidtlp_t          err_tlp_prefix_log0             // AER TLP prefix log0
    ,output logic                   err_gen_msg                     // Send an error message
    ,output logic [15:0]            err_gen_msg_func                // HSD 5313841 - Error function should be included in error message
    ,output logic [7:0]             err_gen_msg_data                // Data to be sent to the TI message register
);

logic                            usr_err_vec;               // Unsupported request
logic                            usr_err_vec_anfes;         // Unsupported request
logic                            ecrcc_err_vec;             // Per function ECRC check
logic                            mtlp_err_vec;              // Per function malformed packet
logic                            ec_err_vec;                // Per function unexpected completion
logic                            ec_err_vec_anfes;          // Per function unexpected completion advisory non-fatal
logic                            ptlpr_err_vec;             // Per function poisoned TLP
logic                            ptlpr_err_vec_anfes;       // Per function poisoned TLP advisory non-fatal/
logic                            ptlpr_err_vec_any;         // Per function poisoned TLP advisory non-fatal/
logic                            usr_err_vec_ff;            // Unsupported request
logic                            ecrcc_err_vec_ff;          // Per function ECRC check
logic                            mtlp_err_vec_ff;           // Per function malformed packet
logic                            ec_err_vec_ff;             // Per function unexpected completion
logic                            ptlpr_err_vec_ff;          // Per function poisoned TLP
logic                            anfes_err_vec;             // Per function advisory message
logic                            anfes_err_vec_ff;          // Per function advisory message
logic                            anfes_ced;                 // Per function advisory set device status CED
logic                            mdpe_err_vec;              // Per function CPL Data fifo parity
logic                            master_parity;             // Per function master data parity error
logic                            ct_err_vec;                // Per function completion timeout
logic                            ct_err_vec_ff;             // Per function completion timeout

// Pre Mask Error State

logic                            err_usr_unmasked;          // USR pre mask error state
logic                            err_ecrcc_unmasked;        // ECRC pre mask error state
logic                            err_mtlp_unmasked;         // Malformed TLP pre mask error state
logic                            err_ec_unmasked;           // Unexpected completion pre mask error state
logic                            err_ptlpr_unmasked;        // poisoned TLP pre mask error state
logic                            err_ct_unmasked;           // Completion timeout pre mask error state

// Pre Mask Error State floped

logic                            err_usr_unmasked_rxp;      // USR pre mask error state
logic                            err_ecrcc_unmasked_rxp;    // ECRC pre mask error state
logic                            err_mtlp_unmasked_rxp;     // Malformed TLP pre mask error state
logic                            err_ec_unmasked_rxp;       // Unexpected completion pre mask error state
logic                            err_ptlpr_unmasked_rxp;    // poisoned TLP pre mask error state
logic                            err_ct_unmasked_rxp;       // Completion timeout pre mask error state

// Advisory correctable errors.

logic                            err_anfes_unmasked;        // advisory pre mask error state
logic                            err_anfes_ur_unmasked;     // advisory UR pre mask error state

// Advisory correctable errors floped.

logic                            err_anfes_unmasked_rxp;    // advisory pre mask error state

// Masked Error Status

logic                            ppaerucs_ur;               // Per function USR err post mask
logic                            ppaerucs_ecrcc;            // Per function ECRCC err post mask
logic                            ppaerucs_mtlp;             // Per function MTLP err post mask
logic                            ppaerucs_ec;               // Per function EC err post mask
logic                            ppaerucs_ptlpr;            // Per function PTLPR err post mask
logic                            ppaerucs_ct;               // Per function CT err post mask

logic [`HQM_NUM_ERR_SRC-1:0]     mltfunc_mask_pnc;          // Mask for all errors, all functions
logic [`HQM_NUM_ERR_SRC-1:0]     mltfunc_mask_hold;         // Hold mask for all errors, all functions
logic [`HQM_NUM_ERR_SRC-1:0]     mask_per_err;              // severity per error type for each function

// Masked Error Grant

logic                            ppaerucs_ur_gnt;           // Per function USR grant err post mask
logic                            ppaerucs_ecrcc_gnt;        // Per function ECRCC grant err post mask
logic                            ppaerucs_mtlp_gnt;         // Per function MTLP grant err post mask
logic                            ppaerucs_ec_gnt;           // Per function EC grant err post mask
logic                            ppaerucs_ptlpr_gnt;        // Per function PTLPR grant err post mask
logic                            ppaerucs_ct_gnt;           // Per function CT grant err post mask

// Multiple Message Error Mask
logic                            mlt_ur_msg_mask;           // Mask for preventing multiple USR messages
logic                            mlt_ecrcc_msg_mask;        // Mask for preventing multiple ECRCC messages
logic                            mlt_mtlp_msg_mask;         // Mask for preventing multiple MTLP messages
logic                            mlt_ec_msg_mask;           // Mask for preventing multiple EC messages
logic                            mlt_ptlpr_msg_mask;        // Mask for preventing multiple PTLPR messages
logic                            mlt_anfes_msg_mask;        // Mask for preventing multiple ANFES messages
logic                            mlt_ct_msg_mask;           // Mask for preventing multiple CT messages

// Multiple Message Status

logic                            mlt_ur_msg_stat;           // Status for preventing multiple USR messages
logic                            mlt_ecrcc_msg_stat;        // Status for preventing multiple ECRCC messages
logic                            mlt_mtlp_msg_stat;         // Status for preventing multiple MTLP messages
logic                            mlt_ec_msg_stat;           // Status for preventing multiple EC messages
logic                            mlt_ptlpr_msg_stat;        // Status for preventing multiple PTLPR messages
logic                            mlt_anfes_msg_stat;        // Status for preventing multiple ANFES messages
logic                            mlt_ct_msg_stat;           // Status for preventing multiple CT messages

// Per function clear vector

logic                            ur_clr_vec;                // UR Per function clear vector
logic                            ecrcc_clr_vec;             // ECRCC Per function clear vector
logic                            mtlp_clr_vec;              // MTLP Per function clear vector
logic                            ec_clr_vec;                // EC Per function clear vector
logic                            ptlpr_clr_vec;             // PTLPR Per function clear vector
logic                            anfes_clr_vec;             // ANFES per function clear
logic                            ct_clr_vec;                // CT Per function clear vector

// Per function clear vector

logic                            ur_arb_mask_vec;           // UR Per function mask vector
logic                            ecrcc_arb_mask_vec;        // ECRCC Per function mask vector
logic                            mtlp_arb_mask_vec;         // MTLP Per function mask vector
logic                            ec_arb_mask_vec;           // EC Per function mask vector
logic                            ptlpr_arb_mask_vec;        // PTLPR Per function mask vector
logic                            anfes_arb_mask_vec;        // ANFES per function mask
logic                            ct_arb_mask_vec;           // CT Per function mask vector

logic                            anfes_ur_arb_mask_vec_nc;
logic                            dpe_arb_mask_vec_nc;
logic                            sse_arb_mask_vec_nc;
logic                            mdpe_arb_mask_vec_nc;

// Error severity per uncorrectable error

logic                            ppaerucs_ur_sev;           // Severity of unsupported request
logic                            ppaerucs_ecrcc_sev;        // Severity of ECRCC
logic                            ppaerucs_mtlp_sev;         // Severity of malformed packet
logic                            ppaerucs_ec_sev;           // Severity of unexpected completion
logic                            ppaerucs_ptlpr_sev;        // Severity of poisoned TLP
logic                            ppaerucs_ct_sev;           // Severity of completion timeout

// Error severity per function

logic                            ur_sev_vec;                // Severity of unsupported request
logic                            ecrcc_sev_vec;             // Severity of ECRCC
logic                            mtlp_sev_vec;              // Severity of malformed packets
logic                            ec_sev_vec;                // Severity of unexpected completions
logic                            ptlpr_sev_vec;             // Severity of poisoned TLP
logic                            ct_sev_vec;                // Severity of completion timeout

// Correctable Masked Error Status

logic                            ppaercs_anfes;             // Advisory correctable masked message
logic                            ppaercs_anfes_ff;          // Floped advisory correctable masked message

logic                            ppaercs_anfes_gnt;         // Advisory grant message

// Uncorrectable post arbitration pending per error data

pend_uerr_vec_t                  pend_uerr_det;             // Per function uncorrectable error pending
pend_uerr_vec_t                  pend_uerr_sevi;            // Per function uncorrectable error severity
pend_uerr_vec_t                  pend_uerr_sev;             // Per function uncorrectable error severity
pend_uerr_vec_t                  pend_uerr_req;             // Per function uncorrectable error req
pend_uerr_vec_t                  pend_uerr_gnt;             // Per function uncorrectable error grant

hdr_log_t                        hdr_log_src_vec_pnc;       // Error source vector for header log

// Per error post arbitration correctable error

pend_cerr_vec_t                  pend_cerr_det;             // Per function correctable error pending
pend_cerr_vec_t                  pend_cerr_req;             // Per function correctable error req
pend_cerr_vec_t                  pend_cerr_gnt;             // Per function correctable error grant

// Pending error message arbitration between each of the error sources

logic                            err_msg_rdy;               // Arbitrated error message ready
logic                            err_msg_sev;               // Severity of arbitrated error message
logic                            uerr_msg_sev;              // Severity of arbitrated error message
errhdr_t                         err_log_hdr;               // Potential header for error log CSR
logic                            cerr_msg_uc;               // Uncorrectable arbitrated error message

logic                            ecrccc_ppaerctlcap;        // ECRC capability enable

logic                            update_hdr_log;            // A header log needs to be updated
logic                            update_hdr_log_hdr;        // A header log needs to be updated
pend_err_vec_t                   log_err_vec;               // All logged functions, all uncorrectable errors
pend_err_vec_t                   log_err_vec_hdr;           // All logged functions, all uncorrectable errors
pend_err_vec_t                   log_err_vec_hdr_ff;        // All logged functions, all uncorrectable errors
pend_err_vec_t                   msg_err_vec;               // All message functions, all uncorrectable errors
pend_err_vec_t                   log_err_vec_ff;            // Previous uncorrectable errors
pend_err_vec_t                   hdr_log_vec;               // Header log used status
errhdr_t                         cds_error_hdr;             // Reconstructed header from error
errhdr_t                         cpl_error_hdr_ff;          // Reconstructed completion header from error

// Flopped Error Status Clears Signals

csr_data_t                       csr_pcists_pre_qual;       
csr_data_t                       csr_pcists_ff;             
csr_data_t                       csr_ppaerucs_pre_qual;     
csr_data_t                       csr_ppaerucs_ff;           
csr_data_t                       csr_ppaercs_pre_qual;      
csr_data_t                       csr_ppaercs_ff;            

logic                            cds_pusr_err_ff;           // Flopped posted USR error signal
logic                            cds_npusr_err_ff;          // Flopped non posted USR error signal
logic                            cds_cfg_usr_func_ff;       // Flopped USR func
logic                            cds_bar_decode_err_ff;     // Flopped USR func
logic                            cds_poison_err_ff;         // Flopped poison packet detect
logic                            cds_usr_in_cpl_ff;         // Flopped USR in completion
logic                            cds_malform_pkt_ff;        // Flopped malformed packet
logic                            cpl_poisoned_ff;           // Flopped completion poisoned
logic                            cpl_unexpected_ff;         // Flopped unexpected completion
logic                            cpl_timeout_ff;            // Flopped completion timeout
logic [8:0]                      cpl_timeout_synd_ff;       // Flopped completion timeout syndrome
logic                            err_fatal_en;              // Fatal error enable per function
logic                            usr_func_vec;              // Unsupported function request

// Message Arbitration Request Vectors

logic                            ppaerucs_ur_req;           // Arb message req of unsupported request
logic                            ppaerucs_ecrcc_req;        // Arb message req of ECRCC
logic                            ppaerucs_mtlp_req;         // Arb message req of malformed packet
logic                            ppaerucs_ec_req;           // Arb message req of unexpected completion
logic                            ppaerucs_ptlpr_req;        // Arb message req of poisoned TLP
logic                            ppaercs_anfes_req;         // Arb message req advisory non fatal
logic                            ppaerucs_ct_req;           // Arb message req of completion timeout

// Uncorrectable Advisory Non-Fatal

logic                            mltfunc_anfes_mask;        // Multi function advisory non fatal error mask
logic                            mltfunc_anfes_hold;        // Multi function advisory non fatal error mask hold

logic                            sse_err_sig;               // PCISTS.SSE error detect
logic                            anfes_mask;                // Mask for advisory error

logic                            lli_tecrc_cpar_err;        // or of tecrc and cpar errors

//-------------------------------------------------------------------------
// Unsupported Requests
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_usr(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (usr_err_vec),
    .clr_err            (ur_clr_vec),
    .err_taken          (ppaerucs_ur_gnt),
    .err_arb_mask       (ur_arb_mask_vec),
    .err_status         (err_usr_unmasked)
);

//-------------------------------------------------------------------------
// ECRCC
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_ecrcc(    
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (ecrcc_err_vec),
    .clr_err            (csr_ppaerucs_ff[19]),
    .err_taken          (ppaerucs_ecrcc_gnt),
    .err_arb_mask       (ecrcc_arb_mask_vec),
    .err_status         (err_ecrcc_unmasked)
);

//-------------------------------------------------------------------------
// Malformed TLP
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_mtlp(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (mtlp_err_vec),
    .clr_err            (csr_ppaerucs_ff[18]),
    .err_taken          (ppaerucs_mtlp_gnt),
    .err_arb_mask       (mtlp_arb_mask_vec),
    .err_status         (err_mtlp_unmasked)
);

//-------------------------------------------------------------------------
// AER Unexpected Completion
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_ec(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (ec_err_vec),
    .clr_err            (ec_clr_vec),
    .err_taken          (ppaerucs_ec_gnt),
    .err_arb_mask       (ec_arb_mask_vec),
    .err_status         (err_ec_unmasked)
);

//-------------------------------------------------------------------------
// AER Completer Abort
//-------------------------------------------------------------------------

// HQM does not generate completer aborts

//-------------------------------------------------------------------------
// AER Completion timeout
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_ct(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (ct_err_vec),
    .clr_err            (ct_clr_vec),
    .err_taken          (ppaerucs_ct_gnt),
    .err_arb_mask       (ct_arb_mask_vec),
    .err_status         (err_ct_unmasked)
);

//-------------------------------------------------------------------------
// AER Poisoned TLP Error
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_ptlpr(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (ptlpr_err_vec),
    .clr_err            (ptlpr_clr_vec),
    .err_taken          (ppaerucs_ptlpr_gnt),
    .err_arb_mask       (ptlpr_arb_mask_vec),
    .err_status         (err_ptlpr_unmasked)
);

//-------------------------------------------------------------------------
// Advisory Correctable Error Detect
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_anfes(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (anfes_err_vec),
    .clr_err            (csr_ppaercs_ff[13]),
    .err_taken          (ppaercs_anfes_gnt),
    .err_arb_mask       (anfes_arb_mask_vec),
    .err_status         (err_anfes_unmasked)
);

hqm_ri_err_stat i_ri_err_stat_anfes_ur(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (usr_err_vec_anfes),
    .clr_err            (csr_ppaercs_ff[13]),
    .err_taken          (ppaercs_anfes_gnt),
    .err_arb_mask       (anfes_ur_arb_mask_vec_nc),                               
    .err_status         (err_anfes_ur_unmasked)
);

//-------------------------------------------------------------------------
// PCISTS Poisoned TLP Error
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_dpe(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (ptlpr_err_vec_any),
    .clr_err            (csr_pcists_ff[31]),
    .err_taken          (1'b0),
    .err_arb_mask       (dpe_arb_mask_vec_nc),                              
    .err_status         (csr_pcists.dpe)
);

//-------------------------------------------------------------------------
// PCISTS Fatal/Non Fatal Message Status
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_sse(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (sse_err_sig),
    .clr_err            (csr_pcists_ff[30]),
    .err_taken          (1'b0),
    .err_arb_mask       (sse_arb_mask_vec_nc),                         
    .err_status         (csr_pcists.sse)
);

//-------------------------------------------------------------------------
// PCISTS Received Master Abort Status
//-------------------------------------------------------------------------

assign csr_pcists.rma = '0;

//-------------------------------------------------------------------------
// PCISTS Received Target Abort Status
//-------------------------------------------------------------------------

assign csr_pcists.rta = '0;

//-------------------------------------------------------------------------
// PCISTS Sent Completion Abort Status
//-------------------------------------------------------------------------

assign csr_pcists.sta = '0;

//-------------------------------------------------------------------------
// PCISTS Master Data Parity Error Status
//-------------------------------------------------------------------------

hqm_ri_err_stat i_ri_err_stat_mdpe(
    .prim_nonflr_clk    (prim_nonflr_clk),
    .prim_gated_rst_b   (prim_gated_rst_b),
    .err_signal         (master_parity),
    .clr_err            (csr_pcists_ff[24]),
    .err_taken          (1'b0),
    .err_arb_mask       (mdpe_arb_mask_vec_nc),                     
    .err_status         (csr_pcists.mdpe)
);

//-------------------------------------------------------------------------
// Arbitrate between all the functions unsupported request error messages
//-------------------------------------------------------------------------

assign ppaerucs_ur_gnt = ppaerucs_ur_req;

//-------------------------------------------------------------------------
// Arbitrate between all the functions ECRC error messages
//-------------------------------------------------------------------------

assign ppaerucs_ecrcc_gnt = ppaerucs_ecrcc_req;

//-------------------------------------------------------------------------
// Arbitrate between all the functions Malformed TLP error messages
//-------------------------------------------------------------------------

assign ppaerucs_mtlp_gnt = ppaerucs_mtlp_req;

//-------------------------------------------------------------------------
// Arbitrate between all the functions unexpected completion error messages
//-------------------------------------------------------------------------

assign ppaerucs_ec_gnt = ppaerucs_ec_req;

//-------------------------------------------------------------------------
// Arbitrate between all the functions completion timeout error messages
//-------------------------------------------------------------------------

assign ppaerucs_ct_gnt = ppaerucs_ct_req;

//-------------------------------------------------------------------------
// Arbitrate between all the functions poisoned TLP error messages
//-------------------------------------------------------------------------

assign ppaerucs_ptlpr_gnt = ppaerucs_ptlpr_req;

//-------------------------------------------------------------------------
// Arbitrate between all the functions advisory error messages
//-------------------------------------------------------------------------

assign ppaercs_anfes_gnt = ppaercs_anfes_req;

//-------------------------------------------------------------------------
// Error Message Aribter
//-------------------------------------------------------------------------

hqm_fair_arb #(.LINES(`HQM_NUM_ERR_SRC), .LOG2LINES(`HQM_NUM_ERR_SRC_LOG2)) i_fair_arb_errmsg ( 
    .clk    (prim_nonflr_clk),
    .rst    (prim_gated_rst_b),
    .req    (({pend_uerr_req, pend_cerr_req} & {`HQM_NUM_ERR_SRC{~err_gen_msg}})),
    .gnt    ({pend_uerr_gnt, pend_cerr_gnt})
);

//-------------------------------------------------------------------------
// Multi Function Errors
//-------------------------------------------------------------------------

always_comb begin: multi_func_err_p

    // The following errors sources are ones which effect all the functions.
    // Here, we will set the error signal for each function that has either
    // fatal, non fatal or correctable enabled.

    mtlp_err_vec     = cds_malform_pkt_ff;
    usr_func_vec     = cds_cfg_usr_func_ff | cds_bar_decode_err_ff | cds_usr_in_cpl_ff;
    ec_err_vec       = cpl_unexpected_ff &  ec_sev_vec;
    ec_err_vec_anfes = cpl_unexpected_ff & ~ec_sev_vec;

end // always_comb multi_func_err_p

//-------------------------------------------------------------------------
// Per Function Error Severity
//-------------------------------------------------------------------------

always_comb begin: sev_vec_p

    ur_sev_vec    = csr_ppaerucsev.ur;
    ecrcc_sev_vec = csr_ppaerucsev.ecrcc;
    mtlp_sev_vec  = csr_ppaerucsev.mtlp;
    ec_sev_vec    = csr_ppaerucsev.ec;
    ct_sev_vec    = csr_ppaerucsev.ct;
    ptlpr_sev_vec = csr_ppaerucsev.ptlpr;

end // always_comb sev_vec_p

//-------------------------------------------------------------------------
// Uncorrectable Unsupported Request
//-------------------------------------------------------------------------

always_comb begin: usr_err_vec_p

    // Create a per function vector for the unsupported request error
    // Posted USR are uncorrectable but non posted will be flagged as advisory
    // non-fatal if the severity bit is not set.

    if (cds_bar_decode_err_ff & cds_pusr_err_ff) begin

        // Non-function specific posted decode error is always treated as USR

        usr_err_vec = usr_func_vec;

    end else if (cds_usr_in_cpl_ff | cds_cfg_usr_func_ff) begin

        // Non-function specific non-posted unsupported request or undefined CFG function
        // Treated as USR only if severity is fatal

        usr_err_vec = ur_sev_vec & usr_func_vec;

    end else begin

        // Function specific URs
        // Non-posted are treated as USR only if severity is fatal

        usr_err_vec = cds_pusr_err_ff | (ur_sev_vec & cds_npusr_err_ff);
    end

end // always_comb usr_err_vec_p

//-------------------------------------------------------------------------
// HSD 5314966 - Unsupported request was posted if asserted
// Uncorrectable Unsupported Request for ANFES ONLY
//-------------------------------------------------------------------------

always_comb begin: usr_err_vec_anfes_p

    // Create a per function vector for the unsupported request error
    // Posted USR are uncorrectable but non posted will be flagged as advisory
    // non-fatal if the severity is bit is not set.

    if (cds_usr_in_cpl_ff | cds_cfg_usr_func_ff | (cds_bar_decode_err_ff & ~cds_pusr_err_ff)) begin

        // Non-function specific non-posted unsupported request or undefined CFG function
        // Non-function specific non-posted decode error
        // Treated as advisory non-fatal only if severity is non-fatal

        usr_err_vec_anfes = ~ur_sev_vec & usr_func_vec;

    end else begin

        // Function specific URs
        // Non-posted are treated as advisory non-fatal only if severity is non-fatal

        usr_err_vec_anfes = ~ur_sev_vec & cds_npusr_err_ff;
    end

end // always_comb usr_err_vec_p

//-------------------------------------------------------------------------
// PPDSTAT USR Status Input
//-------------------------------------------------------------------------

always_comb begin: err_urd_vec_p

    // Unsupported Requests that are reported in the PPDSTAT.USR CSR include
    // those that are advisory.
    // HSD 4727745 - added support for ANFES for virtual functions

    err_urd_vec = usr_err_vec | usr_err_vec_anfes;

end // always_comb err_urd_vec_p

//-------------------------------------------------------------------------
// Per Physical & Virtual Function Error Vector
//-------------------------------------------------------------------------

always_comb begin: per_func_err_p

    // Create a per function vector for ECRCC or cpar
    // since this is a non-function specific error, tying function number to always be 0 for PF
    // Create a per function vector for malformed TLP error severity
    // Create a per function vector for receiver overflow
    // Create a per function vector for unexpected completion
    // Create a per function vector for completer abort
    // Completer/Target aborts come from the following sources;
    // - inbound completion completion status = 100 (no error message generated)
    // - Non aligned CSR accesses
    // - CSR access of size greater then 32 bits
    // Create a per function vector for completion timeout
    // Create a per function vector for flow control protocol
    // Create a per function vector for poisoned TLP received for posted and nonposted commands
    // Create a per function vector for poisoned data link protocol

    ppaerucs_ur_sev    = '0;
    ppaerucs_ecrcc_sev = '0;
    ppaerucs_mtlp_sev  = '0;
    ppaerucs_ec_sev    = '0;
    ppaerucs_ct_sev    = '0;
    ppaerucs_ptlpr_sev = '0;

    if (ppaerucs_ur_gnt)    ppaerucs_ur_sev    = csr_ppaerucsev.ur    & err_fatal_en;
    if (ppaerucs_ecrcc_gnt) ppaerucs_ecrcc_sev = csr_ppaerucsev.ecrcc & err_fatal_en;
    if (ppaerucs_mtlp_gnt)  ppaerucs_mtlp_sev  = csr_ppaerucsev.mtlp  & err_fatal_en;
    if (ppaerucs_ec_gnt)    ppaerucs_ec_sev    = csr_ppaerucsev.ec    & err_fatal_en;
    if (ppaerucs_ct_gnt)    ppaerucs_ct_sev    = csr_ppaerucsev.ct    & err_fatal_en;
    if (ppaerucs_ptlpr_gnt) ppaerucs_ptlpr_sev = csr_ppaerucsev.ptlpr & err_fatal_en;

    lli_tecrc_cpar_err = lli_cpar_err_wp | (lli_tecrc_err_wp & ecrccc_ppaerctlcap);

    ecrcc_err_vec = lli_tecrc_cpar_err;

    ct_err_vec    = cpl_timeout_ff;

    ptlpr_err_vec_any   = cds_poison_err_ff | cpl_poisoned_ff;
    ptlpr_err_vec       = ptlpr_err_vec_any &  ptlpr_sev_vec;
    ptlpr_err_vec_anfes = ptlpr_err_vec_any & ~ptlpr_sev_vec;

end // always_comb per_func_err_p

//-------------------------------------------------------------------------
// HSD 5314547 - MDPE not getting set when CPM receives poison completion
// PPCISTS Errors not Covered by PPAER
//-------------------------------------------------------------------------

always_comb begin: ppcists_mdpe_p

    // Create a per function vector for master data parity error detected

    mdpe_err_vec = poisoned_wr_sent;

end // always_comb ppcists_mdpe_p

//-------------------------------------------------------------------------
// Error Clear Vector Per Function
//-------------------------------------------------------------------------

always_comb begin: err_clr_vec_p

    ur_clr_vec    = csr_ppaerucs_ff[20];
    ecrcc_clr_vec = csr_ppaerucs_ff[19];
    mtlp_clr_vec  = csr_ppaerucs_ff[18];
    ec_clr_vec    = csr_ppaerucs_ff[16];
    ct_clr_vec    = csr_ppaerucs_ff[14];
    anfes_clr_vec = csr_ppaercs_ff[ 13];
    ptlpr_clr_vec = csr_ppaerucs_ff[12];

end // always_comb err_clr_vec_p

//-------------------------------------------------------------------------
// Multiple Message Mask
//-------------------------------------------------------------------------

always_comb begin: mlt_msg_mask_p

    // mult_msg_mask() will create a mask the prevents all but the function
    // who generated an error from sending an error message when the error
    // applies to all functions.

    // HSD 5313801 - mask signal uses pusr signal instead of usr, removed CA mask signal since it shouldn't be here.

    mlt_ur_msg_mask     = mult_msg_mask_func(1'b0,               1'b0,               mlt_ur_msg_stat,     ur_clr_vec);
    mlt_ecrcc_msg_mask  = mult_msg_mask_func(lli_tecrc_cpar_err, lli_tecrc_cpar_err, mlt_ecrcc_msg_stat,  ecrcc_clr_vec);
    mlt_mtlp_msg_mask   = mult_msg_mask_func(cds_malform_pkt_ff, cds_malform_pkt_ff, mlt_mtlp_msg_stat,   mtlp_clr_vec);
    mlt_ec_msg_mask     = mult_msg_mask_func(cpl_unexpected_ff,  cpl_unexpected_ff,  mlt_ec_msg_stat,     ec_clr_vec);
    mlt_ct_msg_mask     = mult_msg_mask_func(cpl_timeout_ff,     cpl_timeout_ff,     mlt_ct_msg_stat,     ct_clr_vec);
    mlt_ptlpr_msg_mask  = mult_msg_mask_func(1'b0,               cds_poison_err_ff,  mlt_ptlpr_msg_stat,  ptlpr_clr_vec);
    mlt_anfes_msg_mask  = mult_msg_mask_func(1'b0,               1'b0,               mlt_anfes_msg_stat,  anfes_clr_vec);

end // always_comb mlt_msg_mask_p

//-------------------------------------------------------------------------
// Multiple Message Status
//-------------------------------------------------------------------------

//ssabneka added:

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin

    if (~prim_gated_rst_b) begin
        mlt_ur_msg_stat     <= '0;
        mlt_ecrcc_msg_stat  <= '0;
        mlt_mtlp_msg_stat   <= '0;
        mlt_ec_msg_stat     <= '0;
        mlt_ct_msg_stat     <= '0;
        mlt_ptlpr_msg_stat  <= '0;
        mlt_anfes_msg_stat  <= '0;
    end else begin
        if (mlt_ur_msg_mask     != mlt_ur_msg_stat    ) mlt_ur_msg_stat     <= mlt_ur_msg_mask;
        if (mlt_ecrcc_msg_mask  != mlt_ecrcc_msg_stat ) mlt_ecrcc_msg_stat  <= mlt_ecrcc_msg_mask;
        if (mlt_mtlp_msg_mask   != mlt_mtlp_msg_stat  ) mlt_mtlp_msg_stat   <= mlt_mtlp_msg_mask;
        if (mlt_ec_msg_mask     != mlt_ec_msg_stat    ) mlt_ec_msg_stat     <= mlt_ec_msg_mask;
        if (mlt_ct_msg_mask     != mlt_ct_msg_stat    ) mlt_ct_msg_stat     <= mlt_ct_msg_mask;
        if (mlt_ptlpr_msg_mask  != mlt_ptlpr_msg_stat ) mlt_ptlpr_msg_stat  <= mlt_ptlpr_msg_mask;
        if (mlt_anfes_msg_mask  != mlt_anfes_msg_stat ) mlt_anfes_msg_stat  <= mlt_anfes_msg_mask;
    end

end

//-------------------------------------------------------------------------
// Advisory Error Signal Per Function
//-------------------------------------------------------------------------

always_comb begin: anfes_err_vec_p

    // Create a per function vector for the advisory errors


    anfes_err_vec = usr_err_vec_anfes | ec_err_vec_anfes | ptlpr_err_vec_anfes;

    // Correctable error detected must be set even if correctable error reporting is not enabled.

    anfes_ced     = anfes_err_vec & ~anfes_err_vec_ff;

end // always_comb anfes_err_vec_p

//-------------------------------------------------------------------------
// Uncorrectable Advisory Error Last State
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: anfes_ced_ff_p

    if (~prim_gated_rst_b) begin
        anfes_err_vec_ff <= '0;
    end else begin
        anfes_err_vec_ff <= anfes_err_vec;
    end // else !reset

end // always_ff anfes_vec_ff_p

//-------------------------------------------------------------------------
// Fatal Error Status Per Function
//-------------------------------------------------------------------------

always_comb begin: err_fatal_en_p

    // Fatal errors can be enabled via the PPCICMD SER bit or via the PPDCNTL
    // FERE bit. The following creates a per function fatal error enable signal.

    err_fatal_en = csr_pcicmd_wp.ser | csr_ppdcntl_wp.fere;

end // always_comb err_fatal_en_p

//-------------------------------------------------------------------------
// Uncorrectable Unsupported Request Error Masked
//-------------------------------------------------------------------------

always_comb begin: csr_ppaerucs_p

    // In order for an unsupported request to be detected;
    // - There must be an unsupported request on a supported function.
    // - The USR cannont be masked for the given function (PPAERUCM[20]).
    // - Unsupported requests must be enabled (PPDCNTL[3]).
    // - Fixes for ticket 3542120
    // - 3542193 made a typo when fixing the above 3542120 for ptlpr

    // - csr_ppaerucsev needs to be high to enable  fatal messages
    // - csr_ppaerucsev needs to be low to enable  non-fatal messages


    //  if (errorunmasked & logging enabled & not multi function error) &
    //  ((if fatal reporting enabled and severity is fatal) or  non_fatal reporting enabled & severity is non f


    //3542206 for ur if urro or ser are high the error can be loged as per pcie flow chart

    ppaerucs_ur    = err_usr_unmasked & ~csr_ppaerucm_wp.ur & ~mlt_ur_msg_mask &
                        (csr_ppdcntl_wp.urro | csr_pcicmd_wp.ser) &
                        ((err_fatal_en & csr_ppaerucsev.ur) |
                         ((csr_ppdcntl_wp.nere | csr_pcicmd_wp.ser) & ~csr_ppaerucsev.ur));

    // Masked ECRC error status per function

    ppaerucs_ecrcc = err_ecrcc_unmasked & ~csr_ppaerucm_wp.ecrcc & ~mlt_ecrcc_msg_mask &
                        ((err_fatal_en & csr_ppaerucsev.ecrcc) |
                         ((csr_ppdcntl_wp.nere | csr_pcicmd_wp.ser) & ~csr_ppaerucsev.ecrcc));

    // Masked malformed TLP error status per function

    ppaerucs_mtlp  = err_mtlp_unmasked & ~csr_ppaerucm_wp.mtlp & ~mlt_mtlp_msg_mask &
                        ((err_fatal_en & csr_ppaerucsev.mtlp) |
                         ((csr_ppdcntl_wp.nere | csr_pcicmd_wp.ser) & ~csr_ppaerucsev.mtlp));

    // Unexpected completion error status per function

    ppaerucs_ec    = err_ec_unmasked &  ~csr_ppaerucm_wp.ec & ~mlt_ec_msg_mask &
                        ((err_fatal_en & csr_ppaerucsev.ec) |
                         ((csr_ppdcntl_wp.nere | csr_pcicmd_wp.ser) & ~csr_ppaerucsev.ec));

    // Completion timeout error status per function

    ppaerucs_ct    = err_ct_unmasked & ~csr_ppaerucm_wp.ct & ~mlt_ct_msg_mask &
                        ((err_fatal_en & csr_ppaerucsev.ct) |
                         ((csr_ppdcntl_wp.nere | csr_pcicmd_wp.ser) & ~csr_ppaerucsev.ct));


    // Poisoned TLP recieved error status per function

    ppaerucs_ptlpr = err_ptlpr_unmasked & ~csr_ppaerucm_wp.ptlpr & ~mlt_ptlpr_msg_mask &
                        ((err_fatal_en & csr_ppaerucsev.ptlpr) |
                         ((csr_ppdcntl_wp.nere | csr_pcicmd_wp.ser) & ~csr_ppaerucsev.ptlpr));


    // The status register will signal unsupported request in the status
    // even if PPDCNTL does not have USR messages being sent back up to the host.
    // Must only pulse once for the bit to be set in the CSR.
    //ticket 3542124 csr_ppaerucs.ec needed to be gated by anfes_mask the same way csr_ppaerucs.ur is
    //ticket 3542125 csr_ppaerucs.ptlpr needed to be gated by anfes_mask the same way csr_ppaerucs.ur is

    csr_ppaerucs.ieunc = '0;
    csr_ppaerucs.ur    = (err_usr_unmasked    & ~err_usr_unmasked_rxp) |
                         (usr_err_vec_anfes   & ~anfes_mask);
    csr_ppaerucs.ecrcc =  err_ecrcc_unmasked  & ~err_ecrcc_unmasked_rxp;
    csr_ppaerucs.mtlp  =  err_mtlp_unmasked   & ~err_mtlp_unmasked_rxp;
    csr_ppaerucs.ro    = '0;
    csr_ppaerucs.ec    = (err_ec_unmasked     & ~err_ec_unmasked_rxp) |
                         (ec_err_vec_anfes    & ~anfes_mask);
    csr_ppaerucs.ca    = '0;
    csr_ppaerucs.ct    =  err_ct_unmasked     & ~err_ct_unmasked_rxp;
    csr_ppaerucs.fcpes = '0;
    csr_ppaerucs.ptlpr = (err_ptlpr_unmasked  & ~err_ptlpr_unmasked_rxp) |
                         (ptlpr_err_vec_anfes & ~anfes_mask);
    csr_ppaerucs.dlpe  = '0;

end // always_comb csr_ppaerucs_p

//-------------------------------------------------------------------------
// Flop pre mask errors to edge dected
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_unmasked_p
    if (~prim_gated_rst_b) begin
        err_usr_unmasked_rxp    <= '0;
        err_ecrcc_unmasked_rxp  <= '0;
        err_mtlp_unmasked_rxp   <= '0;
        err_ec_unmasked_rxp     <= '0;
        err_ct_unmasked_rxp     <= '0;
        err_ptlpr_unmasked_rxp  <= '0;
    end else begin
        err_usr_unmasked_rxp    <= err_usr_unmasked;
        err_ecrcc_unmasked_rxp  <= err_ecrcc_unmasked;
        err_mtlp_unmasked_rxp   <= err_mtlp_unmasked;
        err_ec_unmasked_rxp     <= err_ec_unmasked;
        err_ct_unmasked_rxp     <= err_ct_unmasked;
        err_ptlpr_unmasked_rxp  <= err_ptlpr_unmasked;
    end
end

//-------------------------------------------------------------------------
// Advisory Correctable Error Masked
//-------------------------------------------------------------------------

always_comb begin: csr_ppaercs_p

    //ssabneka added: IECOR masked error status per physical function
    // Replay timer masked error status per physical function
    // Replay numbeer rollover masked error status per physical function
    // Bad DLLP masked error status per physical function
    // Bad TLP masked error status per physical function
    // Receiver error masked error status per physical function


    // correctable error status - tie off bits from unused physical functions and vitual functions

    csr_ppaercs.iecor  = '0;
    csr_ppaercs.rtts   = '0;
    csr_ppaercs.rnrs   = '0;
    csr_ppaercs.bdllps = '0;
    csr_ppaercs.dlpe   = '0;
    csr_ppaercs.res    = '0;

    // Advisory correctable error message request

    ppaercs_anfes     = err_anfes_unmasked & ~csr_ppaercm_wp.anfes & csr_ppdcntl_wp.cere &
                            ~(err_anfes_ur_unmasked & ~csr_ppdcntl_wp.urro);

    // correctable error status

    csr_ppaercs.anfes = err_anfes_unmasked & ~err_anfes_unmasked_rxp;

end // always_comb csr_ppaercs_p

//-------------------------------------------------------------------------
//  Advisory Correctable Error Masked flop
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: mask_ppaercs_flop_p
    if (~prim_gated_rst_b) begin
        err_anfes_unmasked_rxp  <= '0;
    end else begin
        err_anfes_unmasked_rxp  <= err_anfes_unmasked;
    end
end

//-------------------------------------------------------------------------
// Re-constructed Header for Error Logging
//-------------------------------------------------------------------------

always_comb begin: cds_error_hdr_p

    cds_error_hdr = {

         cds_err_hdr.pasidtlp                                           // PASIDTLP

        ,(((cds_err_hdr.fmt==2'd0) | (cds_err_hdr.fmt==2'd2)) ?

            32'd0 :                                                     // Header Bytes 12-15   (3DW format)
            cds_err_hdr.addr[31: 0])                                    // Header Bytes 12-15   (4DW format)

        ,(((cds_err_hdr.fmt==2'd0) | (cds_err_hdr.fmt==2'd2)) ?

            cds_err_hdr.addr[31: 0] :                                   // Header Bytes  8-11   (3DW format)
            cds_err_hdr.addr[63:32])                                    // Header Bytes  8-11   (4DW format)

        ,cds_err_hdr.reqid[15:8]                                        // Header Byte   4
        ,cds_err_hdr.reqid[7:0]                                         // Header Byte   5
        ,cds_err_hdr.tag[7:0]                                           // Header Byte   6
        ,cds_err_hdr.endbe, cds_err_hdr.startbe                         // Header Byte   7

        ,{1'd0,cds_err_hdr.fmt,cds_err_hdr.ttype}                       // Header Byte   0, bits 7->0
        ,{cds_err_hdr.tag[9], cds_err_hdr.tc, cds_err_hdr.tag[8], 3'd0} // Header Byte   1
        ,{1'd0, cds_err_hdr.poison, 4'd0, cds_err_hdr.length[9:8]}      // Header Byte   2
        ,cds_err_hdr.length[7:0]};                                      // Header Byte   3

end // always_comb cds_error_hdr_p

//-------------------------------------------------------------------------
// Re-constructed Completion Header for Error Logging
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge soft_rst_np) begin: cpl_error_hdr_p

    if (~soft_rst_np) begin

        cpl_error_hdr_ff    <= '0;
        cpl_timeout_synd_ff <= '0;

    // Need to load this on the first unexpected completion error for a function
    // if we are going to log the header.  We will log the header if EC is not masked
    // in the ppaerucm and either it is not an ANFES case (ppaersev=FATAL) or it is an
    // ANFES case and ANFES is not masked in ppaercm.

    end else begin

        if (~(|cpl_error_hdr_ff) &              // Hasn't been loaded yet or cleared
            ~(|hdr_log_vec)      &              // Error log not loaded yet

            // CE and CE not masked and (severity is fatal or ANFES not masked)

            ((cpl_unexpected & ~mask_per_err[   EC_EL] & (   ec_sev_vec | ~anfes_mask)) |

            // Cpl PTLPR and PTLPR not masked and (severity is fatal or ANFES not masked)

             (cpl_poisoned   & ~mask_per_err[PTLPR_EL] & (ptlpr_sev_vec | ~anfes_mask)) 

            )) begin

         cpl_error_hdr_ff <= {

          {$bits(hqm_pasidtlp_t){1'b0}},                                // PASIDTLP
          32'h0,                                                        // Header byte 12-15
          cpl_error_hdr.rid[15:8],                                      // Header byte 8
          cpl_error_hdr.rid[7:0],                                       // Header byte 9
          cpl_error_hdr.tag[7:0],                                       // Header byte 10
          6'h0, cpl_error_hdr.addr[1:0],                                // Header byte 11
          cpl_error_hdr.cid[15:8],                                      // Header byte 4
          cpl_error_hdr.cid[7:0],                                       // Header byte 5
          cpl_error_hdr.status[2:0], 1'b0, cpl_error_hdr.bc[11:8],      // Header byte 6
          cpl_error_hdr.bc[7:0],                                        // Header byte 7
          1'b0, cpl_error_hdr.wdata, 1'b0, 5'b01010,                    // Header Byte 0, bits 7->0
          cpl_error_hdr.tag[9], cpl_error_hdr.tc,                       // Header byte 1
          cpl_error_hdr.tag[8], cpl_error_hdr.ido, 2'd0,
          1'b0, cpl_error_hdr.poison,2'h0,                              // Header byte 2
          cpl_error_hdr.ro, cpl_error_hdr.ns, cpl_error_hdr.length[9:8],
          cpl_error_hdr.length[7:0]                                     // Header byte 3
         };

        end else if ((|cpl_error_hdr_ff) & (ec_clr_vec | ptlpr_clr_vec)) begin

         cpl_error_hdr_ff <= '0;

        end

        if (~(|cpl_timeout_synd_ff) &           // Hasn't been loaded yet or cleared
            ~(|hdr_log_vec)         &           // Error log not loaded yet
            cpl_timeout & ~mask_per_err[CT_EL]  // CT and CT is not masked
           ) begin

         cpl_timeout_synd_ff <= cpl_timeout_synd;

        end else if ((|cpl_timeout_synd_ff) & ct_clr_vec) begin

         cpl_timeout_synd_ff <= '0;

        end


    end

end

//-------------------------------------------------------------------------
// Uncorrectable Pending Error Condition
//-------------------------------------------------------------------------

always_comb begin: pend_uerr_det_p

    // Uncorrectable error pending grant

    pend_uerr_det[IEUNC] = '0;
    pend_uerr_det[   UR] = ppaerucs_ur_gnt;
    pend_uerr_det[ECRCC] = ppaerucs_ecrcc_gnt;
    pend_uerr_det[ MTLP] = ppaerucs_mtlp_gnt;
    pend_uerr_det[   RO] = '0;
    pend_uerr_det[   EC] = ppaerucs_ec_gnt;
    pend_uerr_det[   CA] = '0;
    pend_uerr_det[   CT] = ppaerucs_ct_gnt;
    pend_uerr_det[FCPES] = '0;
    pend_uerr_det[PTLPR] = ppaerucs_ptlpr_gnt;
    pend_uerr_det[ DLPE] = '0;

    // Uncorrectable error severity

    pend_uerr_sevi[IEUNC] = '0;
    pend_uerr_sevi[   UR] = ppaerucs_ur_sev;
    pend_uerr_sevi[ECRCC] = ppaerucs_ecrcc_sev;
    pend_uerr_sevi[ MTLP] = ppaerucs_mtlp_sev;
    pend_uerr_sevi[   RO] = '0;
    pend_uerr_sevi[   EC] = ppaerucs_ec_sev;
    pend_uerr_sevi[   CA] = '0;
    pend_uerr_sevi[   CT] = ppaerucs_ct_sev;
    pend_uerr_sevi[FCPES] = '0;
    pend_uerr_sevi[PTLPR] = ppaerucs_ptlpr_sev;
    pend_uerr_sevi[ DLPE] = '0;

end // always_comb pend_uerr_det_p

//-------------------------------------------------------------------------
// Pending Uncorrectable Error Register
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pend_uerr_p

    if (~prim_gated_rst_b) begin
        pend_uerr_req <='0;
        pend_uerr_sev <='0;
    end else begin
        for(int i=0; i < `HQM_NUM_UERR_SRC; i++) begin
            if (pend_uerr_det[i]) begin
                pend_uerr_req[i] <= '1;
                pend_uerr_sev[i] <= pend_uerr_sevi[i];
            end else if (pend_uerr_gnt[i]) begin
                pend_uerr_req[i] <= '0;
                pend_uerr_sev[i] <= '0;
            end // else maintain state
        end // for i
    end // !reset

end // always_ff pend_err_p

//-------------------------------------------------------------------------
// Correctable Pending Error Condition
//-------------------------------------------------------------------------

always_comb begin: pend_cerr_det_p

    // Correctable error pending grant

    pend_cerr_det[ IECOR] = '0;                     
    pend_cerr_det[ ANFES] = ppaercs_anfes_gnt;     
    pend_cerr_det[  RTTS] = '0;                     
    pend_cerr_det[  RNRS] = '0;                     
    pend_cerr_det[BDLLPS] = '0;                     
    pend_cerr_det[ BDLPE] = '0;                     
    pend_cerr_det[   RES] = '0;                     

end // always_comb pend_cerr_det_p

//-------------------------------------------------------------------------
// Pending Correctable Error Register
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pend_cerr_p

    if (~prim_gated_rst_b)
        pend_cerr_req <='0;
    else begin
        for(int i=0; i < `HQM_NUM_CERR_SRC; i++) begin
            if (pend_cerr_det[i]) begin
                pend_cerr_req[i] <= '1;
            end else if (pend_cerr_gnt[i]) begin
                pend_cerr_req[i] <= '0;
            end // else maintain state
        end // for i
    end // !reset

end // always_ff pend_err_p

//-------------------------------------------------------------------------
// Arbitrated Error Message Ready
//-------------------------------------------------------------------------

always_comb begin: err_msg_rdy_p

    err_msg_rdy = |{pend_cerr_gnt, pend_uerr_gnt};

    // If an uncorrectable error was granted arbitration, mux out the
    // function, severity and correctable status for the error selected.

    uerr_msg_sev  = '0;

    for(int i=0; i < `HQM_NUM_UERR_SRC; i++) begin
        if (pend_uerr_gnt[i]) begin
            uerr_msg_sev  = pend_uerr_sev[i];
        end
    end // for i

    // If a correctable error was granted arbitration, mux out the
    // function, severity and correctable status for the error selected.

    cerr_msg_uc   = '0;

    for(int i=0; i < `HQM_NUM_CERR_SRC; i++) begin
        if (pend_cerr_gnt[i]) begin
            cerr_msg_uc   = 1'b1;
        end // if pend_cerr_gnt[i]
    end // for i

    // Select the correctable or uncorrectable error function, severity
    // and correctable stataus.

    err_msg_sev  = |pend_uerr_gnt ? uerr_msg_sev  : '0;

end //always_comb err_msg_rdy_p

//-------------------------------------------------------------------------
// Pending Error Message Request
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_gen_msg_p

    if (~prim_gated_rst_b) begin

        err_gen_msg      <= '0;
        err_gen_msg_data <= '0;
        err_gen_msg_func <= '0;

    end else if (err_msg_rdy) begin

        // When an error message has been arbitrated from all the error sources,
        // signal to ri_cds it is ready to be scheduled as a CSR write to the
        // message register.

        err_gen_msg      <= '1;
        err_gen_msg_data <= cerr_msg_uc ? 8'b00110000 :
                           !err_msg_sev ? 8'b00110001 :
                                          8'b00110011;
        err_gen_msg_func <= {current_bus, 8'd0};

    end else if (cds_err_msg_gnt) begin

        // The messaged has been scheduled, clear the pending status

        err_gen_msg      <= '0;
        err_gen_msg_data <= '0;
        err_gen_msg_func <= '0;

    end

end // always_ff err_gen_msg_p

//-------------------------------------------------------------------------
// ECRC Capabilities Enable
//-------------------------------------------------------------------------

always_comb begin: ecrc_ppaerctlcap_p

    // ECRC is not enabled for virtual functions. Since this vector is used
    // as an enable for the unmasked error status and ECRC is an uncorrectable
    // error, the error generation runs through both virtual and physical
    // functions.
    // updated to be enabled only if ECRCCC & ECRCCE - check capable and check enabled

    ecrccc_ppaerctlcap = csr_ppaerctlcap_wp.ecrccc & csr_ppaerctlcap_wp.ecrcce;

end // always_combecrc_ppaerctlcap

//-------------------------------------------------------------------------
// Master Parity Error
//-------------------------------------------------------------------------

always_comb begin: master_parity_p

    // The master parity error consists of
    // - Parity errors detected in the completion data fifo of the RI

    master_parity = mdpe_err_vec & csr_pcicmd_wp.per;

end // always_comb master_parity_p

//-------------------------------------------------------------------------
// Error Header Log
//-------------------------------------------------------------------------
// Every error source for every function will have a bit that is set
// when the error is signaled (arbitrated) and cleared when it's
// respective CSR status is written. This is used to maintain the
// AER header log register for each function. The header log cannot
// change state until the status bit is cleared. When the individual
// bits below are set, they will prevent a subsequent error from
// changing the AER error log registers.
// cleared all mask when clear is asserted 3542139
// hmccarth clear the header log vec when log_err_clr transistions to zero

always_ff @(posedge prim_nonflr_clk or negedge hard_rst_np) begin: hdr_log_vec0_p

  if (~hard_rst_np) begin

      hdr_log_vec <= '0;

  // Protect loading of PF sticky regs during ResetPrep or PF FLR

  end else if (~quiesce_qualifier & ~flr_treatment_vec) begin

      if (~(|csr_ppaerucs_c) & (|hdr_log_vec)) begin
          hdr_log_vec <= '0;
      end else if ((update_hdr_log_hdr) & ~(|hdr_log_vec)) begin
          hdr_log_vec <= '1;
      end

  end

end // always_ff hdr_log_vec0_p

//-------------------------------------------------------------------------
// AER Header Error Log Regiseter
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge hard_rst_np) begin: err_hdr_log0_p

  // Take the error header recorded for each function and maintain it's
  // state until a new error is detected and the status is clear.

  if (~hard_rst_np) begin

      err_hdr_log0        <= '0;
      err_hdr_log1        <= '0;
      err_hdr_log2        <= '0;
      err_hdr_log3        <= '0;
      err_tlp_prefix_log0 <= '0;

  // Protect loading of PF sticky regs during ResetPrep or PF FLR

  end else if (~quiesce_qualifier & ~flr_treatment_vec) begin

      // Only a an error with a clear status will be qualified to
      // change the header log.

      if (update_hdr_log_hdr & ~(|hdr_log_vec)) begin
          err_hdr_log0        <= err_log_hdr[31:0];
          err_hdr_log1        <= err_log_hdr[63:32];
          err_hdr_log2        <= err_log_hdr[95:64];
          err_hdr_log3        <= err_log_hdr[127:96];
          err_tlp_prefix_log0 <= err_log_hdr.pasidtlp;
      end // if update_hdr_log

  end // else !reset

end // always_ff

// It was necessary to flop the clear error signals coming from the
// CSR registers to fix a timing path starting at obc_hdr_full and
// running to the err_hdr_log3 register.

//-------------------------------------------------------------------------
// PCI Status Clear (Not a sticky reg)
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge soft_rst_np) begin
    if (~soft_rst_np) begin
        csr_pcists_pre_qual <= '1;
    end else begin
        csr_pcists_pre_qual <= csr_pcists_clr;
    end
end

assign csr_pcists_ff = csr_pcists_pre_qual | {$bits(csr_data_t){flr_treatment_vec}};

//-------------------------------------------------------------------------
// Uncorrectable Error Clear (PF)
//   Correctable Error Clear (PF)
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge hard_rst_np) begin
    if (~hard_rst_np) begin

        csr_ppaerucs_pre_qual <= '1;
        csr_ppaercs_pre_qual  <= '1;

    // Protect loading of PF sticky regs during ResetPrep or PF FLR

    end else if (~quiesce_qualifier & ~flr_treatment_vec) begin

        csr_ppaerucs_pre_qual <= csr_ppaerucs_clr;
        csr_ppaercs_pre_qual  <= csr_ppaercs_clr;
    end
end

assign csr_ppaerucs_ff = csr_ppaerucs_pre_qual;
assign csr_ppaercs_ff  = csr_ppaercs_pre_qual;

//-------------------------------------------------------------------------
// Device Status Fatal Error
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_fed_vec_p

    // Fatal errors must be detected pre mask and reported to the CSR
    // FUB for the update of the PPDSTAT CSRs. When a fatal error is
    // detected, the information for which function is sent to the
    // CSR FUB so the proper functions' PPDSAT CSR is updated.

    if (~prim_gated_rst_b)
        err_fed_vec <= '0;
    else
        err_fed_vec <=
            (usr_err_vec_ff   & ur_sev_vec)     |
            (ecrcc_err_vec_ff & ecrcc_sev_vec)  |
            (mtlp_err_vec_ff  & mtlp_sev_vec)   |
            (ec_err_vec_ff    & ec_sev_vec)     |
            (ct_err_vec_ff    & ct_sev_vec)     |
            (ptlpr_err_vec_ff & ptlpr_sev_vec);

end // always_ff err_fed_vec_p

//-------------------------------------------------------------------------
// Device Non-Fatal Error
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_ned_vec_p

    // Non-fatal errors must be detected pre mask and reported to the CSR
    // FUB for the update of the PPDSTAT CSRs. When a non-fatal error is
    // detected, the information for which function is sent to the
    // CSR FUB so the proper functions' PPDSAT CSR is updated.

    if (~prim_gated_rst_b)
        err_ned_vec <= '0;
    else
        err_ned_vec <=
            (usr_err_vec_ff   & ~ur_sev_vec)    |
            (ecrcc_err_vec_ff & ~ecrcc_sev_vec) |
            (mtlp_err_vec_ff  & ~mtlp_sev_vec)  |
            (ec_err_vec_ff    & ~ec_sev_vec)    |
            (ct_err_vec_ff    & ~ct_sev_vec)    |
            (ptlpr_err_vec_ff & ~ptlpr_sev_vec);

end // always_ff err_ned_vec_p

//-------------------------------------------------------------------------
// Device Correctable Error
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: err_ced_vec_p

    // Correctable errors must be detected pre mask and reported to the CSR
    // FUB for the update of the PPDSTAT CSRs. When a non-fatal error is
    // detected, the information for which function is sent to the
    // CSR FUB so the proper functions' PPDSAT CSR is updated.

    if (~prim_gated_rst_b)
        err_ced_vec <= '0;
    else
        err_ced_vec <= anfes_ced;

end // always_ff err_ced_vec_p

//-------------------------------------------------------------------------
// Flopped Advisory Special Case Error Signals
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: cds_usr_err_p

    // Fixing a timing path from reg_off7c -> cds_usr_err_wp -> err_hdr_log3

    if (~prim_gated_rst_b) begin
        cds_pusr_err_ff       <= '0;
        cds_npusr_err_ff      <= '0;
        cds_cfg_usr_func_ff   <= '0;
        cds_bar_decode_err_ff <= '0;
        cds_poison_err_ff     <= '0;
        cds_usr_in_cpl_ff     <= '0;
        cds_malform_pkt_ff    <= '0;
        cpl_poisoned_ff       <= '0;
        cpl_unexpected_ff     <= '0;
        cpl_timeout_ff        <= '0;
    end else begin
        cds_pusr_err_ff       <= cds_pusr_err_wp;
        cds_npusr_err_ff      <= cds_npusr_err_wp;
        cds_cfg_usr_func_ff   <= cds_cfg_usr_func;
        cds_bar_decode_err_ff <= cds_bar_decode_err_wp;
        cds_poison_err_ff     <= cds_poison_err_wp;
        cds_usr_in_cpl_ff     <= cds_usr_in_cpl;
        cds_malform_pkt_ff    <= cds_malform_pkt;
        cpl_poisoned_ff       <= cpl_poisoned;
        cpl_unexpected_ff     <= cpl_unexpected;
        cpl_timeout_ff        <= cpl_timeout;
    end // if !reset


end // always_ff cds_usr_err_p

//-------------------------------------------------------------------------
// Error Mask per Function Vector
//-------------------------------------------------------------------------

always_comb begin: mask_per_err_p

    mask_per_err[IEUNC_EL]  = '0;
    mask_per_err[   UR_EL]  = csr_ppaerucm_wp.ur;
    mask_per_err[ECRCC_EL]  = csr_ppaerucm_wp.ecrcc;
    mask_per_err[ MTLP_EL]  = csr_ppaerucm_wp.mtlp;
    mask_per_err[   RO_EL]  = '0;
    mask_per_err[   EC_EL]  = csr_ppaerucm_wp.ec;
    mask_per_err[   CA_EL]  = csr_ppaerucm_wp.ca;
    mask_per_err[   CT_EL]  = csr_ppaerucm_wp.ct;
    mask_per_err[FCPES_EL]  = '0;
    mask_per_err[PTLPR_EL]  = csr_ppaerucm_wp.ptlpr;
    mask_per_err[ DLPE_EL]  = '0;

    mask_per_err[ IECOR_EL] = '0;
    mask_per_err[ ANFES_EL] = csr_ppaercm_wp.anfes;
    mask_per_err[  RTTS_EL] = '0;
    mask_per_err[  RNRS_EL] = '0;
    mask_per_err[BDLLPS_EL] = '0;
    mask_per_err[ BDLPE_EL] = '0;
    mask_per_err[   RES_EL] = '0;

end // always_comb mask_per_err_p

//-------------------------------------------------------------------------
// Multiple Function Error Mask Logic
//-------------------------------------------------------------------------

always_comb begin: mltfunc_mask_p

    // Create a mask that will prevent any function but the active function
    // from signaling an error an error message. This is used to prevent
    // multiple message to be sent for each of the functions when a given
    // error is signaled and it is not function specific (applies to all
    // functions). Only the active function should generate an error message.
    // This mask is used to suppress the messages from the other functions.

    for(int j=0; j < `HQM_NUM_ERR_SRC; j++) begin

        // if there is a rising edge in the error source signal and the
        // the error source is for the current active function or was not
        // previously masked then the message won't be masked.

        if ((update_hdr_log & log_err_vec[j]) | mltfunc_mask_hold[j])
            mltfunc_mask_pnc[j] = 1'b0;
        else
            mltfunc_mask_pnc[j] = 1'b1;

    end // for j (error sources)

end // always_comb mltfunc_mask_p

//-------------------------------------------------------------------------
// Hold Multi Function Mask Logic
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: mltfunc_mask_hold_p

    // Once the mask for an incoming rising edge error signal has been
    // detected, the mask must be maintained even if the active function
    // changed until the next error signal is received. This logic will
    // allow the multi function mask (mltfunc_mask_pnc) to retain it's state
    // until the next error is received.

    if (~prim_gated_rst_b) begin
        mltfunc_mask_hold <= '0;
    end else begin
        for (int err=0; err < `HQM_NUM_ERR_SRC; err++) begin

          // The error signal with the rising edge is for the active
          // function. Flag it's mask to be maintained

          if (update_hdr_log & log_err_vec[err]) begin

            mltfunc_mask_hold[err] <= 1'b1;

          end else if (update_hdr_log) begin

            // A new error for a different function has been received.
            // Clear the mask hold.

            mltfunc_mask_hold[err] <= 1'b0;

          end

        end // for err (error sources)

    end // else ! reset

end // always_ff mltfunc_mask_hold_p

//-------------------------------------------------------------------------
// ANFES Multi Function Error Mask Hold
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: mltfunc_anfes_hold_p

    // The following logic will ensure that an advisory error masked due
    // to single error, multi function PCIE error requirements, will
    // maintain it's masked state until the PPAERCS.ANFES status is cleared
    // for the given function

    if (~prim_gated_rst_b)
        mltfunc_anfes_hold <= '0;
    else begin

        // If there are multiple functions receiving the same advisory error
        // only one function will send a message for the error. We capture
        // the mask for all functions who should not send the error here on
        // the rising edge of the advisory error edge detect.

        if (ppaercs_anfes && !ppaercs_anfes_ff)
            mltfunc_anfes_hold <= 1'b1;
        // When the ANFES error condition is cleared, then clear the mask
        else if (csr_ppaercs_ff[13])
            mltfunc_anfes_hold <= 1'b0;

    end // always_ff
end // always_ff mltfunc_anfes_hold_p

//-------------------------------------------------------------------------
// Multi Function Advisory Non Fatal Error Mask
//-------------------------------------------------------------------------

always_comb begin: mltfunc_anfes_mask_p

    // Create a mask that will prevent any function but the first advisory
    // function from sending a message

    mltfunc_anfes_mask = ~ppaercs_anfes | mltfunc_anfes_hold;

end // always_comb mltfunc_anfes_mask_p

//-------------------------------------------------------------------------
// Message Arbiter Request Logic
//-------------------------------------------------------------------------

always_comb begin: ppaerucs_req_p

    // The following logic will assert the request signal to the message
    // arbiter based on the PCIE send message rules. Only one message
    // will be sent;
    // 1) in the event of a multiple function error (mltfunc_*_mask)
    // 2) the message has already been sent (*_arb_mask_vec) or
    // 3) the message is currently pending

    //ssabneka added
    ppaerucs_ur_req    = ppaerucs_ur    & ~ur_arb_mask_vec     & ~mltfunc_mask_pnc[   UR_EL] & ~pend_uerr_req[UR];
    ppaerucs_ecrcc_req = ppaerucs_ecrcc & ~ecrcc_arb_mask_vec  & ~mltfunc_mask_pnc[ECRCC_EL] & ~pend_uerr_req[ECRCC];
    ppaerucs_mtlp_req  = ppaerucs_mtlp  & ~mtlp_arb_mask_vec   & ~mltfunc_mask_pnc[ MTLP_EL] & ~pend_uerr_req[MTLP];
    ppaerucs_ec_req    = ppaerucs_ec    & ~ec_arb_mask_vec     & ~mltfunc_mask_pnc[   EC_EL] & ~pend_uerr_req[EC];
    ppaerucs_ct_req    = ppaerucs_ct    & ~ct_arb_mask_vec     & ~mltfunc_mask_pnc[   CT_EL] & ~pend_uerr_req[CT];
    ppaerucs_ptlpr_req = ppaerucs_ptlpr & ~ptlpr_arb_mask_vec  & ~mltfunc_mask_pnc[PTLPR_EL] & ~pend_uerr_req[PTLPR];
    ppaercs_anfes_req  = ppaercs_anfes  & ~anfes_arb_mask_vec  & ~mltfunc_anfes_mask         & ~pend_cerr_req[ANFES];

end // always_comb ppaerucs_req_p

//-------------------------------------------------------------------------
// Per Function Error Log Qualifier
//-------------------------------------------------------------------------

always_comb begin: log_err_vec_p

    // The following is done strictly for the purpose of
    // increading code density. In order to flag the
    // error source for each function which generated the
    // last error message, we'll take the individual error
    // grant signals and assign them to

    // Physical function

    log_err_vec = {
                       1'b0,
                       (csr_ppaerucs.ur    & ~csr_ppaerucm_wp.ur),
                       (csr_ppaerucs.ecrcc & ~csr_ppaerucm_wp.ecrcc),
                       (csr_ppaerucs.mtlp  & ~csr_ppaerucm_wp.mtlp),
                       1'b0,
                       (csr_ppaerucs.ec    & ~csr_ppaerucm_wp.ec),
                       (csr_ppaerucs.ca    & ~csr_ppaerucm_wp.ca),
                       (csr_ppaerucs.ct    & ~csr_ppaerucm_wp.ct),
                       1'b0,
                       (csr_ppaerucs.ptlpr & ~csr_ppaerucm_wp.ptlpr),
                       1'b0,
                       1'b0,
                       (csr_ppaercs.anfes  & ~csr_ppaercm_wp.anfes),
                       5'd0
                     };

end // always_comb log_err_vec_p

//-------------------------------------------------------------------------
// Per Function Error Message Qualifier
//-------------------------------------------------------------------------

always_comb begin: msg_err_vec_p

    // Flag each function which send an error an error message

    msg_err_vec = {
                       1'b0,
                       ppaerucs_ur,
                       ppaerucs_ecrcc,
                       ppaerucs_mtlp,
                       1'b0,
                       ppaerucs_ec,
                       1'b0,
                       ppaerucs_ct,
                       1'b0,
                       ppaerucs_ptlpr,
                       1'b0,
                       1'b0,
                       ppaercs_anfes,
                       1'b0,
                       1'b0,
                       1'b0,
                       1'b0,
                       1'b0
                     };

end // always_comb msg_err_vec_p


//-------------------------------------------------------------------------
// Per Function Error Log Qualifier
// removed correctable errors for header logging only
//-------------------------------------------------------------------------

always_comb begin: log_err_vec_hdr_p

    // The following is done strictly for the purpose of
    // increasing code density. In order to flag the
    // error source for each function which generated the
    // last error message, we'll take the individual error
    // grant signals and assign them to physical function

    log_err_vec_hdr = { {($bits(log_err_vec_hdr)-18){1'b0}},
                        1'b0,
                        (csr_ppaerucs.ur    & ~csr_ppaerucm_wp.ur),
                        (csr_ppaerucs.ecrcc & ~csr_ppaerucm_wp.ecrcc),
                        (csr_ppaerucs.mtlp  & ~csr_ppaerucm_wp.mtlp),
                        1'b0,
                        (csr_ppaerucs.ec    & ~csr_ppaerucm_wp.ec),
                        (csr_ppaerucs.ca    & ~csr_ppaerucm_wp.ca),
                        (csr_ppaerucs.ct    & ~csr_ppaerucm_wp.ct),
                        1'b0,
                        (csr_ppaerucs.ptlpr & ~csr_ppaerucm_wp.ptlpr),
                        8'h0
                      };

end // always_comb log_err_vec_p

//-------------------------------------------------------------------------
// Previous State of the Uncorrectable Error Status
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: log_err_vec_ff_p
    if (~prim_gated_rst_b) begin
        log_err_vec_ff     <= '0;
        log_err_vec_hdr_ff <= '0;
    end else begin
        log_err_vec_hdr_ff <= log_err_vec_hdr;
        log_err_vec_ff     <= log_err_vec;
    end
end // always_ff log_err_vec_ff_p

//-------------------------------------------------------------------------
// Detect a New Header Log
//-------------------------------------------------------------------------

always_comb begin: update_hdr_log_p

    // Detect the rising edges of the error signals. Set the update
    // header log if there is a new error

    update_hdr_log_hdr = |((log_err_vec_hdr ^ log_err_vec_hdr_ff) & log_err_vec_hdr);
    update_hdr_log     = |((log_err_vec     ^ log_err_vec_ff)     & log_err_vec);

end // always_comb update_hdr_log_p

//-------------------------------------------------------------------------

always_comb begin: hdr_log_src_vec_p

    hdr_log_src_vec_pnc = '0;

    hdr_log_src_vec_pnc[    UR_EL] = cds_error_hdr;
    hdr_log_src_vec_pnc[ ECRCC_EL] = lli_chdr_w_err_wp;
    hdr_log_src_vec_pnc[  MTLP_EL] = cds_error_hdr;
    hdr_log_src_vec_pnc[    RO_EL] = '0;
    hdr_log_src_vec_pnc[    EC_EL] = cpl_error_hdr_ff;
    hdr_log_src_vec_pnc[    CA_EL] = '0;
    hdr_log_src_vec_pnc[    CT_EL] = {{($bits(cpl_error_hdr)-$bits(cpl_timeout_synd)){1'b0}}, cpl_timeout_synd_ff};
    hdr_log_src_vec_pnc[ FCPES_EL] = '0;
    hdr_log_src_vec_pnc[ PTLPR_EL] = (cpl_poisoned_ff) ? cpl_error_hdr_ff : cds_error_hdr;
    hdr_log_src_vec_pnc[  DLPE_EL] = '0;
    hdr_log_src_vec_pnc[ ANFES_EL] = cds_error_hdr;
    hdr_log_src_vec_pnc[  RTTS_EL] = '0;
    hdr_log_src_vec_pnc[  RNRS_EL] = '0;
    hdr_log_src_vec_pnc[BDLLPS_EL] = '0;
    hdr_log_src_vec_pnc[ BDLPE_EL] = '0;
    hdr_log_src_vec_pnc[   RES_EL] = '0;
    hdr_log_src_vec_pnc[ IEUNC_EL] = '0; //ssabneka added
    hdr_log_src_vec_pnc[ IECOR_EL] = '0; //ssabneka added

end // always_ff hdr_log_src_vec_p

//-------------------------------------------------------------------------
// Error Log Header Select
//-------------------------------------------------------------------------

always_comb begin: err_log_hdr_p

    // MUX to select the header from the different header error source

    err_log_hdr = '0;

    if (update_hdr_log_hdr) begin

        // Use same priority as the first error pointer in ri_pf_vf_cfg

             if (log_err_vec[   CT_EL]) err_log_hdr = hdr_log_src_vec_pnc[   CT_EL];
        else if (log_err_vec[   RO_EL]) err_log_hdr = hdr_log_src_vec_pnc[   RO_EL];
        else if (log_err_vec[FCPES_EL]) err_log_hdr = hdr_log_src_vec_pnc[FCPES_EL];
        else if (log_err_vec[ DLPE_EL]) err_log_hdr = hdr_log_src_vec_pnc[ DLPE_EL];
        else if (log_err_vec[ECRCC_EL]) err_log_hdr = hdr_log_src_vec_pnc[ECRCC_EL];
        else if (log_err_vec[ MTLP_EL]) err_log_hdr = hdr_log_src_vec_pnc[ MTLP_EL];
        else if (log_err_vec[   UR_EL]) err_log_hdr = hdr_log_src_vec_pnc[   UR_EL];
        else if (log_err_vec[   CA_EL]) err_log_hdr = hdr_log_src_vec_pnc[   CA_EL];
        else if (log_err_vec[   EC_EL]) err_log_hdr = hdr_log_src_vec_pnc[   EC_EL];
        else if (log_err_vec[PTLPR_EL]) err_log_hdr = hdr_log_src_vec_pnc[PTLPR_EL];
        else if (log_err_vec[IEUNC_EL]) err_log_hdr = hdr_log_src_vec_pnc[IEUNC_EL];

    end // if update_hdr_log

end // always_com err_log_hdr_p

//-------------------------------------------------------------------------
// Flopped Advisory Error
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: ppaercs_anfes_ff_p
    if (~prim_gated_rst_b)
        ppaercs_anfes_ff <= '0;
    else
        ppaercs_anfes_ff <= ppaercs_anfes;

end // always_ff ppaercs_anfes_ff_p

//-------------------------------------------------------------------------
// PCISTS.SSE  Error Detection
//-------------------------------------------------------------------------

always_comb begin: sse_err_sig_p

    sse_err_sig = cds_err_msg_gnt &
                  (err_gen_msg_data[7:0] != 8'h30) &
                  (err_gen_msg_func[7:0] == 8'h00) &
                  csr_pcicmd_wp.ser;

end // always_comb sse_err_sig_p

//-------------------------------------------------------------------------
// Advisory Mask Accross All Functions
//-------------------------------------------------------------------------

always_comb begin: anfes_mask_p

    anfes_mask = csr_ppaercm_wp.anfes;

end // always_comb anfes_mask

//-------------------------------------------------------------------------
// Flopped Uncorrectable Errors
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: unc_err_vec_p

    if (~prim_gated_rst_b) begin
        usr_err_vec_ff    <= '0;
        ecrcc_err_vec_ff  <= '0;
        mtlp_err_vec_ff   <= '0;
        ec_err_vec_ff     <= '0;
        ct_err_vec_ff     <= '0;
        ptlpr_err_vec_ff  <= '0;
    end else begin
        usr_err_vec_ff    <= usr_err_vec;
        ecrcc_err_vec_ff  <= ecrcc_err_vec;
        mtlp_err_vec_ff   <= mtlp_err_vec;
        ec_err_vec_ff     <= ec_err_vec;
        ct_err_vec_ff     <= ct_err_vec;
        ptlpr_err_vec_ff  <= ptlpr_err_vec;
    end // if not reset

end // always_ff unc_err_vec_p

// Lint Note 1
// 70036 errors - often sites structures which are only partially used.  No problem there.
// Signal ri_bd_rid_wxp (ri_bd_rid_wxp[1].device[4:0], ri_bd_rid_wxp[2].device[4:0], ri_bd_rid_wxp[3].device[4:0], ri_bd_rid_wxp[4].device[4:0], ri_bd_rid_wxp[5].device[4:0], ri_bd_rid_wxp[6].device[4:0], ri_bd_rid_wxp[7].device[4:0], ri_bd_rid_wxp[8].device[4:0], ri_bd_rid_wxp[9].device[4:0], ri_bd_rid_wxp[10].device[4:0], ri_bd_rid_wxp[11].device[4:0], ri_b
// Signal cpl_error_hdr_wxp (cpl_error_hdr_wxp.wdata, cpl_error_hdr_wxp.ctot) is driven but unused in parent module ri_err (KEY : "cpl_error_hdr_wxp (cpl_error_hdr_wxp.wdata, cpl_error_hdr_wxp.ctot),ri_err" , CONFIG HIERARCHY : "ri")
// Signal csr_pcists_ff (csr_pcists_ff[23:0], csr_pcists_ff[26:25], csr_pcists_ff[1][23:0], csr_pcists_ff[1][26:25], csr_pcists_ff[2][23:0], csr_pcists_ff[2][26:25], csr_pcists_ff[3][23:0], csr_pcists_ff[3][26:25], csr_pcists_ff[4][23:0], csr_pcists_ff[4][26:25], csr_pcists_ff[5][23:0], csr_pcists_ff[5][26:25], csr_pcists_ff[6][23:0], csr_pcists_ff[6][2
// Signal csr_ppaerucs_ff (csr_ppaerucs_ff[3:0], csr_ppaerucs_ff[11:5], csr_ppaerucs_ff[21], csr_ppaerucs_ff[31:23] , csr_ppaerucs_ff[1][3:0], csr_ppaerucs_ff[1][11:5], csr_ppaerucs_ff[1][21], csr_ppaerucs_ff[1][31:23] , csr_ppaerucs_ff[2][3:0], csr_ppaerucs_ff[2][11:5], csr_ppaerucs_ff[2][21], csr_ppaerucs_ff[2][31:23] , csr_ppaerucs_ff[3][3:0],
// Signal csr_ppaercs_ff (csr_ppaercs_ff[5:1], csr_ppaercs_ff[11:9], csr_ppaercs_ff[31:15] , csr_ppaercs_ff[1][12:0], csr_ppaercs_ff[1][31:14] , csr_ppaercs_ff[2][12:0], csr_ppaercs_ff[2][31:14] , csr_ppaercs_ff[3][12:0], csr_ppaercs_ff[3][31:14] , csr_ppaercs_ff[4][12:0], csr_ppaercs_ff[4][31:14] , csr_ppaercs_ff[5][12:0], csr_ppaercs_ff[5][31:14] ,
// Signal err_msg_func (err_msg_func[6]) is driven but unused in parent module ri_err (KEY : "err_msg_func (err_msg_func[6]),ri_err" , CONFIG HIERARCHY : "ri")


//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Assertions
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// PROTO & COVERAGE
// - Cold reset when there are pending errors (Execute a reset with
//   a pending error, come out of reset and successfully detect each of the
//   possible errors sources from all the functions); !sh_ep_pwrgd_np &
//   cds_npusr_err_wp, cds_pusr_err_wp, cds_usr_in_cpl, cds_cfg_usr_func,
//   cds_bar_decode_err_wp, lli_unspp_err_wp, cds_poison_err_wp,
//   cds_err_func, lli_mlfpkt_err_wp,
//   cpl_unexpected_wxp,  cb_tlp_err,
//   cb_uncor_err,
// - Hot reset when there are pending errors (Execute a reset with
//   a pending error, come out of reset and successfully detect each of the
//   possible errors sources from all the functions); !prim_gated_rst_b &
//   cds_npusr_err_wp, cds_pusr_err_wp, cds_usr_in_cpl, cds_cfg_usr_func,
//   cds_bar_decode_err_wp, lli_unspp_err_wp, cds_poison_err_wp,
//   cds_err_func, lli_mlfpkt_err_wp,
//   cpl_unexpected_wxp,  cb_tlp_err,
//   cb_uncor_err,
// - FLR reset when there are pending errors (Execute a reset with
//   a pending error, come out of reset and successfully detect each of the
//   possible errors sources from all the functions); !ri_flr_rxp &
//   (for each function in ri.ri_err) err_usr_unmasked, err_ecrcc_unmasked,
//   err_mtlp_unmasked, err_ec_unmasked,
//   err_ptlpr_unmaksed, err_anfes_unmasked,
// - All correctable error sources are detected; ri.ri_err.pend_cerr_det.
//   Cover each error case with a concurrent pending error;
//   pend_cerr_det[ANFES]
// - All correctable error sources for each function; pend_cerr_det & pend_cerr_func.
// - All correctable error sources with each error severity case;
//   pend_cerr_sev & pend_cerr_det.
// - Back to back pending correctable errors; ri.ri_error.pend_cerr_det & pend_cerr
// - All correctable error sources with simulanteous correctable error sources;
//   pend_uerr_det[UR] & pend_cerr_det[ANFES] ...
//   pend_uerr_det[ECRCC] & pend_cerr_det[ANFES] ...
// - Advisory correctable error message with all CSR enable permutations;
//   ri.ri_err.err_anfes_unmasked & csr_ppaercm_wp.anfes,
// - Bad TLP error message with all CSR enable permutations;
//   csr_ppdcntl_wp.cere, csr_pcicmd_wp.ser
// - All uncorrectable error sources are detected; ri.ri_err.pend_uerr_det.
//   Cover each error case with simultaneous pending errors from other sources;
//   pend_uerr_det[UR] & pend_uerr_det[ECRCC], pend_uerr_det[MTLP] ...
//   pend_uerr_det[ECRCC] & pend_uerr_det[MTLP] ...
// - All uncorrectable error sources detected on each function;
//   ri.ri_err.penduerr_det & pend_uerr_func
// - Uncorrectable errors with and w/o fatal severity; pend_uerr_sev & pend_uerr_det.
// - unsupported request masked for multiple message; mlt_ur_msg_mask &
//   err_usr_unmasked
// - multiple message for ECRCC; mlt_ecrcc_msg_mask & err_ecrcc_unmasked
// - multiple message for malformed packet; mlt_mtlp_msg_mask &
//   err_mtlp_unmasked
// - multiple message masked for unexpected completion; err_ec_unmasked &
//   mlt_ec_msg_masked
// - multiple message masked for poisoned packet; err_ptlpr_unmasked &
//   mlt_ptlpr_msg_masked
// - Unsupported request with csr_ppdcntl_wp.cere/fere/nere/ur and csr_pcicmd_wp.ser/fere CSR enables/disables.
//   err_usr_unmasked and all permutations of; csr_ppdcntl_wp.urro,
//   csr_pcicmd_wp.ser, csr_ppdcntl_wp.fere, csr_ppaerucsev.ur,
//   csr_ppdcntl_wp.nere
// - ECRC with PPDCNTL and PCICMD CSR enables/disables.
//   err_ecrcc_unmasked and all permutations of;
//   csr_pcicmd_wp.ser, csr_ppdcntl_wp.fere, csr_ppaerucsev.ecrcc,
//   csr_ppdcntl_wp.nere
// - Malformed TLP with PPDCNTL and PCICMD CSR enables/disables.
//   err_mtlp_unmasked and all permutations of;
//   csr_pcicmd_wp.ser, csr_ppdcntl_wp.fere, csr_ppaerucsev.mtlp,
//   csr_ppdcntl_wp.nere
// - Unexpected completion with PPDCNTL and PCICMD CSR enables/disables.
//   err_ec_unmasked and all permutations of;
//   csr_pcicmd_wp.ser, csr_ppdcntl_wp.fere, csr_ppaerucsev.ec,
//   csr_ppdcntl_wp.nere
// - Poisoned TLP error  with PPDCNTL and PCICMD CSR enables/disables.
//   err_ptlpr_unmasked and all permutations of;
//   csr_pcicmd_wp.ser, csr_ppdcntl_wp.fere, csr_ppaerucsev.ptlpr,
//   csr_ppdcntl_wp.nere

endmodule // hqm_ri_err

// $Log: hqm_ri_err.sv,v $
// Revision 1.9  2012/10/23 13:12:08  hmccarth
// replaced DV_OFF with RI_DV_OFF
//
// Revision 1.8  2012/06/07 07:57:38  hmccarth
// made fix for ticket 4555988
//
// Revision 1.7  2012/05/24 09:05:23  jkearney
// Related to HSD4555723, Updated err_gen_msg_data to use 6b of function number from update to cds_err_func
//
// Revision 1.6  2012/04/11 13:24:23  jkearney
// Changed ep_function fair_arbs to for loops, corrected tie offs
//
// Revision 1.5  2011/12/22 14:57:17  jkearney
// anfes_mask tieoff
//
// Revision 1.4  2011/12/14 10:09:26  jkearney
// RTL merge MASTER_PRE_TRUNK_MERGE_DEC8_2011
//
// Revision 1.3  2011/11/29 13:35:58  hmccarth
// made act_func_no_err 1 bit per function
//
// Revision 1.2  2011/11/08 14:45:45  hmccarth
// moved error dections to stage 1 of the lli_ctl pipe
//
// Revision 1.1.1.1  2011/09/28 09:03:04  acunning
// import tree
//
// Revision 1.115  2011/07/25 19:44:49  pfleming
// updated with hughs fix for function number in error message reporting
//
// Revision 1.114  2011/07/06 16:35:45  dgfeekes
// Fixed typo in malformed packet mask.
//
// Revision 1.113  2011/06/02 08:57:40  hmccarth
// checked in a fix for ticket 3542350, also split corr an uncorr apart in gen of first_not_fatal
//
// Revision 1.112  2011/06/01 08:45:29  hmccarth
// fix for ticket 3542333 hdr log only updated by unc errors, removed the gate of ppdcntl.cere from the loging of corr errors
//
// Revision 1.111  2011/05/31 07:08:54  dgfeekes
// Fixed a typo in the mask_per_err logic (fix for HSD 3542334). Also added new
// logic for the function number of the correctable errors.
//
// Revision 1.110  2011/05/23 12:04:23  dgfeekes
// Wired out the completion header for poisoned packet error logging.
//
// Revision 1.109  2011/05/22 09:31:15  dgfeekes
// Wired in the completion data parity error into the poisoned error message
// logic (HSD 3542223). Hooked up poisoned packet error detect logic for
// completions (HSD 3542319).
//
// Revision 1.108  2011/05/19 09:25:10  dgfeekes
// Fix the error function for poisoned and completor aborts (HSD 3542282). Also
// Fixed the first_fatal/non_fatal error logic.
//
// Revision 1.107  2011/05/12 09:23:25  dgfeekes
// Completed the virtual function fix for the error message data.
//
// Revision 1.106  2011/05/11 21:17:21  dgfeekes
// One of the function bits were missing from the message data.
//
// Revision 1.105  2011/05/11 15:35:09  dgfeekes
// Modified the code for coverage holes.
//
// Revision 1.104  2011/05/09 08:15:20  dgfeekes
// Fixed an error in the anfes_func MUX.
//
// Revision 1.103  2011/05/05 13:34:56  dgfeekes
// Fixed a typo in the multi function mask for RTTS and RNNS (fix for HSD 3542089).
//
// Revision 1.102  2011/04/29 10:15:17  dgfeekes
// Fixed first_non_fatal and first_fatal so that parity and unsupported errors
// were qualified by URRO and PER.
//
// Revision 1.101  2011/04/28 08:13:35  dgfeekes
// Changed the err_usr_func from a flop to combinatorial.
//
// Revision 1.100  2011/04/27 11:36:41  dgfeekes
// Added err_usr_func to fix the error function number provided in the error
// message for unsupported requests (HSD 3542204).
//
// Revision 1.99  2011/04/26 16:35:13  hmccarth
// checked in a fix for 3542206 3542200 3542194
//
// Revision 1.98  2011/04/21 17:09:16  hmccarth
// added fix for tcikets 3542193 3542194 3542195 3542196
//
// Revision 1.97  2011/04/21 12:29:19  hmccarth
// checked in fix for 3542168
//
// Revision 1.96  2011/04/21 07:58:58  hmccarth
// corrected fix for ticket 3542122 and 3542124
//
// Revision 1.95  2011/04/20 14:08:15  hmccarth
// fixes for tickets 3542124 3542125 3542122
//
// Revision 1.94  2011/04/20 09:00:17  hmccarth
// added fix for ticket 4542120
//
// Revision 1.93  2011/04/18 12:09:12  hmccarth
//  fix for ticket 3542139 and 3542136
//
// Revision 1.92  2011/04/17 09:03:18  dgfeekes
// Fixe bugs in the first fatal and non fatal error detect logic (HSD 3542119 &
// 3542121).
//
// Revision 1.91  2011/04/12 21:59:39  dgfeekes
// Changed the PPDSTAT error source to a vector pre the edge trigger.
//
// Revision 1.90  2011/04/12 07:13:34  dgfeekes
// Added fix for the PPAERUCS and PPAERCS CSR when reporting advirory state due
// to unsupported requests that generate completions with CS set.
//
// Revision 1.89  2011/04/11 12:33:34  dgfeekes
// Removed the no_adv_det and fixed the non_fatal_adv_np_usr for PPSTAT.CED (HSD 3452078)
//
// Revision 1.88  2011/04/11 10:03:56  dgfeekes
// Made additional fix for UR completions generating uncorrectable messages.
//
// Revision 1.87  2011/04/10 20:13:43  dgfeekes
// Added the unsupported requests in the completion error detection to the
// advisory logic.
//
// Revision 1.86  2011/04/06 16:46:34  dgfeekes
// made the first_fatal/non_fatal logic detect a priority mux (fix for HSD 3542068)
//
// Revision 1.85  2011/04/06 13:33:58  dgfeekes
// Cleaned up the advirosy correctable error logic (anfes_ced_vec). Fix for
// HSD 3542060.
//
// Revision 1.84  2011/04/06 07:17:31  dgfeekes
// Created new sse_err_sig (HSD 3542055). Changed memory read lock to be a
// multi function error (HSD 3542073).
//
// Revision 1.83  2011/04/01 06:56:36  dgfeekes
// Made a fix for multi function errors so that multiple message will be sent
// if the error severity differs from one function to the next (HSD 3542054).
//
// Revision 1.82  2011/03/29 12:44:25  dgfeekes
// Added logic to correctly detect and report correctable advisory errors generated
// from unsupported requests that generate completion with error status (HSD 3542022).
//
// Revision 1.81  2011/03/28 07:15:18  dgfeekes
// Added per function error severity to the non fatal PPDSTAT logic and removed
// the fatal enable qualifier.
//
// Revision 1.80  2011/03/24 13:30:47  dgfeekes
// Modified the header log so that it is not updated on masked errors.
//
// Revision 1.78  2011/03/16 19:49:47  dgfeekes
// Changed the header log logic so that headers would now be updated on updates
// to the CSR status.
//
// Revision 1.77  2011/03/16 08:10:01  dgfeekes
// Fix bug where the incorrect function was being used for malformed packets
// (HSD 3541998).
//
// Revision 1.76  2011/03/15 08:58:59  dgfeekes
// Removed the cnd_err_en from the mtlp_err_vec (fix for HSD 3541997).
//
// Revision 1.75  2011/03/10 11:58:56  hmccarth
// added fix for ticket 3541992 and wired num valid vf func to func_valid function
//
// Revision 1.74  2011/03/10 10:56:43  dgfeekes
// Added fix for virtual function error reporting on non function specific errors
// (HSD 3541989).
//
// Revision 1.73  2011/03/04 10:53:58  dgfeekes
// Fixed the SSE bit error reporting (HSD 3541975).
//
// Revision 1.72  2011/03/03 21:25:50  dgfeekes
// csr_ppaercs was not set for the earlier correctable error so non_fatal_adv_np_usr
// should not have been set (Fix for HSD 3541246). Also made a NED FED fix
// (HSD 3541949).
//
// Revision 1.71  2011/02/24 10:53:04  hmccarth
// fix for ticket 3541942 only funcs with anfes_clr_vec asserted will have their non_fatal_adv_ec cleared
//
// Revision 1.70  2011/02/23 09:57:47  hmccarth
// added flops to all tlq inputs to help with timing also added completor ID for unexpected cmpl's
//
// Revision 1.69  2011/02/18 20:18:33  dgfeekes
// Added a temporary fix for the aliasing issues in supported_funcs.
//
// Revision 1.68  2011/02/18 11:45:22  dgfeekes
// Fixed error where DPE was not getting cleared because all the csr_pcists clear
// signals were assigned to the wrong word in the CSR (HSD 3541899). Fixed type in
// the multi function mask using BDLPE_EL (HSD 3541903).
//
// Revision 1.67  2011/02/17 08:15:37  dgfeekes
// Fixed unexpected completions for non valid functions (HSD 3541516).
//
// Revision 1.66  2011/02/15 13:45:28  dgfeekes
// Wired up cto_ec_ud_fnc_wp to drive multi function errors for unexpected
// completions when the function number is illegal (3541516).
//
// Revision 1.65  2011/02/11 17:36:31  dgfeekes
// Fixed another bug in the advisory function logic for multiple function error
// reporting.
//
// Revision 1.64  2011/02/10 07:50:31  dgfeekes
// Made poisoned packets advisory when severity is not set.
//
// Revision 1.63  2011/02/09 14:22:04  dgfeekes
// Fixed bugs in the advisory error detections for MMIO unsupported BARs.
//
// Revision 1.62  2011/02/07 17:31:09  dgfeekes
// Changed BAR misses to multi function errors.
//
// Revision 1.61  2011/02/04 12:12:58  dgfeekes
// Undid the error log 2-3 swap.
//
// Revision 1.60  2011/02/03 12:37:10  dgfeekes
// Removed the unexpected completions advisory change and swapped dword 2 & 3
// is the header log for headers from ri_cds (fix for bug 3541839).
//
// Revision 1.59  2011/02/02 15:45:14  dgfeekes
// Added path from LLI header to the header log for unsupported requests from the LLI.
// (HSD 3541838).
//
// Revision 1.58  2011/02/02 14:32:51  dgfeekes
// Tied off advisory non fatal unexpected completions (HSD 3541822).
//
// Revision 1.57  2011/01/26 19:10:45  dgfeekes
// Changed the FED, NED, CED error status to use the output of the error detection
// logic instead of the input. Also fixed the cb_uncor_err error logic (bug 3541773).
//
// Revision 1.56  2011/01/26 12:58:26  dgfeekes
// Made fix for bug 3541793 where the uncorrectable errors were being masked by
// the mltfunc_mask_pnc and ppdctl.ced was not staying cleared.
//
// Revision 1.55  2011/01/25 14:56:08  dgfeekes
// Fixed misc. fields in the error header log.
//
// Revision 1.54  2011/01/21 09:59:55  hmccarth
// wired ep_disable to ri_err and added ep_disable to func_valid func
//
// Revision 1.53  2011/01/20 16:52:54  dgfeekes
// Flopped the non posted advisory state and set up clearing mechinism.
//
// Revision 1.52  2011/01/20 11:50:35  dgfeekes
// Added logic to allow for unsupported/disabled functions that recieve an
// unsupported request to apply to all functions for advisory non-fatal errors.
//
// Revision 1.51  2011/01/19 14:39:12  dgfeekes
// Re-wrote the single err, multiple function mask logic.
//
// Revision 1.50  2011/01/14 09:06:56  dgfeekes
// Added logic for updating the PPAERUCS error status on correctable errors.
//
// Revision 1.49  2011/01/13 08:37:27  dgfeekes
// Updated the header error log to include header from the decoder.
//
// Revision 1.48  2011/01/11 14:49:51  dgfeekes
// Added multi function error support.
//
// Revision 1.47  2010/12/23 09:03:02  dgfeekes
// Seperated out posted and non posted unexpected completions for non-fatal
// advisory error detection.
//
// Revision 1.46  2010/12/20 15:12:37  hmccarth
// made further error logging changes
//
// Revision 1.45  2010/12/15 13:41:18  hmccarth
// enabled the generations of message for vf functions plus error reproting in the VF PCI express device capabilites register
//
// Revision 1.44  2010/11/24 12:06:05  dgfeekes
// The wrong clear bit was being used for the receiver overflow errors.
//
// Revision 1.43  2010/11/24 09:25:31  dgfeekes
// Added the fatal error detect CSR into the severity logic.
//
// Revision 1.42  2010/10/12 14:02:44  dgfeekes
// Added unsupported function information so that advisory error info was not
// being recorded in ppdstat of the last active function (HSD 3541247).
//
// Revision 1.41  2010/09/15 11:48:33  dgfeekes
// Fixed error in the arbitration of the completion timeout.
//
// Revision 1.40  2010/05/29 20:51:19  dgfeekes
// Fixed timing issue caused by the multiple error detection logic masking the
// errors going into arbitration. One of many fixes done for HSD 3540542.
//
// Revision 1.39  2010/05/27 18:09:54  dgfeekes
// Fixed a lint warning.
//
// Revision 1.38  2010/05/26 05:28:58  dgfeekes
// Fixed lint warnings.
//
// Revision 1.37  2010/05/25 11:27:05  dgfeekes
// Changed the common block correctable errors to fatal and removed the severity
// qualifer from the ppdstat FED field.
//
// Revision 1.36  2010/04/12 07:09:10  dgfeekes
// Divided the completion timeout fair arb between physical and virtual functions
// to fix a timing path.
//
// Revision 1.35  2010/03/09 11:38:57  dgfeekes
// Removed the CB parity error. It was not what it was advertised as (bug 2783749).
//
