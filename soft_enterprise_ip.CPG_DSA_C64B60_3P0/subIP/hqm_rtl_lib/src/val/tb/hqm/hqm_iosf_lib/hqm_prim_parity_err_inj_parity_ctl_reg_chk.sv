import lvm_common_pkg::*;

class hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq ,sla_sequencer)

  hqm_iosf_prim_cfg_wr_badparity_seq    cfg_write_badparity_seq;
  hqm_reset_init_sequence               warm_reset;
  hqm_iosf_prim_cfg_rd_badparity_seq    cfg_read_badparity_seq;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_sla_pcie_init_seq                 pcie_init;

  function new(string name = "hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq");
    super.new(name); 
    ral_access_path = iosf_sb_sla_pkg::get_src_type();
  endfunction

  virtual task body();
    bit [31:0] rdata;
      
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    

    if($test$plusargs("IOSFP_PAR_OFF"))begin 
       WriteReg("hqm_sif_csr", "parity_ctl", 'h0000_0001);    
    end   

    if($test$plusargs("TI_PAR_OFF"))begin 
       WriteReg("hqm_sif_csr", "parity_ctl", 'h0000_0002);    
    end   

    if($test$plusargs("RI_PAR_OFF"))begin 
       WriteReg("hqm_sif_csr", "parity_ctl", 'h0000_0004);    
    end   

    if($test$plusargs("INJ_IOSF_MDPERR"))begin 
       WriteReg("hqm_sif_csr", "parity_ctl", 'h0000_0010);    
    end   

    if($test$plusargs("INJ_IOSF_MCPERR"))begin 
       WriteReg("hqm_sif_csr", "parity_ctl", 'h0000_0008);    
    end   

    if($test$plusargs("INJ_IOSF_MDPERR") || $test$plusargs("INJ_IOSF_MCPERR")  )begin 

      repeat(5) begin
        randomize(cfg_addr);
        `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
      end

     ReadField("hqm_pf_cfg_i", "aer_cap_uncorr_err_status", "ecrcc", SLA_FALSE, rdata);

     if(rdata == 'h1)
        `ovm_error("hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq",$psprintf("Read data 0x%0x does not match expected  data 0x0",rdata))

    end else begin

    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr0; iosf_data == 32'h0; m_driveBadCmdParity == 1;
    m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
        
    `ovm_info("hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq",$psprintf("cfgwr0: addr=0x%08x wdata=0x0",cfg_write_badparity_seq.iosf_addr),OVM_LOW)

    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr1; iosf_data == 32'h01; m_driveBadCmdParity == 1;
       m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
        
    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x01",cfg_write_badparity_seq.iosf_addr),OVM_LOW)
                                    
    `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr; iosf_data == 32'hAA; m_driveBadCmdParity == 1;
       m_driveBadDataParity == 0; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 0;})
        
    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x0",cfg_write_badparity_seq.iosf_addr),OVM_LOW)

    ReadField("hqm_pf_cfg_i", "aer_cap_uncorr_err_status", "ecrcc", SLA_FALSE, rdata);
     if(rdata == 'h1 && $test$plusargs("IOSFP_PAR_OFF"))
       `ovm_error("hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq",$psprintf("Read data 0x%0x does not match expected  data 0x0",rdata))
     else if (rdata == 'h0 && ($test$plusargs("TI_PAR_OFF") ||  $test$plusargs("TI_PAR_OFF"))) 
       `ovm_error("hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq",$psprintf("Read data 0x%0x does not match expected data 0x1",rdata))


    `ovm_do(warm_reset) 
    `ovm_do(pcie_init);
    `ovm_info(get_type_name(),"Completed pcie_init", OVM_LOW);

  end

  endtask : body
endclass : hqm_prim_parity_err_inj_parity_ctl_reg_chk_seq
