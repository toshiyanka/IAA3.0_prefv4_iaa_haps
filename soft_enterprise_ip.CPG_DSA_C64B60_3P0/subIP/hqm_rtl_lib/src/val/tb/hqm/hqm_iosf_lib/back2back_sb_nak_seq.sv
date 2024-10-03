import lvm_common_pkg::*;


class back2back_sb_nak_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_sb_nak_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memwr_seq        mem_write_seq;

  function new(string name = "back2back_sb_nak_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
       cfg_sb_packet pkt1 ;
       mem_sb_packet pkt ;

        pkt1 = cfg_sb_packet::type_id::create("pkt1");

                pkt = mem_sb_packet::type_id::create("pkt");
          
               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP memwr than available credit -------------------------------//
                repeat(np_cnt+1)
                

                       begin
                       pkt1.constraint_mode(0);
                       pkt1.default_cfgrd.constraint_mode(1);   
                       assert(pkt.randomize());

          //`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()), {addr == pkt.cfg_addr;})
          `ovm_do_with(cfg_read_seq, {addr == pkt1.cfg_addr;})

               // rdata = cfg_read_seq.iosf_data;
          //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end 
     
                  repeat(3)begin
                `ovm_do_with(cfg_write_seq, {addr == pkt1.cfg_addr; wdata == pkt1.cfg_data;})
              end  


           repeat(np_cnt+1)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);
               pkt.legal_cplstatus.constraint_mode(0);
                pkt.illegal_cplstatus.constraint_mode(0);
                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == pkt.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt.mem_addr; wdata == 32'hFFFFFFFF;})

         
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                          end 
     
                      
      //wait after all sequence given
   #15000;
   #10000;
                                          
                   

    
  endtask : body
endclass : back2back_sb_nak_seq
