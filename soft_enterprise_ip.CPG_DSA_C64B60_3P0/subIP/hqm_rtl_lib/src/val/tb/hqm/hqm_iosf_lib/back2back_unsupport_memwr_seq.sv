import lvm_common_pkg::*;


class back2back_unsupport_memwr_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_unsupport_memwr_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_memwr_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_unsupport_atomic_seq        mem_atomic_write_seq;


  function new(string name = "back2back_unsupport_memwr_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
      
                      
        
         mem_packet pkt ;
         pkt = mem_packet::type_id::create("pkt");
                          p_cnt = 16;  
                           
        //------------------------send more P memwr64 than available credit -------------------------------//
         if($test$plusargs("MEM64"))begin

        repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 end
                   end
        //-----------------------------------------------------------------------------------------------------// 
                   if($test$plusargs("MEM32"))begin

         repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 end
                   end
//------------------------------------------------------------------------------------------//       
                         
                 if($test$plusargs("IOWr"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd32 == Iosf::IOWr;  }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 //end
                   end
 //-------------------------------------------------------------------------------------------//
   if($test$plusargs("NPMWr32"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd32 == Iosf::NPMWr32;  }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 //end
                   end
//------------------------------------------------------------------------------------------------------------------//
if($test$plusargs("LTMWr32"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd32 == Iosf::LTMWr32;  }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                 //end
                   end

//--------------------------------------------------------------------------------------------//                                             
                    if($test$plusargs("NPMWr64"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd64 == Iosf::NPMWr64;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                // end
                   end
//--------------------------------------------------------------------------------------------------------------------------//
if($test$plusargs("LTMWr64"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_write_seq);
    if (!mem_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd64 == Iosf::LTMWr64;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_write_seq);

                // end
                   end

//--------------------------------------------------------------------------------------------//
if($test$plusargs("FAdd64"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_atomic_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_atomic_write_seq);
    if (!mem_atomic_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd64 == Iosf::FAdd64;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_atomic_write_seq);

                // end
                   end
//-------------------------------------------------------------------------------------------------------------------------------------------------//

if($test$plusargs("SWAP64"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_atomic_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_atomic_write_seq);
    if (!mem_atomic_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd64 == Iosf::Swap64;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_atomic_write_seq);

                // end
                   end


//-----------------------------------------------------------------------------------------------------------------------------------------------------------//

if($test$plusargs("CAS64"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_atomic_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_atomic_write_seq);
    if (!mem_atomic_write_seq.randomize() with  {iosf_addr == 64'h200004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd64 == Iosf::CAS64;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_atomic_write_seq);

                // end
                   end

//---------------------------------------------------------------------------------------------//
if($test$plusargs("SWAP32"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_atomic_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_atomic_write_seq);
    if (!mem_atomic_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd32 == Iosf::Swap32;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_atomic_write_seq);

                // end
                   end


//-----------------------------------------------------------------------------------------------------------------------------------------------------------//

if($test$plusargs("CAS32"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_atomic_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_atomic_write_seq);
    if (!mem_atomic_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd32 == Iosf::CAS32;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_atomic_write_seq);

                // end
                   end
//-----------------------------------------------------------------------------------------------------------------//  
if($test$plusargs("FAdd32"))begin

         //repeat(p_cnt+1) begin
        `ovm_create_on(mem_atomic_write_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(mem_atomic_write_seq);
    if (!mem_atomic_write_seq.randomize() with  {iosf_addr == 64'h000004218; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; iosf_cmd32 == Iosf::FAdd32;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end
                   finish_item(mem_atomic_write_seq);

                // end
                   end


 //------------------------------------------------------------------------------------------//   
  endtask : body
endclass : back2back_unsupport_memwr_seq 
