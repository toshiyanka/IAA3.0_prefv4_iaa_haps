import lvm_common_pkg::*;


class back2back_fbe_vf_memwr_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_fbe_vf_memwr_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_iosf_fbe_memwr_seq        mem_write_seq;

  function new(string name = "back2back_fbe_vf_memwr_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt, i ; //max posted trasaction credit advertised by HQM
      
                      
        
         mem_packet pkt ;
         pkt = mem_packet::type_id::create("pkt");
                          p_cnt = 16;  
                           
        //------------------------send more P memwr64 than available credit -------------------------------//
         if($test$plusargs("MEM64"))begin

        //repeat(p_cnt+1) begin
        for(i = 0, i=0; i<15; i++)begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h0000000300001f00; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_fbe == i; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 end
                   end

          if($test$plusargs("MEM641"))begin

        //repeat(p_cnt+1) begin
        for(i = 0, i=0; i<15; i++)begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004214; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_fbe == i; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 end
                   end
         
        //-----------------------------------------------------------------------------------------------------// 
                   if($test$plusargs("MEM32"))begin

        // repeat(p_cnt+1) begin
        for(i = 0, i=0; i<15; i++)begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h0000000300001f00; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_fbe == i; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
                   //following memory rd
        
             end 
     `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h0000000300001f00;})
                rdata = mem_read_seq.iosf_data;
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
                         


                 end
                  
//------------------------------------------------------------------------------------------//       
       if($test$plusargs("ZERO"))begin

         repeat(5) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h0000000300001f00; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_fbe == 4'h0; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);
    
      start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h0000000300001f00; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_fbe == 4'h0; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);              

                 end
                   end
         
 //------------------------------------------------------------------------------------------//   
  endtask : body
endclass : back2back_fbe_vf_memwr_seq 
