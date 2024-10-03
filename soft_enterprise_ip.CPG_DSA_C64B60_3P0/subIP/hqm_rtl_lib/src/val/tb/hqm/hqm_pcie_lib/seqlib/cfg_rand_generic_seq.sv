import lvm_common_pkg::*;


class cfg_rand_generic_seq extends ovm_sequence;
  `ovm_sequence_utils(cfg_rand_generic_seq,sla_sequencer)
   

  string        mode = "";
 

  integer       fd;
  integer       timeoutval;
  int cfg_int;
  bit [63:0]  addr;
   rand bit [31:0]      wdata[20];
   

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
   pcie_seqlib_pkg::cfg_order_seq        cfg_order_check_seq;

  
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
       bit [31:0]          final_wdata;
      
        mem_packet1 pkt ;
        pkt =  mem_packet1::type_id::create("pkt");
                

      
    //--------------check all combination of P/NP cfgwr/cfgrd using random_data------------//                       
              
             
   //----------------------******WRWR random address*****----------------------------//
               // `ifdef WRWR_rand
               if (mode == "WRWR_rand") begin  
                             
                 for (int i=0;i<=15;i++)begin
            
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                     assert(pkt.randomize());
                     `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;iosf_data == wdata[i]; })
     `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
     `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
           rdata = cfg_read_seq.iosf_data;
      `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
              final_wdata = wdata[i];                  
                      end
                 //check only latest update 
              repeat(10) begin
                assert(pkt.randomize());

                `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;iosf_data == final_wdata; })
                `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                     end

               //order check
                     `ovm_do_on_with(cfg_order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
                 `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfg_order_check_seq_sent "),OVM_LOW)
                 

             end  
             //  `endif             

     
     //-----------------------*******WWWWWR_diff data on same address***********------------------------------------//
             // `ifdef WWWR_addr
                  if (mode == "WWWR_addr") begin  
                    repeat(16)begin   
                     
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                assert(pkt.randomize());

                  for (int i=0; i<=10;i++)
              begin
                
                `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;iosf_data == wdata[i]; })
     `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
            final_wdata = wdata[i];
                     end
                     
                     `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
       rdata = cfg_read_seq.iosf_data;
      `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                   end

               for (int i=0; i<=16;i++)
              begin
                assert(pkt.randomize());
                `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;iosf_data == final_wdata; })
     `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
                                 end
     
                   

                   //check order update 
                                 `ovm_do_on_with(cfg_order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
                
                 `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfg_order_check_seq_sent "),OVM_LOW)
                 

             end  
             //  `endif             

     
                        
      //------------------------******WRRRRRR on same address**************------------------------------------//
                     //`ifdef WRRR_addr
                 if (mode == "WRRR_addr") begin  
                   for(int i=0;i<=16;i++)begin
                       
                 pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                         final_wdata = 32'hAABBCCDD;
               repeat(10)begin //wait till write all register
                assert(pkt.randomize());

                `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == final_wdata;  })
      `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
                          end
   
            repeat(10)
                       begin
                         
                    assert(pkt.randomize())
                    `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end
                       
                      
                      //check order update 
                          `ovm_do_on_with(cfg_order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
                       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfg_order_check_seq_sent"),OVM_LOW)

               end 

                    end 
                       // `endif 
                       
      //--------------------------------------------------------------------------------------------------------------------------//                    
          //`ifdef WWRR_addr
          
          if (mode == "WWRR_addr") begin  
       
            for (int i=0;i<=16;i++)begin
          
               pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);

                 assert(pkt.randomize());
                  repeat(1)
              begin
                `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == wdata[i]; })
     `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
                     end 

            repeat(2)
                       begin
                         `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end
                     repeat(1)
              begin
                `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == wdata[i]; })
     `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
                     end 

                     final_wdata = wdata[16];
                end
             
                for (int i=0; i<=10;i++)
              begin
                assert(pkt.randomize()); 
                repeat(2)begin
                  `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;iosf_data == final_wdata; })
                 end 
       `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
                      end

             //check order update 
                      `ovm_do_on_with(cfg_order_check_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_data == final_wdata;})
                       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfg_order_check_seq_sent"),OVM_LOW)



     end  
      //-------------------------------------------------------------------------------------------------------------------------------------//               


                       // `endif 
           

   


//run_time_until_idle (400000000);

      
  endtask : body
endclass : cfg_rand_generic_seq
