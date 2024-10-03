// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_cds
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Sunday Nov 22, 2008
// -- Description :
// -- Command Decode and Schedule
// -- This is the receive interface command address decode and
// -- schedule module. From here, the PCI posted/non posted
// -- completion headers and data are received from the link clock
// -- domain into the cpp clock domain from the transaction layer
// -- queues. The address in the transaction header is decoded to
// -- determine where the command should be issued to. In addition,
// -- this module will schedule the CPP command to the appropriate
// -- target from the posted/non posted PCIE transaction, error
// -- command fub, the interrupt command fub or the CSR CPP command
// -- fub.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_cds
        import hqm_AW_pkg::*, hqm_sif_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_rtlgen_pkg_v12::*,
               hqm_system_type_pkg::*, hqm_system_func_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------
     input  logic                               prim_nonflr_clk             // CPP clock

    ,input  logic                               prim_gated_rst_b            // Active low reset from the SHAC in the P_clk
                                                                            //  domain. This reset will also be synced to the
                                                                            //  link clock domain. This will reset all flops in
                                                                            //  the receive interface.
    ,input  logic                               func_in_rst                 // Per function soft reset

    ,input  logic                               ri_pf_disabled_wxp          // D3 State of physical functions

    ,input  logic                               sif_mstr_quiesce_req        // UR/drop primary NP/P requests

    //-----------------------------------------------------------------
    // TLQ Interface (IOSF Primary Channel Traffic)
    //-----------------------------------------------------------------

    ,input  logic                               tlq_phdrval_wp_2arb         // A posted header is valid
    ,input  tdl_phdr_t                          tlq_phdr_rxp                // The next valid posted header
    ,input  logic                               tlq_nphdrval_wp_2arb        // A non posted header is valid
    ,input  tdl_nphdr_t                         tlq_nphdr_rxp               // The next valid non posted header
    ,input  logic                               tlq_pdataval_wp_2arb        // Posted data is valid
    ,input  tlq_pdata_t                         tlq_pdata_rxp               // The next valid posted data
    ,input  logic                               tlq_npdataval_wp_2arb       // Non posted data is valid
    ,input  tlq_npdata_t                        tlq_npdata_rxp              // The next valid non posted data
    ,input  logic                               tlq_ioqval_wp_2arb          // IOQ data valid
    ,input  tlq_ioqdata_t                       tlq_ioq_data_rxp            
                                                                            //  Bit[0] is not used it seems it not need needed in the decode:
                                                                            //  `HQM_TLQ_IOQ_PH and `HQM_TLQ_IOQ_NPH.
                                                                            // IOQ output data
    ,output logic                               cds_phdr_rd_wp              // Pop a posted header from TLQ
    ,output logic                               cds_nphdr_rd_wp             // Pop a non posted header from TLQ
    ,output logic                               cds_npd_rd_wp               // Pop non posted data from the TLQ
    ,output logic                               cds_pd_rd_wp                // Pop posted data from the TLQ

    //-----------------------------------------------------------------
    // Outbound Completion Interface
    //-----------------------------------------------------------------

    ,input  logic                               obcpl_fifo_afull            // Outbound completion header has been queued
                                                                        
    ,output logic                               obcpl_fifo_push             // Valid outbound completion header
    ,output RiObCplHdr_t                        obcpl_fifo_push_hdr         // The outbound completion header is ready.
    ,output csr_data_t                          obcpl_fifo_push_data        // Internally generated outbound completion data.
    ,output logic                               obcpl_fifo_push_dpar        // Internally generated outbound completion data parity.
    ,output upd_enables_t                       obcpl_fifo_push_enables

    ,output upd_enables_t                       gpsb_upd_enables

    ,input  logic                               ri_bme_rxl                  // Bus Master Enable
    ,input  logic                               csr_pmsixctl_msie_wxp       // MSI-X Enable

    //-----------------------------------------------------------------
    // RI IOSF Sideband Interface
    // (from hqm_ri_iosf_sb or directly from IOSF sideband)
    //-----------------------------------------------------------------
    ,input  hqm_sb_ri_cds_msg_t                 sb_cds_msg                  // Tweaked version of sb_ep_msg for hqm_ri_cds.
    ,input  logic                               err_sb_msgack               // Tells CDS that an error message has been
                                                                            //  granted (eventually to ERR fub)
    // to hqm_ri_iosf_sb block for sideband unsupported requests

    ,output logic                               cds_sb_wrack                // from CDS - ack an incoming write request that has been sent
    ,output logic                               cds_sb_rdack                // from CDS - ack an incoming read request that has been sent
    ,output hqm_cds_sb_tgt_cmsg_t               cds_sb_cmsg                 // Completion message back to the sb_tgt in the shim

    //-----------------------------------------------------------------
    // CSR Interface
    //-----------------------------------------------------------------

    ,input  hdr_addr_t                          csr_pf_bar                  // PF0 MISC BAR
    ,input  hdr_addr_t                          func_pf_bar                 // The PF_FUNC BAR
                                              
    ,input  logic                               csr_stall                   // CSR Control stalled due to Common Block CSR read
    ,input  logic                               csr_pcicmd_mem              // Memory enable from PCICMD CSR
    ,input  logic [2:0]                         ri_mps_rxp                  // Max Payload Size
    ,input  hqm_sif_csr_pkg::HCW_TIMEOUT_t      cfg_hcw_timeout             // Timeout configuration for HCW requests
    ,input  logic                               csr_pasid_enable            // SCIOV enable
    ,input  logic                               cfg_ri_par_off

    // HCW WR Interface

    ,input  logic                               hcw_enq_in_ready
    ,output logic                               hcw_enq_in_v
    ,output hqm_system_enq_data_in_t            hcw_enq_in_data
    ,output logic                               hcw_timeout_error
    ,output logic [7:0]                         hcw_timeout_syndrome

    // Actual RI CSR RD/WR Interface

    ,output logic                               csr_req_wr                  // The CSR write signal
    ,output logic                               csr_req_rd                  // The CSR read  signal
    ,output hqm_system_csr_req_t                csr_req                     // The CSR request signals

    ,input  logic                               csr_rd_data_val_wp          // CSR read data valid
    ,input  csr_data_t                          csr_rd_data_wxp             // The read data from the CSR FUB
    ,input  logic                               csr_rd_ur                   // CSR read UR error
    ,input  logic [1:0]                         csr_rd_error                // CSR read target error (1:pslverr 0:rdata parity err)
    ,input  logic                               csr_rd_sai_error            // CSR read SAI error
    ,input  logic                               csr_rd_timeout_error        // CSR read timeout error

    ,input  logic                               cfg_wr_ur                   // CSR write UR error
    ,input  logic                               csr_wr_error                // CSR write target error (pslverr)
    ,input  logic                               cfg_wr_sai_error            // CFG write SAI error (NP writes - never asserted for MMIO writes)
    ,input  logic                               cfg_wr_sai_ok               // CFG write SAI ok (NP writes - never asserted for MMIO writes)

    ,input  logic                               mmio_wr_sai_error           // MMIO write SAI error (Used for sideband NP memory writes)
    ,input  logic                               mmio_wr_sai_ok              // MMIO write SAI ok (Used for sideband NP memory writes)

    //-----------------------------------------------------------------
    // Devtlb Invalidate Request Interface
    //-----------------------------------------------------------------

    ,output logic                               rx_msg_v
    ,output hqm_devtlb_rx_msg_t                 rx_msg

    //-----------------------------------------------------------------
    // Error Handling Interface
    //-----------------------------------------------------------------

    ,input  logic                               tlq_cds_phdr_par_err
    ,input  logic                               tlq_cds_pdata_par_err
    ,input  logic                               tlq_cds_nphdr_par_err
    ,input  logic                               tlq_cds_npdata_par_err

    // Errors

    ,output cbd_hdr_t                           cds_err_hdr                 // Header of the transaction that generated an error.
    ,output logic                               cds_err_msg_gnt             // Error message scheduled.
    ,output logic                               cds_malform_pkt             // Malformed packet - exceed MPS for memory write
    ,output logic                               cds_npusr_err_wp            // Non posted unsupported request (NP memory request asserted when CBD decode valid, others asserted when tlq_nphdrval_wp)
    ,output logic                               cds_usr_in_cpl              // Unsupported request that generates a completion (asserted when tlq_nphdrval_wp)
    ,output logic                               cds_pusr_err_wp             // Posted unsupported request (asserted when CBD decode valid)
    ,output logic                               cds_cfg_usr_func            // Unsupported function (asserted when tlq_nphdrval_wp)
    ,output logic                               cds_poison_err_wp           // Poisoned config transaction (memory requests assert when CBD decode valid, others when tlq_nphdrval_wp)
    ,output logic                               cds_bar_decode_err_wp       // No valid bar decode

    ,output logic                               set_cbd_hdr_parity_err
    ,output logic                               set_cbd_data_parity_err
    ,output logic                               set_hcw_data_parity_err

    //-----------------------------------------------------------------
    // Misc Outputs
    //-----------------------------------------------------------------

    ,output logic [7:0]                         current_bus                 // Current Bus

    ,output logic                               flr_pending
    ,output logic                               flr_treatment
    ,input  logic                               flr_triggered_wl
    ,input  logic                               flr_function0

    ,output logic                               flr_txn_sent
    ,output nphdr_tag_t                         flr_txn_tag
    ,output hdr_reqid_t                         flr_txn_reqid

    ,input  logic                               ps_d0_to_d3
    ,output logic                               ps_txn_sent
    ,output nphdr_tag_t                         ps_txn_tag
    ,output hdr_reqid_t                         ps_txn_reqid

    ,output logic [6:0]                         ri_hcw_db_status
    ,output logic                               cds_idle
    ,output logic [47:0]                        cds_noa                     // CDS NOA debug signals

    ,output logic                               cds_smon_event
    ,output logic [31:0]                        cds_smon_comp
);

//------------------------------------------------------------------------------------
// Local Support Signals
//------------------------------------------------------------------------------------

logic                                   flr_triggered_q;
logic [1:0]                             flr_treatment_q;
logic                                   flr_pending_q;

logic [1:0]                             prim_side_arb_reqs;
logic                                   prim_side_arb_update;
logic                                   prim_side_arb_winner_v;
logic                                   prim_side_arb_winner_v_next;
logic                                   prim_side_arb_winner;
logic                                   prim_side_arb_winner_next;
logic                                   prim_side_arb_winner_q;
logic                                   prim_side_arb_hold_next;
logic                                   prim_side_arb_hold_q;

logic                                   sb_cds_taken_next;
logic                                   sb_cds_taken_q;
logic                                   sb_cds_rd_q;
logic                                   sb_cds_wr_q;
logic [7:0]                             sb_cds_fid_q;

logic                                   cds_sb_ack_q;

logic                                   tlq_phdrval_wp;             // A posted header is valid
logic                                   tlq_nphdrval_wp;            // A non posted header is valid
logic                                   tlq_pdataval_wp;            // Posted data is valid
logic                                   tlq_npdataval_wp;           // Non posted data is valid
logic                                   tlq_ioqval_wp;              // IOQ data valid

logic                                   sb_cds_msg_irdy;            // transaction is available on sideband

logic                                   ph_wodval_in_tlq;           // Posted header w/o data ready in TLQ
logic                                   ph_wdval_in_tlq;            // Posted header w/  data ready in TLQ

logic                                   nph_wdval_in_tlq;           // Non posted w/ data header ready in TLQ
logic                                   nph_wodval_in_tlq;          // Non posted w/o data header ready in TLQ

logic                                   nxt_ioq_cmd_cfg_rd;         // Next command from IOQ is a CFG read
logic                                   nxt_ioq_cmd_cfg_wr;         // Next command from IOQ is a CFG write
logic                                   nxt_ioq_cmd_cfg;            // Next command from IOQ is a CFG read or write
logic                                   nxt_ioq_cmd_mem_rd;         // Next command from IOQ is a MMIO read
logic                                   nxt_ioq_cmd_mem_wr;         // Next command from IOQ is a MMIO write
logic                                   nxt_ioq_cmd_p_msg_d;        // Next command from IOQ is a MsgD
logic                                   nxt_ioq_cmd_np_usr_d;
logic                                   nxt_ioq_cmd_np_usr_nd;
logic                                   nxt_ioq_cmd_p_usr_d;
logic                                   nxt_ioq_cmd_p_usr_nd;
logic                                   nxt_ioq_cmd_np;
logic                                   nxt_ioq_cmd_p;

logic                                   cds_hdr_v;                  // Header is valid
logic                                   cds_hdr_v_wdata;            // Queue an address to decode, all posted write data available
cbd_hdr_t                               cds_hdr;                    // The header associated with address being sent to decode
logic                                   cds_hdr_mmio;               // The cds_hdr is not a CFG transaction
logic                                   cds_hdr_check;              // The cds_hdr requires decoding
tlq_pdata_t                             cds_wr_data;                // The transaction write data that goes with the header.
tlq_pdata_t                             cds_wr_data2;               // The transaction write data (2nd beat) that goes with the header.
logic                                   cds_hdr_perr;

logic                                   iosfsb_mmio_txn;
logic [2:0]                             iosfsb_mmio_bar;
logic [7:0]                             iosfsb_mmio_fid;

logic                                   cds_cbd_v;

logic                                   cds_take_decode;            // Signal the address decode is taken

logic                                   cbd_bar_miss_err_wp;        // BAR miss error
logic                                   cbd_rdy;                    // BAR decode is ready
logic                                   cbd_busy;                   // BAR decode is busy
logic [3:0]                             cbd_decode_val;             // BAR decode complete
logic [1:0]                             cbd_func_pf_bar_hit;
logic                                   cbd_csr_pf_bar_hit;
logic [1:0]                             cbd_func_pf_rgn_hit;
logic [1:0]                             cbd_csr_pf_rgn_hit;
logic [31:2]                            cbd_bar_offset;             // Address offset from the BAR.
logic                                   cbd_bar_offset_par;         // Parity on the bar offset
cbd_hdr_t                               cbd_hdr;                    // The header associated with the address in the BAR
logic                                   cbd_hdr_mmio;
logic                                   cbd_hdr_iosfsb;
tlq_pdata_t                             cbd_wr_data;                // Write data associated with the last header that completed decoded.
tlq_pdata_t                             cbd_wr_data2;               // Write data (2nd beat) associated with the last header that completed decoded.
logic                                   cbd_parity_err;

logic [7:0]                             cbd_cfg_func;
logic                                   cbd_cfg_func_valid;

logic                                   mem_hit_csr_pf_rgn;         // PCIE mem NP tran to EP CSR space
logic                                   mem_hit_func_pf_hcw_rgn;    // PCIE mem NP tran to EP CSR space
logic                                   mem_hit_func_pf_cfg_rgn;    // PCIE mem NP tran to EP CSR space
logic                                   mem_req_good;
logic                                   mem_rd;
logic                                   mem_wr;
logic                                   mem_csr_wr_req;             // Non posted memory write to CSR
logic                                   mem_csr_rd_req;             // Non posted memory read to CSR
logic                                   mem_func_pf_hcw_wr_req;     // Non posted memory write to CSR
logic                                   mem_func_pf_cfg_wr_req;     // Non posted memory write to CSR
logic                                   mem_func_pf_cfg_rd_req;     // Non posted memory read to CSR
logic                                   mem_mps_err;                // Posted MPS violation
logic                                   mem_prim_quiesce;           // Primary memory access when quiesced
logic                                   mem_bad_addr;               // Address in the command completed decode is in error.
logic                                   mem_bad_len_be;             // Unsupported mem length or byte enable
logic                                   mem_bad_region;             // Unsupported mem address for HCW
logic                                   mem_in_d3;                  // memory request while in d3
logic                                   mem_req_gen_usr;            // Unsupported request completion from mem or IO access.
logic                                   mem_cbd_hit;                // CDB memory transaction hit a bar

