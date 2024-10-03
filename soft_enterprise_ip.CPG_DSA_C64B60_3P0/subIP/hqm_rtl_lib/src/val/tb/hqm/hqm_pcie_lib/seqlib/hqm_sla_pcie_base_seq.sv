//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_SLA_PCIE_BASE_SEQUENCE__SV
`define HQM_SLA_PCIE_BASE_SEQUENCE__SV

//------------------------------------------------------------------------------
// File        : hqm_sla_pcie_base_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence holds most of the support required for PCIe tests,
//               with an empty body task.
//------------------------------------------------------------------------------

typedef enum int { pf = 1, sriov = 2, sciov = 3 } hqm_mode_t ;
typedef enum int { ur_p_np = 1, ur_np_p = 2, ur_p_only = 3, ur_np_only = 4, mtlp_mps_128B = 5, mtlp_mps_256B = 6, mtlp_mps_512B = 7 } hqm_len_stim_t ;
typedef enum int { cfgrd   = 1, cfgwr   = 2, mwr       = 3, mrd        = 4 } hqm_fbe_lbe_stim_t ;

class hqm_sla_pcie_base_seq extends ovm_sequence;

  `ovm_sequence_utils(hqm_sla_pcie_base_seq, sla_sequencer)

  // -- Pointer to hqm_tb_env, in order to obtain handle to pins -- //
  hqm_tb_env      hqm_env;
  virtual hqm_misc_if  pins;
  bit [7:0]       legal_sai=8'h_3;

  // -- Internal variables -- //
  bit                   result; 
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  string                reg_name;
  sla_status_t          status;
  sla_ral_data_t        rd_val, wr_val;
  sla_ral_access_path_t primary_id, access;
 
  sla_ral_env           ral;
  string                ral_tb_env_hier = "*.";    // -- Useful with multiple ral instances
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
  hqm_sif_csr_bridge_file               hqm_sif_csr_regs;
  hqm_msix_mem_bridge_file              hqm_msix_mem_regs;
  ovm_event_pool                        event_pool;
  ovm_event                             schedular_ev;
  ovm_event                             done_ev;
  string                                pool_id;

  function new(string name = "hqm_sla_pcie_base_seq");

    super.new(name);

    // -- Obtain handles to hqm_tb_env and correspondingly to hqm_misc_if -- //

    `sla_assert( $cast(hqm_env,   sla_utils::get_comp_by_name("i_hqm_tb_env")), (("Could not find i_hqm_tb_env\n")));
    if(hqm_env   == null) `ovm_error(get_full_name(),$psprintf("i_hqm_tb_env ptr is null")) else 
                          `ovm_info(get_full_name(),$psprintf("i_hqm_tb_env ptr is not null"),OVM_LOW) 

    `sla_assert( $cast(pins, hqm_env.pins),                               (("Could not find hqm_misc_if pointer \n")));
    if(pins      == null) `ovm_error(get_full_name(),$psprintf("hqm_misc_if ptr is null"))    else
                          `ovm_info(get_full_name(),$psprintf("hqm_misc_if ptr is not null"),OVM_LOW)   

    // -- Get handles to ral env and correspondignly to register file handles -- //

    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
    `sla_assert($cast(sm , sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

    // -- get handles to each register files -- //

    `sla_assert($cast(pf_cfg_regs,          ral.find_file({ral_tb_env_hier,"hqm_pf_cfg_i"})),     ("Unable to get handle to pf_cfg_regs."))

    `sla_assert($cast(master_regs,           ral.find_file({ral_tb_env_hier,"config_master"})),     ("Unable to get handle to master_regs."))
    `sla_assert($cast(hqm_sif_csr_regs,      ral.find_file({ral_tb_env_hier,"hqm_sif_csr"})),       ("Unable to get handle to hqm_sif_csr_regs."))
    `sla_assert($cast(hqm_system_csr_regs,   ral.find_file({ral_tb_env_hier,"hqm_system_csr"})),    ("Unable to get handle to hqm_system_csr_regs."))
    `sla_assert($cast(hqm_msix_mem_regs,     ral.find_file({ral_tb_env_hier,"hqm_msix_mem"})),      ("Unable to get handle to hqm_msix_mem."))
    `sla_assert($cast(rop_regs,              ral.find_file({ral_tb_env_hier,"reorder_pipe"})),      ("Unable to get handle to rop_regs."))
    `sla_assert($cast(list_sel_pipe_regs,    ral.find_file({ral_tb_env_hier,"list_sel_pipe"})),     ("Unable to get handle to list_sel_pipe_regs."))
    `sla_assert($cast(nalb_regs,             ral.find_file({ral_tb_env_hier,"nalb_pipe"})),         ("Unable to get handle to nalb_regs."))
    `sla_assert($cast(atm_pipe_regs,         ral.find_file({ral_tb_env_hier,"atm_pipe"})),          ("Unable to get handle to atm_pipe."))
    `sla_assert($cast(dp_regs,               ral.find_file({ral_tb_env_hier,"direct_pipe"})),       ("Unable to get handle to dp_regs."))
    `sla_assert($cast(qed_regs,              ral.find_file({ral_tb_env_hier,"qed_pipe"})),          ("Unable to get handle to qed_regs."))
    `sla_assert($cast(aqed_pipe_regs,        ral.find_file({ral_tb_env_hier,"aqed_pipe"})),         ("Unable to get handle to aqed_pipe_regs."))
    `sla_assert($cast(credit_hist_pipe_regs, ral.find_file({ral_tb_env_hier,"credit_hist_pipe"})),  ("Unable to get handle to credit_hist_pipe_regs."))
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

  task wait_for_schedular();

  endtask: wait_for_schedular;


  virtual task body();

  endtask

