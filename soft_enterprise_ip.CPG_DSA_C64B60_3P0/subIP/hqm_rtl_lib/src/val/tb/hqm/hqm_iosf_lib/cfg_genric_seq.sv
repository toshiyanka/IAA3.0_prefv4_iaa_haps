import lvm_common_pkg::*;


class cfg_genric_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(cfg_genric_seq,sla_sequencer)

  string        mode = "";
  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;

  rand bit [63:0]               i_cfg_addr;
  bit [63:0]                    i_cfg_addr0, i_cfg_addr1, i_cfg_addr2;
  constraint select_cfg_address {
    i_cfg_addr dist {i_cfg_addr0:/35, i_cfg_addr1:/35, i_cfg_addr2:/30};  
  }


  function new(string name = "hqm_CFG_SEQ");
    super.new(name);
     $value$plusargs("CFG_MODE=%s",mode);

     if(mode == "") begin
       `ovm_info("CFG_MODE","+CFG_MODE=<file name> not set",OVM_LOW)
     end else begin
       `ovm_info("CFG_MODE",$psprintf("+CFG_MODE=%s",mode),OVM_LOW)
     end
    i_cfg_addr0 = get_reg_addr("hqm_pf_cfg_i", "cache_line_size",  "primary");
    i_cfg_addr1 = get_reg_addr("hqm_pf_cfg_i", "int_line",  "primary");
    i_cfg_addr2 = get_reg_addr("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  "primary");

  endfunction

  virtual task body();
    bit [31:0]          rdata;

    if(mode == "RRWWRR") begin  
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
              
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr1;})
  
      `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hFF;})
      `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)

      `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr1; iosf_data == 32'hFFFFFFFF;})
      `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)

      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
      rdata = cfg_read_seq.iosf_data;

      if((rdata) != 32'hFF) begin
        `ovm_error("cfg_genric_seq",$psprintf(" address of CACHE LINE SIZE register  read data (0x%08x) does not match expected data (32'hFF)",rdata))
      end 
              
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr1;})
      rdata = cfg_read_seq.iosf_data;

      if((rdata) != 32'hFF) begin
        `ovm_error("cfg_genric_seq",$psprintf(" address of FUNC BAR_L read data (0x%08x) does not match expected data (32'hFF)",rdata))
      end 
    end

   if(mode == "WRWR_rand") begin  
     repeat(2) begin
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
           
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hFF;})
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
     
       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hFF;})
       rdata = cfg_read_seq.iosf_data;
       `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
             
       if((rdata) != 32'h00000FF) begin
         `ovm_error("IOSF_RQID_SEQ",$psprintf("Read data (0x%08x) from CACHE_LINE_SIZE register does not match write data (0xFF)",rdata))
       end else begin
         `ovm_info("IOSF_RQID_SEQ",$psprintf(" Read data matched with expected data"),OVM_LOW)
       end
     end
   end
     
   if(mode == "WWWR_addr") begin  
     repeat(10) begin
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hFF;})
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
     end 
     `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
     rdata = cfg_read_seq.iosf_data;
     `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
     if((rdata) != 32'h00000FF) begin
       `ovm_error("IOSF_RQID_SEQ",$psprintf("CACHE_LINE_SIZE read data (0x%08x) does not match write data 0xFF",rdata))
     end else begin
       `ovm_info("IOSF_RQID_SEQ",$psprintf(" CACHE_LINE_SIZE read data (0x%08x) matches expected value 0xFF",rdata),OVM_LOW)
     end
   end

   if(mode == "WRRR_addr") begin  
     repeat(3) begin
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hFF;})
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
   
       repeat(10) begin
         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
         rdata = cfg_read_seq.iosf_data;
         `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
       end
     end
   end
          
   if(mode == "WWRR_addr") begin  
     repeat(3) begin 
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hAA;})
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
     end 

     repeat(2) begin
       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0;})
       rdata = cfg_read_seq.iosf_data;
       `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)

       if((rdata) != 32'h00000AA) begin
         `ovm_error("IOSF_RQID_SEQ",$psprintf(" CACHE_LINE_SIZE read data (0x%08x) does not match write data (0xAA)",rdata))
       end else begin
         `ovm_info("IOSF_RQID_SEQ",$psprintf(" CACHE_LINE_SIZE read data (0x%08x) matches expected value 0xAA",rdata),OVM_LOW)
       end
     end

     repeat(1) begin
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == i_cfg_addr0; iosf_data == 32'hFF;})
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
     end 
   end
  endtask : body
endclass : cfg_genric_seq
