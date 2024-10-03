import lvm_common_pkg::*;


class back2back_unsupport_cplD_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_unsupport_cplD_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_iosf_prim_mem_rd_seq      mem_read_seq;
  hqm_iosf_cplD_seq             cplD_seq;
  hqm_iosf_cpl_seq              cpl_seq;
  hqm_iosf_cplLk_seq            cplLk_seq;

  function new(string name = "back2back_unsupport_cplD_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  p_cnt ; //max posted trasaction credit advertised by HQM
      
                      
        
         mem_packet pkt ;
         pkt = mem_packet::type_id::create("pkt");
         pkt.constraint_mode(0);
                          p_cnt = 8;  
                           
        //------------------------send more P memwr64 than available credit -------------------------------//
         if($test$plusargs("CPLD_ALL"))begin

        repeat(p_cnt+1) begin
                 pkt.legal_cplstatus.constraint_mode(1);
                       assert(pkt.randomize());
        `ovm_create_on(cplD_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cplD_seq);
    if (!cplD_seq.randomize() with  {iosf_addr == 64'h000070000; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; cplD_status == 4'h0;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cplD_seq");
        end
                   finish_item(cplD_seq);

                 end
                   end
//------------------------------------------------------------------------------------------------//
      if($test$plusargs("COMPLETER_ID_ALL"))begin

        repeat(p_cnt+1) begin
                 pkt.legal_cplstatus.constraint_mode(1);
                 pkt.completer_id_addr.constraint_mode(1);
                       assert(pkt.randomize());
        `ovm_create_on(cplD_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cplD_seq);
    if (!cplD_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; cplD_status == 4'h0;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cplD_seq");
        end
                   finish_item(cplD_seq);

                 end
                   end

//-----------------------------------------------------------------------------------------------------------------------------//
if($test$plusargs("CPLD_MALFORM"))begin

        repeat(p_cnt+1) begin
                 pkt.legal_cplstatus.constraint_mode(1);
                       assert(pkt.randomize());
        `ovm_create_on(cplD_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cplD_seq);
    if (!cplD_seq.randomize() with  {iosf_addr == 64'h000070000; iosf_data.size() == 35; iosf_data[0] == 32'hFFFFFFFF; cplD_status == 4'h0;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cplD_seq");
        end
                   finish_item(cplD_seq);

                 end
                   end



//---------------------------------------------------------------------------------------------------//
if($test$plusargs("CPLDK_ALL"))begin

        repeat(p_cnt+1) begin
                 pkt.legal_cplstatus.constraint_mode(1);
                       assert(pkt.randomize());
        `ovm_create_on(cplD_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cplD_seq);
    if (!cplD_seq.randomize() with  {iosf_addr == 64'h000070000; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; cplD_status == 4'h0;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cplD_seq");
        end
                   finish_item(cplD_seq);

                 end
                   end





        //-----------------------------------------------------------------------------------------------------// 
               if($test$plusargs("CPL_ALL"))begin

        repeat(p_cnt+1) begin
               pkt.legal_cplstatus.constraint_mode(1);
           assert(pkt.randomize());
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == pkt.cpl_status;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 end
                   end 

//-----------------------------------------------------------------------------------------------------------------------------//

       if($test$plusargs("COMPLETER_CPL_ALL"))begin

        repeat(p_cnt+1) begin
               pkt.legal_cplstatus.constraint_mode(1);
               pkt.completer_id_addr.constraint_mode(1);

                assert(pkt.randomize());
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == pkt.mem_addr; cpl_status == pkt.cpl_status;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 end
                   end 
            
    //----------------------------------------------------------------------------------------//
if($test$plusargs("CPL_ALL"))begin

        repeat(p_cnt+1) begin
               pkt.legal_cplstatus.constraint_mode(1);
           assert(pkt.randomize());
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == pkt.cpl_status; requester_id == 16'h0F;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 end
                   end 

//----------------------------------------------------------------------------------------------//
if($test$plusargs("CPLK_ALL"))begin

        //repeat(10) begin
               for (int i =0 ; i <15;i++) begin
               pkt.legal_cplstatus.constraint_mode(1);
           assert(pkt.randomize());
        `ovm_create_on(cplLk_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cplLk_seq);
    if (!cplLk_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == pkt.cpl_status;}) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cplLk_seq);

            `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h0007014c;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h00010000)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end

             `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h00070074;})
                                   rdata = cfg_read_seq.iosf_data;
                            if (rdata != 32'h0001291F)begin
                            `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                                 end
                     
        

                 end
                   end 


 //------------------------------------------------------------------------------------------//  

if($test$plusargs("cpl_SC"))begin

        //repeat(p_cnt+1) begin

        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h0; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 //end
                   end

if($test$plusargs("cpl_UR"))begin

        //repeat(p_cnt+1) begin
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h1; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 //end
  
               end

//--------------------------------------------------------------------------------------------//               
if($test$plusargs("cpl_CRS"))begin

        //repeat(p_cnt+1) begin
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h2; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 //end
                   end

//---------------------------------------------------------------------------------------------------//                   

if($test$plusargs("cpl_CA"))begin

        //repeat(p_cnt+1) begin
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))

                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h4; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                 //end
                   end
//-------------------------------------------------------------------------------------------------//

if($test$plusargs("cpl_Illegal"))begin

        //repeat(p_cnt+1) begin
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h3; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);
                 
      
   //repeat(p_cnt+1) begin
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h5; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);

                   //repeat(p_cnt+1) begin
        `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h6; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);


 `ovm_create_on(cpl_seq,p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()))
                start_item(cpl_seq);
    if (!cpl_seq.randomize() with  {iosf_addr == 64'h000070000; cpl_status == 4'h7; }) begin
       `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for cpl_seq");
        end
                   finish_item(cpl_seq);



                   end
                   
//---------------------------------------------------------------------------------------------//






//-----------------------------------------------------------------------------------------------//
  endtask : body
endclass : back2back_unsupport_cplD_seq 
