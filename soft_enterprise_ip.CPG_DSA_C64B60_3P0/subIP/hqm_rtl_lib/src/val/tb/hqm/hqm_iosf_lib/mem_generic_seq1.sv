import lvm_common_pkg::*;


class mem_generic_seq1 extends hqm_iosf_base_seq;
  `ovm_sequence_utils(mem_generic_seq1,sla_sequencer)

  string                mode = "";
  bit [63:0]            addr;
  rand bit [31:0]       wdata[200];
  bit      [63:0]       mem_addr3, mem_addr4, mem_addr5;
  rand bit [63:0]       mem_addr;

  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  pcie_seqlib_pkg::order_seq                            order_check_seq;


  constraint select_mem_address{
    mem_addr dist {mem_addr2:/50, mem_addr3:/50};  
  }

  
  function new(string name = "hqm_MEM_SEQ");
    super.new(name);
     $value$plusargs("CFG_MODE=%s",mode);

     if(mode == "") begin
       `ovm_info("CFG_MODE","+CFG_MODE=<file name> not set",OVM_LOW)
     end else begin
       `ovm_info("CFG_MODE",$psprintf("+CFG_MODE=%s",mode),OVM_LOW)
     end


    mem_addr3 = get_reg_addr("hqm_sif_csr", "ri_nphdr_fifo_ctl",  "primary");
    //mem_addr4 = get_reg_addr("hqm_sif_csr", "ti_pdata_fifo_ctl", "primary");
    //mem_addr5 = get_reg_addr("hqm_sif_csr", "ti_ioq_fifo_ctl",   "primary");


  endfunction

  virtual task body();
    bit [31:0]          rdata;
    bit [31:0]          final_wdata;
      
    if(mode == "WRWR_rand") begin  
      for(int i=0;i<=50;i++)begin
        randomize(mem_addr);
        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1;iosf_data[0] == wdata[i]; })
        `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
        rdata = mem_read_seq.iosf_data[0];
        `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
        final_wdata = wdata[i];                  
      end

      repeat(100) begin
        randomize(mem_addr);
        `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1;iosf_data[0] == final_wdata; })
        `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
      end

      `ovm_do_on_with(order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("order_check_seq_sent "),OVM_LOW)
    end  

      if(mode == "WWWR_addr") begin  
        repeat(16)begin   
          randomize(mem_addr);
          for(int i=0; i<=50;i++) begin
            `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1;iosf_data[0] == wdata[i]; })
            `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
            final_wdata = wdata[i];
          end
                     
          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
          rdata = mem_read_seq.iosf_data[0];
          `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
        end

        for(int i=0; i<=100;i++) begin
          randomize(mem_addr);
          `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1;iosf_data[0] == final_wdata; })
          `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
        end

        `ovm_do_on_with(order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
                
        `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("order_check_seq_sent "),OVM_LOW)

      end  
                        
      if(mode == "WRRR_addr") begin  
        for(int i=0;i<=56;i++)begin
          final_wdata = wdata[i];
          repeat(100) begin //wait till write all register

            `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1; iosf_data[0] == final_wdata;  })
            `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
          end
   
          repeat(10) begin
            `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
            rdata = mem_read_seq.iosf_data[0];
            `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
          end
                       
          `ovm_do_on_with(order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("order_check_seq_sent"),OVM_LOW)

        end 
      end 
          
      if(mode == "WWRR_addr") begin  
        for(int i=0;i<=56;i++)begin
          randomize(mem_addr);
          repeat(1) begin
            `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1; iosf_data[0] == wdata[i]; })
            `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
          end 

          repeat(2) begin
            `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;})
            rdata = mem_read_seq.iosf_data[0];
            `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
          end
          repeat(1) begin
            `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr; iosf_data.size() == 1;iosf_data[0] == wdata[i]; })
            `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
          end 

          final_wdata = wdata[16];
        end
             
        for(int i=0; i<=100;i++) begin
          randomize(mem_addr); 
            repeat(2) begin
              `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == mem_addr;iosf_data.size() == 1;iosf_data[0] == final_wdata; })
            end 
            `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
         end

         `ovm_do_on_with(order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("order_check_seq_sent"),OVM_LOW)
  
       end  
  endtask : body
endclass : mem_generic_seq1
