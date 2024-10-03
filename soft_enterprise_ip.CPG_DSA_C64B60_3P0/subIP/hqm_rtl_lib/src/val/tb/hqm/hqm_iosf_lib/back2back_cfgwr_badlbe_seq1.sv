import lvm_common_pkg::*;


class back2back_cfgwr_badlbe_seq1 extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgwr_badlbe_seq1,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_URlbe_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_URlbe_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_cfgwr_badlbe_seq1");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
          
               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP cfgwr than available credit -------------------------------//
       if($test$plusargs("CFGWR_TXN"))begin
    
       
        for (int i=1;i<16;i++)begin
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());
             //check the scenario with single badtxn_seq
  `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70010; iosf_data == pkt.cfg_data;lbe == i;})
        
 `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70014; iosf_data == pkt.cfg_data;lbe == i;})
 `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70018; iosf_data == pkt.cfg_data; lbe == i;})
 `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h7001c; iosf_data == pkt.cfg_data; lbe == i;})
 end

 end
  
//----------------------------------------------------------------------------------------------------------------------------------------------// 
    if($test$plusargs("CFGRD_TXN"))begin

        for (int i=1;i<16;i++)begin
                pkt.constraint_mode(0);
                pkt.default_cfgrd.constraint_mode(1);
                //pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());
             //check the scenario with single badtxn_seq
  `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70010;lbe == i;})
        
 `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70014;lbe == i;})
 `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h70018; lbe == i;})
 `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h7001c; lbe == i;})
         end

       end

//----------------------------------------------------------------------------------------------------------------------------------------------------//
  endtask : body
endclass : back2back_cfgwr_badlbe_seq1
