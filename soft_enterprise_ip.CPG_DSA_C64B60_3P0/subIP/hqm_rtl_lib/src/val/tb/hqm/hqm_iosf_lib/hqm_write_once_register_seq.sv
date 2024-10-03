import lvm_common_pkg::*;

class hqm_write_once_register_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_write_once_register_seq,sla_sequencer)
   
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq      mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq   mem_read_seq;

  function new(string name = "hqm_write_once_register_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]          rdata;

    mem_addr0 = get_reg_addr("config_master", "cfg_pm_pmcsr_disable", "primary");

    //==============================================================================//
    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0; iosf_data.size() == 1; iosf_data[0]==1;})      

    #100ns; 

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0;})
    rdata = mem_read_seq.iosf_data;
    `ovm_info("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("MEMRD: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

    if(rdata == 'h0)
      `ovm_error("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("Read data (0x%08x) differs from expected data 0x1",rdata))


    //==============================================================================//

    #100ns; 

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0; iosf_data.size() == 1; iosf_data[0]==0;})      

    #100ns; 

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0;})
    rdata = mem_read_seq.iosf_data;
    `ovm_info("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("MEMRD: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
    if(rdata == 'h1)
      `ovm_error("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("Read data (0x%08x) differs from expected data 0x0",rdata))


    //==============================================================================//

    #100ns; 

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0; iosf_data.size() == 1; iosf_data[0]==1;})      


    #100ns; 

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0;})
    rdata = mem_read_seq.iosf_data;
    `ovm_info("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("MEMRD: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
    if(rdata == 'h1)
      `ovm_error("HQM_WRITE_ONCE_REGISTER_SEQ",$psprintf("Read data (0x%08x) differs from expected data 0x0",rdata))
    //==============================================================================//

  endtask
endclass
