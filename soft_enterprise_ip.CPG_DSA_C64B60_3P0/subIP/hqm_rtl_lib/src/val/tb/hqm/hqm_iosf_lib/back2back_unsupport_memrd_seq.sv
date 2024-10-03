import lvm_common_pkg::*;


class back2back_unsupport_memrd_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_unsupport_memrd_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_memory_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  bit [7:0]     iosf_sai_val;

  function new(string name = "back2back_unsupport_memrd_seq");
    super.new(name); 
    iosf_sai_val = 8'h03;                          
    $value$plusargs("iosf_sai_memrd=%d", iosf_sai_val);
    ovm_report_info(get_type_name(),$psprintf("back2back_unsupport_memrd_seq_SeqOptions:: iosf_sai_val=%0d ", iosf_sai_val), OVM_DEBUG);
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
        mem_packet pkt ;
        pkt = mem_packet::type_id::create("pkt");
                       //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
         //if($test$plusargs("SAI_0"))begin
         //    iosf_sai_val = 8'h0;                          
         //end else begin
         //    iosf_sai_val = 8'h03;                          
         //end
         //ovm_report_info(get_type_name(),$psprintf("back2back_unsupport_memrd_seq_SeqOptions1:: iosf_sai_val=%0d ", iosf_sai_val), OVM_DEBUG);


        //------------------------send more NP cfgrd than available credit -------------------------------//
                     if($test$plusargs("MEM32"))begin
           repeat(np_cnt+1)
                

                       begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd32.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_DEBUG)
                          end 

                        end                
     
   
                   if($test$plusargs("MEM64"))begin
           repeat(np_cnt+1)
                

                       begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd64.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_DEBUG)
                          end 

                        end                                 
                   
//----------------------------------------------------------------------------------------------------------------------------------------------//

 if($test$plusargs("MRdLk64"))begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd64.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr; iosf_cmd64 == Iosf::MRdLk64; iosf_sai == iosf_sai_val; })
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0:MRdLk64 addr=0x%08x rdata=0x%08x sai=%0d",mem_read_seq.iosf_addr ,rdata, mem_read_seq.iosf_sai),OVM_DEBUG)
                        

                        end   


  if($test$plusargs("LTMRd64"))begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd64.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr; iosf_cmd64 == Iosf::LTMRd64; iosf_sai == iosf_sai_val; })
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0:LTMRd64 addr=0x%08x rdata=0x%08x sai=%0d",mem_read_seq.iosf_addr ,rdata, mem_read_seq.iosf_sai),OVM_DEBUG)
                        

                        end  
//-------------------------------------------------------------------------------------//

if($test$plusargs("IORd"))begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd32.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr; iosf_cmd32 == Iosf::IORd; iosf_sai == iosf_sai_val; })
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0:IORd addr=0x%08x rdata=0x%08x sai=%0d",mem_read_seq.iosf_addr ,rdata, mem_read_seq.iosf_sai),OVM_DEBUG)
                        

                        end   


  if($test$plusargs("MRdLk32"))begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd32.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr; iosf_cmd32 == Iosf::MRdLk32; iosf_sai == iosf_sai_val; })
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0:MRdLk32 addr=0x%08x rdata=0x%08x sai=%0d",mem_read_seq.iosf_addr ,rdata, mem_read_seq.iosf_sai),OVM_DEBUG)
                        

                        end  


  if($test$plusargs("LTMRd32"))begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd32.constraint_mode(1);  
                                               
                       assert(pkt.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr; iosf_cmd32 == Iosf::LTMRd32; iosf_sai == iosf_sai_val; })
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0:LTMRd32 addr=0x%08x rdata=0x%08x sai=%0d",mem_read_seq.iosf_addr ,rdata, mem_read_seq.iosf_sai),OVM_DEBUG)
                        

                        end  
                  

//--------------------------------------------------------------------------------------------//
    
  endtask : body
endclass : back2back_unsupport_memrd_seq
