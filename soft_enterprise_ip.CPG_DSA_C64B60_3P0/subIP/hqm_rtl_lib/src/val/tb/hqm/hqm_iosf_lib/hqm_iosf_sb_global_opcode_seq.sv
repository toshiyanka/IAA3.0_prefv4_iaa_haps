import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_global_opcode_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_global_opcode_seq,sla_sequencer)

   static logic [2:0]           iosf_tag = 0;
   rand bit [63:0]              addr;
   rand bit [31:0]              wdata;
   rand bit [7:0]               common_opcode;
   flit_t                       my_ext_headers[];
   iosfsbm_seq::iosf_sb_seq     sb_seq;

   function new(string name = "hqm_iosf_sb_global_opcode_seq");
     super.new(name); 
     my_ext_headers      = new[4];
     my_ext_headers[0]   = 8'h00;
     my_ext_headers[1]   = `HQM_VALID_SAI;      // Set SAI
     my_ext_headers[2]   = 8'h00;
     my_ext_headers[3]   = 8'h00;
   endfunction
  
   virtual task body();
    iosfsbm_cm::flit_t    iosf_addr[];
    iosfsbm_cm::flit_t    iosf_data[];
    bit [31:0]            rdata;
    logic[1:0]            cplstatus;

    wdata                 = 32'hFFFF_FFFF;
    addr                  = cfg_addr0;
                 
    iosf_addr             = new[2];
    iosf_addr[0]          = addr[7:0];
    iosf_addr[1]          = addr[15:8];
        
    iosf_data             = new[4];
    iosf_data[0]          = wdata[7:0];
    iosf_data[1]          = wdata[15:8];
    iosf_data[2]          = wdata[23:16];
    iosf_data[3]          = wdata[31:24];


    WriteReg("hqm_pf_cfg_i", "aer_cap_corr_err_mask",  'h0000_4000);    
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev", 'h004C_1000);    
    get_pid();
    for(int i=137;i<149;i++)begin
      `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
      { addr_i.size         == iosf_addr.size;
        foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
        eh_i                == 1'b1;
        ext_headers_i.size  == 4;
        foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
        data_i.size         == iosf_data.size;
        foreach (data_i[j]) data_i[j] == iosf_data[j];
        xaction_class_i     == POSTED;
        src_pid_i           == dest_pid[7:0];
        dest_pid_i          == src_pid[7:0];
        local_src_pid_i       == dest_pid[15:8];
        local_dest_pid_i      == src_pid[15:8];
        opcode_i            == i;
        tag_i               == iosf_tag;
        fbe_i               == 4'hf;
        sbe_i               == 4'h0;
        fid_i               == 8'h0;
        misc_i              == 4'h0;
        exp_rsp_i           == 1;
        compare_completion_i == 0;
      })
    end

    if($test$plusargs("GLOBAL_TXN"))begin
      ReadReg("hqm_pf_cfg_i", "cache_line_size",SLA_FALSE, rdata);    
      if(rdata != 'h0)
      `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0x0",rdata))

      ReadReg("hqm_system_csr", "msix_64_synd", SLA_FALSE, rdata);    
      if(rdata != 'h0)
      `ovm_error("back2back_sb_unsupport_sai_seq",$psprintf("Read data 0x%0x does not match expected data 0x0",rdata))
    end  


  endtask : body
endclass : hqm_iosf_sb_global_opcode_seq
