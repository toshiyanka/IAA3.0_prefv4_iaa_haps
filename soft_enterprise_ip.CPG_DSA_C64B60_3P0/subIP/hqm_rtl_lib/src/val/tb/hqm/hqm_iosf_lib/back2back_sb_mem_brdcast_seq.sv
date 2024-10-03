import lvm_common_pkg::*;


class back2back_sb_mem_brdcast_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_sb_mem_brdcast_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memrd_brdcast_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memrd32_seq        mem_read_seq1;

  hqm_tb_sequences_pkg::hqm_iosf_sb_memwr_brdcast_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memwr_mcast_seq        mem_mcast_seq;


  function new(string name = "back2back_sb_mem_brdcast_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
        mem_sb_packet pkt ;
        pkt = mem_sb_packet::type_id::create("pkt");
                       //max np_credit is set to 16 while no credit update 
        np_cnt = 15 ;
  
           
        //------------------------send more NP cfgrd than available credit -------------------------------//
                   if($test$plusargs("MEMRD_BRDCAST_TXN"))begin

           repeat(np_cnt+1)
                      begin
                       pkt.constraint_mode(0);
                       pkt.default_memrd64.constraint_mode(1);   
                       assert(pkt.randomize());

          //`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()), {addr == pkt.cfg_addr;})
          `ovm_do_with(mem_read_seq, {addr == pkt.mem_addr;})

               // rdata = cfg_read_seq.iosf_data;
          //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end 

                      end 

     //-----------------------------------memwr----------------------------------------------------//                      
           if($test$plusargs("MEMWR_BRDCAST_TXN"))begin

     repeat(5)
                    
                       begin
                
       `ovm_do_with(mem_write_seq, {addr == 64'h00004218; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == 64'h00004214; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == 64'h00004120; wdata == 32'hFFFFFFFF;})
                        end
         
        



                        end
     //------------------------------------------------------------------------------------------------------//
         if($test$plusargs("MEMWR_MCAST_TXN"))begin

     repeat(5)
                    
                       begin
                
       `ovm_do_with(mem_mcast_seq, {addr == 64'h00004218; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_mcast_seq, {addr == 64'h00004214; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_mcast_seq, {addr == 64'h00004120; wdata == 32'hFFFFFFFF;})
                        end
         
        



                        end
                 
                   

 
  endtask : body
endclass : back2back_sb_mem_brdcast_seq
