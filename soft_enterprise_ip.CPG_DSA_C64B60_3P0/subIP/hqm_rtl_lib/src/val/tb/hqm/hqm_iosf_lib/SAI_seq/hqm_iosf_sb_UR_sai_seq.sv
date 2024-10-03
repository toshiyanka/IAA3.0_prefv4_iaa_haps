import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_UR_sai_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_UR_sai_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  randc logic [7:0]             Iosf_sai;
  flit_t                        my_ext_headers[];
  rand bit [63:0]               addr;
  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_UR_sai_seq");
    super.new(name); 
    my_ext_headers      = new[4];
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
 
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = Iosf_sai[7:0]; 
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;

    addr = cfg_addr0;

    iosf_addr          = new[2];
    iosf_addr[0]       = addr[7:0];
    iosf_addr[1]       = addr[15:8];
    
    get_pid();

    if($test$plusargs("IORD_TXN"))begin
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
        opcode_i            == OP_IORD;
        tag_i               == iosf_tag;
        fbe_i               == 4'hf;
        sbe_i               == 4'h0;
        fid_i               == 8'h00;
        bar_i               == 3'b010;
        exp_rsp_i           == 1;
        compare_completion_i == 0;
      })
    end

    if($test$plusargs("IORD_SAI_TXN"))begin
      for (int i=0 ;i <256;i++)begin
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
          opcode_i            == OP_IORD;
          tag_i               == iosf_tag;
          fbe_i               == 4'hf;
          sbe_i               == 4'h0;
          fid_i               == 8'h0;
          bar_i               == 3'b010;
          exp_rsp_i           == 1;
          compare_completion_i == 0;
        })
      end 
    end

    if($test$plusargs("CRRD_TXN"))begin
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
        opcode_i            == OP_CRRD;
        tag_i               == iosf_tag;
        fbe_i               == 4'hf;
        sbe_i               == 4'h0;
        fid_i               == 8'h0;
        bar_i               == 3'b010;
        exp_rsp_i           == 1;
        compare_completion_i == 0;
      })
    end

    iosf_tag++;

    rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
    rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
    rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
    rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
    cplstatus      = sb_seq.rx_compl_xaction.rsp;
      
    if(cplstatus == 2'b01) //unSuccessful Completion
      ovm_report_info(get_full_name(), $psprintf("Received UR as expected for Address=0x%x  Data=0x%08x",addr,rdata), OVM_LOW);
    else 
      ovm_report_error(get_full_name(), $psprintf("Expecting UR for unsupported request to HQM for Address=0x%x  Data=0x%08x error completion (0x%x)",addr,rdata,cplstatus), OVM_LOW);

    if(do_compare) begin
      if((rdata & maskdata) != cmpdata) begin
        `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) does not match write data (0x%08x)",opcode,maskdata,addr,rdata,cmpdata))
      end else begin
        `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: address 0x%0x mask (0x%08x) read data (0x%08x) matches expected value (0x%08x)",opcode,maskdata,addr,rdata,cmpdata),OVM_LOW)
      end
    end else begin
      `ovm_info("IOSF_SB_FILE_SEQ",$psprintf("%s: addr=0x%08x rdata=0x%08x",opcode,addr,rdata),OVM_LOW)
    end

  endtask : body
endclass : hqm_iosf_sb_UR_sai_seq
