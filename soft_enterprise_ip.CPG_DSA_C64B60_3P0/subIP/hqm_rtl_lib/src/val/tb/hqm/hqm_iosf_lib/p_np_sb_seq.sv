import lvm_common_pkg::*;


class p_np_sb_seq extends ovm_sequence;
  `ovm_sequence_utils(p_np_sb_seq,sla_sequencer)
   

  string        file_name = "";
  integer       fd;
  integer       timeoutval;

  hqm_iosf_sb_cfgrd_seq        cfg_read_seq;
  hqm_iosf_sb_cfgwr_seq        cfg_write_seq;
  hqm_iosf_sb_memrd_seq        mem_read_seq;
  hqm_iosf_sb_memwr_seq        mem_write_seq;



  function new(string name = "p_np_sb_seq");
    super.new(name); 
  endfunction

  virtual task body();
       bit [31:0]          rdata;
       //max np credit available
         int  np_cnt ; //max non posted trasaction credit advertised by HQM
      
         //constraint added
        mem_sb_packet pkt1 ;
        cfg_sb_packet pkt ;
 
        pkt = cfg_sb_packet::type_id::create("pkt");
        pkt1 = mem_sb_packet::type_id::create("pkt1");

        //max np_credit is set to 16 while no credit update 
            np_cnt = 16 ;
               
               //---------------------------------------------------------------------------------------------//
           //send Posted transaction once 
            repeat(np_cnt+1)
                    
                       begin
                pkt1.constraint_mode(0);
                pkt1.default_memwr64.constraint_mode(1);
               // pkt.default_data.constraint_mode(1); 
                    assert(pkt.randomize());

       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
       `ovm_do_with(mem_write_seq, {addr == pkt1.mem_addr; wdata == 32'hFFFFFFFF;})
       ///send nonposted cfgrd 
                              
                      pkt.default_cfgwr.constraint_mode(0); 
                          assert(pkt.randomize());
                 `ovm_do_with(cfg_read_seq, {addr == pkt.cfg_addr;})
                `ovm_do_with(cfg_write_seq, {addr == pkt.cfg_addr; wdata == pkt.cfg_data;})

         
         //`ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("cfgwr0: addr=0x%08x wdata=0x%08x",cfg_write_seq.iosf_addr ,pkt.cfg_data),OVM_LOW)
 
                          end

     
                                        
  endtask : body
endclass : p_np_sb_seq
