import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_memrd_sai_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_iosf_sb_memrd_sai_seq,sla_sequencer)

    static logic [2:0]            iosf_tag = 0;

  flit_t                        my_ext_headers[];
  rand bit [63:0]          addr;
 rand logic [7:0]      Iosf_sai;
  bit [15:0]               src_pid;
  bit [15:0]               dest_pid;


  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_memrd_sai_seq");
    super.new(name); 
    //timeoutval = 4000;
     
    my_ext_headers      = new[4];
   endfunction

  
  virtual task body();
    integer             fd;
    integer             code;
    string              opcode;
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
    logic[1:0] cplstatus;


     wdata = 32'hFFFF_FFFF;
     //addr = 64'h0000000000000310;


     //header 
    my_ext_headers[0]   = 8'h00; 
    my_ext_headers[1]   = Iosf_sai[7:0];        // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;


          iosf_addr          = new[6];
        iosf_addr[0]       = addr[7:0];
        iosf_addr[1]       = addr[15:8];
        iosf_addr[2]       = addr[23:16];
        iosf_addr[3]       = addr[31:24];
        iosf_addr[4]       = addr[39:32];
        iosf_addr[5]       = addr[47:40];
    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)

        `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer("sideband"),
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
            opcode_i            == OP_MRD;
            tag_i               == iosf_tag;
            fbe_i               == 4'hf;
            sbe_i               == 4'h0;
            fid_i               == 8'h07;
            bar_i               == 3'b010;
            exp_rsp_i           == 1;
            compare_completion_i == 0;
          })

        iosf_tag++;
 
        //expect completion status and resonse data for blocking transaction
           if($test$plusargs("BLOCKING_IOSF_CFGRD_TXN"))begin
        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
       cplstatus      = sb_seq.rx_compl_xaction.rsp;

         if (cplstatus == 2'b00) //Successful Completion
       ovm_report_info(get_full_name(), $psprintf("MemRd0 Address=0x%x  Data=0x%08x",addr,rdata), OVM_LOW);
      else 
        ovm_report_error(get_full_name(), $psprintf("MEmrd0 Address=0x%x  Data=0x%08x error completion (0x%x)",addr,rdata,cplstatus), OVM_LOW);
          //end
           end 

 if($test$plusargs("UR_TXN"))begin
        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
        cplstatus      = sb_seq.rx_compl_xaction.rsp;

         if (cplstatus == 2'b01) //unuccessful Completion
       ovm_report_info(get_full_name(), $psprintf("MEMRd0 Address=0x%x  Data=0x%08x",addr,rdata), OVM_LOW);
      else 
        ovm_report_error(get_full_name(), $psprintf("MEMrd0 Address=0x%x  Data=0x%08x error completion (0x%x)",addr,rdata,cplstatus), OVM_LOW);
          //end
     
     end  

   if($test$plusargs("DENIED_SAI_TXN"))begin
        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
       cplstatus      = sb_seq.rx_compl_xaction.rsp;

         if (cplstatus == 2'b00) //Successful Completion
       ovm_report_info(get_full_name(), $psprintf("MemRd0 Address=0x%x  Data=0x%08x",addr,rdata), OVM_LOW);
      else 
        ovm_report_error(get_full_name(), $psprintf("MEmrd0 Address=0x%x  Data=0x%08x error completion (0x%x)",addr,rdata,cplstatus), OVM_LOW);
          //end


          if (rdata[31:0] != 32'h00000000)begin
        `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) ",rdata[31:0]))
       end
     
     end



        

  endtask : body
endclass : hqm_iosf_sb_memrd_sai_seq
