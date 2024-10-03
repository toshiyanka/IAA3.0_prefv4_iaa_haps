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
// File   : hqm_cfg.sv
// Author : Mike Betker
//
// Description :
//
// This class is derived form uvm_object and it represents the high level configuration of HQM.
//------------------------------------------------------------------------------
`ifndef HQM_TB_CFG__SV
`define HQM_TB_CFG__SV

import hqm_cfg_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
//class hqm_tb_cfg extends uvm_report_object;
class hqm_tb_cfg extends hqm_cfg;
  `uvm_component_utils(hqm_tb_cfg)

  int				    flr_Q[$];
  bit				    shuffle_pkts;
  int				    func_no_lut[string];
  int				    warm_reset_delay=70;
  hcw_transaction       hcw_trans_Q[$];
  hcw_transaction	    loc_hcw_trans;
  int				    GlblSeqNum;
  int				    DirPrioSeqNum[127:0][7:0];
  int				    LdbPrioSeqNum[63 :0][7:0];
  longint               CycleCnt;
  int                   HcwTxDly;
  int                   MaxHcwTxDly;
  int                   MinHcwTxDly;

  //------------------------- 
  // Function: new 
  // Class constructor
  //------------------------- 
  function new (string name = "hqm_tb_cfg", uvm_component parent = null);
    super.new(name, parent);
	func_no_lut["vf0"]=1; func_no_lut["vf4"]=5; func_no_lut["vf8"]=9 ;  func_no_lut["vf12"]=13;
	func_no_lut["vf1"]=2; func_no_lut["vf5"]=6; func_no_lut["vf9"]=10;  func_no_lut["vf13"]=14;
	func_no_lut["vf2"]=3; func_no_lut["vf6"]=7; func_no_lut["vf10"]=11; func_no_lut["vf14"]=15;
	func_no_lut["vf3"]=4; func_no_lut["vf7"]=8; func_no_lut["vf11"]=12; func_no_lut["vf15"]=16;
	GlblSeqNum = 0;
    CycleCnt   = 0;
    for(int i =0; i < 128; i++)
        for(int j =0; j < 8; j++)
            DirPrioSeqNum[i][j] = 0;

    for(int i =0; i < 64; i++)
        for(int j =0; j < 8; j++)
            LdbPrioSeqNum[i][j] = 0;
    HcwTxDly = 0;
    MaxHcwTxDly = 200;
    MinHcwTxDly = 100;
    $value$plusargs("MaxHcwTxDly=%0d", MaxHcwTxDly);
    $value$plusargs("MinHcwTxDly=%0d", MinHcwTxDly);
  endfunction : new

  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual task run_phase (uvm_phase phase);
    fork begin
    //while(pins != null)
        CycleCnt = @ (slu_tb_env::sys_clk_r) (CycleCnt + 1);
    end join_none;

    super.run_phase(phase);

  endtask:run_phase ;
  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  //--------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------
virtual function void connect_phase(uvm_phase phase); 
    uvm_object o_tmp;

    super.connect_phase(phase);

    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
   // if (!uvm_config_object::get(this, "","i_hcw_scoreboard", o_tmp)) begin
   //              uvm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
   // end 

   // if (!$cast(i_hcw_scoreboard, o_tmp)) begin
   //   uvm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", o_tmp.sprint(), i_hcw_scoreboard.sprint()));
   // end else begin
   //   uvm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), UVM_DEBUG);
   // end 

  endfunction

 extern   virtual protected function hqm_command_handler_status_t       command_decode(string commands,bit ignore_unknown = 1'b0);

 extern   virtual protected function hqm_command_handler_status_t       sysrst_command_handler(hqm_cfg_command command);
 extern   virtual protected function hqm_command_handler_status_t       runtest_command_handler(hqm_cfg_command command);
 extern   virtual function void      set_cfg_end(hqm_cfg_command command);

 extern   virtual function hcw_transaction get_typical_hcw();
 extern   virtual function hcw_transaction update_pf_configuration();
 extern   virtual function hcw_transaction update_vas_configuration();
 extern   virtual function hcw_transaction update_vf_configuration(int vf_num);
 extern   virtual protected function void  shuffle_pkts_and_send();
 extern   virtual function  int            ready_to_send();
 extern   virtual function  int            GetGlblSeqNum(int num=1);
 extern   virtual function  int            GetPrioSeqNum(int is_ldb = 0, int ppid = 0, int prio = 0, int num=1);
 extern   virtual function  longint        GetCycleCnt();
endclass : hqm_tb_cfg

//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_tb_cfg::command_decode(string commands,bit ignore_unknown = 1'b0);
   hqm_cfg_command command;
   int status;

   command_decode = super.command_decode(commands,1'b1);     // check for 0 length, comment, valid commands

   if (command_decode != HQM_CFG_CMD_NOT_DONE) begin
     return(command_decode);
   end 
  
   commands = commands.tolower();
   lvm_common_pkg::ltrim_string(commands);
   lvm_common_pkg::rtrim_string(commands);

   status = command_parser.get_command(commands, command);
   if(status) begin
     if (status < 50) begin
       if (!ignore_unknown) begin
         uvm_report_error("CFG", $psprintf("No handler when processing command -> %s", commands));     
       end 
     end   
     else begin
       uvm_report_info("CFG", $psprintf("Skipping command -> %s", commands), UVM_LOW);     
       command_decode = HQM_CFG_CMD_DONE_NO_CFG_SEQ;
     end 
   end 

   if (!ignore_unknown && (command_decode == HQM_CFG_CMD_NOT_DONE)) begin
     uvm_report_error("CFG", $psprintf("Unknown command -> %s", commands));
   end 

endfunction

//AMOL

function hqm_command_handler_status_t hqm_tb_cfg::sysrst_command_handler(hqm_cfg_command command);
    sysrst_command_handler = HQM_CFG_CMD_NOT_DONE;
    if (command.options.size() > 0) begin        
        `uvm_info("hqm_tb_cfg",$psprintf("Processing sysrst command <%s> <%0d> cycle", command.options[0].option, command.options[0].values[0]),UVM_MEDIUM);
        case (command.options[0].option.tolower())
            "resetprep"  :   begin
							add_register_to_access_list("resetprep", "resetprep", "resetprep", HQM_RESETPREP, 0, 0, 0, .sai(cur_sai));  
                            sysrst_command_handler = HQM_CFG_CMD_DONE;
                        end 

            "forcepwrgatepok"  :   begin
							add_register_to_access_list("forcepwrgatepok", "forcepwrgatepok", "forcepwrgatepok", HQM_FORCEPWRGATEPOK, 0, 0, 0, .sai(cur_sai));  
                            sysrst_command_handler = HQM_CFG_CMD_DONE;
                        end 

            "warm"  :   begin
							if(|command.options[0].values.size())  warm_reset_delay=command.options[0].values[0];
							add_register_to_access_list("warm_rst", "warm_rst", "warm_rst", HQM_WARM_RST, 0, 0, 0, .sai(cur_sai));  
                            sysrst_command_handler = HQM_CFG_CMD_DONE;
                        end 

            "flr"   :   begin
							flr_Q.push_back(func_no_lut[command.options[0].str_value]);
							if(shuffle_pkts)
							  `uvm_info("hqm_tb_cfg",$psprintf("Skipping HQM_SYSRST_FLR. Shuffle and send -> shuffle_pkts(%0d).",shuffle_pkts),UVM_LOW)
							else
							  add_register_to_access_list("flr", "flr", "flr", HQM_SYSRST_FLR, 0, 0, 0, .sai(cur_sai));  
                            sysrst_command_handler = HQM_CFG_CMD_DONE;
                        end 
            default : 
                        uvm_report_error("hqm_tb_cfg", $psprintf("Undefined sysrst option %s", command.options[0].option));
        endcase

    end  else begin
        `uvm_error("hqm_tb_cfg",$psprintf("Invalid sysrst command"))
    end 

