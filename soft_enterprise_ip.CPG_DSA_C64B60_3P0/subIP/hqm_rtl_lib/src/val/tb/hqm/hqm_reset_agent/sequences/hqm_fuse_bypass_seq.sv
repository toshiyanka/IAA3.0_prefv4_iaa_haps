

//FBP
//class hqm_fuse_bypass_seq extends reset_sequence_phase_base;
class hqm_fuse_bypass_seq extends ovm_sequence;
    `ovm_object_utils(hqm_fuse_bypass_seq)

    hqm_integ_pkg::HqmIntegEnv agent_env;
    sla_fuse_env fal;
    sla_fuse_group fuse_group;
    int fuse_download_no_bypass;
    int fuse_req_group;
    string fuse_puller_path;
    string fuse_group_name;

    protected sla_fuse_env target_sla_fuse_env;

    // Public virtual set. IPs or SoCs can override this method in their project if they have a common internal utility to do further lookups
    virtual function sla_fuse_env get_sla_fuse_env();
      if(target_sla_fuse_env == null) begin
        return sla_fuse_env::get_ptr( );
      end else begin
        return target_sla_fuse_env;
      end
    endfunction

    // Public virtual set. For callers to set a an environment that the sequence must use explicitly.
    virtual function void set_sla_fuse_env(sla_fuse_env fuse_env);
      target_sla_fuse_env = fuse_env;
    endfunction


    function new(string name = "hqm_fuse_bypass_seq");
        super.new(name);
        if(!($cast(fal, sla_fuse_env::get_ptr()) && (fal != null))) begin
            `ovm_fatal(get_name(), "Unable to find FAL object");           
        end
    endfunction : new


    virtual function void init();

        // Avoid fatals for things we don't need if not bypassing
        if (agent_env.hqmCfg.hqm_fuse_no_bypass == 0) begin 
            if (agent_env.hqmCfg.hqm_fuse_rtl_path == "") begin
                `ovm_fatal(get_name(), "HQM RTL path not provided to HQM config object. Need a set_config_string('HQM_RTL_TOP') in top level env")
            end
            fuse_puller_path = {agent_env.hqmCfg.hqm_fuse_rtl_path,".par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_top.i_hqm_iosfsb_top.i_hqm_msg_wrapper.i_hqm_fuse_puller"};
            fuse_group_name = agent_env.hqmCfg.hqm_fuse_group;

            fuse_group = fal.get_group_by_name(fuse_group_name);
            if (fuse_group == null) begin
                `ovm_fatal(get_name(), $sformatf("Unable to get handle to HQM fuse group: %s", fuse_group_name))
            end

            fuse_req_group = 0;
        end

    endfunction : init

    virtual task hqm_fuse_bypass();

        int signal_value;
        chandle handle;
       
        fork begin
            handle = sla_vpi_handle_by_name({fuse_puller_path, ".ip_request"});

            `ovm_info(get_name(), $sformatf("HQM waiting for fuse pull request at time: %d", $time), OVM_LOW)
            signal_value = sla_vpi_get_value(handle, {fuse_puller_path, ".ip_request"});
            while (signal_value != 1) begin
                #1;
                signal_value = sla_vpi_get_value(handle, {fuse_puller_path, ".ip_request"});
            end
            `ovm_info(get_name(), $sformatf("HQM fuse pull request at time: %d", $time), OVM_LOW)

            //#1;
            `ovm_info(get_name(), $sformatf("HQM forcing next state of fsm to puller done at time: %d", $time), OVM_LOW)
            sla_vpi_put_value_by_name({fuse_puller_path, ".i_fp_ip_fsm.next_state[2:0]"}, 'h4);  

            handle = sla_vpi_handle_by_name({fuse_puller_path, ".puller_done"});
            `ovm_info(get_name(), $sformatf("Waiting for hqm fuse puller done at time: %d", $time), OVM_LOW)
            signal_value = sla_vpi_get_value(handle, {fuse_puller_path, ".puller_done"});
            while (signal_value != 1) begin
                #1;
                signal_value = sla_vpi_get_value(handle, {fuse_puller_path, ".puller_done"});
            end
            `ovm_info(get_name(), $sformatf("HQM fuse FSM at puller done at time: %d", $time), OVM_LOW)

            `ovm_info(get_name(), $sformatf("Setting hqm fuses through back door at time: %d", $time), OVM_LOW)
            fal.write_fuse_group_backdoor(fuse_group, , "Group", fuse_req_group);

            `ovm_info(get_name(), $sformatf("HQM fuse group %s bypassed at time: %d", fuse_group_name, $time), OVM_LOW)
        end
        join_none

    endtask : hqm_fuse_bypass

    task body();

        `sla_assert($cast(agent_env, sla_tb_env::get_tb_env("hqm_agent")),("Could not get a TB_Env pointer"));
        fal = get_sla_fuse_env();

        init();

        //lowerExitObjection();
         
         if (agent_env.hqmCfg.hqm_fuse_no_bypass == 0) begin
            `ovm_info(get_name(), "HQM fuse bypass enabled. Bypassing fuse pull", OVM_LOW)
            hqm_fuse_bypass();
        end
        else begin
            `ovm_info(get_name(), "HQM fuse bypass not enabled. Doing full download", OVM_LOW)
        end

    endtask : body

endclass
