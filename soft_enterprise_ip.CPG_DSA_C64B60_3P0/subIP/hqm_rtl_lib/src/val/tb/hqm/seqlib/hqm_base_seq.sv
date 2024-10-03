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
// File   : hqm_base_seq.sv
// Author : 
//
// Description :
//    Contains common tasks/functions which are used by various sequences.
//
// -----------------------------------------------------------------------------

`ifndef HQM_BASE_SEQ__SV
`define HQM_BASE_SEQ__SV

class hqm_base_seq extends ovm_sequence;

    string cfg_cmds[$];

    sla_ral_env           ral_env;
    sla_ral_access_path_t ral_access_path;
    virtual hqm_misc_if     pins;
    hqm_tb_env            i_hqm_tb_env;
    hqm_cfg               i_hqm_cfg;
    hqm_pp_cq_status      i_hqm_pp_cq_status;
    int                   pgcb_ref;

    string                inst_suffix = "";

    `ovm_sequence_utils(hqm_base_seq, sla_sequencer)

    extern         function             new                      ( string             name       = "hqm_base_seq",
                                                                   ovm_sequencer_base sequencer  = null,
                                                                   ovm_sequence       parent_seq = null
                                                                 );

    extern         function sla_ral_reg    get_reg_handle        ( string reg_name,
                                                                   string file_name = ""
                                                                 );
    extern         function sla_ral_data_t get_actual_ral        ( string reg_name,
                                                                   string file_name = ""
                                                                 );
    extern         function bit [63:0]     get_cq_addr_val       ( e_port_type port_type,
                                                                   bit [6:0]   cq
                                                                 );
    extern         function sla_ral_addr_t get_reg_addr          ( string reg_name,
                                                                   string file_name = ""
                                                                 );
    extern         function sla_ral_addr_t get_reg_addr_sb       ( string reg_name,
                                                                   string file_name = ""
                                                                 );
    extern         function sla_ral_sai_t  pick_legal_sai_value  ( sla_ral_rw_t op,
                                                                   string       reg_name, 
                                                                   string       file_name = ""
                                                                 );
    extern virtual function void           get_hqm_cfg           ();
    extern virtual function void           get_hqm_pp_cq_status  ();
    extern virtual task                    write_reg             ( string         reg_name,
                                                                   sla_ral_data_t wr_data,
                                                                   string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    write_fields          ( string reg_name,
                                                                   string field_name[$],
                                                                   sla_ral_data_t wr_data[$],
                                                                   string file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 ); 
    extern virtual task                    read_reg              (        string         reg_name,
                                                                   output sla_ral_data_t rd_data,
                                                                   input  string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    read_field           (         string reg_name,
                                                                          string field_name,
                                                                   output sla_ral_data_t rd_data,
                                                                   input  string file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 ); 

    extern virtual task                    read_fields           (        string reg_name,
                                                                          string field_name[$],
                                                                   output sla_ral_data_t rd_data[$],
                                                                   input  string file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 ); 
    extern virtual task                    poll_reg              ( string         reg_name,
                                                                   sla_ral_data_t exp_val,
                                                                   string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    poll_fields           ( string reg_name,
                                                                   string field_name[$],
                                                                   sla_ral_data_t exp_val[$],
                                                                   string file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    compare_reg           (        string         reg_name,
                                                                          sla_ral_data_t exp_val,
                                                                   output sla_ral_data_t rd_val,
                                                                   input  string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );

    extern virtual task                    compare_fields        (        string         reg_name,
                                                                          string         field_name[$],
                                                                          sla_ral_data_t exp_val[$],
                                                                   output sla_ral_data_t rd_val[$],
                                                                   input  string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    read_and_check_reg    ( string         reg_name,
                                                                   string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    read_and_check_fields ( string         reg_name,
                                                                   string         field_name[$],
                                                                   string         file_name = "",
                                                                   input  sla_ral_sai_t  sai = 3      
                                                                 );
    extern virtual task                    wait_for_clk          (  int cycle_count = 1);

    extern virtual task                    stop_bg_cfg_gen_seq   ();

    extern virtual function void           resume_bg_cfg_gen_seq ();

    extern virtual task                    wait_for_sch_cnt      (bit is_ldb, bit [5:0] cq, int unsigned exp_cnt, int poll_delay = 1);

    extern function void send_new         (bit [7:0] pp_num, bit [3:0] vf_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0);
    extern function void send_new_pf      (bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0);
    extern function void send_new_pf_sciov      (bit is_nm_pf, bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0);
    extern task          send_comp_t      (bit [7:0] pp_num, bit [3:0] vf_num, int unsigned rpt = 1);
    extern task          send_comp_t_pf_sciov   (bit is_nm_pf, bit [7:0] pp_num, int unsigned rpt = 1);
    extern task          send_comp_t_pf   (bit [7:0] pp_num, int unsigned rpt = 1);
    extern task          send_bat_t       (bit [7:0] pp_num, bit [3:0] vf_num, int unsigned rpt = 1, int unsigned tkn_cnt = 0, bit is_ldb = 1'b0);
    extern task          send_bat_t_pf    (bit [7:0] pp_num, int unsigned rpt = 1, int unsigned tkn_cnt = 0, bit is_ldb = 1'b0);
    extern task          send_bat_t_pf_sciov    (bit is_nm_pf, bit [7:0] pp_num, int unsigned rpt = 1, int unsigned tkn_cnt = 0, bit is_ldb = 1'b0);
    extern function void send_cmd_pf      (bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0, bit [0:3] cmd = 4'b1000, bit [2:0] qpri = 3'b0);
    extern function void send_cmd_pf_sciov      (bit is_nm_pf, bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0, bit [0:3] cmd = 4'b1000, bit [2:0] qpri = 3'b0);
    
    extern task          poll_sch         (bit [7:0] cq_num, int unsigned exp_cnt, bit is_ldb = 1'b0, int unsigned delay =1, int unsigned timeout = 4000);
    extern task          execute_cfg_cmds ();
    extern task          pgcb_clk();
    extern task          setup_hqm_flr(int flr_set, int pending_status_cknum);
    extern task          hqm_pmcsr_ps_cfg(int pmcsr_ps, int wait_loop);
    extern task          HqmAtsInvalidRequest_task(int is_ldb, int cq_num, bit global_inv=0);
    extern task          HqmAts_deletetlb();

endclass : hqm_base_seq

function hqm_base_seq::new(string name = "hqm_base_seq", ovm_sequencer_base sequencer = null, ovm_sequence parent_seq = null);

    super.new(name, sequencer, parent_seq);
    ovm_report_info(get_full_name(), $psprintf("hqm_base_seq -- Start"), OVM_MEDIUM);
    // -- get hqm_tb_env ptr
    `sla_assert ($cast(i_hqm_tb_env, sla_utils::get_comp_by_name("i_hqm_tb_env")), ("Couldn't find i_hqm_tb_env ptr"));
    if (i_hqm_tb_env == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("i_hqm_tb_env is null"));
    end

   // -- get pins interface
   `sla_assert ($cast(pins, i_hqm_tb_env.pins), ("Couldn't find hqm_msix_if pins"));
   if (pins == null) begin
      ovm_report_fatal(get_full_name(), $psprintf("pins is null"));
   end 

   // -- get ral_env ptr
   `sla_assert ($cast(ral_env, sla_ral_env::get_ptr()), ("Unable to get handle to RAL"));
    ral_access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();

   // -- ral access path
   $value$plusargs("HQM_RAL_ACCESS_PATH=%s",ral_access_path);
    if (ovm_is_match("sideband", ral_access_path))
     begin : is_sbd
     `ovm_info(get_full_name(),$sformatf("\n access_path is sideband \n"),OVM_LOW)
      ral_access_path = iosf_sb_sla_pkg::get_src_type();
     end   : is_sbd
    ovm_report_info(get_full_name(), $psprintf("hqm_base_seq -- End"),   OVM_MEDIUM);

endfunction : new

//---------------------------------------------------------------
//---------------------------------------------------------------
function sla_ral_reg hqm_base_seq::get_reg_handle (string reg_name, string file_name = "");

    ovm_report_info(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- Start", reg_name, file_name), OVM_MEDIUM);
    if (file_name == "") begin
        get_reg_handle = ral_env.find_reg(reg_name);
    end else begin
        get_reg_handle = ral_env.find_reg_by_file_name(reg_name, file_name);
    end
    if (get_reg_handle == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- Null reg handle", reg_name, file_name));
    end
    ovm_report_info(get_full_name(), $psprintf("get_reg_handle(reg_name=%0s, file_name=%0s) -- End", reg_name, file_name), OVM_MEDIUM);

endfunction : get_reg_handle

task hqm_base_seq::write_reg (string reg_name, sla_ral_data_t wr_data, string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg  reg_h;
    sla_status_t status;

    ovm_report_info(get_full_name(), $psprintf("write_reg(reg_name=%0s, wr_data=0x%0x, file_name=%0s, sai=0x%0x) -- Start", reg_name, wr_data, file_name, sai), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.write(status, wr_data, ral_access_path, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("write_reg(reg_name=%0s, wr_data=0x%0x, file_name=%0s, sai=0x%0x) -- End", reg_name, wr_data, file_name, sai), OVM_MEDIUM);

endtask : write_reg

task hqm_base_seq::write_fields (string reg_name, string field_name[$], sla_ral_data_t wr_data[$], string file_name = "",  input sla_ral_sai_t sai );

    sla_ral_reg  reg_h;
    sla_status_t status;
    string         field_names_uppercase[$];

    ovm_report_info(get_full_name(), $psprintf("write_fields(reg_name=%0s, field_name=%0p, wr_data=%0p, file_name=%0s, sai=0x%0x) -- Start", reg_name, field_name, wr_data, file_name, sai), OVM_MEDIUM);
    foreach(field_name[i]) begin
        field_names_uppercase.push_back(field_name[i].toupper());
    end
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.write_fields(status, field_names_uppercase, wr_data, ral_access_path, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("write_fields(reg_name=%0s, field_name=%0p, wr_data=%0p, file_name=%0s, sai=0x%0x) -- End", reg_name, field_names_uppercase, wr_data, file_name, sai), OVM_MEDIUM);

endtask : write_fields

task hqm_base_seq::read_reg (string reg_name, output sla_ral_data_t rd_data, input string file_name = "",input sla_ral_sai_t sai );

    sla_ral_reg  reg_h;
    sla_status_t status;

    ovm_report_info(get_full_name(), $psprintf("read_reg(reg_name=%0s, file_name=%0s, sai=0x%0x) -- Start", reg_name, file_name, sai), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.read(status, rd_data, ral_access_path, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("read_reg(reg_name=%0s, file_name=%0s, sai=0x%0x) -- End", reg_name, file_name, sai), OVM_MEDIUM);

endtask : read_reg

task hqm_base_seq::read_field (string reg_name, string field_name, output sla_ral_data_t rd_data, input string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg  reg_h;
    sla_status_t status;
    string         field_names_uppercase[$];
    sla_ral_data_t rd_data_q[$];

    ovm_report_info(get_full_name(), $psprintf("read_field(reg_name=%0s, field_name=%0s, file_name=%0s, sai=0x%0x) -- Start", reg_name, field_name, file_name, sai), OVM_MEDIUM);
    field_names_uppercase.push_back(field_name.toupper());

    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.read_fields(status, field_names_uppercase, rd_data_q, ral_access_path, this, .sai(sai));
    rd_data = rd_data_q[0];
    ovm_report_info(get_full_name(), $psprintf("read_field(reg_name=%0s, field_name_q=%0p, file_name=%0s, sai=0x%0x) rd_data_q=%0p rd_data=0x%0x -- End", reg_name, field_names_uppercase, file_name, sai, rd_data_q, rd_data), OVM_MEDIUM);

endtask : read_field


task hqm_base_seq::read_fields (string reg_name, string field_name[$], output sla_ral_data_t rd_data[$], input string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg  reg_h;
    sla_status_t status;
    string         field_names_uppercase[$];

    ovm_report_info(get_full_name(), $psprintf("read_fields(reg_name=%0s, field_name=%0p, file_name=%0s, sai=0x%0x) -- Start", reg_name, field_name, file_name, sai), OVM_MEDIUM);
    foreach(field_name[i]) begin
        field_names_uppercase.push_back(field_name[i].toupper());
    end
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.read_fields(status, field_names_uppercase, rd_data, ral_access_path, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("read_fields(reg_name=%0s, field_name=%0p, file_name=%0s, sai=0x%0x) -- End", reg_name, field_names_uppercase, file_name, sai), OVM_MEDIUM);

endtask : read_fields

task hqm_base_seq::poll_reg (string reg_name, sla_ral_data_t exp_val, string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg  reg_h;
    sla_status_t status;
    sla_ral_data_t   val;

    ovm_report_info(get_full_name(), $psprintf("poll_reg(reg_name=%0s, exp_val=0x%0x, file_name=%0s, sai=0x%0x) -- Start", reg_name, exp_val, file_name, sai), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.readx(status, exp_val, 'hffff_ffff, val, ral_access_path, SLA_TRUE, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("poll_reg(reg_name=%0s, exp_val=0x%0x, file_name=%0s, sai=0x%0x) -- End", reg_name, exp_val, file_name, sai), OVM_MEDIUM);

endtask : poll_reg

task hqm_base_seq::poll_fields (string reg_name, string field_name[$], sla_ral_data_t exp_val[$], string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg      reg_h;
    sla_status_t status;
    sla_ral_data_t   val[$];
    string         field_names_uppercase[$];

    ovm_report_info(get_full_name(), $psprintf("poll_fields(reg_name=%0s, field_name=%0p, exp_val=%0p, file_name=%0s, sai=0x%0x) -- Start", reg_name, field_name, exp_val, file_name, sai), OVM_MEDIUM);
    foreach(field_name[i]) begin
        field_names_uppercase.push_back(field_name[i].toupper());
    end
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.readx_fields(status, field_names_uppercase, exp_val, val, ral_access_path, SLA_TRUE, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("poll_fields(reg_name=%0s, field_name=%0p, exp_val=%0p, file_name=%0s, sai=0x%0x) -- End", reg_name, field_names_uppercase, exp_val, file_name, sai), OVM_MEDIUM);

endtask : poll_fields

task hqm_base_seq::compare_reg (string reg_name, sla_ral_data_t exp_val, output sla_ral_data_t rd_val, input string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg    reg_h;
    sla_status_t   status;

    ovm_report_info(get_full_name(), $psprintf("compare_reg(reg_name=%0s, exp_val=0x%0x, file_name=%0s, sai=0x%0x) -- Start", reg_name, exp_val, file_name,sai), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.readx(status, exp_val, 'hffff_ffff, rd_val, ral_access_path, SLA_FALSE, this, .sai(sai) );
    ovm_report_info(get_full_name(), $psprintf("compare_reg(reg_name=%0s, exp_val=0x%0x, rd_val, file_name=%0s, sai=0x%0x) -- End", reg_name, exp_val, rd_val, file_name, sai), OVM_MEDIUM);

endtask : compare_reg

task hqm_base_seq::compare_fields (string reg_name, string field_name[$], sla_ral_data_t exp_val[$], output sla_ral_data_t rd_val[$], input string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg    reg_h;
    sla_status_t   status;
    string         field_names_uppercase[$];

    ovm_report_info(get_full_name(), $psprintf("compare_fields(reg_name=%0s, field_name=%0p, exp_val=%0p, file_name=%0s, sai=0x%0x) -- Start", reg_name, field_name, exp_val, file_name, sai), OVM_MEDIUM);
    foreach(field_name[i]) begin
        field_names_uppercase.push_back(field_name[i].toupper());
    end
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.readx_fields(status, field_names_uppercase, exp_val, rd_val, ral_access_path, SLA_FALSE, this, .sai(sai)); 
    ovm_report_info(get_full_name(), $psprintf("compare_fields(reg_name=%0s, field_name=%0p, exp_val=%0p, rd_val=%0p, file_name=%0s, sai=0x%0x) -- End", reg_name, field_names_uppercase, exp_val, rd_val, file_name, sai), OVM_MEDIUM);

endtask : compare_fields

task hqm_base_seq::read_and_check_reg (string reg_name, string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg    reg_h;
    sla_status_t   status;
    sla_ral_data_t val;

    ovm_report_info(get_full_name(), $psprintf("read_and_check_reg(reg_name=%0s, file_name=%0s, sai=0x%0x) -- Start", reg_name, file_name, sai), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.read_and_check(status, val, ral_access_path, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("read_and_check_reg(reg_name=%0s, file_name=%0s, sai=0x%0x) -- End", reg_name, file_name, sai), OVM_MEDIUM);

endtask : read_and_check_reg

task hqm_base_seq::read_and_check_fields (string reg_name, string field_name[$], string file_name = "", input sla_ral_sai_t sai);

    sla_ral_reg    reg_h;
    sla_status_t   status;
    sla_ral_data_t val[$];
    string         field_names_uppercase[$];

    ovm_report_info(get_full_name(), $psprintf("read_and_check_fields(reg_name=%0s, field_name=%0p, file_name=%0s, sai=0x%0x) -- Start", reg_name, field_name, file_name, sai), OVM_MEDIUM);
    foreach(field_name[i]) begin
        field_names_uppercase.push_back(field_name[i].toupper());
    end
    reg_h = get_reg_handle(reg_name, file_name);
    reg_h.read_and_check_fields(status, field_names_uppercase, val, ral_access_path, this, .sai(sai));
    ovm_report_info(get_full_name(), $psprintf("read_and_check_fields(reg_name=%0s, field_name=%0p, file_name=%0s, sai=0x%0x) -- End", reg_name, field_names_uppercase, file_name, sai), OVM_MEDIUM);

endtask : read_and_check_fields

task hqm_base_seq::wait_for_clk (int cycle_count = 1);

    repeat(cycle_count) begin
        @(sla_tb_env::sys_clk_r); 
    end

endtask : wait_for_clk

function sla_ral_data_t hqm_base_seq::get_actual_ral(string reg_name, string file_name = "");

    sla_ral_reg reg_h;

    ovm_report_info(get_full_name(), $psprintf("get_actual_ral(reg_name=%0s, file_name=%0s) -- Start", reg_name, file_name), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    get_actual_ral = reg_h.get_actual();
    ovm_report_info(get_full_name(), $psprintf("get_actual_ral(reg_name=%0s, file_name=%0s, get_actual_ral=0x%0x) -- End", reg_name, file_name, get_actual_ral), OVM_MEDIUM);

endfunction : get_actual_ral

function bit [63:0] hqm_base_seq::get_cq_addr_val(e_port_type port_type, bit [6:0] cq);

    sla_ral_reg reg_h;
    string      port_type_str;
    bit is_ldb;
    bit [63:0] cq_physical_addr_val;

    ovm_report_info(get_full_name(), $psprintf("get_cq_addr_val(port_type=%0p, cq=0x%0x) -- Start", port_type, cq), OVM_MEDIUM);
    if (port_type == LDB) begin
        port_type_str = "ldb";
        is_ldb = 1;
    end else begin
        port_type_str = "dir";
        is_ldb = 0;
    end
    get_cq_addr_val[31:0]  = get_actual_ral($psprintf("%0s_cq_addr_l[%0d]", port_type_str, cq), "hqm_system_csr");
    get_cq_addr_val[63:32] = get_actual_ral($psprintf("%0s_cq_addr_u[%0d]", port_type_str, cq), "hqm_system_csr");
    ovm_report_info(get_full_name(), $psprintf("get_cq_addr_val(port_type=%0p, cq=0x%0x, get_cq_addr_val=0x%0x) -- Virtual address read from cq_addr_l/cq_addr_u", port_type, cq, get_cq_addr_val), OVM_MEDIUM);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- get_cq_addr_val is virtual address
    //-- cq_physical_addr_val=get_cq_hpa(is_ldb, cq);  
    //----------------------------------
    get_hqm_cfg();
    if(i_hqm_cfg.ats_enabled==1) begin
       cq_physical_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, cq); 
       ovm_report_info(get_full_name(), $psprintf("get_cq_addr_val(port_type=%0p, cq=0x%0x, get_cq_addr_val=0x%0x) -- physical address 0x%0x (i_hqm_cfg.ats_enabled==1)", port_type, cq, get_cq_addr_val, cq_physical_addr_val), OVM_MEDIUM);
       get_cq_addr_val = cq_physical_addr_val; 
    end
endfunction : get_cq_addr_val

function sla_ral_addr_t hqm_base_seq::get_reg_addr(string reg_name, string file_name = "");

    ovm_report_info(get_full_name(), $psprintf("get_reg_addr(reg_name=%0s, file_name=%0s) -- Start", reg_name, file_name), OVM_MEDIUM);
    get_reg_addr = ral_env.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), get_reg_handle(reg_name, file_name));
    ovm_report_info(get_full_name(), $psprintf("get_reg_addr(reg_name=%0s, file_name=%0s, get_reg_addr=0x%0x) -- End", reg_name, file_name, get_reg_addr), OVM_MEDIUM);

endfunction : get_reg_addr

function sla_ral_addr_t hqm_base_seq::get_reg_addr_sb(string reg_name, string file_name = "");

    ovm_report_info(get_full_name(), $psprintf("get_reg_addr_sb(reg_name=%0s, file_name=%0s) -- Start", reg_name, file_name), OVM_MEDIUM);
    get_reg_addr_sb = ral_env.get_addr_val(iosf_sb_sla_pkg::get_src_type(), get_reg_handle(reg_name, file_name));
    ovm_report_info(get_full_name(), $psprintf("get_reg_addr_sb(reg_name=%0s, file_name=%0s, get_reg_addr_sb=0x%0x) -- End", reg_name, file_name, get_reg_addr_sb), OVM_MEDIUM);

endfunction : get_reg_addr_sb

function sla_ral_sai_t hqm_base_seq::pick_legal_sai_value(sla_ral_rw_t op, string reg_name, string file_name = "");

    sla_ral_reg reg_h;

    ovm_report_info(get_full_name(), $psprintf("pick_legal_sai_value(op=%0p, reg_name=%0s, file_name=%0s) -- Start", op, reg_name, file_name), OVM_MEDIUM);
    reg_h = get_reg_handle(reg_name, file_name);
    pick_legal_sai_value = reg_h.pick_legal_sai_value(op);
    ovm_report_info(get_full_name(), $psprintf("pick_legal_sai_value(op=%0p, reg_name=%0s, file_name=%0s, sai=0x%0x)", op, reg_name, file_name, pick_legal_sai_value), OVM_MEDIUM);
    ovm_report_info(get_full_name(), $psprintf("pick_legal_sai_value(op=%0p, reg_name=%0s, file_name=%0s) -- End", op, reg_name, file_name), OVM_MEDIUM);

endfunction : pick_legal_sai_value

//---------------------------------------------------------------
//---------------------------------------------------------------
function void hqm_base_seq::get_hqm_cfg();

    ovm_object tmp;

    ovm_report_info(get_full_name(), $psprintf("get_hqm_cfg -- Start"), OVM_MEDIUM);
    if ( p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, tmp) ) begin
        if ( ! ($cast(i_hqm_cfg, tmp)) ) begin
            ovm_report_fatal(get_full_name(), $psprintf("Object passed through i_hqm_cfg not compatible with class type hqm_cfg"));
        end 
    end else begin
        ovm_report_fatal(get_full_name(), $psprintf("No i_hqm_cfg set through set_config_object"));
    end

    ovm_report_info(get_full_name(), $psprintf("get_hqm_cfg -- End"), OVM_MEDIUM);

endfunction : get_hqm_cfg

//---------------------------------------------------------------
//---------------------------------------------------------------
function void hqm_base_seq::get_hqm_pp_cq_status();

    ovm_object tmp;

    ovm_report_info(get_full_name(), $psprintf("get_hqm_pp_cq_status -- Start"), OVM_MEDIUM);
    if ( p_sequencer.get_config_object({"i_hqm_pp_cq_status",inst_suffix}, tmp) ) begin
        if ( ! ($cast(i_hqm_pp_cq_status, tmp)) ) begin
            ovm_report_fatal(get_full_name(), $psprintf("Object passed through i_hqm_pp_cq_status not compatible with class type hqm_pp_cq_status"));
        end 
    end else begin
        ovm_report_fatal(get_full_name(), $psprintf("No i_hqm_pp_cq_status set through set_config_object"));
    end

    ovm_report_info(get_full_name(), $psprintf("get_hqm_pp_cq_status -- End"), OVM_MEDIUM);

endfunction : get_hqm_pp_cq_status

//---------------------------------------------------------------
//---------------------------------------------------------------
task hqm_base_seq::stop_bg_cfg_gen_seq();

    ovm_report_info(get_full_name(), $psprintf("stop_bg_cfg_gen_seq -- Start"), OVM_MEDIUM);
    if ( $test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ") &&  !($test$plusargs("HQM_DISABLE_BACKGROUND_CFG_GEN_SEQ")) )	begin
        ovm_report_info(get_full_name(), $psprintf("Disabling the hqm_background_cfg_gen_seq"), OVM_LOW);
        i_hqm_pp_cq_status.pause_bg_cfg_req = 1'b1;
        wait (i_hqm_pp_cq_status.pause_bg_cfg_ack == 1'b1);
        i_hqm_pp_cq_status.pause_bg_cfg_ack = 1'b0;
    end
    ovm_report_info(get_full_name(), $psprintf("stop_bg_cfg_gen_seq -- End"), OVM_MEDIUM);

endtask : stop_bg_cfg_gen_seq

//---------------------------------------------------------------
//---------------------------------------------------------------
function void hqm_base_seq::resume_bg_cfg_gen_seq();

    ovm_report_info(get_full_name(), $psprintf("resume_bg_cfg_gen_seq -- Start"), OVM_MEDIUM);
    if ($test$plusargs("HQM_BACKGROUND_CFG_GEN_SEQ")) begin
        ovm_report_info(get_full_name(), $psprintf("Resuming hqm_background_cfg_gen_seq"), OVM_LOW);
        i_hqm_pp_cq_status.pause_bg_cfg_req = 1'b0;
    end
    ovm_report_info(get_full_name(), $psprintf("resume_bg_cfg_gen_seq -- End"), OVM_MEDIUM);

endfunction : resume_bg_cfg_gen_seq

task hqm_base_seq::wait_for_sch_cnt(bit is_ldb, bit [5:0] cq, int unsigned exp_cnt, int poll_delay = 1);

    ovm_report_info(get_full_name(), $psprintf("wait_for_sch_cnt(is_ldb=%0b, cq=0x%0x, exp_cnt=%0d, poll_delay=%0d) -- Start", is_ldb, cq, exp_cnt, poll_delay), OVM_MEDIUM);
    if (is_ldb) begin
        forever begin
            ovm_report_info(get_full_name(), $psprintf("Expected scheduled count(is_ldb=%0b, cq=0x%0x, sch_cnt=%0d, exp_cnt=%0d)", is_ldb, cq, i_hqm_pp_cq_status.ldb_pp_cq_status[cq].mon_sch_cnt, exp_cnt), OVM_LOW);
            if (i_hqm_pp_cq_status.ldb_pp_cq_status[cq].mon_sch_cnt == exp_cnt) begin
                ovm_report_info(get_full_name(), $psprintf("Expected scheduled count reached(is_ldb=%0b, cq=0x%0x, sch_cnt=%0d, exp_cnt=%0d)", is_ldb, cq, i_hqm_pp_cq_status.ldb_pp_cq_status[cq].mon_sch_cnt, exp_cnt), OVM_LOW);
                break;
            end
            wait_for_clk(poll_delay);
        end 
    end else begin
        forever begin
            ovm_report_info(get_full_name(), $psprintf("Expected scheduled count(is_ldb=%0b, cq=0x%0x, sch_cnt=%0d, exp_cnt=%0d)", is_ldb, cq, i_hqm_pp_cq_status.dir_pp_cq_status[cq].mon_sch_cnt, exp_cnt), OVM_LOW);
            if (i_hqm_pp_cq_status.dir_pp_cq_status[cq].mon_sch_cnt == exp_cnt) begin
                ovm_report_info(get_full_name(), $psprintf("Expected scheduled count reached(is_ldb=%0b, cq=0x%0x, sch_cnt=%0d, exp_cnt=%0d)", is_ldb, cq, i_hqm_pp_cq_status.dir_pp_cq_status[cq].mon_sch_cnt, exp_cnt), OVM_LOW);
                break;
            end
            wait_for_clk(poll_delay);
        end 
    end
    ovm_report_info(get_full_name(), $psprintf("wait_for_sch_cnt(is_ldb=%0b, cq=0x%0x, exp_cnt=%0d, poll_delay=%0d) -- End", is_ldb, cq, exp_cnt, poll_delay), OVM_MEDIUM);

endtask : wait_for_sch_cnt


//================================================//
//- function to send hcw command
// 1. send_new: send new from dir/ldb PP vf mode
// 1. send_new_pf: send new from dir/ldb PP pf mode
//================================================//

function void hqm_base_seq::send_new(bit [7:0] pp_num, bit [3:0] vf_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0);

    ovm_report_info(get_full_name(), $psprintf("send_new(is_ldb=%0d pp_num=0x%0x, vf_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b) -- Start", is_ldb, pp_num, vf_num, qid, rpt, ingress_drop), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        if(ingress_drop) begin :ingress_drop_check
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d vf_num=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=uno qid=%0d ingress_drop=1", pp_num, vf_num, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d vf_num=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d ingress_drop=1", pp_num, vf_num, qid));
            end
        end : ingress_drop_check
        else begin //No_drop
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d vf_num=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=uno qid=%0d", pp_num, vf_num, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d vf_num=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d", pp_num, vf_num, qid));
            end
        end 
    end
    ovm_report_info(get_full_name(), $psprintf("send_new(is_ldb=%0d pp_num=0x%0x, vf_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b) -- End", is_ldb, pp_num, vf_num, qid, rpt, ingress_drop), OVM_MEDIUM);

endfunction : send_new

//- send_new_pf
function void hqm_base_seq::send_new_pf(bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0);

    ovm_report_info(get_full_name(), $psprintf("send_new_pf(pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b) -- Start", pp_num, qid, rpt, ingress_drop), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        if(ingress_drop) begin :ingress_drop_check_pf
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=uno qid=%0d ingress_drop=1", pp_num, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d ingress_drop=1", pp_num, qid));
            end
        end : ingress_drop_check_pf
        else begin //No_drop
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=uno qid=%0d", pp_num, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d", pp_num, qid));
            end
        end 
    end
    ovm_report_info(get_full_name(), $psprintf("send_new_pf(pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b) -- End", pp_num, qid, rpt, ingress_drop), OVM_MEDIUM);

endfunction : send_new_pf

//- send_new_pf_sciov
function void hqm_base_seq::send_new_pf_sciov(bit is_nm_pf, bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0);

    ovm_report_info(get_full_name(), $psprintf("send_new_pf_sciov(is_nm_pf=%0d, pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b) -- Start", is_nm_pf, pp_num, qid, rpt, ingress_drop), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        if(ingress_drop) begin :ingress_drop_check_pf
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d is_nm_pf=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=uno qid=%0d ingress_drop=1", pp_num, is_nm_pf, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d is_nm_pf=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d ingress_drop=1", pp_num, is_nm_pf, qid));
            end
        end : ingress_drop_check_pf
        else begin //No_drop
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d is_nm_pf=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=uno qid=%0d", pp_num, is_nm_pf, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d is_nm_pf=%0d qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d", pp_num, is_nm_pf, qid));
            end
        end 
    end
    ovm_report_info(get_full_name(), $psprintf("send_new_pf_sciov(is_nm_pf=%0d pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b) -- End", is_nm_pf, pp_num, qid, rpt, ingress_drop), OVM_MEDIUM);

endfunction : send_new_pf_sciov

//send_comp_t vf
task hqm_base_seq::send_comp_t(bit [7:0] pp_num, bit [3:0] vf_num, int unsigned rpt = 1);

    ovm_report_info(get_full_name(), $psprintf("send_comp_t(pp_num=0x%0x, vf_num=0x%0x, rpt=%0d) -- Start", pp_num, vf_num, rpt), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        cfg_cmds.push_back($psprintf("HCW LDB:%0d vf_num=%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=0", pp_num, vf_num));
    end
    execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("send_comp_t(pp_num=0x%0x, vf_num=0x%0x, rpt=%0d) -- End", pp_num, vf_num, rpt), OVM_MEDIUM);

endtask: send_comp_t

//send_comp_t pf
task hqm_base_seq::send_comp_t_pf(bit [7:0] pp_num, int unsigned rpt = 1);

    ovm_report_info(get_full_name(), $psprintf("send_comp_t_pf(pp_num=0x%0x, rpt=%0d) -- Start", pp_num, rpt), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=0", pp_num ));
    end
    execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("send_comp_t_pf(pp_num=0x%0x, rpt=%0d) -- End", pp_num, rpt), OVM_MEDIUM);

endtask: send_comp_t_pf

//send_comp_t pf_sciov
task hqm_base_seq::send_comp_t_pf_sciov(bit is_nm_pf, bit [7:0] pp_num, int unsigned rpt = 1);

    ovm_report_info(get_full_name(), $psprintf("send_comp_t_pf_sciov(is_nm_pf=%0d pp_num=0x%0x, rpt=%0d) -- Start", is_nm_pf, pp_num, rpt), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        cfg_cmds.push_back($psprintf("HCW LDB:%0d is_nm_pf=%0d qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=1 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=0", pp_num,is_nm_pf));
    end
    execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("send_comp_t_pf_sciov(is_nm_pf=%0d pp_num=0x%0x, rpt=%0d) -- End", is_nm_pf, pp_num, rpt), OVM_MEDIUM);

endtask: send_comp_t_pf_sciov

//send_bat_t from vf
task hqm_base_seq::send_bat_t(bit [7:0] pp_num, bit [3:0] vf_num, int unsigned rpt = 1, int unsigned tkn_cnt = 0, bit is_ldb);

    ovm_report_info(get_full_name(), $psprintf("send_bat_t(pp_num=0x%0x, vf_num=0x%0x, rpt=%0d, tkn_cnt=%0d, is_ldb=%0b) -- Start", pp_num, vf_num, rpt, tkn_cnt, is_ldb), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
     if (is_ldb) begin : is_ldb_chk
        cfg_cmds.push_back($psprintf("HCW LDB:%0d vf_num=%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=%0d msgtype=0 qpri=0 qtype=uno qid=0", pp_num, vf_num, tkn_cnt));
     end : is_ldb_chk
     else begin 
        cfg_cmds.push_back($psprintf("HCW DIR:%0d vf_num=%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=%0d msgtype=0 qpri=0 qtype=dir qid=0", pp_num, vf_num, tkn_cnt));
     end 
    end
    execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("send_bat_t(pp_num=0x%0x, vf_num=0x%0x, rpt=%0d, tkn_cnt=%0d, is_ldb=%0b) -- End", pp_num, vf_num, rpt,tkn_cnt, is_ldb), OVM_MEDIUM);

endtask: send_bat_t

//send_bat_t from pf
task hqm_base_seq::send_bat_t_pf(bit [7:0] pp_num, int unsigned rpt = 1, int unsigned tkn_cnt = 0, bit is_ldb);

    ovm_report_info(get_full_name(), $psprintf("send_bat_t_pf(pp_num=0x%0x, rpt=%0d, tkn_cnt=%0d, is_ldb=%0b) -- Start", pp_num, rpt, tkn_cnt, is_ldb), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
     if (is_ldb) begin : is_ldb_chk
        cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=%0d msgtype=0 qpri=0 qtype=uno qid=0", pp_num, tkn_cnt));
     end : is_ldb_chk
     else begin 
        cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=%0d msgtype=0 qpri=0 qtype=dir qid=0", pp_num, tkn_cnt));
     end
    end
    execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("send_bat_t_pf(pp_num=0x%0x, rpt=%0d, tkn_cnt=%0d, is_ldb=%0b) -- End", pp_num, rpt, tkn_cnt, is_ldb), OVM_MEDIUM);

endtask: send_bat_t_pf

//send_bat_t from pf_sciov
task hqm_base_seq::send_bat_t_pf_sciov(bit is_nm_pf, bit [7:0] pp_num, int unsigned rpt = 1, int unsigned tkn_cnt = 0, bit is_ldb);

    ovm_report_info(get_full_name(), $psprintf("send_bat_t_pf_sciov(is_nm_pf=%0d pp_num=0x%0x, rpt=%0d, tkn_cnt=%0d, is_ldb=%0b) -- Start", is_nm_pf, pp_num, rpt, tkn_cnt, is_ldb), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
     if (is_ldb) begin : is_ldb_chk
        cfg_cmds.push_back($psprintf("HCW LDB:%0d is_nm_pf=%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=%0d msgtype=0 qpri=0 qtype=uno qid=0", pp_num, is_nm_pf, tkn_cnt));
     end : is_ldb_chk
     else begin 
        cfg_cmds.push_back($psprintf("HCW DIR:%0d is_nm_pf=%0d qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=%0d msgtype=0 qpri=0 qtype=dir qid=0", pp_num, is_nm_pf, tkn_cnt));
     end
    end
    execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("send_bat_t_pf_sciov(is_nm_pf=%0d pp_num=0x%0x, rpt=%0d, tkn_cnt=%0d, is_ldb=%0b) -- End", is_nm_pf, pp_num, rpt, tkn_cnt, is_ldb), OVM_MEDIUM);

endtask: send_bat_t_pf_sciov

task hqm_base_seq::poll_sch( bit [7:0] cq_num, int unsigned exp_cnt, bit is_ldb = 1'b0, int unsigned delay = 1, int unsigned timeout =4000 );

    ovm_report_info(get_full_name(), $psprintf("poll_sch -- Start"), OVM_MEDIUM);
        cfg_cmds = {};
        if(is_ldb) begin
          cfg_cmds.push_back($psprintf("poll_sch ldb:%0d %0d %d %d", cq_num, exp_cnt, timeout, delay ));
        end else begin 
          cfg_cmds.push_back($psprintf("poll_sch dir:%0d %0d %d %d", cq_num, exp_cnt, timeout, delay ));
        end   
        execute_cfg_cmds();
    ovm_report_info(get_full_name(), $psprintf("poll_sch -- End"),   OVM_MEDIUM);
endtask : poll_sch


task hqm_base_seq::execute_cfg_cmds();

    while (cfg_cmds.size()) begin

        bit    do_cfg_seq;
        string cmd;

        hqm_cfg_seq cfg_seq;

        cmd = cfg_cmds.pop_front();
        ovm_report_info(get_full_name(), $psprintf("Processing command -> %0s", cmd), OVM_MEDIUM);
        i_hqm_cfg.set_cfg(cmd, do_cfg_seq);
        if (do_cfg_seq) begin
            `ovm_create(cfg_seq)
            cfg_seq.pre_body();
            start_item(cfg_seq);
            finish_item(cfg_seq);
            cfg_seq.post_body();
        end
    end