logic                                   cbd_drop_hpar;
logic                                   cbd_drop_flr_p;
logic                                   cbd_drop_flr_np;
logic                                   cbd_drop_flr;
logic                                   cbd_poisoned_p;
logic                                   cbd_poisoned_np;
logic                                   cbd_poisoned;
logic                                   cbd_cfg_rd;
logic                                   cbd_cfg_wr;
logic                                   cbd_cfg_req;
logic                                   cbd_cfg_req_good;
logic                                   cbd_cfg_usr_func;           // Unsupported function
logic                                   cbd_cfg_sb_bad_len;
logic                                   cbd_multi_bar_hit_err_wp;
hqm_pcie_type_e_t                       cbd_hdr_pciecmd;
logic                                   cbd_hdr_pciecmd_mrd;
logic                                   cbd_hdr_pciecmd_mrdlk;
logic                                   cbd_hdr_pciecmd_io;
logic                                   cbd_hdr_pciecmd_atomic_1op;
logic                                   cbd_hdr_pciecmd_atomic_2op;
logic                                   cbd_hdr_pciecmd_msgd;
logic                                   cds_pdw_size_err_wp;        // Data size error.
logic                                   cbd_cfg_prim_quiesce;       // Primary CFG access when quiesced

logic                                   cds_usr_in_cpl_next;
logic                                   cds_pusr_err_next;
logic                                   cds_npusr_err_next;
logic                                   cds_malform_pkt_next;
logic                                   cds_poison_err_next;
logic                                   cds_cfg_usr_func_next;
logic                                   cds_bar_decode_err_next;
logic                                   cds_err_next;
logic [2:0]                             cds_err_stall_q;
logic                                   cds_err_stall;

logic                                   prim_quiesce;               // Quiesce Primary

logic                                   dec_mmio_wr_req;            // Decode CSR write request
logic                                   dec_mmio_rd_req;            // Decode CSR read request
logic                                   dec_cbd_cfg_rd;
logic                                   dec_cbd_cfg_wr;

logic                                   hcw_wr_rdy;                 // Ready to accept HCW write
logic                                   hcw_wr_wp;                  // HCW write
hcw_wr_hdr_t                            hcw_wr_hdr;                 // HCW write header
tlq_pdata_t                             hcw_wr_data;                // First beat of write data
tlq_pdata_t                             hcw_wr_data2;               // Second beat of write data

logic                                   hcw_wr_buff_rdy;            // Ready to accept HCW write
logic                                   hcw_wr_buff_wp;             // HCW write
hcw_wr_hdr_t                            hcw_wr_buff_hdr;            // HCW write header
tlq_pdata_t                             hcw_wr_buff_data;           // First beat of write data
tlq_pdata_t                             hcw_wr_buff_data2;          // Second beat of write data

logic                                   hcw_timeout_next;
logic                                   hcw_timeout_q;              // HCW write timeout
logic [31:0]                            hcw_cnt_next;
logic [31:0]                            hcw_cnt_q;

inbound_hcw_t                           hcw[3:0];                   // cbd_wr_data as hcw type

localparam  HCW_ENQ_IDLE_BIT    = 0;
localparam  HCW_ENQ_1_HCW_BIT   = 1;
localparam  HCW_ENQ_2_HCW_BIT   = 2;
localparam  HCW_ENQ_3_HCW_BIT   = 3;

typedef enum logic [3:0] {
  HCW_ENQ_IDLE              = 4'h1,
  HCW_ENQ_1_HCW             = 4'h2,
  HCW_ENQ_2_HCW             = 4'h4,
  HCW_ENQ_3_HCW             = 4'h8
} hqm_hcw_enq_state_t;

hqm_hcw_enq_state_t                     hcw_enq_state;
hqm_hcw_enq_state_t                     hcw_enq_state_next;
logic                                   hcw_enq_state_err_nc;

inbound_hcw_t                           hcw_enq_hcw;
logic [3:0]                             hcw_enq_par;
logic                                   hcw_enq_par_error;

logic                                   cds2ob_cfg_req;             // Config outbound completion completion
logic                                   cds2ob_mmio_req;            // MMIO outbound completion completion
logic                                   cds2ob_uns_np_req;
logic                                   cds2ob_uns_func_req;

logic                                   cbd_uns_pcmd;               // An unsupported posted command received
logic                                   cbd_msg_drop;               // Detect MSG requests that should just be dropped
logic                                   cbd_uns_npcmd;              // An unsupported non-posted command received
logic                                   cbd_uns_cmd;                // An unsupported command received

logic                                   usr_npmem_req;              // Non posted unsupported memory request
logic                                   usr_pmem_req;               // Posted Unsupported memory request

logic                                   pend_cfg_rd;                // The pending CSR outbound completion header is a read
logic                                   pend_cfg_wr;                // The pending CSR outbound completion header is a write
logic                                   pend_mmio_rd;               // The pending MMIO outbound completion header is a read
logic                                   pend_mmio_wr;               // The pending MMIO outbound completion header is a write
logic                                   pend_iosf_sb_rd;
logic                                   pend_iosf_sb_wr;
logic                                   np_csr_obc_stall;           // NP CSR command sent but the completion has not been sent

logic                                   mmio_wr_done;

logic                                   last_csr_rd_ur;             // The UR error indication from last read from the CSR FUB.
logic                                   last_csr_rd_sai_error;      // The sai error indication from last read from the CSR FUB.
logic                                   last_csr_rd_timeout_error;  // The timeout error indication from last read from the CSR FUB.
csr_data_t                              last_cfg_rd_data;           // The data last read from the CSR FUB.
logic                                   last_cfg_wr_ur;             // The UR error indication from last write from the CSR FUB.
logic                                   last_cfg_wr_sai_error;      // The sai error indication from last CFG write (NP) from the CSR FUB.

RiObCplHdr_t                            cds2ob_cplhdr;              // Outbound completion header
RiObCplHdr_t                            cds2ob_err_cplhdr;          // Outbound completion header for USR and CA errors
csr_data_t                              cds_cfg2ob_data_wxp;        // CSR outbound completion data.
logic                                   cds_cfg2ob_dpar_wxp;        // CSR outbound completion data parity.
                                                                    // MSIX table read data
logic                                   pdata_first_cycle;          // Indicates first cycle of posted data
logic                                   pdata_second_cycle;         // Indicates second cycle of posted data
logic                                   pdata_last_cycle;           // Indicates last cycle of posted data
tlq_pdata_t                             pdata_first_cycle_data;     // save first cycle of posted data

logic                                   pd_queue_flush;
logic [7:0]                             pd_cnt_nxt;
logic [7:0]                             pd_cnt;
logic                                   pd_par_err_or;

logic                                   npdata_first_cycle;         // Indicates first cycle of non-posted data
logic                                   npdata_last_cycle;          // Indicates last cycle of non-posted data
logic [`HQM_CSR_SIZE-1:0]               npdata_first_cycle_data;    // save first cycle of non-posted data
logic [(`HQM_CSR_SIZE/32)-1:0]          npdata_first_cycle_data_par;
logic [`HQM_CSR_SIZE-1:0]               np_wr_data;                 // non-posted write data
logic [(`HQM_CSR_SIZE/32)-1:0]          np_wr_data_par;

logic                                   flush_cds_npd_rd_wp;
logic                                   last_cds_npd_rd_wp;
logic                                   npd_queue_flush;
logic [7:0]                             npd_cnt_nxt;
logic [7:0]                             npd_cnt;

logic                                   cds_sb_rdack_next;
logic                                   cds_sb_wrack_next;
logic                                   cds_sb_rd_ur_next;
logic                                   cds_sb_wr_ur_next;
logic                                   cds_sb_rd_ur;
logic                                   cds_sb_wr_ur;
logic                                   cds_sb_np;
logic [31:0]                            cds_sb_rddata;

logic                                   func_in_rst_q;

//------------------------------------------------------------------------------------
// Add a flop that sets when an FLR has been initiated (write of the startflr bit)
// and remains set until the internal FLR pulse has completed (rising edge of pulse).
// Use this to force any incoming transactions to look unsupported during the FLR.
// The case in the CDS is special because we need to wait until we've sent the
// completion for the FLR to the OBC block. The flr_pending flop sets and holds until
// the OB completion is granted and only then can the flr_treatment flop be set.

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    flr_triggered_q <= '1;
    flr_pending_q   <= '0;
    flr_treatment_q <= '0;
  end else begin
    flr_triggered_q <= flr_triggered_wl;
    flr_pending_q   <= (flr_function0 | flr_pending_q) & ~cds2ob_cfg_req;
    flr_treatment_q <= {2{((flr_pending_q & cds2ob_cfg_req) | flr_treatment_q[0]) &
        ~(flr_triggered_wl & ~flr_triggered_q)}};
  end
end

assign flr_pending   = flr_pending_q;
assign flr_treatment = flr_treatment_q[1];

//------------------------------------------------------------------------------------
// Logic to monitor startflr and PS writes
//------------------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: flr_reqid_tag_p
    if (~prim_gated_rst_b) begin
        flr_txn_sent                    <= '0;
        flr_txn_tag                     <= '0;
        flr_txn_reqid                   <= '0;
    end else if (flr_function0) begin
        flr_txn_sent                    <= flr_function0;
        flr_txn_tag                     <= cbd_hdr.tag;
        flr_txn_reqid                   <= cbd_hdr.reqid;
    end else begin
        flr_txn_sent                    <= '0;
        flr_txn_tag                     <= flr_txn_tag;
        flr_txn_reqid                   <= flr_txn_reqid;
    end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: ps_reqid_tag_p
    if (~prim_gated_rst_b) begin
        ps_txn_sent                     <= '0;
        ps_txn_tag                      <= '0;
        ps_txn_reqid                    <= '0;
    end else if (ps_d0_to_d3) begin
        ps_txn_sent                     <= '1;
        ps_txn_tag                      <= cbd_hdr.tag;
        ps_txn_reqid                    <= cbd_hdr.reqid;
    end else begin
        ps_txn_sent                     <= '0;
        ps_txn_tag                      <= ps_txn_tag;
        ps_txn_reqid                    <= ps_txn_reqid;
    end

end

//------------------------------------------------------------------------------------
// Arbitration SB and PC
//------------------------------------------------------------------------------------

// Sideband irdy stays up an additional cycle after the ack, so mask that cycle

assign prim_side_arb_reqs = {tlq_ioqval_wp_2arb,
                             (sb_cds_msg.irdy & ~sb_cds_taken_q & ~cds_sb_ack_q &
                                (sb_cds_msg.mmiowr | sb_cds_msg.mmiord |
                                 sb_cds_msg.cfgwr  | sb_cds_msg.cfgrd)
                             )
                            };

hqm_AW_wrr_arbiter #(.NUM_REQS(2), .WEIGHT_WIDTH(4)) i_prim_side_arb (

     .clk           (prim_nonflr_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd3)
    ,.update        (prim_side_arb_update)

    ,.weights       ({4'd10, 4'd0})

    ,.reqs          (prim_side_arb_reqs)

    ,.winner_v      (prim_side_arb_winner_v_next)
    ,.winner        (prim_side_arb_winner_next)
);

assign prim_side_arb_update = prim_side_arb_winner_v &
    ((prim_side_arb_winner) ? (cds_nphdr_rd_wp | cds_phdr_rd_wp) :
                              (cds_sb_wrack    | cds_sb_rdack));

assign prim_side_arb_hold_next = (prim_side_arb_winner_v_next | prim_side_arb_hold_q) &
    ~prim_side_arb_update;

assign sb_cds_taken_next = (sb_cds_taken_q | (sb_cds_msg_irdy & cbd_rdy)) &
                            ~(cds_sb_wrack | cds_sb_rdack);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin
        prim_side_arb_hold_q   <= '0;
        prim_side_arb_winner_q <= '0;
        sb_cds_taken_q         <= '0;
        sb_cds_rd_q            <= '0;
        sb_cds_wr_q            <= '0;
        cds_sb_ack_q           <= '0;
        sb_cds_fid_q           <= '0;
    end else begin
        prim_side_arb_hold_q   <= prim_side_arb_hold_next;
        prim_side_arb_winner_q <= prim_side_arb_winner_next;
        sb_cds_taken_q         <= sb_cds_taken_next;
        cds_sb_ack_q           <= cds_sb_wrack | cds_sb_rdack;
        if (sb_cds_msg_irdy & cbd_rdy) begin
            sb_cds_rd_q        <= sb_cds_msg.mmiord | sb_cds_msg.cfgrd;
            sb_cds_wr_q        <= sb_cds_msg.mmiowr | sb_cds_msg.cfgwr;
            sb_cds_fid_q       <= sb_cds_msg.fid;
        end
    end
end

assign prim_side_arb_winner_v = prim_side_arb_winner_v_next | prim_side_arb_hold_q;

assign prim_side_arb_winner   = (prim_side_arb_hold_q) ? prim_side_arb_winner_q :
                                                         prim_side_arb_winner_next;

always_comb begin: arb_reqs_gen_p

    tlq_phdrval_wp       = '0;
    tlq_nphdrval_wp      = '0;
    tlq_pdataval_wp      = '0;
    tlq_npdataval_wp     = '0;
    tlq_ioqval_wp        = '0;
    sb_cds_msg_irdy      = '0;

    if (prim_side_arb_winner_v) begin

      if (prim_side_arb_winner) begin

        tlq_phdrval_wp   = tlq_phdrval_wp_2arb;
        tlq_pdataval_wp  = tlq_pdataval_wp_2arb;
        tlq_nphdrval_wp  = tlq_nphdrval_wp_2arb;
        tlq_npdataval_wp = tlq_npdataval_wp_2arb;
        tlq_ioqval_wp    = tlq_ioqval_wp_2arb;

      end else begin

        sb_cds_msg_irdy  = sb_cds_msg.irdy & ~sb_cds_taken_q & ~cds_sb_ack_q;

      end

    end

end

//-------------------------------------------------------------------------
// Decode transaction types
//-------------------------------------------------------------------------

always_comb begin

    nph_wodval_in_tlq = tlq_nphdrval_wp  & tlq_ioqval_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_NPH];

    nph_wdval_in_tlq  = tlq_nphdrval_wp  & tlq_ioqval_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_NPH] &
                       (tlq_npdataval_wp & npdata_last_cycle);

    ph_wodval_in_tlq  = tlq_phdrval_wp   & tlq_ioqval_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_PH];

    ph_wdval_in_tlq   = tlq_phdrval_wp   & tlq_ioqval_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_PH]  &
                        tlq_pdataval_wp;

    // Decode non-posted transactions

    nxt_ioq_cmd_mem_rd    = nph_wodval_in_tlq & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_MEM_RD);
    nxt_ioq_cmd_cfg_rd    = nph_wodval_in_tlq & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_CFG_RD);
    nxt_ioq_cmd_cfg_wr    = nph_wdval_in_tlq  & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_CFG_WR);
    nxt_ioq_cmd_np_usr_d  = nph_wdval_in_tlq  & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_USR_D);
    nxt_ioq_cmd_np_usr_nd = nph_wodval_in_tlq & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_USR_ND);

    // Decode posted transactions

    nxt_ioq_cmd_mem_wr    = ph_wdval_in_tlq   & (tlq_phdr_rxp.cmd  == `HQM_TDL_PHDR_WR);
    nxt_ioq_cmd_p_msg_d   = ph_wdval_in_tlq   & (tlq_phdr_rxp.cmd  == `HQM_TDL_PHDR_MSG_D);
    nxt_ioq_cmd_p_usr_d   = ph_wdval_in_tlq   & (tlq_phdr_rxp.cmd  == `HQM_TDL_PHDR_USR_D);
    nxt_ioq_cmd_p_usr_nd  = ph_wodval_in_tlq  & (tlq_phdr_rxp.cmd  == `HQM_TDL_PHDR_USR_ND);

    // Categories of transactions

    nxt_ioq_cmd_cfg       = nxt_ioq_cmd_cfg_wr   | nxt_ioq_cmd_cfg_rd;

    nxt_ioq_cmd_p         = nxt_ioq_cmd_mem_wr   | nxt_ioq_cmd_p_msg_d |
                            nxt_ioq_cmd_p_usr_d  | nxt_ioq_cmd_p_usr_nd;

    nxt_ioq_cmd_np        = nxt_ioq_cmd_mem_rd   | nxt_ioq_cmd_cfg_rd  | nxt_ioq_cmd_cfg_wr |
                            nxt_ioq_cmd_np_usr_d | nxt_ioq_cmd_np_usr_nd;

