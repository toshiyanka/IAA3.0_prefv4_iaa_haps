import lvm_common_pkg::*;


class mem_generic_seq extends ovm_sequence;
  `ovm_sequence_utils(mem_generic_seq,sla_sequencer)

  string           mode = "";
  Iosf::data_t     iosf_data_l[];

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq      mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq      mem_write_seq;

  function new(string name = "hqm_MEM_SEQ");
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
        mem_packet pkt ;
        pkt = mem_packet::type_id::create("pkt");
                


                           
              
             
   //----------------------******WRWR random address*****----------------------------//
               // `ifdef WRWR_rand
               if (mode == "WRWR_rand") begin  
                             
            repeat(15)
              begin
                pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);
                assert(pkt.randomize());
                iosf_data_l = new[1];
                iosf_data_l[0] = $urandom_range(31,1);
                `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]};})
                `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
                `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
                rdata = mem_read_seq.iosf_data;
                `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
                if (rdata != iosf_data_l[0]) begin 
                   `ovm_error("mem_generic_seq",$psprintf("address 0x%0x read data (0x%08x) does not match expected data (0x%08x)",pkt.mem_addr,rdata,iosf_data_l[0]))
                end 
               end
             end  
             //  `endif             

     
     //-----------------------*******WWWWWR_diff data on same address***********------------------------------------//
             // `ifdef WWWR_addr
                  if (mode == "WWWR_addr") begin  
                    repeat(16)begin   
                     repeat(3) begin
                pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);
                assert(pkt.randomize());

                  repeat(10)
              begin
     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]};})
     `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
                     end 
      `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
       rdata = mem_read_seq.iosf_data[0];
      `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
       if(rdata != iosf_data_l[0]) begin 
         `ovm_error("mem_generic_seq",$psprintf("address 0x%0x read data (0x%08x) does not match expected data (0x%08x)",pkt.mem_addr,rdata,iosf_data_l[0]))
       end 

                   end
                 end 
               end 
               //`endif
                   
      //------------------------******WRRRRRR on same address**************------------------------------------//
                     //`ifdef WRRR_addr
                 if (mode == "WRRR_addr") begin  
                   repeat(16)begin
                       repeat(3) begin
                         pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);

                assert(pkt.randomize());

     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]};})
      `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
   
            repeat(10)
                       begin
          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
                rdata = mem_read_seq.iosf_data[0];
          `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end
       if(rdata != iosf_data_l[0]) begin 
         `ovm_error("mem_generic_seq",$psprintf("address 0x%0x read data (0x%08x) does not match expected data (0x%08x)",pkt.mem_addr,rdata,iosf_data_l[0]))
       end 

                        end
                      end
                    end 
                       // `endif 
                       
      //--------------------------------------------------------------------------------------------------------------------------//                    
          //`ifdef WWRR_addr
          
          if (mode == "WWRR_addr") begin  
       repeat(16)begin
          repeat(3) begin
               pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);

                 assert(pkt.randomize());
  
             repeat(1)
              begin
     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; foreach(iosf_data_l[i]) {iosf_data[i]==iosf_data_l[i]};})
     `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
                     end 

            repeat(2)
                       begin
          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
                rdata = mem_read_seq.iosf_data[0];
          `ovm_info("MEM_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end
                     repeat(1)
              begin
     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; })
     `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
                     end 
             end
           end  
     end  
      //-------------------------------------------------------------------------------------------------------------------------------------//               


                       // `endif 
           

   


//run_time_until_idle (400000000);

      
  endtask : body
endclass : mem_generic_seq
