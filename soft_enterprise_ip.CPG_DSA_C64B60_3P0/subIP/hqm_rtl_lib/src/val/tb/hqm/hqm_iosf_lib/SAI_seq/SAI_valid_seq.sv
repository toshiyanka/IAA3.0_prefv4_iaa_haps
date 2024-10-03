import lvm_common_pkg::*;


class SAI_valid_seq extends ovm_sequence;
  `ovm_sequence_utils(SAI_valid_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_sai_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_sai_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_sai_memory_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_sai_memory_wr_seq        mem_write_seq;

  function new(string name = "SAI_valid_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  np_cnt ; //max non posted trasaction credit advertised by HQM
      
         //constraint added
        sai_packet pkt ;
         
        pkt = sai_packet::type_id::create("pkt");
        pkt.constraint_mode(0);
         
              
        //max np_credit is set to 16 while no credit update 
            np_cnt = 20 ;
               
               // repeat(np_cnt+1)begin

        //set constraint
        pkt.default_memwr64.constraint_mode(1);
        pkt.default_cfgwr.constraint_mode(1);
        pkt.default_cfgrd.constraint_mode(1);
        pkt.default_data.constraint_mode(1);
        //pkt.invalid_sai.constraint_mode(1);  
          //send nonposted cfgrd and cfgwr     

                       for (int i =0 ;i <256;i++)begin
                     assert(pkt.randomize());
          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_rdaddr; Iosf_sai == i; })
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
          
          //config write
          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {iosf_addr == pkt.cfg_addr; iosf_data == 32'hFFFF; Iosf_sai == i;})
         
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                      end
         //----------------------------------send memory rd and memory write-----------------------------------------------------------//
                                                      
      /* 
         //---memory read
          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == pkt.mem_addr; Iosf_sai == pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

         //--memory write
        `ovm_create_on(mem_write_seq,p_sequencer.pick_sequencer("primary"))        
        start_item(mem_write_seq);
                        if (!mem_write_seq.randomize() with  {iosf_addr == pkt.mem_addr; iosf_data.size() == 1; iosf_data[0] == 32'hFFFFFFFF; Iosf_sai == pkt.iosf_sai;}) begin
          `ovm_warning("HQM_IOSF_PRIM_FILE_SEQ", "Randomization failed for mem_write_seq");
        end                               
        finish_item(mem_write_seq); */

      //end //repeat end          

                                
  endtask : body
endclass : SAI_valid_seq
