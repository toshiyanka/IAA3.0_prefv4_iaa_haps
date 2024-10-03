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

module hqm_ri_csr_ctl

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_sif_pkg::*, hqm_sif_csr_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic                                       prim_freerun_clk        // Primary clock ungated
    ,input  logic                                       prim_nonflr_clk         // Primary FLR gated clock
    ,input  logic                                       prim_gated_clk          // Primary gated clock
    ,input  logic                                       prim_gated_rst_b        // Active low reset from the SHAC in the P_clk
                                                                                // domain. This reset will also be synced to the
                                                                                // link clock domain. This will reset all flops in
                                                                                // the receive interface.
    ,input  logic                                       powergood_rst_b         // PowerGood signal used to reset all
                                                                                // registers including sticky register.
    ,input  logic                                       pm_rst                  // Early indication flr reset is coming
    ,input  logic                                       pm_pf_rst_wxp           // power management derived reset (enter D3)
    ,output logic                                       hard_rst_np             // Hard reset for CSRs
    ,output logic                                       soft_rst_np             // Soft reset for CSRs
    ,output logic                                       flr_treatment_vec

    // HSD 4728428 - DFX scan control inputs to drive reset

    ,input  logic                                       fscan_rstbypen          
    ,input  logic                                       fscan_byprst_b          
 
    ,input  hqm_sif_csr_pkg::MMIO_TIMEOUT_t             cfg_mmio_timeout        // Timeout configuration for MMIO requests
    ,output logic                                       mmio_timeout_error      // Timeout error on MMIO request (pulse)
    ,output logic [7:0]                                 mmio_timeout_syndrome   // Timeout error syndrome on MMIO request

    //-----------------------------------------------------------------
    // Interface with hqm_ri_cds block 
    //-----------------------------------------------------------------

    ,input  logic                                       csr_req_wr              // The CSR write signal
    ,input  logic                                       csr_req_rd              // The CSR read signal
    ,input  hqm_system_csr_req_t                        csr_req                 // The CSR request signals

    ,output logic                                       csr_rd_data_val_wp      // The CSR read data is ready
    ,output logic [`HQM_CSR_SIZE-1:0]                   csr_rd_data_wxp         // CSR read data
    ,output logic                                       csr_stall               // CSR Force Serialization 
    ,output logic                                       csr_rd_ur               // CSR read UR (CFG address >=0x1000)
    ,output logic [1:0]                                 csr_rd_error            // CSR read target error (1:pslverr, 0:read data parity error)
    ,output logic                                       csr_rd_sai_error        // CSR read SAI error
    ,output logic                                       csr_rd_timeout_error    // CSR read timeout error
    ,output logic                                       cfg_wr_ur               // CFG write (NP) UR error
    ,output logic                                       csr_wr_error            // CFG write (NP) target error
    ,output logic                                       cfg_wr_sai_error        // CFG write (NP) SAI error
    ,output logic                                       cfg_wr_sai_ok           // CFG write (NP) SAI ok
    ,output logic                                       mmio_wr_sai_error       // MMIO write (NP) SAI error
    ,output logic                                       mmio_wr_sai_ok          // MMIO write (NP) SAI ok

    //-----------------------------------------------------------------
    // hqm_pf_cfg request signals
    //-----------------------------------------------------------------

    ,output logic                                       hqm_csr_pf0_rst_n
    ,output logic                                       hqm_csr_pf0_pwr_rst_n
    ,output hqm_rtlgen_pkg_v12::cfg_req_32bit_t         hqm_csr_pf0_req
    ,input  hqm_rtlgen_pkg_v12::cfg_ack_32bit_t         hqm_csr_pf0_ack

    //-----------------------------------------------------------------
    // hqm_pf_cfg indication to stall CSR accesses due to previous ppmcsr write
    //-----------------------------------------------------------------

    ,input  logic                                       ppmcsr_wr_stall

    //-----------------------------------------------------------------
    // CSR BAR internal and external address
    //-----------------------------------------------------------------

    ,output logic [47:0]                                hqm_sif_csr_hc_addr

    //-----------------------------------------------------------------
    // CSR BAR internal memory mapped IO (hqm_sif_csr)
    //-----------------------------------------------------------------

    ,output logic                                       hqm_csr_mmio_rst_n
    ,output hqm_rtlgen_pkg_v12::cfg_req_32bit_t         hqm_csr_int_mmio_req
    ,input  hqm_rtlgen_pkg_v12::cfg_ack_32bit_t         hqm_csr_int_mmio_ack

    //-----------------------------------------------------------------
    // CSR BAR external memory mapped IO (hqm_proc)
    //-----------------------------------------------------------------

    ,output hqm_rtlgen_pkg_v12::cfg_req_32bit_t         hqm_csr_ext_mmio_req
    ,output logic                                       hqm_csr_ext_mmio_req_apar
    ,output logic                                       hqm_csr_ext_mmio_req_dpar
    ,input  hqm_rtlgen_pkg_v12::cfg_ack_32bit_t         hqm_csr_ext_mmio_ack
    ,input  logic [1:0]                                 hqm_csr_ext_mmio_ack_err
    ,input  logic                                       cfgm_timeout_error

    //-----------------------------------------------------------------
    // NOA CSR debug signals  
    //-----------------------------------------------------------------

    ,output logic [111:0]                               csr_noa
);
    
logic                               csr_req_wr_q;                   // The CSR write signal
logic                               csr_req_rd_q;                   // The CSR read signal

logic                               mmio_timeout_next;
logic                               mmio_timeout_q;
logic [31:0]                        mmio_cnt_next;
logic [31:0]                        mmio_cnt_q;

logic                               zero_length_rd_next;
logic                               zero_length_rd_q;

hqm_system_csr_req_t                csr_req_q;

logic                               csr_rd_stall;                   // Pending CSR read
logic                               csr_wr_stall;                   // Pending CSR write
      
// CSR access restriction signals
logic                               csr_ext_mem_mapped_q;        // Flopped version of effective csr_ext_mem_mapped input
logic                               eff_csr_ext_mem_mapped;      // Effective csr_ext_mem_mapped input for current access
logic                               csr_func_pf_mem_mapped_q;    // Flopped version of effective csr_func_pf_mem_mapped input
logic                               eff_csr_func_pf_mem_mapped;  // Effective csr_func_pf_mem_mapped input for current access

// Reset related signals
logic                               soft_rst_np_pre_scan;        
logic                               flr_treatment_q;        
logic                               flr_treatment_q0;        
  
// Memory mapped request signals - common for all memory mapped interfaces
hqm_rtlgen_pkg_v12::cfg_req_32bit_t                 hqm_csr_mmio_req_new;
hqm_rtlgen_pkg_v12::cfg_req_32bit_t                 hqm_csr_mmio_req;
hqm_rtlgen_pkg_v12::cfg_req_32bit_t                 hqm_csr_mmio_req_q;
logic [5:0]                                         hqm_csr_mmio_req_sai_q;
logic                                               hqm_csr_mmio_req_apar_new;
logic                                               hqm_csr_mmio_req_apar;
logic                                               hqm_csr_mmio_req_apar_q;
logic                                               hqm_csr_mmio_req_dpar_new;
logic                                               hqm_csr_mmio_req_dpar;
logic                                               hqm_csr_mmio_req_dpar_q;

// Asserted if there is an active request without an ack/error
logic                                 hqm_csr_mmio_req_stall;

// control signals
logic                                 csr_pf0_rd_hit;
logic                                 csr_pf0_rd_miss;
logic                                 csr_pf0_rd_ur;
logic                                 csr_pf0_rd_sai_error;
logic                                 cfg_pf0_wr_ur;
logic                                 cfg_pf0_wr_ur_f;
logic                                 cfg_pf0_wr_sai_error;
logic                                 cfg_pf0_wr_sai_error_f;
logic                                 cfg_pf0_wr_sai_ok;
logic                                 cfg_pf0_wr_sai_ok_f;
logic                                 csr_int_mmio_rd_hit;
logic                                 csr_int_mmio_rd_miss;
logic                                 csr_int_mmio_rd_sai_error;
logic                                 csr_int_mmio_rd_timeout_error;
logic                                 csr_int_mmio_wr_sai_error;
logic                                 csr_int_mmio_wr_sai_ok;
logic                                 csr_int_mmio_wr_timeout_error;
logic                                 csr_ext_mmio_rd_hit;
logic                                 csr_ext_mmio_rd_miss;
logic [1:0]                           csr_ext_mmio_rd_error;
logic                                 csr_ext_mmio_rd_sai_error;
logic                                 csr_ext_mmio_rd_timeout_error;
logic                                 csr_ext_mmio_wr_error;
logic                                 csr_ext_mmio_wr_sai_error;
logic                                 csr_ext_mmio_wr_sai_ok;
logic                                 csr_ext_mmio_wr_timeout_error;

logic                                 csr_rd_hit_f;
logic                                 csr_rd_miss_f;
logic [1:0]                           csr_rd_error_f;
logic                                 csr_rd_ur_f;
logic                                 csr_cfg_rd_sai_error_f; // CFG space sai error
logic                                 csr_mem_rd_sai_error_f; // MEM space sai error
logic                                 csr_rd_timeout_error_f;
csr_data_t                            csr_rd_data_f; // The read data
csr_data_t                            pf0_rd_data_f; // The read data
csr_data_t                            int_csr_rd_data_f; // The read data
csr_data_t                            ext_csr_rd_data_f; // The read data

logic                                 csr_wr_error_f;
logic                                 csr_wr_sai_error_f;
logic                                 csr_wr_sai_ok_f;
logic                                 csr_wr_timeout_error_f;

logic                                 csr_timeout_q;

logic                                 cfgm_timeout_error_qual;

hqm_rtlgen_pkg_v12::cfg_ack_32bit_t   hqm_csr_pf0_ack_qual;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t   hqm_csr_int_mmio_ack_qual;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t   hqm_csr_ext_mmio_ack_qual;
logic [1:0]                           hqm_csr_ext_mmio_ack_err_qual;

// ------------------------------------------------------------------------
// Qualifier formed from early FLR indication
// Set on early indication and remain set until the FLR deasserts.
// Use to gate cfg acks coming back from domains that will be reset by the FLR.
// ------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    flr_treatment_q  <= '0;
    flr_treatment_q0 <= '0;   // Replicate high fanout bit 0
  end else begin
    flr_treatment_q  <= (pm_rst | flr_treatment_q) & ~(pm_pf_rst_wxp & ~soft_rst_np_pre_scan);
    flr_treatment_q0 <= (pm_rst | flr_treatment_q) & ~(pm_pf_rst_wxp & ~soft_rst_np_pre_scan);
  end
end

assign flr_treatment_vec = flr_treatment_q;

always_comb begin: qualify_acks

  cfgm_timeout_error_qual        = ~flr_treatment_q0 & cfgm_timeout_error;
  hqm_csr_pf0_ack_qual           = ~{$bits(hqm_rtlgen_pkg_v12::cfg_ack_32bit_t){flr_treatment_q0}} & hqm_csr_pf0_ack;
  hqm_csr_int_mmio_ack_qual      = ~{$bits(hqm_rtlgen_pkg_v12::cfg_ack_32bit_t){flr_treatment_q0}} & hqm_csr_int_mmio_ack;
  hqm_csr_ext_mmio_ack_qual      = ~{$bits(hqm_rtlgen_pkg_v12::cfg_ack_32bit_t){flr_treatment_q0}} & hqm_csr_ext_mmio_ack;
  hqm_csr_ext_mmio_ack_err_qual  = ~{2{flr_treatment_q0}} & hqm_csr_ext_mmio_ack_err;

end

// Flop single cycle pulse for reads and writes
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin :    hqm_csr_read_wr_q_p
  if(~prim_gated_rst_b) begin
    csr_req_wr_q      <= '0;
    csr_req_rd_q      <= '0;
  end else if (flr_treatment_q0) begin
    csr_req_wr_q      <= '0;
    csr_req_rd_q      <= '0;
  end else begin
    csr_req_wr_q      <= csr_req_wr;
    csr_req_rd_q      <= csr_req_rd;
  end
end

// Flop request signals when read or write pulse is active
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin :    hqm_csr_req_q_p
  if(~prim_gated_rst_b) begin
    csr_req_q               <= '0;
  end else if (flr_treatment_q0) begin
    csr_req_q               <= '0;
  end else if (csr_req_wr | csr_req_rd) begin
    csr_req_q               <= csr_req;
  end
end

assign mmio_cnt_next          = (~csr_stall | mmio_timeout_q) ? 32'd0 : (mmio_cnt_q + {31'd0,csr_stall});
assign mmio_timeout_next      = (cfg_mmio_timeout.TIMEOUT_ENABLE & mmio_cnt_q[cfg_mmio_timeout.TIMEOUT_PWR2]) | (mmio_timeout_q & csr_stall);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    mmio_cnt_q        <= '0;
    mmio_timeout_q    <= '0;
  end else begin
    mmio_cnt_q        <= mmio_cnt_next;
    mmio_timeout_q    <= mmio_timeout_next;
  end
end

assign zero_length_rd_next        = csr_stall & csr_req_q.csr_mem_mapped & (csr_req_q.csr_byte_en == '0) & csr_req_rd_q;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    zero_length_rd_q  <= '0;
  end else begin
    zero_length_rd_q  <= zero_length_rd_next;
  end
end

//-----------------------------------------------------------------
// Translate incoming CSR request into PF CFG and MMIO requests
//    - Capture values with read or write pulse
//    - Set PF CFG requests (assumes they always respond in 1 cycle)
//    - Set MMIO 'new' request (used when first asserting request)
//-----------------------------------------------------------------
always_comb begin : csr_translate_p

  // Set default values
  hqm_csr_pf0_req.valid                       = '0;
  hqm_csr_pf0_req.opcode                      = hqm_rtlgen_pkg_v12::CFGRD;      
  hqm_csr_pf0_req.addr.mem.offset             = '0;
  hqm_csr_pf0_req.be                          = '0;
  hqm_csr_pf0_req.data                        = '0;
      
  hqm_csr_mmio_req_new.valid                  = '0;
  hqm_csr_mmio_req_new.opcode                 = hqm_rtlgen_pkg_v12::MRD;        
  hqm_csr_mmio_req_new.addr.mem.offset        = '0;
  hqm_csr_mmio_req_new.be                     = '0;
  hqm_csr_mmio_req_new.data                   = '0;
  hqm_csr_mmio_req_apar_new                   = '0;
  hqm_csr_mmio_req_dpar_new                   = '0;
      
  // csr write to PF CFG
  if (csr_req_wr_q & ~csr_req_q.csr_mem_mapped & (csr_req_q.csr_wr_func == 8'd0) ) begin
    hqm_csr_pf0_req.valid             = 1'b1;
    hqm_csr_pf0_req.opcode            = hqm_rtlgen_pkg_v12::CFGWR;              
    hqm_csr_pf0_req.addr.mem.offset   = {{($bits(hqm_csr_pf0_req.addr.mem.offset)-$bits(csr_req_q.csr_wr_offset)){1'b0}}, csr_req_q.csr_wr_offset};
    hqm_csr_pf0_req.be                = csr_req_q.csr_byte_en;
    hqm_csr_pf0_req.data              = csr_req_q.csr_wr_dword;
  end else
  // csr read to PF CFG
  if (csr_req_rd_q & ~csr_req_q.csr_mem_mapped & (csr_req_q.csr_rd_func == 8'd0) ) begin
    hqm_csr_pf0_req.valid             = 1'b1;
    hqm_csr_pf0_req.opcode            = hqm_rtlgen_pkg_v12::CFGRD;              
    hqm_csr_pf0_req.addr.mem.offset   = {{($bits(hqm_csr_pf0_req.addr.mem.offset)-$bits(csr_req_q.csr_rd_offset)){1'b0}}, csr_req_q.csr_rd_offset};
    hqm_csr_pf0_req.be                = 4'hF;                                 // set BE - assuming all enabled for reads
    hqm_csr_pf0_req.data              = '0;                                   // set write data - none for reads
  end else
  // csr write to MMIO space
  if (csr_req_wr_q & csr_req_q.csr_mem_mapped & (csr_req_q.csr_byte_en != '0)) begin
    hqm_csr_mmio_req_new.valid                = 1'b1;
    hqm_csr_mmio_req_new.opcode               = hqm_rtlgen_pkg_v12::MWR;                                        
    hqm_csr_mmio_req_new.addr.mem.offset      = {16'd0, csr_req_q.csr_mem_mapped_offset};
    hqm_csr_mmio_req_new.be                   = csr_req_q.csr_byte_en;
    hqm_csr_mmio_req_new.data                 = csr_req_q.csr_wr_dword;
    hqm_csr_mmio_req_apar_new                 = csr_req_q.csr_mem_mapped_apar;
    hqm_csr_mmio_req_dpar_new                 = csr_req_q.csr_mem_mapped_dpar;
  end else
  // csr read to MMIO space
  if (csr_req_rd_q & csr_req_q.csr_mem_mapped & (csr_req_q.csr_byte_en != '0)) begin
    hqm_csr_mmio_req_new.valid                = 1'b1;
    hqm_csr_mmio_req_new.opcode               = hqm_rtlgen_pkg_v12::MRD;                                        
    hqm_csr_mmio_req_new.addr.mem.offset      = {16'd0, csr_req_q.csr_mem_mapped_offset};
    hqm_csr_mmio_req_new.be                   = 4'hF;         // set BE - assuming all enabled for reads
    hqm_csr_mmio_req_new.data                 = '0;           // set write data - none for reads
    hqm_csr_mmio_req_apar_new                 = csr_req_q.csr_mem_mapped_apar;
    hqm_csr_mmio_req_dpar_new                 = csr_req_q.csr_mem_mapped_dpar;
  end

  // set SAI
  hqm_csr_pf0_req.sai                         = hqm_rtlgen_pkg_v12::f_sai_sb_to_cr(csr_req_q.csr_sai);          
  hqm_csr_mmio_req_new.sai                    = hqm_rtlgen_pkg_v12::f_sai_sb_to_cr(csr_req_q.csr_sai);          
  
  // set FID  - appears to be unused in Bell
  hqm_csr_pf0_req.fid                         = '0;
  hqm_csr_mmio_req_new.fid                    = '0;
  
  // temp for testing nebulon 2.08 - new bar field added to req packages, needs to be tied off
  hqm_csr_pf0_req.bar                         = '0;
  hqm_csr_mmio_req_new.bar                    = '0;

end     // end csr_translate_p

//-----------------------------------------------------------------
// Select between pending request and new request for MMIO request
//-----------------------------------------------------------------
assign hqm_csr_mmio_req               = hqm_csr_mmio_req_q.valid ? hqm_csr_mmio_req_q : hqm_csr_mmio_req_new;
assign hqm_csr_mmio_req_apar          = hqm_csr_mmio_req_q.valid ? hqm_csr_mmio_req_apar_q : hqm_csr_mmio_req_apar_new;
assign hqm_csr_mmio_req_dpar          = hqm_csr_mmio_req_q.valid ? hqm_csr_mmio_req_dpar_q : hqm_csr_mmio_req_dpar_new;

//-----------------------------------------------------------------
// effective mem_mapped signals
//    - Retain flopped values if request still pending
//    - Use new values if there is not a pending request
//-----------------------------------------------------------------
assign eff_csr_ext_mem_mapped        = hqm_csr_mmio_req_q.valid ? csr_ext_mem_mapped_q     : csr_req_q.csr_ext_mem_mapped;
assign eff_csr_func_pf_mem_mapped    = hqm_csr_mmio_req_q.valid ? csr_func_pf_mem_mapped_q : csr_req_q.csr_func_pf_mem_mapped;

//-----------------------------------------------------------------
// Flop MMIO request if there is a new or pending request
//-----------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin : hqm_csr_mmio_req_q_p
  if (~prim_gated_rst_b) begin
    hqm_csr_mmio_req_q                <= '0;
    hqm_csr_mmio_req_apar_q           <= '0;
    hqm_csr_mmio_req_dpar_q           <= '0;
    hqm_csr_mmio_req_sai_q            <= '0;
    csr_ext_mem_mapped_q              <= '0;
    csr_func_pf_mem_mapped_q          <= '0;
  end else if (hqm_csr_mmio_req_q.valid | hqm_csr_mmio_req.valid) begin
    hqm_csr_mmio_req_q.valid          <= hqm_csr_mmio_req_new.valid | hqm_csr_mmio_req_stall;      // Keep request pending if stalling request
    hqm_csr_mmio_req_q.opcode         <= hqm_csr_mmio_req.opcode;
    hqm_csr_mmio_req_q.addr           <= hqm_csr_mmio_req.addr;
    hqm_csr_mmio_req_q.be             <= hqm_csr_mmio_req.be;
    hqm_csr_mmio_req_q.data           <= hqm_csr_mmio_req.data;
    hqm_csr_mmio_req_q.sai            <= hqm_csr_mmio_req.sai;
    hqm_csr_mmio_req_q.fid            <= hqm_csr_mmio_req.fid;
    hqm_csr_mmio_req_q.bar            <= hqm_csr_mmio_req.bar;
    hqm_csr_mmio_req_apar_q           <= hqm_csr_mmio_req_apar;
    hqm_csr_mmio_req_dpar_q           <= hqm_csr_mmio_req_dpar;
    hqm_csr_mmio_req_sai_q            <= hqm_csr_mmio_req.sai[5:0];
    csr_ext_mem_mapped_q              <= eff_csr_ext_mem_mapped;
    csr_func_pf_mem_mapped_q          <= eff_csr_func_pf_mem_mapped;
  end
end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin : mmio_wr_sai_p
  if (~prim_gated_rst_b) begin
    mmio_wr_sai_error         <= '0;
    mmio_wr_sai_ok            <= '0;
  end else begin
    mmio_wr_sai_error         <= '0;
    mmio_wr_sai_ok            <= csr_wr_sai_ok_f | csr_wr_sai_error_f;
  end
end

//-----------------------------------------------------------------
// Drive individual request signals for MMIO regions
//
// Need to translate incoming offsets based on BAR region. Here is the effective RDL addresses for requests to HQM_PROC
//
//   hqm_system_csr_map                  hqm_system_csr          @0x16000000;
//   hqm_msix_mem_map                    hqm_msix_mem            @0x17000000;
//
//-----------------------------------------------------------------

always_comb begin: hqm_csr_int_ext_mmio_req_p

  hqm_csr_int_mmio_req                                = hqm_csr_mmio_req_q;
  hqm_csr_int_mmio_req.valid                          = hqm_csr_mmio_req_q.valid & ~eff_csr_func_pf_mem_mapped & ~eff_csr_ext_mem_mapped;

  hqm_csr_ext_mmio_req                                = hqm_csr_mmio_req_q;
  hqm_csr_ext_mmio_req.sai                            = {2'd0, hqm_csr_mmio_req_sai_q};
  hqm_csr_ext_mmio_req.valid                          = hqm_csr_mmio_req_q.valid & (eff_csr_func_pf_mem_mapped |  eff_csr_ext_mem_mapped);

  hqm_csr_ext_mmio_req.addr.mem.offset[47:32]         = '0;       // clear upper address bits

  hqm_csr_ext_mmio_req_apar                           = hqm_csr_mmio_req_apar_q;
  hqm_csr_ext_mmio_req_dpar                           = hqm_csr_mmio_req_dpar_q;

  if (eff_csr_func_pf_mem_mapped) begin

    hqm_csr_ext_mmio_req.bar                          = 4'd0;     // FUNC_PF/VF BAR
    hqm_csr_ext_mmio_req.addr.mem.offset[31:28]       = 4'd1;     // FUNC_PF BAR area mapped to node ID 1, same as CSR_PF BAR
    hqm_csr_ext_mmio_req.addr.mem.offset[26:25]       = 2'd3;     // So cfg ring decode logic passes full target/offset to hqm_system

    if (hqm_csr_mmio_req_q.addr.mem.offset[25:24] == 2'd1) begin  // MSIX_MEM has bits 25:24=1

      hqm_csr_ext_mmio_req.addr.mem.offset[24:22]     = 3'd4;     // MSIX_MEM sets bits 24:22=4

      // Bits [31:26] are consumed by the bar decode.
      //
      // 3322 2222 2222 1111 1111
      // 1098 7654 3210 9876 5432
      // ------------------------
      // 0000_0001_0000_0000_0000  input low
      // 0000_0001_0000_0000_0001  input high
      //
      // 0001_0111_00              output (parity adjusts if bits 31:26 or 23:22 were set)

      // We don't pass address bits 31:23 to the nebulon decode logic.
      // Invalidate if any of those bits other than 25:24 are set.

      if (|{hqm_csr_mmio_req_q.addr.mem.offset[31:26], hqm_csr_mmio_req_q.addr.mem.offset[23:22]}) begin

        hqm_csr_ext_mmio_req.addr.mem.offset[31:28]   = 4'd13;    // Force invalid unit

      end

      // Adjust parity for bits we're forcing (since forcing an odd number, invert)

      hqm_csr_ext_mmio_req_apar                       = ^{~hqm_csr_mmio_req_apar_q
                                                         ,hqm_csr_mmio_req_q.addr.mem.offset[31:26]
                                                         ,hqm_csr_mmio_req_q.addr.mem.offset[23:22]};

    end else begin // Else we're in other FUNC_PF space 25=1(HCW), 0(non-HCW)

      // The HCW case is handled in CDS before we get here, so any other address is invalid

      hqm_csr_ext_mmio_req.addr.mem.offset[31:28]     = 4'd13;    // Force invalid unit

      // Adjust parity for bits we're forcing (since forcing an odd number, invert)

      hqm_csr_ext_mmio_req_apar                       = ^{~hqm_csr_mmio_req_apar_q
                                                         ,hqm_csr_mmio_req_q.addr.mem.offset[31:22]};
    end

  end else if (hqm_csr_mmio_req_q.addr.mem.offset[31:28]==4'd1) begin

    hqm_csr_ext_mmio_req.bar                          = 4'd2;     // CSR_PF BAR
    hqm_csr_ext_mmio_req.addr.mem.offset[26:25]       = 2'd3;     // So cfg ring decode logic passes full target/offset to hqm_system

    // All 32 bits are valid from the bar decode.
    // Bit 27 is "feature" indication.
    //
    // 3322 2222 2222 1111 1111
    // 1098 7654 3210 9876 5432
    // ------------------------
    // 0001_0000_0000_0000_0000  input low
    // 0001_1001_1111_1111_1111  input high
    //
    // 0001_f11                  output (parity adjusts if bits 31:23 were set)

    // We don't pass bits 26:25 to the nebulon decode logic.
    // Field [24:23] decodes of 4, 5, and 6 are used for decoding to msix or func_pf/vf.
    // Invalidate if any of those bits are set.  All others are passed to the system.

    if ((|hqm_csr_mmio_req_q.addr.mem.offset[26:25]) | 
        ((hqm_csr_mmio_req_q.addr.mem.offset[24:22] >= 3'd4) &
         (hqm_csr_mmio_req_q.addr.mem.offset[24:22] <= 3'd6))) begin

      hqm_csr_ext_mmio_req.addr.mem.offset[31:28]     = 4'd13;    // Force invalid unit

    end

    // Adjust parity for bits we're forcing (since forcing an even number, no inversion)

    hqm_csr_ext_mmio_req_apar                         = ^{hqm_csr_mmio_req_apar_q
                                                         ,hqm_csr_mmio_req_q.addr.mem.offset[26:25]};
  end else begin

  // Otherwise just pass the address on

    hqm_csr_ext_mmio_req.bar                          = 4'd2;     // CSR_PF BAR

  end

end

//-----------------------------------------------------------------
// Drive addresses for handcoded CSR spaces
//-----------------------------------------------------------------
assign hqm_sif_csr_hc_addr                            = {16'h0,hqm_csr_mmio_req_q.addr.mem.offset}; // CSR memory mapped address offset

//-----------------------------------------------------------------
// Stall MMIO request if there is a valid request and there is not a response on the ack interface
//    - Request is complete if read_valid or write_valid signals are asserted, or sai_successfull is not asserted or mmio_timeout_q is asserted for all but csr_ext_mmio
//-----------------------------------------------------------------
assign hqm_csr_mmio_req_stall = (hqm_csr_int_mmio_req.valid & ~hqm_csr_int_mmio_ack_qual.read_valid & ~hqm_csr_int_mmio_ack_qual.write_valid & hqm_csr_int_mmio_ack_qual.sai_successfull & ~mmio_timeout_q) |
                                (hqm_csr_ext_mmio_req.valid & ~hqm_csr_ext_mmio_ack_qual.read_valid & ~hqm_csr_ext_mmio_ack_qual.write_valid & hqm_csr_ext_mmio_ack_qual.sai_successfull & ~cfgm_timeout_error_qual);

//-----------------------------------------------------------------
// Detect hit/miss/sai_error response on the PF CFG interface and each of the MMIO interfaces
//-----------------------------------------------------------------
always_comb begin : csr_rd_pf_mmio_p
  csr_pf0_rd_hit                      = hqm_csr_pf0_req.valid & hqm_csr_pf0_ack_qual.read_valid & ~hqm_csr_pf0_ack_qual.read_miss & hqm_csr_pf0_ack_qual.sai_successfull;
  csr_pf0_rd_miss                     = hqm_csr_pf0_req.valid & hqm_csr_pf0_ack_qual.read_valid &  hqm_csr_pf0_ack_qual.read_miss & hqm_csr_pf0_ack_qual.sai_successfull;
  csr_pf0_rd_ur                       = hqm_csr_pf0_req.valid &
                                        hqm_csr_pf0_req.addr.mem.offset[12] &
                                        hqm_csr_pf0_ack_qual.read_valid &
                                        hqm_csr_pf0_ack_qual.read_miss &
                                        hqm_csr_pf0_ack_qual.sai_successfull;
  csr_pf0_rd_sai_error                = hqm_csr_pf0_req.valid & (hqm_csr_pf0_req.opcode == hqm_rtlgen_pkg_v12::CFGRD) &  ~hqm_csr_pf0_ack_qual.sai_successfull;
  cfg_pf0_wr_ur                       = hqm_csr_pf0_req.valid & hqm_csr_pf0_req.addr.mem.offset[12] & (hqm_csr_pf0_req.opcode == hqm_rtlgen_pkg_v12::CFGWR) & hqm_csr_pf0_ack_qual.sai_successfull;
  cfg_pf0_wr_sai_error                = hqm_csr_pf0_req.valid & (hqm_csr_pf0_req.opcode == hqm_rtlgen_pkg_v12::CFGWR) &  ~hqm_csr_pf0_ack_qual.sai_successfull;
  cfg_pf0_wr_sai_ok                   = hqm_csr_pf0_req.valid & (hqm_csr_pf0_req.opcode == hqm_rtlgen_pkg_v12::CFGWR) &   hqm_csr_pf0_ack_qual.sai_successfull;

  csr_int_mmio_rd_hit                 = hqm_csr_int_mmio_req.valid & hqm_csr_int_mmio_ack_qual.read_valid & ~hqm_csr_int_mmio_ack_qual.read_miss & hqm_csr_int_mmio_ack_qual.sai_successfull;
  csr_int_mmio_rd_miss                = hqm_csr_int_mmio_req.valid & hqm_csr_int_mmio_ack_qual.read_valid &  hqm_csr_int_mmio_ack_qual.read_miss & hqm_csr_int_mmio_ack_qual.sai_successfull;
  csr_int_mmio_rd_sai_error           = hqm_csr_int_mmio_req.valid & (hqm_csr_int_mmio_req.opcode == hqm_rtlgen_pkg_v12::MRD) &  ~hqm_csr_int_mmio_ack_qual.sai_successfull;
  csr_int_mmio_rd_timeout_error       = hqm_csr_int_mmio_req.valid & (hqm_csr_int_mmio_req.opcode == hqm_rtlgen_pkg_v12::MRD) &  mmio_timeout_q;
  csr_int_mmio_wr_sai_error           = hqm_csr_int_mmio_req.valid & (hqm_csr_int_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR) &  ~hqm_csr_int_mmio_ack_qual.sai_successfull;
  csr_int_mmio_wr_sai_ok              = hqm_csr_int_mmio_req.valid & (hqm_csr_int_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR) &   hqm_csr_int_mmio_ack_qual.sai_successfull;
  csr_int_mmio_wr_timeout_error       = hqm_csr_int_mmio_req.valid & (hqm_csr_int_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR) &  mmio_timeout_q;

  csr_ext_mmio_rd_hit                 = hqm_csr_ext_mmio_req.valid & hqm_csr_ext_mmio_ack_qual.read_valid & ~hqm_csr_ext_mmio_ack_qual.read_miss & hqm_csr_ext_mmio_ack_qual.sai_successfull;
  csr_ext_mmio_rd_miss                = hqm_csr_ext_mmio_req.valid & hqm_csr_ext_mmio_ack_qual.read_valid &  hqm_csr_ext_mmio_ack_qual.read_miss & hqm_csr_ext_mmio_ack_qual.sai_successfull;
  csr_ext_mmio_rd_error               = {2{(hqm_csr_ext_mmio_req.valid & hqm_csr_ext_mmio_ack_qual.read_valid)}} & hqm_csr_ext_mmio_ack_err_qual;
  csr_ext_mmio_rd_sai_error           = hqm_csr_ext_mmio_req.valid & (hqm_csr_ext_mmio_req.opcode == hqm_rtlgen_pkg_v12::MRD) &  ~hqm_csr_ext_mmio_ack_qual.sai_successfull;
  csr_ext_mmio_rd_timeout_error       = hqm_csr_ext_mmio_req.valid & (hqm_csr_ext_mmio_req.opcode == hqm_rtlgen_pkg_v12::MRD) &  cfgm_timeout_error_qual;
  csr_ext_mmio_wr_error               = hqm_csr_ext_mmio_req.valid & hqm_csr_ext_mmio_ack_qual.write_valid &  hqm_csr_ext_mmio_ack_err_qual[1];
  csr_ext_mmio_wr_sai_error           = hqm_csr_ext_mmio_req.valid & (hqm_csr_ext_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR) &  ~hqm_csr_ext_mmio_ack_qual.sai_successfull;
  csr_ext_mmio_wr_sai_ok              = hqm_csr_ext_mmio_req.valid & (hqm_csr_ext_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR) &   hqm_csr_ext_mmio_ack_qual.sai_successfull;
  csr_ext_mmio_wr_timeout_error       = hqm_csr_ext_mmio_req.valid & (hqm_csr_ext_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR) &  cfgm_timeout_error_qual;

end         // csr_rd_pf_mmio_p

// Provide read data from source

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin : int_csr_rd_data_p
  // Store the CSR read data temporarily
  if (~prim_gated_rst_b) begin
    int_csr_rd_data_f     <= `HQM_CSR_SIZE'h0;
    ext_csr_rd_data_f     <= `HQM_CSR_SIZE'h0;
    pf0_rd_data_f         <= `HQM_CSR_SIZE'h0;
  end else begin
    if (hqm_csr_int_mmio_req.valid & (hqm_csr_int_mmio_req.opcode == hqm_rtlgen_pkg_v12::MRD)) begin
      int_csr_rd_data_f     <= hqm_csr_int_mmio_ack_qual.data;
    end else if (|int_csr_rd_data_f) begin
      int_csr_rd_data_f     <= `HQM_CSR_SIZE'h0;
    end
    if (hqm_csr_ext_mmio_req.valid & (hqm_csr_ext_mmio_req.opcode == hqm_rtlgen_pkg_v12::MRD)) begin
      ext_csr_rd_data_f     <= hqm_csr_ext_mmio_ack_qual.data;
    end else if (|ext_csr_rd_data_f) begin
      ext_csr_rd_data_f     <= `HQM_CSR_SIZE'h0;
    end
    if (hqm_csr_pf0_req.valid & (hqm_csr_pf0_req.opcode == hqm_rtlgen_pkg_v12::CFGRD)) begin
      pf0_rd_data_f         <= hqm_csr_pf0_ack_qual.data;
    end else if (|pf0_rd_data_f) begin
      pf0_rd_data_f         <= `HQM_CSR_SIZE'h0;
    end
  end
end

assign csr_rd_data_f = pf0_rd_data_f |
                       int_csr_rd_data_f |
                       ext_csr_rd_data_f;

//-----------------------------------------------------------------
// Combine all hit/miss/sai_error indications
//-----------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin : cfg_rd_hit_miss_p
  if(~prim_gated_rst_b) begin
    csr_rd_hit_f              <= '0;
    csr_rd_miss_f             <= '0;
    csr_rd_error_f            <= '0;
    csr_rd_ur_f               <= '0;
    csr_cfg_rd_sai_error_f    <= '0;

    csr_mem_rd_sai_error_f    <= '0;
    csr_rd_timeout_error_f    <= '0;
    csr_wr_error_f            <= '0;
    csr_wr_sai_error_f        <= '0;
    csr_wr_sai_ok_f           <= '0;
    csr_wr_timeout_error_f    <= '0;

    cfg_pf0_wr_ur_f           <= '0;
    cfg_pf0_wr_sai_error_f    <= '0;
    cfg_pf0_wr_sai_ok_f       <= '0;
    csr_timeout_q             <= '0;
  end else begin
    // HSD 4727725 - if a register read is missed, it does not send read ack and causes hang
    // HSD 4727730 - PCI cfg read miss causes hang (same problem and solution as 4727725)
    csr_rd_hit_f              <= csr_pf0_rd_hit  | csr_int_mmio_rd_hit  | csr_ext_mmio_rd_hit;
    csr_rd_miss_f             <= csr_pf0_rd_miss | csr_int_mmio_rd_miss | csr_ext_mmio_rd_miss;
    csr_rd_ur_f               <= csr_pf0_rd_ur;
    csr_rd_error_f            <= csr_ext_mmio_rd_error;
    csr_cfg_rd_sai_error_f    <= csr_pf0_rd_sai_error;

    csr_mem_rd_sai_error_f    <= csr_int_mmio_rd_sai_error     | csr_ext_mmio_rd_sai_error;
    csr_rd_timeout_error_f    <= csr_int_mmio_rd_timeout_error | csr_ext_mmio_rd_timeout_error;
    csr_wr_error_f            <= csr_ext_mmio_wr_error;
    csr_wr_sai_error_f        <= csr_int_mmio_wr_sai_error     | csr_ext_mmio_wr_sai_error;
    csr_wr_sai_ok_f           <= csr_int_mmio_wr_sai_ok        | csr_ext_mmio_wr_sai_ok;
    csr_wr_timeout_error_f    <= csr_int_mmio_wr_timeout_error | csr_ext_mmio_wr_timeout_error;

    cfg_pf0_wr_ur_f           <= cfg_pf0_wr_ur;
    cfg_pf0_wr_sai_ok_f       <= cfg_pf0_wr_sai_ok;
    cfg_pf0_wr_sai_error_f    <= cfg_pf0_wr_sai_error;
    csr_timeout_q             <= csr_rd_timeout_error_f | csr_wr_timeout_error_f;
  end
end         // cfg_rd_hit_miss_p

assign mmio_timeout_error = ~csr_timeout_q & (csr_rd_timeout_error_f | csr_wr_timeout_error_f);

always_ff @(posedge prim_nonflr_clk) begin : mmio_timeout_syndrome_p
  if (hqm_csr_int_mmio_req.valid) begin
    mmio_timeout_syndrome     <= {2'b00,hqm_csr_int_mmio_req.addr.mem.offset[7:2]};
  end else if (hqm_csr_ext_mmio_req.valid) begin
    mmio_timeout_syndrome     <= {2'b01,hqm_csr_ext_mmio_req.addr.mem.offset[7:2]};
  end else begin
    mmio_timeout_syndrome     <= '0;
  end
end

// ------------------------------------------------------------------------
// CSR read data/status return to hqm_ri_cds
// ------------------------------------------------------------------------
always_comb begin : csr_rd_data_p
  // HSD 4727725 - if a register read is missed, it does not send read ack and causes hang
  csr_rd_data_val_wp      = csr_rd_hit_f || csr_rd_miss_f || csr_cfg_rd_sai_error_f || csr_mem_rd_sai_error_f || csr_rd_timeout_error_f || zero_length_rd_q;
  csr_rd_data_wxp         = ({`HQM_CSR_SIZE{csr_rd_hit_f}} & csr_rd_data_f);
  csr_rd_ur               = csr_rd_ur_f;
  csr_rd_error            = csr_rd_error_f;
  csr_rd_sai_error        = '0; //csr_mem_rd_sai_error_f;
  csr_rd_timeout_error    = csr_rd_timeout_error_f;
  cfg_wr_ur               = cfg_pf0_wr_ur_f;
  csr_wr_error            = csr_wr_error_f;
  cfg_wr_sai_error        = 1'b0; // Do not signal an error for CFG sai error cases - cfg_pf0_wr_sai_error_f
  cfg_wr_sai_ok           = cfg_pf0_wr_sai_ok_f | cfg_pf0_wr_sai_error_f;  // signal OK even if sai error
