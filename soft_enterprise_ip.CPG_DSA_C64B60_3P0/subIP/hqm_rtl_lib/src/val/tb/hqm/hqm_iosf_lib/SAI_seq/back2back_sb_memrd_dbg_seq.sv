import lvm_common_pkg::*;


class back2back_sb_memrd_dbg_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_sb_memrd_dbg_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memrd_sai_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_sb_memrd_dbg_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
        sai_sb_packet pkt ;
        pkt = sai_sb_packet::type_id::create("pkt");
                       //max np_credit is set to 16 while no credit update 
        np_cnt = 30 ;
  
           
  //-------------------------------------------------------------------------------------------------//       

        repeat(np_cnt+1)
                
                      begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd64.constraint_mode(1); 

                     if($test$plusargs("MODE0"))begin
                           pkt.invalid_sai.constraint_mode(1);  
                           end  

                       if($test$plusargs("MODE1"))begin
                              pkt.invalid_sai1.constraint_mode(1);  
                               end

                       assert(pkt.randomize());

          
    

                       
          `ovm_do_with(mem_read_seq, {addr == 64'h000000610; Iosf_sai ==  pkt.iosf_sai;})
                          
 
          `ovm_do_with(mem_read_seq, {addr == 64'h0000006a0; Iosf_sai ==  pkt.iosf_sai;})
                
          
         `ovm_do_with(mem_read_seq, {addr == 64'h00000069C; Iosf_sai ==  pkt.iosf_sai;})
                
                                 
                         
          
          `ovm_do_with(mem_read_seq, {addr == 64'h000003060; Iosf_sai ==  pkt.iosf_sai;})
               
                    
          `ovm_do_with(mem_read_seq, {addr == 64'h000000694; Iosf_sai ==  pkt.iosf_sai;})
             
                     
          `ovm_do_with(mem_read_seq, {addr == 64'h000000698; Iosf_sai ==  pkt.iosf_sai;})
              
                      
          `ovm_do_with(mem_read_seq, {addr == 64'h000002000; Iosf_sai ==  pkt.iosf_sai;})
                
                     
          `ovm_do_with(mem_read_seq, {addr == 64'h000002008; Iosf_sai ==  pkt.iosf_sai;})
                     
         `ovm_do_with(mem_read_seq, {addr == 64'h00000060C; Iosf_sai ==  pkt.iosf_sai;})
                
                  
          `ovm_do_with(mem_read_seq, {addr == 64'h000000624; Iosf_sai ==  pkt.iosf_sai;})
                
          
         `ovm_do_with(mem_read_seq, {addr == 64'h000000624; Iosf_sai ==  pkt.iosf_sai;})
          
                          





                   end

                          
                   

  //wait after all sequence given
   #15000;
   #10000;
     
  endtask : body
endclass : back2back_sb_memrd_dbg_seq
