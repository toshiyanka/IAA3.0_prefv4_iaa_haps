import lvm_common_pkg::*;


class back2back_memwr_badtxn_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_memwr_badtxn_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_badtxn_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_badtxn_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_badlbe_seq        mem_write_seq1;
  hqm_tb_sequences_pkg::hqm_iosf_prim_memory_rd_lbe_seq        mem_read_seq1;


  function new(string name = "back2back_memwr_badtxn_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
         
        //----------------------------------------------------------------------------------------//           
                if($test$plusargs("MODE0"))begin

                 //each clock one DW is transferred
       `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_length == 35;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
                                     
                  end 
            
                 if($test$plusargs("MODE1"))begin
          `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004214; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_length == 40;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
                 end

                 //MPS =256B
               if($test$plusargs("MODE2"))begin
          `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004214; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_length == 70;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
                 end  

                //MPS=512B
                if($test$plusargs("MODE3"))begin
          `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004214; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_length == 129;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
                 end

               if($test$plusargs("MODE4"))begin
          `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004214; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_length == 129;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
                 end   



                   
          if($test$plusargs("LBE_CHECK"))begin
            for (int i=1; i<16;i++)begin
          `ovm_create_on(mem_write_seq1,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq1);
    if (!mem_write_seq1.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1;  iosf_data[0] == 32'hFFFFFFFF; lbe == i; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq1);
                end //for end
                   
                 end


          if($test$plusargs("MEMRD_LBE_CHECK"))begin
            for(int i=1; i<16; i++)begin

      `ovm_do_on_with(mem_read_seq1, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h200004218;lbe == i;})
                                          end 

           end       

    
  endtask : body
endclass : back2back_memwr_badtxn_seq
