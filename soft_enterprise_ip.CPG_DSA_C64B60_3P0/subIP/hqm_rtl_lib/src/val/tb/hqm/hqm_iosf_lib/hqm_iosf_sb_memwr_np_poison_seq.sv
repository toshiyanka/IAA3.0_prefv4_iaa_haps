import lvm_common_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_iosf_sb_memwr_np_poison_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_memwr_np_poison_seq,sla_sequencer)

  static logic [2:0]            iosf_tag = 0;
  flit_t                        my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq      sb_seq;
  hqm_sla_pcie_init_seq         pcie_init;
  mem_generic_seq               rd_wr_seq;
  hqm_reset_init_sequence       warm_reset;

  function new(string name = "hqm_iosf_sb_memwr_np_poison_seq");
    super.new(name); 
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = `HQM_VALID_SAI;                // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;
  endfunction

  virtual task body();
    bit [63:0]          addr;
    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
    bit [31:0]          wdata;
    bit [31:0]          rdata;
    logic[1:0] cplstatus;

    wdata = 32'hFFFF_FFFF;
    mem_addr0[63:32] = 0;
    addr  = mem_addr0;
                 
    iosf_addr          = new[6];
    iosf_addr[0]       = addr[7:0];
    iosf_addr[1]       = addr[15:8];
    iosf_addr[2]       = addr[23:16];
    iosf_addr[3]       = addr[31:24];
    iosf_addr[4]       = addr[39:32];
    iosf_addr[5]       = addr[47:40];

    iosf_data = new[4];
    iosf_data[0] = wdata[7:0];
    iosf_data[1] = wdata[15:8];
    iosf_data[2] = wdata[23:16];
    iosf_data[3] = wdata[31:24];

    WriteReg("hqm_pf_cfg_i", "func_bar_l", 'h00);    
    WriteReg("hqm_pf_cfg_i", "func_bar_u", 'h00);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_l", 'h00);    
    WriteReg("hqm_pf_cfg_i", "csr_bar_u", 'h02);    
    get_pid();
    `ovm_create_on(sb_seq,p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()));  
    sb_seq.parity_err_con.constraint_mode(0);

    `ovm_rand_send_with(sb_seq,{ addr_i.size   == iosf_addr.size;
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
      opcode_i            == OP_MWR;
      tag_i               == iosf_tag;
      fbe_i               == 4'hf;
      sbe_i               == 4'h0;
      fid_i               == 8'h0;
      bar_i               == 3'b010;
      exp_rsp_i           == 0;
      parity_err_i        == 1; //enable parity error injection
      compare_completion_i == 0;
   })
   iosf_tag++;

   `ovm_do(rd_wr_seq);
   `ovm_do(warm_reset);
   `ovm_do(pcie_init)

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
          rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
          rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
          rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
          rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
          cplstatus      = sb_seq.rx_compl_xaction.rsp;
          if(cplstatus == 2'b00) begin //Successful Completion
            ovm_report_info(get_full_name(), $psprintf("MemRd0 Address=0x%x",addr), OVM_LOW);
            if(rdata == wdata) begin
              `ovm_error(get_full_name(),$psprintf("Parity injected on IOSF SB. For address 0x%0x read data (0x%08x) does match error transaction write data (0x%08x)",addr,rdata,wdata))
            end
          end   
          else begin 
            ovm_report_error(get_full_name(), $psprintf("Memrd0 Address=0x%x   error completion (0x%x)",addr,cplstatus), OVM_LOW);
          end   
   iosf_tag++;


  endtask : body
endclass : hqm_iosf_sb_memwr_np_poison_seq
