// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_tlq
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Wednesday Nov 12, 2008
// -- Description :
// -- Transaction Layer Queue. This block contains the fifo's used
// -- in crossing the link clock to the cpp clock for the packet
// -- header and data. There are seven asynchronous fifos here;
// -- posted header, non posted header, compleation header, posted
// -- data, non posted data, completion data and the in order queue.
// -- In addition, the fifo's read pointer (in the cpp clock domain)
// -- is passed back to the link layer interface link clock domain.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_ri_tlq

     import hqm_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic                           prim_nonflr_clk
    ,input  logic                           prim_gated_rst_b

    //-----------------------------------------------------------------
    // Top level interface signals.
    //-----------------------------------------------------------------

    // Push Header Interface

    ,input logic                            lli_phdr_val        // valid posted header
    ,input tdl_phdr_t                       lli_phdr            // The control signal for the
                                                                // decoded posted header.
    ,input logic                            lli_nphdr_val       // valid non posted header
    ,input tdl_nphdr_t                      lli_nphdr           // The control signal for the
                                                                // decoded non posted header.

    ,input logic                            lli_cpar_err_rl     // Cmd Hdr parity error detected
    ,input logic                            lli_tecrc_err_rl    // HSD 4727748 - add support for TECRC error
    ,input errhdr_t                         lli_chdr_w_err_rl

    ,input logic                            poisoned_wr_sent    // HSD 5314547 - MDPE not getting set when HQM receives poison completion

    // Pop Data Interface

    ,input logic                            cds_phdr_rd_wp      // Read signal for posted header
                                                                // from command decode schedule
    ,input logic                            cds_pd_rd_wp        // Read signal for posted data
                                                                // from command decode schedule

    ,input logic                            cds_nphdr_rd_wp     // Read signal for non posted header
                                                                // from command decode schedule
    ,input logic                            cds_npd_rd_wp       // Read signal for non posted data
                                                                // from command decode schedule

    // Push Data Interface

    ,input logic                            lli_pdata_push      // push data to posted data queue
    ,input logic                            lli_npdata_push     // push data to non posted data queue
    ,input ri_bus_width_t                   lli_pkt_data        // The big ending packet data
    ,input ri_bus_par_t                     lli_pkt_data_par    // parity per dword

    // Common Block Errors

    ,input logic                            cpl_usr             // Completion UR
    ,input logic                            cpl_abort           // Completer abort
    ,input logic                            cpl_poisoned        // Completion poisoned
    ,input logic                            cpl_unexpected      // Unexpected completion
    ,input logic                            cpl_timeout         // Completion timeout

    ,output logic [31:0]                    tlq_noa             // tlq noa signals

    //-----------------------------------------------------------------
    // Signals for synchronization - because they shouldn't be all the way at RI top level
    //-----------------------------------------------------------------

    ,input  logic [4:0]                     cfg_ri_phdr_fifo_high_wm     // The posted header fifo full threshold
    ,input  logic [5:0]                     cfg_ri_pdata_fifo_high_wm    // The posted data fifo full threshold
    ,input  logic [3:0]                     cfg_ri_nphdr_fifo_high_wm    // The non posted header fifo full threshold
    ,input  logic [3:0]                     cfg_ri_npdata_fifo_high_wm   // The non posted data fifo full threshold
    ,input  logic [5:0]                     cfg_ri_ioq_fifo_high_wm      // The IOQ full threshold
    ,input  logic                           cfg_ri_par_off
    ,input  logic                           cfg_cnt_clear
    ,input  logic                           cfg_cnt_clearv

    ,output logic [9:0] [31:0]              cfg_tlq_cnts

    ,output logic [31:0]                    ri_phdr_fifo_status
    ,output logic [31:0]                    ri_pdata_fifo_status
    ,output logic [31:0]                    ri_nphdr_fifo_status
    ,output logic [31:0]                    ri_npdata_fifo_status
    ,output logic [31:0]                    ri_ioq_fifo_status

    ,output logic [6:0]                     ri_phdr_db_status
    ,output logic [6:0]                     ri_pdata_db_status
    ,output logic [6:0]                     ri_nphdr_db_status
    ,output logic [6:0]                     ri_npdata_db_status
    ,output logic [6:0]                     ri_ioq_db_status

    //-----------------------------------------------------------------
    // Memory Interface
    //-----------------------------------------------------------------

    ,output hqm_sif_memi_fifo_phdr_t        memi_ri_tlq_fifo_phdr    // input to the relocated mem;
    ,input  hqm_sif_memo_fifo_phdr_t        memo_ri_tlq_fifo_phdr    // output to the relocated mem;
    ,output hqm_sif_memi_fifo_pdata_t       memi_ri_tlq_fifo_pdata   // input to the relocated mem;
    ,input  hqm_sif_memo_fifo_pdata_t       memo_ri_tlq_fifo_pdata   // output to the relocated mem;
    ,output hqm_sif_memi_fifo_nphdr_t       memi_ri_tlq_fifo_nphdr   // input to the relocated mem;
    ,input  hqm_sif_memo_fifo_nphdr_t       memo_ri_tlq_fifo_nphdr   // output to the relocated mem;
    ,output hqm_sif_memi_fifo_npdata_t      memi_ri_tlq_fifo_npdata  // input to the relocated mem;
    ,input  hqm_sif_memo_fifo_npdata_t      memo_ri_tlq_fifo_npdata  // output to the relocated mem;

    // SER related signals, used to gate tlq signals if there are parity errors

    ,input  logic                           set_cbd_hdr_parity_err
    ,input  logic                           set_cbd_data_parity_err
    ,input  logic                           set_hcw_data_parity_err

    ,output logic                           tlq_cds_phdr_par_err
    ,output logic                           tlq_cds_pdata_par_err
    ,output logic                           tlq_cds_nphdr_par_err
    ,output logic                           tlq_cds_npdata_par_err
    ,output load_RI_PARITY_ERR_t            set_ri_parity_err
    ,output logic                           ri_parity_alarm

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    ,output logic                           tlq_idle

    // TLQ header/data fifo outpus

    ,output logic                           tlq_phdrval_wp       // A posted header is valid
    ,output tdl_phdr_t                      tlq_phdr_rxp         // The next valid posted header
    ,output logic                           tlq_nphdrval_wp      // A non posted header is valid
    ,output tdl_nphdr_t                     tlq_nphdr_rxp        // The next valid non posted header
    ,output logic                           tlq_pdataval_wp      // Posted data is valid
    ,output tlq_pdata_t                     tlq_pdata_rxp        // The next valid posted data
    ,output logic                           tlq_npdataval_wp     // Non posted data is valid
    ,output tlq_npdata_t                    tlq_npdata_rxp       // The next valid non posted data
    ,output logic                           tlq_ioqval_wp        // IOQ data valid
    ,output tlq_ioqdata_t                   tlq_ioq_data_rxp     // IOQ output data

    ,output hqm_iosf_tgt_crd_t              ri_tgt_crd_inc       // Target credit return

    ,output logic                           lli_cpar_err_wp      // Cmd Hdr parity error detected
    ,output logic                           lli_tecrc_err_wp     // HSD 4727748 - add support for TECRC error
    ,output errhdr_t                        lli_chdr_w_err_wp
);

