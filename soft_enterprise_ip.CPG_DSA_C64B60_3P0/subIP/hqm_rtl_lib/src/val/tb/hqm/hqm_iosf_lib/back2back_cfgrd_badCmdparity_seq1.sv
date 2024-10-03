import lvm_common_pkg::*;


class back2back_cfgrd_badCmdparity_seq1 extends ovm_sequence;
  `ovm_sequence_utils(back2back_cfgrd_badCmdparity_seq1,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_prim_cfg_rd_badparity_seq        cfg_read_badparity_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "back2back_cfgrd_badCmdparity_seq1");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
        pkt.default_cfgwr.constraint_mode(0); 
         
               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP cfgrd with BadCmd parity -------------------------------//
                
           repeat(np_cnt+1)
                    begin
                       pkt.driveBadDataParity_c.constraint_mode(0);
                         assert(pkt.randomize());

          `ovm_do_on_with(cfg_read_badparity_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()),{iosf_addr == pkt.cfg_addr; m_driveBadCmdParity == pkt.driveBadCmdParity; m_driveBadDataParity == pkt.driveBadDataParity; m_driveBadDataParityCycle == pkt.driveBadDataParityCycle; m_driveBadDataParityPct == pkt.driveBadDataParityPct; })
                rdata = cfg_read_badparity_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_badparity_seq.iosf_addr ,rdata),OVM_LOW)
                          end 
     
         
    
  endtask : body
endclass : back2back_cfgrd_badCmdparity_seq1
