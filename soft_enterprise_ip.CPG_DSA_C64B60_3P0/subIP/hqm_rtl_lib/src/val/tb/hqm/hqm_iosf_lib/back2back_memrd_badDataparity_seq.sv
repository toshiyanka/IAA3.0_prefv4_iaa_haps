import lvm_common_pkg::*;

class back2back_memrd_badDataParity_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_memrd_badDataParity_seq ,sla_sequencer)

  hqm_iosf_prim_mem_rd_badparity_seq        mem_read_seq;

  function new(string name = "back2back_badDataParity_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]          rdata;
    bit [31:0]          rdata_new[8];
    int                 np_cnt; 
    
    mem_errcheck_packet pkt ;
    np_cnt = 16 ;
        
    WriteReg("hqm_pf_cfg_i", "pcie_cap_device_control",  'h291F);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",   'h0000_4000);    

    WriteReg("hqm_pf_cfg_i", "device_command",  'h46);

    repeat(np_cnt+1) begin
      randomize(mem_addr);
      `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;m_driveBadCmdParity == 0; m_driveBadDataParity == 1; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 100;})
      rdata = mem_read_seq.iosf_data;

      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
    end 
     
    ReadReg("hqm_sif_csr", "ibcpl_hdr_fifo_ctl", SLA_FALSE, rdata);
    if(rdata != 32'h100)
      `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch , Read data is 0x%0x whereas expected data of 0x100", rdata))

    ReadReg("hqm_sif_csr", "ri_phdr_fifo_ctl", SLA_FALSE, rdata);
    if(rdata != 32'h0F)
      `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch , Read data is 0x%0x whereas expected data of 0x0F", rdata))

    ReadReg("hqm_sif_csr", "ri_pdata_fifo_ctl", SLA_FALSE, rdata);
    if(rdata != 32'h1F)
      `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch, Read data is 0x%0x whereas expected data of 0x1F", rdata))

  endtask : body
endclass : back2back_memrd_badDataParity_seq
