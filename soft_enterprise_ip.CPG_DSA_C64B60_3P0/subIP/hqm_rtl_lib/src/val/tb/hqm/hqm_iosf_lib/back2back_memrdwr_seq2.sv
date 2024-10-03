import pcie_seqlib_pkg::*;

//back to back mem64 read 
class back2back_memrdwr_seq2 extends hqm_sla_pcie_base_seq;//ovm_sequence;
  `ovm_sequence_utils(back2back_memrdwr_seq2,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_rqid_seq        mem_write_seq;

  function new(string name = "back2back_memrdwr_seq2");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       int attr_force_val1;
       sla_ral_addr_t addr1;
       bit [31:0]     data1;
       logic [9:0] ttagl;
       int unsupport_pkt_cnt;
      
       addr1[63:0] = ral.get_addr_val(primary_id, hqm_msix_mem_regs.MSG_DATA[0]);
       if(!$value$plusargs("ATTR_FORCE_VAL=%d", attr_force_val1))  attr_force_val1 = 0;
       if(!$value$plusargs("tag_opt=%d", ttagl)) ttagl = 0;
       if(!$value$plusargs("unsupport_pkt_cnt=%d", unsupport_pkt_cnt))  unsupport_pkt_cnt = 2;
           
       // mem wr with rand attr
       repeat(unsupport_pkt_cnt/2) begin
         data1 = $urandom();
         `ovm_do_on_with(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; iosf_data.size() == 1; iosf_data[0] == data1;attr_force_val==attr_force_val1; iosf_tagl==ttagl;})
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memwr with rand attr: addr=0x%08x wdata=0x%08x, ttagl=%0d",mem_write_seq.iosf_addr ,data1, ttagl),OVM_LOW)
         ttagl++;
       end

       // mem rd with rand attr
       repeat(unsupport_pkt_cnt/2) begin
         `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; attr_force_val==attr_force_val1; iosf_tagl==ttagl;})
         rdata = mem_read_seq.iosf_data;             
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd with rand attr: addr=0x%08x rdata=0x%08x, ttagl=%0d",mem_read_seq.iosf_addr ,rdata, ttagl),OVM_LOW)
         ttagl++;
       end

       pf_cfg_regs.VENDOR_ID.read(status,rd_val,primary_id,this);

       // mem wr normal
       data1 = $urandom();
       `ovm_do_on_with(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; iosf_data.size() == 1; iosf_data[0] == data1;attr_force_val==0;iosf_tagl==ttagl;})
       ttagl++;
       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memwr normal: addr=0x%08x wdata=0x%08x, ttagl=%d",mem_write_seq.iosf_addr ,data1, ttagl),OVM_LOW)

       // mem rd normal
       `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1;attr_force_val==0; iosf_tagl==ttagl;})
       ttagl++;
       rdata = mem_read_seq.iosf_data;             
       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd normal: addr=0x%08x rdata=0x%08x, ttagl=%d",mem_read_seq.iosf_addr ,rdata, ttagl),OVM_LOW)

  endtask : body

endclass : back2back_memrdwr_seq2
