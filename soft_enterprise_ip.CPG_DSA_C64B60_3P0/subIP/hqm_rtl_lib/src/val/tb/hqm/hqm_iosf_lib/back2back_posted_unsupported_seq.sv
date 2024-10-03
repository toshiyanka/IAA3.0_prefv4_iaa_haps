import lvm_common_pkg::*;


class back2back_posted_unsupported_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_posted_unsupported_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq         mem_write_seq;

  function new(string name = "back2back_posted_unsupported_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
      
         
               //max np_credit is set to 16 while no credit update 
        
         mem_errcheck_packet pkt ;
         pkt = mem_errcheck_packet::type_id::create("pkt");
         pkt.constraint_mode(0);
         
         p_cnt = 5;  
                           
        //------------------------send more P memwr64 than available credit -------------------------------//
               //#-------Mode0 for unspported DW width--------# 
             if($test$plusargs("MODE0"))begin
 
               repeat(p_cnt+1) begin   
                pkt.unsupported_addr.constraint_mode(1);
 
                   assert(pkt.randomize());
                                        
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
        start_item(mem_write_seq);
        if (!mem_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 8;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
        foreach (pkt.mem_data[i]) begin
          mem_write_seq.iosf_data[i] = pkt.mem_data[i];
        end
        finish_item(mem_write_seq);
                      
                                 end
                end

       //-----------------------------------------------------------------------------------------------------// 
             //#----------Mode1 for unsupported address---------#        
       if($test$plusargs("MODE1"))begin
         
       repeat(2) begin
                                                                                                                
       pkt.unsupported_maddr.constraint_mode(1);
        assert(pkt.randomize());
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
           
        start_item(mem_write_seq);
                        if (!mem_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end     
                          
        finish_item(mem_write_seq);
      end

    end
                                                     
                    //-------------------------------------------------------------------------------------//
    
  endtask : body
endclass : back2back_posted_unsupported_seq 
