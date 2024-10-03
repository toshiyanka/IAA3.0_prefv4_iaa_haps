import lvm_common_pkg::*;

class back2back_cfgwr_badtxn_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_cfgwr_badtxn_seq,sla_sequencer)

  hqm_iosf_prim_cfg_wr_badtxn_seq        cfg_write_seq;

  function new(string name = "back2back_cfgwr_badtxn_seq");
    super.new(name); 
  endfunction

  virtual task body();

    bit [31:0] rdata;

    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h0);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h1);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l",  'h0);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u",  'h2);    

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    

    `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr0; iosf_data == 32'hFF;})
         
    `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0xFF",cfg_write_seq.iosf_addr),OVM_LOW)
 
    ReadReg("hqm_pf_cfg_i", "cache_line_size", SLA_FALSE, rdata);
    if(rdata != 32'hFF)
      `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch for addr = 0x%0x, Read data is 0x%0x whereas expected data of 0xFF",cfg_addr0, rdata))
  endtask : body
endclass : back2back_cfgwr_badtxn_seq
