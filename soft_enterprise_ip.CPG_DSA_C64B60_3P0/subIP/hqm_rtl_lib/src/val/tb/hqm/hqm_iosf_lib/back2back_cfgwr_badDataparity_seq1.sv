import lvm_common_pkg::*;


class back2back_cfgwr_badDataparity_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgwr_badDataparity_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_badparity_seq        cfg_read_badparity_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_wr_badparity_seq        cfg_write_badparity_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_cfgwr_badDataparity_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
        pkt.constraint_mode(0);
        pkt.default_cfgwr.constraint_mode(1);
        pkt.driveBadDataParity_c.constraint_mode(1);
        pkt.driveBadCmdParity_c.constraint_mode(0);
 
  
               //max np_credit is set to 16 while no credit update 
        np_cnt = 1 ;
  
           
       

       //parity enable signal in device command
        `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h04; iosf_data == 32'h00100040;})

        //disable the mask        
       `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h150; iosf_data == 32'h00400000;})
         
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)


       //------------------------------------send NP cfgwr with Bad Data parity--------------------------------------------------------------//    
           
               repeat(np_cnt+1)
                    
                       begin
                                    assert(pkt.randomize());
                           
       `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h18; iosf_data == 32'h00; m_driveBadCmdParity == pkt.driveBadCmdParity;
       m_driveBadDataParity == pkt.driveBadDataParity; m_driveBadDataParityCycle == pkt.driveBadDataParityCycle; m_driveBadDataParityPct == pkt.driveBadDataParityPct;})
         
                 
         `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h1c; iosf_data == 32'h02; m_driveBadCmdParity == pkt.driveBadCmdParity;
       m_driveBadDataParity == pkt.driveBadDataParity; m_driveBadDataParityCycle == pkt.driveBadDataParityCycle; m_driveBadDataParityPct == pkt.driveBadDataParityPct;})
         
        
         
       `ovm_do_on_with(cfg_write_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == pkt.cfg_data; m_driveBadCmdParity == pkt.driveBadCmdParity;
       m_driveBadDataParity == pkt.driveBadDataParity; m_driveBadDataParityCycle == pkt.driveBadDataParityCycle; m_driveBadDataParityPct == pkt.driveBadDataParityPct;})
        
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_badparity_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)

         

       // `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h18; })
        //`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h1c; })

                          end

//--------------------------------------------------------------------------------------------------------------------//     
   
                                                
                   

    
  endtask : body
endclass : back2back_cfgwr_badDataparity_seq
