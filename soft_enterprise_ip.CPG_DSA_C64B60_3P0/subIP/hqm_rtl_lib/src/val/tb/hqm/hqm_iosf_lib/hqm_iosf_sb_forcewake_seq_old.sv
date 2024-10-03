import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_forcewake_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_forcewake_seq,sla_sequencer)

    static logic [2:0]            iosf_tag = 0;

  flit_t                        my_ext_headers[];

  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_forcewake_seq");
    super.new(name); 
    //timeoutval = 4000;
     
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = 8'h01;                // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;
  endfunction

  
  virtual task body();
    integer             fd;
    integer             code;
    string              opcode;
    bit [63:0]          addr;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [31:0]          wdata;
    bit [31:0]          rdata;
    bit [31:0]          cmpdata;
    bit [31:0]          maskdata;
    bit                 do_compare;
    int                 polldelay;
    integer             poll_cnt;
    string              input_line;
    string              line;
    string              token;
    bit [63:0]          int_tokens_q[$];
    string              msg;

     wdata = 32'hFFFF_FFFF;
     addr = 64'h0000000000000310;

          iosf_addr          = new[6];
        iosf_addr[0]       = addr[7:0];
        iosf_addr[1]       = addr[15:8];
        iosf_addr[2]       = addr[23:16];
        iosf_addr[3]       = addr[31:24];
        iosf_addr[4]       = addr[39:32];
        iosf_addr[5]       = addr[47:40];

        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == POSTED;
            src_pid_i           == 8'h01;
            dest_pid_i          == 8'h21;
            opcode_i            == 8'h2E;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h00;
            parity_err_i        == 0; 
            compare_completion_i == 0;
          })

        iosf_tag++;

         


  endtask : body
endclass : hqm_iosf_sb_forcewake_seq
