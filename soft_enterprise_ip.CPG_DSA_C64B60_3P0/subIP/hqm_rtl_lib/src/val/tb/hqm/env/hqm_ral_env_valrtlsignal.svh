foreach (aqed_pipe.CFG_AQED_WRD0[i]) begin
       aqed_pipe.CFG_AQED_WRD0[i].DATA.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_sram_pg_cont.i_sr_aqed.i_sram_b0.hqm_ip7413srhsshp2048x47m4c1.hqm_ip7413srhsshp2048x47m4c1_bmod.hqm_ip7413srhsshp2048x47m4c1_array.array[%0d][31:0]",i)});

       aqed_pipe.CFG_AQED_WRD0[i].DATA.set_logical_path("HQMIDMEM");
end
foreach (aqed_pipe.CFG_AQED_WRD1[i]) begin
       aqed_pipe.CFG_AQED_WRD1[i].DATA.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_sram_pg_cont.i_sr_aqed.i_sram_b0.hqm_ip7413srhsshp2048x47m4c1.hqm_ip7413srhsshp2048x47m4c1_bmod.hqm_ip7413srhsshp2048x47m4c1_array.array[%0d][47:32]",i),
                                                  $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_sram_pg_cont.i_sr_aqed.i_sram_b1.hqm_ip7413srhsshp2048x47m4c1.hqm_ip7413srhsshp2048x47m4c1_bmod.hqm_ip7413srhsshp2048x47m4c1_array.array[%0d][15:0]",i)});
       aqed_pipe.CFG_AQED_WRD1[i].DATA.set_logical_path("HQMIDMEM");
end

foreach (aqed_pipe.CFG_AQED_WRD2[i]) begin
       aqed_pipe.CFG_AQED_WRD2[i].DATA.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_sram_pg_cont.i_sr_aqed.i_sram_b1.hqm_ip7413srhsshp2048x47m4c1.hqm_ip7413srhsshp2048x47m4c1_bmod.hqm_ip7413srhsshp2048x47m4c1_array.array[%0d][31:0]",i)});
       aqed_pipe.CFG_AQED_WRD2[i].DATA.set_sliced_path(1);
       aqed_pipe.CFG_AQED_WRD2[i].DATA.set_logical_path("HQMIDMEM");
end

foreach (aqed_pipe.CFG_AQED_WRD3[i]) begin
       aqed_pipe.CFG_AQED_WRD3[i].DATA.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_sram_pg_cont.i_sr_aqed.i_sram_b1.hqm_ip7413srhsshp2048x47m4c1.hqm_ip7413srhsshp2048x47m4c1_bmod.hqm_ip7413srhsshp2048x47m4c1_array.array[%0d][47:32]",i),
                                                  $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_sram_pg_cont.i_sr_aqed.i_sram_b2.hqm_ip7413srhsshp2048x47m4c1.hqm_ip7413srhsshp2048x47m4c1_bmod.hqm_ip7413srhsshp2048x47m4c1_array.array[%0d][15:0]",i)});
       aqed_pipe.CFG_AQED_WRD3[i].DATA.set_logical_path("HQMIDMEM");
end

foreach (aqed_pipe.CFG_AQED_QID_FID_LIMIT[i]) begin
       aqed_pipe.CFG_AQED_QID_FID_LIMIT[i].QID_FID_LIMIT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid_fid_limit.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][12:0]",i)});
       aqed_pipe.CFG_AQED_QID_FID_LIMIT[i].QID_FID_LIMIT.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][7:0]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][15:8]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][23:16]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][31:24]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][39:32]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][47:40]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][55:48]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][63:56]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][71:64]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][79:72]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][87:80]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][95:88]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][103:96]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][111:104]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][119:112]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][127:120]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:128]",i),
                                       $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][3:0]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P0.set_sliced_path(1);
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][11:4]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][19:12]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][27:20]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][35:28]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][43:36]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][51:44]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][59:52]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][67:60]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][75:68]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][83:76]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][91:84]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][99:92]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][107:100]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][115:108]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][123:116]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:124]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][7:0]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][15:8]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][23:16]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][31:24]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][39:32]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][47:40]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][55:48]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][63:56]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][71:64]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][79:72]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][87:80]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][95:88]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][103:96]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][111:104]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][119:112]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][127:120]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:128]",i),
                                       $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][3:0]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P1.set_sliced_path(1);
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][11:4]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][19:12]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][27:20]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][35:28]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][43:36]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][51:44]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][59:52]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][67:60]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][75:68]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][83:76]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i]) begin
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][91:84]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P0.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][99:92]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P1.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][107:100]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P2.set_logical_path("HQMIDMEM");
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_aqed_qid2cqidix.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][115:108]",i)});
       atm_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i]) begin
      atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i].MIN_BIN.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_rdylst_clamp.i_rf.hqm_ip7413rfshpm1r1w32x8c1p1m5.ARRAY[%0d][%0d:%0d]",i,1,0)});
      atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i].MAX_BIN.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_rdylst_clamp.i_rf.hqm_ip7413rfshpm1r1w32x8c1p1m5.ARRAY[%0d][%0d:%0d]",i,3,2)});
      atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i].RSVZ0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_rdylst_clamp.i_rf.hqm_ip7413rfshpm1r1w32x8c1p1m5.ARRAY[%0d][%0d]",i,4)});
      atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i].MIN_BIN.set_logical_path("HQMIDMEM");
      atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i].MAX_BIN.set_logical_path("HQMIDMEM");
      atm_pipe.CFG_LDB_QID_RDYLST_CLAMP[i].RSVZ0.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[i]) begin
       credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[i].EN.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_cmp_id_chk_enbl_mem.i_rf.hqm_ip7413rfshpm1r1w64x8c1p1m5.ARRAY[%0d][0]",i)});
       credit_hist_pipe.CFG_CMP_SN_CHK_ENBL[i].EN.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_DIR_CQ_TIMER_COUNT[i]) begin
       credit_hist_pipe.CFG_DIR_CQ_TIMER_COUNT[i].TICK_COUNT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_count_rmw_pipe_dir_mem.i_rf.hqm_ip7413rfshpm1r1w64x16c1p1m5.ARRAY[%0d][13:0]",i)});
       credit_hist_pipe.CFG_DIR_CQ_TIMER_COUNT[i].TICK_COUNT.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_LDB_CQ_TIMER_COUNT[i]) begin
       credit_hist_pipe.CFG_LDB_CQ_TIMER_COUNT[i].TICK_COUNT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_count_rmw_pipe_ldb_mem.i_rf.hqm_ip7413rfshpm1r1w64x16c1p1m5.ARRAY[%0d][13:0]",i)});
       credit_hist_pipe.CFG_LDB_CQ_TIMER_COUNT[i].TICK_COUNT.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_DIR_CQ_DEPTH[i]) begin
       credit_hist_pipe.CFG_DIR_CQ_DEPTH[i].DEPTH.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_dir_cq_depth.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][10:0]",i)});
       credit_hist_pipe.CFG_DIR_CQ_DEPTH[i].DEPTH.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_DIR_CQ_INT_DEPTH_THRSH[i]) begin
       credit_hist_pipe.CFG_DIR_CQ_INT_DEPTH_THRSH[i].DEPTH_THRESHOLD.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_dir_cq_intr_thresh.i_rf.hqm_ip7413rfshpm1r1w64x16c1p1m5.ARRAY[%0d][12:0]",i)});
       credit_hist_pipe.CFG_DIR_CQ_INT_DEPTH_THRSH[i].DEPTH_THRESHOLD.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[i]) begin
       credit_hist_pipe.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[i].TOKEN_DEPTH_SELECT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_dir_cq_token_depth_select.i_rf.hqm_ip7413rfshpm1r1w64x8c1p1m5.ARRAY[%0d][3:0]",i)});
       credit_hist_pipe.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[i].TOKEN_DEPTH_SELECT.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_DIR_CQ_WPTR[i]) begin
       credit_hist_pipe.CFG_DIR_CQ_WPTR[i].WRITE_POINTER.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_dir_cq_wptr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][10:0]",i)});
       credit_hist_pipe.CFG_DIR_CQ_WPTR[i].WRITE_POINTER.set_logical_path("HQMIDMEM");
