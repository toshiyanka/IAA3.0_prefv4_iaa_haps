import lvm_common_pkg::*;


class back2back_mwmr_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_mwmr_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq1        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_mwmr_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
      
         
               //max np_credit is set to 16 while no credit update 
        
         mem_packet pkt ;
         pkt = mem_packet::type_id::create("pkt");
         pkt.constraint_mode(0);
         pkt.mem_data_size.constraint_mode(1);
         pkt.default_memwr64.constraint_mode(1);
         pkt.randomize_foreach();

         p_cnt = 16;  
                           
        //------------------------send more P memwr32 than available credit -------------------------------//
        repeat(20) begin
                                                                                                                
      //each clock one DW is transferred
       `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
       
        start_item(mem_write_seq);
        assert(pkt.randomize());
                if (!mem_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_data[0] == 32'hDEADBEEF;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
       // foreach (pkt.mem_data[i]) begin
         // mem_write_seq.iosf_data[i] = pkt.mem_data[i];
        //end
               
           `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.mem_addr;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

                
        finish_item(mem_write_seq);
      end
                      
                                        //-----------------------------------------------------------------------------------------------------// 
                         
       //sen memwr32 after max p_credit memwr64
        //`ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h0; iosf_data.size() == pkt.mem_data.size();})
      
                                                     
                   

    
  endtask : body
endclass : back2back_mwmr_seq 
