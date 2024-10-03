// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_iosf_base_seq.sv
// Author : rsshekha
//
// Description :
//
//    base iosf seq.
//
// -----------------------------------------------------------------------------
import hcw_transaction_pkg::*;

class hqm_iosf_base_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_iosf_base_seq, sla_sequencer)

  string skip_regs_q[$];
  sla_ral_env                   ral;
  string                        ral_tb_env_hier = "*.";    // -- Useful with multiple ral instances
  string                        reg_name_func;// -- Useful with multiple ral instances
  string                        reg_name_func1;// -- Useful with multiple ral instances
  string                        reg_name_func_v;// -- Useful with multiple ral instances
  string                        var1;// -- Useful with multiple ral instances
  string                        const_raint_i;
  sla_ral_access_path_t         ral_access_path;
  sla_ral_addr_t                reg_addr;   
  sla_ral_reg                   reg_list_csr_pf[$];
  sla_ral_reg                   reg_list_func_p[$];
  sla_ral_reg                   reg_list_func_pf[$];
  sla_ral_reg                   reg_list_func_vf[$];
  sla_ral_reg                   reg_list[$];
  sla_ral_reg                   reg_list_func_vf_csr_pf[$];
  sla_ral_reg                   reg_list_func_regs[$];
  sla_ral_reg                   reg_list_func_pf_csr_pf[$];
  sla_ral_reg                   reg_list_func[$];
  sla_ral_reg                   reg_list_func_v[$];
  sla_ral_reg                   reg_list_csr_p[$];
  sla_ral_reg                   reg_list_system_csr[$];
  sla_ral_reg                   reg_list_csr_system[$];
  sla_ral_reg                   reg_list_csr_system_rand[$];
  sla_ral_reg                   reg_list_cfg_pf[$];
  sla_ral_reg                   reg_list_cfg_pf_1[$];
  sla_ral_reg                   reg_list_pf_cfg[$];
  sla_ral_reg                   reg_list_cfg_vf[$];
  sla_ral_reg                   reg_list_cfg_pf_vf_regs[$];
  sla_ral_reg                   reg_list_cfg_pf_regs[$];
  hqm_tb_env                    hqm_env;
  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
  hqm_iosf_prim_mon             i_hqm_iosf_prim_mon_obj;
  hqm_pp_cq_status              i_hqm_pp_cq_status;     
  hqm_iosf_prim_checker         i_hqm_iosf_prim_checker_obj;
  virtual hqm_misc_if           pins;
  string                        base_tb_env_hier     = "*";
  int                           idx=0;
  rand int                           register_num;
  hqm_system_csr_bridge_file            hqm_system_csr_regs;
  hqm_sif_csr_bridge_file              hqm_sif_csr_regs;
  hqm_pf_cfg_bridge_file                pf_cfg_regs;

  rand bit [63:0]               cfg_addr,mem_addr;
  bit [63:0]                    cfg_addr0, cfg_addr1, cfg_addr2;
  bit[63:0]                     mem_addr0, mem_addr1, mem_addr2;
  bit [15:0]                    src_pid;
  bit [15:0]                    dest_pid;
  bit [63:0]                    rdata;
  bit [7:0]                     legal_sai;
  bit [31:0]                    compare_data;
  int                           j,k,v,y,x,m,u,a,count=0;
  int                           z=0;
  flit_t                        my_ext_headers[];
  iosfsbm_seq::iosf_sb_seq      sb_seq;
  iosfsbm_cm::xaction_class_e   xaction_class;

  typedef enum int {
                   MemRd    = 'h0,
                   MemWr    = 'h1,
                   CfgRd    = 'h4, 
                   CfgWr    = 'h5,
                   Cmp      = 'h20,
                   CmpD     = 'h21,
                   BootPrep = 'h28,
                   Pm_Req   = 'h40,
                   IoWr     = 'h3,
                   IoRd     = 'h2,
                   CrWr     = 'h7,
                   CrRd     = 'h6,
                   LocalSync= 'h51,
                   SetId_Txn= 'h67,
                   VirtualWire = 'h2d,
                   DoPme    = 'h44
                 } trans_type_t;

  typedef enum int {
                   Parity_Error = 'h0
               } trans_type_e;

  constraint select_cfg_address {
    cfg_addr dist {cfg_addr0:/35, cfg_addr1:/35, cfg_addr2:/30};  
  }

  constraint select_mem_address {
    mem_addr dist {mem_addr0:/35, mem_addr1:/35, mem_addr2:/30};  

  }

  constraint select_register {
      register_num dist {[0:79]:/35,[80:158]:/35,[159:161]:/30};
  }
  function new(string name = "hqm_iosf_base_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    
    initialize_variables();
    my_ext_headers      = new[4];
    my_ext_headers[0]   = 8'h00;
    my_ext_headers[1]   = `HQM_VALID_SAI;     // Set SAI
    my_ext_headers[2]   = 8'h00;
    my_ext_headers[3]   = 8'h00;
  endfunction

  extern virtual task body();

  extern virtual task WriteReg( string          file_name,
                                string          reg_name,
                                sla_ral_data_t  wr_data
                              );


  extern virtual task WriteField( string                file_name,
                                  string                reg_name,
                                  string                field_name,
                                  sla_ral_data_t        wr_data
                                );

  extern virtual task ReadReg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  sla_ral_data_t   rd_data
                              );

  extern virtual task ReadField( string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 output  sla_ral_data_t rd_data
                                );

  extern virtual task poll(string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 input  sla_ral_data_t  exp_data);

  extern virtual task compare(string                 file_name,
                                 string                 reg_name,
                                 string                 field_name,
                                 boolean_t              exp_error,
                                 input  sla_ral_data_t  exp_data);

  extern virtual task read_and_check_reg( string                   file_name,
                               string                   reg_name,
                               boolean_t                exp_error,
                               output  sla_ral_data_t   rd_data
                              );

  extern virtual function reset_tb(string reset_type = "COLD_RESET");

  extern virtual function void initialize_variables ();  

  extern virtual task send_command(input sla_ral_reg register, input trans_type_t cmd_type,input xaction_class_e xaction_class , input bit [63:0] addr, input bit [63:0] wdata, input bit [2:0] iosf_tag, input bit [2:0] bar, input bit [7:0] fid = 0,input bit [3:0] fbe, input bit [3:0] sbe,input bit [3:0] misc ,input bit np_32_64_seq = 0,input bit parity_en_checks ,input bit exp_rsp, input bit compare_completion, input bit do_compare=1,input bit [1:0] rsp , input bit [63:0] actual_data );
  
  extern virtual task send_command_with_constraint(input sla_ral_reg register, input trans_type_t cmd_type,input trans_type_e const_raint, input bit const_raint_mode,input xaction_class_e xaction_class , input bit [63:0] addr, input bit [63:0] wdata, input bit [2:0] iosf_tag, input bit [2:0] bar, input bit [7:0] fid = 0,input bit [3:0] fbe, input bit [3:0] sbe ,input bit parity_en ,input bit exp_rsp, input bit compare_completion, input bit [1:0] rsp , input bit [63:0] actual_data );


  virtual task wait_for_clk(int number=10);
   repeat(number) begin @(sla_tb_env::sys_clk_r); end
  endtask

  virtual task wait_for_ns(integer number=2000);
    for (int i = 0;i < number;i++) begin 
      #1ns; 
    end     
  endtask

  extern virtual task wr_inverse (input string file_name);

  extern virtual task wait_ns_clk(int ticks=10);

 extern virtual task poll_reg_val(input sla_ral_reg r, logic [31:0] comp_val, logic [31:0] mask, integer timeout_val = 500);

  extern virtual task compare_regs(input string file_name);

  extern virtual function void skip_regs_by_name (input string pattern, input string file_name);

  extern virtual function logic [63:0] get_reg_addr (input string file_name, input string reg_name, input string access_path);

  extern virtual function void get_pid ();

endclass : hqm_iosf_base_seq

task hqm_iosf_base_seq::body();
endtask : body

function void hqm_iosf_base_seq::initialize_variables ();
    `sla_assert( $cast(hqm_env,   sla_utils::get_comp_by_name("i_hqm_tb_env")), (("Could not find i_hqm_tb_env\n")));
    if(hqm_env   == null) `ovm_error(get_full_name(),$psprintf("i_hqm_tb_env ptr is null")) else 
                          `ovm_info(get_full_name(),$psprintf("i_hqm_tb_env ptr is not null"),OVM_LOW) 
    `sla_assert( $cast(pins, hqm_env.pins),  (("Could not find hqm_misc_if pointer \n")));
    if(pins      == null) `ovm_error(get_full_name(),$psprintf("hqm_misc_if ptr is null"))    else
                          `ovm_info(get_full_name(),$psprintf("hqm_misc_if ptr is not null"),OVM_LOW)   
    ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

    `sla_assert($cast(hqm_system_csr_regs,   ral.find_file({ral_tb_env_hier,"hqm_system_csr"})),    ("Unable to get handle to hqm_system_csr_regs."))
     hqm_system_csr_regs.get_regs(reg_list_system_csr);
     foreach(reg_list_system_csr[i])begin
         if(ovm_is_match("LDB_CQ_ADDR_U*[*]",reg_list_system_csr[i].get_name()))begin
//             m=$urandom_range(0,63);
//             if(i == m)begin
             reg_list_csr_system[m]=reg_list_system_csr[i];
             m++;
         end
      end

      repeat(15)begin
         count = $urandom_range(0,63);
         reg_list_csr_system_rand[a] = reg_list_csr_system[count];
         $display("written reg_list_system_csr[%0d]=%s",a,reg_list_csr_system_rand[a].get_name());
      end

    `sla_assert($cast(hqm_sif_csr_regs,     ral.find_file({ral_tb_env_hier,"hqm_sif_csr"})),      ("Unable to get handle to hqm_sif_csr_regs."))

    hqm_sif_csr_regs.get_regs(reg_list_csr_pf);
    foreach(reg_list_csr_pf[i])begin
        if( ovm_is_match("TI_CMPL_FIFO_CTL",reg_list_csr_pf[i].get_name()) || ovm_is_match("RI_PHDR_FIFO_CTL",reg_list_csr_pf[i].get_name()) || ovm_is_match("RI_PDATA_FIFO_CTL",reg_list_csr_pf[i].get_name()))begin
            reg_list_csr_p[v]=reg_list_csr_pf[i];
            $display("written reg_list_csr_p[%0d]=%s",v,reg_list_csr_p[v].get_name());
            v++;
        end
    end

    
    `sla_assert($cast(pf_cfg_regs,          ral.find_file({ral_tb_env_hier,"hqm_pf_cfg_i"})),     ("Unable to get handle to pf_cfg_regs."))

    pf_cfg_regs.get_regs(reg_list_pf_cfg);
    foreach(reg_list_pf_cfg[i])begin
        if( ovm_is_match("CACHE_LINE_SIZE",reg_list_pf_cfg[i].get_name()) || ovm_is_match("INT_LINE",reg_list_pf_cfg[i].get_name()) || ovm_is_match("AER_CAP_UNCORR_ERR_SEV",reg_list_pf_cfg[i].get_name()))begin
            reg_list_cfg_pf[y]=reg_list_pf_cfg[i];
            $display("written reg_list_cfg_pf[%0d]=%s",y,reg_list_cfg_pf[y].get_name());
            y++;
        end
          if( ovm_is_match("PCIE_CAP_DEVICE_CONTROL",reg_list_pf_cfg[i].get_name()))begin
            reg_list_cfg_pf_1[u]=reg_list_pf_cfg[i];
            $display("written reg_list_cfg_pf_1[%0d]=%s",u,reg_list_cfg_pf_1[u].get_name());
            u++;
        end

    end
   
    reg_list_func_vf_csr_pf= {reg_list_func_p, reg_list_func_v,reg_list_csr_system};
    reg_list_func_regs={reg_list_func_p,reg_list_func_v};
    reg_list_func_pf_csr_pf = {reg_list_func_p,reg_list_csr_p};
    reg_list_cfg_pf_vf_regs= {reg_list_cfg_pf,reg_list_cfg_vf};
    reg_list_cfg_pf_regs= {reg_list_cfg_pf,reg_list_cfg_pf_1};
    reg_list = {reg_list_csr_pf, reg_list_func_pf, reg_list_func_vf};

    cfg_addr0 = get_reg_addr("hqm_pf_cfg_i", "cache_line_size",  "primary");
    cfg_addr1 = get_reg_addr("hqm_pf_cfg_i", "int_line",  "primary");
    cfg_addr2 = get_reg_addr("hqm_pf_cfg_i", "aer_cap_uncorr_err_sev",  "primary");

    mem_addr0 = get_reg_addr("hqm_sif_csr", "ibcpl_hdr_fifo_ctl", "primary");
    mem_addr1 = get_reg_addr("hqm_sif_csr", "ri_phdr_fifo_ctl", "primary");
    mem_addr2 = get_reg_addr("hqm_sif_csr", "ri_pdata_fifo_ctl","primary");
endfunction : initialize_variables

function void hqm_iosf_base_seq::get_pid ();
    m_sequencer.get_config_int("strap_hqm_gpsb_srcid", src_pid);
    m_sequencer.get_config_int("hqm_gpsb_dstid", dest_pid);
    `ovm_info(get_full_name(),$sformatf("src_pid %0h, dest_pid %0h", src_pid, dest_pid),OVM_LOW)
endfunction : get_pid

function logic [63:0]  hqm_iosf_base_seq::get_reg_addr (input string file_name, input string reg_name, input string access_path);

    logic [63:0] addr;

    sla_ral_file file_handle;
    sla_ral_reg  reg_handle;

    ovm_report_info(get_full_name(), $psprintf("get_reg_addr: file_name=%0s reg_name=%0s", file_name, reg_name), OVM_LOW);

    file_handle      = ral.find_file(file_name);

    if (file_handle == null) begin
      `ovm_error(get_full_name(),{"hqm_iosf_base_seq::get_reg_addr unable to get handle to RAL file"})
      return (0);
    end

    reg_handle     = file_handle.find_reg(reg_name);

    if (reg_handle == null) begin
      `ovm_error(get_full_name(),{"hqm_iosf_base_seq::get_reg_addr unable to get handle to RAL reg"})
      return (0);
    end
    
    if (access_path == "primary") begin 
        addr  = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(),reg_handle); 
    end 
    
    else if (access_path == "sideband") begin 
        addr  = ral.get_addr_val(iosf_sb_sla_pkg::get_src_type(),reg_handle); 
    end 

    return (addr);

endfunction: get_reg_addr

function hqm_iosf_base_seq::reset_tb(string reset_type = "COLD_RESET");
  ovm_object sb_tmp, prim_mon_tmp, pp_cq_status_tmp, prim_checker_tmp;
  //-----------------------------
  //-- get i_hcw_scoreboard
  //-----------------------------
  if (!p_sequencer.get_config_object("i_hcw_scoreboard", sb_tmp)) begin
     ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
  end

  if (!$cast(i_hcw_scoreboard, sb_tmp)) begin
    ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", sb_tmp.sprint(), i_hcw_scoreboard.sprint()));
  end else begin
    ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_LOW);
  end

  if (p_sequencer.get_config_object("i_hqm_iosf_prim_mon", prim_mon_tmp,0))  begin
      $cast(i_hqm_iosf_prim_mon_obj, prim_mon_tmp);
  end else begin
      `ovm_fatal(get_full_name(), "Unable to get config object hqm_iosf_prim_mon_obj");
  end

  if (p_sequencer.get_config_object("i_hqm_pp_cq_status",pp_cq_status_tmp,0)) begin
      $cast(i_hqm_pp_cq_status,pp_cq_status_tmp);
  end else begin
      `ovm_fatal(get_full_name(), "Unable to get config object i_hqm_pp_cq_status");
  end
  if (p_sequencer.get_config_object("i_hqm_iosf_prim_checker", prim_checker_tmp,0))  begin
      $cast(i_hqm_iosf_prim_checker_obj, prim_checker_tmp);
  end else begin
      `ovm_fatal(get_full_name(), "Unable to get config object i_hqm_iosf_prim_checker_obj");
  end
     //CQ_reset
  i_hqm_iosf_prim_mon_obj.cq_gen_reset(); 
  i_hcw_scoreboard.hcw_scoreboard_reset();
  i_hqm_pp_cq_status.reset();
  // -- Reset transaction Qs -- //
  if (reset_type == "D3HOT") begin
     `ovm_info(get_full_name(),$sformatf("\n skipped hqm_iosf_prim_checker reset \n"),OVM_LOW)
  end
  else begin 
     i_hqm_iosf_prim_checker_obj.reset_txnid_q(); 
     i_hqm_iosf_prim_checker_obj.reset_ep_bus_num_q(); 
     i_hqm_iosf_prim_checker_obj.reset_func_flr_status(); 
  end    
endfunction: reset_tb

function void hqm_iosf_base_seq::skip_regs_by_name (input string pattern, input string file_name);
     sla_ral_file          ral_file;
     sla_ral_reg           ral_regs[$];

     ral_file = ral.find_file({base_tb_env_hier, file_name});
     if (ral_file == null) begin
       `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
       return;
     end
     ral_file.get_regs(ral_regs);
     foreach(ral_regs[i]) begin 
        if(ovm_is_match(pattern.toupper(), ral_regs[i].get_name() )) begin 
          skip_regs_q.push_back(ral_regs[i].get_name());
        end    
     end       
     `ovm_info(get_full_name(),$sformatf("skip_regs_q size = %d",skip_regs_q.size()),OVM_LOW)
     return;
endfunction: skip_regs_by_name

task hqm_iosf_base_seq::wr_inverse( input string file_name);
  sla_ral_file          ral_file;
  sla_ral_data_t        rd_data;
  sla_ral_data_t        wr_data;
  sla_ral_reg           ral_regs[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_file.get_regs(ral_regs);

  foreach(ral_regs[reg_name]) begin
     `ovm_info(get_full_name(),$sformatf("Entered for register %s",ral_regs[reg_name].get_name()),OVM_DEBUG)
     if(ral_regs[reg_name].get_test_reg() == 0) begin
        continue;
     end
     if(ral_regs[reg_name].get_name() inside {skip_regs_q}) begin 
        `ovm_info(get_full_name(),$sformatf("wr_inverse skipped for register %s",ral_regs[reg_name].get_name()),OVM_LOW)
        continue;
     end
     ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
     `ovm_info(get_full_name(),$sformatf("generating read for register %s",ral_regs[reg_name].get_name()),OVM_DEBUG)
     ReadReg(ral_file.get_name(),ral_regs[reg_name].get_name(),SLA_FALSE,rd_data);
     wr_data = ~rd_data;
     `ovm_info(get_full_name(),$sformatf("generating write for register %s, rd data %h, wr_data %h",ral_regs[reg_name].get_name(), rd_data, wr_data),OVM_DEBUG)
     WriteReg(ral_file.get_name(),ral_regs[reg_name].get_name(),wr_data);
     `ovm_info(get_full_name(),$sformatf("generating read for register %s",ral_regs[reg_name].get_name()),OVM_DEBUG)
     read_and_check_reg(ral_file.get_name(),ral_regs[reg_name].get_name(),SLA_FALSE,rd_data); 
     `ovm_info(get_full_name(),$sformatf("generated read_and_check for register %s, rd data %h, wr_data %h",ral_regs[reg_name].get_name(), rd_data, wr_data),OVM_DEBUG)
  end

endtask : wr_inverse

task hqm_iosf_base_seq::compare_regs(input string file_name);
  sla_ral_file          ral_file;
  sla_ral_reg           ral_regs[$];
  sla_ral_data_t        rd_data;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_file.get_regs(ral_regs);

  foreach(ral_regs[reg_name]) begin
     if(ral_regs[reg_name].get_test_reg() == 0) begin
        continue;
     end
     ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
     read_and_check_reg(ral_file.get_name(),ral_regs[reg_name].get_name(),SLA_FALSE,rd_data); 
  end

endtask : compare_regs

task hqm_iosf_base_seq::read_and_check_reg( string                     file_name,
                                     string                     reg_name,
                                     boolean_t                  exp_error,
                                     output     sla_ral_data_t  rd_data
                                   );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read_and_check(status,rd_data,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
endtask : read_and_check_reg

task hqm_iosf_base_seq::poll  ( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       input   sla_ral_data_t   exp_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        rd_val[$];
  sla_ral_data_t        reg_val;
  sla_ral_data_t        rd_data;
  string                field_names[$];
  sla_ral_data_t        exp_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  field_names.delete();
  exp_vals.delete();
   
  field_names.push_back(field_name.toupper());
  exp_vals.push_back(exp_data);

  ral_reg.readx_fields(status,field_names,exp_vals,rd_val,ral_access_path,SLA_TRUE,this,.sai(legal_sai),.ignore_access_error(exp_error));
  reg_val = rd_val.pop_front(); 
  rd_data = ral_field.get_val(reg_val);

endtask : poll

task hqm_iosf_base_seq::wait_ns_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

task hqm_iosf_base_seq::poll_reg_val(input sla_ral_reg r, logic [31:0] comp_val, logic [31:0] mask, integer timeout_val = 500);

  sla_status_t      status;
  sla_ral_data_t    rd_val, wr_val;
  int               iteration;
  sla_ral_sai_t     legal_sai;

  r.read(status,rd_val,"primary",this,.sai(legal_sai));
  `ovm_info(get_name(), $sformatf("Polling for reg (%s) to reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask),OVM_LOW)
  for(iteration=0; ( ((rd_val & mask) != (comp_val & mask)) && (iteration<`HQM_POLL_REG_ITER) );iteration++ ) begin
    repeat(timeout_val/10) wait_ns_clk(10);
    r.read(status,rd_val,"primary",this,.sai(legal_sai));
  end

  if(iteration==`HQM_POLL_REG_ITER)    
    `ovm_error(get_name(), $sformatf("Polling for reg (%s) didn't reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask))
  else
    `ovm_info(get_name(),  $sformatf("Polling for reg (%s) did reach value comp_val(0x%0x), rd_val(0x%0x), mask(0x%0x)",r.get_name(),comp_val,rd_val, mask),OVM_LOW)

endtask: poll_reg_val

task hqm_iosf_base_seq::WriteReg( string               file_name,
                                      string               reg_name,
                                      sla_ral_data_t       wr_data
                                    );
  sla_ral_file      ral_file;
  sla_ral_reg       ral_reg;
  sla_status_t      status;
  sla_ral_sai_t     legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  ral_reg.write(status,wr_data,ral_access_path,this,.sai(legal_sai));
endtask : WriteReg

task hqm_iosf_base_seq::WriteField( string          file_name,
                                        string          reg_name,
                                        string          field_name,
                                        sla_ral_data_t  wr_data
                                      );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  string                field_names[$];
  sla_ral_data_t        field_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_WRITE);

  field_names.delete();
  field_vals.delete();

  field_names.push_back(field_name);
  field_vals.push_back(wr_data);

  ral_reg.write_fields(status,field_names,field_vals,ral_access_path,this,.sai(legal_sai));
endtask : WriteField

task hqm_iosf_base_seq::ReadReg( string                     file_name,
                                     string                     reg_name,
                                     boolean_t                  exp_error,
                                     output     sla_ral_data_t  rd_data
                                   );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read(status,rd_data,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));
endtask : ReadReg

task hqm_iosf_base_seq::ReadField( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       output   sla_ral_data_t  rd_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        reg_val;

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);

  ral_reg.read(status,reg_val,ral_access_path,this,.sai(legal_sai),.ignore_access_error(exp_error));

  rd_data = ral_field.get_val(reg_val);
endtask : ReadField

task hqm_iosf_base_seq::compare  ( string                   file_name,
                                       string                   reg_name,
                                       string                   field_name,
                                       boolean_t                exp_error,
                                       input   sla_ral_data_t   exp_data
                                     );
  sla_ral_file          ral_file;
  sla_ral_reg           ral_reg;
  sla_ral_field         ral_field;
  sla_status_t          status;
  sla_ral_sai_t         legal_sai;
  sla_ral_data_t        rd_val[$];
  sla_ral_data_t        reg_val;
  sla_ral_data_t        rd_data;
  string                field_names[$];
  sla_ral_data_t        exp_vals[$];

  ral_file = ral.find_file({base_tb_env_hier, file_name});
  if (ral_file == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL file ",file_name})
    return;
  end

  ral_reg = ral_file.find_reg(reg_name);
  if (ral_reg == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL register ",reg_name})
    return;
  end

  ral_field = ral_reg.find_field(field_name);
  if (ral_field == null) begin
    `ovm_error(get_full_name(),{"unable to get handle to RAL field ",field_name})
    return;
  end

  legal_sai     = ral_reg.pick_legal_sai_value(RAL_READ);
  field_names.delete();
  exp_vals.delete();
   
  field_names.push_back(field_name.toupper());
  exp_vals.push_back(exp_data);

  `ovm_info(get_full_name(),$sformatf("\n status = %s, ral_access_path = %s, legal_sai = %h, exp_error = %b", status, ral_access_path, legal_sai, exp_error),OVM_LOW)
  ral_reg.readx_fields(status,field_names,exp_vals,rd_val,ral_access_path,SLA_FALSE,this,.sai(legal_sai),.ignore_access_error(exp_error));
  reg_val = rd_val.pop_front(); 
  rd_data = ral_field.get_val(reg_val);

endtask : compare

task hqm_iosf_base_seq::send_command(input sla_ral_reg register , input trans_type_t cmd_type,input xaction_class_e xaction_class , input bit [63:0] addr, input bit [63:0] wdata, input bit [2:0] iosf_tag, input bit [2:0] bar, input bit [7:0] fid = 0,input bit [3:0] fbe, input bit [3:0] sbe,input bit [3:0] misc = 0, input bit np_32_64_seq = 0, input bit parity_en_checks = 0,input bit exp_rsp, input bit compare_completion,input bit do_compare=1,input bit [1:0] rsp = 0 ,input bit [63:0] actual_data);

    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
  
    if(cmd_type == MemWr || cmd_type == MemRd || cmd_type == Pm_Req) begin 
      iosf_addr     = new[6];
      iosf_addr[0]  = addr[7:0];
      iosf_addr[1]  = addr[15:8];
      iosf_addr[2]  = addr[23:16];
      iosf_addr[3]  = addr[31:24];
      iosf_addr[4]  = addr[39:32];
      iosf_addr[5]  = addr[47:40];
    end else begin
      iosf_addr     = new[2];
      iosf_addr[0]  = addr[7:0];
      iosf_addr[1]  = addr[15:8];
    end
  
    if(((cmd_type == CfgWr || cmd_type == MemWr || cmd_type == CmpD || cmd_type == IoWr || cmd_type == CrWr || cmd_type == LocalSync || cmd_type == SetId_Txn || cmd_type == VirtualWire || cmd_type == DoPme) && sbe==0)) begin 
      iosf_data = new[4];
      iosf_data[0] = wdata[7:0];
      iosf_data[1] = wdata[15:8];
      iosf_data[2] = wdata[23:16];
      iosf_data[3] = wdata[31:24];
      legal_sai=register.pick_legal_sai_value(RAL_WRITE);
      $display("This SAI is picked");
    end 
    else if((((cmd_type == CfgWr || cmd_type == MemWr) && sbe!=0) || cmd_type == Pm_Req || cmd_type == BootPrep))begin 
    iosf_data          = new[8];
    iosf_data[0]       = wdata[7:0];
    iosf_data[1]       = wdata[15:8];
    iosf_data[2]       = wdata[23:16];
    iosf_data[3]       = wdata[31:24];
    iosf_data[4]       = wdata[39:32];
    iosf_data[5]       = wdata[47:40];
    iosf_data[6]       = wdata[55:48];
    iosf_data[7]       = wdata[63:56];
      legal_sai=register.pick_legal_sai_value(RAL_WRITE);
    end
    else begin
      legal_sai=register.pick_legal_sai_value(RAL_READ);
    end
//    my_ext_headers[1]=legal_sai; 
    if(np_32_64_seq == 'h1)begin           
     my_ext_headers[3]   = {4'h0,$urandom_range(0,15)};
    end
    `ovm_do_on_with(sb_seq, p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type()),
      
      { addr_i.size         == iosf_addr.size;
        foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
        eh_i                == 1'b1;
        ext_headers_i.size  == 4;
        foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
//        xaction_class_i     == 1;
        xaction_class_i     == xaction_class;
        src_pid_i           == dest_pid[7:0];
        dest_pid_i          == src_pid[7:0];
        local_src_pid_i     == dest_pid[15:8];
        local_dest_pid_i    == src_pid[15:8];
        opcode_i            == cmd_type;
        tag_i               == iosf_tag;
        fbe_i               == fbe;
        sbe_i               == sbe;
        fid_i               == fid;
        bar_i               == bar;
        misc_i              == misc;
        exp_rsp_i           == exp_rsp;
        compare_completion_i == compare_completion;
        (cmd_type == CfgWr || cmd_type == MemWr || cmd_type == CmpD) -> 
        {data_i.size         == iosf_data.size;
        foreach (data_i[j]) data_i[j] == iosf_data[j];}
    })
     
     if(xaction_class == NON_POSTED && parity_en_checks == 0)begin
        if((cmd_type == MemRd && fbe == 4'h0f) || cmd_type == CfgRd ) begin 
            rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
            rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
            rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
            rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
       if(do_compare)begin
           if(rdata == actual_data)begin//rdata check
              ovm_report_info(get_full_name(), $psprintf("rdata check successful for %s command and Address=0x%x ", cmd_type, addr), OVM_LOW);
           end else begin
              ovm_report_error(get_full_name(), $psprintf("rdata check failed for command %s and Address=0x%x. Expected rdata is 0x%x,  rdata is 0x%0x",cmd_type, addr, actual_data, rdata), OVM_LOW);
           end
        end
      end
     if(sb_seq.rx_compl_xaction.tag == iosf_tag) begin //Tag check
        ovm_report_info(get_full_name(), $psprintf("Tag check successful for %s command and Address=0x%x ", cmd_type, addr), OVM_LOW);
     end else begin
        ovm_report_error(get_full_name(), $psprintf("Tag check failed for command %s and Address=0x%x. Expected tag is 0x%x, Actual tag is 0x%0x",cmd_type, addr,iosf_tag, sb_seq.rx_compl_xaction.tag), OVM_LOW);
     end 
     if(sb_seq.rx_compl_xaction.rsp == rsp)begin//rsp check
        ovm_report_info(get_full_name(), $psprintf("rsp check successful for %s command and Address=0x%x ", cmd_type, addr), OVM_LOW);
     end else begin
        ovm_report_error(get_full_name(), $psprintf("rsp check failed for command %s  and Address=0x%x. Expected rsp is 0x%x, Actual rsp is 0x%0x",cmd_type , addr,rsp, sb_seq.rx_compl_xaction.rsp), OVM_LOW); 
     end
     iosf_tag++;
   end
//   iosf_tag++;
    if(xaction_class == NON_POSTED && parity_en_checks == 1)begin
        if((cmd_type == MemRd && fbe == 4'h0f) || cmd_type == CfgRd ) begin 
            rdata[7:0]      = sb_seq.rx_compl_xaction.data[0];
            rdata[15:8]     = sb_seq.rx_compl_xaction.data[1];
            rdata[23:16]    = sb_seq.rx_compl_xaction.data[2];
            rdata[31:24]    = sb_seq.rx_compl_xaction.data[3];
        if(rdata == actual_data) begin
          `ovm_error(get_full_name(),$psprintf("Parity injected on IOSF SB. For address 0x%0x read data (0x%08x) does match error transaction write data (0x%08x)",addr,rdata,actual_data))
      end 
       if(sb_seq.rx_compl_xaction.rsp == rsp)begin//rsp check
        ovm_report_info(get_full_name(), $psprintf("rsp check successful for %s command and Address=0x%x ", cmd_type, addr), OVM_LOW);
       end else begin
        ovm_report_error(get_full_name(), $psprintf("rsp check failed for command %s  and Address=0x%x. Expected rsp is 0x%x, Actual rsp is 0x%0x",cmd_type , addr,rsp, sb_seq.rx_compl_xaction.rsp), OVM_LOW); 
       end
     end
     iosf_tag++;
    end
  endtask


  task hqm_iosf_base_seq::send_command_with_constraint(input sla_ral_reg register , input trans_type_t cmd_type,input trans_type_e const_raint=1, input bit const_raint_mode=1,input xaction_class_e xaction_class , input bit [63:0] addr, input bit [63:0] wdata, input bit [2:0] iosf_tag, input bit [2:0] bar, input bit [7:0] fid = 0,input bit [3:0] fbe, input bit [3:0] sbe, input bit parity_en = 0,input bit exp_rsp, input bit compare_completion ,input bit [1:0] rsp = 0 ,input bit [63:0] actual_data);

    iosfsbm_cm::flit_t  iosf_addr[];
    iosfsbm_cm::flit_t  iosf_data[];
  
    if(cmd_type == MemWr || cmd_type == MemRd || cmd_type == Pm_Req) begin 
      iosf_addr     = new[6];
      iosf_addr[0]  = addr[7:0];
      iosf_addr[1]  = addr[15:8];
      iosf_addr[2]  = addr[23:16];
      iosf_addr[3]  = addr[31:24];
      iosf_addr[4]  = addr[39:32];
      iosf_addr[5]  = addr[47:40];
    end else begin
      iosf_addr     = new[2];
      iosf_addr[0]  = addr[7:0];
      iosf_addr[1]  = addr[15:8];
    end
  
    if(((cmd_type == CfgWr || cmd_type == MemWr || cmd_type == CmpD) && sbe==0)) begin 
      iosf_data = new[4];
      iosf_data[0] = wdata[7:0];
      iosf_data[1] = wdata[15:8];
      iosf_data[2] = wdata[23:16];
      iosf_data[3] = wdata[31:24];
      legal_sai=register.pick_legal_sai_value(RAL_WRITE);
    end 
    else if((((cmd_type == CfgWr || cmd_type == MemWr) && sbe==4'h0f) || cmd_type == Pm_Req))begin 
    iosf_data          = new[8];
    iosf_data[0]       = wdata[7:0];
    iosf_data[1]       = wdata[15:8];
    iosf_data[2]       = wdata[23:16];
    iosf_data[3]       = wdata[31:24];
    iosf_data[4]       = wdata[39:32];
    iosf_data[5]       = wdata[47:40];
    iosf_data[6]       = wdata[55:48];
    iosf_data[7]       = wdata[63:56];
      legal_sai=register.pick_legal_sai_value(RAL_WRITE);
    end
    else begin
      legal_sai=register.pick_legal_sai_value(RAL_READ);
    end

//    my_ext_headers[1]=legal_sai; 

     `ovm_create_on(sb_seq,p_sequencer.pick_sequencer(iosf_sb_sla_pkg::get_src_type())); 
     if(const_raint == 'h0)begin
       sb_seq.parity_err_con.constraint_mode(const_raint_mode);
     end

    `ovm_rand_send_with(sb_seq,{ addr_i.size   == iosf_addr.size;
      foreach (addr_i[j]) addr_i[j] == iosf_addr[j];
      eh_i                == 1'b1;
      ext_headers_i.size  == 4;
      foreach (ext_headers_i[j]) ext_headers_i[j] == my_ext_headers[j];
      xaction_class_i     == xaction_class ;
      src_pid_i           == dest_pid[7:0];
      dest_pid_i          == src_pid[7:0];
      local_src_pid_i     == dest_pid[15:8];
      local_dest_pid_i    == src_pid[15:8];
      opcode_i            == cmd_type;
      tag_i               == iosf_tag;
      fbe_i               == fbe;
      sbe_i               == sbe;
      fid_i               == fid;
      bar_i               == bar;
      exp_rsp_i           == exp_rsp;
      parity_err_i        == parity_en; //enable parity error injection
      compare_completion_i == compare_completion;
    })
    //   iosf_tag++;
  endtask