end

// The following registers exist, but have been removed from the RDL
/*
foreach (credit_hist_pipe.CFG_HIST_LIST_0[i]) begin
       credit_hist_pipe.CFG_HIST_LIST_0[i].SN_FID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][11:0]",i)});
       credit_hist_pipe.CFG_HIST_LIST_0[i].SN_FID.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_0[i].SLOT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][16:12]",i)});
       credit_hist_pipe.CFG_HIST_LIST_0[i].SLOT.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_0[i].MODE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][19:17]",i)});
       credit_hist_pipe.CFG_HIST_LIST_0[i].MODE.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_0[i].QIDIX.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][22:20]",i)});
       credit_hist_pipe.CFG_HIST_LIST_0[i].QIDIX.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_0[i].QID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][29:23]",i)});
       credit_hist_pipe.CFG_HIST_LIST_0[i].QID.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_0[i].QPRIO.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][31:30]",i)});
       credit_hist_pipe.CFG_HIST_LIST_0[i].QPRIO.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_HIST_LIST_1[i]) begin
       credit_hist_pipe.CFG_HIST_LIST_1[i].QPRIO_2.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][32]",i)});
       credit_hist_pipe.CFG_HIST_LIST_1[i].QPRIO_2.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_1[i].QTYPE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][34:33]",i)});
       credit_hist_pipe.CFG_HIST_LIST_1[i].QTYPE.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_1[i].MEAS.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][35]",i)});
       credit_hist_pipe.CFG_HIST_LIST_1[i].MEAS.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_1[i].CMP_ID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][39:36]",i)});
       credit_hist_pipe.CFG_HIST_LIST_1[i].CMP_ID.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_1[i].HID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][55:40]",i)});
       credit_hist_pipe.CFG_HIST_LIST_1[i].HID.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_1[i].QE_WT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_hist_list.i_sram.hqm_ip7413srhsshp2048x66m4c1.hqm_ip7413srhsshp2048x66m4c1_bmod.hqm_ip7413srhsshp2048x66m4c1_array.array[%0d][57:56]",i)});
       credit_hist_pipe.CFG_HIST_LIST_1[i].QE_WT.set_logical_path("HQMIDMEM");
end
*/

foreach (credit_hist_pipe.CFG_HIST_LIST_BASE[i]) begin
       credit_hist_pipe.CFG_HIST_LIST_BASE[i].BASE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_hist_list_minmax.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][12:0]",i)});
       credit_hist_pipe.CFG_HIST_LIST_BASE[i].BASE.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_HIST_LIST_LIMIT[i]) begin
       credit_hist_pipe.CFG_HIST_LIST_LIMIT[i].LIMIT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_hist_list_minmax.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][27:15]",i)});
       credit_hist_pipe.CFG_HIST_LIST_LIMIT[i].LIMIT.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[i]) begin
       credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[i].PUSH_PTR.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_hist_list_ptr.i_rf.hqm_ip7413rfshpm1r1w64x32c1p1m5.ARRAY[%0d][12:0]",i)});
       credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[i].PUSH_PTR.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[i].GENERATION.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_hist_list_ptr.i_rf.hqm_ip7413rfshpm1r1w64x32c1p1m5.ARRAY[%0d][13]",i)});
       credit_hist_pipe.CFG_HIST_LIST_PUSH_PTR[i].GENERATION.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_HIST_LIST_POP_PTR[i]) begin
       credit_hist_pipe.CFG_HIST_LIST_POP_PTR[i].POP_PTR.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_hist_list_ptr.i_rf.hqm_ip7413rfshpm1r1w64x32c1p1m5.ARRAY[%0d][28:16]",i)});
       credit_hist_pipe.CFG_HIST_LIST_POP_PTR[i].POP_PTR.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_HIST_LIST_POP_PTR[i].GENERATION.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_hist_list_ptr.i_rf.hqm_ip7413rfshpm1r1w64x32c1p1m5.ARRAY[%0d][29]",i)});
       credit_hist_pipe.CFG_HIST_LIST_POP_PTR[i].GENERATION.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_LDB_CQ_DEPTH[i]) begin
       credit_hist_pipe.CFG_LDB_CQ_DEPTH[i].DEPTH.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ldb_cq_depth.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][10:0]",i)});
       credit_hist_pipe.CFG_LDB_CQ_DEPTH[i].DEPTH.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_LDB_CQ_INT_DEPTH_THRSH[i]) begin
       credit_hist_pipe.CFG_LDB_CQ_INT_DEPTH_THRSH[i].DEPTH_THRESHOLD.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ldb_cq_intr_thresh.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][12:0]",i)});
       credit_hist_pipe.CFG_LDB_CQ_INT_DEPTH_THRSH[i].DEPTH_THRESHOLD.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_LDB_CQ_TOKEN_DEPTH_SELECT[i]) begin
       credit_hist_pipe.CFG_LDB_CQ_TOKEN_DEPTH_SELECT[i].TOKEN_DEPTH_SELECT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ldb_cq_token_depth_select.i_rf.hqm_ip7413rfshpm1r1w64x8c1p1m5.ARRAY[%0d][3:0]",i)});
       credit_hist_pipe.CFG_LDB_CQ_TOKEN_DEPTH_SELECT[i].TOKEN_DEPTH_SELECT.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_LDB_CQ_WPTR[i]) begin
       credit_hist_pipe.CFG_LDB_CQ_WPTR[i].WRITE_POINTER.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ldb_cq_wptr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][10:0]",i)});
       credit_hist_pipe.CFG_LDB_CQ_WPTR[i].WRITE_POINTER.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_ORD_QID_SN[i]) begin
       credit_hist_pipe.CFG_ORD_QID_SN[i].SN.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ord_qid_sn.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][9:0]",i)});
       credit_hist_pipe.CFG_ORD_QID_SN[i].SN.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_ORD_QID_SN_MAP[i]) begin
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].MODE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ord_qid_sn_map.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][2:0]",i)});
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].MODE.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].SLOT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ord_qid_sn_map.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][6:3]",i)});
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].SLOT.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].RSVZ0.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ord_qid_sn_map.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][7]",i)});
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].RSVZ0.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].GRP.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ord_qid_sn_map.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][8]",i)});
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].GRP.set_logical_path("HQMIDMEM");
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].RSVZ1.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_ord_qid_sn_map.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][9]",i)});
       credit_hist_pipe.CFG_ORD_QID_SN_MAP[i].RSVZ1.set_logical_path("HQMIDMEM");