end // always_comb

// ------------------------------------------------------------------------
// Hard Reset Signal Generation for the CSRs
// ------------------------------------------------------------------------
// Reset signal from the shack that resets all the CSR's including the sticky registers. 
//
// VF sticky regs must not be reset on a VF FLR.
// All other (non VF FLR) reset conditions that reset the VF CFG space must
// also reset the sticky regs!  No need to include powergood_rst_b in the
// sticky reset case, since powergood_rst_b implies prim_rst_b and a reset
// of the PF implies the reset of all VF CFG state including the sticky bits.

hqm_AW_reset_sync_scan i_hard_rst_np_pf (

       .clk               (prim_freerun_clk)
      ,.rst_n             (powergood_rst_b)
      ,.fscan_rstbypen    (fscan_rstbypen)
      ,.fscan_byprst_b    (fscan_byprst_b)
      ,.rst_n_sync        (hard_rst_np)
);

// ------------------------------------------------------------------------
// Soft Reset Signal Generation for the CSRs
// ------------------------------------------------------------------------
always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b) begin : sftrst_pre_scan_p
  // Active low soft reset for each individual function.
  // Sticky registers are not reset. The reset can be initiated from the
  // SHaC or from a function level reset.
  if(~prim_gated_rst_b)
    soft_rst_np_pre_scan <= '0;
  else
    soft_rst_np_pre_scan <= pm_pf_rst_wxp;
