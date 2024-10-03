`ifndef pcie_prim_base_seq_
`define pcie_prim_base_seq_

import IosfPkg::*;


class pcie_prim_base_seq extends ovm_sequence;

  `ovm_sequence_utils(pcie_prim_base_seq,IosfAgtSeqr)

  bit                   result; 
  integer               rcCfgId;
  integer               epCfgId;
  integer               epAtrcCfgId;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  string                reg_name;
  sla_status_t          status;
  sla_ral_data_t        rd_val, wr_val;
  sla_ral_access_path_t primary_id, access;
 
  sla_ral_env           ral;
  sla_sm_env            sm;
  hqm_tb_cfg            i_hqm_cfg;

  hqm_pf_cfg_bridge_file                pf_cfg_regs;

  hqm_list_sel_pipe_bridge_file         list_sel_pipe_regs;
  hqm_dir_pipe_bridge_file              dp_regs;
  hqm_qed_pipe_bridge_file              qed_regs;
  hqm_nalb_pipe_bridge_file             nalb_regs;
  hqm_atm_pipe_bridge_file              atm_pipe_regs;
  hqm_aqed_pipe_bridge_file             aqed_pipe_regs;
  hqm_reorder_pipe_bridge_file          rop_regs;
  hqm_credit_hist_pipe_bridge_file      credit_hist_pipe_regs;
  hqm_config_master_bridge_file         master_regs;
  hqm_system_csr_bridge_file            hqm_system_csr_regs;
  hqm_msix_mem_bridge_file              hqm_msix_mem_regs;
  ovm_event_pool                        event_pool;
  ovm_event                             schedular_ev;
  ovm_event                             done_ev;
  string                                pool_id;
  function new(string name = "pcie_prim_base_seq");
    super.new(name);

// ADP to fix
//    rcCfgId       = $mminstanceid("hqm_tb_top.RC(cfg_0_0)");
//    epCfgId       = $mminstanceid("hqm_tb_top.EP(cfg_0_0)");
//    epAtrcCfgId   = $mminstanceid("hqm_tb_top.RC(p_0.cfg_0_0)");
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `sla_assert($cast(sm , sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

    //-- get each register files
    `sla_assert($cast(pf_cfg_regs,          ral.find_file("hqm_pf_cfg_i")),     ("Unable to get handle to pf_cfg_regs."))

    `sla_assert($cast(master_regs,         ral.find_file("config_master")),          ("Unable to get handle to master_regs."))
    `sla_assert($cast(hqm_system_csr_regs, ral.find_file("hqm_system_csr")),  ("Unable to get handle to hqm_system_csr_regs."))
    `sla_assert($cast(hqm_msix_mem_regs, ral.find_file("hqm_msix_mem")),  ("Unable to get handle to hqm_msix_mem."))
    `sla_assert($cast(rop_regs,            ral.find_file("reorder_pipe")),      ("Unable to get handle to rop_regs."))
    `sla_assert($cast(list_sel_pipe_regs,  ral.find_file("list_sel_pipe")),     ("Unable to get handle to list_sel_pipe_regs."))
    `sla_assert($cast(nalb_regs,           ral.find_file("nalb_pipe")),         ("Unable to get handle to nalb_regs."))
    `sla_assert($cast(atm_pipe_regs,       ral.find_file("atm_pipe")),          ("Unable to get handle to atm_pipe."))
    `sla_assert($cast(dp_regs,             ral.find_file("direct_pipe")),        ("Unable to get handle to dp_regs."))
    `sla_assert($cast(qed_regs,            ral.find_file("qed_pipe")),          ("Unable to get handle to qed_regs."))
    `sla_assert($cast(aqed_pipe_regs,      ral.find_file("aqed_pipe")),         ("Unable to get handle to aqed_pipe_regs."))
    `sla_assert($cast(credit_hist_pipe_regs,ral.find_file("credit_hist_pipe")), ("Unable to get handle to credit_hist_pipe_regs."))
    event_pool      = event_pool.get_global_pool();
    schedular_ev    = event_pool.get("schedular_ev");
    done_ev         = event_pool.get("done_ev");

    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type();
    
     if(!$cast(i_hqm_cfg, hqm_tb_cfg::get()))
        `ovm_error(get_name(), "Failed to get hqm_cfg handle");

  endfunction

  function set_pool_id(string pid);
      pool_id = pid;
  endfunction: set_pool_id;

  virtual task body();

  endtask


  virtual task read_compare(input sla_ral_reg r, logic [31:0] comp_val, logic [31:0] mask = 32'h_ffff_ffff, output bit result);

    logic [63:0] absolute_addr;

    if(r != null) begin
      absolute_addr = get_address(r);
      `ovm_info(get_name(), $sformatf("Doing read_compare for absolute_addr(0x%0x), comp_val(0x%0x), mask(0x%0x), last_written(0x%0x), prev_val(0x%0x), reset_val(0x%0x)",absolute_addr,comp_val,mask,r.get(),r.get_prev(),r.get_reset_val()),OVM_LOW)

      r.read(status,rd_val,primary_id,this);

      if((rd_val & mask) != (comp_val & mask))    begin
        `ovm_error(get_name(), $sformatf("Read mismatched for (%s) comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val,mask))
        result = 0;
      end else begin
        `ovm_info(get_name(), $sformatf("Read matched for (%s) comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val,mask),OVM_LOW)
        result = 1;
      end
    end

  endtask: read_compare

  virtual task reset_check(input sla_ral_reg r);

    logic [63:0] absolute_addr;
    logic [31:0] comp_val;
    logic [31:0] mask;
    logic [31:0] width;
    bit              rslt;

    if(r != null) begin
      comp_val    = r.get_reset_val();
      width        = r.get_size();

      comp_val  = r.get_reset_val(); 
      mask        = (2**width - 1);
      //mask        = (|comp_val) ?  comp_val : mask ;
      absolute_addr = get_address(r);
      
      `ovm_info(get_name(), $sformatf("Doing reset_check for absolute_addr(0x%0x), width(0x%0x), reset_val(0x%0x), comp_val(0x%0x), mask(0x%0x)",absolute_addr,width,r.get_reset_val(),comp_val,mask),OVM_LOW)

      read_compare(r,comp_val,mask,rslt);

      if(!rslt)    `ovm_error(get_name(), $sformatf("Reset check failed for reg %s",r.get_name()))
      else        `ovm_info (get_name(), $sformatf("Reset check passed for reg %s",r.get_name()),OVM_LOW)

    end

  endtask: reset_check


  virtual task poll_reg_val(input sla_ral_reg r, logic [31:0] comp_val, logic [31:0] mask, integer timeout_val = 100);
      int iteration;

      r.read(status,rd_val,primary_id,this);
      `ovm_info(get_name(), $sformatf("Polling for reg (%s) to reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask),OVM_LOW)
      for(iteration=0; ( ((rd_val & mask) != (comp_val & mask)) && (iteration<10) );iteration++ ) begin
          repeat(timeout_val/10) #10ns;
          r.read(status,rd_val,primary_id,this);
      end

      if(iteration==10)    `ovm_error(get_name(), $sformatf("Polling for reg (%s) didn't reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask))
      else                `ovm_info(get_name(),  $sformatf("Polling for reg (%s) did reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask),OVM_LOW)

  endtask: poll_reg_val

  virtual function logic [31:0] get_next_reg_reset_val(sla_ral_reg r);
      logic [31:0]    offset;
      logic [31:0]    loc_offset = 0;
      logic [31:0]    max_offset;
      sla_ral_file    r_file;
      sla_ral_reg    temp_reg;

      get_next_reg_reset_val=32'h_0;

      r_file = r.get_file();
      offset = r.get_offset();
      max_offset = 'h_4 - (offset%'h_4);

      for (int i=1; i<=max_offset; i++)    begin
        temp_reg = r_file.find_reg_by_offset(offset+i);
        if(temp_reg)    begin
          get_next_reg_reset_val = get_next_reg_reset_val | (temp_reg.get_reset_val()<< ( 8*(temp_reg.get_offset()%'h_4) )) ;
          `ovm_info(get_name(), $sformatf("next_reg (%s) with reset_val(0x%0x) and offset (0x%0x)",temp_reg.get_name(),temp_reg.get_reset_val(),temp_reg.get_offset()),OVM_LOW)
        end
      end
      `ovm_info(get_name(), $sformatf("next_reset_val(0x%0x)",get_next_reg_reset_val),OVM_LOW)
  endfunction: get_next_reg_reset_val

  virtual function logic [31:0] get_previous_reg_reset_val(sla_ral_reg r);
      logic [31:0]    offset;
      logic [31:0]    loc_offset = 0;
      logic [31:0]    max_offset;
      sla_ral_file    r_file;
      sla_ral_reg    temp_reg;

      get_previous_reg_reset_val=32'h_0;

      r_file = r.get_file();
      offset = r.get_offset();
      max_offset = offset%'h_4;

      for (int i=1; i<=max_offset; i++)    begin
        temp_reg = r_file.find_reg_by_offset(offset-i);
        if(temp_reg)    begin
          get_previous_reg_reset_val = get_previous_reg_reset_val | (temp_reg.get_reset_val()<< ( 8*(temp_reg.get_offset()%'h_4) )) ;
          `ovm_info(get_name(), $sformatf("prev_reg (%s) with reset_val(0x%0x) and offset (0x%0x)",temp_reg.get_name(),temp_reg.get_reset_val(),temp_reg.get_offset()),OVM_LOW)
        end
      end
      `ovm_info(get_name(), $sformatf("prev_reset_val(0x%0x)",get_previous_reg_reset_val),OVM_LOW)
  endfunction: get_previous_reg_reset_val

  virtual function logic [63:0] get_address(sla_ral_reg r);
    logic [63:0] loc_addr;
    loc_addr = ral.get_addr_val( sla_iosf_pri_reg_lib_pkg::get_src_type(),r); 
    loc_addr[31:0] = loc_addr[31:0] >> 2;
    return (loc_addr ); // PCIe register number/address //
  endfunction

endclass

`endif