end

// The following registers exist, but have been removed from the RDL
/*
foreach (credit_hist_pipe.CFG_FREELIST_0[i]) begin
       credit_hist_pipe.CFG_FREELIST_0[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_0.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_0[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_1[i]) begin
       credit_hist_pipe.CFG_FREELIST_1[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_1.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_1[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_2[i]) begin
       credit_hist_pipe.CFG_FREELIST_2[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_2.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_2[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_3[i]) begin
       credit_hist_pipe.CFG_FREELIST_3[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_3.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_3[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_4[i]) begin
       credit_hist_pipe.CFG_FREELIST_4[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_4.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_4[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_5[i]) begin
       credit_hist_pipe.CFG_FREELIST_5[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_5.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_5[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_6[i]) begin
       credit_hist_pipe.CFG_FREELIST_6[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_6.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_6[i].FLID.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_FREELIST_7[i]) begin
       credit_hist_pipe.CFG_FREELIST_7[i].FLID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_sram_pg_cont.i_sr_freelist_7.i_sram.hqm_ip7413srhsshp2048x16m8c1.hqm_ip7413srhsshp2048x16m8c1_bmod.hqm_ip7413srhsshp2048x16m8c1_array.array[%0d][10:0]",i)});
       credit_hist_pipe.CFG_FREELIST_7[i].FLID.set_logical_path("HQMIDMEM");
end
*/

foreach (credit_hist_pipe.CFG_DIR_CQ_TIMER_THRESHOLD[i]) begin
      credit_hist_pipe.CFG_DIR_CQ_TIMER_THRESHOLD[i].THRSH_13_1.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_threshold_r_pipe_dir_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][13:1]",i)});
      credit_hist_pipe.CFG_DIR_CQ_TIMER_THRESHOLD[i].THRSH_0.set_paths({"NOSIGNAL"});
      credit_hist_pipe.CFG_DIR_CQ_TIMER_THRESHOLD[i].THRSH_13_1.set_logical_path("HQMIDMEM");
end