//-------------------------------------------------------------------------

hqm_iosf_tgt_crd_t                   ri_tgt_crd_inc_next;   // Target credit return

logic                                ioq_hdr_push;          
logic                                ioq_hdr_push_in;       // Phase selected IOQ header valid
tlq_ioqdata_t                        ioq_hdr_type;          
tlq_ioqdata_t                        ioq_hdr_type_in;       // The phased selected header type to the IOQ
logic                                tlq_ioq_fifo_afull;    // The IOQ fifo is full
logic                                tlq_ioq_fifo_full_nc;
logic                                ioq_pop;               // pop the oldest entry from the
                                                            // in order queue.
ri_bus_width_t                       pkt_data_in;           // Phase selected packet data
ri_bus_par_t                         pkt_data_par_in;       // parity per dword
logic                                pdata_push;            // phase selected push data
logic                                npdata_push;           // phase selected non posted push data
logic                                phdr_val;              // phase select valid posted header
tdl_phdr_t                           phdr;                  // phase selected posted header
logic                                nphdr_val;             // phase select valid non posted header
tdl_nphdr_t                          nphdr;                 // phase selected posted header
logic                                ioqval_wp;             // Valid qualifier from IOQ

// fix for ticket 3542149 3542146
// gate the valid signal from the ph and nph queues with the output of the ioq fifo

logic                                phdrval_wp;            // A posted header is valid pre ioq mask
logic                                nphdrval_wp;           // A non posted header is valid pre ioq mask
logic                                ioq_phdrval_wp;        // A posted header is valid pre ioq mask
logic                                ioq_nphdrval_wp;       // A non posted header is valid pre ioq mask


logic                                phdr_fifo_afull;       // the posted header fifo is full.
logic                                nphdr_fifo_afull;      // the non posted header fifo is full.
logic                                pdata_fifo_afull;      // the posted data fifo is full.
logic                                npdata_fifo_afull;     // the non posted data fifo is full.