end // always_ff sftrst_pre_scan_p

// ------------------------------------------------------------------------
// Soft Reset
// ------------------------------------------------------------------------
// soft_rst_np = soft_rst_np_pre_scan | {`EP_FUNCTIONS{swxx_tst_scn_mode_wx}}; 
// HSD 4728428 - DFX scan control inputs to drive reset

hqm_AW_reset_mux i_soft_rst_np (

   .rst_in_n          (soft_rst_np_pre_scan)
  ,.fscan_rstbypen    (fscan_rstbypen)
  ,.fscan_byprst_b    (fscan_byprst_b)
  ,.rst_out_n         (soft_rst_np)
);
  
// ------------------------------------------------------------------------
// Create reset assignments for new SRDL based CSR blocks
// ------------------------------------------------------------------------
always_comb begin : srdl_resets_and_clks_p

  // resets are either hard or soft, same across physical function and MMIO

  hqm_csr_pf0_rst_n               = soft_rst_np;
  hqm_csr_pf0_pwr_rst_n           = hard_rst_np;
  hqm_csr_mmio_rst_n              = soft_rst_np;

end // always_comb srdl_resets_and_clks_p
  
// ------------------------------------------------------------------------
// CSR Read Stall
//    - set when read pulse is seen
//    - clear when read data valid is being returned
// ------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin : csr_rd_stall_p
  // We cannot issue back to back CSR reads because there is a corner
  // case where the OBC will fill and the pending 2nd CSR read data
  // will be lost.
  if (~prim_gated_rst_b)
    csr_rd_stall      <= 1'b0;
  else if (csr_req_rd & ~flr_treatment_q0)
    csr_rd_stall      <= 1'b1;
  else if (csr_rd_data_val_wp | flr_treatment_q0)
    csr_rd_stall      <= 1'b0;        
  else
    csr_rd_stall      <= csr_rd_stall;
