import lvm_common_pkg::*;


class np_np_seq1 extends ovm_sequence;
  `ovm_sequence_utils(np_np_seq1,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "np_np_seq1");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        cfg_packet pkt ;
        mem_packet pkt1;
        pkt = cfg_packet::type_id::create("pkt");
        pkt1 = mem_packet::type_id::create("pkt1");

               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP cfgrd than available credit -------------------------------//

           repeat(np_cnt+5)
                    
                       begin
                           assert(pkt.randomize());
                              pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1); 

       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == pkt.cfg_data;})
         
       `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
               
       //add memory read command and enable memory constraint
                       pkt1.constraint_mode(0);
                       pkt1.default_memrd64.constraint_mode(1);   
                       assert(pkt1.randomize());

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt1.mem_addr;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)




                          end 
     
   
                                                
                   

    
  endtask : body
endclass : np_np_seq1