logic                                phdr_fifo_full_nc;
logic                                nphdr_fifo_full_nc;
logic                                pdata_fifo_full_nc;
logic                                npdata_fifo_full_nc;

logic [1:0]                          rf_tlq_phdr_parity_err;
logic                                rf_tlq_pdata_parity_err;
logic [1:0]                          rf_tlq_nphdr_parity_err;
logic                                rf_tlq_npdata_parity_err;

//-------------------------------------------------------------------------

//noa hookup for coleto

// TBD: Update visa.sig for new signals

always_comb begin
 tlq_noa = {    lli_cpar_err_wp            // 3
               ,lli_tecrc_err_wp
               ,poisoned_wr_sent
               ,cpl_usr
               ,cpl_abort
               ,cpl_poisoned
               ,cpl_unexpected
               ,cpl_timeout

               ,phdr_val                   // 2
               ,cds_phdr_rd_wp
               ,phdrval_wp
               ,phdr_fifo_afull
               ,pdata_push
               ,cds_pd_rd_wp
               ,tlq_pdataval_wp
               ,pdata_fifo_afull

               ,nphdr_val                  // 1
               ,cds_nphdr_rd_wp
               ,nphdrval_wp
               ,nphdr_fifo_afull
               ,npdata_push
               ,cds_npd_rd_wp
               ,tlq_npdataval_wp
               ,npdata_fifo_afull

               ,tlq_idle                   // 0 // 7
               ,tlq_ioq_fifo_afull              // 6
               ,ioq_hdr_push_in                 // 5
               ,ioq_pop                         // 4
               ,ioqval_wp                       // 3
               ,cds_pd_rd_wp                    // 2
               ,tlq_ioq_data_rxp                // 1:0
 };
end

//-------------------------------------------------------------------------
// The memory script will generate memories which violate several
// lint rules (e.g. signal names and instantiations greater then 20
// characters). Also given that the memories are generic, the signal names
// across the ports will not be the same.
//-------------------------------------------------------------------------
// The posted header queue.
//-------------------------------------------------------------------------

hqm_AW_fifo_control_big_wdb #(

     .DEPTH                 (16)
    ,.DWIDTH                ($bits(phdr))

) i_fifo_phdr (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ri_phdr_fifo_high_wm)

    ,.push                  (phdr_val)
    ,.push_data             (phdr)
    ,.pop                   (cds_phdr_rd_wp)
    ,.pop_data_v            (phdrval_wp)
    ,.pop_data              (tlq_phdr_rxp)

    ,.mem_we                (memi_ri_tlq_fifo_phdr.we)
    ,.mem_waddr             (memi_ri_tlq_fifo_phdr.waddr)
    ,.mem_wdata             (memi_ri_tlq_fifo_phdr.wdata[$bits(phdr)-1:0])
    ,.mem_re                (memi_ri_tlq_fifo_phdr.re)
    ,.mem_raddr             (memi_ri_tlq_fifo_phdr.raddr)
    ,.mem_rdata             (memo_ri_tlq_fifo_phdr.rdata[$bits(phdr)-1:0])

    ,.fifo_status           (ri_phdr_fifo_status)
    ,.fifo_full             (phdr_fifo_full_nc)                              
    ,.fifo_afull            (phdr_fifo_afull)
    ,.db_status             (ri_phdr_db_status)
);

// Check separate parity on cmd/len and rest of the fields
// A cmd/len parity error gets the stop_and_scream behavior by masking off the valid
// as we can't be certain of the command or length and could get the hdr/data FIFOs
// out of sync if we tried to just throw away the transaction.
// If there is a parity error on the non-cmd/len type fields, can indicate this to
// the ri_cds so it can just pop and throw away the transacgtion w/o getting the
// hdr/data FIFOs out of sync.

assign ioq_phdrval_wp  = ioqval_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_PH] & phdrval_wp;

assign rf_tlq_phdr_parity_err = {2{(ioq_phdrval_wp & ~cfg_ri_par_off)}} &

                                {(^{tlq_phdr_rxp.cmdlen_par
                                   ,tlq_phdr_rxp.cmd
                                   ,tlq_phdr_rxp.fmt
                                   ,tlq_phdr_rxp.ttype
                                   ,tlq_phdr_rxp.length})

                                ,(^{tlq_phdr_rxp.addr_par
                                   ,tlq_phdr_rxp.addr
                                   ,tlq_phdr_rxp.par
                                   ,tlq_phdr_rxp.pasidtlp
                                   ,tlq_phdr_rxp.sai
                                   ,tlq_phdr_rxp.poison
                                   ,tlq_phdr_rxp.tag
                                   ,tlq_phdr_rxp.reqid
                                   ,tlq_phdr_rxp.endbe
                                   ,tlq_phdr_rxp.startbe})};