end

//-------------------------------------------------------------------------
// The header is staged along with the decode for memory reads and writes.
// The following mux selects the header from the posted or nonposted TLQ
// to be sent to decode.
//-------------------------------------------------------------------------

always_comb begin: cds_hdr_p

    cds_hdr_v       = '0;
    cds_hdr_v_wdata = '0;
    cds_hdr_mmio    = '0;
    cds_hdr_check   = '0;
    cds_hdr         = '0;
    cds_hdr_perr    = '0;

    if (sb_cds_msg_irdy) begin // Sideband

        cds_hdr_v        = cbd_rdy;
        cds_hdr_v_wdata  = cds_hdr_v;
        cds_hdr_mmio     = sb_cds_msg.mmiowr | sb_cds_msg.mmiord;
        cds_hdr_check    = sb_cds_msg.mmiowr | sb_cds_msg.mmiord;
        cds_hdr_perr     = '0;

        cds_hdr.sai      = sb_cds_msg.sai;
        cds_hdr.attr     = '0;
        cds_hdr.tc       = '0;
        cds_hdr.posted   = ~sb_cds_msg.np;
        cds_hdr.fmt      = '0;
        cds_hdr.ttype    = '0;
        cds_hdr.poison   = '0;
        cds_hdr.addr     = {{($bits(cds_hdr.addr)-$bits(sb_cds_msg.addr)){1'b0}},
                            sb_cds_msg.addr};
        cds_hdr.tag      = '0;
        cds_hdr.reqid    = '0;
        cds_hdr.endbe    = sb_cds_msg.sbe;
        cds_hdr.startbe  = sb_cds_msg.fbe;
        cds_hdr.length   = 10'h1 + {9'b0, |sb_cds_msg.sbe};
        cds_hdr.cmd      = (sb_cds_msg.mmiowr) ?
                              ((sb_cds_msg.np) ? `HQM_TDL_NPHDR_MEM_WR :
                                                 `HQM_TDL_PHDR_WR)     :
                          ((sb_cds_msg.mmiord) ? `HQM_TDL_NPHDR_MEM_RD :
                          ((sb_cds_msg.cfgwr)  ? `HQM_TDL_NPHDR_CFG_WR :
                                                 `HQM_TDL_NPHDR_CFG_RD));
        cds_hdr.pasidtlp = '0;
        cds_hdr.iosfsb   = '1;

        cds_hdr.addr_par = ^(sb_cds_msg.addr);

        cds_hdr.par      = ^{sb_cds_msg.sai
                            ,sb_cds_msg.np  // inverting sense to cover set iosfsb bits
                            ,sb_cds_msg.sbe
                            ,sb_cds_msg.fbe
                            ,cds_hdr.length
                            ,cds_hdr.cmd};

    end else if (nxt_ioq_cmd_p) begin // Posted

        cds_hdr_v        = cbd_rdy;
        cds_hdr_v_wdata  = cds_hdr_v & (pdata_last_cycle | (tlq_phdr_rxp.length <= 'd8));
        cds_hdr_mmio     = '1;
        cds_hdr_check    = nxt_ioq_cmd_mem_wr;
        cds_hdr_perr     = tlq_cds_phdr_par_err;

        cds_hdr.sai      = tlq_phdr_rxp.sai;
        cds_hdr.attr     = '0;
        cds_hdr.tc       = '0;
        cds_hdr.posted   = '1;
        cds_hdr.fmt      = tlq_phdr_rxp.fmt;
        cds_hdr.ttype    = tlq_phdr_rxp.ttype;
        cds_hdr.poison   = tlq_phdr_rxp.poison | pd_par_err_or | tlq_cds_pdata_par_err;
        cds_hdr.addr     = tlq_phdr_rxp.addr;
        cds_hdr.tag      = {2'd0, tlq_phdr_rxp.tag};
        cds_hdr.reqid    = tlq_phdr_rxp.reqid;
        cds_hdr.endbe    = tlq_phdr_rxp.endbe;
        cds_hdr.startbe  = tlq_phdr_rxp.startbe;
        cds_hdr.length   = tlq_phdr_rxp.length;
        cds_hdr.cmd      = tlq_phdr_rxp.cmd;
        cds_hdr.pasidtlp = tlq_phdr_rxp.pasidtlp;
        cds_hdr.iosfsb   = '0;

        cds_hdr.addr_par = ^tlq_phdr_rxp.addr_par;

        cds_hdr.par      = ^{(~tlq_phdr_rxp.cmdlen_par) // invert to account for posted bit being set
                            ,  tlq_phdr_rxp.par
                            ,(~tlq_phdr_rxp.poison & (pd_par_err_or | tlq_cds_pdata_par_err))};

    end else if (nxt_ioq_cmd_np) begin // Non-Posted

        cds_hdr_v        = cbd_rdy;
        cds_hdr_v_wdata  = cds_hdr_v & (nxt_ioq_cmd_mem_rd    |
                                        nxt_ioq_cmd_cfg_rd    |
                                        nxt_ioq_cmd_np_usr_nd |
                                        npdata_last_cycle     |
                                        (tlq_nphdr_rxp.length <= 'd8));
        cds_hdr_mmio     = ~nxt_ioq_cmd_cfg;
        cds_hdr_check    = nxt_ioq_cmd_mem_rd;
        cds_hdr_perr     = tlq_cds_nphdr_par_err;

        cds_hdr.sai      = tlq_nphdr_rxp.sai;
        cds_hdr.attr     = tlq_nphdr_rxp.attr;
        cds_hdr.tc       = tlq_nphdr_rxp.tc;
        cds_hdr.posted   = '0;
        cds_hdr.fmt      = tlq_nphdr_rxp.fmt;
        cds_hdr.ttype    = tlq_nphdr_rxp.ttype;
        cds_hdr.poison   = tlq_nphdr_rxp.poison | tlq_cds_npdata_par_err;
        cds_hdr.addr     = {tlq_nphdr_rxp.addr, 2'd0};
        cds_hdr.tag      = tlq_nphdr_rxp.tag;
        cds_hdr.reqid    = tlq_nphdr_rxp.reqid;
        cds_hdr.endbe    = tlq_nphdr_rxp.endbe;
        cds_hdr.startbe  = tlq_nphdr_rxp.startbe;
        cds_hdr.length   = tlq_nphdr_rxp.length;
        cds_hdr.cmd      = tlq_nphdr_rxp.cmd;
        cds_hdr.pasidtlp = tlq_nphdr_rxp.pasidtlp;
        cds_hdr.iosfsb   = '0;

        cds_hdr.addr_par = ^tlq_nphdr_rxp.addr_par;

        cds_hdr.par      = ^{  tlq_nphdr_rxp.cmdlen_par
                            ,  tlq_nphdr_rxp.par
                            ,(~tlq_nphdr_rxp.poison & tlq_cds_npdata_par_err)};

    end

end

assign iosfsb_mmio_txn = sb_cds_msg_irdy & |{sb_cds_msg.mmiord, sb_cds_msg.mmiowr};
assign iosfsb_mmio_bar = sb_cds_msg.bar;
assign iosfsb_mmio_fid = sb_cds_msg.fid;

// Throwing away primary P or NP transactions that have a non-cmd/len parity error
// by forcing them to not look valid to the ri_cbd.
// Note that transactions with a cmd/len parity error are already forced not valid
// in the ri_tlq which effectively locks the pipeline there (stop_and_scream).

assign cds_cbd_v = cds_hdr_v_wdata & ~cds_hdr_perr;

assign cds_smon_event = cds_hdr_v_wdata;

assign cds_smon_comp  = {cds_hdr.pasidtlp[15:0] // 31:16
                        ,cds_hdr.iosfsb[0]      //    15
                        ,cds_hdr.fmt            // 14:13
                        ,cds_hdr.ttype          // 12: 8
                        ,cds_hdr.sai            //  7: 0
};

//-----------------------------------------------------------------
// CBD Control BAR Decode. Logic for decoding the incoming address
// and signaling which BAR it hits.
//-----------------------------------------------------------------

hqm_ri_cbd i_ri_cbd (

     .prim_nonflr_clk                       (prim_nonflr_clk)
    ,.prim_gated_rst_b                      (prim_gated_rst_b)

    ,.cds_hdr_v                             (cds_cbd_v)
    ,.cds_hdr                               (cds_hdr)
    ,.cds_hdr_mmio                          (cds_hdr_mmio)
    ,.cds_hdr_check                         (cds_hdr_check)
    ,.cds_wr_data                           (cds_wr_data)
    ,.cds_wr_data2                          (cds_wr_data2)

    ,.cds_take_decode                       (cds_take_decode)

    ,.iosfsb_mmio_txn                       (iosfsb_mmio_txn)
    ,.iosfsb_mmio_bar                       (iosfsb_mmio_bar)
    ,.iosfsb_mmio_fid                       (iosfsb_mmio_fid)

    ,.func_pf_bar                           (func_pf_bar)
    ,.csr_pf_bar                            (csr_pf_bar)

    ,.csr_pcicmd_mem                        (csr_pcicmd_mem)

    ,.cbd_rdy                               (cbd_rdy)
    ,.cbd_busy                              (cbd_busy)
    ,.cbd_decode_val                        (cbd_decode_val)
    ,.cbd_func_pf_bar_hit                   (cbd_func_pf_bar_hit)
    ,.cbd_csr_pf_bar_hit                    (cbd_csr_pf_bar_hit)
    ,.cbd_func_pf_rgn_hit                   (cbd_func_pf_rgn_hit)
    ,.cbd_csr_pf_rgn_hit                    (cbd_csr_pf_rgn_hit)
    ,.cbd_bar_offset                        (cbd_bar_offset)
    ,.cbd_bar_offset_par                    (cbd_bar_offset_par)
    ,.cbd_hdr                               (cbd_hdr)
    ,.cbd_hdr_mmio                          (cbd_hdr_mmio)
    ,.cbd_wr_data                           (cbd_wr_data)
    ,.cbd_wr_data2                          (cbd_wr_data2)
    ,.cbd_bar_miss_err_wp                   (cbd_bar_miss_err_wp)
    ,.cbd_multi_bar_hit_err_wp              (cbd_multi_bar_hit_err_wp)
);

//-------------------------------------------------------------------------
// Signal for the BAR decoder that the header can be popped.
//-------------------------------------------------------------------------

always_comb begin: cds_take_decode_p

    // This is the key control for dequeuing the next pending command from
    // BAR and region decode. It is important to note that all commands
    // must be dequeued here (valid or not). ALL commands must all under one
    // of the following catagories otherwise there is the possibility of
    // deadlock.
    //
    // 1)  Valid HCW MMIO write being taken by double buffer (posted and primary only)
    // 2)  Valid HCW MMIO write timing out (posted and primary only)
    // 3)  Valid primary non-HCW MMIO write completing (posted)
    // 4)  Primary MMIO write which violates the current MPS setting (posted)
    // 5)  Primary MMIO write which does not hit any BAR, hits multiple BARs, or
    //     hits a single BAR but does not hit a region within that BAR (posted)
    // 6)  Primary MMIO write which has a bad length or byte_enable encoding (posted)
    // 7)  Primary MMIO write while in the D3 power state (posted)
    // 8)  Primary MMIO write during FLR (posted)
    // 9)  Primary MMIO write received while quiescing
    // 10) Primary unsupported posted commands
    // 11) Primary poisoned MMIO writes
    //
    // The above do not generate completions
    //
    // 12) Valid primary non-HCW MMIO read completing (non-posted)
    // 13) Valid primary CFG read/write that is completing (non-posted)
    // 14) Primary MMIO read which does not hit any BAR, hits multiple BARs, or
    //     hits a single BAR but does not hit a region within that BAR (non-posted)
    // 15) Primary MMIO read which has a bad length or byte_enable encoding (non-posted)
    // 16) Primary MMIO read while in the D3 power state (non-posted)
    // 17) Primary CFG read/write to an unsupported function (non-posted)
    // 18) Primary non-posted commands received while quiescing
    // 19) Primary unsupported non-posted commands
    // 20) Primary poisoned non-posted write commands
    // 21) Primary non-posted commands during FLR
    //
    // The above generate completions and therefore all funnel through obcpl_fifo_push  
    //
    // All of the following sideband transactions are covered by cds_sb_rdack/wrack_next
    // Sideband commands received by the CDS don't have a poisoned indication
    //
    // 22) Valid sideband non-HCW MMIO write completing (posted or non-posted)
    // 23) Valid sideband CFG read/write that is completing (non-posted)
    // 24) Sideband MMIO write which violates the current MPS setting (posted or non-posted)
    // 25) Sideband MMIO write which does not hit any BAR, hits multiple BARs, or
    //     hits a single BAR but does not hit a region within that BAR (posted or non-posted)
    // 26) Sideband MMIO write which has a bad length or byte_enable encoding (posted or non-posted)
    // 27) Sideband MMIO write while in the D3 power state (posted or non-posted)
    // 28) Sideband unsupported posted commands
    // 29) Sideband MMIO write during FLR (posted or non-posted)
    //
    // 30) Valid sideband non-HCW MMIO read completing (non-posted)
    // 31) Sideband MMIO read which does not hit any BAR, hits multiple BARs, or
    //     hits a single BAR but does not hit a region within that BAR (non-posted)
    // 32) Sideband MMIO read which has a bad length or byte_enable encoding (non-posted)
    // 33) Sideband MMIO read while in the D3 power state (non-posted)
    // 34) Sideband CFG read/write to an unsupported function (non-posted)
    // 35) Sideband unsupported non-posted commands
    // 36) Sideband non-posted commands during FLR
    //
    // 37) Any transaction that has a parity error on the header

    // Don't allow errored packets to be dequeued back-to-back.  This allows us to
    // not have to reregister the cds_err_hdr in ri_err and protects against
    // collisions in the ri_err block.

    // Majority vote for state of the iosfsb indication

    cbd_hdr_iosfsb  = (cbd_hdr.iosfsb[0] & cbd_hdr.iosfsb[1]) |
                      (cbd_hdr.iosfsb[0] & cbd_hdr.iosfsb[2]) |
                      (cbd_hdr.iosfsb[1] & cbd_hdr.iosfsb[2]);

    cds_take_decode = |{mem_func_pf_hcw_wr_req                                  // 1
                       ,hcw_timeout_q                                           // 2
                       ,(mmio_wr_done    & ~cbd_hdr.iosfsb[0])                  // 3
                       ,(mem_mps_err     & ~cbd_hdr.iosfsb[0] & ~cds_err_stall) // 4
                       ,(usr_pmem_req    & ~cbd_hdr.iosfsb[0] & ~cds_err_stall) // 5-7,9
                       ,(cbd_drop_flr_p  & ~cbd_hdr.iosfsb[0])                  // 8
                       ,(cbd_uns_pcmd    & ~cbd_hdr.iosfsb[0] & ~cds_err_stall) // 10
                       ,(cbd_poisoned_p  & ~cbd_hdr.iosfsb[0] & ~cds_err_stall) // 11

                       ,obcpl_fifo_push                                         // 12-20
                       ,(cbd_drop_flr_np & ~cbd_hdr.iosfsb[0])                  // 21

                       ,(cds_sb_rdack_next | cds_sb_wrack_next)                 // 23-36

                       ,(cbd_drop_hpar   & ~cbd_hdr_iosfsb)                     // 37

                       ,mem_bad_region  // Silently drop HCW writes to invalid region

                       ,cbd_hdr_pciecmd_msgd    // devtlb invalidate request
    };

end // always_comb cds_take_decode_p

//-----------------------------------------------------------------
// Decode CBD outputs
//-----------------------------------------------------------------

always_comb begin

    cbd_hdr_pciecmd       = hqm_pcie_type_e_t'({cbd_hdr.fmt, cbd_hdr.ttype});

    // Indication that transaction is a memory read type used to allow
    // setting of addr field in completions.

    cbd_hdr_pciecmd_mrd   = cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_hdr.posted &
                              (   (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_RD) |
                                ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_ND) &
                                  ( (cbd_hdr_pciecmd == HQM_MRD3  ) |
                                    (cbd_hdr_pciecmd == HQM_MRD4  ) |
                                    (cbd_hdr_pciecmd == HQM_LTMRD3) |
                                    (cbd_hdr_pciecmd == HQM_LTMRD4) |
                                    (cbd_hdr_pciecmd == HQM_MRDLK3) |
                                    (cbd_hdr_pciecmd == HQM_MRDLK4)
                                  )
                                )
                              );

    // Indication that transaction is a MRDLK used to return a CPLLK
    // command instead of a CPL command in the completion.

    cbd_hdr_pciecmd_mrdlk = cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_hdr.posted &
                               (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_ND) &
                               ( (cbd_hdr_pciecmd == HQM_MRDLK3) |
                                 (cbd_hdr_pciecmd == HQM_MRDLK4)
                               );

    // Determine whether the unsupported atomic was a 1 operand or 2 operand transaction

    cbd_hdr_pciecmd_atomic_1op = cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_hdr.posted &
                                 ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_D) &
                                   ( (cbd_hdr_pciecmd == HQM_SWAP3)     |
                                     (cbd_hdr_pciecmd == HQM_SWAP4)     |
                                     (cbd_hdr_pciecmd == HQM_FETCHADD3) |
                                     (cbd_hdr_pciecmd == HQM_FETCHADD4)
                                   )
                                 );

    cbd_hdr_pciecmd_atomic_2op = cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_hdr.posted &
                                 ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_D) &
                                   ( (cbd_hdr_pciecmd == HQM_CAS3) |
                                     (cbd_hdr_pciecmd == HQM_CAS4)
                                   )
                                 );

    cbd_hdr_pciecmd_io         = cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_hdr.posted &
                                 ( ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_ND) &
                                     (cbd_hdr_pciecmd == HQM_IORD)
                                   ) || (
                                     (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_D) &
                                     (cbd_hdr_pciecmd == HQM_IOWR)
                                   )
                                 );

    // ATS invalidate requests (It's currently the only MsgD passed from the LL)
    // TBD: Need to understand the invreq in the presence of FLR, quiesce, and or D3
    // Currently dropping for header parity only , and passing for FLR, D3, or quiesce.

    cbd_hdr_pciecmd_msgd       = cbd_decode_val[0] & cbd_hdr_mmio & cbd_hdr.posted &
                                    (cbd_hdr.cmd == `HQM_TDL_PHDR_MSG_D) & ~cbd_drop_hpar;

    // Send invalidate request to the devtlb

    rx_msg_v                   = cbd_hdr_pciecmd_msgd;

    rx_msg.pasid_valid         = cbd_hdr.pasidtlp.fmt2;
    rx_msg.pasid_priv          = cbd_hdr.pasidtlp.pm_req;
    rx_msg.pasid               = cbd_hdr.pasidtlp.pasid;
    rx_msg.opcode              = '0;                                // ATS invalidation request
    rx_msg.invreq_itag         = cbd_hdr.tag[4:0];                  // Itag
    rx_msg.invreq_reqid        = cbd_hdr.reqid;
    rx_msg.dw2                 = {current_bus, 8'd0, 16'd0};        // {BDF, DW2[15:0]}
    rx_msg.data                = cbd_wr_data[63:0];
    rx_msg.dperror             = cbd_hdr.poison | cbd_parity_err;

    // Determine the function number associated with the transaction
    // Force this to the physical function if not a valid function

    // Note that if memory is not enabled for the function, we should not decode
    // the address of an MMIO transaction, so the CBD will force the bar hit
    // indications to 0.
    //
    //  PS  MSE FUNC
    //  --  --- ----
    //  D0   0  PF (UR)
    //  D0   1  PF (UR if no bar hit)
    //
    //  D3   0  PF (UR)
    //  D3   1  PF (UR)

    cbd_cfg_func       = (cbd_hdr.iosfsb[0]) ? sb_cds_fid_q : cbd_hdr.addr[`HQM_CSR_ADDR_DEV_FUNC];

    cbd_cfg_func_valid = ~(|cbd_cfg_func);

end

//-------------------------------------------------------------------------
// Decode bar hits to region hits
//-------------------------------------------------------------------------

always_comb begin: mem_hit_rgn_p

    // Signal a memory read/write to the CSR region of PF0 MISC BAR.

    mem_hit_csr_pf_rgn      = cbd_decode_val[1] & cbd_csr_pf_bar_hit  &
                                (cbd_csr_pf_rgn_hit[0] | cbd_csr_pf_rgn_hit[1]);

    // Signal a memory read/write to the HCW, MSIX, or CSR regions of func_pf BAR

    mem_hit_func_pf_cfg_rgn = cbd_decode_val[2] & cbd_func_pf_bar_hit[0] & cbd_func_pf_rgn_hit[0];
    mem_hit_func_pf_hcw_rgn = cbd_decode_val[3] & cbd_func_pf_bar_hit[1] & cbd_func_pf_rgn_hit[1];

end // always_comb mem_hit_rgn_p

//-------------------------------------------------------------------------
// Check for errors from CBD
//-------------------------------------------------------------------------

always_comb begin: cbd_error_check

    // Throw away any transaction with a header parity error

    cbd_drop_hpar   = cbd_decode_val[0] & (^cbd_hdr);

    // Need to silently drop transactions if received during FLR
    // This means we will just throw away transactions w/o any error logging
    // or completion being generated.

    cbd_drop_flr_p  = cbd_decode_val[0] & ~cbd_drop_hpar &  cbd_hdr.posted & func_in_rst_q & ~cbd_hdr_pciecmd_msgd;

    cbd_drop_flr_np = cbd_decode_val[0] & ~cbd_drop_hpar & ~cbd_hdr.posted & func_in_rst_q;

    cbd_drop_flr    = cbd_drop_flr_p | cbd_drop_flr_np;

    // Priority for reporting other errors is malformed TLP, then UR, then poisoned.

    // Malformed packet - posted or non-posted write length > MPS

    if (cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_drop_hpar & ~cbd_drop_flr & ~cbd_hdr_pciecmd_msgd &
        (( cbd_hdr.posted & (cbd_hdr.cmd == `HQM_TDL_PHDR_WR)) |
         (~cbd_hdr.posted & (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_WR)))) begin
             if (ri_mps_rxp == 3'h2) mem_mps_err = (cbd_hdr.length > 'd128); // 512B
        else if (ri_mps_rxp == 3'h1) mem_mps_err = (cbd_hdr.length > 'd64);  // 256B
        else                         mem_mps_err = (cbd_hdr.length > 'd32);  // 128B + unsupported values
    end else begin
        mem_mps_err = '0;
    end

    // Unsupported commands from LLI or sciov mode is disabled, and fmt[2]

    cbd_uns_pcmd    = cbd_decode_val[0] & ~cbd_drop_hpar  & ~cbd_drop_flr_p  & ~cbd_hdr_pciecmd_msgd &
                           ~mem_mps_err &  cbd_hdr.posted &

                              (   (cbd_hdr.cmd == `HQM_TDL_PHDR_USR_D ) |
                                  (cbd_hdr.cmd == `HQM_TDL_PHDR_USR_ND) |

                                ( (cbd_hdr.cmd == `HQM_TDL_PHDR_WR    ) &
                                  (cbd_hdr.pasidtlp.fmt2 & ~csr_pasid_enable)
                                )
                              );

    // Detect messages that should just be dropped without UR
    cbd_msg_drop = (cbd_hdr.fmt[0] == 1'b1) &
                   (cbd_hdr.ttype[4:3] == 2'b10) & ~cbd_hdr_pciecmd_msgd &
                   ( ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0111_1111) & ( (cbd_hdr.ttype[2:0] == 3'b000) |
                                                                             (cbd_hdr.ttype[2:0] == 3'b010) |
                                                                             (cbd_hdr.ttype[2:0] == 3'b011) |
                                                                             (cbd_hdr.ttype[2:0] == 3'b100)
                                                                           )
                     ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_0000) & (cbd_hdr.ttype[2:0] == 3'b100) ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_0001) & (cbd_hdr.ttype[2:0] == 3'b100) ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_0011) & (cbd_hdr.ttype[2:0] == 3'b100) ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_0100) & (cbd_hdr.ttype[2:0] == 3'b100) ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_0101) & (cbd_hdr.ttype[2:0] == 3'b100) ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_0111) & (cbd_hdr.ttype[2:0] == 3'b100) ) |
                     ( ({cbd_hdr.endbe,cbd_hdr.startbe} == 8'b0100_1000) & (cbd_hdr.ttype[2:0] == 3'b100) )
                   );

    // Unsupported commands from LLI or sciov mode is disabled, and fmt[2]
    // fmt[2] should never be set for CFG transactions

    cbd_uns_npcmd   = cbd_decode_val[0] & ~cbd_drop_hpar  & ~cbd_drop_flr_np &
                           ~mem_mps_err & ~cbd_hdr.posted &

                            (     (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_D ) |
                                  (cbd_hdr.cmd == `HQM_TDL_NPHDR_USR_ND) |

                              ( ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_RD) |
                                  (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_WR) ) &
                                (cbd_hdr.pasidtlp.fmt2 & ~csr_pasid_enable)
                              ) |

                              ( ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_CFG_RD) |
                                  (cbd_hdr.cmd == `HQM_TDL_NPHDR_CFG_WR) ) &
                                (cbd_hdr.pasidtlp.fmt2)
                              )
                            );

    cbd_uns_cmd     = cbd_uns_pcmd | cbd_uns_npcmd;

    // The following term covers all BAR decode errors

    mem_bad_addr = cbd_decode_val[0] & cbd_hdr_mmio & ~cbd_hdr_pciecmd_msgd &
                    (cbd_bar_miss_err_wp | cbd_multi_bar_hit_err_wp) &
                    ~(cbd_drop_hpar | cbd_drop_flr | cbd_uns_cmd | mem_mps_err);

    // When a physical function is in the D3 state, only CFG accesses and messages
    // are allowed.
    // If we didn't hit a bar (could also be due to MSE and/or VFMSE not being set)
    // the above term covers us.  The following term covers us when we hit a valid
    // bar and region but are in D3.

    mem_in_d3    = cbd_decode_val[0] & cbd_hdr_mmio & ri_pf_disabled_wxp &
        ~(cbd_drop_hpar | cbd_drop_flr | cbd_uns_cmd | mem_mps_err | mem_bad_addr | cbd_hdr_pciecmd_msgd);

    // If we hit a valid BAR and region and aren't in D3, need to check the length
    // and bytes enables are valid.
    // The RI only supports memory reads of 32 bits and memory writes of 32 bits,
    // except for HCW writes. HCW writes may be 16, 32, 48, or 64 bytes in length.
    // Any memory transactions that requests a read or write of a size outside of
    // these limitations, or without the byte enables indicating full DWORDs
    // will be flagged as an unsupported request.

    mem_cbd_hit = cbd_decode_val[0] & cbd_hdr_mmio &
       ~(cbd_drop_hpar | cbd_drop_flr | cbd_uns_cmd | mem_mps_err  | mem_bad_addr | mem_in_d3 | cbd_hdr_pciecmd_msgd);

    if (mem_hit_func_pf_hcw_rgn) begin

      // For the HCW regions the request must meet the following criteria otherwise UR
      //
      // Only posted writes are supported
      // Length must be 4, 8, 12, or 16 DW (1, 2, 3, or 4 HCWs)
      // Address offset must be on a 4 DW boundary
      // No SAI check for HCW writes
      // The SAI check will actually be done for HCW reads, but the behavior for a read with
      // a bad SAI is the same as the expected behavior for a read to HCW space (return 0s).
      // Both the first and last BEs must be all 1's
      // The address range associated with the request must fit within the cache line 
      // Access not supported through sideband

      mem_bad_len_be = mem_cbd_hit & ~cbd_hdr_pciecmd_msgd &
                       ( ( cbd_hdr.posted &
                          ( ( (cbd_hdr.length !=  4) &
                              (cbd_hdr.length !=  8) &
                              (cbd_hdr.length != 12) &
                              (cbd_hdr.length != 16)
                            ) |
                            (cbd_hdr.iosfsb[0]) |
                            (cbd_hdr.endbe   != 4'hf) |
                            (cbd_hdr.startbe != 4'hf) |
                            ((cbd_hdr.length ==  8) & (cbd_bar_offset[5:4] == 2'd3)) |
                            ((cbd_hdr.length == 12) & (cbd_bar_offset[5:4] >= 2'd2)) |
                            ((cbd_hdr.length == 16) & (cbd_bar_offset[5:4] >= 2'd1))
                          )
                         )
                       );

      mem_bad_region = mem_cbd_hit & ~mem_bad_len_be & ~cbd_hdr_pciecmd_msgd &
                          ( (cbd_bar_offset[24:22] != 3'd0)  |
                            ((cbd_bar_offset[20]) ?                                    // LDB
        ({1'd0, cbd_bar_offset[19:12]} >= {(|NUM_LDB_PP[31:8]), NUM_LDB_PP[7:0]}) :    // LDB PP
        ({1'd0, cbd_bar_offset[19:12]} >= {(|NUM_DIR_PP[31:8]), NUM_DIR_PP[7:0]})) |   // DIR PP
                            (cbd_bar_offset[11:10] != 2'd0)  |
                            (cbd_bar_offset[ 3: 2] != 2'd0)
                          );

    end else begin // Default for everything else.

      mem_bad_len_be = mem_cbd_hit & ~cbd_hdr_pciecmd_msgd &
                       (( cbd_hdr.posted & (cbd_hdr.length  != 1))    |
                        (~cbd_hdr.posted & (cbd_hdr.length  != 1))    |
                        (~cbd_hdr.posted & (cbd_hdr.endbe   != 0))    |
                        (~cbd_hdr.posted & (cbd_hdr.startbe != 4'hf)) |
                        ( cbd_hdr.posted & (cbd_hdr.length  == 1) &
                                          ((cbd_hdr.startbe != 4'hf) |
                                           (cbd_hdr.endbe   != 4'h0)
                                          )
                        )
                       );

      mem_bad_region = '0;

    end

    // If cbd_hdr_mmio isn't set, this is a CFG transaction since MMIO transactions
    // or unsupported transactions set cds_hdr_mmio into the CBD.

    cbd_cfg_req          = cbd_decode_val[0] & ~cbd_hdr_mmio;

    // Need to UR transactions received when quiesce is asserted

    cbd_cfg_prim_quiesce = cbd_cfg_req & ~cbd_drop_hpar & ~cbd_drop_flr &  prim_quiesce & ~cbd_hdr.iosfsb[0];

    mem_prim_quiesce     = mem_cbd_hit & prim_quiesce;

    mem_req_gen_usr      = mem_bad_addr | mem_bad_len_be | mem_in_d3 | mem_prim_quiesce;

    // Poisoned packets are the lowest priority check and only checked on
    // commands that include data (MEM_WR or CFG_WR or MSGD);

    cbd_parity_err   = cbd_decode_val[0] & ~cbd_hdr.poison & ~cfg_ri_par_off &
                                ~((cbd_wr_data2.parity[0] == (^cbd_wr_data2.data[ 31:  0])) &
                                  (cbd_wr_data2.parity[1] == (^cbd_wr_data2.data[ 63: 32])) &
                                  (cbd_wr_data2.parity[2] == (^cbd_wr_data2.data[ 95: 64])) &
                                  (cbd_wr_data2.parity[3] == (^cbd_wr_data2.data[127: 96])) &
                                  (cbd_wr_data2.parity[4] == (^cbd_wr_data2.data[159:128])) &
                                  (cbd_wr_data2.parity[5] == (^cbd_wr_data2.data[191:160])) &
                                  (cbd_wr_data2.parity[6] == (^cbd_wr_data2.data[223:192])) &
                                  (cbd_wr_data2.parity[7] == (^cbd_wr_data2.data[255:224])) &
                                  ( cbd_wr_data.parity[0] ==  (^cbd_wr_data.data[ 31:  0])) &
                                  ( cbd_wr_data.parity[1] ==  (^cbd_wr_data.data[ 63: 32])) &
                                  ( cbd_wr_data.parity[2] ==  (^cbd_wr_data.data[ 95: 64])) &
                                  ( cbd_wr_data.parity[3] ==  (^cbd_wr_data.data[127: 96])) &
                                  ( cbd_wr_data.parity[4] ==  (^cbd_wr_data.data[159:128])) &
                                  ( cbd_wr_data.parity[5] ==  (^cbd_wr_data.data[191:160])) &
                                  ( cbd_wr_data.parity[6] ==  (^cbd_wr_data.data[223:192])) &
                                  ( cbd_wr_data.parity[7] ==  (^cbd_wr_data.data[255:224])));

    cbd_poisoned_p   = cbd_decode_val[0] & ~cbd_drop_hpar   & ~cbd_drop_flr   & ~cbd_uns_pcmd  &
                        ~mem_req_gen_usr & ~mem_mps_err     & ~mem_bad_region &
                        (cbd_hdr.poison  |  cbd_parity_err) &  cbd_hdr.posted &
                        ((cbd_hdr.cmd == `HQM_TDL_PHDR_WR) |
                         (cbd_hdr.cmd == `HQM_TDL_PHDR_MSG_D));

    cbd_poisoned_np  = cbd_decode_val[0] & ~cbd_drop_hpar   & ~cbd_drop_flr   & ~cbd_uns_npcmd &
                        ~mem_req_gen_usr & ~mem_mps_err     &
                        (cbd_hdr.poison  |  cbd_parity_err) & ~cbd_hdr.posted &
                        ~cbd_cfg_prim_quiesce &
                        ( (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_WR) |
                         ((cbd_hdr.cmd == `HQM_TDL_NPHDR_CFG_WR) & cbd_cfg_func_valid));

    cbd_poisoned     = cbd_poisoned_p | cbd_poisoned_np;

    // If we pass the above checks then we have a good MMIO transaction

    mem_req_good     = mem_cbd_hit & ~(mem_bad_len_be | mem_in_d3 | mem_prim_quiesce |
                                       mem_bad_region | cbd_poisoned);

    mem_rd           = mem_req_good &  (~cbd_hdr.posted & (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_RD));
    mem_wr           = mem_req_good & (( cbd_hdr.posted & (cbd_hdr.cmd == `HQM_TDL_PHDR_WR)) |
                                       (~cbd_hdr.posted & (cbd_hdr.cmd == `HQM_TDL_NPHDR_MEM_WR)));

    mem_csr_wr_req   = mem_wr & mem_hit_csr_pf_rgn;
    mem_csr_rd_req   = mem_rd & mem_hit_csr_pf_rgn;

    mem_func_pf_cfg_wr_req = mem_wr & mem_hit_func_pf_cfg_rgn;
    mem_func_pf_cfg_rd_req = mem_rd & mem_hit_func_pf_cfg_rgn;

    mem_func_pf_hcw_wr_req = mem_wr & mem_hit_func_pf_hcw_rgn & hcw_wr_rdy & ~hcw_timeout_q;

    // CFG transactions also need to check that the function is a valid function

    cbd_cfg_usr_func     = cbd_cfg_req & ~cbd_drop_hpar & ~cbd_drop_flr & ~cbd_cfg_prim_quiesce &
                            ~cbd_cfg_func_valid;

    // We do not check that length==1 for primary CFG transactions.  If a length>1 is received
    // for a primary CFG write, we will pop all of the data associated with it off the npdata
    // FIFO, but will save the first DW we popped and use it to do the write.
    // The length must be 1 for sideband CFG transactions.
    // For CFG reads we will always return 1 DW of data.

    cbd_cfg_sb_bad_len   = cbd_cfg_req & cbd_hdr.iosfsb[0] & (cbd_hdr.length > 10'd1) &
                            ~(cbd_drop_hpar | cbd_drop_flr | cbd_cfg_prim_quiesce | cbd_cfg_usr_func);

    cbd_cfg_req_good     = cbd_cfg_req & ~(cbd_drop_hpar | cbd_drop_flr     | cbd_cfg_prim_quiesce |
                                           cbd_poisoned  | cbd_cfg_usr_func | cbd_cfg_sb_bad_len);

    cbd_cfg_rd           = cbd_cfg_req_good & (cbd_hdr.cmd == `HQM_TDL_NPHDR_CFG_RD);
    cbd_cfg_wr           = cbd_cfg_req_good & (cbd_hdr.cmd == `HQM_TDL_NPHDR_CFG_WR);

    // Pulses on leading edge of the requests

    dec_mmio_wr_req = ~pend_mmio_wr & (mem_csr_wr_req | mem_func_pf_cfg_wr_req);
    dec_mmio_rd_req = ~pend_mmio_rd & (mem_csr_rd_req | mem_func_pf_cfg_rd_req);

    dec_cbd_cfg_rd  = ~pend_cfg_rd  & cbd_cfg_rd;
    dec_cbd_cfg_wr  = ~pend_cfg_wr  & cbd_cfg_wr;

end // cbd_error_check

//-------------------------------------------------------------------------
// Error outputs to ri_err
//-------------------------------------------------------------------------

// The posted unsupported requests error can come from the following sources;
// 1) An unsupported posted command (cbd_uns_pcmd)
// 2) A posted mmio error (mem_req_gen_usr -> usr_pmem_req)

// The non-posted unsupported requests error can come from the following sources;
// 1) An unsupported non-posted command (cbd_uns_npcmd)
// 2) A non-posted mmio error (mem_req_gen_usr -> usr_npmem_req)
// 3) A cfg transaction that returns an error (?)
// 4) A cfg transaction to a non-existent function (cds_cfg_usr_func)

assign usr_pmem_req  =  cbd_hdr.posted & mem_req_gen_usr & ~cbd_hdr.iosfsb[0];

assign usr_npmem_req = ~cbd_hdr.posted & mem_req_gen_usr & ~cbd_hdr.iosfsb[0] &
                        ~cds_err_stall & ~obcpl_fifo_afull;

// Note that unsupported sideband transactions are silently dropped.

assign cds_usr_in_cpl_next     = cds_take_decode & ~cbd_drop_flr_np & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & cbd_uns_npcmd;

// Condition this with cbd_msg_drop. cbd_msg_drop should never be asserted when usr_pmem_req is asserted,
// and cbd_msg_drop will only be asserted for MSG requests, where the cbd_hdr.cmd is HQM_TDL_PHDR_USR_D or ..._ND
assign cds_pusr_err_next       = cds_take_decode & ~cbd_drop_flr_p  & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & (cbd_uns_pcmd | usr_pmem_req) & ~cbd_msg_drop;

assign cds_npusr_err_next      = cds_take_decode & ~cbd_drop_flr_np & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & (usr_npmem_req | cbd_cfg_usr_func | cbd_cfg_prim_quiesce);

assign cds_malform_pkt_next    = cds_take_decode & ~cbd_drop_flr_p  & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & mem_mps_err;

assign cds_poison_err_next     = cds_take_decode & ~cbd_drop_flr    & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & cbd_poisoned;

assign cds_cfg_usr_func_next   = cds_take_decode & ~cbd_drop_flr_np & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & cbd_cfg_usr_func;

assign cds_bar_decode_err_next = cds_take_decode & ~cbd_drop_flr    & ~cbd_hdr.iosfsb[1] &
                                  ~cbd_drop_hpar & ~cbd_uns_cmd & ~mem_mps_err     &
                                  (cbd_bar_miss_err_wp | cbd_multi_bar_hit_err_wp);

assign cds_err_next            = cds_usr_in_cpl_next   | cds_malform_pkt_next |
                                 cds_pusr_err_next     | cds_npusr_err_next   |
                                 cds_cfg_usr_func_next | cds_poison_err_next  |
                                 cds_bar_decode_err_next;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin

    if (~prim_gated_rst_b) begin
        cds_usr_in_cpl          <= '0;
        cds_npusr_err_wp        <= '0;
        cds_pusr_err_wp         <= '0;
        cds_malform_pkt         <= '0;
        cds_poison_err_wp       <= '0;
        cds_cfg_usr_func        <= '0;
        cds_bar_decode_err_wp   <= '0;
        set_cbd_data_parity_err <= '0;
        set_cbd_hdr_parity_err  <= '0;
        cds_err_stall_q         <= '0;
        cds_err_hdr             <= '0;
    end else begin

        cds_usr_in_cpl          <= cds_usr_in_cpl_next;
        cds_pusr_err_wp         <= cds_pusr_err_next;
        cds_npusr_err_wp        <= cds_npusr_err_next;
        cds_malform_pkt         <= cds_malform_pkt_next;
        cds_poison_err_wp       <= cds_poison_err_next;
        cds_cfg_usr_func        <= cds_cfg_usr_func_next;
        cds_bar_decode_err_wp   <= cds_bar_decode_err_next;
        set_cbd_data_parity_err <= cbd_poisoned & cbd_parity_err & cds_take_decode;
        set_cbd_hdr_parity_err  <= cbd_drop_hpar;
        cds_err_stall_q         <= {cds_err_next, cds_err_stall_q[2:1]};
        if (cds_err_next) begin
            cds_err_hdr         <= cbd_hdr;
        end
    end

end

assign cds_err_stall = (|cds_err_stall_q);

//-------------------------------------------------------------------------
// HCW write logic
//-------------------------------------------------------------------------
always_comb begin: hcw_write_p

    // HCW write is granted

    hcw_wr_wp            = mem_func_pf_hcw_wr_req;

    hcw_wr_hdr           ='0;
    hcw_wr_hdr.is_nm     = cbd_bar_offset[21];
    hcw_wr_hdr.is_ldb    = cbd_bar_offset[20];
    hcw_wr_hdr.prod_port = cbd_bar_offset[19:12];
    hcw_wr_hdr.cl        = cbd_bar_offset[9: 6];

    {hcw[1], hcw[0]} = cbd_wr_data.data;
    {hcw[3], hcw[2]} = cbd_wr_data2.data;

    if (cbd_hdr.length > 'd12) begin
      hcw_wr_hdr.num_hcw = 3'h4;
    end else if (cbd_hdr.length > 'd8) begin
      hcw_wr_hdr.num_hcw = 3'd3;
    end else if (cbd_hdr.length > 'd4) begin
      hcw_wr_hdr.num_hcw = 3'd2;
    end else if (cbd_hdr.length > 'd0) begin
      hcw_wr_hdr.num_hcw = 3'd1;
    end else begin
      hcw_wr_hdr.num_hcw = 3'd0;
    end

    hcw_wr_data                             = cbd_wr_data;
    hcw_wr_data2                            = cbd_wr_data2;

end // always_comb

hqm_AW_double_buffer_clear #(.WIDTH($bits(hcw_wr_hdr)+(2*$bits(hcw_wr_data)))) i_hcw_wr_aw_db (

   .clk           (prim_nonflr_clk)
  ,.rst_n         (prim_gated_rst_b)

  ,.status        (ri_hcw_db_status)

  ,.clear         (~flr_triggered_q)

  ,.in_ready      (hcw_wr_rdy)

  ,.in_valid      (hcw_wr_wp)
  ,.in_data       ({hcw_wr_hdr,hcw_wr_data2,hcw_wr_data})

  ,.out_ready     (hcw_wr_buff_rdy)

  ,.out_valid     (hcw_wr_buff_wp)
  ,.out_data      ({hcw_wr_buff_hdr,hcw_wr_buff_data2,hcw_wr_buff_data})
);

//-------------------------------------------------------------------------
// HCW enqueue logic
//-------------------------------------------------------------------------
always_comb begin: hcw_enqueue_p
  hcw_enq_state_next            = hcw_enq_state;
  hcw_enq_state_err_nc          = '0;
  hcw_wr_buff_rdy               = '0;
  hcw_enq_hcw                   = '0;
  hcw_enq_par                   = '0;
  hcw_enq_in_v                  = '0;
  hcw_enq_in_data.cl_last       = '0;
  hcw_enq_in_data.cl            = hcw_wr_buff_hdr.cl;
  hcw_enq_in_data.cli           = '0;
  hcw_enq_in_data.is_nm_pf      = hcw_wr_buff_hdr.is_nm;
  hcw_enq_in_data.is_pf_port    = hcw_wr_buff_hdr.is_nm | (~csr_pasid_enable);
  hcw_enq_in_data.is_ldb_port   = hcw_wr_buff_hdr.is_ldb;
  hcw_enq_in_data.vpp           = hcw_wr_buff_hdr.prod_port[$bits(hcw_enq_in_data.vpp)-1:0];

  unique casez (1'b1)      
    hcw_enq_state[HCW_ENQ_IDLE_BIT]: begin
      if (hcw_wr_buff_wp) begin
        hcw_enq_in_v                = 1'b1;
        hcw_enq_hcw                 = hcw_wr_buff_data.data[127:0];
        hcw_enq_par                 = hcw_wr_buff_data.parity[3:0];

        case (hcw_wr_buff_hdr.num_hcw)
          3'h0,3'h1: begin
            hcw_enq_in_data.cl_last = '1;
            hcw_enq_state_next      = HCW_ENQ_IDLE;
            hcw_wr_buff_rdy         = hcw_enq_in_ready & ~flr_treatment_q[0];
          end
          3'h2: begin
            hcw_enq_state_next      = HCW_ENQ_1_HCW;
          end
          3'h3: begin
            hcw_enq_state_next      = HCW_ENQ_2_HCW;
          end
          default: begin
            hcw_enq_state_next      = HCW_ENQ_3_HCW;
          end
        endcase
      end
    end
    hcw_enq_state[HCW_ENQ_1_HCW_BIT]: begin
      hcw_enq_in_v                  = 1'b1;

      case (hcw_wr_buff_hdr.num_hcw)
        3'h2: begin
          hcw_enq_hcw               = hcw_wr_buff_data.data[255:128];        // second hcw of 2 hcw write
          hcw_enq_par               = hcw_wr_buff_data.parity[7:4];
          hcw_enq_in_data.cli       = 2'd1;
        end
        3'h3: begin
          hcw_enq_hcw               = hcw_wr_buff_data2.data[127:0];         // third hcw of 3 hcw write
          hcw_enq_par               = hcw_wr_buff_data2.parity[3:0];
          hcw_enq_in_data.cli       = 2'd2;
        end
        default: begin
          hcw_enq_hcw               = hcw_wr_buff_data2.data[255:128];       // fourth hcw of 4 hcw write
          hcw_enq_par               = hcw_wr_buff_data2.parity[7:4];
          hcw_enq_in_data.cli       = 2'd3;
        end
      endcase

      hcw_enq_in_data.cl_last       = '1;

      hcw_enq_state_next            = HCW_ENQ_IDLE;
      hcw_wr_buff_rdy               = hcw_enq_in_ready & ~flr_treatment_q[0];
    end
    hcw_enq_state[HCW_ENQ_2_HCW_BIT]: begin
      hcw_enq_in_v = 1'b1;

      case (hcw_wr_buff_hdr.num_hcw)
        3'h3: begin
          hcw_enq_hcw               = hcw_wr_buff_data.data[255:128];        // second hcw of 3 hcw write
          hcw_enq_par               = hcw_wr_buff_data.parity[7:4];
          hcw_enq_in_data.cli       = 2'd1;
        end
        default: begin
          hcw_enq_hcw               = hcw_wr_buff_data2.data[127:0];         // third hcw of 4 hcw write
          hcw_enq_par               = hcw_wr_buff_data2.parity[3:0];
          hcw_enq_in_data.cli       = 2'd2;
        end
      endcase

      hcw_enq_state_next            = HCW_ENQ_1_HCW;
    end
    hcw_enq_state[HCW_ENQ_3_HCW_BIT]: begin
      hcw_enq_in_v                  = 1'b1;

      hcw_enq_hcw                   = hcw_wr_buff_data.data[255:128];    // second hcw of 4 hcw write
      hcw_enq_par                   = hcw_wr_buff_data.parity[7:4];
      hcw_enq_in_data.cli           = 2'd1;

      hcw_enq_state_next            = HCW_ENQ_2_HCW;
    end
    default: begin      
      hcw_enq_state_err_nc          = 1'b1;
    end
  endcase
end

assign hcw_enq_in_data.port_parity  = ^{hcw_enq_in_data.cl_last
                                       ,hcw_enq_in_data.cl
                                       ,hcw_enq_in_data.cli
                                       ,hcw_enq_in_data.is_nm_pf
                                       ,hcw_enq_in_data.is_pf_port
                                       ,hcw_enq_in_data.is_ldb_port
                                       ,hcw_enq_in_data.vpp
                                       };

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_gen_ecc_l (

     .d         (hcw_enq_hcw[63:0])
    ,.ecc       (hcw_enq_in_data.ecc_l)
);

hqm_AW_ecc_gen #(.DATA_WIDTH(64), .ECC_WIDTH(8)) i_gen_ecc_h (

     .d         (hcw_enq_hcw[127:64])
    ,.ecc       (hcw_enq_in_data.ecc_h)
);

// If parity error, poison by causing multiple bit ECC errors on both halves of the HCW

assign hcw_enq_par_error   = hcw_enq_in_v & ~cfg_ri_par_off &
                                ~((hcw_enq_par[0] == (^hcw_enq_hcw[ 31:  0])) &
                                  (hcw_enq_par[1] == (^hcw_enq_hcw[ 63: 32])) &
                                  (hcw_enq_par[2] == (^hcw_enq_hcw[ 95: 64])) &
                                  (hcw_enq_par[3] == (^hcw_enq_hcw[127: 96])));

assign hcw_enq_in_data.hcw = {hcw_enq_hcw[127:66]
                            ,(hcw_enq_hcw[ 65:64] ^ {2{hcw_enq_par_error}})
                            , hcw_enq_hcw[ 63: 2]
                            ,(hcw_enq_hcw[  1: 0] ^ {2{hcw_enq_par_error}})};

//-------------------------------------------------------------------------
// HCW enqueue state
//-------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: hcw_enq_state_p
  if (!prim_gated_rst_b) begin
    hcw_enq_state           <= HCW_ENQ_IDLE;
    set_hcw_data_parity_err <= '0;
  end else if (~flr_triggered_q) begin
    hcw_enq_state           <= HCW_ENQ_IDLE;
    set_hcw_data_parity_err <= '0;
  end else if (hcw_enq_in_ready & ~flr_treatment_q[0]) begin
    hcw_enq_state           <= hcw_enq_state_next;
    set_hcw_data_parity_err <= hcw_enq_par_error & hcw_enq_in_ready;
  end
end // always_ff pend_mmio_cfg_rd_p

//-------------------------------------------------------------------------
// Detect HCW write timeout
//-------------------------------------------------------------------------
assign hcw_cnt_next          = (cds_take_decode | hcw_timeout_q | hcw_wr_rdy) ? 32'd0 : (hcw_cnt_q + {31'd0,mem_hit_func_pf_hcw_rgn});
assign hcw_timeout_next      = (~hcw_timeout_q & cfg_hcw_timeout.TIMEOUT_ENABLE & hcw_cnt_q[cfg_hcw_timeout.TIMEOUT_PWR2]) | (hcw_timeout_q & ~cds_take_decode);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    hcw_timeout_q           <= '0;
    hcw_timeout_error       <= '0;
    hcw_timeout_syndrome    <= '0;
    hcw_cnt_q               <= '0;
  end else if (~flr_triggered_q) begin
    hcw_timeout_q           <= '0;
    hcw_timeout_error       <= '0;
    hcw_timeout_syndrome    <= '0;
    hcw_cnt_q               <= '0;
  end else begin
    hcw_timeout_q           <= hcw_timeout_next;
    hcw_timeout_error       <= hcw_timeout_next & ~hcw_timeout_q;
    if (cfg_hcw_timeout.TIMEOUT_ENABLE) begin
    hcw_timeout_syndrome    <= {hcw_wr_hdr.num_hcw[1:0],hcw_wr_hdr.is_ldb,hcw_wr_hdr.is_nm,hcw_wr_hdr.prod_port[3:0]};
      if (|{cds_take_decode, hcw_timeout_q, hcw_wr_rdy, mem_hit_func_pf_hcw_rgn}) begin
        hcw_cnt_q           <= hcw_cnt_next;
      end
    end
  end
end

//-------------------------------------------------------------------------
// CSR request logic to ri_csr_ctl
//-------------------------------------------------------------------------

always_comb begin: csr_req_p

    csr_req_wr = dec_mmio_wr_req | dec_cbd_cfg_wr;

    csr_req_rd = dec_mmio_rd_req | dec_cbd_cfg_rd;

    csr_req = '0;

    csr_req.csr_wr_offset          = {(cbd_hdr.iosfsb[2] & (|cbd_hdr.addr[47:HQM_CSR_OFFSET_WID-1])),
                                      cbd_bar_offset[`HQM_CSR_OFFSET_WID-1:2], 2'h0};
    csr_req.csr_rd_offset          = {1'd0, cbd_bar_offset[`HQM_CSR_OFFSET_WID-1:2], 2'h0};
    csr_req.csr_wr_dword           = cbd_wr_data.data[`HQM_CSR_SIZE-1:0];
    csr_req.csr_wr_func            = '0;
    csr_req.csr_rd_func            = '0;
    csr_req.csr_byte_en            = cbd_hdr.poison ? '0 : cbd_hdr.startbe;
    csr_req.csr_sai                = cbd_hdr.sai;
    csr_req.csr_mem_mapped         = mem_wr | mem_rd;
    csr_req.csr_mem_mapped_offset  = {cbd_bar_offset,2'b00};
    csr_req.csr_ext_mem_mapped     = (mem_csr_wr_req | mem_csr_rd_req) & cbd_csr_pf_rgn_hit[1];
    csr_req.csr_func_pf_mem_mapped =  mem_func_pf_cfg_wr_req | mem_func_pf_cfg_rd_req;

    csr_req.csr_mem_mapped_apar    =  cbd_bar_offset_par;
    csr_req.csr_mem_mapped_dpar    =  cbd_wr_data.parity[0];

end

//-------------------------------------------------------------------------
// Indicate first or second cycle of npdata
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: npdata_cycle_p
    if (~prim_gated_rst_b) begin
      npdata_first_cycle  <= 1'b1;
    end else if (cds_nphdr_rd_wp) begin
      npdata_first_cycle  <= 1'b1;
    end else if (cds_npd_rd_wp) begin
      npdata_first_cycle  <= 1'b0;
    end
end

// Indicate last cycle of npdata

assign npdata_last_cycle = (npd_cnt == 8'h2) | (tlq_nphdr_rxp.length <= 10'd8);

//-------------------------------------------------------------------------
// Capture first cycle of posted data when there is a second cycle expected
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: npdata_first_cycle_data_p

    if (~prim_gated_rst_b) begin
      npdata_first_cycle_data     <= '0;
      npdata_first_cycle_data_par <= '0;
    end else if (cds_npd_rd_wp & npdata_first_cycle) begin
      npdata_first_cycle_data     <= tlq_npdata_rxp[0 +: `HQM_CSR_SIZE];
      npdata_first_cycle_data_par <= tlq_npdata_rxp[RI_NPDATA_WID +: (`HQM_CSR_SIZE/32)];
    end

end

//-------------------------------------------------------------------------
// Dequeue extra data from the non-posted data fifo
//-------------------------------------------------------------------------

always_comb begin: cds_npd_rd_p

  // Select non-posted write data - use tlq if first cycle or saved value if not

  np_wr_data     = (npdata_first_cycle) ? tlq_npdata_rxp[0 +: `HQM_CSR_SIZE] : npdata_first_cycle_data;
  np_wr_data_par = (npdata_first_cycle) ? tlq_npdata_rxp[RI_NPDATA_WID +: (`HQM_CSR_SIZE/32)] : npdata_first_cycle_data_par;

  // If this is not the last cycle of npdata and there is valid data then flush the extra data

  if ((npd_queue_flush | (tlq_nphdrval_wp & (tlq_nphdr_rxp.length > 'd8))) & ~npdata_last_cycle) begin

    flush_cds_npd_rd_wp = tlq_npdataval_wp;

    if (npdata_first_cycle) begin

      if (tlq_nphdr_rxp.length == 10'h0) begin
        npd_cnt_nxt  = 8'h80;
      end else begin
        npd_cnt_nxt  = (tlq_nphdr_rxp.length + 10'd7) >> 3;   // number of 256 bit posted data transfers
      end

    end else if (tlq_npdataval_wp) begin

      npd_cnt_nxt = npd_cnt - 8'h1;

    end else begin

      npd_cnt_nxt = npd_cnt;

    end

  end else begin // There is no valid non-posted header and data. Don't pop anything from the TLQ

    flush_cds_npd_rd_wp = '0;
    npd_cnt_nxt         = '0;

  end // else !valid non-posted header

end

//-------------------------------------------------------------------------
// HSD 5313939 - posted data > 4 DW causes hang
//-------------------------------------------------------------------------
// if a non-posted transaction comes with > 8 DW of data, it will take one more
// entry in the TLQ.  So cds_pd_rd_wp will need to be popped an extra time.

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: npd_queue_flush_p
  if (~prim_gated_rst_b) begin
    npd_queue_flush <= 1'b0;
  end else if (~npd_queue_flush & cds_npd_rd_wp & ~npdata_last_cycle) begin
    npd_queue_flush <= 1'b1;
  end else if ( npd_queue_flush & cds_npd_rd_wp &  npdata_last_cycle) begin
    npd_queue_flush <= 1'b0;
  end
end

// Count of posted data beats, set to number of beats for second beat, so value of 2 indicates last beat

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: npd_cnt_p
  if (~prim_gated_rst_b) begin
    npd_cnt <= '0;
  end else if (cds_npd_rd_wp) begin
    npd_cnt <= npd_cnt_nxt;
  end
end

always_comb begin: q_decode_p

    // Pop a posted header from the posted header queue in the TLQ

    cds_phdr_rd_wp = (cds_hdr_v       &  nxt_ioq_cmd_p_usr_nd) |
                     (cds_hdr_v_wdata & (nxt_ioq_cmd_mem_wr | nxt_ioq_cmd_p_msg_d | nxt_ioq_cmd_p_usr_d));

    // Pop a non posted header from the non posted header queue in the TLQ.
    // - When a csr read/write has been issued to the CSR fub AND it's outbound
    //   completion has been sent (excluding a pending OBC from a MMIO CSR transactions)
    // - For the case where the next non posted transaction is a memory transaction,
    //   we pop immediately and pipe the data along with the address decode.
    // - Pop the next request if the request generates an error
    // HSD 4728269 - if parity error in header, pop header and ignore
    // HSD 4728546 - test hangs after parity error injection

    cds_nphdr_rd_wp = (cds_hdr_v       & (nxt_ioq_cmd_cfg_rd | nxt_ioq_cmd_mem_rd |
                                          nxt_ioq_cmd_np_usr_nd)) |
                      (cds_hdr_v_wdata & (nxt_ioq_cmd_cfg_wr | nxt_ioq_cmd_np_usr_d));

    // Pop data from the non posted data queue when;
    // - There is a PCIE CSR write type transaction and it has data.
    // - The next command from the TLQ is a config transaction w/ an error.
    // - An IO write transaction that needs to be sent to the decoder.
    // -dont pop the data queue when the command does not have data
    // HSD 4728269 - if parity error in header, pop header and ignore

    last_cds_npd_rd_wp = cds_hdr_v_wdata & (nxt_ioq_cmd_cfg_wr | nxt_ioq_cmd_np_usr_d) &
                            (tlq_nphdr_rxp.length != 10'd0);

    cds_npd_rd_wp      = flush_cds_npd_rd_wp | last_cds_npd_rd_wp;

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    prim_quiesce <= '0;
  end else if (~cbd_decode_val[1] | cds_take_decode) begin
    prim_quiesce <= sif_mstr_quiesce_req;
  end
end

//-------------------------------------------------------------------------
// Dequeue data from the posted data fifo
//-------------------------------------------------------------------------

always_comb begin: cds_pd_rd_p

    // Default to non-posted

    cds_pd_rd_wp                   = '0;
    cds_wr_data.parity             = {{($bits(cds_wr_data.parity)-(`HQM_CSR_SIZE/32)){1'b0}}, np_wr_data_par};
    cds_wr_data.data               = {{($bits(cds_wr_data.data)-$bits(np_wr_data)){1'b0}}, np_wr_data};
    cds_wr_data2                   = '0;
    cds_pdw_size_err_wp            = '0;

    pd_cnt_nxt                     = '0;

    if (sb_cds_msg_irdy) begin

        cds_wr_data.parity = {{($bits(cds_wr_data.parity)-2){1'b0}}, (^sb_cds_msg.sdata), (^sb_cds_msg.data)};
        cds_wr_data.data   = {{($bits(cds_wr_data.data)-64){1'b0}}, sb_cds_msg.sdata, sb_cds_msg.data};

    end

    // Signal that we have a valid posted header which can be popped from
    // the TLQ
    // If it's and ingore message with data ticket 3542145
    // or an unsupported req with data
    // HSD 4728269 - drop txn if parity error in posted header queue
    // HSD 5313939 - return 2 credits instead of just 1 for a posted txn > 4DW

    else if (pd_queue_flush | ((ph_wodval_in_tlq | ph_wdval_in_tlq) & cds_hdr_v)) begin

        // Pop the posted data when there is a valid header & data present.
        // This logic makes the assumption that the maximum data size for all RI to
        // CPP transactions is 64 bytes (one data packet for each header).

        cds_pd_rd_wp = tlq_pdataval_wp &
                        (pd_queue_flush | (tlq_phdr_rxp.cmd != `HQM_TDL_PHDR_USR_ND));

        // RI only supports data transactions of 64 bytes or less.
        // -- use this to detect txns > 16 DW, not 64 bits, and pop the posted data queue twice

        cds_pdw_size_err_wp = (tlq_phdr_rxp.length > 10'd16) | (tlq_phdr_rxp.length == 10'd0);

        if (pdata_first_cycle) begin
          if (tlq_phdr_rxp.length == 10'h0) begin
            pd_cnt_nxt  = 8'h80;
          end else begin
            pd_cnt_nxt  = (tlq_phdr_rxp.length + 10'd7) >> 3;   // number of 256 bit posted data transfers
          end
        end else begin
          pd_cnt_nxt = pd_cnt - 8'h1;
        end

        cds_wr_data  = (pdata_second_cycle) ? pdata_first_cycle_data : tlq_pdata_rxp;
        cds_wr_data2 = tlq_pdata_rxp;

    end // if valid posted header

end // always cds_pd_rd_p

//-------------------------------------------------------------------------
// HSD 5313939 - posted data > 4 DW causes hang
//-------------------------------------------------------------------------
// if a posted transaction comes with > 8 DW of data, it will take one more
// entry in the TLQ.  So cds_pd_rd_wp will need to be popped an extra time.

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pd_queue_flush_p
  if (~prim_gated_rst_b) begin
    pd_queue_flush <= 1'b0;
  end else if (~pd_queue_flush & cds_pd_rd_wp & cds_pdw_size_err_wp) begin
    pd_queue_flush <= 1'b1;
  end else if ( pd_queue_flush & cds_pd_rd_wp & pdata_last_cycle) begin
    pd_queue_flush <= 1'b0;
  end
end

//-------------------------------------------------------------------------
// Detect parity error within data
//-------------------------------------------------------------------------
// if a posted transaction comes with > 8 DW of data, it will take one more
// entry in the TLQ.  So cds_pd_rd_wp will need to be popped an extra time.

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pd_par_err_p
  if (~prim_gated_rst_b) begin
    pd_par_err_or <= 1'b0;
  end else if (cds_pd_rd_wp & ~cds_phdr_rd_wp & tlq_cds_pdata_par_err) begin
    pd_par_err_or <= 1'b1;
  end else if (cds_phdr_rd_wp) begin
    pd_par_err_or <= 1'b0;
  end
end

// Count of posted data beats, set to number of beats for second beat, so value of 2 indicates last beat

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pd_cnt_p
  if (~prim_gated_rst_b) begin
    pd_cnt <= '0;
  end else if (cds_pd_rd_wp) begin
    pd_cnt <= pd_cnt_nxt;
  end
end

//-------------------------------------------------------------------------
// Indicate first or second cycle of pdata
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pdata_cycle_p
    if (~prim_gated_rst_b) begin
        pdata_first_cycle  <= 1'b1;
        pdata_second_cycle <= 1'b0;
    end else if (cds_phdr_rd_wp) begin
        pdata_first_cycle  <= 1'b1;
        pdata_second_cycle <= 1'b0;
    end else if (cds_pd_rd_wp) begin
        pdata_first_cycle  <= 1'b0;
        pdata_second_cycle <= pdata_first_cycle;
    end
end

assign pdata_last_cycle = (pd_cnt == 8'h2) | (tlq_phdr_rxp.length <= 10'd8);

//-------------------------------------------------------------------------
// Capture first cycle of posted data when there is a second cycle expected
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: pdata_first_cycle_data_p
    if (~prim_gated_rst_b) begin
        pdata_first_cycle_data <= '0;
    end else if (cds_pd_rd_wp & pdata_first_cycle) begin
        pdata_first_cycle_data <= tlq_pdata_rxp;
    end
end

//-------------------------------------------------------------------------
// Pending logic for requests
//-------------------------------------------------------------------------

assign mmio_wr_done = pend_mmio_wr & ~csr_stall &
                        (mmio_wr_sai_ok | mmio_wr_sai_error);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin

    // Signal that an MMIO config read has been issued and that we are
    // waiting to send out it's OBC

    if (~prim_gated_rst_b) begin

        pend_mmio_rd     <= '0;
        pend_mmio_wr     <= '0;
        pend_cfg_rd      <= '0;
        pend_cfg_wr      <= '0;
        pend_iosf_sb_rd  <= '0;
        pend_iosf_sb_wr  <= '0;
        np_csr_obc_stall <= '0;

    end else begin

      if (dec_mmio_rd_req) begin
        pend_mmio_rd     <= '1;
      end else if (pend_mmio_rd & (cds2ob_mmio_req |
                                    (pend_iosf_sb_rd & cds_sb_rdack_next))) begin
        pend_mmio_rd     <= '0;
      end

      if (dec_mmio_wr_req) begin
        pend_mmio_wr     <= '1;
      end else if (pend_mmio_wr & mmio_wr_done) begin
        pend_mmio_wr     <= '0;
      end

      if (dec_cbd_cfg_rd) begin
        pend_cfg_rd      <= '1;
      end else if (pend_cfg_rd  & (cds2ob_cfg_req |
                                    (pend_iosf_sb_rd & cds_sb_rdack_next))) begin
        pend_cfg_rd      <= '0;
      end

      if (dec_cbd_cfg_wr) begin
        pend_cfg_wr      <= '1;
      end else if (pend_cfg_wr  & (cds2ob_cfg_req |
                                    (pend_iosf_sb_wr & cds_sb_wrack_next))) begin
        pend_cfg_wr      <= '0;
      end

      if (dec_mmio_rd_req | dec_cbd_cfg_rd) begin
        pend_iosf_sb_rd  <= cbd_hdr.iosfsb[2];
      end else if (pend_iosf_sb_rd & cds_sb_rdack_next) begin
        pend_iosf_sb_rd  <= '0;
      end

      if (dec_mmio_wr_req | dec_cbd_cfg_wr) begin
        pend_iosf_sb_wr  <= cbd_hdr.iosfsb[2];
      end else if (pend_iosf_sb_wr & cds_sb_wrack_next) begin
        pend_iosf_sb_wr  <= '0;
      end

      // The next CSR read/write request to the CSR FUB cannot be issued until
      // the OBC for the previous CSR transaction has been sent. The following
      // will signal when a CSR command has been issued to the CSR FUB but
      // the OBC for the command has not yet been sent.

      if (dec_cbd_cfg_rd | dec_cbd_cfg_wr | dec_mmio_rd_req | dec_mmio_wr_req) begin
        np_csr_obc_stall <= '1;
      end else if (~csr_stall) begin
        np_csr_obc_stall <= '0;
      end

    end

end

//-------------------------------------------------------------------------
// Pending Outbound completion from Config Transaction
//-------------------------------------------------------------------------
// Store the CSR read data in the event that the OBC is not ready to
// take the header and data on this clock

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: last_cfg_rd_data_p
    if (~prim_gated_rst_b) begin
      last_cfg_rd_data          <= '0;
      last_csr_rd_ur            <= '0;
      last_csr_rd_sai_error     <= '0;
      last_csr_rd_timeout_error <= '0;
    end else if (csr_rd_data_val_wp & (pend_cfg_rd | pend_mmio_rd))  begin
      last_cfg_rd_data          <= csr_rd_data_wxp;
      last_csr_rd_ur            <= csr_rd_ur;
      last_csr_rd_sai_error     <= csr_rd_sai_error;
      last_csr_rd_timeout_error <= csr_rd_timeout_error;
    end else if (pend_cfg_wr)  begin
      last_cfg_rd_data          <= '1;
      last_csr_rd_ur            <= '0;
      last_csr_rd_sai_error     <= '0;
      last_csr_rd_timeout_error <= '0;
    end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: last_cfg_wr_ur_p
    if (~prim_gated_rst_b) begin
      last_cfg_wr_ur            <= '0;
      last_cfg_wr_sai_error     <= '0;
    end else if (pend_cfg_wr)  begin
      last_cfg_wr_ur            <= cfg_wr_ur;
      last_cfg_wr_sai_error     <= cfg_wr_sai_error;
    end else if (csr_rd_data_val_wp & (pend_cfg_rd | pend_mmio_rd))  begin
      last_cfg_wr_ur            <= '0;
      last_cfg_wr_sai_error     <= '0;
    end

end

//-------------------------------------------------------------------------
// Outbound Completion Data for CSR read/write
//-------------------------------------------------------------------------

always_comb begin: cfg2ob_data_p

    // We must be prepared to forward the read data immediately in the event
    // that the OBC FUB is ready to take it.  Otherwise, we must hold the
    // data until the CSR completion header is posted to the OBC.
    // BTW: CSR writes generate a completion with data=ffffffff

    cds_cfg2ob_data_wxp =
        (csr_rd_data_val_wp & (pend_cfg_rd | pend_mmio_rd)) ? csr_rd_data_wxp :
            ((pend_cfg_wr) ? '1 : last_cfg_rd_data);

    cds_cfg2ob_dpar_wxp =
        (csr_rd_data_val_wp & (pend_cfg_rd | pend_mmio_rd)) ? (^csr_rd_data_wxp) :
            ((pend_cfg_wr) ? '0 : (^last_cfg_rd_data));

    // The internally generated data for outbound completions comes from
    // the following sources; 1) CSR read or write completion data or
    // 2) Completions for unsupported non posted requests (e.g. memory read
    // to a physical function which is in the D3 state) 3) From MSIX table
    // reads. 4) MISCBAR reserved memory read.

    obcpl_fifo_push_data =
        (usr_npmem_req | cbd_cfg_usr_func | cbd_cfg_prim_quiesce) ? '1 :
            cds_cfg2ob_data_wxp;

    obcpl_fifo_push_dpar =
        (usr_npmem_req | cbd_cfg_usr_func | cbd_cfg_prim_quiesce) ? '0 :
            cds_cfg2ob_dpar_wxp;

end

//-------------------------------------------------------------------------
// Outbound completion requests
//-------------------------------------------------------------------------

always_comb begin: cds2ob_req_p

    // These will assert when storage for an OBC hdr is available and the
    // stall deasserts, indicating that the ack for the request was received.

    cds2ob_cfg_req  = ((pend_cfg_rd & ~pend_iosf_sb_rd) |
                       (pend_cfg_wr & ~pend_iosf_sb_wr)) &
                        ~(obcpl_fifo_afull | np_csr_obc_stall);

    cds2ob_mmio_req = pend_mmio_rd & ~pend_iosf_sb_rd &
                        ~(obcpl_fifo_afull | np_csr_obc_stall);

    // These will assert when storage for an OBC hdr is available with no
    // need to stall as we are throwing away the transactions.

    cds2ob_uns_np_req   = (cbd_uns_npcmd | cbd_poisoned_np) &
        ~(cds_err_stall | obcpl_fifo_afull | cbd_hdr.iosfsb[2]);

    cds2ob_uns_func_req = (cbd_cfg_usr_func | cbd_cfg_prim_quiesce) &
        ~(cds_err_stall | obcpl_fifo_afull | cbd_hdr.iosfsb[2]);
end

upd_enables_t   local_upd_enables;

always_comb begin: cds_obchdr_rdy_p

    // Signal the outbound completion FUB that CDS has a valid completion
    // header ready and waiting.

    obcpl_fifo_push = cds2ob_cfg_req | cds2ob_mmio_req | usr_npmem_req |
                            cds2ob_uns_np_req | cds2ob_uns_func_req;

    // Capture the current value of the BME, MSIE, and MSIXE bits for this
    // function so they can be passed to the ri_obc, and ultimately to the
    // ti_trn ioq for use in determining whether to invalidate subsequent
    // associated transactions for the function.
    // Note that the bits will have already been updated for any completion
    // for a CFG write that changed them.
    // If sideband updates the BME, MSIE, or MSIXE bits, need to inform
    // the ti_trn directly to update its local copies.

    local_upd_enables = '0;

    if (cbd_cfg_wr) begin
        if (cbd_hdr.addr[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
             hqm_pf_cfg_pkg::DEVICE_COMMAND_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]) begin

                local_upd_enables.enable = BME;                                    // Update local BME
                local_upd_enables.value  = ri_bme_rxl;

        end else if (cbd_hdr.addr[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2] ==
             hqm_pf_cfg_pkg::MSIX_CAP_CONTROL_CR_ADDR[hqm_rtlgen_pkg_v12::CR_CFG_ADDR_HI:2]) begin

                local_upd_enables.enable = MSIXE;                                  // Update local MSIXE
                local_upd_enables.value  = csr_pmsixctl_msie_wxp;
        end
    end

    obcpl_fifo_push_enables = '0;
    gpsb_upd_enables        = '0;

    if (~cbd_hdr.iosfsb[2]) begin

        obcpl_fifo_push_enables    = local_upd_enables;

    end else if (cds_take_decode) begin

        gpsb_upd_enables = local_upd_enables;

    end

end

// Since the err msg is routed to ri_int, use the msgack to release
// err_gen_msg from ri_err.  If the sb mstr is not ready, the request
// (err_sb_msgavail) will remain asserted until sb acknowledges the
// ep->sb msg.

assign cds_err_msg_gnt = err_sb_msgack;

//-------------------------------------------------------------------------
// Build the outbound completion header
// If there is a USR and supported_funcs is not true then always default to
// take function zero's bus number
//-------------------------------------------------------------------------

always_comb begin: cds2ob_cplhdr_p

    // Create an outbound header for the completion

    cds2ob_cplhdr         = '0;

    cds2ob_cplhdr.length  = (~pend_cfg_wr) ? cbd_hdr.length :
                           ((last_cfg_wr_ur | last_cfg_wr_sai_error) ? 10'h1 : 10'h0);
    cds2ob_cplhdr.startbe = (cbd_cfg_req) ? 4'hf : cbd_hdr.startbe;
    cds2ob_cplhdr.endbe   = (cbd_cfg_req) ? 4'h0 : cbd_hdr.endbe;
    cds2ob_cplhdr.attr    = cbd_hdr.attr;
    cds2ob_cplhdr.tag     = cbd_hdr.tag;
    cds2ob_cplhdr.rid     = cbd_hdr.reqid;
    cds2ob_cplhdr.tc      = cbd_hdr.tc;
    cds2ob_cplhdr.fmt     = pend_cfg_rd | pend_mmio_rd;
    cds2ob_cplhdr.ep      = '0;
    cds2ob_cplhdr.addr    = '0;
    cds2ob_cplhdr.pm      = '0;
    cds2ob_cplhdr.lok     = '0;
    cds2ob_cplhdr.cs      = '0;                         // 000 = successful completion

    if (cbd_hdr_pciecmd_mrd) begin

      cds2ob_cplhdr.addr[6:2] = cbd_hdr.addr[6:2];

           if (cbd_hdr.startbe[1:0] ==   2'b10) cds2ob_cplhdr.addr[1:0] = 2'b01;
      else if (cbd_hdr.startbe[2:0] ==  3'b100) cds2ob_cplhdr.addr[1:0] = 2'b10;
      else if (cbd_hdr.startbe[3:0] == 4'b1000) cds2ob_cplhdr.addr[1:0] = 2'b11;
      else                                      cds2ob_cplhdr.addr[1:0] = 2'b00;

    end

`ifdef HQM_SFI

    // Passing the upper 4 SFI tag bits in cid[4:0] field.
    // sfi_rx_xlate currently passes these in the pasid[4:0] field.

    cds2ob_cplhdr.cid     = {current_bus, 4'd0, cbd_hdr.pasidtlp[3:0]};

`else

    cds2ob_cplhdr.cid     = {current_bus, 8'd0};

`endif

    cds2ob_cplhdr.par     = ^cds2ob_cplhdr;

    // Create an outbound header for the completion if it was errored

    cds2ob_err_cplhdr     = cds2ob_cplhdr;

    cds2ob_err_cplhdr.pm  = {2{ri_pf_disabled_wxp}};
    cds2ob_err_cplhdr.cs  = 3'd1;                       // 001 = unsupported request
    cds2ob_err_cplhdr.fmt = '0;                         // No data for CPL
    cds2ob_err_cplhdr.lok = cbd_hdr_pciecmd_mrdlk;      // Send CPLLK instead of CPL for MRDLK

    // Byte count must be operand size for atomic transactions, 4 or 8 for IO transactions,
    // and 4 for everything else but memory reads where it needs to be the actual byte count.

    if (cbd_hdr_pciecmd_atomic_1op | cbd_hdr_pciecmd_io) begin
        cds2ob_err_cplhdr.startbe = 4'hf;
        cds2ob_err_cplhdr.endbe   = (cbd_hdr.length > 10'd1) ? 4'hf : 4'h0;
    end else if (cbd_hdr_pciecmd_atomic_2op) begin
        cds2ob_err_cplhdr.startbe = 4'hf;
        cds2ob_err_cplhdr.endbe   = 4'hf;
        cds2ob_err_cplhdr.length  = {1'b0, cbd_hdr.length[9:1]};
    end else if (~cbd_hdr_pciecmd_mrd) begin
        cds2ob_err_cplhdr.startbe = 4'hf;
        cds2ob_err_cplhdr.endbe   = 4'h0;
    end

    // pm does not contribute. Adjust for fmt, cs, lok, startbe, endbe

    cds2ob_err_cplhdr.par = ^{(~cds2ob_cplhdr.par)      // Account for cs  being set
                             ,(cds2ob_cplhdr.fmt)       // Account for fmt being reset
                             ,cbd_hdr_pciecmd_mrdlk
                             ,({4{(cbd_hdr_pciecmd_io | cbd_hdr_pciecmd_atomic_1op | cbd_hdr_pciecmd_atomic_2op | ~cbd_hdr_pciecmd_mrd)}} & cds2ob_cplhdr.startbe)
                             ,({4{(cbd_hdr_pciecmd_io | cbd_hdr_pciecmd_atomic_1op | cbd_hdr_pciecmd_atomic_2op | ~cbd_hdr_pciecmd_mrd)}} & cds2ob_cplhdr.endbe)
                             ,(cbd_hdr_pciecmd_atomic_2op & cbd_hdr.length[0])
    };

end // always_comb cds2ob_cplhdr_p

//-------------------------------------------------------------------------
// The next outbound completion header to be queued
//-------------------------------------------------------------------------

always_comb begin: cds_obc_hdr_p

    // The outbound completion header can be generated from a;
    // 1) config space CSR read/write
    // 2) mem space CSR read
    // 3) an unsupported request
    // 4) CSR read/write to an unsupported function.

    obcpl_fifo_push_hdr = cds2ob_err_cplhdr;

    if ((cds2ob_cfg_req  & ~last_csr_rd_sai_error & ~last_csr_rd_ur &
                           ~last_cfg_wr_sai_error & ~last_cfg_wr_ur) |
        (cds2ob_mmio_req & ~last_csr_rd_sai_error & ~last_csr_rd_timeout_error)) begin

        obcpl_fifo_push_hdr = cds2ob_cplhdr;

    end

end // always_comb cds_obc_hdr_p

//-------------------------------------------------------------------------
// Bus and Device Number per Function for the last CSR Write
// If there is a CSR write, record the bus and device ID for the given function.
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: current_bus_p

    if (~prim_gated_rst_b) begin

        current_bus <= '0;

    end else if (csr_req_wr & ~cbd_hdr_mmio & ~cbd_hdr.iosfsb[2]) begin

        // Run through each function and see if there is a write to the given
        // function. If so, change the current bus and device number to the
        // bus and device of this CSR write.

        if (~(|csr_req.csr_wr_func)) begin
            current_bus <= cbd_hdr.addr[`HQM_CSR_ADDR_BUS];
        end
    end

end

//------------------------------------------------------------------------
// JCAM CSR READ DATA
// ssabneka: Added for nCPM , IOSF SB CSR read data
//------------------------------------------------------------------------

assign cds_sb_wr_ur_next =

    // Normal CFG or MMIO write request completions w/ error

    (pend_iosf_sb_wr & (cfg_wr_ur | cfg_wr_sai_error |
                        (mmio_wr_done & (mmio_wr_sai_error | csr_wr_error)))) |

    // Errored CFG or MMIO write request being thrown away

    (cbd_decode_val[0] & cbd_hdr_iosfsb & sb_cds_wr_q &
        ((cbd_hdr.posted) ?
            (cbd_drop_flr_p  | mem_req_gen_usr  | cbd_uns_pcmd  | cbd_poisoned_p  |
             cbd_drop_hpar   | usr_pmem_req) :
            (cbd_drop_flr_np | mem_req_gen_usr  | cbd_uns_npcmd | cbd_poisoned_np |
             cbd_drop_hpar   | cbd_cfg_usr_func | cbd_cfg_sb_bad_len)));

assign cds_sb_wrack_next =

    // Set for UR completion or normal completion w/o error

    cds_sb_wr_ur_next | (pend_iosf_sb_wr & (cfg_wr_sai_ok |
                                            (mmio_wr_done & mmio_wr_sai_ok)));

assign cds_sb_rd_ur_next =

    // Normal CFG or MMIO read request completions w/ error

    (pend_iosf_sb_rd & csr_rd_data_val_wp &
        (csr_rd_ur | csr_rd_sai_error | csr_rd_timeout_error | (|csr_rd_error))) |

    // Errored CFG or MMIO read request being thrown away

    (cbd_decode_val[0] & cbd_hdr_iosfsb & sb_cds_rd_q &
        (cbd_drop_flr_np | mem_req_gen_usr  | cbd_uns_npcmd | cbd_poisoned_np |
         cbd_drop_hpar   | cbd_cfg_usr_func | cbd_cfg_sb_bad_len));

assign cds_sb_rdack_next =

    // Set for UR completion or normal completion w/o error

    cds_sb_rd_ur_next | (pend_iosf_sb_rd & csr_rd_data_val_wp);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin: ep_rdack_p
    if (~prim_gated_rst_b) begin
        cds_sb_rdack  <= '0;
        cds_sb_wrack  <= '0;
        cds_sb_rd_ur  <= '0;
        cds_sb_wr_ur  <= '0;
        cds_sb_np     <= '0;
        cds_sb_rddata <= '0;
    end else begin
        cds_sb_rdack  <= cds_sb_rdack_next;
        cds_sb_wrack  <= cds_sb_wrack_next;
        cds_sb_rd_ur  <= cds_sb_rd_ur_next;
        cds_sb_wr_ur  <= cds_sb_wr_ur_next;
        cds_sb_np     <= sb_cds_msg.np;
        if (cbd_cfg_usr_func) begin
            cds_sb_rddata <= '1;
        end else if (cds_sb_rd_ur_next | cds_sb_wr_ur_next) begin
            cds_sb_rddata <= '0;
        end else if (cds_sb_rdack_next) begin
            cds_sb_rddata <= csr_rd_data_wxp;
        end
    end
end

always_comb begin: populate_cmsg_to_sb_g

    cds_sb_cmsg       = '0;

    cds_sb_cmsg.vld   = cds_sb_wrack & cds_sb_np;
    cds_sb_cmsg.dvld  = cds_sb_rdack;
    cds_sb_cmsg.eom   = (cds_sb_wrack & cds_sb_np) | cds_sb_rdack;
    cds_sb_cmsg.ursp  = cds_sb_rd_ur | cds_sb_wr_ur;
    cds_sb_cmsg.rdata = {32'd0, cds_sb_rddata};

end: populate_cmsg_to_sb_g

//-------------------------------------------------------------------------
// Next Config Transaction Function in Reset
//-------------------------------------------------------------------------

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin
        func_in_rst_q <= '0;
    end else if (~pend_cfg_wr | cds2ob_cfg_req) begin
        func_in_rst_q <= func_in_rst;
    end
end

//-------------------------------------------------------------------------
// IDLE indication
//-------------------------------------------------------------------------

assign cds_idle = ~|{
     cbd_busy
    ,hcw_wr_buff_wp
};

//-------------------------------------------------------------------------
// NOA Signals from CDS
//-------------------------------------------------------------------------

always_comb begin

    cds_noa = { cbd_func_pf_bar_hit[0],     // 47
                1'd0,                       // 46
                cbd_func_pf_rgn_hit[1:0],   // 45:44
                cbd_csr_pf_rgn_hit[1:0],    // 43:42
                2'd0,                       // 41:40
                csr_rd_ur,                  // 39
                csr_rd_sai_error,           // 38
                csr_rd_timeout_error,       // 37
                mmio_wr_sai_error,          // 36
                mmio_wr_sai_ok,             // 35
                cfg_wr_ur,                  // 34
                cfg_wr_sai_error,           // 33
                cfg_wr_sai_ok,              // 32
                cbd_csr_pf_bar_hit,         // 31
                tlq_cds_phdr_par_err,       // 30
                tlq_cds_pdata_par_err,      // 29
                tlq_cds_nphdr_par_err,      // 28
                tlq_cds_npdata_par_err,     // 27
                cds_err_msg_gnt,            // 26
                cds_malform_pkt,            // 25
                cds_npusr_err_wp,           // 24
                cds_usr_in_cpl,             // 23
                cds_pusr_err_wp,            // 22
                cds_cfg_usr_func,           // 21
                cds_take_decode,            // 20
                cds_poison_err_wp,          // 19
                cds_bar_decode_err_wp,      // 18
                tlq_phdrval_wp,             // 17
                tlq_nphdrval_wp,            // 16
                tlq_pdataval_wp,            // 15
                tlq_npdataval_wp,           // 14
                tlq_ioqval_wp,              // 13
                cds_phdr_rd_wp,             // 12
                cds_nphdr_rd_wp,            // 11
                cds_npd_rd_wp,              // 10
                cds_pd_rd_wp,               // 9
                cds_hdr_v,                  // 8
                cds_hdr.addr[6:2],          // 7:3
                cbd_decode_val[0],          // 2
                mem_hit_csr_pf_rgn,         // 1
                cbd_rdy                     // 0
    };
end

// Lint Note 1
// 70036 errors - often sites structures which are only partially used.  No problem there.
// Several signals should be used in assertions even if unused in RTL.
// Signal pm_pf_rst_wxp (pm_pf_rst_wxp[23:8]) is driven but unused in parent module ri_cds
// Signal obc_cds_data_for_iosfsb (obc_cds_data_for_iosfsb[63:32]) is driven but unused in parent module ri_cds
// Signal iosfsb_fid (iosfsb_fid[7]) is driven but unused in parent module ri_cds
// Signal sb_csr_iacppcsr (sb_csr_iacppcsr.ia_msg_outs ,
//                         sb_csr_iacppcsr.cpp_msg_outs , sb_csr_iacppcsr.ia_illegalmsg_ack...
// Signal csr_cds_cpp2iosfsb_rsts (csr_cds_cpp2iosfsb_rsts[1]) is driven but unused in parent module ri_cds
// Signal cbd_bar_hit (cbd_bar_hit[16]) is driven but unused in parent module ri_cds
// Signal cbd_region_off_ad_wxp (cbd_region_off_ad_wxp[20:19]) is driven but unused in parent module ri_cds
// Signal cbd_me_cpp_ad (cbd_me_cpp_ad[20:19]) is driven but unused in parent module ri_cds
// Signal cds_msix2ob_data (cds_msix2ob_data[63:32]) is driven but unused in parent module ri_cds
// Signal ti_cfgaddr_ff (ti_cfgaddr_ff[11:10]) is driven but unused in parent module ri_cds
// Signal null_cppcmd_gnt is driven but unused in parent module ri_cds
// Signal restricted_access_allowed is driven but unused -- created mostly FYI and for consistency,
//        even if its not used in RTL
// Signal cbd_bar_offset (cbd_bar_offset[27:22]) is driven but unused in parent module ri_cds - started happening after removing IO address decodes.
// Signal pend_cpp_cmd (pend_cpp_cmd.ppid.signal_num[3:0]) is driven but unused in parent module ri_cds - started happening after removing IO address decodes.

// make an assertion:
// Signal cds_pf0_misc_rgn_err_wp is driven but unused in parent module ri_cds
// Signal cds_msix_addr_pf0_err_wp is driven but unused in parent module ri_cds


//-------------------------------------------------------------------------
// Assertions and Coverage
//-------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF

//////////////////////////////////////////////////////////////////
// Assertions - CPM 1.7 and CPM 1.75 and beyond
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// SV Coverage - CPM 1.7 and CPM 1.75 and beyond
/////////////////////////////////////////////////////////////////

// Check that each flavor of the SB transactions sent to hqm_ri_cds collided with a PC granted transaction

SB_CFGRD_ARBITRATED_WITH_PC_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    sb_cds_msg.irdy & prim_side_arb_winner_v & prim_side_arb_winner & sb_cds_msg.cfgrd);

SB_CFGWR_ARBITRATED_WITH_PC_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    sb_cds_msg.irdy & prim_side_arb_winner_v & prim_side_arb_winner & sb_cds_msg.cfgwr);

SB_MEMRD_ARBITRATED_WITH_PC_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    sb_cds_msg.irdy & prim_side_arb_winner_v & prim_side_arb_winner & sb_cds_msg.mmiord);

SB_MEMWR_ARBITRATED_WITH_PC_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    sb_cds_msg.irdy & prim_side_arb_winner_v & prim_side_arb_winner & sb_cds_msg.mmiowr);

// Check that each flavor of the PC transactions sent to hqm_ri_cds collided with a SB granted transaction
// This could be expanded to handle URed and Ingored I added only good transactions.

PC_CFGRD_ARBITRATED_WITH_SB_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    tlq_ioqval_wp_2arb & prim_side_arb_winner_v & ~prim_side_arb_winner & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_CFG_RD));

PC_CFGWR_ARBITRATED_WITH_SB_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    tlq_ioqval_wp_2arb & prim_side_arb_winner_v & ~prim_side_arb_winner & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_CFG_WR));

PC_MEMRD_ARBITRATED_WITH_SB_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    tlq_ioqval_wp_2arb & prim_side_arb_winner_v & ~prim_side_arb_winner & (tlq_nphdr_rxp.cmd == `HQM_TDL_NPHDR_MEM_RD));

PC_MEMWR_ARBITRATED_WITH_SB_GRANTED: cover property (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b)
    tlq_ioqval_wp_2arb & prim_side_arb_winner_v & ~prim_side_arb_winner & (tlq_phdr_rxp.cmd  == `HQM_TDL_PHDR_WR));


`endif //  `ifndef INTEL_SVA_OFF

endmodule // hqm_ri_cds

