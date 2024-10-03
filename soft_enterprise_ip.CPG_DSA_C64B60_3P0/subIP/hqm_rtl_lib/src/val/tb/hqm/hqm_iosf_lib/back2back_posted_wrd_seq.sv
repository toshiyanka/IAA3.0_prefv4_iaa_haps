import lvm_common_pkg::*;

class back2back_posted_wrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_posted_wrd_seq,sla_sequencer)
   
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq      mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq      mem_write_seq;

  function new(string name = "back2back_posted_wrd_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]  rdata;
    int         p_cnt; 
         
    `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

    start_item(mem_write_seq);
    if(!mem_write_seq.randomize() with  {iosf_addr == mem_addr0; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; }) begin
      `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
    end
    finish_item(mem_write_seq);

    `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

    start_item(mem_write_seq);
    if(!mem_write_seq.randomize() with  {iosf_addr == mem_addr1; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; }) begin
      `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
    end
    finish_item(mem_write_seq);

         
    `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
              
    start_item(mem_write_seq);
    if(!mem_write_seq.randomize() with  {iosf_addr == mem_addr2; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; }) begin
      `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
    end
    finish_item(mem_write_seq);

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr0;})
    rdata = mem_read_seq.iosf_data;

    if((rdata) != 'h1FF) begin
      `ovm_error("back2back_posted_wrd_seq",$psprintf("Read data (0x%08x) differs from expected data of 0x1FF",rdata))
    end else begin
      `ovm_info("back2back_posted_wrd_seq",$psprintf("Read data (0x%08x) matched successfully with expected data 0x1FF",rdata),OVM_LOW)
    end

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr1;})
    rdata = mem_read_seq.iosf_data;

    if((rdata) != 'h1F) begin
      `ovm_error("back2back_posted_wrd_seq",$psprintf("Read data (0x%08x) differs from expected data of 0x1F",rdata))
    end else begin
      `ovm_info("back2back_posted_wrd_seq",$psprintf("Read data (0x%08x) matched successfully with expected data 0x1F",rdata),OVM_LOW)
    end

    `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr2;})
    rdata = mem_read_seq.iosf_data;
                      
    if((rdata) != 'h3F) begin
      `ovm_error("back2back_posted_wrd_seq",$psprintf("Read data (0x%08x) differs from expected data of 0x3F",rdata))
    end else begin
      `ovm_info("back2back_posted_wrd_seq",$psprintf("Read data (0x%08x) matched successfully with expected data 0x3F",rdata),OVM_LOW)
    end

  endtask : body
endclass : back2back_posted_wrd_seq 
