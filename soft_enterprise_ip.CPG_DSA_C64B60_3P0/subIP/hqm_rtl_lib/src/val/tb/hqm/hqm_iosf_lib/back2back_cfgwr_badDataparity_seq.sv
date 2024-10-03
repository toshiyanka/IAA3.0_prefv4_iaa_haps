import lvm_common_pkg::*;

class back2back_cfgwr_badDataparity_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_cfgwr_badDataparity_seq,sla_sequencer)
   
  hqm_iosf_prim_cfg_wr_badparity_seq        cfg_write_badparity_seq;

  constraint select_cfg_address {
    cfg_addr dist {cfg_addr0:/50, cfg_addr1:/50};  
  }

  function new(string name = "back2back_cfgwr_badDataparity_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]      rdata;
    int             np_cnt ; 
    np_cnt = 5 ;
        
    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    

    repeat(np_cnt+1) begin
      randomize(cfg_addr);
       
      `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr; iosf_data == 32'hFFFF_FFFF; m_driveBadCmdParity == 1'b0;
      m_driveBadDataParity == 1'b1; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 100;})
        
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0xFFFF_FFFF",cfg_write_badparity_seq.iosf_addr),OVM_LOW)
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: driiveBadDataparity=1, driveBadDataParityCycle=0   driveBadDataParitypct=100"),OVM_LOW)

     end

    ReadReg("hqm_pf_cfg_i", "device_status", SLA_FALSE, rdata);    
    if(rdata != 32'h8010)
      `ovm_error("Read data mistmatch_received",$psprintf(" read data 0x%0x does not match expected data of 0x8010",rdata))

    ReadReg("hqm_pf_cfg_i", "func_bar_l", SLA_FALSE, rdata);    
    if(rdata != 8'h0C)
      `ovm_error("Read data mistmatch_received",$psprintf(" read data 0x%0x does not match expected data of 0xC",rdata))

    ReadReg("hqm_pf_cfg_i", "func_bar_u", SLA_FALSE, rdata);    
    if(rdata != 8'h01)
      `ovm_error("Read data mistmatch_received",$psprintf(" read data 0x%0x does not match expected data of 0x1",rdata))
    ReadReg("hqm_pf_cfg_i", "csr_bar_l",  SLA_FALSE, rdata);    
    if(rdata != 8'h0C)
      `ovm_error("Read data mistmatch_received",$psprintf(" read data 0x%0x does not match expected data of 0xC",rdata))
    ReadReg("hqm_pf_cfg_i", "csr_bar_u",  SLA_FALSE, rdata);    
    if(rdata != 8'h02)
      `ovm_error("Read data mistmatch_received",$psprintf(" read data 0x%0x does not match expected data of 0x2",rdata))
    
  endtask : body
endclass : back2back_cfgwr_badDataparity_seq