endtask : execute_cfg_cmds

function void hqm_base_seq::send_cmd_pf(bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0, bit [0:3] cmd, bit [2:0] qpri = 3'b0);

    ovm_report_info(get_full_name(), $psprintf("send_cmd_pf(is_ldb=%0d pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b, command=%0b) -- Start", is_ldb, pp_num, qid, rpt, ingress_drop, cmd), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        if(ingress_drop) begin :ingress_drop_check_pf
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=%0d qtype=uno qid=%0d ingress_drop=1", pp_num, cmd[0],cmd[1],cmd[2],cmd[3], qpri, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d ingress_drop=1", pp_num,  cmd[0],cmd[1],cmd[2],cmd[3],qid));
            end
        end : ingress_drop_check_pf
        else begin //No_drop
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=%0d qtype=uno qid=%0d", pp_num, cmd[0],cmd[1],cmd[2],cmd[3], qpri, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d", pp_num,  cmd[0],cmd[1],cmd[2],cmd[3],qid));
            end
        end 
    end
    ovm_report_info(get_full_name(), $psprintf("send_cmd_pf(is_ldb=%0d pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b, command=%0b) -- End", is_ldb, pp_num, qid, rpt, ingress_drop,cmd), OVM_MEDIUM);

endfunction : send_cmd_pf



