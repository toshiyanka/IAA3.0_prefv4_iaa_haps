import lvm_common_pkg::*;


class mix_cfg_mem_seq extends ovm_sequence;
  `ovm_sequence_utils(mix_cfg_mem_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
   hqm_tb_sequences_pkg::hqm_iosf_config_rd_rqid_seq        cfg_read_rqid_seq;

  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
   hqm_tb_sequences_pkg::hqm_iosf_config_wr_rqid_seq        cfg_write_rqid_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  //hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_memwr_seq        mem_write_seq;
   hqm_tb_sequences_pkg::hqm_iosf_sb_memwr_np_seq1        npmem_wr_seq;



  function new(string name = "mix_cfg_mem_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
       cfg_packet pkt ;
        mem_sb_packet sb_pkt ;

       pkt = cfg_packet::type_id::create("pkt");
       sb_pkt = mem_sb_packet::type_id::create("sb_pkt");
          

          
               //max np_credit is set to 16 while no credit update 
        np_cnt = 96 ;
  
           
        //------------------------send more NP cfgwr than available credit -------------------------------//
  if($test$plusargs("CFG_MEMWR_TXN"))begin 
           repeat(np_cnt+1)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1);
                             assert(pkt.randomize());
               sb_pkt.constraint_mode(0);
               sb_pkt.default_memwr64.constraint_mode(1);
                              assert(sb_pkt.randomize());

                               fork 
                                    //send cfgwr on primary and memwr_on sideband 
                  `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h0000003c; iosf_data == 32'hFF;})
                  `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
                         //send parallely memwr on sideband    
                    `ovm_do_with(mem_write_seq, {addr == sb_pkt.mem_addr; wdata == 32'hFFFFFFFF;})
                          join
 
                        end

                      end  


        //-----------------------------------------------------------------------------------------------------------------//   
         if($test$plusargs("CFG_NPMEMWR_TXN"))begin              
               repeat(np_cnt+1)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_cfgwr.constraint_mode(1);
                pkt.default_data.constraint_mode(1);
                             assert(pkt.randomize());
               sb_pkt.constraint_mode(0);
               sb_pkt.default_memwr64.constraint_mode(1);
                              assert(sb_pkt.randomize());

                               fork 
                                    //send cfgwr on primary and memwr_on sideband 
                  `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == 64'h0000003c; iosf_data == 32'hFF;})
                  `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
                         //send parallely np_memwr on sideband    
                    `ovm_do_with(npmem_wr_seq, {addr == sb_pkt.mem_addr; wdata == 32'hFFFFFFFF;})
                          join
 
                        end
                  end      
       //----------------------------------------------------------------------------------------------------------------------------------------------//                 
                                                
                   

    
  endtask : body
endclass : mix_cfg_mem_seq
