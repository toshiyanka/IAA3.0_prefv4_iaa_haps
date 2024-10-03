import lvm_common_pkg::*;


class back2back_cfgwr_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(back2back_cfgwr_seq,sla_sequencer)
   
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_rqid_seq        cfg_read_rqid_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq             cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_rqid_seq        cfg_write_rqid_seq;

  function new(string name = "back2back_cfgwr_seq");
    super.new(name); 
  endfunction

  virtual task body();
    bit [31:0]     rdata;
    int            np_cnt; 
    int            wdata; 
          
    np_cnt = 36 ;
    wdata  = $urandom();

    repeat(np_cnt+1) begin
      randomize(cfg_addr);
      `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr; iosf_data == 32'hFF;})
         
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr, wdata),OVM_LOW)
    end

    if($test$plusargs("RQID_TXN"))begin        
      repeat(np_cnt+1) begin

       `ovm_do_on_with(cfg_write_rqid_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr0; iosf_data == wdata;})
         
       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_rqid_seq.iosf_addr ,wdata),OVM_LOW)

       //Read back
       `ovm_do_on_with(cfg_read_rqid_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr0;})
       rdata = cfg_read_rqid_seq.iosf_data;

       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=3c rdata=0x%08x",rdata),OVM_LOW)

       //added check
       if((rdata) != wdata[7:0]) begin
         `ovm_error("IOSF_RQID_SEQ",$psprintf("Read data (0x%08x) from register CACHE_LINE_SIZE does not match write data 0x%0x",rdata, wdata))
       end else begin
         `ovm_info("IOSF_RQID_SEQ",$psprintf("Read data (0x%08x) from register CACHE_LINE_SIZE matches expected value 0x%0x",rdata, wdata),OVM_LOW)
       end
     end
   end //testarg end
  endtask : body
endclass : back2back_cfgwr_seq
