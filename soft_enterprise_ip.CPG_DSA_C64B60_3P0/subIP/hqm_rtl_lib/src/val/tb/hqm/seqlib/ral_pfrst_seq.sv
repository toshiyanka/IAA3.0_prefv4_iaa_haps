
//`include "hqm_iosf_prim_mon.sv"
   
import hqm_saola_pkg::*;
class ral_pfrst_seq extends ovm_sequence;
  `ovm_sequence_utils(ral_pfrst_seq,sla_sequencer)

  sla_ral_env                   ral;
  hqm_cfg                       cfg;
  hqm_pp_cq_status              i_pp_cq_status;

  //hqm_credit_hist_pipe_map_file              chp_regs;
  sla_status_t                  status;
  sla_ral_data_t                rd_val, wr_val;
  sla_ral_access_path_t         primary_id, access;
  hqm_iosf_prim_mon     i_hqm_iosf_prim_mon_obj;
  hqm_iosf_prim_checker i_hqm_iosf_prim_checker_obj;


  //sla_hqm_core_env              i_sla_hqm_core_env;

   function new(string name = "ral_pfrst_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
      super.new(name, sequencer, parent_seq); 
      
         endfunction

    function void reset_agent_prim_checker_obj();
        ovm_object tmp_obj;

        if (p_sequencer.get_config_object("i_hqm_iosf_prim_checker", tmp_obj,0))  begin

            $cast(i_hqm_iosf_prim_checker_obj, tmp_obj);
        end else begin
            `ovm_fatal(get_full_name(), "Unable to get config object i_hqm_iosf_prim_checker_obj");
        end
        // -- Reset transaction Qs -- //
        i_hqm_iosf_prim_checker_obj.reset_txnid_q(); 
        i_hqm_iosf_prim_checker_obj.reset_ep_bus_num_q(); 
        i_hqm_iosf_prim_checker_obj.reset_func_flr_status(); 

    endfunction


    function void get_agent_mon_obj();
        ovm_object tmp_obj;

        if (p_sequencer.get_config_object("i_hqm_iosf_prim_mon", tmp_obj,0))  begin

            $cast(i_hqm_iosf_prim_mon_obj, tmp_obj);
        end else begin
            `ovm_fatal(get_full_name(), "Unable to get config object hqm_iosf_prim_mon_obj");
        end
           //CQ_reset
        i_hqm_iosf_prim_mon_obj.cq_gen_reset(); 

    endfunction

  virtual task body();
 
     ovm_object temp;

     get_agent_mon_obj();
     reset_agent_prim_checker_obj(); 

    `sla_assert($cast(ral,sla_ral_env::get_ptr()),
                ("Unable to get handle to RAL."))
 
     //get cfg object
      if (cfg == null) begin
        cfg = hqm_cfg::get();
        if (cfg == null) begin
          ovm_report_fatal(get_full_name(), $psprintf("Unable to get CFG object"));
        end
      end

      //get pp_cq_status object
      p_sequencer.get_config_object("i_hqm_pp_cq_status", temp);
      $cast(i_pp_cq_status,temp);

      `ovm_info("RAL_PFRST_seq", $psprintf("Pf_rst_sequence_started"), OVM_LOW)

      //The RAL hierarchy will get reset by getting a handle to the sla_ral_env class and calling the sla_ral_env::reset_regs() function
       ral.reset_regs(); 

      //clear hqm_cfg class internal configuratiom  n
      cfg.reset_hqm_cfg();

      i_pp_cq_status.reset();


   //add cg_reset 
    
      endtask : body
endclass : ral_pfrst_seq
