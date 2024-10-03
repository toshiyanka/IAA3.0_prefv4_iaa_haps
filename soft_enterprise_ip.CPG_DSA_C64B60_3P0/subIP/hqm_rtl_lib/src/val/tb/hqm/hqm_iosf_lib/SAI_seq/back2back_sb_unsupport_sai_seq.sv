import lvm_common_pkg::*;

class back2back_sb_unsupport_sai_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_sb_unsupport_sai_seq,sla_sequencer)
   
  hqm_iosf_sb_UR_sai_seq        cfg_read_seq;

  function new(string name = "back2back_sb_unsupport_sai_seq");
    super.new(name); 
  endfunction

  virtual task body();
    sla_ral_data_t        rd_data;
                
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);

    WriteReg("hqm_sif_csr", "hqm_csr_cp_lo",      'hFFFF_FFFF);
    WriteReg("hqm_sif_csr", "hqm_csr_cp_hi",      'hFFFF_FFFF);
    ReadReg("hqm_sif_csr",  "hqm_csr_cp_lo",  SLA_FALSE,  rd_data);
    if(rd_data != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rd_data))
    ReadReg("hqm_sif_csr",  "hqm_csr_cp_hi",  SLA_FALSE,  rd_data);
    if(rd_data != 'hFFFF_FFFF)
      `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0xFFFF_FFFF",rd_data))

    //WriteReg("hqm_sif_csr", "hqm_csr_rac_lo",     'h0);
    //WriteReg("hqm_sif_csr", "hqm_csr_rac_hi",     'h0);
    //ReadReg("hqm_sif_csr",  "hqm_csr_rac_lo"  ,SLA_FALSE, rd_data);
    //if(rd_data != 'h0)
    //  `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0x0",rd_data))
    //ReadReg("hqm_sif_csr",  "hqm_csr_rac_hi"  ,SLA_FALSE, rd_data);
    //if(rd_data != 'h0)
    //  `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0x0",rd_data))

    //WriteReg("hqm_sif_csr", "hqm_csr_wac_lo",     'h0);
    //WriteReg("hqm_sif_csr", "hqm_csr_wac_hi",     'h0);
    //ReadReg("hqm_sif_csr",  "hqm_csr_wac_lo"  ,SLA_FALSE, rd_data);
    //if(rd_data != 'h0)
    //  `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0x0",rd_data))
    //ReadReg("hqm_sif_csr",  "hqm_csr_wac_hi"  ,SLA_FALSE, rd_data);
    //if(rd_data != 'h0)
    //  `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0x0",rd_data))

    for(int i=0; i<10;i++)begin
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'h0;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'h1;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'h2;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'h3;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'h6;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'h8;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'hf;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'haa;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'hbb;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'hcc;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'hdd;})
      `ovm_do_with(cfg_read_seq, {Iosf_sai == 8'hff;})
    end

   #15000;
   #10000;
     
  endtask : body
endclass : back2back_sb_unsupport_sai_seq
