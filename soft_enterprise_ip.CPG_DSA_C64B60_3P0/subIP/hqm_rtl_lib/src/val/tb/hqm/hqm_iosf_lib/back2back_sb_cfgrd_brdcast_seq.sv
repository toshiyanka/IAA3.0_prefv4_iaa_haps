import lvm_common_pkg::*;


class back2back_sb_cfgrd_brdcast_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_sb_cfgrd_brdcast_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_brdcast_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_brdcast_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_sb_cfgrd_brdcast_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
        cfg_sb_packet pkt ;
        pkt = cfg_sb_packet::type_id::create("pkt");
                       //max np_credit is set to 16 while no credit update 
        np_cnt = 5 ;
  
           
        //------------------------send more NP cfgrd than available credit -------------------------------//
            if($test$plusargs("BRDCAST_CFGRD_TXN"))begin

           repeat(np_cnt+1)
                

                       begin
                       pkt.constraint_mode(0);
                       pkt.default_cfgrd.constraint_mode(1);   
                       assert(pkt.randomize());

          //`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()), {addr == pkt.cfg_addr;})
          //`ovm_do_with(cfg_read_seq, {addr == pkt.cfg_addr;})
          `ovm_do_with(cfg_write_seq, {addr == 64'h0000003c; wdata == 32'hFFFF_FFFF;})


               // rdata = cfg_read_seq.iosf_data;
          //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end 
     
                 
            end          
   //-------------------------------------------------------------------------------------------------//                
     if($test$plusargs("BRDCAST_CFGWR_TXN"))begin
   
       repeat(np_cnt+1)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(cfg_write_seq, {addr == 64'h0000003c; wdata == 32'hFFFF_FFFF;})
        `ovm_do_with(cfg_write_seq, {addr == 64'h00000118; wdata == 32'hFFFF_FFFF;})

         
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                          end 
     
                      
       end    

    //----------------------------------------------------------------------------------------------------------------//
  //wait after all sequence given
   #15000;
   #10000;
     
  endtask : body
endclass : back2back_sb_cfgrd_brdcast_seq