endfunction

//----------------------------------------------------------------------------
//-- 
//----------------------------------------------------------------------------
function hqm_command_handler_status_t hqm_tb_cfg::runtest_command_handler(hqm_cfg_command command);
	string rcpath, cur_pool_ = "";
    int i;
	hcw_transaction  hcw_trans_;
    runtest_command_handler = HQM_CFG_CMD_NOT_DONE;
    if (command.options.size() >= 1) begin
    	foreach(command.options[i])
            `uvm_info("hqm_tb_cfg",$psprintf("Processing runtest command on <%s> ", command.options[i].option), UVM_MEDIUM);
			case (command.options[i].option.tolower())
  				"pool"	:   cur_pool_= command.options[i].str_value;
                "go"    :   add_register_to_access_list("go", "go", "go", HQM_RUNTST_GO, 0, 0, 0, .sai(cur_sai));
 				"sys_init": if(command.options[i].str_value.substr(0,3) =="pool")
							    add_register_to_access_list("pool_init", command.options[i].str_value, "pool_init", HQM_POOL_INIT, 0, 0, 0, .sai(cur_sai));
							else if(command.options[i].str_value=="sys")	
							    add_register_to_access_list("sys_init", "sys_init", "sys_init", HQM_SYS_INIT, 0, 0, 0, .sai(cur_sai));
							else if(command.options[i].str_value=="pf0")	
						        add_register_to_access_list("pf_init", "pf_init", "pf_init", HQM_PF_INIT, 0, 0, 0, .sai(cur_sai));
							else if(func_no_lut.exists(command.options[i].str_value))
							    add_register_to_access_list("vf_init", "vf_init", "vf_init", HQM_VF_INIT, .exp_rd_val(func_no_lut[command.options[i].str_value]), .sai(cur_sai));
						    else
								`uvm_error(get_name(),"Illegal sys_init command !!")

  				"gen_count"	: for(int kk=0;kk<command.options[i].values[0];kk++)  begin
								 hcw_trans_		  = hcw_transaction::type_id::create("hcw_trans_");
								 hcw_trans_.randomize();
								 hcw_trans_.do_copy(get_typical_hcw());
  								 hcw_trans_.ppid  = resolve_name(cur_pool_,-1,128);
								 hcw_trans_.qid = hcw_trans_.ppid;
  								 hcw_trans_.iptr  = 'h_0;
  								 hcw_trans_Q.push_back(hcw_trans_); 
								 if(shuffle_pkts)
									`uvm_info("hqm_tb_cfg",$psprintf("Skipping HCW_PKT_ENQ. Shuffle and send -> shuffle_pkts(%0d).",shuffle_pkts),UVM_LOW)
								 else
									add_register_to_access_list("pkt_enq", "pkt_enq", "pkt_enq", HQM_PKT_ENQ, 0, 0, 0, .sai(cur_sai));  
								`uvm_info(get_name(),$psprintf("Added HCW transaction to Q for pool=%s",cur_pool_),UVM_LOW);
								hcw_trans_.print();
  							  end 
  				"shuffle_pkts"	: if(command.options[i].values[0]) shuffle_pkts = command.options[i].values[0];
								  else							   shuffle_pkts_and_send();
            default: begin
						  `uvm_error("hqm_tb_cfg",$psprintf("Invalid runtest option <%s>",command.options[0].option));
            end 
        endcase
         runtest_command_handler = HQM_CFG_CMD_DONE;
    end  else begin
        `uvm_error("hqm_tb_cfg",$psprintf("Invalid runtest command"));
    end 

