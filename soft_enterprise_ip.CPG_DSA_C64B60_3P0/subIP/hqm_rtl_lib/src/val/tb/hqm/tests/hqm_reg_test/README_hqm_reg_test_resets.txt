Most of the reset register testing you indicated is ready.

The cold_reset_sequence has been integrated for reg_tests_rs1.list

To run the regression:
simregress -l verif/tb/hqm/reglist/reg_tests_rs1.list
######################################################
verif/tb/hqm/seqlib/test_hqm_ral_attr_seq.sv excerpt:
    if(resetm != 0)
      begin : resetm_nz
        if(curr_phase == "DATA_PHASE")
          begin : resetm_nz_dp
            atr = 1; //use attribute test to modify registers
            def = 0; //no default value check this phase
            restm = 0; //no restore mode, time for only one write
            tsm = 0; //write followed by read_and_check one register at a time
            wom = 0; //inverse write operation mode
            wrcnt = 1; //reduce write count to prevent timeout
          end   : resetm_nz_dp
        if(curr_phase == "POST_RESET_DATA_PHASE")
          begin : resetm_nz_prdp
            atr = 0; //don't modify registers
            def = 1; //just do default value check this phase
          end   : resetm_nz_prdp
      end   : resetm_nz
######################################################
verif/tb/hqm/tests/hqm_reg_test/hqm_reg_test.svh excerpts:
function void build();
    super.build();
    if(resetm != 0)
     begin : resetm_nz //reset_mode(do second reset when nonzero)
       i_hqm_tb_env.add_test_phase("POST_RESET_DATA_PHASE","FLUSH_PHASE","BEFORE");
       i_hqm_tb_env.add_test_phase("RECONFIG_PHASE","POST_RESET_DATA_PHASE","BEFORE");
       i_hqm_tb_env.add_test_phase("HARD_RERESET_PHASE","RECONFIG_PHASE","BEFORE");
     end  : resetm_nz
  endfunction : build

function void connect();
#...
    if(resetm != 0)
     begin : connect_resetm //reset_mode(do second reset when nonzero)
       if(resetm == 1)
        begin : connect_resetm_eq_1 //cold reset
          i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","HARD_RERESET_PHASE","hqm_cold_reset_sequence");
        end   : connect_resetm_eq_1
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","RECONFIG_PHASE","hqm_tb_cfg_opt_file_mode_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","POST_RESET_DATA_PHASE","test_hqm_ral_attr_seq");
     end   : connect_resetm
######################################################
cfg/trex/hqm_TREX.pm excerpt:
  if ($main::found_opt{hqm_rs1}) {
     push @hqm_simv_args,"-simv_args","+hraisresetm=1";
  }
######################################################


