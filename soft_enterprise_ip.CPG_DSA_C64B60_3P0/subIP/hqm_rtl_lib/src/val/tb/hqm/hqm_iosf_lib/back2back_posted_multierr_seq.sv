import lvm_common_pkg::*;

class back2back_posted_multierr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_posted_multierr_seq,sla_sequencer)

  hqm_iosf_prim_mem_wr_poison_seq     mem_write_seq;
  hqm_iosf_prim_mem_wr_badparity_seq  mem_write_seq1;

  function new(string name = "back2back_posted_multierr_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]      rdata;
    int             p_cnt; 
        
    p_cnt = 5;  
                           
    WriteReg("hqm_pf_cfg_i", "pcie_cap_device_control",  'h291F);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",   'h0044_1000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",   'h0000_4000);    

    WriteReg("hqm_pf_cfg_i", "device_command",  'h46);

    //#-------Mode0 for unspported DW width--------# 
    if($test$plusargs("MODE0"))begin
       repeat(p_cnt+1) begin   
         randomize(mem_addr);
                                          
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
        start_item(mem_write_seq);
        if(!mem_write_seq.randomize() with  {iosf_addr == mem_addr; iosf_data.size() == 8;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
        finish_item(mem_write_seq);
      end
    end


    if($test$plusargs("MODE1"))begin
      repeat(p_cnt+1) begin   
        randomize(mem_addr);
                                          
        `ovm_create_on(mem_write_seq1,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

        start_item(mem_write_seq1);

        if(!mem_write_seq1.randomize() with  {iosf_addr == mem_addr; iosf_data.size() == 8; m_driveBadCmdParity == 0; m_driveBadDataParity == 1; m_driveBadDataParityCycle == 0; m_driveBadDataParityPct == 100;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
 
        finish_item(mem_write_seq1);
      end

      ReadReg("hqm_pf_cfg_i", "pcie_cap_device_status", SLA_FALSE, rdata);
      if(rdata != 32'h0A)
        `ovm_error("Read data mistmatch_received",$psprintf("read data mismatch, Read data is 0x%0x whereas expected data of 0x0A",rdata))

    end
  endtask : body
endclass : back2back_posted_multierr_seq 