//   task pre_body();
//     ovm_test_done.raise_objection(this);
//   endtask
// 
//   task post_body();
//     ovm_test_done.drop_objection(this);
//   endtask

  virtual task wr_inv_rst_val(input sla_ral_reg r);
    `ovm_info(get_full_name(), $psprintf("Sending inverse reset val write to reg (%s) with val (0x%0x).", r.get_name(), ~r.get_reset_val()), OVM_LOW);
    send_wr(r, ~r.get_reset_val());
  endtask

  virtual task read_compare(input sla_ral_reg r, logic [31:0] comp_val, logic [31:0] mask = 32'h_ffff_ffff, output bit result);

    string log = "";
    logic [63:0] absolute_addr;

    if(r != null) begin
      absolute_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r);
      `ovm_info(get_name(), $sformatf("Doing read_compare for absolute_addr(0x%0x), comp_val(0x%0x), mask(0x%0x), last_written(0x%0x), prev_val(0x%0x), reset_val(0x%0x)",absolute_addr,comp_val,mask,r.get(),r.get_prev(),r.get_reset_val()),OVM_LOW)

      // -- r.read(status,rd_val,primary_id,this,.sai(legal_sai));
      r.readx(status,comp_val,mask,rd_val,primary_id,.sai(legal_sai));
      log = $psprintf("while doing read_compare of reg (%s) with comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val,mask);
      if(status != sla_pkg::SLA_OK) begin
        `ovm_error(get_name(), $sformatf("Received (%s) status %s",status.name(), log))
      end else if((rd_val & mask) != (comp_val & mask))    begin
        `ovm_error(get_name(), $sformatf("Read mismatched %s",log))
        result = 0;
      end else begin
        `ovm_info(get_name(), $sformatf("Read matched %s",log),OVM_LOW)
        result = 1;
      end
    end else begin
        `ovm_error(get_name(), $sformatf("Null reg handle received for read_compare !!"))
    end

  endtask: read_compare

  virtual task read_compare_rw(input sla_ral_reg r, logic [31:0] comp_val);
    bit status;   
    `ovm_info(get_full_name(), $psprintf("Doing RW fields compare for reg(%s) with RW attr_mask(0x%0x) and compare val (0x%0x).",r.get_name(), r.get_attr_mask("RW"), comp_val), OVM_LOW);
    read_compare(r, (r.get_attr_mask("RW") & comp_val), .result(status));
  endtask

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


  task reset_check_reg_list(sla_ral_reg reg_list[$]);
	sla_ral_file reg_file = reg_list[0].get_file();
	foreach(reg_list[i]) begin `ovm_info(get_name(), $sformatf("Checking reset_val for %s",reg_list[i].get_name()),OVM_LOW) reset_check(reg_list[i]); end
    `ovm_info(get_name(), $sformatf("Completed reset_val check for (%0d) registers of reg_file (%0s)",reg_list.size(),reg_file.get_name()),OVM_LOW)
  endtask : reset_check_reg_list

  virtual task poll_reg_val(input sla_ral_reg r, logic [31:0] comp_val, logic [31:0] mask, integer timeout_val = 500);
      int iteration;

      r.read(status,rd_val,primary_id,this,.sai(legal_sai));
      `ovm_info(get_name(), $sformatf("Polling for reg (%s) to reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask),OVM_LOW)
      for(iteration=0; ( ((rd_val & mask) != (comp_val & mask)) && (iteration<`HQM_POLL_REG_ITER) );iteration++ ) begin
          repeat(timeout_val/10) wait_ns_clk(10);
          r.read(status,rd_val,primary_id,this,.sai(legal_sai));
      end

      if(iteration==`HQM_POLL_REG_ITER)    `ovm_error(get_name(), $sformatf("Polling for reg (%s) didn't reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask))
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
    loc_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r); 
    loc_addr[31:0] = loc_addr[31:0] >> 2;
    return (loc_addr ); // PCIe register number/address //
  endfunction

  task wait_ns_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

  virtual task cfgrd_chk_addr(Iosf::address_t addr, Iosf::data_t data, Iosf::data_t mask = 32'h_ffff_ffff);
    fork begin 
           automatic hqm_tb_sequences_pkg::hqm_iosf_prim_base_seq prim_seq;
           automatic Iosf::address_t addr_c=addr;
           automatic Iosf::data_t    data_c=data;
           automatic Iosf::data_t    mask_c=mask;
           automatic string          log="";

             `ovm_info(get_full_name(),$psprintf("cfgrd_chk_addr: addr=0x%0x data=0x%0x mask=0x%0x", addr, data, mask),OVM_LOW)

             `ovm_do_with(prim_seq,{iosf_addr_l==addr_c; cmd==Iosf::CfgRd0;});

             log = $psprintf("Address=(0x%0x); Data: exp(0x%0x), actual(0x%0x); Mask: (0x%0x)",addr_c,data_c,prim_seq.iosf_data_l[0],mask_c);

             if( (data_c & mask_c) == (prim_seq.iosf_data_l[0] & mask_c) ) 
                  `ovm_info(get_full_name(),$psprintf("cfgrd_chk_addr: PASSED for %s",log),OVM_LOW)
             else `ovm_error(get_full_name(),$psprintf("cfgrd_chk_addr: FAILED for %s",log)) 
         end
    join_none
  endtask

  virtual task mrd_chk_addr(Iosf::address_t addr, Iosf::data_t data, Iosf::data_t mask = 32'h_ffff_ffff);
    fork begin 
           automatic hqm_tb_sequences_pkg::hqm_iosf_prim_base_seq prim_seq;
           automatic Iosf::address_t addr_c=addr;
           automatic Iosf::data_t    data_c=data;
           automatic Iosf::data_t    mask_c=mask;
           automatic string          log="";
             `ovm_do_with(prim_seq,{iosf_addr_l==addr_c; cmd==Iosf::MRd64;});
             log = $psprintf("Address=(0x%0x); Data: exp(0x%0x), actual(0x%0x); Mask: (0x%0x)",addr_c,data_c,prim_seq.iosf_data_l[0],mask_c);
             if( (data_c & mask_c) == (prim_seq.iosf_data_l[0] & mask_c) ) 
                  `ovm_info(get_full_name(),$psprintf("mrd_chk_addr: PASSED for %s",log),OVM_LOW)
             else `ovm_error(get_full_name(),$psprintf("mrd_chk_addr: FAILED for %s",log)) 
         end
    join_none
  endtask

  // -- Read check for addresses not defined in RAL -- //
  task rd_chk_file(string file_name);
    integer fd;
    integer code;
    string  ip;
    string  line;
    string  opcode;
        
    if (file_name == "") begin
      `ovm_error(get_full_name(),$psprintf("%s file path not set !!",file_name))
      return;
    end

    fd = $fopen(file_name,"r");

    if (fd == 0) begin
      `ovm_error(get_full_name(),$psprintf("Unable to open file %s",file_name))
      return;
    end

    `ovm_info(get_full_name(),$psprintf("Processing file %s",file_name),OVM_LOW)

    // -- Parse file -- //
    code = $fgets(ip,fd);
    while (code > 0) begin
      line = ip;

      opcode = lvm_common_pkg::parse_token(line);
      opcode = opcode.tolower();

      case(opcode)
         "crd","crde"  : begin do_cfg_read(line, .ur(opcode=="crde") ); end
         "cwr","cwre"  : begin do_cfg_write(line, .ur(opcode=="cwre") ); end
         "brdp","bwrp" : begin send_bg_acc_with_pasid(lvm_common_pkg::parse_token(line),.rd_only(opcode  == "brdp")); end
         "chk_in_bar"  : begin chk_in_bar(lvm_common_pkg::parse_token(line)); end
         "//","#","" : begin `ovm_info(get_full_name(),$psprintf("%s",opcode),OVM_LOW); end // -- Comment in code -- //
         default     : `ovm_error(get_full_name(),$psprintf("Unsupported cmd found: %s",opcode))
      endcase
      code = $fgets(ip,fd);
    end    // -- while   
 
  endtask

  virtual function void get_int_tokens(ref string line,output bit [63:0] int_tokens_q[$],input int max_ints = -1);
    bit [63:0]  int_val;
    string      token;

    token = lvm_common_pkg::parse_token(line);

    int_tokens_q.delete();

    while (token != "") begin
      if (lvm_common_pkg::token_to_longint(token,int_val) == 0) begin
        line = {token," ",line};
        break;
      end

      int_tokens_q.push_back(int_val);

      if ((max_ints >= 0) && (int_tokens_q.size() == max_ints)) begin
        break;
      end

      token = lvm_common_pkg::parse_token(line);
    end
  endfunction

  task send_bg_acc_with_pasid(string line, bit rd_only);
    string      explode_q[$];
    sla_ral_reg r;
    explode_q.delete();
    lvm_common_pkg::explode(".",line,explode_q);
    case(explode_q.size())
        'h_2,'h_3 : begin
                      decode_reg(explode_q[0], explode_q[1], r); 
                      if(rd_only)       send_rd(r, .with_pasid(1));    // -- Send MRd for register with PASID
                      else              send_rd_wr(r, .with_pasid(1)); // -- Send MRd -> MWr for register with PASID
                    end
        default   : `ovm_error(get_full_name(),$psprintf("Unable to decode command '%s'. \n Typical usage: 'bgrdp <reg_file>.<reg> or bgrdp <reg_file>.<reg>.<reg_field>' ",line))
    endcase
  endtask 

  function void chk_in_bar(string line);
    string      explode_q[$];
    sla_ral_reg r;
    explode_q.delete();
    lvm_common_pkg::explode(".",line,explode_q);
    case(explode_q.size())
        'h_2,'h_3 : begin
                      if(explode_q[1] == "*") begin chk_reg_file_in_bar(explode_q[0]);         end // -- Wildcard provided (all regs)
                      else begin decode_reg(explode_q[0], explode_q[1], r); chk_reg_in_bar(r); end // -- Single register to check
                    end
        default   : `ovm_error(get_full_name(),$psprintf("Unable to decode command '%s'. \n Typical usage: 'chk_in_bar <reg_file>.<reg> or chk_in_bar <reg_file>.<reg>.<reg_field>' ",line))
    endcase
  endfunction 

  function void chk_reg_file_in_bar(string reg_file);
    sla_ral_file i_file = ral.find_file({ral_tb_env_hier,reg_file});
    if(i_file == null) `ovm_error(get_full_name(),$psprintf("Unable to find register file '%s', within ral env. Command usage: chk_in_bar <reg_file_name>.*", reg_file))
    else begin         
       sla_ral_reg regs[$];
       i_file.get_regs(regs);
       `ovm_info(get_full_name(),$psprintf("Executing chk_reg_file_in_bar for :%s with # of regs (0x%0x).",reg_file,regs.size()),OVM_LOW);
       foreach(regs[k]) chk_reg_in_bar(regs[k]);
    end
  endfunction

  function void chk_addr_in_sys_page_size(Iosf::address_t addr, int size);
    string log1 = $psprintf("Regsiter @ Address (0x%0x) with size (0x%0x)",addr, size);
    string log2 = $psprintf("within a single system page size region (0x%0x)",`HQM_SYS_PAGE_SIZE);

    if((addr/`HQM_SYS_PAGE_SIZE) == ( (addr+(size/32))/`HQM_SYS_PAGE_SIZE) ) begin  // -- DW is 32bits which corresponds to a length of 1 in PCIe -- //
        `ovm_info(get_full_name(), $psprintf("%s lies %s", log1, log2), OVM_LOW)
    end else 
        `ovm_error(get_full_name(), $psprintf("%s doesn't lie %s", log1, log2))
  endfunction

  function void chk_addr_in_bar(Iosf::address_t addr);
    case({chk_addr_in_pf_func_bar(addr),chk_addr_in_pf_csr_bar(addr)})
      2'b_00: `ovm_error(get_full_name(), $psprintf("Address (0x%0x) not found in any BAR space",addr)) 
      2'b_10, 
      2'b_01: `ovm_info(get_full_name(), $psprintf( "Found address (0x%0x) in HQM BAR space",addr),OVM_LOW)
      default: `ovm_error(get_full_name(), $psprintf("Address (0x%0x) found in multiple BAR space !!! Overlapping BARS. Match found as (0x%0x)",addr,{chk_addr_in_pf_func_bar(addr),chk_addr_in_pf_csr_bar(addr)}))
    endcase
  endfunction

  function bit is_addr_within(Iosf::address_t addr, Iosf::address_t base, Iosf::address_t max_offset);
     is_addr_within = 1'b_0;
    `ovm_info(get_full_name(), $psprintf( "is_addr_within - addr (0x%0x) base (0x%0x) max_offset (0x%0x)", addr, base, max_offset),OVM_LOW)
     if( (addr >= base) &&  ( addr < (base + max_offset) ) ) begin 
       is_addr_within = 1'b_1;
       `ovm_info(get_full_name(), $psprintf("Found address within -> Address: (0x%0x), Base: (0x%0x), Max_Offset (0x%0x)",addr, base, max_offset), OVM_LOW);
     end
  endfunction

  function bit chk_addr_in_pf_func_bar(Iosf::address_t addr); 
    Iosf::address_t base_addr;
    base_addr[63:32] = pf_cfg_regs.FUNC_BAR_U.get_actual();
    base_addr[31:00] = pf_cfg_regs.FUNC_BAR_L.get_actual();
    `ovm_info(get_full_name(), $psprintf( "chk_addr_in_pf_func_bar - addr (0x%0x) base_addr (0x%0x)", addr, base_addr),OVM_LOW)
    chk_addr_in_pf_func_bar = is_addr_within(addr, base_addr, `HQM_PF_FUNC_BAR_SIZE);
  endfunction

  function bit chk_addr_in_pf_csr_bar(Iosf::address_t addr); 
    Iosf::address_t base_addr;
    base_addr[63:32] = pf_cfg_regs.CSR_BAR_U.get_actual();
    base_addr[31:00] = pf_cfg_regs.CSR_BAR_L.get_actual();
    `ovm_info(get_full_name(), $psprintf( "chk_addr_in_pf_csr_bar - addr (0x%0x) base_addr (0x%0x)", addr, base_addr),OVM_LOW)
    chk_addr_in_pf_csr_bar = is_addr_within(addr, base_addr, `HQM_PF_CSR_BAR_SIZE); 
  endfunction

  function void chk_reg_in_bar(sla_ral_reg r);
     if(r == null) `ovm_error(get_full_name(), $psprintf("Null register provided to chk_reg_in_bar, no checks done !"))
     else begin    
         `ovm_info(get_full_name(), $psprintf("Doing chk_reg_in_bar for reg (%s)", r.get_name()), OVM_LOW)
         if(r.get_name()=="CFG_MASTER_CTL") begin
            `ovm_info(get_full_name(), $psprintf("Skip chk_addr_in_bar for reg (%s) which is SB-access only (Control Register on Side Reset for HQM Master, accessible via sideband)", r.get_name()), OVM_LOW)
         end else begin
            chk_addr_in_bar(ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r)); 
         end 
         chk_addr_in_sys_page_size(ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r), r.get_size()); 
     end
  endfunction 

  function void decode_reg(string reg_file_name, string reg_name, ref sla_ral_reg r);
     r   = ral.find_reg_by_file_name(reg_name, {ral_tb_env_hier,reg_file_name});
     if(r == null) `ovm_error(get_full_name(), $psprintf("Unable to find reg with hierarchy: %s.%s", {ral_tb_env_hier,reg_file_name}, reg_name))
  endfunction 

  task do_cfg_write(string line, bit ur);
     bit [63:0]          token_q[$];
     get_int_tokens(line,token_q);

     if(token_q.size() < 2) `ovm_error(get_full_name(),$psprintf("Insufficient tokens for cwr/cwre command, provided # of tokens (%0d)",token_q.size()))
     else  begin 
        Iosf::data_t mask; Iosf::address_t addr; addr = token_q[0];
        if(token_q.size() > 3) mask = token_q[2]; else mask = 32'h_ffff_ffff;
        send_cfgwr(addr, .fill_data(0), .wdata(token_q[1]), .ur(ur));
     end
  endtask

  task do_cfg_read(string line, bit ur);
     bit [63:0]          token_q[$];
     get_int_tokens(line,token_q);

     if(token_q.size() < 2) `ovm_error(get_full_name(),$psprintf("Insufficient tokens for crd/crde command, provided # of tokens (%0d)",token_q.size()))
     else  begin 
        Iosf::data_t mask; Iosf::address_t addr; addr = token_q[0];
        if(token_q.size() > 3) mask = token_q[2]; else mask = 32'h_ffff_ffff;
        cfgrd_chk_addr(addr, token_q[1], mask);
     end
  endtask

  virtual task send_wr(sla_ral_reg r, Iosf::data_t d, bit with_pasid = 0, bit ur = 0);
    fork begin
      automatic hqm_tb_sequences_pkg::hqm_iosf_prim_base_seq prim_seq;
      automatic Iosf::address_t i_addr  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r);
      automatic bit exp_err             = ur;
      automatic Iosf::data_t    i_data  = d;
      automatic Iosf::iosf_cmd_t i_cmd  = (r.get_space() == "CFG") ? Iosf::CfgWr0 : Iosf::MWr64;
      automatic bit [22:0] pasid_prefix = $urandom_range(0,23'h_7f_ffff); pasid_prefix[22] = with_pasid;
      `ovm_do_with(prim_seq,{cmd == i_cmd; iosf_addr_l == i_addr; iosf_pasidtlp_l == pasid_prefix; iosf_exp_error_l == exp_err; iosf_data_l.size() == 1; iosf_data_l[0] == i_data;});
    end join_none
  endtask

  virtual task send_rd(sla_ral_reg r, bit with_pasid = 0, bit ur = 0);
    fork begin
      automatic hqm_tb_sequences_pkg::hqm_iosf_prim_base_seq prim_seq;
      automatic Iosf::address_t i_addr  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r);
      automatic bit exp_err             = ur;
      automatic Iosf::iosf_cmd_t i_cmd  = (r.get_space() == "CFG") ? Iosf::CfgRd0 : Iosf::MRd64;
      automatic bit [22:0] pasid_prefix = $urandom_range(0,23'h_7f_ffff); pasid_prefix[22] = with_pasid;
      `ovm_do_with(prim_seq,{cmd == i_cmd; iosf_addr_l == i_addr; iosf_pasidtlp_l == pasid_prefix; iosf_exp_error_l == exp_err;});
    end join_none
  endtask

  virtual task send_rd_wr(sla_ral_reg r, bit with_pasid = 0);
    fork begin
      automatic hqm_tb_sequences_pkg::hqm_iosf_prim_base_seq rd_seq, wr_seq;
      automatic Iosf::address_t i_addr  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),r);
      automatic Iosf::iosf_cmd_t i_cmd  = (r.get_space() == "CFG") ? Iosf::CfgRd0 : Iosf::MRd64;
      automatic bit [22:0] pasid_prefix = $urandom_range(0,23'h_7f_ffff); pasid_prefix[22] = with_pasid;
      `ovm_do_with(rd_seq,{cmd == i_cmd; iosf_addr_l == i_addr; iosf_pasidtlp_l == pasid_prefix;});
      i_cmd  = (r.get_space() == "CFG") ? Iosf::CfgWr0 : Iosf::MWr64;
      `ovm_do_with(wr_seq,{cmd == i_cmd; iosf_addr_l == i_addr; iosf_pasidtlp_l == pasid_prefix; iosf_data_l.size() == 1; iosf_data_l[0] == rd_seq.iosf_data_l[0];});
    end join_none
  endtask

  function bit [63:0] get_sm_addr(string mem_name, bit [63:0] mem_size, bit [63:0] mem_mask, string mem_region = "DRAM_HIGH");
      sla_sm_ag_status_t       status;
      sla_sm_ag_result         gpa_mem;
      status = sm.ag.allocate_mem(gpa_mem, mem_region, mem_size, mem_name, mem_mask);
      get_sm_addr = gpa_mem.addr;
  endfunction
 
  function IosfPkg::IosfTxn get_tlp(
    Iosf::address_t  i_addr, 
    Iosf::iosf_cmd_t i_cmd, 
    Iosf::data_t     i_data[$]           = {},
    bit              i_fill_data         = 0,
    bit [3:0]        i_trafficClass      = 0,
    bit [15:0]       i_reqID             = 0,
    bit              i_procHint          = 0,
    bit [9:0]        i_length            = 1,
    bit              i_errorPresent      = 0,
    bit [3:0]        i_first_byte_en     = 4'hf,
    bit [3:0]        i_last_byte_en      = 4'h0,
    bit [9:0]        i_tag               = 0,
    bit [22:0]       i_pasidtlp          = 0
  );
     IosfPkg::IosfTxn iosfTxn; 
     Iosf::data_t     loc_data[];
     iosfTxn = new("iosfTxn");
     iosfTxn.cmd               = Iosf::cmdIsMem(i_cmd) ? ( Iosf::cmdIsMemRead(i_cmd) ? ( (i_addr[63:32] == 32'h0) ? Iosf::MRd32 : Iosf::MRd64 ) : ( (i_addr[63:32] == 32'h0) ? Iosf::MWr32 : Iosf::MWr64 ) ) : i_cmd  ;
     iosfTxn.reqChId           = 0;
     iosfTxn.trafficClass      = 0;
     iosfTxn.reqID             = i_reqID;
     iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
     iosfTxn.procHint          = i_procHint;
     iosfTxn.length            = i_length;
     iosfTxn.errorPresent      = i_errorPresent;
     iosfTxn.address           = i_addr;
     iosfTxn.byteEnWithData    = 0;
     iosfTxn.first_byte_en     = i_first_byte_en;
     iosfTxn.last_byte_en      = i_last_byte_en;
     iosfTxn.reqLocked         = 0;  
     iosfTxn.compareType       = Iosf::CMP_EQ;
     iosfTxn.compareCompletion = 0;
     iosfTxn.waitForCompletion = 0;
     iosfTxn.pollingMode       = 0;
     iosfTxn.tag               = i_tag;
     iosfTxn.expectRsp         = 0;
     iosfTxn.driveBadCmdParity =  0;
     iosfTxn.driveBadDataParity =  0;
     iosfTxn.driveBadDataParityCycle =  0;
     iosfTxn.driveBadDataParityPct   =  0;
     iosfTxn.reqGap            =  0;
     iosfTxn.chain             =  1'b0;
     iosfTxn.sai               =  legal_sai;
     iosfTxn.pasidtlp		   =  i_pasidtlp;

     if( (i_data.size() == i_length) || (i_fill_data) ) begin // -- TLP has data -- //
       string log = "";
       `ovm_info(get_full_name(), $psprintf("TLP has data as i_data.size(0x%0x), i_length(0x%0x), i_fill_data(0x%0x)", i_data.size(), i_length, i_fill_data), OVM_LOW)
       loc_data = new[i_length];  foreach(loc_data[i]) begin loc_data[i] = (i_data.size() == i_length) ? i_data[i] : $urandom() ; end
       iosfTxn.data = loc_data; 
       foreach(loc_data[i]) log = $psprintf("%s data[%0d]=(0x%0x)",log,i,loc_data[i]);
       `ovm_info(get_full_name(), $psprintf("Filled data: %s", log), OVM_LOW)
     end
     return iosfTxn;
  endfunction

  task send_tlp(IosfPkg::IosfTxn tlp, bit ur = 0, bit compare = 0, Iosf::data_t comp_val = 'h_0, Iosf::data_t mask = 32'h_ffff_ffff, bit skip_ur_chk = 1'b_0);
    fork begin
         automatic hqm_tb_sequences_pkg::hqm_iosf_prim_rsvd_tgl_seq tlp_seq;
         automatic IosfPkg::IosfTxn i_tlp      = tlp;
         automatic bit i_ur                    = ur;
         automatic bit i_skip_ur_chk           = skip_ur_chk;
         automatic bit i_compare               = compare;
         automatic Iosf::data_t i_comp_val     = comp_val;
         automatic Iosf::data_t i_mask         = mask;
         tlp_seq = hqm_tb_sequences_pkg::hqm_iosf_prim_rsvd_tgl_seq::type_id::create("tlp_seq");
         tlp_seq.exp_ur = i_ur;
         tlp_seq.skip_ur_chk = i_skip_ur_chk;
         tlp_seq.set_iosf_txn(i_tlp);
         tlp_seq.start(p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()));
           if(compare) begin : read_compare
              string log = $psprintf("read with compare(0x%0x), comp_val(0x%0x), mask(0x%0x)", i_compare, i_comp_val, i_mask);
              case(tlp_seq.iosf_txn.cplStatus) 
                3'b_000: begin
                           if( tlp_seq.iosf_txn.cplData.size() > 0 ) begin
                               log = $psprintf("%s, rd_val(0x%0x)", log, tlp_seq.iosf_txn.cplData[0]);
                               if( (i_comp_val & i_mask) == (tlp_seq.iosf_txn.cplData[0] & i_mask) )  
                                    `ovm_info(get_full_name(),$psprintf( "send_rd chk: PASSED for %s",log),OVM_LOW)
                               else `ovm_error(get_full_name(),$psprintf("send_rd chk: FAILED for %s",log)) 
                           end else `ovm_error(get_full_name(),$psprintf("Didn't receive any data for compare as read data size (0x%0x)",tlp_seq.iosf_txn.cplData.size())) 
                         end
                default: `ovm_error(get_full_name(), $psprintf("Did not receive SC for %s ",log ))
              endcase
           end : read_compare
    end join_none
  endtask : send_tlp

  // -----------------------------------------------------------------------------
  // -- Get register value from RAL mirror
  // -----------------------------------------------------------------------------

 function sla_ral_data_t get_reg_value(string reg_name, string file_name, bit ro = 1'b_0);
   sla_ral_reg my_reg ;
   my_reg   = ral.find_reg_by_file_name(reg_name, {ral_tb_env_hier, file_name});
   if(my_reg != null) begin if(ro || $isunknown(my_reg.get_actual())) return my_reg.get_reset_val(); else return my_reg.get_actual(); end
   else               `ovm_error(get_full_name(), $psprintf("Null reg handle received for %s.%s", file_name, reg_name))
 endfunction: get_reg_value
  
  // -----------------------------------------------------------------------------
  // -- Returns MPS in DW
  // -----------------------------------------------------------------------------

  function int get_mps_dw(bit [2:0] mps);
    get_mps_dw = 'h_0;
    case(mps) 
      3'b_000: get_mps_dw =  128/4; 
      3'b_001: get_mps_dw =  256/4; 
      3'b_010: get_mps_dw =  512/4; 
      3'b_011: get_mps_dw = 1024/4; 
      3'b_100: get_mps_dw = 2048/4; 
      3'b_101: get_mps_dw = 4096/4; 
      default: begin get_mps_dw = 4096/4; `ovm_warning(get_full_name(), "Unsupported MPS programmed to DUT !!") end
    endcase
  endfunction

  task send_mrd(Iosf::address_t iosf_addr, int length, bit [3:0] lbe, bit exp_ur);
      IosfPkg::IosfTxn tlp;
      `ovm_info(get_full_name(), $psprintf("Sending MRd @address (0x%0x) with length (0x%0x) and exp_ur (0x%0x)", iosf_addr, length, exp_ur), OVM_LOW)
      tlp  = get_tlp(iosf_addr, Iosf::MRd64, .i_length(length), .i_last_byte_en(lbe));
      send_tlp(tlp, exp_ur);
  endtask : send_mrd
  
  task send_mwr(Iosf::address_t iosf_addr, int length, bit [3:0] lbe);
      IosfPkg::IosfTxn tlp;
      `ovm_info(get_full_name(), $psprintf("Sending MWr @address (0x%0x) with length (0x%0x)",iosf_addr ,length), OVM_LOW)
      tlp  = get_tlp(iosf_addr, Iosf::MWr64, .i_length(length), .i_last_byte_en(lbe), .i_fill_data(1));
      send_tlp(tlp);
  endtask : send_mwr
  
  task send_cfgwr(Iosf::address_t iosf_addr, bit fill_data = 1, Iosf::data_t wdata = 32'h_ff, bit ur = 0);
      IosfPkg::IosfTxn tlp;

      `ovm_info(get_full_name(), $psprintf("Sending CfgWr0 @address (0x%0x) and random data",iosf_addr ), OVM_LOW)
      tlp = get_tlp(iosf_addr, Iosf::CfgWr0, .i_fill_data(fill_data), .i_data({wdata}), .i_length(1)); 

      // -- Creating a mismatch between i_length and i_data.size() intentionally above if (fill_data = 1)
      // -- Since, want to fill random data in case of fill_data == 1;

      send_tlp(tlp, .ur(ur));

  endtask : send_cfgwr

task init_hqm();
    	
    pf_cfg_regs.FUNC_BAR_L.write(status,32'h_00000000,primary_id,this,.sai(legal_sai));
	pf_cfg_regs.FUNC_BAR_U.write(status,32'h_00000001,primary_id,this,.sai(legal_sai));

	pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id,this,.sai(legal_sai));
	pf_cfg_regs.CSR_BAR_U.write(status,32'h_00000002,primary_id,this,.sai(legal_sai));

    pf_cfg_regs.DEVICE_COMMAND.write(status,32'h_00000046,primary_id,this,.sai(legal_sai));

    master_regs.CFG_PM_PMCSR_DISABLE.write(status,32'h_0,primary_id,this,.sai(legal_sai));
    read_compare(master_regs.CFG_PM_PMCSR_DISABLE,32'h_0,.result(result));
    poll_reg_val(master_regs.CFG_DIAGNOSTIC_RESET_STATUS,'h_8000_0bff,'h_ffff_ffff,1000);

endtask

  // -----------------------------------------------------------------------------
  // -- Returns plusarg value provided in hex format 
  // -----------------------------------------------------------------------------

  function longint get_plusarg_val(string plusarg_name, longint default_val);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_plusarg_val = default_val; // -- Assign default value of plusarg, if no plusarg provided -- //
    end
    else if (lvm_common_pkg::token_to_longint(val_string,get_plusarg_val) == 0) begin
      `ovm_error(get_full_name(),$psprintf("+%s=%s not a valid integer value",plusarg_name,val_string))
      get_plusarg_val = default_val; // -- Assign default value of plusarg, if invalid plusarg usage -- //
    end

    // -- Finally print the resolved plusarg value -- //
    `ovm_info(get_full_name(), $psprintf("Resolved plusarg (%s) with value (0x%0x) ", plusarg_name, get_plusarg_val), OVM_LOW);

  endfunction

endclass

`endif
