import lvm_common_pkg::*;


class p_p_sb_seq extends ovm_sequence;
  `ovm_sequence_utils(p_p_sb_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memwr_seq        mem_write_seq;

  function new(string name = "p_p_sb_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  p_cnt ; 
      
        mem_sb_packet pkt ;
        pkt = mem_sb_packet::type_id::create("pkt");
          
               //max p_credit is set to 16 while no credit update 
        p_cnt = 10 ;
  
           
        //------------------------send more P memwr than available credit -------------------------------//

           repeat(p_cnt+1)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);
               // pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == pkt.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt.mem_addr; wdata == 32'hFFFFFFFF;})

         
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                          end 
     
                      
                                                
                   

    
  endtask : body
endclass : p_p_sb_seq