assign tlq_phdrval_wp  = ioq_phdrval_wp & ~rf_tlq_phdr_parity_err[1];

assign tlq_cds_phdr_par_err = rf_tlq_phdr_parity_err[0]; // Non-cmd/len parity error

//-------------------------------------------------------------------------
// The posted data queue.
//-------------------------------------------------------------------------

hqm_AW_fifo_control_big_wdb #(

     .DEPTH                 (32)
    ,.DWIDTH                (RI_PDATA_WID + (RI_PDATA_WID/32))

) i_fifo_pdata (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ri_pdata_fifo_high_wm)

    ,.push                  (pdata_push)
    ,.push_data             ({pkt_data_par_in[(RI_PDATA_WID/32)-1:0]
                             ,pkt_data_in[RI_PDATA_WID-1:0]
                            })
    ,.pop                   (cds_pd_rd_wp)
    ,.pop_data_v            (tlq_pdataval_wp)
    ,.pop_data              (tlq_pdata_rxp)

    ,.mem_we                (memi_ri_tlq_fifo_pdata.we)
    ,.mem_waddr             (memi_ri_tlq_fifo_pdata.waddr)
    ,.mem_wdata             (memi_ri_tlq_fifo_pdata.wdata)
    ,.mem_re                (memi_ri_tlq_fifo_pdata.re)
    ,.mem_raddr             (memi_ri_tlq_fifo_pdata.raddr)
    ,.mem_rdata             (memo_ri_tlq_fifo_pdata.rdata)

    ,.fifo_status           (ri_pdata_fifo_status)
    ,.fifo_full             (pdata_fifo_full_nc)                              
    ,.fifo_afull            (pdata_fifo_afull)
    ,.db_status             (ri_pdata_db_status)
);

assign rf_tlq_pdata_parity_err = tlq_pdataval_wp & ~cfg_ri_par_off &
            ~((tlq_pdata_rxp.parity[0] == (^tlq_pdata_rxp.data[ 31:  0])) &
              (tlq_pdata_rxp.parity[1] == (^tlq_pdata_rxp.data[ 63: 32])) &
              (tlq_pdata_rxp.parity[2] == (^tlq_pdata_rxp.data[ 95: 64])) &
              (tlq_pdata_rxp.parity[3] == (^tlq_pdata_rxp.data[127: 96])) &
              (tlq_pdata_rxp.parity[4] == (^tlq_pdata_rxp.data[159:128])) &
              (tlq_pdata_rxp.parity[5] == (^tlq_pdata_rxp.data[191:160])) &
              (tlq_pdata_rxp.parity[6] == (^tlq_pdata_rxp.data[223:192])) &
              (tlq_pdata_rxp.parity[7] == (^tlq_pdata_rxp.data[255:224])));


assign tlq_cds_pdata_par_err   = rf_tlq_pdata_parity_err;

//-------------------------------------------------------------------------
// The non posted header queue.
//-------------------------------------------------------------------------

hqm_AW_fifo_control_wdb #(

     .DEPTH                 (8)
    ,.DWIDTH                ($bits(nphdr))

) i_fifo_nphdr (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ri_nphdr_fifo_high_wm)

    ,.push                  (nphdr_val)
    ,.push_data             (nphdr)
    ,.pop                   (cds_nphdr_rd_wp)
    ,.pop_data_v            (nphdrval_wp)
    ,.pop_data              (tlq_nphdr_rxp)

    ,.mem_we                (memi_ri_tlq_fifo_nphdr.we)
    ,.mem_waddr             (memi_ri_tlq_fifo_nphdr.waddr)
    ,.mem_wdata             (memi_ri_tlq_fifo_nphdr.wdata[$bits(nphdr)-1:0])
    ,.mem_re                (memi_ri_tlq_fifo_nphdr.re)
    ,.mem_raddr             (memi_ri_tlq_fifo_nphdr.raddr)
    ,.mem_rdata             (memo_ri_tlq_fifo_nphdr.rdata[$bits(nphdr)-1:0])

    ,.fifo_status           (ri_nphdr_fifo_status)
    ,.fifo_full             (nphdr_fifo_full_nc)                              
    ,.fifo_afull            (nphdr_fifo_afull)
    ,.db_status             (ri_nphdr_db_status)
);

// Check separate parity on cmd/len and rest of the fields
// A cmd/len parity error gets the stop_and_scream behavior by masking off the valid
// as we can't be certain of the command or length and could get the hdr/data FIFOs
// out of sync if we tried to just throw away the transaction.
// If there is a parity error on the non-cmd/len type fields, can indicate this to
// the ri_cds so it can just pop and throw away the transacgtion w/o getting the
// hdr/data FIFOs out of sync.

