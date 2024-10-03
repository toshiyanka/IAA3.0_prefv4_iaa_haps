import dft_common_val_seq_pkg::*;
import dft_common_val_tb_pkg::*;

class dft_itpp_test extends `ITPP_READER_BASE_TEST;

    dft_common_val_sim_component dft_val_sim_comp;

    `ovm_component_utils(dft_itpp_test)

    function new (string name = "saola_itpp_test", ovm_component parent = null);

        super.new(name, parent);

        dft_val_sim_comp = dft_common_val_sim_component::type_id::create("dft_val_sim_comp", this);

        `ovm_info("ITPP_READER_TEST_INFO", "Completed ITPP test constructor function", OVM_NONE)

    endfunction

    function void connect();

        sla_tb_env top_tb_env;

        super.connect();

        top_tb_env = sla_tb_env::get_top_tb_env();

        if ($test$plusargs("ITPP_RESET_TEST")) begin

            sla_phase_name_t test_phases[$];

            // add a new Saola test phase at time=0
            `ovm_info("ITPP_READER_TEST_INFO", "Detected ITPP reset test!", OVM_NONE)
            top_tb_env.get_all_phases(test_phases);
            top_tb_env.add_test_phase("ITPP_PHASE", test_phases[0], "BEFORE");
            top_tb_env.set_phase_delay("ITPP_PHASE", 0);

            // declare the Saola test phase for ITPP execution
            top_tb_env.set_test_phase_type(top_tb_env.get_name(), "ITPP_PHASE", "itpp_phase_seq");
            top_tb_env.set_test_phase_type(top_tb_env.get_name(), "USER_DATA_PHASE", "goodbye_world_seq");

        end else begin

            string target_phase;
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
                top_tb_env.set_test_phase_type(top_tb_env.get_name(), "DFT_VAL_INIT_PHASE", "dft_val_init_seq");
            end

            // declare the Saola test phase for ITPP execution
            top_tb_env.set_test_phase_type(top_tb_env.get_name(), itpp_test_phase_name, itpp_test_phase_seq);

        end

    endfunction : connect

endclass : dft_itpp_test
