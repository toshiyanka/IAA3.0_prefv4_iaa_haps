import lvm_common_pkg::*;


class back2back_posted_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_posted_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_msg_wr_seq        msg_write_seq;


  function new(string name = "back2back_posted_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
        
          msg_packet pkt ;
         pkt = msg_packet::type_id::create("pkt");
         p_cnt = 16;  
                           
        //------------------------send more P msg than available credit -------------------------------//
                repeat(p_cnt+1) begin  
                          assert(pkt.randomize());
                             pkt.randomize_foreach();
                               
        `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
             start_item(msg_write_seq);
        if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == pkt.msg_data.size();}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
        end
        foreach (pkt.msg_data[i]) begin
          msg_write_seq.iosf_data[i] = pkt.msg_data[i];
        end
               finish_item(msg_write_seq);
                      
                                 end
           
                                                     
                   

    
  endtask : body
endclass : back2back_posted_seq 