foreach (credit_hist_pipe.CFG_LDB_CQ_TIMER_THRESHOLD[i]) begin
      credit_hist_pipe.CFG_LDB_CQ_TIMER_THRESHOLD[i].THRSH_13_1.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_threshold_r_pipe_ldb_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][13:1]",i)});
      credit_hist_pipe.CFG_LDB_CQ_TIMER_THRESHOLD[i].THRSH_0.set_paths({"NOSIGNAL"});
      credit_hist_pipe.CFG_LDB_CQ_TIMER_THRESHOLD[i].THRSH_13_1.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_ATM_QID_DPTH_THRSH[i]) begin
       list_sel_pipe.CFG_ATM_QID_DPTH_THRSH[i].THRESH.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_atm_qid_dpth_thrsh_mem.i_rf.hqm_ip7413rfshpm1r1w32x16c1p1m5.ARRAY[%0d][14:0]",i)});
       list_sel_pipe.CFG_ATM_QID_DPTH_THRSH[i].THRESH.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ2PRIOV[i]) begin
       list_sel_pipe.CFG_CQ2PRIOV[i].PRIO.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2priov_mem.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][23:0]",i)});
       list_sel_pipe.CFG_CQ2PRIOV[i].PRIO.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2PRIOV[i].V.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2priov_mem.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:24]",i)});
       list_sel_pipe.CFG_CQ2PRIOV[i].V.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ2QID0[i]) begin
       list_sel_pipe.CFG_CQ2QID0[i].QID_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_0_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][6:0]",i)});
       list_sel_pipe.CFG_CQ2QID0[i].QID_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2QID0[i].QID_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_0_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][13:7]",i)});
       list_sel_pipe.CFG_CQ2QID0[i].QID_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2QID0[i].QID_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_0_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][20:14]",i)});
       list_sel_pipe.CFG_CQ2QID0[i].QID_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2QID0[i].QID_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_0_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][27:21]",i)});
       list_sel_pipe.CFG_CQ2QID0[i].QID_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ2QID1[i]) begin
       list_sel_pipe.CFG_CQ2QID1[i].QID_P4.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_1_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][6:0]",i)});
       list_sel_pipe.CFG_CQ2QID1[i].QID_P4.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2QID1[i].QID_P5.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_1_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][13:7]",i)});
       list_sel_pipe.CFG_CQ2QID1[i].QID_P5.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2QID1[i].QID_P6.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_1_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][20:14]",i)});
       list_sel_pipe.CFG_CQ2QID1[i].QID_P6.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ2QID1[i].QID_P7.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq2qid_1_mem.i_rf.hqm_ip7413rfshpm1r1w64x30c1p1m5.ARRAY[%0d][27:21]",i)});
       list_sel_pipe.CFG_CQ2QID1[i].QID_P7.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[i]) begin
       list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[i].LIMIT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq_ldb_inflight_limit_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_INFLIGHT_LIMIT[i].LIMIT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_INFLIGHT_THRESHOLD[i]) begin
       list_sel_pipe.CFG_CQ_LDB_INFLIGHT_THRESHOLD[i].THRESH.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq_ldb_inflight_threshold_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_INFLIGHT_THRESHOLD[i].THRESH.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[i]) begin
       list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[i].TOKEN_DEPTH_SELECT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq_ldb_token_depth_select_mem.i_rf.hqm_ip7413rfshpm1r1w64x8c1p1m5.ARRAY[%0d][3:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_TOKEN_DEPTH_SELECT[i].TOKEN_DEPTH_SELECT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_DIR_QID_DPTH_THRSH[i]) begin
       list_sel_pipe.CFG_DIR_QID_DPTH_THRSH[i].THRESH.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_dir_qid_dpth_thrsh_mem.i_rf.hqm_ip7413rfshpm1r1w64x16c1p1m5.ARRAY[%0d][14:0]",i)});
       list_sel_pipe.CFG_DIR_QID_DPTH_THRSH[i].THRESH.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_NALB_QID_DPTH_THRSH[i]) begin
       list_sel_pipe.CFG_NALB_QID_DPTH_THRSH[i].THRESH.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_nalb_qid_dpth_thrsh_mem.i_rf.hqm_ip7413rfshpm1r1w32x16c1p1m5.ARRAY[%0d][14:0]",i)});
       list_sel_pipe.CFG_NALB_QID_DPTH_THRSH[i].THRESH.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[i]) begin
       list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[i].LIMIT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_aqed_active_limit_mem.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_QID_AQED_ACTIVE_LIMIT[i].LIMIT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[i]) begin
       list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[i].LIMIT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_inflight_limit_mem.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_QID_LDB_INFLIGHT_LIMIT[i].LIMIT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][7:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][15:8]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][23:16]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][31:24]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_00[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][39:32]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][47:40]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][55:48]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][63:56]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_01[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][71:64]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][79:72]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][87:80]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][95:88]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_02[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][103:96]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][111:104]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][119:112]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][127:120]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_03[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:128]",i),
                                       $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][3:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P0.set_sliced_path(1);
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][11:4]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][19:12]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][27:20]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_04[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][35:28]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][43:36]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][51:44]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][59:52]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_05[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][67:60]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][75:68]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][83:76]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][91:84]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_06[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][99:92]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][107:100]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][115:108]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][123:116]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_07[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:124]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][7:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][15:8]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][23:16]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_08[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][31:24]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][39:32]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][47:40]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][55:48]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_09[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][63:56]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][71:64]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][79:72]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][87:80]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_10[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][95:88]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][103:96]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][111:104]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][119:112]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_11[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][127:120]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:128]",i),
                                       $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][3:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P1.set_sliced_path(1);
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][11:4]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][19:12]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_12[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][27:20]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][35:28]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][43:36]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][51:44]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_13[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][59:52]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][67:60]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][75:68]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][83:76]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_14[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][91:84]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][99:92]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][107:100]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix2_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][115:108]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX2_15[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][7:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][15:8]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][23:16]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][31:24]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_00[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][39:32]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][47:40]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][55:48]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][63:56]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_01[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][71:64]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][79:72]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][87:80]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][95:88]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_02[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][103:96]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][111:104]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][119:112]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][127:120]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_03[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b0.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:128]",i),
                                       $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][3:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P0.set_sliced_path(1);
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][11:4]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][19:12]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][27:20]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_04[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][35:28]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][43:36]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][51:44]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][59:52]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_05[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][67:60]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][75:68]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][83:76]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][91:84]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_06[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][99:92]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][107:100]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][115:108]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][123:116]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_07[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b1.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:124]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][7:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][15:8]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][23:16]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_08[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][31:24]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][39:32]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][47:40]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][55:48]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_09[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][63:56]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][71:64]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][79:72]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][87:80]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_10[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][95:88]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][103:96]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][111:104]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][119:112]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_11[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][127:120]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b2.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][131:128]",i),
                                       $psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][3:0]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P1.set_sliced_path(1);
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][11:4]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][19:12]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_12[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][27:20]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][35:28]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][43:36]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][51:44]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_13[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][59:52]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][67:60]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][75:68]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][83:76]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_14[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i]) begin
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P0.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][91:84]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P0.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P1.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][99:92]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P1.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P2.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][107:100]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P2.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P3.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_qid_ldb_qid2cqidix_mem.i_rf_b3.hqm_ip7413rfshpm1r1w32x132c1p1m5.ARRAY[%0d][115:108]",i)});
       list_sel_pipe.CFG_QID_LDB_QID2CQIDIX_15[i].CQ_P3.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTL[i]) begin
       list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTL[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_dir_tot_sch_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x66c1p1m5.ARRAY[%0d][31:0]",i)});
       list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTL[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTH[i]) begin
       list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTH[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_dir_tot_sch_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x66c1p1m5.ARRAY[%0d][63:32]",i)});
       list_sel_pipe.CFG_CQ_DIR_TOT_SCH_CNTH[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_INFLIGHT_COUNT[i]) begin
       list_sel_pipe.CFG_CQ_LDB_INFLIGHT_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_ldb_inflight_count_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_INFLIGHT_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[i]) begin
       list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[i].TOKEN_COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_ldb_token_count_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][10:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_TOKEN_COUNT[i].TOKEN_COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[i]) begin
       list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_ldb_tot_sch_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x66c1p1m5.ARRAY[%0d][31:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTL[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTH[i]) begin
       list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTH[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_ldb_tot_sch_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x66c1p1m5.ARRAY[%0d][63:32]",i)});
       list_sel_pipe.CFG_CQ_LDB_TOT_SCH_CNTH[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_DIR_ENQUEUE_COUNT[i]) begin
       list_sel_pipe.CFG_QID_DIR_ENQUEUE_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_dir_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][12:0]",i)});
       list_sel_pipe.CFG_QID_DIR_ENQUEUE_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[i]) begin
       list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_dir_tok_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][10:0]",i)});
       list_sel_pipe.CFG_CQ_DIR_TOKEN_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[i]) begin
       list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[i].TOKEN_DEPTH_SELECT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_dir_tok_lim_mem.i_rf.hqm_ip7413rfshpm1r1w64x8c1p1m5.ARRAY[%0d][3:0]",i)});
       list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[i].DISABLE_WB_OPT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_dir_tok_lim_mem.i_rf.hqm_ip7413rfshpm1r1w64x8c1p1m5.ARRAY[%0d][4:4]",i)});
       list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[i].TOKEN_DEPTH_SELECT.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[i].DISABLE_WB_OPT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_WU_COUNT[i]) begin
       list_sel_pipe.CFG_CQ_LDB_WU_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cq_ldb_wu_count_mem.i_rf.hqm_ip7413rfshpm1r1w64x20c1p1m5.ARRAY[%0d][16:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_WU_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[i]) begin
       list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[i].LIMIT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq_ldb_wu_limit_mem.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][14:0]",i)});
       list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[i].V.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_cfg_cq_ldb_wu_limit_mem.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][15:15]",i)});
       list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[i].LIMIT.set_logical_path("HQMIDMEM");
       list_sel_pipe.CFG_CQ_LDB_WU_LIMIT[i].V.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_AQED_ACTIVE_COUNT[i]) begin
       list_sel_pipe.CFG_QID_AQED_ACTIVE_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_aqed_active_count_mem.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_QID_AQED_ACTIVE_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_ATM_ACTIVE[i]) begin
       list_sel_pipe.CFG_QID_ATM_ACTIVE[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_atm_active_mem.i_rf.hqm_ip7413rfshpm1r1w32x18c1p1m5.ARRAY[%0d][14:0]",i)});
       list_sel_pipe.CFG_QID_ATM_ACTIVE[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[i]) begin
       list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_atm_tot_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w32x66c1p1m5.ARRAY[%0d][31:0]",i)});
       list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTL[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTH[i]) begin
       list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTH[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_atm_tot_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w32x66c1p1m5.ARRAY[%0d][63:32]",i)});
       list_sel_pipe.CFG_QID_ATM_TOT_ENQ_CNTH[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_ATQ_ENQUEUE_COUNT[i]) begin
       list_sel_pipe.CFG_QID_ATQ_ENQUEUE_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_atq_enqueue_count_mem.i_rf.hqm_ip7413rfshpm1r1w32x18c1p1m5.ARRAY[%0d][13:0]",i)});
       list_sel_pipe.CFG_QID_ATQ_ENQUEUE_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_DIR_MAX_DEPTH[i]) begin
       list_sel_pipe.CFG_QID_DIR_MAX_DEPTH[i].DEPTH.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_dir_max_depth_mem.i_rf.hqm_ip7413rfshpm1r1w64x16c1p1m5.ARRAY[%0d][12:0]",i)});
       list_sel_pipe.CFG_QID_DIR_MAX_DEPTH[i].DEPTH.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_DIR_REPLAY_COUNT[i]) begin
       list_sel_pipe.CFG_QID_DIR_REPLAY_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_dir_replay_count_mem.i_rf.hqm_ip7413rfshpm1r1w32x18c1p1m5.ARRAY[%0d][12:0]",i)});
       list_sel_pipe.CFG_QID_DIR_REPLAY_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTL[i]) begin
       list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTL[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_dir_tot_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x66c1p1m5.ARRAY[%0d][31:0]",i)});
       list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTL[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTH[i]) begin
       list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTH[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_dir_tot_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w64x66c1p1m5.ARRAY[%0d][63:32]",i)});
       list_sel_pipe.CFG_QID_DIR_TOT_ENQ_CNTH[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_ENQUEUE_COUNT[i]) begin
       list_sel_pipe.CFG_QID_LDB_ENQUEUE_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_ldb_enqueue_count_mem.i_rf.hqm_ip7413rfshpm1r1w32x18c1p1m5.ARRAY[%0d][13:0]",i)});
       list_sel_pipe.CFG_QID_LDB_ENQUEUE_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_INFLIGHT_COUNT[i]) begin
       list_sel_pipe.CFG_QID_LDB_INFLIGHT_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_ldb_inflight_count_mem.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][11:0]",i)});
       list_sel_pipe.CFG_QID_LDB_INFLIGHT_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_LDB_REPLAY_COUNT[i]) begin
       list_sel_pipe.CFG_QID_LDB_REPLAY_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_ldb_replay_count_mem.i_rf.hqm_ip7413rfshpm1r1w32x18c1p1m5.ARRAY[%0d][13:0]",i)});
       list_sel_pipe.CFG_QID_LDB_REPLAY_COUNT[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_NALDB_MAX_DEPTH[i]) begin
       list_sel_pipe.CFG_QID_NALDB_MAX_DEPTH[i].DEPTH.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_naldb_max_depth_mem.i_rf.hqm_ip7413rfshpm1r1w32x16c1p1m5.ARRAY[%0d][13:0]",i)});
       list_sel_pipe.CFG_QID_NALDB_MAX_DEPTH[i].DEPTH.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[i]) begin
       list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_naldb_tot_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w32x66c1p1m5.ARRAY[%0d][31:0]",i)});
       list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTL[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTH[i]) begin
       list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTH[i].COUNT.set_paths({$psprintf("i_hqm_list_sel_mem.i_hqm_list_sel_mem_hqm_clk_rf_pg_cont.i_rf_qid_naldb_tot_enq_cnt_mem.i_rf.hqm_ip7413rfshpm1r1w32x66c1p1m5.ARRAY[%0d][63:32]",i)});
       list_sel_pipe.CFG_QID_NALDB_TOT_ENQ_CNTH[i].COUNT.set_logical_path("HQMIDMEM");
