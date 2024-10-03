import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_memrd_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_memrd_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  flit_t                        my_ext_headers[];
  rand bit [63:0]               addr;
  bit [31:0]                    rdata;
  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_memrd_seq");
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
    bit [31:0]          cmpdata;
    bit [31:0]          maskdata;
    bit                 do_compare;
    logic[1:0]          cplstatus;

    addr[63:32]        = 0;

    iosf_addr          = new[6];
    iosf_addr[0]       = addr[7:0];
    iosf_addr[1]       = addr[15:8];
    iosf_addr[2]       = addr[23:16];
    iosf_addr[3]       = addr[31:24];
    iosf_addr[4]       = addr[39:32];
    iosf_addr[5]       = addr[47:40];
    get_pid(); 
    `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
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
        fid_i               == 8'h0;
        bar_i               == 3'b010;
        exp_rsp_i           == 1;
        compare_completion_i == 0;
      })

      iosf_tag++;

      if($test$plusargs("BLOCKING_IOSF_MEMRD_TXN"))begin
        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
        cplstatus       = sb_seq.rx_compl_xaction.rsp;

        if(cplstatus == 2'b00) //Successful Completion
          ovm_report_info(get_full_name(), $psprintf("MemRd0 Address=0x%x",addr), OVM_LOW);
        else 
          ovm_report_error(get_full_name(), $psprintf("Memrd0 Address=0x%x   error completion (0x%x)",addr,cplstatus), OVM_LOW);

        if(do_compare) begin
          if ((rdata & maskdata) != cmpdata) begin
            `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x)",opcode,maskdata,addr,rdata,cmpdata))
          end else begin
            `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
          end
        end else begin
          `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
        end
  
        end//args end

        if($test$plusargs("UR_TXN"))begin
        rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
        rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
        rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
        rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
        cplstatus      = sb_seq.rx_compl_xaction.rsp;

         if (cplstatus == 2'b01) //unSuccessful Completion
       ovm_report_info(get_full_name(), $psprintf("MemRd0 Address=0x%x",addr), OVM_LOW);
      else 
        ovm_report_error(get_full_name(), $psprintf("Memrd0 Address=0x%x   error completion (0x%x)",addr,cplstatus), OVM_LOW);
          //end

         
        end//args end


  endtask : body
endclass : hqm_iosf_sb_memrd_seq