endfunction

function int hqm_tb_cfg::GetGlblSeqNum(int num=1);
    int cnt = GlblSeqNum;
    GlblSeqNum += num;
    return cnt;
endfunction: GetGlblSeqNum;

function int hqm_tb_cfg::GetPrioSeqNum(int is_ldb = 0, int ppid = 0, int prio = 0, int num=1);
    int cnt, pp;
    prio = (prio & 32'h7);
    pp = (is_ldb) ? (ppid & 32'h3f) : (ppid & 32'h7f);
    if(is_ldb) begin
        cnt = LdbPrioSeqNum[pp][prio];
        LdbPrioSeqNum[pp][prio] = cnt + num;
    end else begin
        cnt = DirPrioSeqNum[pp][prio];
        DirPrioSeqNum[pp][prio] = cnt + num;
    end 
    return cnt;
endfunction: GetPrioSeqNum;

function longint hqm_tb_cfg::GetCycleCnt();
    return CycleCnt;
endfunction: GetCycleCnt;

function void hqm_tb_cfg::set_cfg_end(hqm_cfg_command command);
    super.set_cfg_end();
endfunction: set_cfg_end;

function hcw_transaction hqm_tb_cfg::get_typical_hcw();
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

function void hqm_tb_cfg::shuffle_pkts_and_send();

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

function int hqm_tb_cfg::ready_to_send();
    if((this.register_access_list.size == 0) && (hcw_trans_Q.size < 4) && (HcwTxDly == 0)) begin
        HcwTxDly = $urandom_range(MaxHcwTxDly,MinHcwTxDly);
        ready_to_send = 1;
    end else begin
        HcwTxDly = (HcwTxDly > 0) ? (HcwTxDly - 1) : 0;
        ready_to_send = 0;
    end 
endfunction:ready_to_send;

function hcw_transaction hqm_tb_cfg::update_vas_configuration();

    foreach(dir_pp_cq_cfg[pp])	if(dir_pp_cq_cfg[pp].pp_provisioned)  begin
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr",   "dir_pp2vas",         pp, "vas",      this.dir_pp_cq_cfg[pp].vas);
    end 

    foreach(ldb_pp_cq_cfg[pp]) if(ldb_pp_cq_cfg[pp].pp_provisioned) begin  
        set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr",   "ldb_pp2vas",         pp, "vas",      this.ldb_pp_cq_cfg[pp].vas);
    end 

  foreach(vas_cfg[vas])	if(vas_cfg[vas].provisioned)
      for (int qid = 0 ; qid < 128 ; qid++) begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_vasqid_v",  (vas * 128) + qid, "vasqid_v",  this.vas_cfg[vas].ldb_qid_v[qid]);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "dir_vasqid_v",  (vas * 128) + qid, "vasqid_v",  this.vas_cfg[vas].dir_qid_v[qid]);
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
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe", "cfg_cq_ldb_inflight_limit", cq, "limit", (ldb_pp_cq_cfg[cq].hist_list_limit - 
            ldb_pp_cq_cfg[cq].hist_list_base) + 1); 
      end 
      set_cfg_val_index(HQM_CFG_WRITE,  "credit_hist_pipe", "cfg_hist_list_base",      cq, "base",      ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(HQM_CFG_WRITE,  "credit_hist_pipe", "cfg_hist_list_limit",     cq, "limit",     ldb_pp_cq_cfg[cq].hist_list_limit);
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_hist_list_push_ptr",  cq, "push_ptr",  ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_hist_list_push_ptr",  cq, "generation",0); 
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_hist_list_pop_ptr",   cq, "pop_ptr",   ldb_pp_cq_cfg[cq].hist_list_base); 
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_hist_list_pop_ptr",   cq, "generation",0); 

      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_cq_token_depth_select",cq, "token_depth_select", ldb_pp_cq_cfg[cq].cq_depth);
      set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe",    "cfg_cq_ldb_token_depth_select",cq, "token_depth_select", ldb_pp_cq_cfg[cq].cq_depth);    
      set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr",   "ldb_cq_isr",                   cq, "en_code",          ldb_pp_cq_cfg[cq].cq_isr.en_code);
      set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr",   "ldb_cq_isr",                   cq, "vf",               ldb_pp_cq_cfg[cq].cq_isr.vf);
      set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr",   "ldb_cq_isr",                   cq, "vector",           ldb_pp_cq_cfg[cq].cq_isr.vector);
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_cq_int_depth_thrsh",   cq, "depth_threshold",  ldb_pp_cq_cfg[cq].cq_depth_intr_thresh); 
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_cq_int_enb",           cq, "en_depth",         ldb_pp_cq_cfg[cq].cq_depth_intr_ena); 
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_cq_int_enb",           cq, "en_tim",           ldb_pp_cq_cfg[cq].cq_timer_intr_ena); 
      set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_ldb_cq_timer_threshold",   cq, "thrsh",            ldb_pp_cq_cfg[cq].cq_timer_intr_thresh); 
      set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe",    "cfg_cq2priov",                 cq, "v",      8'hff);
      set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe",    "cfg_cq2priov",                 cq, "prio",   24'h0);

  end 

    foreach(dir_pp_cq_cfg[cq])  if(dir_pp_cq_cfg[cq].cq_provisioned)	begin
        set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_dir_cq_token_depth_select",     cq, "token_depth_select", dir_pp_cq_cfg[cq].cq_depth);
        set_cfg_val_index(HQM_CFG_CWRITE, "list_sel_pipe",    "cfg_cq_dir_token_depth_select_dsi", cq, "token_depth_select", dir_pp_cq_cfg[cq].cq_depth);
        set_cfg_val_index(HQM_CFG_CWRITE, "credit_hist_pipe", "cfg_dir_cq_int_depth_thrsh",        cq, "depth_threshold",    dir_pp_cq_cfg[cq].cq_depth_intr_thresh);

    end 

    foreach(ldb_qid_cfg[qid])  if(ldb_qid_cfg[qid].provisioned) begin
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "mode", this.ldb_qid_cfg[qid].ord_mode); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "slot", this.ldb_qid_cfg[qid].ord_slot); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn_map", qid, "grp",  this.ldb_qid_cfg[qid].ord_grp); 
        set_cfg_val_index(HQM_CFG_WRITE, "credit_hist_pipe", "cfg_ord_qid_sn",     qid, "sn", this.ldb_qid_cfg[qid].ord_sn); 
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe",    "cfg_qid_ldb_inflight_limit", qid, "limit", ldb_qid_cfg[qid].qid_ldb_inflight_limit); 
        set_cfg_val_index(HQM_CFG_WRITE, "list_sel_pipe",    "cfg_qid_aqed_active_limit",  qid, "limit", 1 + ldb_qid_cfg[qid].aqed_freelist_limit - 
            ldb_qid_cfg[qid].aqed_freelist_base); 
        set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",       "cfg_aqed_freelist_base",  qid, "base", this.ldb_qid_cfg[qid].aqed_freelist_base); 
        set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",       "cfg_aqed_freelist_limit", qid, "limit", this.ldb_qid_cfg[qid].aqed_freelist_limit); 
        
        if (ldb_qid_cfg[qid].fid_cfg_v) begin
            set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",   "cfg_aqed_freelist_limit", qid, "freelist_disable", 0);
        end 

        set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",       "cfg_aqed_freelist_push_ptr", qid, "push_ptr", this.ldb_qid_cfg[qid].aqed_freelist_base); 
        set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",       "cfg_aqed_freelist_push_ptr", qid, "generation", 1);
        set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",       "cfg_aqed_freelist_pop_ptr",  qid, "pop_ptr", this.ldb_qid_cfg[qid].aqed_freelist_base); 
        set_cfg_val_index(HQM_CFG_CWRITE, "aqed_pipe",       "cfg_aqed_freelist_pop_ptr",  qid, "generation", 0);

    end 

    foreach(ldb_pp_cq_cfg[pp]) begin
        if(ldb_pp_cq_cfg[pp].cq_provisioned) begin
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_cq_addr_l", pp, "addr_l", this.ldb_pp_cq_cfg[pp].cq_gpa[31:6]); 
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "ldb_cq_addr_u", pp, "addr_u", this.ldb_pp_cq_cfg[pp].cq_gpa[63:32]); 
        end 
    end 

    foreach(dir_pp_cq_cfg[pp]) begin
        if(dir_pp_cq_cfg[pp].cq_provisioned) begin
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_cq_addr_l", pp, "addr_l", this.dir_pp_cq_cfg[pp].cq_gpa[31:6]); 
            set_cfg_val_index(HQM_CFG_CWRITE, "hqm_system_csr", "dir_cq_addr_u", pp, "addr_u", this.dir_pp_cq_cfg[pp].cq_gpa[63:32]); 
        end 
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
        
    end 

