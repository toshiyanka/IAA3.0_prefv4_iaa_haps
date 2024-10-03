#!/usr/bin/sh
##Modes:  Register, Register reset, IOSF, PCIe, BG+AGI, BG, Power, 

simregress -dut hqm -model hqm -save -notify -trex  -code_cov -trex- -l ./verif/tb/hqm/reglist/hqm_compliance/hqm_pcie_test.list 
sleep 60m
simregress -dut hqm -model hqm -save -notify -trex  -code_cov -trex- -l ./verif/tb/hqm/reglist/hqm_compliance/hqm_iosf_test.list
sleep 45m
##functional simregress -dut hqm -model hqm -save -notify -trex  -code_cov -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqm_functional.list
simregress -dut hqm -model hqm -save -notify -trex  -code_cov -trex- -l ./verif/tb/hqm/reglist/hqm_reg/hqm_reg_tests.list
sleep 2h 
simregress -dut hqm -model hqm -save -notify -trex  -code_cov -trex- -l ./verif/tb/hqm/reglist/hqm_reg/hqm_reg_reset_tests.list
sleep 2h  
simregress -dut hqm -model hqm -save -notify -trex  -code_cov -vcsvariant mpp -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqm_pwr_test.list  
sleep 2h  
##simregress -dut hqm -model hqm -save -notify -trex  -code_cov -vcsvariant mpp -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqm_pa_random_corrupt.list 
sleep 90m
##simregress -dut hqm -model hqm -save -notify -trex  -code_cov -vcsvariant mpp -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqmv25_pwr_switching_tests.list 
sleep 90m
simregress -dut hqm -model hqm -save -notify -trex  -code_cov -hqm_bg_cfg_en -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqm_functional.list
sleep 3h  
simregress -dut hqm -model hqm -save -notify -trex  -code_cov -hqm_agitate_rand_en -hqm_agitate_wdata 0x04000802  -ace_args -simv_args '"' +agitate_hcw_wr_rdy=1:40:1:10  +SLA_MAX_RUN_CLOCK=4000000 +SLA_USER_DATA_PHASE_TIMEOUT=4000000  +SLA_PRE_FLUSH_PHASE_TIMEOUT=400000 +SLA_RANDOM_DATA_PHASE_TIMEOUT=20000000 '"' -ace_args- -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqm_functional.list
sleep 180m
##agitate simregress -model hqm -dut hqm -save -notify -trex  -code_cov -hqm_bg_cfg_en -hqm_agitate_rand_en -hqm_agitate_wdata 0x04000802  -ace_args -simv_args '"'+agitate_hcw_wr_rdy=1:40:1:10  +SLA_PRE_FLUSH_PHASE_TIMEOUT=400000 '"' -ace_args- -trex- -l ./verif/tb/hqm/reglist/hqm_functional/hqm_functional.list


## merged coverage command
## urg -full64 -show tests -f <vdbfiles.list> -dir <model_root/target/hqm/vcs_4value/hqm/hqm.simv.vdb/> -dbname hqm_merged_all -report hqm_merged_all -log urg_warnings
## addon command
## 1.-elfilelist <exclusion_list> -excl_bypass_checks 
## 2. -plan <hvp file path>
##ex. urg -full64 -show tests -f vdbfiles.list -dir /nfs/site/disks/axx_0046/users/vijayaga/hqmv25_20ww17.1/target/hqm/vcs_4value/hqm/hqm.simv.vdb/ -dbname hqm_merged_all -report hqm_merged_all -log urg_warnings


