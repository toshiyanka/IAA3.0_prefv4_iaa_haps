
class back2back_cfgrdwr_seq1 extends hqm_sla_pcie_base_seq;//ovm_sequence;
  `ovm_sequence_utils(back2back_cfgrdwr_seq1,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;

  function new(string name = "back2back_cfgrdwr_seq1");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       int attr_force_val1;
       sla_ral_addr_t addr1;
       bit [31:0]     data1;
       logic [9:0] ttagl;
       int unsupport_pkt_cnt;

       addr1[63:0] = ral.get_addr_val(primary_id, pf_cfg_regs.INT_LINE);

       if(!$value$plusargs("ATTR_FORCE_VAL=%d", attr_force_val1))  attr_force_val1 = 0;
       if(!$value$plusargs("tag_opt=%d", ttagl)) ttagl = 0;
       if(!$value$plusargs("unsupport_pkt_cnt=%d", unsupport_pkt_cnt))  unsupport_pkt_cnt = 2;
  
       // cfg Wr with rand attr variation
       repeat(unsupport_pkt_cnt/2) begin
          data1 = $urandom_range(1,15);
          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; iosf_data == data1;attr_force_val==attr_force_val1; iosf_tagl==ttagl;})
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x, ttagl=%0d",cfg_write_seq.iosf_addr ,data1, ttagl),OVM_LOW)
          ttagl++;
       end
   
       // cfg Rd with rand attr variation
       repeat(unsupport_pkt_cnt/2) begin
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; attr_force_val==attr_force_val1; iosf_tagl==ttagl;})
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x, ttagl=%d",cfg_read_seq.iosf_addr ,rdata, ttagl),OVM_LOW)
         ttagl++;
         rdata = cfg_read_seq.iosf_data;
       end
  
       pf_cfg_regs.VENDOR_ID.read(status,rd_val,primary_id,this);

       // cfg Wr normal
       data1 = $urandom_range(1,15);
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; iosf_data == data1; attr_force_val==0; iosf_tagl==ttagl;})
       ttagl++;
       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x, ttagl=%d",cfg_write_seq.iosf_addr ,data1, ttagl),OVM_LOW)

       // cfg Rd normal 
       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == addr1; attr_force_val==0; iosf_tagl==ttagl;})
       ttagl++;
       rdata = cfg_read_seq.iosf_data;
       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x, ttagl=%d",cfg_read_seq.iosf_addr ,rdata, ttagl),OVM_LOW)
    
  endtask : body
endclass : back2back_cfgrdwr_seq1
