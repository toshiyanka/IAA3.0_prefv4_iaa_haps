//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
//------------------------------------------------------------------------------
// File   : hqm_pcie_tb_cfg.sv
// Author : Amol Patil 
//
// Description :
//
// This file is part of PCIe config generator.
//------------------------------------------------------------------------------
`ifndef HQM_PCIE_TB_CFG
`define HQM_PCIE_TB_CFG

import hqm_rndcfg_pkg::*;



class hqm_pcie_tb_cfg extends hqm_tb_cfg;
  `ovm_component_utils(hqm_pcie_tb_cfg)

	int				flr_Q[$];
	bit				shuffle_pkts;
 	int				func_no_lut[string];
	int				warm_reset_delay=70;
	int				tot_hcw_num;
	hcw_transaction hcw_trans_Q[$];
	hcw_transaction	loc_hcw_trans;
    hqm_sys_rndcfg  i_hqm_rndcfg;
    virtual pvc_vintf  port;
//    sla_sequencer sla_seqr;
  //------------------------- 
  // Function: new 
  // Class constructor
  //------------------------- 
  function new (string name = "hqm_pcie_tb_cfg", ovm_component parent = null);
    super.new(name, parent);
//	func_no_lut["pf00"]=0;
	func_no_lut["vf0"]=1; func_no_lut["vf4"]=5; func_no_lut["vf8"]=9 ;  func_no_lut["vf12"]=13;
	func_no_lut["vf1"]=2; func_no_lut["vf5"]=6; func_no_lut["vf9"]=10;  func_no_lut["vf13"]=14;
	func_no_lut["vf2"]=3; func_no_lut["vf6"]=7; func_no_lut["vf10"]=11; func_no_lut["vf14"]=15;
	func_no_lut["vf3"]=4; func_no_lut["vf7"]=8; func_no_lut["vf11"]=12; func_no_lut["vf15"]=16;
	tot_hcw_num=0;
  endfunction : new

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void build();
    super.build();
    i_hqm_rndcfg = hqm_sys_rndcfg::type_id::create("HQM_RNDCFG", this);
    i_hqm_rndcfg.set_cfg(this.get());
    if(i_hqm_rndcfg.is_enabled()) 
        i_hqm_rndcfg.setup_rnd_cfg();
  endfunction
  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void connect();
    ovm_object o_tmp;
    super.connect();
  endfunction

 function connect_port(virtual pvc_vintf pvc_port);
    port = pvc_port;
 endfunction: connect_port;

 extern   virtual protected function hqm_command_handler_status_t       sysrst_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       rndcfg_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       chngcfg_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       runtest_command_handler(hqm_cfg_command command);
 extern   virtual function void      set_cfg_end(hqm_cfg_command command);
     
 extern   virtual function hcw_transaction get_typical_hcw();
 extern   virtual function hcw_transaction update_pf_configuration();
 extern   virtual function hcw_transaction update_vas_configuration();
 extern   virtual function hcw_transaction update_vf_configuration(int vf_num);
 extern   virtual protected function void	shuffle_pkts_and_send();
 extern   virtual function  int      ready_to_send();
 extern   virtual function  int      rmw_hcw_cnt(int num=1);
endclass : hqm_pcie_tb_cfg

//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_pcie_tb_cfg::sysrst_command_handler(hqm_cfg_command command);
    sysrst_command_handler = HQM_CFG_CMD_NOT_DONE;
    if (command.options.size() > 0) begin        
        `ovm_info("HQM_PCIE_TB_CFG",$psprintf("Processing sysrst command <%s> <%0d> cycle", command.options[0].option, command.options[0].values[0]),OVM_MEDIUM);
        case (command.options[0].option.tolower())
            "warm"  :   begin
							if(|command.options[0].values.size())  warm_reset_delay=command.options[0].values[0];
							add_register_to_access_list("warm_rst", "warm_rst", "warm_rst", HQM_WARM_RST, 0, 0, 0, .sai(cur_sai));  
                            sysrst_command_handler = HQM_CFG_CMD_DONE;
                        end

            "flr"   :   begin
							flr_Q.push_back(func_no_lut[command.options[0].str_value]);
							if(shuffle_pkts)
							  `ovm_info("HQM_PCIE_TB_CFG",$psprintf("Skipping HQM_SYSRST_FLR. Shuffle and send -> shuffle_pkts(%0d).",shuffle_pkts),OVM_LOW)
							else
							  add_register_to_access_list("flr", "flr", "flr", HQM_SYSRST_FLR, 0, 0, 0, .sai(cur_sai));  
                            sysrst_command_handler = HQM_CFG_CMD_DONE;
                        end
            default : 
                        ovm_report_error("HQM_PCIE_TB_CFG", $psprintf("Undefined sysrst option %s", command.options[0].option));
        endcase

    end  else begin
        `ovm_error("HQM_PCIE_TB_CFG",$psprintf("Invalid sysrst command"))
    end

