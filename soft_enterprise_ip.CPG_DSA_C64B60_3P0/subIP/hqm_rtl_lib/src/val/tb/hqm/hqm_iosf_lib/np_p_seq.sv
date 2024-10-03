import lvm_common_pkg::*;


class np_p_seq extends ovm_sequence;
  `ovm_sequence_utils(np_p_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "np_p_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  np_cnt ; //max non posted trasaction credit advertised by HQM
      
         //constraint added
        mem_packet pkt1 ;
        cfg_packet pkt ;
 
        pkt = cfg_packet::type_id::create("pkt");
        pkt1 = mem_packet::type_id::create("pkt1");

        //max np_credit is set to 16 while no credit update 
            np_cnt = 16 ;
               
        //------------------------send more P memwr32 than available credit -------------------------------//


        ///send nonposted cfgrd 
                       pkt.default_cfgwr.constraint_mode(0);  
                         repeat(np_cnt+1) begin
                       assert(pkt.randomize());
          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                          end 
          //---------------------------------------------------------------------------------------------//
           //send Posted transaction once np is blocked
        repeat(5) begin

                       pkt1.default_memwr64.constraint_mode(0);
                       assert(pkt1.randomize());
         `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt1.mem_addr; })      
        // `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memwr64: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data),OVM_LOW)
                           end 

                                
  endtask : body
endclass : np_p_seq
