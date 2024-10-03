// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_sva
// -- Author : Ashish Mehta
// -- Project Name : CPM1.8
// -- Creation Date: Friday, October 16 2015
// -- Description :
// -- SVA file containing assertions for FPV within the RI.
// -------------------------------------------------------------------


b5314548_rta_sta_not_assert_same_cycle:       assert property (@(posedge prim_gated_clk) disable iff (!prim_gated_rst_b)
                                                                 not ($rose(i_ri_pf_vf_cfg.csr_pcists_f.sta) & $rose(i_ri_pf_vf_cfg.csr_pcists_f.rta)));


b5314548_cov_rta : cover property (@(posedge prim_gated_clk) disable iff (!prim_gated_rst_b)
                                    i_ri_pf_vf_cfg.csr_pcists_f.rta);

// sta tied off as part of bug fix because HQM doesn't sent CA
//b5314548_cov_sta : cover property (@(posedge prim_gated_clk) disable iff (!prim_gated_rst_b)
//                                    i_ri_pf_vf_cfg.csr_pcists_f.sta);


b5314547_mdpe_set_for_poisoned_cmpl:        assert property (@(posedge prim_gated_clk) disable iff (!prim_gated_rst_b)
                                                                    $rose(i_ri_err.poisoned_wr_sent) && 
                                                                            (i_ri_pf_vf_cfg.device_status_nc.MDPE == 0) &&
                                                                            (i_ri_pf_vf_cfg.csr_pcicmd_wp.per == 1) |-> 
                                                                            ##[1:5] $rose(i_ri_pf_vf_cfg.device_status_nc.MDPE));

b5315242_iosfsb_cmd_stable:     assert property  (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b) 
                                    (!($rose(i_ri_cds.sb_cds_msg.irdy)) & (i_ri_cds.sb_cds_msg.irdy == 1'b1)) |-> ($stable({i_ri_cds.sb_cds_msg.mmiowr, i_ri_cds.sb_cds_msg.mmiord, i_ri_cds.sb_cds_msg.cfgwr, i_ri_cds.sb_cds_msg.cfgrd}) ) );

b5315242_iosfsb_cmd_onehot:     assert property  (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b) 
                                    (!($rose(i_ri_cds.sb_cds_msg.irdy)) & (i_ri_cds.sb_cds_msg.irdy == 1'b1)) |-> ($onehot0({i_ri_cds.sb_cds_msg.mmiowr, i_ri_cds.sb_cds_msg.mmiord, i_ri_cds.sb_cds_msg.cfgwr, i_ri_cds.sb_cds_msg.cfgrd}) ) );

b5315242_iosfsb_addr_stable:    assert property  (@(posedge prim_nonflr_clk) disable iff (~prim_gated_rst_b) 
                                    (!($rose(i_ri_cds.sb_cds_msg.irdy)) & (i_ri_cds.sb_cds_msg.irdy == 1'b1)) |-> ( (  $stable(i_ri_cds.sb_cds_msg.addr) & 
                                                                                $stable(i_ri_cds.sb_cds_msg.bar) &
                                                                                $stable(i_ri_cds.sb_cds_msg.sbe) &
                                                                                $stable(i_ri_cds.sb_cds_msg.fbe) &
                                                                                $stable(i_ri_cds.sb_cds_msg.np) ) ) );


