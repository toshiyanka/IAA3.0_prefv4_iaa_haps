import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_epspec_opcode_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_epspec_opcode_seq,sla_sequencer)

  static logic [2:0]         iosf_tag = 0;
  bit [63:0]                 addr;
  flit_t                     my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq   sb_seq;
  int                        exp_rsp;

  function new(string name = "hqm_iosf_sb_epspec_opcode_seq");
    super.new(name); 
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = `HQM_VALID_SAI;                // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;
  endfunction

  virtual task body();
    string              opcode;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    logic[1:0]          cplstatus;
     
    addr = cfg_addr0;
    iosf_addr       = new[2];
    iosf_addr[0]    = addr[7:0];
    iosf_addr[1]    = addr[15:8];
        
    exp_rsp = 1;

    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_mask", 'h0000_4000);
    WriteReg("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  'h0044_1000);
    get_pid();
    `ovm_create_on(sb_seq,p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()));  
    `ovm_rand_send_with(sb_seq, 
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == 8'h1F;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            bar_i               == 3'b000;
            exp_rsp_i           == exp_rsp;
          compare_completion_i == 0;
          })

        iosf_tag++;
        cplstatus      = sb_seq.rx_compl_xaction.rsp;

        if(cplstatus == 2'b01) //Successful Completion
          ovm_report_info(get_full_name(), $psprintf("Received UR for non-supported opcode as expected"), OVM_LOW);
        else 
          ovm_report_error(get_full_name(), $psprintf("Expecting UR for non-supported opcode. Received 0x%0x", cplstatus), OVM_LOW);

        `ovm_rand_send_with(sb_seq, 
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == 8'h6F;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            bar_i               == 3'b000;
            exp_rsp_i           == exp_rsp;
          compare_completion_i == 0;
          })

        iosf_tag++;
        cplstatus      = sb_seq.rx_compl_xaction.rsp;

        if(cplstatus == 2'b01) //Successful Completion
          ovm_report_info(get_full_name(), $psprintf("Received UR for non-supported opcode as expected"), OVM_LOW);
        else 
          ovm_report_error(get_full_name(), $psprintf("Expecting UR for non-supported opcode. Received 0x%0x", cplstatus), OVM_LOW);

        `ovm_rand_send_with(sb_seq, 
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == dest_pid[7:0];
            dest_pid_i          == src_pid[7:0];
            local_src_pid_i       == dest_pid[15:8];
            local_dest_pid_i      == src_pid[15:8];
            opcode_i            == 8'hA0;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            bar_i               == 3'b000;
            exp_rsp_i           == exp_rsp;
          compare_completion_i == 0;
          })

        cplstatus      = sb_seq.rx_compl_xaction.rsp;

        if(cplstatus == 2'b01) //Successful Completion
          ovm_report_info(get_full_name(), $psprintf("Received UR for non-supported opcode as expected"), OVM_LOW);
        else 
          ovm_report_error(get_full_name(), $psprintf("Expecting UR for non-supported opcode. Received 0x%0x", cplstatus), OVM_LOW);

  endtask : body
endclass