assign ioq_nphdrval_wp = ioqval_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_NPH] & nphdrval_wp;

assign rf_tlq_nphdr_parity_err = {2{(ioq_nphdrval_wp & ~cfg_ri_par_off)}} &

                                 {(^{tlq_nphdr_rxp.cmdlen_par
                                    ,tlq_nphdr_rxp.cmd
                                    ,tlq_nphdr_rxp.fmt
                                    ,tlq_nphdr_rxp.ttype
                                    ,tlq_nphdr_rxp.length})

                                 ,(^{tlq_nphdr_rxp.addr_par
                                    ,tlq_nphdr_rxp.addr
                                    ,tlq_nphdr_rxp.par
                                    ,tlq_nphdr_rxp.pasidtlp
                                    ,tlq_nphdr_rxp.sai
                                    ,tlq_nphdr_rxp.attr
                                    ,tlq_nphdr_rxp.tc
                                    ,tlq_nphdr_rxp.poison
                                    ,tlq_nphdr_rxp.tag
                                    ,tlq_nphdr_rxp.reqid
                                    ,tlq_nphdr_rxp.endbe
                                    ,tlq_nphdr_rxp.startbe})};

assign tlq_nphdrval_wp = ioq_nphdrval_wp & ~rf_tlq_nphdr_parity_err[1];

assign tlq_cds_nphdr_par_err = rf_tlq_nphdr_parity_err[0]; // Non-cmd/len parity error

//-------------------------------------------------------------------------
// The non posted data queue.
//-------------------------------------------------------------------------

hqm_AW_fifo_control_wdb #(

     .DEPTH                 (8)
    ,.DWIDTH                (RI_NPDATA_WID + (RI_NPDATA_WID/32))

) i_fifo_npdata (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ri_npdata_fifo_high_wm)

    ,.push                  (npdata_push)
    ,.push_data             ({pkt_data_par_in[(RI_NPDATA_WID/32)-1:0]
                             ,pkt_data_in[RI_NPDATA_WID-1:0]
                            })
    ,.pop                   (cds_npd_rd_wp)
    ,.pop_data_v            (tlq_npdataval_wp)
    ,.pop_data              (tlq_npdata_rxp)

    ,.mem_we                (memi_ri_tlq_fifo_npdata.we)
    ,.mem_waddr             (memi_ri_tlq_fifo_npdata.waddr)
    ,.mem_wdata             (memi_ri_tlq_fifo_npdata.wdata)
    ,.mem_re                (memi_ri_tlq_fifo_npdata.re)
    ,.mem_raddr             (memi_ri_tlq_fifo_npdata.raddr)
    ,.mem_rdata             (memo_ri_tlq_fifo_npdata.rdata)

    ,.fifo_status           (ri_npdata_fifo_status)
    ,.fifo_full             (npdata_fifo_full_nc)                              
    ,.fifo_afull            (npdata_fifo_afull)
    ,.db_status             (ri_npdata_db_status)
);

assign rf_tlq_npdata_parity_err = tlq_npdataval_wp & ~cfg_ri_par_off &
            ~(tlq_npdata_rxp.parity[0] == (^tlq_npdata_rxp.data[ 31:  0]));

assign tlq_cds_npdata_par_err   = rf_tlq_npdata_parity_err;

//-------------------------------------------------------------------------
// The inorder queue (IOQ).
//-------------------------------------------------------------------------

logic                                   ioq_we;
logic                                   ioq_re;
logic   [4:0]                           ioq_waddr;
logic   [4:0]                           ioq_raddr;
logic   [$bits(ioq_hdr_type_in)-1:0]    ioq_wdata;
logic   [$bits(ioq_hdr_type_in)-1:0]    ioq_rdata;
logic   [$bits(ioq_hdr_type_in)-1:0]    ioq_q[31:0];

hqm_AW_fifo_control_big_wdb #(

     .DEPTH                 (32)
    ,.DWIDTH                ($bits(ioq_hdr_type_in))

) i_ioq (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           (cfg_ri_ioq_fifo_high_wm)

    ,.push                  (ioq_hdr_push_in)
    ,.push_data             (ioq_hdr_type_in)
    ,.pop                   (ioq_pop)
    ,.pop_data_v            (ioqval_wp)
    ,.pop_data              (tlq_ioq_data_rxp)

    ,.mem_we                (ioq_we)
    ,.mem_waddr             (ioq_waddr)
    ,.mem_wdata             (ioq_wdata)
    ,.mem_re                (ioq_re)
    ,.mem_raddr             (ioq_raddr)
    ,.mem_rdata             (ioq_rdata)

    ,.fifo_status           (ri_ioq_fifo_status)
    ,.fifo_full             (tlq_ioq_fifo_full_nc)                              
    ,.fifo_afull            (tlq_ioq_fifo_afull)
    ,.db_status             (ri_ioq_db_status)
);

