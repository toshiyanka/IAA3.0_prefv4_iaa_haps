import lvm_common_pkg::*;


class np_np_sb_seq extends ovm_sequence;
  `ovm_sequence_utils(np_np_sb_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;
  
  hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_iosf_sb_memrd_seq        mem_read_seq;
  hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "np_np_sb_seq");
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

 
  

               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP cfgrd  and memrd than available credit -------------------------------//

           repeat(np_cnt+1)
                

                       begin

                       pkt.constraint_mode(0);
                       pkt.default_cfgwr.constraint_mode(1);   
                       assert(pkt.randomize());
                `ovm_do_with(cfg_read_seq, {addr == pkt.cfg_addr;})
                `ovm_do_with(cfg_write_seq, {addr == pkt.cfg_addr; wdata == pkt.cfg_data;})
 
                      
                       pkt1.constraint_mode(0);
                       pkt1.default_memrd64.constraint_mode(1);   
                       assert(pkt1.randomize());                      
                     `ovm_do_with(mem_read_seq, {addr == pkt1.mem_addr;})


                                      end 

                         
              
     
   
                                                
                   

    
  endtask : body
endclass : np_np_sb_seq
