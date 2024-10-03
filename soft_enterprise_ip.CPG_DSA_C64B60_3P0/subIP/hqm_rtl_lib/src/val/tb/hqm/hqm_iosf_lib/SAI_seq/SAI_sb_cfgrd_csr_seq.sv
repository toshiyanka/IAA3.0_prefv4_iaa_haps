import lvm_common_pkg::*;


class SAI_sb_cfgrd_csr_seq extends ovm_sequence;
  `ovm_sequence_utils(SAI_sb_cfgrd_csr_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_sai_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  function new(string name = "SAI_sb_cfgrd_csr_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //indentify max np credit available and given to np_cnt
         int  np_cnt ; 
      
       
        sai_sb_packet pkt ;
         
        pkt = sai_sb_packet::type_id::create("pkt");
        pkt.constraint_mode(0);

                       //max np_credit is set to 16 while no credit update 
        np_cnt = 20 ;
  
       //--------------send transaction -------------------------------------------------------------//    
                  //repeat(np_cnt+1)
                for (int i=0;i<30;i++)

                       begin
                    pkt.default_cfgrd.constraint_mode(1);

                    //Invalid SAI contraint
                    if($test$plusargs("MODE0"))begin
                       pkt.invalid_sai.constraint_mode(1);  
                      end 

                 if($test$plusargs("MODE1"))begin
                       pkt.invalid_sai1.constraint_mode(1);  
                      end 
 
                       assert(pkt.randomize());
          //`ovm_do_on_with(cfg_read_seq, p_sequencer.pick_sequencer("sideband"), {addr == pkt.cfg_addr;})
          `ovm_do_with(cfg_read_seq, {addr == pkt.cfg_rdaddr;Iosf_sai ==pkt.iosf_sai;})
                       end
                   
                         
                   

       
  endtask : body
endclass : SAI_sb_cfgrd_csr_seq