always_ff @(posedge prim_nonflr_clk) begin
    if (ioq_re) ioq_rdata <= ioq_q[ioq_raddr];
    if (ioq_we) ioq_q[ioq_waddr] <= ioq_wdata;              
end

//-------------------------------------------------------------------------
// Due to cycle slip and metastability, the IOQ and TCQ are not valid
// unless they both have valid data.
//-------------------------------------------------------------------------

always_comb begin: tlq_ioqval_p
    tlq_ioqval_wp = ioqval_wp;
end // always_comb tlq_ioqval_p

//-------------------------------------------------------------------------
// The write data path for the In Order Queue (IOQ)
//-------------------------------------------------------------------------

always_comb begin: ioq_wr_p

    // If we detect an incoming posted or non posted header
    // the header type must be pushed onto the In Order Queue (IOQ).
    // The following signal generates a push signal based on this condition
    // for the IOQ
    ioq_hdr_push = lli_nphdr_val | lli_phdr_val;

    // The header type recorded in the IOQ.
    // 01 = Posted header
    // 10 = Non posted header
    ioq_hdr_type = {lli_nphdr_val, lli_phdr_val};

end // always_comb ioq_wr_p

//-------------------------------------------------------------------------
// Logic for poping entries from the in order queue
//-------------------------------------------------------------------------

