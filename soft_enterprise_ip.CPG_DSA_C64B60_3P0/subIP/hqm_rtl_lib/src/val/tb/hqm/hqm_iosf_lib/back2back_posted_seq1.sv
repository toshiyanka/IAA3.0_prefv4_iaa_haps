import lvm_common_pkg::*;


class back2back_posted_seq1 extends ovm_sequence;
  `ovm_sequence_utils(back2back_posted_seq1,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_posted_seq1");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
      
         
        mem_packet pkt ;
        pkt = mem_packet::type_id::create("pkt");
        pkt.constraint_mode(0);
               //pkt.randomize_foreach();

        //max np_credit is set to 16 while no credit update 
            p_cnt = 16 ;
               
        //------------------------send more P memwr32 than available credit -------------------------------//
                 repeat(3) begin  
                   pkt.default_memwr32.constraint_mode(1);
                                                                              
         `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
        assert(pkt.randomize());
        start_item(mem_write_seq);
        if (!mem_write_seq.randomize() with  {iosf_addr == 64'h100002f00; iosf_data.size() == 1;iosf_data[0] == 32'h01;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                finish_item(mem_write_seq);
                      
                                 end
              repeat(10) begin
                        pkt.default_memwr32.constraint_mode(1);
                         assert(pkt.randomize());
              
          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h100002F00;})
                  rdata = mem_read_seq.iosf_data;
                  if (rdata != 32'h01)begin
             `ovm_error("Read_data_error_received",$psprintf("  read data expected 01 but getting ) (0x%08x) ",rdata))
          end

        
        
                end
                      
        

       //------------------------------------------------------------------------------------------------------//                   
                
  endtask : body
endclass : back2back_posted_seq1
