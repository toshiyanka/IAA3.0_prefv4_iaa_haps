import lvm_common_pkg::*;


class SAI_UR_seq extends ovm_sequence;
  `ovm_sequence_utils(SAI_UR_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_sai_config_rd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_sai_config_wr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_sai_memory_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_sai_memory_wr_seq        mem_write_seq;

  function new(string name = "SAI_UR_seq");
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
               
                repeat(np_cnt+1)begin

        //set constraint
        pkt.default_memwr64.constraint_mode(1);
        pkt.default_cfgwr.constraint_mode(1);

      if($test$plusargs("MODE0"))begin
        pkt.invalid_sai.constraint_mode(1);  
      end  

      if($test$plusargs("MODE1"))begin
        pkt.invalid_sai1.constraint_mode(1);  
      end
          //send nonposted cfgrd and cfgwr       
                     assert(pkt.randomize());
//----------------------------------send memory rd and memory write-----------------------------------------------------------//
               //---memory read with valid sai

         /*`ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h200000610; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)*/

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h300000300; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

         `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h400000304; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)
                       
            `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h500000310; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h600001000; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

           `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h700000308; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

          
          `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h000001004; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

         `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h800001008; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)

           
         `ovm_do_on_with(mem_read_seq, p_sequencer.pick_sequencer("primary"), {iosf_addr == 64'h90000100C; Iosf_sai ==  pkt.iosf_sai;})
                rdata = mem_read_seq.iosf_data;
          `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("memrd0: addr=0x%08x rdata=0x%08x",mem_read_seq.iosf_addr ,rdata),OVM_LOW)


                end //repeat end  


            endtask : body
endclass : SAI_UR_seq
