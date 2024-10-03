import lvm_common_pkg::*;


class cfg_genric_parallel_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(cfg_genric_parallel_seq,sla_sequencer)

  string        mode = "";

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;

  function new(string name = "hqm_CFG_SEQ");
    super.new(name);
    $value$plusargs("CFG_MODE=%s",mode);

    if (mode == "") begin
      `ovm_info("CFG_MODE","+CFG_MODE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("CFG_MODE",$psprintf("+CFG_MODE=%s",mode),OVM_LOW)
    end
  endfunction

  virtual task body();
    bit [31:0]          rdata;

    if(mode == "WRWR_rand") begin  
      repeat(10) begin
        randomize(cfg_addr);
        repeat(2)
          fork
            `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
            `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
            `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
            rdata = cfg_read_seq.iosf_data;
            `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
          join
       end
     end  
     
     if(mode == "WWWR_addr") begin  
       repeat(6) begin
         randomize(cfg_addr);
         fork     
           `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
           `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
         join
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
         rdata = cfg_read_seq.iosf_data;
         `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
        end
      end             

      if(mode == "WRRR_addr") begin  
        repeat(10) begin
          randomize(cfg_addr);
          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
          `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
   
          repeat(3)
            fork
              `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
              rdata = cfg_read_seq.iosf_data;
              `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
            join          
        end
      end
          
      if(mode == "WWRR_addr") begin  
        repeat(5) begin
          randomize(cfg_addr);
          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
          `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)

            repeat(2)
              fork
                `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
                `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
              join
              `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == cfg_addr;})
              `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
        end
      end  
      
  endtask : body
endclass : cfg_genric_parallel_seq