end // always_ff csr_rd_stall_p

// ------------------------------------------------------------------------
// Stall for CSR write to complete
//    - set when the pulse is seen, the delayed write pulse, and a pending MMIO request
// ------------------------------------------------------------------------
always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin : cwr_wr_stall_p
  if(~prim_gated_rst_b)
    csr_wr_stall      <= 1'b0;   
  else if ((csr_req_wr | csr_req_wr_q | (hqm_csr_mmio_req.valid & (hqm_csr_mmio_req.opcode == hqm_rtlgen_pkg_v12::MWR))) & ~flr_treatment_q0)
    csr_wr_stall      <= 1'b1;
  else
    csr_wr_stall      <= 1'b0;
end // always_ff csr_wr_stall_p

// ------------------------------------------------------------------------
// CSR Serializtion
// ------------------------------------------------------------------------
always_comb begin : csr_stall_p
  // We cannot have CSR command pass one another therefore commands
  // to the common block of IOSF must for CSR serialization by suppressing
  // any further command to the CSR FUB until the outstanding CB/IOSF
  // access are complete.
  // no longer used - pcpp_stall, csr_iosf_stall_ff, csr_cb_stall_ff;
  csr_stall = csr_rd_stall || ppmcsr_wr_stall || csr_wr_stall; 
