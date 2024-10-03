import lvm_common_pkg::*;


class back2back_cfgrd_param_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgrd_param_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_cfgrd_param_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
        // int  np_cnt ; 
      
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
                       //max np_credit is set to 16 while no credit update 
       // np_cnt = 16 ;
  
           
        //------------------------send more NP cfgrd than available credit -------------------------------//

           repeat(pkt.np_cnt+1)
                

                       begin
                       pkt.constraint_mode(0);
                       pkt.default_cfgrd.constraint_mode(1);   
                       assert(pkt.randomize());

          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end 
     
   
                                                
                   

    
  endtask : body
endclass : back2back_cfgrd_param_seq
