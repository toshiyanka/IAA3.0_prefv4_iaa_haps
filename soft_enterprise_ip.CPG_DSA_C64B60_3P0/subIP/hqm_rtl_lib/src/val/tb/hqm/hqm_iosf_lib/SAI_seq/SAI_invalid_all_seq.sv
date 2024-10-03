import lvm_common_pkg::*;


class SAI_invalid_all_seq extends ovm_sequence;
  `ovm_sequence_utils(SAI_invalid_all_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_sai_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_sai_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_sai_memory_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_sai_memory_wr_seq        mem_write_seq;

  function new(string name = "SAI_invalid_all_seq");
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
       // pkt.default_memwr64.constraint_mode(1);
        pkt.default_cfgwr.constraint_mode(1);
        pkt.default_cfgrd.constraint_mode(1);
        pkt.default_data.constraint_mode(1);
        //pkt.invalid_sai.constraint_mode(1);  
          //send nonposted cfgrd and cfgwr     

                       for (int i =0 ;i <256;i++)begin
                     assert(pkt.randomize());
                     //send cfgrd with invalid SAI
          `ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == pkt.cfg_rdaddr; Iosf_sai == i; })
                rdata = cfg_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgrd0: addr=0x%08x rdata=0x%08x",cfg_read_seq.iosf_addr ,rdata),OVM_LOW)
                   
         //https://hsdes.intel.com/resource/1405775127..as per HQM (hqm_system) Modify PCIe CFG SAI access denial behavior 
          if (rdata != 32'h00000000)begin
             `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata))
                        end
 
          //config write with invalid SAI
          `ovm_do_on_with(cfg_write_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == pkt.cfg_addr; iosf_data == 32'hFFFF; Iosf_sai == i;})
         
         `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                      end
               

                                
  endtask : body
endclass : SAI_invalid_all_seq
