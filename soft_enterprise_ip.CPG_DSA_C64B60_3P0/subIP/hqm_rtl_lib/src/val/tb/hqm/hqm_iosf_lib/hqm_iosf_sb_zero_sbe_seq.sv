import lvm_common_pkg::*;

class hqm_iosf_sb_zero_sbe_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_zero_sbe_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  flit_t                        my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq      sb_seq;

  function new(string name = "hqm_iosf_sb_zero_sbe_seq");
    super.new(name); 
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = `HQM_VALID_SAI;                // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;
  endfunction

  virtual task body();
    bit [63:0]          rdata;
    iosfsbm_cm::flit_t  iosf_addr[];
    logic[1:0]          cplstatus;

    mem_addr0[63:32] = 0;
    addr             = mem_addr0;   
       
    iosf_addr      = new[6];
    iosf_addr[0]   = addr[7:0];
    iosf_addr[1]   = addr[15:8];
    iosf_addr[2]   = addr[23:16];
    iosf_addr[3]   = addr[31:24];
    iosf_addr[4]   = addr[39:32];
    iosf_addr[5]   = addr[47:40];
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
      rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
      rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
      rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
      rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
      rdata[39:32]    = sb_seq.rx_compl_xaction.data[4];
      rdata[47:40]    = sb_seq.rx_compl_xaction.data[5];
      rdata[55:48]    = sb_seq.rx_compl_xaction.data[6];
      rdata[63:56]    = sb_seq.rx_compl_xaction.data[7];
      cplstatus       = sb_seq.rx_compl_xaction.rsp;

      if(rdata[63:0] != 'h100)  
        ovm_report_error(get_full_name(), $psprintf("Data mismatch. Read data is 0x%0x, Expected data is 'h100", rdata), OVM_LOW);
      else 
        ovm_report_info(get_full_name(), $psprintf("Data received is as expected"), OVM_LOW);

      if(cplstatus == 2'b00) //Successful Completion
        ovm_report_info(get_full_name(), $psprintf("Successful completion received for address=0x%x",mem_addr0), OVM_LOW);
      else 
        ovm_report_error(get_full_name(), $psprintf("Unsuccessful completion received for address=0x%x   error completion (0x%x)",mem_addr0,cplstatus), OVM_LOW);

  endtask : body
endclass : hqm_iosf_sb_zero_sbe_seq
