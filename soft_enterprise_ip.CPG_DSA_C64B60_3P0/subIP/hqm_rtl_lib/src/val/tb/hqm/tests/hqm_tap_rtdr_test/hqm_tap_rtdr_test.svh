import hqm_tap_rtdr_common_val_seq_pkg::*;
import hqm_tap_rtdr_common_val_tb_pkg::*;

class hqm_tap_rtdr_test extends hqm_base_test;

    hqm_tap_rtdr_common_val_sim_component tap_rtdr_sim_comp;

    `ovm_component_utils(hqm_tap_rtdr_test)



    function new (string name = "saola_itpp_test", ovm_component parent = null);

        super.new(name, parent);

        tap_rtdr_sim_comp = hqm_tap_rtdr_common_val_sim_component::type_id::create("hqm_tap_rtdr_val_sim_comp", this);

        `ovm_info("HQM_TAP_RTDR_TEST", "Completed HQM_TAP_RTDR_TEST test constructor function", OVM_NONE)

    endfunction

    function void connect();
        string target_phase;
        sla_tb_env top_tb_env;

        super.connect();

        top_tb_env = sla_tb_env::get_top_tb_env();

        if ($test$plusargs("HAS_ITPP_RESET_TEST_PHASE")) begin

            sla_phase_name_t test_phases[$];

            // add a new Saola test phase at time=0
            `ovm_info(top_tb_env.get_name(), "Detected ITPP reset test!", OVM_NONE)
            top_tb_env.get_all_phases(test_phases);
            top_tb_env.add_test_phase("ITPP_PHASE", test_phases[0], "BEFORE");
            top_tb_env.set_phase_delay("ITPP_PHASE", 0);

            // 
            i_hqm_tb_env.get_all_phases(test_phases);

            // declare the Saola test phase for ITPP execution
            ///top_tb_env.set_test_phase_type(top_tb_env.get_name(), "ITPP_PHASE", "itpp_phase_seq"); 
            top_tb_env.set_test_phase_type(top_tb_env.get_name(), "ITPP_PHASE", "hqm_tap_rtdr_val_init_seq");
            `ovm_info(top_tb_env.get_name(), $psprintf("Use:ITPP_PHASE for hqm_tap_rtdr_val_init_seq"), OVM_NONE)	       
             
        end else if ($test$plusargs("HAS_PWR_RESET_TEST_PHASE")) begin
                target_phase = "WARM_RESET_PHASE";
                $value$plusargs("PWR_TEST_PHASE=%s", target_phase);	
			
                top_tb_env.add_test_phase("PWR_TEST_PHASE", target_phase, "BEFORE");
                top_tb_env.set_test_phase_type(top_tb_env.get_name(), "PWR_TEST_PHASE", "hqm_pwr_extra_data_phase_seq");
                `ovm_info(top_tb_env.get_name(), $psprintf("Use:PWR_TEST_PHASE before %0s for hqm_pwr_extra_data_phase_seq", target_phase), OVM_NONE)

                top_tb_env.set_test_phase_type(top_tb_env.get_name(), "USER_DATA_PHASE", "hqm_tap_rtdr_val_init_seq");
               `ovm_info(top_tb_env.get_name(), $psprintf("Use:USER_DATA_PHASE for hqm_tap_rtdr_val_init_seq"), OVM_NONE)

        end else if ($test$plusargs("HAS_DFT_PWR_OVR_TEST_PHASE")) begin
                target_phase = "WARM_RESET_PHASE";
                $value$plusargs("PWR_OVR_TEST_PHASE=%s", target_phase);	
			
                top_tb_env.add_test_phase("PWR_OVR_TEST_PHASE", target_phase, "BEFORE");
                top_tb_env.set_test_phase_type(top_tb_env.get_name(), "PWR_OVR_TEST_PHASE", "hqm_tap_rtdr_val_init_seq");
                `ovm_info(top_tb_env.get_name(), $psprintf("Use:PWR_OVR_TEST_PHASE before %0s for hqm_tap_rtdr_val_init_seq", target_phase), OVM_NONE)

        end else if ($test$plusargs("HAS_DFT_VAL_INIT_PHASE")) begin  
                target_phase = "CONFIG_PHASE";
                $value$plusargs("DFT_VAL_TEST_PHASE=%s", target_phase);	
			
                top_tb_env.add_test_phase("DFT_VAL_INIT_PHASE", target_phase, "BEFORE");
                top_tb_env.set_test_phase_type(top_tb_env.get_name(), "DFT_VAL_INIT_PHASE", "hqm_tap_rtdr_val_init_seq");
                `ovm_info(top_tb_env.get_name(), $psprintf("Use:DFT_VAL_INIT_PHASE before %0s for hqm_tap_rtdr_val_init_seq", target_phase), OVM_NONE)


                top_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
                top_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hcw_enqtrf_test_hcw_seq");
                top_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
                `ovm_info(top_tb_env.get_name(), $psprintf("Use:Call other PHASES for traffic"), OVM_NONE)

        end else if ($test$plusargs("HAS_DFT_VAL_IN_ANY_PHASE")) begin
              
            string itpp_test_phase_seq  = "itpp_phase_seq";
            string itpp_test_phase_name = "USER_DATA_PHASE";

            $value$plusargs("ITPP_TEST_PHASE=%s", itpp_test_phase_name);
            $value$plusargs("ITPP_TEST_PHASE_SEQUENCE=%s", itpp_test_phase_seq);

            // add a Saola test phase for BFM init
            if (!$test$plusargs("SKIP_DFT_VAL_INIT_PHASE")) begin
                `ovm_info("ITPP_READER_TEST_INFO",
                    $psprintf("Registering DFT val init seq before '%s'", itpp_test_phase_name), OVM_NONE)
                target_phase = (itpp_test_phase_name == "USER_DATA_PHASE") ? "DATA_PHASE" : itpp_test_phase_name;
                top_tb_env.add_test_phase("DFT_VAL_INIT_PHASE", target_phase, "BEFORE");
                top_tb_env.set_test_phase_type(top_tb_env.get_name(), "DFT_VAL_INIT_PHASE", "hqm_tap_rtdr_val_init_seq");
            end

            // declare the Saola test phase for ITPP execution
            ///top_tb_env.set_test_phase_type(top_tb_env.get_name(), itpp_test_phase_name, itpp_test_phase_seq);

        end else begin
             
            // declare the Saola test phase for ITPP execution
            top_tb_env.set_test_phase_type(top_tb_env.get_name(), "USER_DATA_PHASE", "hqm_tap_rtdr_val_init_seq");
            `ovm_info(top_tb_env.get_name(), $psprintf("Use:USER_DATA_PHASE for hqm_tap_rtdr_val_init_seq"), OVM_NONE)
      	
        end

    endfunction : connect

endclass : hqm_tap_rtdr_test
