import lvm_common_pkg::*;


class mix_generic_seq extends ovm_sequence;
  `ovm_sequence_utils(mix_generic_seq,sla_sequencer)
   

  string        mode = "";
 

  integer       fd;
  integer       timeoutval;
  int cfg_int;
  bit [63:0]  addr;
   

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

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
        mix_packet pkt ;
        pkt = mix_packet::type_id::create("pkt");
                


                           
              
             
   //----------------------******WRWR random address*****----------------------------//
               // `ifdef WRWR_rand
               if (mode == "WRWR_rand") begin  
                             
                repeat(15)
              begin
                pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);
                pkt.default_cfgrd.constraint_mode(1);
                     assert(pkt.randomize());
     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; })
     `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
     `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
           rdata = cfg_read_seq.iosf_data;
      `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)

                 
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
                pkt.default_cfgrd.constraint_mode(1);

                assert(pkt.randomize());

                  repeat(10)
              begin
     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; })
     `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
                     end 
      `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
       rdata = cfg_read_seq.iosf_data;
      `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
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
                pkt.default_cfgrd.constraint_mode(1);

                

                assert(pkt.randomize());

      `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; })
      `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
   
            repeat(10)
                       begin
                                                 
          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
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
                pkt.default_cfgrd.constraint_mode(1);


                 assert(pkt.randomize());
  
             repeat(1)
              begin
     `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;iosf_data.size() == 1; })
     `ovm_info("MEM_SEQ",$psprintf("memwr0: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data[0]),OVM_LOW)
                     end 

            repeat(2)
                       begin
          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
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
endclass : mix_generic_seq
