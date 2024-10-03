import lvm_common_pkg::*;


class back2back_sb_memwr32_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_sb_memwr32_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memrd32_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memwr32_seq        mem_write_seq;

  function new(string name = "back2back_sb_memwr32_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        mem_sb_packet pkt ;
        pkt = mem_sb_packet::type_id::create("pkt");
          
               //max np_credit is set to 16 while no credit update 
        np_cnt = 6 ;
  
           
        //------------------------send more NP memwr than available credit -------------------------------//

           
                pkt.constraint_mode(0);
                pkt.default_memwr32.constraint_mode(1);
               // pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == 64'h000002f00; wdata == 32'h01;})
       `ovm_do_with(mem_write_seq, {addr == 64'h000002f00; wdata == 32'h01;})
       `ovm_do_with(mem_write_seq, {addr == 64'h000002f00; wdata == 32'h01;})
                         

                          pkt.constraint_mode(0);
                pkt.default_memwr32.constraint_mode(1);
               // pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(mem_read_seq, {addr == 64'h000002f00; })
       `ovm_do_with(mem_read_seq, {addr == 64'h000002f00; })
       `ovm_do_with(mem_read_seq, {addr == 64'h000002f00; })
                                         
     
                      
                                                
                   

    
  endtask : body
endclass : back2back_sb_memwr32_seq