endfunction

function hcw_transaction hqm_tb_cfg::update_pf_configuration();
	update_vas_configuration();
endfunction

function hcw_transaction hqm_tb_cfg::update_vf_configuration(int vf_num);
    int vf;
    int vpp;
    int pp;
    int vqid;
    int qid;
    int idx;
	
 for(vf=0;( (vf<vf_num) && (vf_cfg[vf].provisioned) );vf++)  begin

    for (vpp = 0 ; vpp < 64 ; vpp++) begin
      pp = vf_cfg[vf].ldb_vpp_cfg[vpp].pp;

      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_ldb_vpp_v",  (vf * 64) + vpp, "vpp_v", this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v);
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_ldb_vpp2pp", (vf * 64) + vpp, "pp", pp);
      if (this.vf_cfg[vf].ldb_vpp_cfg[vpp].vpp_v) begin
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp2vf_pf", pp, "is_pf", this.ldb_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_pp2vf_pf", pp, "vf",    this.ldb_pp_cq_cfg[pp].vf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_cq2vf_pf", pp, "is_pf", this.ldb_pp_cq_cfg[pp].is_pf);
        set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "ldb_cq2vf_pf", pp, "vf",    this.ldb_pp_cq_cfg[pp].vf);
      end 
    end 

    for (vpp = 0 ; vpp < 128 ; vpp++) begin
      pp = vf_cfg[vf].dir_vpp_cfg[vpp].pp;

      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_dir_vpp_v", (vf * 128) + vpp, "vpp_v", this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v);
      set_cfg_val_index(HQM_CFG_WRITE, "hqm_system_csr", "vf_dir_vpp2pp", (vf * 128) + vpp, "pp", pp);
      if (this.vf_cfg[vf].dir_vpp_cfg[vpp].vpp_v) begin
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