end

foreach (reorder_pipe.CFG_REORDER_STATE_NALB_HP[i]) begin
       reorder_pipe.CFG_REORDER_STATE_NALB_HP[i].HP.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_lbhp_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x18c1p1m5.ARRAY[%0d][14:0]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_NALB_HP[i].HP.set_logical_path("HQMIDMEM");
end

foreach (reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i]) begin
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].CQ.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][6:0]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].CQ.set_logical_path("HQMIDMEM");
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].QIDIX.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][9:7]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].QIDIX.set_logical_path("HQMIDMEM");
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].QID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][16:10]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].QID.set_logical_path("HQMIDMEM");
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].QPRI.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][19:17]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].QPRI.set_logical_path("HQMIDMEM");
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].USER.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][20]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].USER.set_logical_path("HQMIDMEM");
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].RSZV0.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][21]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].RSZV0.set_logical_path("HQMIDMEM");
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].VLD.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_reord_st_mem.i_rf_b%0d.hqm_ip7413rfshpm1r1w1024x26c1p1m5.ARRAY[%0d][22]",(i <= 1023) ? 0 : 1,i%1024)});
       reorder_pipe.CFG_REORDER_STATE_QID_QIDIX_CQ[i].VLD.set_logical_path("HQMIDMEM");
end

