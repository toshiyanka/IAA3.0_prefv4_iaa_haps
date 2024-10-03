import lvm_common_pkg::*;


class back2back_posted_msg_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_posted_msg_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_msg_seq        msg_write_seq;

  bit [7:0]     iosf_sai_val;

  function new(string name = "back2back_posted_msg_seq");
    super.new(name); 
    iosf_sai_val = 8'h03;                          
    $value$plusargs("iosf_sai_msg=%d", iosf_sai_val);
    ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_SeqOptions:: iosf_sai_val=%0d ", iosf_sai_val), OVM_DEBUG);
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
        
          msg_packet pkt ;
         pkt = msg_packet::type_id::create("pkt");
         pkt.constraint_mode(0);
         pkt.default_memwr64.constraint_mode(1);
         p_cnt = 16;  

         //if($test$plusargs("SAI_0"))begin
         //    iosf_sai_val = 8'h0;                          
         //end else begin
         //    iosf_sai_val = 8'h03;                          
         //end
         //ovm_report_info(get_type_name(),$psprintf("back2back_unsupport_memrd_seq_SeqOptions1:: iosf_sai_val=%0d ", iosf_sai_val), OVM_DEBUG);


        //------------------------send more P msg than available credit -------------------------------//
                 if($test$plusargs("MODE0"))begin

                repeat(p_cnt+1) begin  
                          assert(pkt.randomize());
                             pkt.randomize_foreach();
                               
        `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
             start_item(msg_write_seq);
        if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
        end
                       finish_item(msg_write_seq);
                      
                                 end

                      end 


                 if($test$plusargs("MSG0"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg0; iosf_sai == iosf_sai_val; }) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end         
           
                 if($test$plusargs("MSG1"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg1; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end        

              
                           
                   if($test$plusargs("MSG2"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg2; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end    



           if($test$plusargs("MSG3"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg3; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end  



                          if($test$plusargs("MSG4"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg4; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end  



          if($test$plusargs("MSG5"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg5; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end  







               if($test$plusargs("MSG6"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg6; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end

               
               if($test$plusargs("MSG7"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 0; iosf_cmd == Iosf::Msg7; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end

//-------------------------------------Message with data--------------------------------------//



if($test$plusargs("MSG_D0"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD0; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end         
           
                 if($test$plusargs("MSG_D1"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD1; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end        

              
                   if($test$plusargs("MSG_D2"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD2; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end             
                   if($test$plusargs("MSG_D3"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD3; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end    


               if($test$plusargs("MSG_D4"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD4; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end

                if($test$plusargs("MSG_D5"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD5; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end


                if($test$plusargs("MSG_D6"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD6; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end


               
               if($test$plusargs("MSG_D7"))begin
                    assert(pkt.randomize());
                         `ovm_create_on(msg_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                         start_item(msg_write_seq);
                       if (!msg_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_cmd == Iosf::MsgD7; iosf_sai == iosf_sai_val;}) begin
                                     `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for msg_write_seq");
                             end
                       ovm_report_info(get_type_name(),$psprintf("back2back_posted_msg_seq_trf:: iosf_addr=0x%0x/iosf_sai_val=%0d ", msg_write_seq.iosf_addr, msg_write_seq.iosf_sai), OVM_DEBUG);
                       finish_item(msg_write_seq);

               end



















  endtask : body
endclass : back2back_posted_msg_seq 
