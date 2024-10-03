import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_unsupport_cfgwr_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_unsupport_cfgwr_seq,sla_sequencer)

    static logic [2:0]            iosf_tag = 0;
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;

  flit_t                        my_ext_headers[];

  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_unsupport_cfgwr_seq");
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
    bit [63:0]          addr[2];
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

     wdata = 32'hFFFF_FFF5;
     

          addr[0] = 64'h0000000000058864;
          addr[1] = 64'h000000000007706D;
          addr[2] = 64'h0000000000088774;
                 
         iosf_addr= new[6];

             for (int i=0; i <3 ; i++) begin 
        
        iosf_data = new[4];

        iosf_data[0] = wdata[7:0];
        iosf_data[1] = wdata[15:8];
        iosf_data[2] = wdata[23:16];
        iosf_data[3] = wdata[31:24];

        iosf_addr[0]    = addr[i][7:0];
        iosf_addr[1]    = addr[i][15:8];
        iosf_addr[2]    = addr[i][23:16];
        iosf_addr[3]    = addr[i][31:24];
        iosf_addr[4]    = addr[i][39:32];
        iosf_addr[5]    = addr[i][47:40];
        

    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
             //disable parity constraint
        `ovm_create_on(sb_seq,p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()));     
             //sb_seq.addr_value.constraint_mode(0);
             sb_seq.addr_value.constraint_mode(0);
            sb_seq.addr_size_range.constraint_mode(0);
                         
        `ovm_rand_send_with(sb_seq,{ addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            data_i.size         == iosf_data.size;
            foreach (data_i[j]) data_i[j] == iosf_data[j];
            xaction_class_i     == NON_POSTED;
        src_pid_i           == dest_pid[7:0];
        dest_pid_i          == src_pid[7:0];
        local_src_pid_i       == dest_pid[15:8];
        local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_CFGWR;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h07;
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
           // parity_err_i        == 1; //enable parity error injection
            compare_completion_i == 0;
          })

        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: addr=0x%08x write data=0x%08x",opcode,addr[i],wdata),OVM_LOW)	

        iosf_tag++;


   end

  endtask : body
endclass : hqm_iosf_sb_unsupport_cfgwr_seq