foreach (reorder_pipe.CFG_GRP_0_SLOT_SHIFT[i]) begin
       reorder_pipe.CFG_GRP_0_SLOT_SHIFT[i].CHANGE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_sn0_order_shft_mem.i_rf.hqm_ip7413rfshpm1r1w16x12c1p1m5.ARRAY[%0d][9:0]",i)});
       reorder_pipe.CFG_GRP_0_SLOT_SHIFT[i].CHANGE.set_logical_path("HQMIDMEM");
end

foreach (reorder_pipe.CFG_GRP_1_SLOT_SHIFT[i]) begin
       reorder_pipe.CFG_GRP_1_SLOT_SHIFT[i].CHANGE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_sn1_order_shft_mem.i_rf.hqm_ip7413rfshpm1r1w16x12c1p1m5.ARRAY[%0d][9:0]",i)});
       reorder_pipe.CFG_GRP_1_SLOT_SHIFT[i].CHANGE.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.ALARM_VF_SYND0[i]) begin
       hqm_system_csr.ALARM_VF_SYND0[i].SYNDROME.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][7:0]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].SYNDROME.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].RTYPE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][9:8]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].RTYPE.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].VF_SYND0_PARITY.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][10]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].VF_SYND0_PARITY.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].VF_SYND1_PARITY.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][11]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].VF_SYND1_PARITY.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].VF_SYND2_PARITY.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][12]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].VF_SYND2_PARITY.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].IS_LDB.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][13]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].IS_LDB.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].CLS.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][15:14]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].CLS.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].AID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][21:16]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].AID.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].UNIT.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][25:22]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].UNIT.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].SOURCE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd0.i_rf.hqm_ip7413rfshpm1r1w16x30c1p1m5.ARRAY[%0d][29:26]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].SOURCE.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND0[i].MORE.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.alarm_vf_synd_more_q[%0d]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].MORE.set_logical_path("HQMID");
       hqm_system_csr.ALARM_VF_SYND0[i].VALID.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.alarm_vf_synd_v_q[%0d]",i)});
       hqm_system_csr.ALARM_VF_SYND0[i].VALID.set_logical_path("HQMID");
end

