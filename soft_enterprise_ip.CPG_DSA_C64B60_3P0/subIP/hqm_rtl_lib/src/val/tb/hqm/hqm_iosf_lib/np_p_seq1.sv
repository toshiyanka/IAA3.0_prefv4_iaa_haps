import lvm_common_pkg::*;


class np_p_seq1 extends ovm_sequence;
  `ovm_sequence_utils(np_p_seq1,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "np_p_seq1");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  np_cnt ; //max non_posted trasaction credit advertised by HQM
      
        cfg_packet pkt ; 
        mem_packet pkt1 ;
        pkt1 = mem_packet::type_id::create("pkt");
        pkt = cfg_packet::type_id::create("pkt1");


        //max np_credit is set to 16 while no credit update 
            np_cnt = 16 ;
          


    //------------------send nonposted cfgrd followed by Posted memwr------------------------------//
                       pkt.default_cfgrd.constraint_mode(0);  
                         repeat(np_cnt+1) begin
                       assert(pkt.randomize());
          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == pkt.cfg_data;})
                         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr,cfg_write_seq.iosf_data),OVM_LOW)
                          end 


        //------------------------send  P memwr32 once np transaction are blocked -------------------------------//

        repeat(5) begin

                       pkt1.default_memwr64.constraint_mode(0);
                       assert(pkt1.randomize());
         `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt1.mem_addr;})      
        // `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memwr64: addr=0x%08x wdata=0x%08x",mem_write_seq.iosf_addr ,mem_write_seq.iosf_data),OVM_LOW)
                           end 

         
         
  endtask : body
endclass : np_p_seq1
