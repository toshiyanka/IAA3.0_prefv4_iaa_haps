import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_cfgrd_brdcast2_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_cfgrd_brdcast2_seq,sla_sequencer)

    static logic [2:0]            iosf_tag = 0;
    rand bit [63:0]          addr;
    rand bit [31:0]          exp_data;
     bit [31:0]          rdata;
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;



  flit_t                        my_ext_headers[];

  iosfsbm_seq::iosf_sb_seq      sb_seq;
  int exp_rsp ;

  function new(string name = "hqm_iosf_sb_cfgrd_brdcast2_seq");
    super.new(name); 
    //timeoutval = 4000;
     
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = 8'h01;                // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;
    exp_rsp = 0;
  endfunction

  
  virtual task body();
    integer             fd;
    integer             code;
    string              opcode;
   // bit [63:0]          addr;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [31:0]          wdata;
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
    logic[1:0] cplstatus;

     
          addr = 64'h000074;

          
        iosf_addr       = new[2];
        iosf_addr[0]    = addr[7:0];
        iosf_addr[1]    = addr[15:8];
        //iosf_addr[2]    = addr[23:16];

    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
        
                     
        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
          { addr_i.size         == iosf_addr.size;
            foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
            eh_i                == 1'b1;
            ext_headers_i.size  == 4;
            foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
            xaction_class_i     == NON_POSTED;
            src_pid_i           == 8'hFE;
            dest_pid_i          == 8'h20;
        local_src_pid_i       == dest_pid[15:8];
        local_dest_pid_i      == src_pid[15:8];
            opcode_i            == OP_CFGRD;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h07;
            bar_i               == 3'b000;
            exp_rsp_i           == 1;
          compare_completion_i == 0;
          })

        iosf_tag++;
              


           



        //expect completion status and resonse data for blocking transaction
        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
        cplstatus      = sb_seq.rx_compl_xaction.rsp;

         if (cplstatus == 2'b00) //Successful Completion
       ovm_report_info(get_full_name(), $psprintf("CfgRd0 Address=0x%x  Data=0x%08x",addr,rdata), OVM_LOW);
      else 
        ovm_report_error(get_full_name(), $psprintf("Cfgrd0 Address=0x%x  Data=0x%08x error completion (0x%x)",addr,rdata,cplstatus), OVM_LOW);
          //end
     
    

       if ((rdata) != 32'h0000291F) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x)",opcode,maskdata,addr,rdata,cmpdata))
          end else begin
            `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
          end
 


        
	
      //end 
     
  endtask : body
endclass : hqm_iosf_sb_cfgrd_brdcast2_seq
