import lvm_common_pkg::*;


class cfg_genric_seq11 extends ovm_sequence;
  `ovm_sequence_utils(cfg_genric_seq11,sla_sequencer)
   

  string        mode = "";
 

  integer       fd;
  integer       timeoutval;
  int cfg_int;
  bit [63:0]  addr;
   

  hqm_tb_sequences_pkg::hqm_iosf_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "hqm_CFG_SEQ");
    super.new(name);
     $value$plusargs("CFG_MODE=%s",mode);

      if (mode == "") begin
      `ovm_info("CFG_MODE","+CFG_MODE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("CFG_MODE",$psprintf("+CFG_MODE=%s",mode),OVM_LOW)
    end


     endfunction

  virtual task body();
            
     
       bit [31:0]          rdata;
        cfg_packet pkt ;
        pkt = cfg_packet::type_id::create("pkt");
        pkt.constraint_mode(0);
        pkt.default_cfgrd.constraint_mode(1);


                           
              
             
   //----------------------******WRWR random address*****----------------------------//
               // `ifdef WRWR_rand
               if (mode == "WRWR_rand") begin  
              repeat(20) begin
                assert(pkt.randomize());

             fork
     `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
     `ovm_info("CFG_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,cfg_write_seq.iosf_data),OVM_LOW)
     `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr;})
           rdata = cfg_read_seq.iosf_data;
      `ovm_info("CFG_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
         
              join
               end
             end  
             //  `endif             

        
  endtask : body
endclass : cfg_genric_seq11
