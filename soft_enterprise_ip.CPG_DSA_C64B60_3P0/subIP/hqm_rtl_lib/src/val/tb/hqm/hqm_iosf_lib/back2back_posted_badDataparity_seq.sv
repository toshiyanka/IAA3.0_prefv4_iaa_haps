import lvm_common_pkg::*;

class back2back_posted_badDataparity_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_posted_badDataparity_seq,sla_sequencer)

  hqm_iosf_prim_mem_wr_badparity_seq         mem_write_seq;

  function new(string name = "back2back_posted_badDataparity_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]  rdata;
                           
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h004C_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",   'h0000_4000);    

    randomize(mem_addr);
                                        
    `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
    start_item(mem_write_seq);
    if(!mem_write_seq.randomize() with  {iosf_addr == mem_addr; iosf_data.size() == 1; m_driveBadCmdParity == 1'b0; m_driveBadDataParity == 1'b1; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 100;}) begin
      `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
    end  

    ReadReg("hqm_sif_csr", "ibcpl_hdr_fifo_ctl", SLA_FALSE, rdata);
    if(rdata != 32'h100)
      `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch for addr = 0x%0x, Read data is 0x%0x whereas expected data of 0x100", mem_addr, rdata))

    ReadReg("hqm_sif_csr", "ri_phdr_fifo_ctl", SLA_FALSE, rdata);
    if(rdata != 32'h0F)
      `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch for addr = 0x%0x, Read data is 0x%0x whereas expected data of 0x0F", mem_addr, rdata))

    finish_item(mem_write_seq);
                      
  endtask : body
endclass : back2back_posted_badDataparity_seq 
