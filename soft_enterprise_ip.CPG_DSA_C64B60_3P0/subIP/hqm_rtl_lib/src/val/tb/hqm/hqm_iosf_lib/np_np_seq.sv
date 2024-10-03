import lvm_common_pkg::*;

class np_np_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(np_np_seq,sla_sequencer)

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq   mem_read_seq;

  function new(string name = "np_np_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]    rdata;
    int           np_cnt ; 
    
    np_cnt = 16 ;
    repeat(np_cnt+1) begin
      randomize(cfg_addr);
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
      rdata = cfg_read_seq.iosf_data;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                
      randomize(mem_addr);
      `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
      rdata = mem_read_seq.iosf_data;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
    end 
    
  endtask : body
endclass : np_np_seq