function void hqm_base_seq::send_cmd_pf_sciov(bit is_nm_pf, bit [7:0] pp_num, bit [7:0] qid, int unsigned rpt = 1, bit ingress_drop = 1'b0, bit is_ldb = 1'b0, bit [0:3] cmd, bit [2:0] qpri = 3'b0);

    ovm_report_info(get_full_name(), $psprintf("send_cmd_pf_sciov(is_nm_pf=%0d is_ldb=%0d pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b, command=%0b) -- Start", is_nm_pf, is_ldb, pp_num, qid, rpt, ingress_drop, cmd), OVM_MEDIUM);
    for (int i = 0; i < rpt; i++) begin
        if(ingress_drop) begin :ingress_drop_check_pf
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d is_nm_pf=%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=%0d qtype=uno qid=%0d ingress_drop=1", pp_num, is_nm_pf, cmd[0],cmd[1],cmd[2],cmd[3], qpri, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d is_nm_pf=%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d ingress_drop=1", pp_num, is_nm_pf,  cmd[0],cmd[1],cmd[2],cmd[3],qid));
            end
        end : ingress_drop_check_pf
        else begin //No_drop
            if(is_ldb) begin 
              cfg_cmds.push_back($psprintf("HCW LDB:%0d is_nm_pf=%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=%0d qtype=uno qid=%0d", pp_num, is_nm_pf, cmd[0],cmd[1],cmd[2],cmd[3], qpri, qid));
            end else begin
              cfg_cmds.push_back($psprintf("HCW DIR:%0d is_nm_pf=%0d qe_valid=%0b qe_orsp=%0b qe_uhl=%0b cq_pop=%0b meas=0 lockid=0x001 msgtype=0 qpri=0 qtype=dir qid=%0d", pp_num,  is_nm_pf, cmd[0],cmd[1],cmd[2],cmd[3],qid));
            end
        end 
    end
    ovm_report_info(get_full_name(), $psprintf("send_cmd_pf_sciov(is_nm_pf=%0d is_ldb=%0d pp_num=0x%0x, qid=0x%0x, rpt=%0d, ingress_drop=%0b, command=%0b) -- End", is_nm_pf, is_ldb, pp_num, qid, rpt, ingress_drop,cmd), OVM_MEDIUM);