always_comb begin: ioq_pop_p

    // We pop from the in order queue when;
    // 1) The oldest IOQ entry is a posted header and the header has been decoded
    // 2) The oldest IOQ entry is a non posted header and the non posted header has been decoded
    ioq_pop =
        // Posted header read by command/decode/schedule
        (cds_phdr_rd_wp  & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_PH]) |
        // Non posted header read by command/decode/schedule
        (cds_nphdr_rd_wp & tlq_ioq_data_rxp[`HQM_TLQ_IOQ_NPH]);

end // always_comb ioq_pop_p

always_comb begin

 phdr_val        = lli_phdr_val;
 phdr            = lli_phdr;
 pdata_push      = lli_pdata_push;

 nphdr_val       = lli_nphdr_val;
 nphdr           = lli_nphdr;
 npdata_push     = lli_npdata_push;

 pkt_data_in     = lli_pkt_data;
 pkt_data_par_in = lli_pkt_data_par;

 ioq_hdr_push_in = ioq_hdr_push;
 ioq_hdr_type_in = ioq_hdr_type;

end

// SJP: replaced all vecsyncs w/ just regs since we are not async

// Create sticky syndrome set and single pulse wide alarm signal for ri parity
// errors with an edge detect on the raw parity error indications
// Rising edge on individual bits sets corresponding ri_parity_err syndrome bit
// Rising edge on any bit sets the ri_parity_alarm output to the alarm block

load_RI_PARITY_ERR_t    ri_par_err_last_next;
load_RI_PARITY_ERR_t    ri_par_err_last_q;
load_RI_PARITY_ERR_t    set_ri_parity_err_next;
load_RI_PARITY_ERR_t    set_ri_parity_err_q;
logic                   ri_parity_alarm_next;
logic                   ri_parity_alarm_q;

always_comb begin
 ri_par_err_last_next                 = '0;
 ri_par_err_last_next.CBD_HDR_PERR    = set_cbd_hdr_parity_err;
 ri_par_err_last_next.CBD_DATA_PERR   = set_cbd_data_parity_err;
 ri_par_err_last_next.HCW_DATA_PERR   = set_hcw_data_parity_err;
 ri_par_err_last_next.PH_FIFO_SCREAM  = rf_tlq_phdr_parity_err[1];
 ri_par_err_last_next.PH_FIFO_PERR    = rf_tlq_phdr_parity_err[0];
 ri_par_err_last_next.PD_FIFO_PERR    = rf_tlq_pdata_parity_err;
 ri_par_err_last_next.NPH_FIFO_SCREAM = rf_tlq_nphdr_parity_err[1];
 ri_par_err_last_next.NPH_FIFO_PERR   = rf_tlq_nphdr_parity_err[0];
 ri_par_err_last_next.NPD_FIFO_PERR   = rf_tlq_npdata_parity_err;
end

assign set_ri_parity_err_next = (ri_par_err_last_next & ~ri_par_err_last_q);
assign ri_parity_alarm_next   = |{1'b0, set_ri_parity_err};

assign set_ri_parity_err      = set_ri_parity_err_q;
assign ri_parity_alarm        = ri_parity_alarm_q;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  lli_cpar_err_wp        <= '0;
  lli_tecrc_err_wp       <= '0;
  lli_chdr_w_err_wp      <= '0;
  ri_par_err_last_q      <= '0;
  ri_parity_alarm_q      <= '0;
  set_ri_parity_err_q    <= '0;
 end else begin
  lli_cpar_err_wp        <= lli_cpar_err_rl;
  lli_tecrc_err_wp       <= lli_tecrc_err_rl;
  if (lli_cpar_err_rl | lli_tecrc_err_rl) lli_chdr_w_err_wp <= lli_chdr_w_err_rl;
  ri_par_err_last_q      <= ri_par_err_last_next;
  ri_parity_alarm_q      <= ri_parity_alarm_next;
  set_ri_parity_err_q    <= set_ri_parity_err_next;
 end
end

//-------------------------------------------------------------------------
// Credit returns

// Completions have infinite credit, so just posted and non-posted.
// Headers always return 1 credit.

assign ri_tgt_crd_inc_next.ccreditup    = cds_phdr_rd_wp | cds_nphdr_rd_wp;
assign ri_tgt_crd_inc_next.ccredit_port = '0;
assign ri_tgt_crd_inc_next.ccredit_vc   = '0;
assign ri_tgt_crd_inc_next.ccredit_fc   = {1'b0, cds_nphdr_rd_wp};
assign ri_tgt_crd_inc_next.ccredit      = cds_phdr_rd_wp | cds_nphdr_rd_wp;

// Data depends on the length which is in DWs.
// Each FIFO entry can be considered to be 256b or 32B or 8DW.
// A data credit is for 4DWs, so 1 or 2 credits per entry popped.
// If popping data w/o header then it must be a full entry's worth or 2 DW.
// If popping data w/  header then it is 2 credits if (length%8)>4.

assign ri_tgt_crd_inc_next.dcreditup    = cds_pd_rd_wp | cds_npd_rd_wp;
assign ri_tgt_crd_inc_next.dcredit_port = '0;
assign ri_tgt_crd_inc_next.dcredit_vc   = '0;
assign ri_tgt_crd_inc_next.dcredit_fc   = {1'b0, cds_npd_rd_wp};
assign ri_tgt_crd_inc_next.dcredit      =
    (cds_pd_rd_wp) ?
            ((~cds_phdr_rd_wp  |
              (tlq_phdr_rxp.length[ 2:0] >  3'd4) |
              (tlq_phdr_rxp.length[ 2:0] == 3'd0)) ? 8'd2 : 8'd1) :
   ((cds_npd_rd_wp) ?
            ((~cds_nphdr_rd_wp |
              (tlq_nphdr_rxp.length[2:0] >  3'd4) |
              (tlq_nphdr_rxp.length[2:0] == 3'd0)) ? 8'd2 : 8'd1) : 8'd0);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ri_tgt_crd_inc <= '0;
 end else begin
  ri_tgt_crd_inc <= ri_tgt_crd_inc_next;
 end
end

//-------------------------------------------------------------------------
// Idle indication

assign tlq_idle = ~|{
     phdrval_wp
    ,tlq_pdataval_wp
    ,nphdrval_wp
    ,tlq_npdataval_wp
    ,ioqval_wp
};

//-----------------------------------------------------------------------------------------------------
// Dedicated interface event counters
// Implementing these 64b counters as two 32b halves for timing.

logic               cnt_clear_q;
logic               cnt_clearv_q;

logic   [4:0]       cnt_inc;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  cnt_clear_q   <= '0;
  cnt_clearv_q  <= '0;
 end else begin
  cnt_clear_q   <= cfg_cnt_clear;
  cnt_clearv_q  <= cfg_cnt_clearv;
 end
end

assign cnt_inc[0] = phdr_val;                               // 1:0 Posted header pushes
assign cnt_inc[1] = pdata_push;                             // 3:2 Posted data pushes
assign cnt_inc[2] = nphdr_val;                              // 5:4 Non-Posted headr pushes
assign cnt_inc[3] = npdata_push;                            // 7:6 Non-Posted data pushes
assign cnt_inc[4] = cpl_unexpected;                         // 9:8 Unexpected completions

// TBD: Add counters and/or SMON modes for CA, CTO, and poisoned Cpl

generate
 for (genvar g=0; g<=4; g=g+1) begin: g_cnt

  hqm_AW_inc_64b_val i_cnt (

     .clk       (prim_nonflr_clk)
    ,.rst_n     (prim_gated_rst_b)
    ,.clr       (cnt_clear_q)
    ,.clrv      (cnt_clearv_q)
    ,.inc       (cnt_inc[g])
    ,.count     ({cfg_tlq_cnts[(g*2)+1], cfg_tlq_cnts[g*2]})
  );

 end
endgenerate

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Assertions and Coverage
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// PROTO & COVERAGE
// - Cold reset when there are pending transactions in LLI( Execute a
//   cold reset when with pending transactions, come out of reset then
//   then successfully transmit new transactions); !sh_ep_pwrgd_np &
//   ri_tlq.tlq_phdrval_wp, tlq_pdataval_wp, tlq_nphdrval_wp, tlq_npdataval_wp,
//   tlq_ioqval_wp, lli_nphdr_val, lli_phdr_val,
//   ri.ri_lli_ctl.ri_lli_dsl.crb_read_valid0/1.
//   This should be followed with by the sequence sh_ep_pwrgd_np &
//   ri_tlq.tlq_phdrval_wp, tlq_pdataval_wp, tlq_nphdrval_wp, tlq_npdataval_wp,
//   tlq_ioqval_wp, lli_nphdr_val, lli_phdr_val,
//   ri.ri_lli_ctl.ri_lli_dsl.crb_read_valid0/1.
// - Hot reset when there are pending transactions in LLI( Execute a
//   hot reset when with pending transactions, come out of reset then
//   then successfully transmit new transactions); !prim_gated_rst_b &
//   ri_tlq.tlq_phdrval_wp, tlq_pdataval_wp, tlq_nphdrval_wp, tlq_npdataval_wp,
//   tlq_ioqval_wp, lli_nphdr_val, lli_phdr_val,
//   ri.ri_lli_ctl.ri_lli_dsl.crb_read_valid0/1.
//   This should be followed with by the sequence prim_gated_rst_b &
//   ri_tlq.tlq_phdrval_wp, tlq_pdataval_wp, tlq_nphdrval_wp, tlq_npdataval_wp,
//   tlq_ioqval_wp, lli_nphdr_val, lli_phdr_val,
//   ri.ri_lli_ctl.ri_lli_dsl.crb_read_valid0/1.
// - FLR reset when there are pending transactions in LLI for each function.
//   (Execute a FLR reset when with pending transactions, come out of reset
//   then successfully transmit new transactions); !ri_flr_rxp &
//   ri_tlq.tlq_phdrval_wp, tlq_pdataval_wp, tlq_nphdrval_wp, tlq_npdataval_wp,
//   tlq_ioqval_wp, lli_nphdr_val, lli_phdr_val,
//   ri.ri_lli_ctl.ri_lli_dsl.crb_read_valid0/1.
//   This should be followed with by the sequence ri_flr_rxp &
//   ri_tlq.tlq_phdrval_wp, tlq_pdataval_wp, tlq_nphdrval_wp, tlq_npdataval_wp,
//   tlq_ioqval_wp, lli_nphdr_val, lli_phdr_val,
//   ri.ri_lli_ctl.ri_lli_dsl.crb_read_valid0/1.

endmodule // hqm_ri_tlq

// $Log: ri_tlq.sv,v $
// Revision 1.12  2012/10/23 13:04:50  hmccarth
// replaced DV_OFF with RI_DV_OFF
//
// Revision 1.11  2012/10/04 10:50:44  jkearney
// Fix for HSD4556390, removing more unused code
//
// Revision 1.10  2012/09/26 10:50:29  jkearney
// RI BRTL comments, including removing redundant code from lli_ctl and lli_tdl, removing duplicate lli_scaln block and comment updates
//
// Revision 1.9  2012/07/24 12:03:49  hmccarth
// Updates made to the noa logic signals for coleto as per endpoint noa ep spread sheet
//
// Revision 1.8  2012/04/11 13:30:25  jkearney
// Removed unused ports
//
// Revision 1.7  2012/01/20 13:06:29  acunning
// added new fifos, bist io and removed log
//
// Revision 1.6  2011/12/20 13:52:46  jkearney
// fixed bus width vecsync_cto
//
// Revision 1.5  2011/12/14 10:09:26  jkearney
// RTL merge MASTER_PRE_TRUNK_MERGE_DEC8_2011
//
// Revision 1.4  2011/11/24 11:10:56  acunning
// fixed synthesis errors
//
// Revision 1.3  2011/11/15 16:36:45  acunning
// outstanding completion performance updates
//
// Revision 1.2  2011/11/08 14:45:45  hmccarth
// moved error dections to stage 1 of the lli_ctl pipe
//
// Revision 1.1.1.1  2011/09/28 09:03:04  acunning
// import tree
//
