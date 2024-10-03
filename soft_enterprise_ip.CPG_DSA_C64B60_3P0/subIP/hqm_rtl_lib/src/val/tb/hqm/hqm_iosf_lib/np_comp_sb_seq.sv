import lvm_common_pkg::*;


class np_comp_sb_seq extends ovm_sequence;
  `ovm_sequence_utils(np_comp_sb_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;
  
  hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_iosf_sb_memrd_seq        mem_read_seq;
  hqm_iosf_prim_mem_wr_seq     mem_write_seq;
  hqm_iosf_sb_cpl_seq          cpl_seq;
  hqm_iosf_sb_cplD_seq         cplD_seq;


  function new(string name = "np_comp_sb_seq");
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
  
           
        //------------------------send more NP cfgrd  and cpl than available credit -------------------------------//
            if($test$plusargs("NP_CPL_TXN"))begin 
           repeat(np_cnt+1)
                  begin
                       pkt.constraint_mode(0);
                       pkt.default_cfgwr.constraint_mode(1);   
                       assert(pkt.randomize());
                `ovm_do_with(cfg_read_seq, {addr == pkt.cfg_addr;})
                                                             
                   //send completion                    
                  `ovm_do(cpl_seq)

                     //send np cfgwr
                     repeat(16)begin
                  assert(pkt.randomize());                  
                 `ovm_do_with(cfg_write_seq, {addr == pkt.cfg_addr; wdata == pkt.cfg_data;})
                     end

                  //send completion                    
                  `ovm_do(cpl_seq)

                end
              end
         //----------------------send cpl and Np transaction back2bck--------------------------//
          if($test$plusargs("CPL_NP_TXN"))begin 
           repeat(np_cnt+1)
                  begin
                                                                                   
                   //send completion                    
                  `ovm_do(cpl_seq)
                 repeat(16)begin
                     //send np cfgwr
                     `ovm_do(cplD_seq)

                      pkt.constraint_mode(0);
                       pkt.default_cfgwr.constraint_mode(1);   
                       assert(pkt.randomize());
                `ovm_do_with(cfg_read_seq, {addr == pkt.cfg_addr;})

                  assert(pkt.randomize());                  
                 `ovm_do_with(cfg_write_seq, {addr == pkt.cfg_addr; wdata == pkt.cfg_data;})

                    end

                  //send completion                    
                  `ovm_do(cpl_seq)

                end
              end







    //--------------------------------------------------------------------------------------------//     





                         
              
     
   
                                                
                   

    
  endtask : body
endclass : np_comp_sb_seq