endfunction

//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_pcie_tb_cfg::rndcfg_command_handler(hqm_cfg_command command);
    string opt;
    rndcfg_command_handler = HQM_CFG_CMD_NOT_DONE;
    if (command.options.size() >= 1) begin
        foreach(command.options[i]) begin
            opt = command.options[i].option;
            if(hqm_rndcfg.exists(opt)) begin
                `ovm_info("HQM_PCIE_TB_CFG",$psprintf("Processing rndcfg command <%s> <%0d> cycle", opt, command.options[i].values[0]),OVM_MEDIUM);
                i_hqm_rndcfg.process_sys_rndcfg_cmd(command.options[i]);
            end else begin
                `ovm_error("HQM_PCIE_TB_CFG",$psprintf("Invalid rndcfg command option <%s>",opt));
            end
        end
        rndcfg_command_handler = HQM_CFG_CMD_DONE;
    end  else begin
        `ovm_error("HQM_PCIE_TB_CFG",$psprintf("Invalid rndcfg command"));
    end

endfunction

//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_pcie_tb_cfg::chngcfg_command_handler(hqm_cfg_command command);
    chngcfg_command_handler = HQM_CFG_CMD_NOT_DONE;

endfunction

//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_pcie_tb_cfg::runtest_command_handler(hqm_cfg_command command);
	string rcpath, cur_pool_ = "";
    int i;
	hcw_transaction  hcw_trans_;
    runtest_command_handler = HQM_CFG_CMD_NOT_DONE;
    if (command.options.size() >= 1) begin
    	foreach(command.options[i])
            `ovm_info("HQM_PCIE_TB_CFG",$psprintf("Processing runtest command on <%s> ", command.options[i].option), OVM_MEDIUM);
			case (command.options[i].option.tolower())
  				"pool"	:   cur_pool_= command.options[i].str_value;
                "go"    :   add_register_to_access_list("go", "go", "go", HQM_RUNTST_GO, 0, 0, 0, .sai(cur_sai));
 				"sys_init": if(command.options[i].str_value=="sys") 
							    add_register_to_access_list("sys_init", "sys_init", "sys_init", HQM_SYS_INIT, 0, 0, 0, .sai(cur_sai));
							else if(command.options[i].str_value=="pf0")	
						        add_register_to_access_list("pf_init", "pf_init", "pf_init", HQM_PF_INIT, 0, 0, 0, .sai(cur_sai));
							else if(func_no_lut.exists(command.options[i].str_value))
							    add_register_to_access_list("vf_init", "vf_init", "vf_init", HQM_VF_INIT, .exp_rd_val(func_no_lut[command.options[i].str_value]), .sai(cur_sai));
							  else
								  `ovm_error(get_name(),"Illegal sys_init command !!")

  				"gen_count"	: for(int kk=0;kk<command.options[i].values[0];kk++)  begin
								 hcw_trans_		  = hcw_transaction::type_id::create("hcw_trans_");
								 hcw_trans_.randomize();
								 hcw_trans_.do_copy(get_typical_hcw());
  								 hcw_trans_.ppid  = resolve_name(cur_pool_,-1,128);
								 hcw_trans_.qid = hcw_trans_.ppid;
  								 hcw_trans_.iptr  = 'h_0;
  								 hcw_trans_Q.push_back(hcw_trans_); 
								 if(shuffle_pkts)
									`ovm_info("HQM_PCIE_TB_CFG",$psprintf("Skipping HCW_PKT_ENQ. Shuffle and send -> shuffle_pkts(%0d).",shuffle_pkts),OVM_LOW)
								 else
									add_register_to_access_list("pkt_enq", "pkt_enq", "pkt_enq", HQM_PKT_ENQ, 0, 0, 0, .sai(cur_sai));  
								`ovm_info(get_name(),$psprintf("Added HCW transaction to Q for pool=%s",cur_pool_),OVM_LOW);
								hcw_trans_.print();
  							  end
  				"shuffle_pkts"	: if(command.options[i].values[0]) shuffle_pkts = command.options[i].values[0];
								  else							   shuffle_pkts_and_send();
            default: begin
						  `ovm_error("HQM_PCIE_TB_CFG",$psprintf("Invalid runtest option <%s>",command.options[0].option));
            end
        endcase
         runtest_command_handler = HQM_CFG_CMD_DONE;
    end  else begin
        `ovm_error("HQM_PCIE_TB_CFG",$psprintf("Invalid runtest command"));
    end

endfunction

function int hqm_pcie_tb_cfg::rmw_hcw_cnt(int num=1);
    int cnt = tot_hcw_num;
    tot_hcw_num += num;
    return cnt;
endfunction: rmw_hcw_cnt;

function void hqm_pcie_tb_cfg::set_cfg_end(hqm_cfg_command command);
    if ((command != null) && (command.get_type() == HQM_CFG_END))
        i_hqm_rndcfg.randomize_sys_data();
    super.set_cfg_end();
endfunction: set_cfg_end;

function hcw_transaction hqm_pcie_tb_cfg::get_typical_hcw();
	hcw_transaction tmp_hcw;
  tmp_hcw= hcw_transaction::type_id::create("tmp_hcw");
  tmp_hcw.randomize();

  tmp_hcw.rsvd0               = '0;
  tmp_hcw.dsi_error           = '0;
  tmp_hcw.cq_int_rearm        = '0;
  tmp_hcw.no_inflcnt_dec      = '0;
  tmp_hcw.dbg                 = '0;
  tmp_hcw.cmp_id              = '0;
  tmp_hcw.is_vf               = '0;
  tmp_hcw.vf_num              = '0;
  tmp_hcw.sai                 = cur_sai;
  tmp_hcw.rtn_credit_only     = '0;
  tmp_hcw.ingress_drop        = '0;
  tmp_hcw.ordqid              = '0;
  tmp_hcw.ordpri              = '0;
  tmp_hcw.ordlockid           = '0;
  tmp_hcw.ordidx              = '0;
  tmp_hcw.reord               = '0;
  tmp_hcw.frg_cnt             = '0;
  tmp_hcw.frg_last            = '0;

  tmp_hcw.is_ldb = 0;
  tmp_hcw.ppid = 0;
   
  tmp_hcw.hcw_batch             = 0;
  tmp_hcw.ingress_drop          = 0;
  tmp_hcw.rtn_credit_only       = 0;
  tmp_hcw.cq_int_rearm = 0;
  tmp_hcw.qe_valid = 1;
  tmp_hcw.qe_orsp = 0;
  tmp_hcw.qe_uhl = 0;
  tmp_hcw.cq_pop = 0;
  tmp_hcw.qe_orsp   = 0;
  tmp_hcw.qe_uhl    = 0;
  tmp_hcw.cq_pop    = 0;
  tmp_hcw.cmp_id    = 0;
  tmp_hcw.dbg = 0;
  tmp_hcw.meas = 0;
  tmp_hcw.lockid = 'h_303;
  tmp_hcw.msgtype = 0;
  tmp_hcw.qpri = 0;
  tmp_hcw.qtype = QDIR;
  tmp_hcw.qid = 0;
  tmp_hcw.ordqid    = tmp_hcw.qid;
  tmp_hcw.idsi = 'h_302;
  tmp_hcw.print();
  return tmp_hcw;
endfunction

function void hqm_pcie_tb_cfg::shuffle_pkts_and_send();

  int flr_trans_sent=0, hcw_trans_sent=0;
  shuffle_pkts=0; 
  if(|flr_Q.size())			flr_Q.shuffle() ;
  if(|hcw_trans_Q.size())	hcw_trans_Q.shuffle();

  while((hcw_trans_Q.size()>(hcw_trans_sent)) && (flr_Q.size()>(flr_trans_sent)))
	if($urandom_range(1,2)%2) begin
      add_register_to_access_list("pkt_enq", "pkt_enq", "pkt_enq", HQM_PKT_ENQ, 0, 0, 0, .sai(cur_sai));
	  hcw_trans_sent++;
	end else begin
	  add_register_to_access_list("flr", "flr", "flr", HQM_SYSRST_FLR, 0, 0, 0, .sai(cur_sai));  
	  flr_trans_sent++;
	end

  //One of the Qs is now empty; So push all the pkts
  if(hcw_trans_Q.size()>hcw_trans_sent)
	for(int k=0;k<(hcw_trans_Q.size()-hcw_trans_sent);k++)
	  add_register_to_access_list("pkt_enq", "pkt_enq", "pkt_enq", HQM_PKT_ENQ, 0, 0, 0, .sai(cur_sai));

  if(flr_Q.size()>flr_trans_sent) 
	for(int k=0;k<(flr_Q.size()-flr_trans_sent);k++)
	  add_register_to_access_list("flr", "flr", "flr", HQM_SYSRST_FLR, 0, 0, 0, .sai(cur_sai));  

endfunction

 function int hqm_pcie_tb_cfg::ready_to_send();
    if((this.register_access_list.size == 0) && (hcw_trans_Q.size < 4))
        return 1;
    else
        return 0;
 endfunction:ready_to_send;

function hcw_transaction hqm_pcie_tb_cfg::update_vas_configuration();

    foreach(vas_cfg[vas])	if(vas_cfg[vas].provisioned)
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vas_gen", vas, "gen", this.vas_cfg[vas].vas_gen);

    foreach(dir_pp_cq_cfg[pp])	if(dir_pp_cq_cfg[pp].pp_provisioned)  begin
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_pp2dirpool", pp, "dirpool", this.dir_pp_cq_cfg[pp].dir_pool);
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_pp2ldbpool", pp, "ldbpool", this.dir_pp_cq_cfg[pp].ldb_pool);
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_pp2vas", pp, "vas", this.dir_pp_cq_cfg[pp].vas);
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_dir_pp2pool", pp, "pool", this.dir_pp_cq_cfg[pp].dir_pool); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_ldb_pp2pool", pp, "pool", this.dir_pp_cq_cfg[pp].ldb_pool); 
    end

    foreach(ldb_pp_cq_cfg[pp]) if(ldb_pp_cq_cfg[pp].pp_provisioned) begin  
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_pp2vas", pp, "vas", this.ldb_pp_cq_cfg[pp].vas);
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ldb_dir_pp2pool", pp, "pool", this.ldb_pp_cq_cfg[pp].dir_pool); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ldb_ldb_pp2pool", pp, "pool", this.ldb_pp_cq_cfg[pp].ldb_pool); 
    end

    foreach(ldb_pool_cfg[pool]) if(ldb_pool_cfg[pool].provisioned)  begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pool_enabled", pool, "pool_enabled", this.ldb_pool_cfg[pool].enable); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ldb_pool_credit_count", pool, "count", this.ldb_pool_cfg[pool].ldb_credit_cnt); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ldb_pool_credit_limit", pool, "limit", this.ldb_pool_cfg[pool].ldb_credit_limit); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_qed_freelist_limit", pool, "limit", this.ldb_pool_cfg[pool].qed_freelist_limit); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_qed_freelist_base", pool, "base", this.ldb_pool_cfg[pool].qed_freelist_base); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_qed_freelist_push_ptr", pool, "push_ptr", this.ldb_pool_cfg[pool].qed_freelist_base); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_qed_freelist_push_ptr", pool, "generation", this.ldb_pool_cfg[pool].enable); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_qed_freelist_pop_ptr", pool, "pop_ptr", this.ldb_pool_cfg[pool].qed_freelist_base); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_qed_freelist_pop_ptr", pool, "generation", 0);
    end

  foreach(dir_pool_cfg[pool]) if(dir_pool_cfg[pool].provisioned) begin
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pool_enabled", pool, "pool_enabled", this.dir_pool_cfg[pool].enable); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pool_credit_count", pool, "count", this.dir_pool_cfg[pool].dir_credit_cnt); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pool_credit_limit", pool, "limit", this.dir_pool_cfg[pool].dir_credit_limit); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dqed_freelist_limit", pool, "limit", this.dir_pool_cfg[pool].dqed_freelist_limit); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dqed_freelist_base", pool, "base", this.dir_pool_cfg[pool].dqed_freelist_base); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dqed_freelist_push_ptr", pool, "push_ptr", this.dir_pool_cfg[pool].dqed_freelist_base); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dqed_freelist_push_ptr", pool, "generation", this.dir_pool_cfg[pool].enable); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dqed_freelist_pop_ptr", pool, "pop_ptr", this.dir_pool_cfg[pool].dqed_freelist_base); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dqed_freelist_pop_ptr", pool, "generation", 0);
  end

  foreach(vas_cfg[vas])	if(vas_cfg[vas].provisioned)
      for (int qid = 0 ; qid < 128 ; qid++) begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_vasqid_v", (vas * 128) + qid, "vasqid_v", this.vas_cfg[vas].ldb_qid_v[qid]);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_vasqid_v", (vas * 128) + qid, "vasqid_v", this.vas_cfg[vas].dir_qid_v[qid]);
	  end
 
  foreach(ldb_pp_cq_cfg[cq])  if(ldb_pp_cq_cfg[cq].cq_provisioned)
	for (int qidix = 0 ; qidix < 8 ; qidix++) begin
        string field_name;
        string reg_name;
        if (ldb_pp_cq_cfg[cq].qidix[qidix].qidv) begin
          field_name = $psprintf("qid_p%0d",qidix[1:0]);
          if (qidix < 4)  reg_name = "cfg_cq2qid[0]";
          else			  reg_name = "cfg_cq2qid[1]";
          set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe", reg_name, cq, field_name, ldb_pp_cq_cfg[cq].qidix[qidix].qid);
        end
    end

  foreach(ldb_pp_cq_cfg[cq])  if(ldb_pp_cq_cfg[cq].cq_provisioned)	begin
      if (ldb_pp_cq_cfg[cq].cq_ldb_inflight_limit_set) begin
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", ldb_pp_cq_cfg[cq].cq_ldb_inflight_limit); 
      end else begin
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", (ldb_pp_cq_cfg[cq].hist_list_limit - ldb_pp_cq_cfg[cq].hist_list_base) + 1); 
      end
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_hist_list_base", cq, "base", ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_hist_list_limit", cq, "limit", ldb_pp_cq_cfg[cq].hist_list_limit);
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_cq_token_depth_select", cq, "token_depth_select", ldb_pp_cq_cfg[cq].cq_depth);
      set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe", "cfg_cq_ldb_token_depth_select", cq, "token_depth_select", ldb_pp_cq_cfg[cq].cq_depth);    
  end

    foreach(dir_pp_cq_cfg[cq])  if(dir_pp_cq_cfg[cq].cq_provisioned)	begin
        set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_dir_cq_token_depth_select", cq, "token_depth_select", dir_pp_cq_cfg[cq].cq_depth);
        set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe", "cfg_cq_dir_token_depth_select_dsi", cq, "token_depth_select", dir_pp_cq_cfg[cq].cq_depth);
        set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_dir_cq_int_depth_thrsh", cq, "depth_threshold", dir_pp_cq_cfg[cq].cq_depth_intr_thresh);
    end

    foreach(ldb_qid_cfg[qid])  if(ldb_qid_cfg[qid].provisioned) begin
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "mode", this.ldb_qid_cfg[qid].ord_mode); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "slot", this.ldb_qid_cfg[qid].ord_slot); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "grp",  this.ldb_qid_cfg[qid].ord_grp); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn", qid, "sn", this.ldb_qid_cfg[qid].ord_sn); 
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe", "cfg_qid_ldb_inflight_limit", qid, "limit", ldb_qid_cfg[qid].qid_ldb_inflight_limit); 
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe", "cfg_qid_aqed_active_limit", qid, "limit", 1 + ldb_qid_cfg[qid].aqed_freelist_limit - ldb_qid_cfg[qid].aqed_freelist_base); 
    end

    foreach(ldb_pp_cq_cfg[pp]) begin
        if(ldb_pp_cq_cfg[pp].pp_provisioned) begin  
            set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_pp_dir_min_credit_quanta", pp, "quanta", this.ldb_pp_cq_cfg[pp].dir_min_credit_quanta); 
            set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_pp_ldb_min_credit_quanta", pp, "quanta", this.ldb_pp_cq_cfg[pp].ldb_min_credit_quanta);
            set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp_addr_l", pp, "addr_l", this.ldb_pp_cq_cfg[pp].pp_gpa[31:7]); 
            set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp_addr_u", pp, "addr_u", this.ldb_pp_cq_cfg[pp].pp_gpa[63:32]); 
        end
        if(ldb_pp_cq_cfg[pp].cq_provisioned) begin
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_cq_addr_l", pp, "addr_l", this.ldb_pp_cq_cfg[pp].cq_gpa[31:6]); 
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_cq_addr_u", pp, "addr_u", this.ldb_pp_cq_cfg[pp].cq_gpa[63:32]); 
        end
    end

    foreach(dir_pp_cq_cfg[pp]) begin
        if(dir_pp_cq_cfg[pp].pp_provisioned) begin  
            set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pp_addr_l", pp, "addr_l", this.dir_pp_cq_cfg[pp].pp_gpa[31:7]); 
            set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pp_addr_u", pp, "addr_u", this.dir_pp_cq_cfg[pp].pp_gpa[63:32]); 
        end
        if(dir_pp_cq_cfg[pp].cq_provisioned) begin
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_cq_addr_l", pp, "addr_l", this.dir_pp_cq_cfg[pp].cq_gpa[31:6]); 
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_cq_addr_u", pp, "addr_u", this.dir_pp_cq_cfg[pp].cq_gpa[63:32]); 
        end
    end

//    foreach(dir_pp_cq_cfg[pp])	if(dir_pp_cq_cfg[pp].pp_provisioned || dir_pp_cq_cfg[pp].cq_provisioned)  begin
    foreach(dir_pp_cq_cfg[pp])	if(dir_pp_cq_cfg[pp].pp_provisioned)  begin
        set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_dir_pp_dir_min_credit_quanta", pp, "quanta", this.dir_pp_cq_cfg[pp].dir_min_credit_quanta); 
        set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_dir_pp_ldb_min_credit_quanta", pp, "quanta", this.dir_pp_cq_cfg[pp].ldb_min_credit_quanta); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pp_dir_credit_count", pp, "count", this.dir_pp_cq_cfg[pp].dir_credit_count); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pp_dir_credit_hwm", pp, "hwm", this.dir_pp_cq_cfg[pp].dir_credit_hwm); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pp_dir_credit_lwm", pp, "lwm", this.dir_pp_cq_cfg[pp].dir_credit_lwm); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pp_ldb_credit_count", pp, "count", this.dir_pp_cq_cfg[pp].ldb_credit_count); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pp_ldb_credit_hwm", pp, "hwm", this.dir_pp_cq_cfg[pp].ldb_credit_hwm); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_dir_pp_ldb_credit_lwm", pp, "lwm", this.dir_pp_cq_cfg[pp].ldb_credit_lwm); 
    end
    // Enable all PP 
    foreach(ldb_pp_cq_cfg[pp]) begin
        if(ldb_pp_cq_cfg[pp].pp_provisioned)
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_pp_v", pp, "pp_v", this.ldb_pp_cq_cfg[pp].pp_enable);
        if(ldb_pp_cq_cfg[pp].cq_provisioned)
            set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe", "cfg_cq_ldb_disable", pp, "disabled", ~ldb_pp_cq_cfg[pp].cq_enable);
    end

    foreach(dir_pp_cq_cfg[pp])begin
        if(dir_pp_cq_cfg[pp].pp_provisioned)
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_pp_v", pp, "pp_v", this.dir_pp_cq_cfg[pp].pp_enable);
        if(dir_pp_cq_cfg[pp].cq_provisioned)
            set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe", "cfg_cq_dir_disable", pp, "disabled", ~dir_pp_cq_cfg[pp].cq_enable);
        if ((dir_pp_cq_cfg[pp].pp_provisioned || dir_pp_cq_cfg[pp].cq_provisioned) && dir_pp_cq_cfg[pp].is_pf) begin
            set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pp2vf_pf", pp, "is_pf", this.dir_pp_cq_cfg[pp].is_pf);
            set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_cq2vf_pf", pp, "is_pf", this.dir_pp_cq_cfg[pp].is_pf);
        end
    end
    // enable qid
    
    foreach(ldb_qid_cfg[qid])  if(ldb_qid_cfg[qid].provisioned) begin
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_qid_v", qid, "qid_v", this.ldb_qid_cfg[qid].enable);
    end
    
    foreach(dir_qid_cfg[qid])  if(dir_qid_cfg[qid].provisioned) begin
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_qid_v", qid, "qid_v", this.dir_qid_cfg[qid].enable);
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_qid2dvas", qid, "dvas", this.dir_qid_cfg[qid].dvas);
    end

endfunction

function hcw_transaction hqm_pcie_tb_cfg::update_pf_configuration();
	update_vas_configuration();
endfunction

function hcw_transaction hqm_pcie_tb_cfg::update_vf_configuration(int vf_num);
    int vf;
    int vpp;
    int pp;
    int vqid;
    int qid;
    int idx;
	
 for(vf=0;( (vf<vf_num) && (vf_cfg[vf].provisioned) );vf++)  begin

    for (vpp = 0 ; vpp < 64 ; vpp++) begin
      pp = vf_cfg[vf].ldb_vpp_cfg[vpp].pp;

      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_ldb_vpp_v", (vf * 64) + vpp, "vpp_v", this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v);
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_ldb_vpp2pp", (vf * 64) + vpp, "pp", pp);
      if (this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v) begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp2vpp", pp, "vpp", vpp);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp2vf_pf", pp, "is_pf", this.ldb_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp2vf_pf", pp, "vf", this.ldb_pp_cq_cfg[pp].vf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_cq2vf_pf", pp, "is_pf", this.ldb_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_cq2vf_pf", pp, "vf", this.ldb_pp_cq_cfg[pp].vf);
      end
    end

    for (vpp = 0 ; vpp < 128 ; vpp++) begin
      pp = vf_cfg[vf].dir_vpp_cfg[vpp].pp;

      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_dir_vpp_v", (vf * 128) + vpp, "vpp_v", this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v);
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_dir_vpp2pp", (vf * 128) + vpp, "pp", pp);
      if (this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v) begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pp2vpp",   pp, "vpp", vpp);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pp2vf_pf", pp, "vf", this.dir_pp_cq_cfg[pp].vf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_cq2vf_pf", pp, "vf", this.dir_pp_cq_cfg[pp].vf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_pp2vf_pf", pp, "is_pf", this.dir_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_cq2vf_pf", pp, "is_pf", this.dir_pp_cq_cfg[pp].is_pf);
      end
    end

    for (vqid = 0 ; vqid < 128 ; vqid++) begin
      qid = vf_cfg[vf].ldb_vqid_cfg[vqid].qid;

      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_ldb_vqid_v", (vf * 128) + vqid, "vqid_v", this.vf_cfg[vf].ldb_vqid_cfg[vqid].vqid_v);
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_ldb_vqid2qid", (vf * 128) + vqid, "qid", qid);
      if (this.vf_cfg[vf].ldb_vqid_cfg[vqid].vqid_v) begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_qid2vqid", qid, "vqid", vqid);
      end
    end

    for (vqid = 0 ; vqid < 128 ; vqid++) begin
      qid = vf_cfg[vf].dir_vqid_cfg[vqid].qid;

      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_dir_vqid_v", (vf * 128) + vqid, "vqid_v", this.vf_cfg[vf].dir_vqid_cfg[vqid].vqid_v);
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_dir_vqid2qid", (vf * 128) + vqid, "qid", qid);
    end

 end //for(vf<vf_num)

endfunction

`endif
