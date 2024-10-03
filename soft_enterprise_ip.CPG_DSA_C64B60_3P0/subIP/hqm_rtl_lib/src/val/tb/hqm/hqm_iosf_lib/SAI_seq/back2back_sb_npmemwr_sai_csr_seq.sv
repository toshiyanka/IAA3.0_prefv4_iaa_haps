import lvm_common_pkg::*;


class back2back_sb_memwr_sai_csr_seq extends ovm_sequence;
  `ovm_sequence_utils(back2back_sb_memwr_sai_csr_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_sb_npmemwr_sai_seq        mem_write_seq;

  function new(string name = "back2back_sb_memwr_sai_csr_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available for HQM (np buffer size ) and given to no_cnt
         int  np_cnt ; 
      
        sai_sb_packet pkt ;
        pkt = sai_sb_packet::type_id::create("pkt");
          
               //max np_credit is set to 16 while no credit update 
        np_cnt = 16 ;
  
           
        //------------------------send more NP memwr than available credit -------------------------------//

           repeat(np_cnt+1)
                    
                       begin
                pkt.constraint_mode(0);
                pkt.default_memwr64.constraint_mode(1);
               // pkt.default_data.constraint_mode(1);


               if($test$plusargs("MODE0"))begin
                       pkt.invalid_sai.constraint_mode(1);  
                        end  

                if($test$plusargs("MODE1"))begin
                      pkt.invalid_sai1.constraint_mode(1);  
                  end

                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == 64'h008000080; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000524; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000520; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000514; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000518; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000510; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000500; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h00000050c; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h00000051c; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

         `ovm_do_with(mem_write_seq, {addr == 64'h000000314; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})

       `ovm_do_with(mem_write_seq, {addr == 64'h000000310; wdata == 32'hFFFFFFFF;Iosf_sai == pkt.iosf_sai;})



         
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                          end 
     
                      
                                                
                   

    
  endtask : body
endclass : back2back_sb_memwr_sai_csr_seq
