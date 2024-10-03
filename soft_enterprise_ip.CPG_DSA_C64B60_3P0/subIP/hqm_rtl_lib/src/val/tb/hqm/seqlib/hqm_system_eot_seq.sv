import hqm_tb_cfg_pkg::*;

class hqm_system_eot_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_system_eot_seq, sla_sequencer)

    function new(string name = "hqm_system_eot_seq");
       super.new(name);
    endfunction

    virtual task body();
       cfg_cmds.push_back("rd hqm_system_csr.hcw_enq_fifo_status       0x00000010");
       cfg_cmds.push_back("rd hqm_system_csr.pptr_data_fifo_status     0x00000010");
       cfg_cmds.push_back("rd hqm_system_csr.dmv_wdata_fifo_status     0x00000010");
       cfg_cmds.push_back("rd hqm_system_csr.dmv_hcw_fifo_status       0x00000010");
       cfg_cmds.push_back("rd hqm_system_csr.sch_out_fifo_status       0x00000010");
       cfg_cmds.push_back("rd hqm_system_csr.cmpl_hdr_fifo_status      0x00000010");
       cfg_cmds.push_back("rd hqm_system_csr.cmpl_data_fifo_status     0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_nphdr_fifo_status      0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_phdr_fifo_status       0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_pdata_fifo_status      0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_ioq_fifo_status        0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_cmpl_fifo_status       0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_dataend_fifo_status    0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_pullend_fifo_status    0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_pullerr_fifo_status    0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_phdr_fifo_status       0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_pdata_fifo_status      0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_nphdr_fifo_status      0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_npdata_fifo_status     0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_cmplhdr_fifo_status    0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_cmpldata_fifo_status   0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_ioq_fifo_status        0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ri_tcq_fifo_status        0x00000010");
///--HQMV30_ATS_RM       cfg_cmds.push_back("#rd hqm_system_csr.pdata_rxq_fifo_status     0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.cpldata_rxq_fifo_status   0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.int_sig_num_fifo_status   0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.pend_signum_fifo_status   0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.csr_data_fifo_status      0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.phdr_rxq_fifo_status      0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.nphdr_rxq_fifo_status     0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.cplhdr_rxq_fifo_status    0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.ioq_rxq_fifo_status       0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.pcrd_fifo_status          0x00000010");
       cfg_cmds.push_back("#rd hqm_system_csr.npcrd_fifo_status         0x00000010");

       cfg_cmds.push_back("rd hqm_system_csr.alarm_db_status           0x00000000 0xfffbbbbb");
       cfg_cmds.push_back("rd hqm_system_csr.ingress_db_status         0x00000000 0xfffbbbbb");
       cfg_cmds.push_back("rd hqm_system_csr.egress_db_status          0x00000000 0xbbbbbbbb");
       cfg_cmds.push_back("rd hqm_system_csr.wbuf_db_status            0x00000000 0xfffffbbb");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_status              0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.ingress_status            0x00000000");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_misc_status            0x00000000");

       cfg_cmds.push_back("rd hqm_system_csr.alarm_lut_perr            0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.egress_lut_err            0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.ingress_lut_err           0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_err                 0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_sb_ecc_err          0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_mb_ecc_err          0x00000000");
       cfg_cmds.push_back("rd hqm_system_csr.ri_parity_err             0x00000000");
       cfg_cmds.push_back("#rd hqm_system_csr.ti_parity_err             0x00000000");

       cfg_cmds.push_back("rd hqm_system_csr.alarm_pf_synd0            0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[0]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[1]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[2]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[3]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[4]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[5]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[6]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[7]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[8]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[9]         0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[10]        0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[11]        0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[12]        0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[13]        0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[14]        0x00000000 0x80000000");
       cfg_cmds.push_back("rd hqm_system_csr.alarm_vf_synd0[15]        0x00000000 0x80000000");


       super.body();
    endtask

endclass
