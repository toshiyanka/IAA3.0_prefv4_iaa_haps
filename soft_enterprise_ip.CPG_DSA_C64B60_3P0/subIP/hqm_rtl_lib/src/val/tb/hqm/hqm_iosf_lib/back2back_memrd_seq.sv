import lvm_common_pkg::*;

class back2back_memrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_memrd_seq,sla_sequencer)
   
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_rqid_seq      mem_rqid_seq;

  function new(string name = "back2back_memrd_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]    rdata;
    int           np_cnt; 
      
    if($test$plusargs("WRITE_ONCE_REGISTER_CHECK"))begin        

      mem_addr0 = get_reg_addr("config_master", "cfg_pm_pmcsr_disable", "primary");
      `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0;})
      rdata = mem_read_seq.iosf_data;
      `ovm_info("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("MEMRD: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
      if(rdata == 'h1)
        `ovm_error("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("Read data (0x%08x) differs from expected data 0x0",rdata))
    end else begin     
      np_cnt = 16 ;
      repeat(np_cnt+1) begin
        randomize(mem_addr);

        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
        rdata = mem_read_seq.iosf_data;
        `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
      end

      if($test$plusargs("RQID_TXN"))begin        
        repeat(np_cnt+1) begin
          randomize(mem_addr);
          `ovm_do_on_with(mem_rqid_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
          rdata = mem_rqid_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_rqid_seq.iosf_addr ,rdata),OVM_LOW)
        end
      end
    end  
    
  endtask : body
endclass : back2back_memrd_seq