endfunction : send_cmd_pf_sciov

task hqm_base_seq::pgcb_clk();

 virtual hqm_misc_if     pins;
         string          misc_if_str;
         realtime              time1;
         realtime              time2;
         realtime              pgcb_clk_period;
//         int                   pgcb_ref;
         int                   counter = 0 ;

     // -- get pins interface
         if (!p_sequencer.get_config_string({"hqm_misc_if_handle",inst_suffix}, misc_if_str)) begin
         ovm_report_fatal(get_full_name(), $psprintf("get_config_string failed for hqm_misc_if_handle"));
     end
     `sla_get_db(pins, virtual hqm_misc_if, misc_if_str)
     if (pins == null) begin
        ovm_report_fatal(get_full_name(), $psprintf("pins is null"));
     end
      ovm_report_info(get_full_name(), $psprintf("the pgcb_clk ref point is being calculated in cq_dead_wd_timer_seq"), OVM_LOW);

while(counter == 0) begin      
ovm_report_info(get_full_name(), $psprintf("the pgcb_clk while loop "), OVM_LOW);

 @(posedge pins.pgcb_clk) 
   time1=$realtime;
ovm_report_info(get_full_name(), $psprintf("the pgcb_clk while loop time1:%0t ",time1), OVM_LOW);

@(posedge pins.pgcb_clk)
    time2=$realtime;
ovm_report_info(get_full_name(), $psprintf("the pgcb_clk while loop time2:%0t ",time2), OVM_LOW);

pgcb_clk_period=(time2-time1);
ovm_report_info(get_full_name(), $psprintf("the pgcb_clk while loop pgcb_clk_period:%0t ",pgcb_clk_period), OVM_LOW);


while(pgcb_clk_period >= 99 )begin
ovm_report_info(get_full_name(), $psprintf("entering while loop pgcb_clk_period:%0t ",pgcb_clk_period), OVM_LOW);
pgcb_clk_period /= 10;
end
pgcb_ref=pgcb_clk_period;
ovm_report_info(get_full_name(), $psprintf("the pgcb_clk while loop pgcb_ref:%0d ",pgcb_ref), OVM_LOW);
counter++;
end

endtask :pgcb_clk


//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------
//---------------------------------------------------------------
task hqm_base_seq::setup_hqm_flr(int flr_set, int pending_status_cknum);
    sla_ral_reg                                         ral_reg;
    sla_status_t                                        status;
    sla_ral_data_t                                      rdata,wdata;
    int ck_cnt;
    ck_cnt=0;

      `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr - flr_set=%0d pending_status_cknum=%0d", flr_set, pending_status_cknum), OVM_NONE)

       while ( ck_cnt < pending_status_cknum) begin
          read_reg("PCIE_CAP_DEVICE_STATUS", rdata, "hqm_pf_cfg_i");
         `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_1 - read PCIE_CAP_DEVICE_STATUS rdata=0x%0x ck_cnt=%0d", rdata, ck_cnt), OVM_NONE)
          if(rdata==0) begin
              break;
          end else begin
              #100ns;
              ck_cnt++;
          end
       end

        // -- Disable MSI in order to avoid any unattended INT later// --
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_2 - write to MSIX_CAP_CONTROL with 0"), OVM_NONE)
        wdata=32'h0;
        write_reg("MSIX_CAP_CONTROL", wdata, "hqm_pf_cfg_i");
        read_reg("MSIX_CAP_CONTROL", rdata, "hqm_pf_cfg_i");
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_2.1 - read MSIX_CAP_CONTROL rdata=0x%0x", rdata), OVM_NONE)

        // -- Disable Bus Master, INTX and Mem Txn enable bit from device_command// -- {1'b_1,10'h_0}
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_3 - write to DEVICE_COMMAND.BM MEM  with 0"), OVM_NONE)
        wdata=32'h400;
        write_reg("DEVICE_COMMAND", wdata, "hqm_pf_cfg_i");
        read_reg("DEVICE_COMMAND", rdata, "hqm_pf_cfg_i");
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_3.1 - read DEVICE_COMMAND rdata=0x%0x", rdata), OVM_NONE)

      #500ns;

      // -flr
      if(flr_set==1) begin
         write_fields($psprintf("PCIE_CAP_DEVICE_CONTROL"), '{"STARTFLR"}, '{'b1}, "hqm_pf_cfg_i");
         `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_4 - FLR Issued : PCIE_CAP_DEVICE_CONTROL.STARTFLR=1"), OVM_NONE)
      end else begin
         write_fields($psprintf("PCIE_CAP_DEVICE_CONTROL"), '{"STARTFLR"}, '{'b0}, "hqm_pf_cfg_i");
         `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:setup_hqm_flr_4 - FLR Not Issued : PCIE_CAP_DEVICE_CONTROL.STARTFLR=0"), OVM_NONE)
      end 

endtask:setup_hqm_flr

//---------------------------------------------------------------
//---------------------------------------------------------------
task hqm_base_seq::hqm_pmcsr_ps_cfg(int pmcsr_ps, int wait_loop);
    sla_ral_reg                                         ral_reg;
    sla_status_t                                        status;
    sla_ral_data_t                                      rdata,wdata;
    int ck_cnt;
    ck_cnt=0;

      `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg - pmcsr_ps=%0d wait_loop=%0d", pmcsr_ps, wait_loop), OVM_NONE)

    //-- poll config_master.CFG_PM_STATUS.PGCB_HQM_IDLE = 1
        //poll_fields ("CFG_PM_STATUS", "PGCB_HQM_IDLE", 1'b1, "config_master");
        //read_reg("CFG_PM_STATUS", rdata, "config_master");
        read_field("CFG_PM_STATUS", "PGCB_HQM_IDLE", rdata, "config_master");
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg_0 - read config_master.CFG_PM_STATUS.PGCB_HQM_IDLE=0x%0x ", rdata), OVM_NONE)
       while(rdata==0) begin
           #300ns;
           read_field("CFG_PM_STATUS", "PGCB_HQM_IDLE", rdata, "config_master");
          `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg_0 - read config_master.CFG_PM_STATUS.PGCB_HQM_IDLE=0x%0x ", rdata), OVM_NONE)
       end
    
    //-- read hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS
        read_reg("PM_CAP_CONTROL_STATUS", rdata, "hqm_pf_cfg_i");
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg_1 - read hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS rdata=0x%0x", rdata), OVM_NONE)

    //-- write hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS
        wdata=rdata;
        wdata[1:0] = pmcsr_ps;
        write_reg("PM_CAP_CONTROL_STATUS", wdata, "hqm_pf_cfg_i");
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg_2 - write hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS wdata=0x%0x", wdata), OVM_NONE)

    //-- wait 
         //PCIE spec says the software should wait for 10ms. keeping it 8000ns to reduce simulation time; 
         for(int i=0; i< wait_loop; i++) begin
           #1us;
           read_reg("PM_CAP_CONTROL_STATUS", rdata, "hqm_pf_cfg_i");
          `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg_3 - wait loop %0d : read hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS rdata=0x%0x", i, rdata), OVM_MEDIUM)
         end    

    //-- read hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS
        read_reg("PM_CAP_CONTROL_STATUS", rdata, "hqm_pf_cfg_i");
       `ovm_info(get_full_name(), $sformatf("HQM_BASE_SEQ:hqm_pmcsr_ps_cfg_4 - read hqm_pf_cfg_i.PM_CAP_CONTROL_STATUS rdata=0x%0x", rdata), OVM_NONE)

endtask:hqm_pmcsr_ps_cfg


//---------------------------------------------------------------
//---------------------------------------------------------------
task hqm_base_seq::HqmAts_deletetlb();
    bit [15:0] hqmbdf_val;


      get_hqm_cfg();
      hqmbdf_val = i_hqm_cfg.ldb_pp_cq_cfg[0].cq_bdf;


     `ovm_info(get_full_name(),$psprintf("HQM_BASE_SEQ:HqmAts_deletetlb:: HqmAts_deletetlb hqmbdf_val=0x%0x", hqmbdf_val),OVM_MEDIUM)
      //--delete all address translation in HqmIommuTLB
      i_hqm_cfg.iommu.delete_all_address_translation(hqmbdf_val);

      //--delete
      i_hqm_cfg.iommu.tlb_delete_all(hqmbdf_val);

endtask:HqmAts_deletetlb


//---------------------------------------------------------------
//---------------------------------------------------------------
task hqm_base_seq::HqmAtsInvalidRequest_task(int is_ldb, int cq_num, bit global_inv);
    bit [15:0] hqmbdf_val;
    bit        pasid_ena;
    bit [19:0] pasid_val;
    bit [63:0] logic_addr;
    HqmAtsPkg::RangeSize_t  pagesize;
    bit        enable_dpe_err, enable_ep_err;
    bit [4:0]  itag;
    bit timeout_detector = 0;

      get_hqm_cfg();

      enable_dpe_err=0;
      enable_ep_err=0;
   
      if(is_ldb) begin
         hqmbdf_val = i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_bdf;
         pasid_ena  = i_hqm_cfg.ldb_pp_cq_cfg[cq_num].pasid[22];
         pasid_val  = i_hqm_cfg.ldb_pp_cq_cfg[cq_num].pasid[19:0];
         logic_addr = i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_gpa;
         pagesize   = HqmAtsPkg::RANGE_4K;
      end else begin
         hqmbdf_val = i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_bdf;
         pasid_ena  = i_hqm_cfg.dir_pp_cq_cfg[cq_num].pasid[22];
         pasid_val  = i_hqm_cfg.dir_pp_cq_cfg[cq_num].pasid[19:0];
         logic_addr = i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_gpa;
         pagesize   = HqmAtsPkg::RANGE_4K;
      end

     `ovm_info(get_full_name(),$psprintf("HQM_BASE_SEQ:HqmAtsInvalidRequest_task:: Invalidation Request be generated - isldb %0d PP %0d virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s itag=%0d, global_inv=%0d", is_ldb, cq_num, logic_addr, pasid_ena, pasid_val, pagesize.name(), itag, global_inv),OVM_MEDIUM)

      i_hqm_cfg.iommu_api.send_ireq( .ireq_itag       (itag ),   // task returns tag of INV REQ that is sent
                             .ireq_requester_id     (hqmbdf_val ),
                             .ireq_destination_id   (0 ),
                             .ireq_pasid_valid      (pasid_ena),
                             .ireq_pasid            (pasid_val),
                             .ireq_la_address       (logic_addr ),
                             .ireq_range            (pagesize), 
                             .ireq_global_invalidate(global_inv));
     `ovm_info(get_full_name(),$psprintf("HQM_BASE_SEQ:HqmAtsInvalidRequest_task:: Invalidation Request Sent  - isldb %0d PP %0d returned itag=0x%0x; virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", is_ldb, cq_num, itag, logic_addr, pasid_ena, pasid_val, pagesize.name()),OVM_MEDIUM)

      //---------------------------
      if($test$plusargs("HQMV30_ATS_INV_RESP_WAIT")) begin 
            fork
                i_hqm_cfg.iommu_api.wait_irsp( .itag ( itag ) );
                begin
                    #10us;
                    timeout_detector = 1;
                end
            join_any
            disable fork;
            if (timeout_detector) begin // timeout did trigger
                `ovm_error(get_full_name(),$psprintf("HQM_BASE_SEQ:HqmAtsInvalidRequest_task:: Invalidation message time out - isldb %0d PP %0d virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", is_ldb, cq_num, logic_addr, pasid_ena, pasid_val, pagesize.name()))
            end else begin
                `ovm_info(get_full_name(),$psprintf("HQM_BASE_SEQ:HqmAtsInvalidRequest_task:: Invalidation message successful - isldb %0d PP %0d virtual_addr=0x%0x pasid_ena=%0d pasid=0x%0x pagesize=%0s", is_ldb, cq_num, logic_addr, pasid_ena, pasid_val, pagesize.name()),OVM_MEDIUM)
            end
      end//if($test$plusargs("HQMV30_ATS_INV_RESP_WAIT"))  


      #100ns;

      if(is_ldb) begin 
         i_hqm_cfg.ldb_pp_cq_cfg[cq_num].cq_ats_inv_ctrl = 4;  
      end else begin
         i_hqm_cfg.dir_pp_cq_cfg[cq_num].cq_ats_inv_ctrl = 4;  
      end 
     `ovm_info(get_full_name(),$psprintf("HQM_BASE_SEQ:HqmAtsInvalidRequest_task:: Invalidation Request Sent  - isldb %0d PP %0d - set cq_ats_inv_ctrl=4; itag=0x%0x logic_addr=0x%0x pasid_ena=%0d pasid_val=0x%0x pagesize=%0s", is_ldb, cq_num, itag, logic_addr, pasid_ena, pasid_val, pagesize.name()),OVM_MEDIUM)
endtask: HqmAtsInvalidRequest_task


`endif //HQM_BASE_SEQ__SV


