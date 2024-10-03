import lvm_common_pkg::*;


class back2back_cfgwr_poison_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgwr_poison_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_poisoned_seq        cfg_write_poison_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_cfgwr_poison_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
        pkt.constraint_mode(0);
         //pkt.default_cfgwr.constraint_mode(1); 
          
               //max np_credit is set to 16 while no credit update 
       // np_cnt = 1 ;
  
           
        //------------------------send more NP cfgwr than available credit -------------------------------//

          // repeat(np_cnt+1)
                    
                      // begin
                
                    assert(pkt.randomize());
             //bar programming with poison data (sequence has EP=1)
       `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70010; iosf_data == 32'h0;})
       `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70014; iosf_data == 32'h04;})
       `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70018; iosf_data == 32'h0;})
       `ovm_do_on_with(cfg_write_poison_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h7001c; iosf_data == 32'h05;})


       if($test$plusargs("UPDATE_CHECK"))begin

       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70010;})
        rdata = cfg_read_seq.iosf_data;
        if ((rdata ) == 32'h00) begin
            `ovm_error("IOSF_PRIM_FILE_SEQ",$psprintf(" address 0x%0x  read data (0x%08x) does  match expected data for posioned tx",cfg_read_seq.iosf_addr,rdata))
          end 


       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70014;})
          rdata = cfg_read_seq.iosf_data;
            if ((rdata ) == 32'h04) begin
            `ovm_error("POISON_SEQ",$psprintf(" address 0x%0x  read data (0x%08x) does  match expected data for posioned tx",cfg_read_seq.iosf_addr,rdata))
          end 
       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h18;})
         rdata = cfg_read_seq.iosf_data;

         if ((rdata ) == 32'h00) begin
            `ovm_error("POISON_SEQ",$psprintf(" address 0x%0x  read data (0x%08x) does  match expected data for posioned tx",cfg_read_seq.iosf_addr,rdata))
          end 


       `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h7001c;})
            rdata = cfg_read_seq.iosf_data;
         if ((rdata ) == 32'h05) begin
            `ovm_error("POISON_SEQ",$psprintf(" address 0x%0x  read data (0x%08x) does  match expected data for posioned tx",cfg_read_seq.iosf_addr,rdata))
          end 

      end


                //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_poison_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                         // end 
     
   
                                                
                   

    
  endtask : body
endclass : back2back_cfgwr_poison_seq