end // always_comb csr_stall_p

// ------------------------------------------------------------------------
// CSR Control NOA Debug Signals
// ------------------------------------------------------------------------
always_comb begin
  csr_noa = {
              hqm_csr_ext_mmio_ack_qual.sai_successfull,      //  1 bit
              hqm_csr_ext_mmio_ack_qual.read_miss,            //  1 bit
              hqm_csr_ext_mmio_ack_qual.write_miss,           //  1 bit
              hqm_csr_ext_mmio_ack_qual.read_valid,           //  1 bit
              hqm_csr_ext_mmio_ack_qual.write_valid,          //  1 bit
              hqm_csr_ext_mmio_req.valid,                     //  1 bit
              hqm_csr_ext_mmio_req.opcode[0],                 //  1 bit
              hqm_csr_ext_mmio_req.data[0],                   //  1 bit   13
                                                                 
              hqm_csr_int_mmio_ack_qual.sai_successfull,      //  1 bit
              hqm_csr_int_mmio_ack_qual.read_miss,            //  1 bit
              hqm_csr_int_mmio_ack_qual.write_miss,           //  1 bit
              hqm_csr_int_mmio_ack_qual.read_valid,           //  1 bit
              hqm_csr_int_mmio_ack_qual.write_valid,          //  1 bit
              hqm_csr_int_mmio_req.valid,                     //  1 bit
              hqm_csr_int_mmio_req.opcode[0],                 //  1 bit
              hqm_csr_int_mmio_req.data[0],                   //  1 bit   12

              hqm_csr_pf0_ack_qual.sai_successfull,           //  1 bit
              hqm_csr_pf0_ack_qual.read_miss,                 //  1 bit
              hqm_csr_pf0_ack_qual.write_miss,                //  1 bit
              hqm_csr_pf0_ack_qual.read_valid,                //  1 bit
              hqm_csr_pf0_ack_qual.write_valid,               //  1 bit
              hqm_csr_pf0_req.valid,                          //  1 bit
              hqm_csr_pf0_req.opcode[0],                      //  1 bit
              hqm_csr_pf0_req.data[0],                        //  1 bit   11

              csr_req_q.csr_wr_offset[11:8],                  //  4 bits
              csr_req_q.csr_rd_offset[11:8],                  //  4 bits  10

              csr_req_q.csr_wr_offset[7:0],                   //  8 bits  9

              csr_req_q.csr_rd_offset[7:0],                   //  8 bits  8

              csr_req_q.csr_mem_mapped_offset,                // 32 bits  4-7

              csr_req_q.csr_mem_mapped,                       //  1 bit
              csr_req_q.csr_ext_mem_mapped,                   //  1 bit
              csr_req_q.csr_func_pf_mem_mapped,               //  1 bit
              1'd0,                                           //  1 bit
              4'd0,                                           //  4 bits  3

              csr_req_rd_q,                                   //  1 bit
              csr_rd_stall,                                   //  1 bit
              ppmcsr_wr_stall,                                //  1 bit
              csr_req_q.csr_rd_func[4:0],                     //  5 bits  2

              csr_req_wr_q,                                   //  1 bit
              csr_wr_stall,                                   //  1 bit
              csr_req_q.csr_byte_en[0],                       //  1 bit
              csr_req_q.csr_wr_func[4:0],                     //  5 bits  1

              csr_req_q.csr_sai                               //  8 bits  0
            };
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
//   ri.ri_lli_ctl.csr_req_wr, csr_req_rd (w/  csr_mem_mapped_wp=1/0, and
//   all functions; csr_wr_func_wxp, csr_rd_rund_wxp), iosf_csr_cmd_blk,
//   ri.ri_int.msix_tbl_wr, msix_tbl_rd.
// - FLR reset when there are pending CSR reads/writes (Execute reset
//   with pending CSR reads/writes, come out of reset and successfully
//   execute a CSR read/write); !ri_flr_rxp &
//   ri.ri_lli_ctl.csr_req_wr, csr_req_rd (w/  csr_mem_mapped_wp=1/0, and
//   all functions; csr_wr_func_wxp, csr_rd_rund_wxp), iosf_csr_cmd_blk,
//   ri.ri_int.msix_tbl_wr, msix_tbl_rd.
// - Verify that after an FLR to each of the functions that the funtions
//   is put back into the pf*_pm_state=D0ACT and that the following
//   events to the given function are executed; csr_wr_wxp, csr_rd_wxp,
//   csr_cb_stall, csr_mm_write, csr_pf_write, msi_cmd_req,
//   intx_req, int2me_req

endmodule // hqm_ri_csr_ctl

