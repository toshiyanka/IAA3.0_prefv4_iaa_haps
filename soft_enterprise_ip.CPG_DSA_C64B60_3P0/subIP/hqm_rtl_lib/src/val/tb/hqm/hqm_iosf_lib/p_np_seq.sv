import lvm_common_pkg::*;

class p_np_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(p_np_seq,sla_sequencer)

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq      mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq   mem_read_seq;

  function new(string name = "p_np_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]  rdata;
    int         p_cnt; 
                      
    p_cnt = 200;
    repeat(p_cnt+1) begin  
      randomize(mem_addr);
      `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
      start_item(mem_write_seq);

      if(!mem_write_seq.randomize() with  {iosf_addr == mem_addr; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; }) begin
        `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
      end
                             
      randomize(cfg_addr);
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
      rdata = cfg_read_seq.iosf_data;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                        
      finish_item(mem_write_seq);
    end

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0;})
    rdata = mem_read_seq.iosf_data;

    if((rdata) != 'h1FF) begin
      `ovm_error("p_np_seq",$psprintf("Read data (0x%08x) differs from expected data of 0x1FF",rdata))
    end else begin
      `ovm_info("p_np_seq",$psprintf("Read data (0x%08x) matched successfully with expected data 0x1FF",rdata),OVM_LOW)
    end

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr1;})
    rdata = mem_read_seq.iosf_data;

    if((rdata) != 'h1F) begin
      `ovm_error("p_np_seq",$psprintf("Read data (0x%08x) differs from expected data of 0x1F",rdata))
    end else begin
      `ovm_info("p_np_seq",$psprintf("Read data (0x%08x) matched successfully with expected data 0x1F",rdata),OVM_LOW)
    end

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr2;})
    rdata = mem_read_seq.iosf_data;
                      
    if((rdata) != 'h3F) begin
      `ovm_error("p_np_seq",$psprintf("Read data (0x%08x) differs from expected data of 0x3F",rdata))
    end else begin
      `ovm_info("p_np_seq",$psprintf("Read data (0x%08x) matched successfully with expected data 0x3F",rdata),OVM_LOW)
    end

  endtask : body
endclass : p_np_seq
