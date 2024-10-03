import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_unsupported_memwr_np_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_unsupported_memwr_np_seq,sla_sequencer)

  static logic [2:0]   iosf_tag = 0;
  rand bit [31:0]      wdata;

  function new(string name = "hqm_iosf_sb_unsupported_memwr_np_seq");
    super.new(name); 
  endfunction
  
  virtual task body();
    string              opcode;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [31:0]          rdata;
    bit [31:0]          cmpdata;
    bit [31:0]          maskdata;
    bit                 do_compare;
    logic[1:0]          cplstatus;
    int                 bar;
    int                 fid;
    bit [31:0]          actual_data; 
    static logic [2:0]  iosf_tag = 0;

    wdata = 32'hFFFF_CCDD;
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);
    get_pid();
    

    foreach(reg_list[i]) begin
        `ovm_info("hqm_iosf_sb_unsupported_memwr_np_seq",$psprintf("Register name is %s", reg_list[i].get_name()),OVM_LOW)

        reg_addr = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(), reg_list[i]);
        `ovm_info("hqm_iosf_sb_unsupported_memwr_np_seq",$psprintf("Register address is 0x%0x ", reg_addr),OVM_LOW)

        bar = reg_list[i].get_bar("MEM-SB");
        fid = reg_list[i].get_fid("MEM-SB");

        for(int i = 26; i < 48; i++) begin
            case(bar)
                'h2:  begin
                          if(i < 32)    
                              continue;
                          reg_addr[47:32] = 0;
                          reg_addr[i]     = 1;
                       end
                'h0:  begin       
                          reg_addr[47:26] = 0;
                          reg_addr[i]     = 1;
                      end     
             endcase        

            send_command(reg_list[i],MemWr,NON_POSTED, reg_addr,wdata, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
            send_command(reg_list[i],MemRd,NON_POSTED, reg_addr,wdata, iosf_tag, bar, fid,.fbe(4'hf),.sbe(0),.exp_rsp(1),.compare_completion(0),.rsp(1),.actual_data(0));
 //check posted scenario and update   
 //check for posted write scenario and add the posted scenario
        end
    end    
  endtask : body
endclass : hqm_iosf_sb_unsupported_memwr_np_seq
