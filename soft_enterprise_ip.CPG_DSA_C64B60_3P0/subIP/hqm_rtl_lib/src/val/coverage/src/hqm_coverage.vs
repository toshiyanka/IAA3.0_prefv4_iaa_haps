
`include "hqm_system_def.vh"

// include QC macros
  `include "quickcov_common.vh"
  `include "quickcov_cover.vh"
  
  // the following line tells the coverage synthesis tool (JemHw) that the following code is synthesizable coverage
  (* jem_coverage_spec *)
  
  module hqm_coverage();
    // Signal Mapping
    //========================================================================

    `QUICKCOV_MAP(logic, ri_cds_prim_gated_clk,         hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.prim_nonflr_clk);
    `QUICKCOV_MAP(logic, ri_cds_rst_b,                  hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.prim_gated_rst_b);
    `QUICKCOV_MAP(logic, ri_cds_phdr_rd,                hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.cds_phdr_rd_wp);
    `QUICKCOV_MAP(logic [2:0], ri_cds_phdr_cmd,         hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.tlq_phdr_rxp.cmd);
    `QUICKCOV_MAP(logic, ri_cds_nphdr_rd,               hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.cds_nphdr_rd_wp);
    `QUICKCOV_MAP(logic [2:0], ri_cds_nphdr_cmd,        hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.tlq_nphdr_rxp.cmd);
    `QUICKCOV_MAP(logic, ri_cds_npd_rd,                 hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.cds_npd_rd_wp);
    `QUICKCOV_MAP(logic, ri_cds_pd_rd,                  hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.cds_pd_rd_wp);
    `QUICKCOV_MAP(logic, ri_cds_sb_irdy,                hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.irdy);
    `QUICKCOV_MAP(logic, ri_cds_sb_cfgrd,               hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.cfgrd);
    `QUICKCOV_MAP(logic, ri_cds_sb_cfgwr,               hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.cfgwr);
    `QUICKCOV_MAP(logic, ri_cds_sb_mmiord,              hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.mmiord);
    `QUICKCOV_MAP(logic, ri_cds_sb_mmiowr,              hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.sb_cds_msg.mmiowr);
    `QUICKCOV_MAP(logic, ri_cds_sb_wrack,               hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_wrack);
    `QUICKCOV_MAP(logic, ri_cds_sb_rdack,               hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.cds_sb_rdack);

    `QUICKCOV_MAP(logic, ri_cds_hcw_enq_in_v,           hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_in_v);
    `QUICKCOV_MAP(logic, ri_cds_hcw_enq_in_ready,       hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_in_ready);
    `QUICKCOV_MAP(logic, ri_cds_hcw_enq_qe_valid,       hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_in_data.hcw.cmd.hcw_cmd_field.qe_valid);
    `QUICKCOV_MAP(logic, ri_cds_hcw_enq_qe_uhl,         hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_in_data.hcw.cmd.hcw_cmd_field.qe_uhl);
    `QUICKCOV_MAP(logic, ri_cds_hcw_enq_cq_pop,         hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_in_data.hcw.cmd.hcw_cmd_field.cq_pop);
    `QUICKCOV_MAP(logic [1:0], ri_cds_hcw_enq_q_type,   hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_in_data.hcw.msg_info.qtype);
  
    `QUICKCOV_MAP(logic, ri_req_pf_valid,               hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_pf0_req.valid);
    `QUICKCOV_MAP(logic, ri_req_pf_read_valid,          hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_pf0_ack.read_valid);
    `QUICKCOV_MAP(logic, ri_req_pf_write_valid,         hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_pf0_ack.write_valid);
    `QUICKCOV_MAP(logic, ri_req_csr_int_valid,          hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_int_mmio_req.valid);
    `QUICKCOV_MAP(logic, ri_req_csr_int_read_valid,     hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_int_mmio_ack.read_valid);
    `QUICKCOV_MAP(logic, ri_req_csr_int_write_valid,    hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_int_mmio_ack.write_valid);
    `QUICKCOV_MAP(logic, ri_req_csr_ext_valid,          hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_ext_mmio_req.valid);
    `QUICKCOV_MAP(logic, ri_req_csr_ext_read_valid,     hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_ext_mmio_ack.read_valid);
    `QUICKCOV_MAP(logic, ri_req_csr_ext_write_valid,    hqm_sip_aon_wrap.i_hqm_sif.i_hqm_sif_core.i_hqm_ri.i_ri_csr_ctl.hqm_csr_ext_mmio_ack.write_valid);
    `QUICKCOV_MAP(logic, ri_req_msix_valid,             hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hqm_msix_mem_req.valid);
    `QUICKCOV_MAP(logic, ri_req_msix_read_valid,        hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hqm_msix_mem_ack.read_valid);
    `QUICKCOV_MAP(logic, ri_req_msix_write_valid,       hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hqm_msix_mem_ack.write_valid);

    `QUICKCOV_MAP(logic, hcw_sched_out_v,               hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hcw_sched_out_v);
    `QUICKCOV_MAP(logic, hcw_sched_out_hcw_v,           hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hcw_sched_out.hcw_v);
    `QUICKCOV_MAP(logic, hcw_sched_out_int_v,           hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hcw_sched_out.int_v);
    `QUICKCOV_MAP(logic, hcw_sched_out_ready,           hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hcw_sched_out_ready);
    `QUICKCOV_MAP(logic, hcw_sched_out_is_pf,           hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hcw_sched_out.is_pf);
    `QUICKCOV_MAP(logic, hcw_sched_out_pasidtlp_v,      hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.hcw_sched_out.pasidtlp[22]);

    `QUICKCOV_MAP(logic, ims_msix_w_v,                  hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.ims_msix_w_v);
    `QUICKCOV_MAP(logic, ims_msix_w_ready,              hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.ims_msix_w_ready);
    `QUICKCOV_MAP(logic, ims_msix_w_ai,                 hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.ims_msix_w.ai);
    `QUICKCOV_MAP(logic, ims_msix_w_poll,               hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.ims_msix_w.poll);
    `QUICKCOV_MAP(logic, ims_msix_w_rid,                hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.ims_msix_w.data[31:27]);

    `QUICKCOV_MAP(logic, pci_cfg_sciov_en,              hqm_sip_gated_wrap.i_hqm_system.i_hqm_system_core.pci_cfg_sciov_en);

    // Coverage Conditions

    // IOSF Sideband Transactions in hqm_ri_cds.sv
    `QC_COVER_COND(  ri_cds_mem_wr_sb,                  // Condition name
                     ri_cds_sb_mmiowr & ri_cds_sb_irdy, // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,     // clock
                     ~ri_cds_rst_b,                     // reset
                     "RI_CDS SB memory write",          // description
                     QC_EMULATION                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_mem_rd_sb,                  // Condition name
                     ri_cds_sb_mmiord & ri_cds_sb_irdy, // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,     // clock
                     ~ri_cds_rst_b,                     // reset
                     "RI_CDS SB memory read",           // description
                     QC_EMULATION                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_cfg_rd_sb,                  // Condition name
                     ri_cds_sb_cfgrd & ri_cds_sb_irdy,  // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,     // clock
                     ~ri_cds_rst_b,                     // reset
                     "RI_CDS SB cfg read",              // description
                     QC_EMULATION                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_cfg_wr_sb,                  // Condition name
                     ri_cds_sb_cfgwr & ri_cds_sb_irdy,  // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,     // clock
                     ~ri_cds_rst_b,                     // reset
                     "RI_CDS SB cfg write",             // description
                     QC_EMULATION                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );

    // IOSF Primary Transactions in hqm_ri_cds.sv
    `QC_COVER_COND(  ri_cds_mem_wr,                                     // Condition name
                     ri_cds_phdr_rd & (ri_cds_phdr_cmd == 3'h0),        // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CDS posted write",                             // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_mem_rd,                                     // Condition name
                     ri_cds_nphdr_rd & (ri_cds_nphdr_cmd == 3'h0),      // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CDS memory read",                              // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_cfg_rd,                                     // Condition name
                     ri_cds_nphdr_rd & (ri_cds_nphdr_cmd == 3'h0),      // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CDS cfg read",                                 // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_cfg_wr,                                     // Condition name
                     ri_cds_nphdr_rd & (ri_cds_nphdr_cmd == 3'h0),      // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CDS cfg write",                                // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );

    // CSR request targets in hqm_ri_csr_ctl.sv
    `QC_COVER_COND(  ri_pf_cfgrd,                                       // Condition name
                     ri_req_pf_valid & ri_req_pf_read_valid,            // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL PF CFG read",                          // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_pf_cfgwr,                                       // Condition name
                     ri_req_pf_valid & ri_req_pf_write_valid,           // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL PF CFG write",                         // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_csr_int_rd,                                     // Condition name
                     ri_req_csr_int_valid & ri_req_csr_int_read_valid,  // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL Internal CSR MMIO read",               // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_csr_int_wr,                                     // Condition name
                     ri_req_csr_int_valid & ri_req_csr_int_write_valid, // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL Internal CSR MMIO write",              // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_csr_ext_rd,                                     // Condition name
                     ri_req_csr_ext_valid & ri_req_csr_ext_read_valid,  // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL External CSR MMIO read",               // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_csr_ext_wr,                                     // Condition name
                     ri_req_csr_ext_valid & ri_req_csr_ext_write_valid, // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL External CSR MMIO write",              // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_msix_rd,                                        // Condition name
                     ri_req_msix_valid & ri_req_msix_read_valid,        // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL MSIX MMIO read",                       // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_msix_wr,                                        // Condition name
                     ri_req_msix_valid & ri_req_msix_write_valid,       // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,                     // clock
                     ~ri_cds_rst_b,                                     // reset
                     "RI_CSR_CTL MSIX MMIO write",                      // description
                     QC_EMULATION                                       // Tag; use this event in LEAF, Soc Simulation and emulation
    );

    // HCW enqueues in hqm_ri_cds.sv
    `QC_COVER_COND(  ri_cds_atm_hcw_enq,                        // Condition name
                     ri_cds_hcw_enq_in_v &
                       ri_cds_hcw_enq_in_ready &
                       ri_cds_hcw_enq_qe_valid &
                       (ri_cds_hcw_enq_q_type == 2'h0),         // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "RI_CDS HCW Enqueue to ATM QTYPE",         // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_dir_hcw_enq,                        // Condition name
                     ri_cds_hcw_enq_in_v &
                       ri_cds_hcw_enq_in_ready &
                       ri_cds_hcw_enq_qe_valid &
                       (ri_cds_hcw_enq_q_type == 2'h3),         // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "RI_CDS HCW Enqueue to DIR QTYPE",         // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_uno_hcw_enq,                        // Condition name
                     ri_cds_hcw_enq_in_v &
                       ri_cds_hcw_enq_in_ready &
                       ri_cds_hcw_enq_qe_valid &
                       (ri_cds_hcw_enq_q_type == 2'h1),         // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "RI_CDS HCW Enqueue to UNO QTYPE",         // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_ord_hcw_enq,                        // Condition name
                     ri_cds_hcw_enq_in_v &
                       ri_cds_hcw_enq_in_ready &
                       ri_cds_hcw_enq_qe_valid &
                       (ri_cds_hcw_enq_q_type == 2'h2),         // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "RI_CDS HCW Enqueue to ORD QTYPE",         // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_tok_ret_hcw_enq,                    // Condition name
                     ri_cds_hcw_enq_in_v &
                       ri_cds_hcw_enq_in_ready &
                       ri_cds_hcw_enq_cq_pop,                   // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "RI_CDS HCW Enqueue Token Return",         // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ri_cds_compl_hcw_enq,                      // Condition name
                     ri_cds_hcw_enq_in_v &
                       ri_cds_hcw_enq_in_ready &
                       ri_cds_hcw_enq_qe_uhl,                   // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "RI_CDS HCW Enqueue Completion",           // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );

    // Schedule HCW traffic
    `QC_COVER_COND(  hcw_sched_out,                             // Condition name
                     hcw_sched_out_v &
                       hcw_sched_out_hcw_v &
                       hcw_sched_out_ready,                     // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "HQM_CORE Scheduled HCW Out",              // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );

    // Schedule HCW traffic in SCIOV mode
    `QC_COVER_COND(  hcw_sched_out_sciov,                       // Condition name
                     pci_cfg_sciov_en &
                       hcw_sched_out_v &
                       hcw_sched_out_pasidtlp_v &
                       hcw_sched_out_hcw_v &
                       hcw_sched_out_ready,                     // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "HQM_CORE Scheduled HCW Out in SCIOV mode",// description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );

    // MSI-X/IMS Interrupts
    `QC_COVER_COND(  msix_int,                                  // Condition name
                     ims_msix_w_v &
                       ims_msix_w_ready &
                      ~ims_msix_w_ai,                           // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "MSI-X Interrupt",                         // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ims_int,                                   // Condition name
                     ims_msix_w_v &
                       ims_msix_w_ready &
                       ims_msix_w_ai &
                      ~ims_msix_w_poll,                         // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "IMS Interrupt",                           // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ims_poll_int,                              // Condition name
                    ~pci_cfg_sciov_en &
                       ims_msix_w_v &
                       ims_msix_w_ready &
                       ims_msix_w_poll &
                       ims_msix_w_ai &
                       (ims_msix_w_rid==5'h00),                 // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "IMS Polling Interrupt",                   // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
    `QC_COVER_COND(  ims_poll_sciov_int,                        // Condition name
                     pci_cfg_sciov_en &
                       ims_msix_w_v &
                       ims_msix_w_ready &
                       ims_msix_w_poll &
                       ims_msix_w_ai,                           // Expression; Just the signal in this case
                     posedge ri_cds_prim_gated_clk,             // clock
                     ~ri_cds_rst_b,                             // reset
                     "IMS Polling SCIOV Interrupt",             // description
                     QC_EMULATION                               // Tag; use this event in LEAF, Soc Simulation and emulation
    );
  endmodule

`QUICKCOV_BIND(hqm_sip, hqm_coverage)

