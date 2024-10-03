`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

import hqm_tb_cfg_pkg::*;

//-----------------------------------------------------------
//-----------------------------------------------------------
class hqm_cfg_reset_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_cfg_reset_seq_stim_config";

  `ovm_object_utils_begin(hqm_cfg_reset_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_hqm_reg_reset,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_hqm_sb_reset,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_hqm_cqgen_reset,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hqm_cfg_reset_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_int(do_hqm_reg_reset)
    `stimulus_config_field_int(do_hqm_sb_reset)
    `stimulus_config_field_int(do_hqm_cqgen_reset)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  int                     do_hqm_reg_reset;
  rand  bit                     do_hqm_sb_reset;
  rand  bit                     do_hqm_cqgen_reset;


  constraint c_hqm_cfg_reset_0 {
   `ifdef IP_TYP_TE
      soft do_hqm_reg_reset           == 2; 
      soft do_hqm_sb_reset            == 1; 
      soft do_hqm_cqgen_reset         == 1; 
   `else
      soft do_hqm_reg_reset           == 2; 
      soft do_hqm_sb_reset            == 1; //1: reset
      soft do_hqm_cqgen_reset         == 1; //1: reset cq_gen_check
   `endif
                                          //-- 0: no reset
                                          //-- 1: set both do_hqm_cfg_reg_reset=0 and do_ral_reg_reset=1
                                          //-- 2: set do_hqm_cfg_reg_reset=1 do_ral_reg_reset=0
                                          //-- 3: set do_hqm_cfg_reg_reset=1 do_ral_reg_reset=1

  }


  function new(string name = "hqm_cfg_reset_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_cfg_reset_seq_stim_config

//-----------------------------------------------------------
//-----------------------------------------------------------
class hqm_cfg_reset_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_cfg_reset_seq, sla_sequencer)

    rand hqm_cfg_reset_seq_stim_config                  cfg;

    hqm_cfg                       i_hqm_cfg;
    hqm_tb_hcw_scoreboard         i_hcw_scoreboard;
    hqm_pp_cq_status              i_hqm_pp_cq_status;

    hqm_mem_map_cfg mem_map_obj;

   `ifdef IP_TYP_TE
     `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_cfg_reset_seq_stim_config);
   `endif

    function new(string name = "hqm_cfg_reset_seq");
       super.new(name);
       cfg = hqm_cfg_reset_seq_stim_config::type_id::create("hqm_cfg_reset_seq_stim_config");
      `ifdef IP_TYP_TE
         apply_stim_config_overrides(0);
      `else
         cfg.randomize();
      `endif
    endfunction

    //----------------------------
    //-- get_agent_cfg_obj
    //----------------------------
    function void get_agent_cfg_obj();
        ovm_object o_tmp;

        if (p_sequencer.get_config_object({"hqm_mem_map_obj",inst_suffix}, o_tmp,0))  begin
            $cast(mem_map_obj, o_tmp);
        end else begin
            `ovm_fatal(get_full_name(), "Unable to get config object hqm_mem_map_obj");
        end

        //-----------------------------
        //-- get i_hqm_cfg
        //-----------------------------
        if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
             ovm_report_info(get_full_name(), "hqm_cfg_reset_seq: Unable to find i_hqm_cfg object", OVM_LOW);
             i_hqm_cfg = null;
        end else begin
             if (!$cast(i_hqm_cfg, o_tmp)) begin
               ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
             end
        end
      
        //-----------------------------
        //-- get i_hcw_scoreboard
        //-----------------------------
        if (!p_sequencer.get_config_object({"i_hcw_scoreboard",inst_suffix}, o_tmp)) begin
             ovm_report_info(get_full_name(), "hqm_cfg_reset_seq: Unable to find i_hcw_scoreboard object", OVM_LOW);
             i_hcw_scoreboard = null;
        end else begin
             if (!$cast(i_hcw_scoreboard, o_tmp)) begin
               ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
             end
        end

        //-----------------------------
        // -- get i_hqm_pp_cq_status
        //-----------------------------
        if ( p_sequencer.get_config_object({"i_hqm_pp_cq_status",inst_suffix}, o_tmp) ) begin
            if ( ! ($cast(i_hqm_pp_cq_status, o_tmp)) ) begin
                ovm_report_fatal(get_full_name(), $psprintf("hqm_cfg_reset_seq: Object passed through i_hqm_pp_cq_status not compatible with class type hqm_pp_cq_status"));
            end 
        end else begin
            ovm_report_info(get_full_name(), $psprintf("No i_hqm_pp_cq_status set through set_config_object"));
            i_hqm_pp_cq_status = null;
        end

    endfunction

   
    //----------------------------
    //-- body
    //----------------------------
    virtual task body();

       //--------------------------------
       get_agent_cfg_obj();

       //--------------------------------
       `ifdef IP_TYP_TE
          apply_stim_config_overrides(1);
       `endif

       //--------------------------------
       `ovm_info(get_name(), $psprintf("Starting hqm_cfg cfg_cmds push... do_hqm_reg_reset=%0d do_hqm_sb_reset=%0d do_hqm_cqgen_reset=%0d", cfg.do_hqm_reg_reset, cfg.do_hqm_sb_reset, cfg.do_hqm_cqgen_reset), OVM_LOW);

       //--------------------------------
       cfg_cmds.push_back("idle 100");

       //--------------------------------
       if($test$plusargs("HQM_CFG_RESET_SKIP")) begin
          `ovm_info(get_name(), $psprintf("Skip Issue reg_reset cmd"), OVM_LOW);
       end else if(cfg.do_hqm_reg_reset==1 || $test$plusargs("HQM_CFG_RESET_1")) begin
          `ovm_info(get_name(), $psprintf("Issue reg_reset ral cmd"), OVM_LOW);
           cfg_cmds.push_back("reg_reset ral");
       end else if(cfg.do_hqm_reg_reset==2 || $test$plusargs("HQM_CFG_RESET_2")) begin
          `ovm_info(get_name(), $psprintf("Issue reg_reset hqm_cfg cmd to reset hqm_cfg and hqm_pp_cq_status"), OVM_LOW);
           cfg_cmds.push_back("reg_reset hqm_cfg");
           i_hqm_cfg.reset_hqm_cfg();
           i_hqm_pp_cq_status.reset();
       end else if(cfg.do_hqm_reg_reset==3 || $test$plusargs("HQM_CFG_RESET_3")) begin
          `ovm_info(get_name(), $psprintf("Issue reg_reset cmd to reset ral, hqm_cfg and hqm_pp_cq_status"), OVM_LOW);
           cfg_cmds.push_back("reg_reset"); 
           i_hqm_cfg.reset_hqm_cfg();
           i_hqm_pp_cq_status.reset();
       end else begin
          `ovm_info(get_name(), $psprintf("Skip Issue reg_reset cmd"), OVM_LOW);
       end

       if($test$plusargs("HQM_SB_RESET_SKIP")) begin
          `ovm_info(get_name(), $psprintf("Bypass i_hcw_scoreboard.hcw_scoreboard_reset() "), OVM_LOW);
       end else if(cfg.do_hqm_sb_reset==1 || $test$plusargs("HQM_TB_SB_RESET")) begin
           i_hcw_scoreboard.hcw_scoreboard_reset();
          `ovm_info(get_name(), $psprintf("Issue i_hcw_scoreboard.hcw_scoreboard_reset() "), OVM_LOW);
       end
      
       if(cfg.do_hqm_cqgen_reset==1 || $test$plusargs("HQM_CQGEN_RESET")) begin
          `ovm_info(get_name(), $psprintf("Issue hqm_cfg.hqm_rst_comp=1 to reset cq_gen_reset() "), OVM_LOW);
           i_hqm_cfg.hqm_rst_comp=1;
       end
       super.body();
    endtask

endclass