foreach (hqm_system_csr.ALARM_VF_SYND1[i]) begin
       hqm_system_csr.ALARM_VF_SYND1[i].DSI.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd1.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][15:0]",i)});
       hqm_system_csr.ALARM_VF_SYND1[i].DSI.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND1[i].QID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd1.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][23:16]",i)});
       hqm_system_csr.ALARM_VF_SYND1[i].QID.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND1[i].QTYPE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd1.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][25:24]",i)});
       hqm_system_csr.ALARM_VF_SYND1[i].QTYPE.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND1[i].QPRI.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd1.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][28:26]",i)});
       hqm_system_csr.ALARM_VF_SYND1[i].QPRI.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND1[i].MSG_TYPE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd1.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][31:29]",i)});
       hqm_system_csr.ALARM_VF_SYND1[i].MSG_TYPE.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.ALARM_VF_SYND2[i]) begin
       hqm_system_csr.ALARM_VF_SYND2[i].LOCK_ID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][15:0]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].LOCK_ID.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].DEBUG.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][23:16]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].DEBUG.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].CQ_POP.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][24]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].CQ_POP.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].QE_UHL.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][25]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].QE_UHL.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].QE_ORSP.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][26]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].QE_ORSP.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].QE_VALID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][27]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].QE_VALID.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].ISZ.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][28]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].ISZ.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].DSI_ERROR.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][29]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].DSI_ERROR.set_logical_path("HQMIDMEM");
       hqm_system_csr.ALARM_VF_SYND2[i].HQMRSVD.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_alarm_vf_synd2.i_rf.hqm_ip7413rfshpm1r1w16x32c1p1m5.ARRAY[%0d][31:30]",i)});
       hqm_system_csr.ALARM_VF_SYND2[i].HQMRSVD.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_CQ2VF_PF_RO[i]) begin
       hqm_system_csr.DIR_CQ2VF_PF_RO[i].VF.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq2vf_pf.i_rf.hqm_ip7413rfshpm1r1w48x14c1p1m5.ARRAY[%0d][%0d:%0d]",i/2,(6*(i%2))+3,(6*(i%2))+0) });
       hqm_system_csr.DIR_CQ2VF_PF_RO[i].VF.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ2VF_PF_RO[i].IS_PF.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq2vf_pf.i_rf.hqm_ip7413rfshpm1r1w48x14c1p1m5.ARRAY[%0d][%0d:%0d]",i/2,(6*(i%2))+4,(6*(i%2))+4) });
       hqm_system_csr.DIR_CQ2VF_PF_RO[i].IS_PF.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ2VF_PF_RO[i].RO.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq2vf_pf.i_rf.hqm_ip7413rfshpm1r1w48x14c1p1m5.ARRAY[%0d][%0d:%0d]",i/2,(6*(i%2))+5,(6*(i%2))+5) });
       hqm_system_csr.DIR_CQ2VF_PF_RO[i].RO.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_CQ_ADDR_L[i]) begin
       hqm_system_csr.DIR_CQ_ADDR_L[i].ADDR_L.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_addr_l.i_rf.hqm_ip7413rfshpm1r1w64x28c1p1m5.ARRAY[%0d][25:0]",i)});
       hqm_system_csr.DIR_CQ_ADDR_L[i].ADDR_L.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_CQ_ADDR_U[i]) begin
       hqm_system_csr.DIR_CQ_ADDR_U[i].ADDR_U.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_addr_u.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i)});
       hqm_system_csr.DIR_CQ_ADDR_U[i].ADDR_U.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.AI_ADDR_L[i]) begin
    if (i < 96) begin
       hqm_system_csr.AI_ADDR_L[i].IMS_ADDR_L.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_ai_addr_l.i_rf.hqm_ip7413rfshpm1r1w64x32c1p1m5.ARRAY[%0d][29:0]",i)});
    end else begin
       hqm_system_csr.AI_ADDR_L[i].IMS_ADDR_L.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_ai_addr_l.i_rf.hqm_ip7413rfshpm1r1w64x32c1p1m5.ARRAY[%0d][29:0]",i-96)});
    end
       hqm_system_csr.AI_ADDR_L[i].IMS_ADDR_L.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.AI_ADDR_U[i]) begin
    if (i < 96) begin
       hqm_system_csr.AI_ADDR_U[i].IMS_ADDR_U.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_ai_addr_u.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i)});
    end else begin
       hqm_system_csr.AI_ADDR_U[i].IMS_ADDR_U.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_ai_addr_u.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i-96)});
    end
       hqm_system_csr.AI_ADDR_U[i].IMS_ADDR_U.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.AI_DATA[i]) begin
    if (i < 96) begin
       hqm_system_csr.AI_DATA[i].IMS_DATA.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_ai_data.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i)});
    end else begin
       hqm_system_csr.AI_DATA[i].IMS_DATA.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_ai_data.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i-96)});
    end
       hqm_system_csr.AI_DATA[i].IMS_DATA.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_CQ_ISR[i]) begin
       hqm_system_csr.DIR_CQ_ISR[i].VECTOR.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_isr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][5:0]",i)});
       hqm_system_csr.DIR_CQ_ISR[i].VECTOR.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ_ISR[i].VF.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_isr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][9:6]",i)});
       hqm_system_csr.DIR_CQ_ISR[i].VF.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ_ISR[i].EN_CODE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_isr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][11:10]",i)});
       hqm_system_csr.DIR_CQ_ISR[i].EN_CODE.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_CQ_PASID[i]) begin
       hqm_system_csr.DIR_CQ_PASID[i].PASID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][19:0]",i)});
       hqm_system_csr.DIR_CQ_PASID[i].PASID.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ_PASID[i].EXE_REQ.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][20]",i)});
       hqm_system_csr.DIR_CQ_PASID[i].EXE_REQ.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ_PASID[i].PRIV_REQ.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][21]",i)});
       hqm_system_csr.DIR_CQ_PASID[i].PRIV_REQ.set_logical_path("HQMIDMEM");
       hqm_system_csr.DIR_CQ_PASID[i].FMT2.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][22]",i)});
       hqm_system_csr.DIR_CQ_PASID[i].FMT2.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_PP2VAS[i]) begin
  hqm_system_csr.DIR_PP2VAS[i].VAS.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_pp2vas.i_rf.hqm_ip7413rfshpm1r1w48x12c1p1m5.ARRAY[%0d][%0d:%0d]",i/2,(5*(i%2))+4,(5*(i%2))+0) });
       hqm_system_csr.DIR_PP2VAS[i].VAS.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_PP_V[i]) begin
  hqm_system_csr.DIR_PP_V[i].PP_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_pp_v.i_rf.hqm_ip7413rfshpm1r1w8x18c1p1m5.ARRAY[%0d][%0d:%0d]",i/16,(1*(i%16))+0,(1*(i%16))+0) });
       hqm_system_csr.DIR_PP_V[i].PP_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.DIR_VASQID_V[i]) begin
  hqm_system_csr.DIR_VASQID_V[i].VASQID_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_dir_vasqid_v.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][%0d:%0d]",i/32,(1*(i%32))+0,(1*(i%32))+0) });
       hqm_system_csr.DIR_VASQID_V[i].VASQID_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_CQ2VF_PF_RO[i]) begin
  hqm_system_csr.LDB_CQ2VF_PF_RO[i].VF.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq2vf_pf.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][%0d:%0d]",i/2,(6*(i%2))+3,(6*(i%2))+0) });
       hqm_system_csr.LDB_CQ2VF_PF_RO[i].VF.set_logical_path("HQMIDMEM");
  hqm_system_csr.LDB_CQ2VF_PF_RO[i].IS_PF.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq2vf_pf.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][%0d]",i/2,(6*(i%2)) + 4)});
       hqm_system_csr.LDB_CQ2VF_PF_RO[i].IS_PF.set_logical_path("HQMIDMEM");
  hqm_system_csr.LDB_CQ2VF_PF_RO[i].RO.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq2vf_pf.i_rf.hqm_ip7413rfshpm1r1w32x14c1p1m5.ARRAY[%0d][%0d]",i/2,(6*(i%2)) + 5)});
       hqm_system_csr.LDB_CQ2VF_PF_RO[i].RO.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_CQ_ADDR_L[i]) begin
       hqm_system_csr.LDB_CQ_ADDR_L[i].ADDR_L.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_addr_l.i_rf.hqm_ip7413rfshpm1r1w64x28c1p1m5.ARRAY[%0d][25:0]",i)});
       hqm_system_csr.LDB_CQ_ADDR_L[i].ADDR_L.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_CQ_ADDR_U[i]) begin
       hqm_system_csr.LDB_CQ_ADDR_U[i].ADDR_U.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_addr_u.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i)});
       hqm_system_csr.LDB_CQ_ADDR_U[i].ADDR_U.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_CQ_ISR[i]) begin
       hqm_system_csr.LDB_CQ_ISR[i].VECTOR.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_isr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][5:0]",i)});
       hqm_system_csr.LDB_CQ_ISR[i].VECTOR.set_logical_path("HQMIDMEM");
       hqm_system_csr.LDB_CQ_ISR[i].VF.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_isr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][9:6]",i)});
       hqm_system_csr.LDB_CQ_ISR[i].VF.set_logical_path("HQMIDMEM");
       hqm_system_csr.LDB_CQ_ISR[i].EN_CODE.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_isr.i_rf.hqm_ip7413rfshpm1r1w64x14c1p1m5.ARRAY[%0d][11:10]",i)});
       hqm_system_csr.LDB_CQ_ISR[i].EN_CODE.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_CQ_PASID[i]) begin
       hqm_system_csr.LDB_CQ_PASID[i].PASID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][19:0]",i)});
       hqm_system_csr.LDB_CQ_PASID[i].PASID.set_logical_path("HQMIDMEM");
       hqm_system_csr.LDB_CQ_PASID[i].EXE_REQ.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][20]",i)});
       hqm_system_csr.LDB_CQ_PASID[i].EXE_REQ.set_logical_path("HQMIDMEM");
       hqm_system_csr.LDB_CQ_PASID[i].PRIV_REQ.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][21]",i)});
       hqm_system_csr.LDB_CQ_PASID[i].PRIV_REQ.set_logical_path("HQMIDMEM");
       hqm_system_csr.LDB_CQ_PASID[i].FMT2.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_cq_pasid.i_rf.hqm_ip7413rfshpm1r1w64x24c1p1m5.ARRAY[%0d][22]",i)});
       hqm_system_csr.LDB_CQ_PASID[i].FMT2.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_PP2VAS[i]) begin
  hqm_system_csr.LDB_PP2VAS[i].VAS.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_pp2vas.i_rf.hqm_ip7413rfshpm1r1w32x12c1p1m5.ARRAY[%0d][%0d:%0d]",i/2,(5*(i%2))+4,(5*(i%2))+0) });
       hqm_system_csr.LDB_PP2VAS[i].VAS.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_QID2VQID[i]) begin
  hqm_system_csr.LDB_QID2VQID[i].VQID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_qid2vqid.i_rf.hqm_ip7413rfshpm1r1w8x22c1p1m5.ARRAY[%0d][%0d:%0d]",i/4,(5*(i%4))+4,(5*(i%4))+0) });
       hqm_system_csr.LDB_QID2VQID[i].VQID.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.LDB_VASQID_V[i]) begin
  hqm_system_csr.LDB_VASQID_V[i].VASQID_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_ldb_vasqid_v.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][%0d:%0d]",i/16,(1*(i%16))+0,(1*(i%16))+0) });
       hqm_system_csr.LDB_VASQID_V[i].VASQID_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_DIR_VPP2PP[i]) begin
  hqm_system_csr.VF_DIR_VPP2PP[i].PP.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_dir_vpp2pp.i_rf.hqm_ip7413rfshpm1r1w384x36c1p1m5.ARRAY[%0d][%0d:%0d]",i/4,(7*(i%4))+6,(7*(i%4))+0) });
       hqm_system_csr.VF_DIR_VPP2PP[i].PP.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_DIR_VPP_V[i]) begin
  hqm_system_csr.VF_DIR_VPP_V[i].VPP_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_dir_vpp_v.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][%0d:%0d]",i/16,(1*(i%16))+0,(1*(i%16))+0) });
       hqm_system_csr.VF_DIR_VPP_V[i].VPP_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_DIR_VQID2QID[i]) begin
  hqm_system_csr.VF_DIR_VQID2QID[i].QID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_dir_vqid2qid.i_rf.hqm_ip7413rfshpm1r1w384x36c1p1m5.ARRAY[%0d][%0d:%0d]",i/4,(7*(i%4))+6,(7*(i%4))+0) });
       hqm_system_csr.VF_DIR_VQID2QID[i].QID.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_DIR_VQID_V[i]) begin
  hqm_system_csr.VF_DIR_VQID_V[i].VQID_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_dir_vqid_v.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][%0d:%0d]",i/16,(1*(i%16))+0,(1*(i%16))+0) });
       hqm_system_csr.VF_DIR_VQID_V[i].VQID_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_LDB_VPP2PP[i]) begin
  hqm_system_csr.VF_LDB_VPP2PP[i].PP.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_ldb_vpp2pp.i_rf.hqm_ip7413rfshpm1r1w256x26c1p1m5.ARRAY[%0d][%0d:%0d]",i/4,(6*(i%4))+5,(6*(i%4))+0) });
       hqm_system_csr.VF_LDB_VPP2PP[i].PP.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_LDB_VPP_V[i]) begin
  hqm_system_csr.VF_LDB_VPP_V[i].VPP_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_ldb_vpp_v.i_rf.hqm_ip7413rfshpm1r1w64x18c1p1m5.ARRAY[%0d][%0d:%0d]",i/16,(1*(i%16))+0,(1*(i%16))+0) });
       hqm_system_csr.VF_LDB_VPP_V[i].VPP_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_LDB_VQID2QID[i]) begin
  hqm_system_csr.VF_LDB_VQID2QID[i].QID.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_ldb_vqid2qid.i_rf.hqm_ip7413rfshpm1r1w128x28c1p1m5.ARRAY[%0d][%0d:%0d]",i/4,(5*(i%4))+4,(5*(i%4))+0) });
       hqm_system_csr.VF_LDB_VQID2QID[i].QID.set_logical_path("HQMIDMEM");
