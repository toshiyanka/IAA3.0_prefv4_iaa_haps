import lvm_common_pkg::*;


class cmp_cmp_sb_seq extends ovm_sequence;
  `ovm_sequence_utils(cmp_cmp_sb_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;
  
  hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_iosf_sb_memrd_seq        mem_read_seq;
  hqm_iosf_sb_memwr_seq        mem_write_seq;
  hqm_iosf_sb_cpl_seq         cpl_seq;
  hqm_iosf_sb_cplD_seq        cplD_seq;


  function new(string name = "cmp_cmp_sb_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
       cfg_sb_packet pkt ;
       mem_sb_packet pkt1 ;
      
       pkt1 = mem_sb_packet::type_id::create("pkt1");
       pkt = cfg_sb_packet::type_id::create("pkt");

 
  

                
        np_cnt = 6 ;
  
           
        //------------------------send more cpl followedby cplD and posted  -------------------------------//

           repeat(np_cnt+1)
                    begin

                 if($test$plusargs("CPL_POSTED_TXN"))begin                                                                    
                   //send completion                    
                  `ovm_do(cpl_seq)
                  //send Posted transaction once 
            repeat(5)                    
                       begin
                        
                pkt1.constraint_mode(0);
                pkt1.default_memwr64.constraint_mode(1);
               // pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
        
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
                          end
                        end //end args     

                if($test$plusargs("CPL_CPL_TXN"))begin      
                     //send cplD followed by cpl
                                  
                 `ovm_do(cplD_seq)
                  //send completion                    
                  `ovm_do(cpl_seq)
                end 
              end  //end loop


    //----------------------------------------------------------------------------------------//
      
                 if($test$plusargs("POSTED_CPL_TXN"))begin                                                                    
                                     //send Posted transaction once 
                    repeat(5)                    
                       begin
                        
                pkt1.constraint_mode(0);
                pkt1.default_memwr64.constraint_mode(1);
               // pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
        `ovm_do(cplD_seq)
       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
        //send completion                    
                  `ovm_do(cpl_seq)

        
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
                          end
                         
                        end //end args 








//--------------------------------------------------------------------------------------------------------//    

                         
              
     
   
                                                
                   

    
  endtask : body
endclass : cmp_cmp_sb_seq