end

foreach (hqm_system_csr.VF_LDB_VQID_V[i]) begin
  hqm_system_csr.VF_LDB_VQID_V[i].VQID_V.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_lut_vf_ldb_vqid_v.i_rf.hqm_ip7413rfshpm1r1w32x18c1p1m5.ARRAY[%0d][%0d:%0d]",i/16,(1*(i%16))+0,(1*(i%16))+0) });
       hqm_system_csr.VF_LDB_VQID_V[i].VQID_V.set_logical_path("HQMIDMEM");
end

foreach (hqm_msix_mem.MSG_ADDR_L[i]) begin
       if (i == 64) begin
         hqm_msix_mem.MSG_ADDR_L[i].MSG_ADDR_L.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_tbl_word0_ms_q[%0d:%0d]",31,2)});
         hqm_msix_mem.MSG_ADDR_L[i].RSVD.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_tbl_word0_ms_q[%0d:%0d]",1,0)});
         hqm_msix_mem.MSG_ADDR_L[i].MSG_ADDR_L.set_logical_path("HQMID");
         hqm_msix_mem.MSG_ADDR_L[i].RSVD.set_logical_path("HQMID");
       end else begin
         hqm_msix_mem.MSG_ADDR_L[i].MSG_ADDR_L.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_msix_tbl_word0.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][%0d:%0d]",i,31,2)});
         hqm_msix_mem.MSG_ADDR_L[i].RSVD.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_msix_tbl_word0.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][%0d:%0d]",i,1,0)});
         hqm_msix_mem.MSG_ADDR_L[i].MSG_ADDR_L.set_logical_path("HQMIDMEM");
         hqm_msix_mem.MSG_ADDR_L[i].RSVD.set_logical_path("HQMIDMEM");
       end
end

foreach (hqm_msix_mem.MSG_ADDR_U[i]) begin
      if (i == 64) begin
        hqm_msix_mem.MSG_ADDR_U[i].MSG_ADDR_U.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_tbl_word1_ms_q[%0d:%0d]",31,0)});
        hqm_msix_mem.MSG_ADDR_U[i].MSG_ADDR_U.set_logical_path("HQMID");
      end else begin
        hqm_msix_mem.MSG_ADDR_U[i].MSG_ADDR_U.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_msix_tbl_word1.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i)});
        hqm_msix_mem.MSG_ADDR_U[i].MSG_ADDR_U.set_logical_path("HQMIDMEM");
      end
end

foreach (hqm_msix_mem.MSG_DATA[i]) begin
      if (i == 64) begin
        hqm_msix_mem.MSG_DATA[i].MSG_DATA.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_tbl_word2_ms_q[%0d:%0d]",31,0)});
        hqm_msix_mem.MSG_DATA[i].MSG_DATA.set_logical_path("HQMID");
      end else begin
        hqm_msix_mem.MSG_DATA[i].MSG_DATA.set_paths({$psprintf("i_hqm_system_mem.i_hqm_system_mem_hqm_clk_rf_pg_cont.i_rf_msix_tbl_word2.i_rf.hqm_ip7413rfshpm1r1w64x34c1p1m5.ARRAY[%0d][31:0]",i)});
        hqm_msix_mem.MSG_DATA[i].MSG_DATA.set_logical_path("HQMIDMEM");
      end
end

