#!/usr/intel/pkgs/perl/5.14.1/bin/perl -w

   #cpl timeout scenario
#	for(my $i = 0; $i <= 15; $i++) {
#       my $cft_str  = "hcw_dmv_vf".$i."_copy_cfg.cft";
#       my $test_str = "cpl_timeout_vf".$i."";
#       my $simv_args = "\"+HQM_SEQ_CFG=aceroot/verif/tb/hqm/hqm_pcie_lib/cft/hqm_range_B0_timeout_cfg.cft +DM_VPA_ERROR_TEST\",\n\t\t\t\t\"+HQM_SEQ_CFG_USER_DATA=aceroot/verif/tb/hqm/tests/$cft_str\",\n\t\t\t\t\"+SLA_MAX_CONFIG_PHASE_TIMEOUT=3000000000 +SLA_MAX_USER_DATA_PHASE_TIMEOUT=3000000000\",\n\t\t\t\t\" +expect_completion_timeout +msix_vector=0 +HQM_LSP_CQ_QID_CFG_CHECK_DIS +UNWANTED_TXN\",\n\t\t\t\t\"+HQM_SYSTEM_CONTINUE_ON_CTO +eot_vf$i +pcie_ct +pcie_anfes +pcie_ned +pcie_ced\",";
#       print "\t\t$test_str => {\n"; 
#       print "\t\t\t-simv_args => [ $simv_args \n\t\t\t],\n\t\t},\n";
#    }
 	for(my $i = 0; $i <= 15; $i++) {
       my $cft_str  = "hcw_dmv_vf".$i."_copy_cfg.cft";
       my $test_str = "cpl_timeout_vf".$i."_severity_1";
       my $simv_args = "\"+HQM_SEQ_CFG=aceroot/verif/tb/hqm/hqm_pcie_lib/cft/hqm_range_B0_timeout_cfg_aer_severity_set.cft +DM_VPA_ERROR_TEST\",\n\t\t\t\t\"+HQM_SEQ_CFG_USER_DATA=aceroot/verif/tb/hqm/tests/$cft_str\",\n\t\t\t\t\"+SLA_MAX_CONFIG_PHASE_TIMEOUT=3000000000 +SLA_MAX_USER_DATA_PHASE_TIMEOUT=3000000000\",\n\t\t\t\t\" +expect_completion_timeout +msix_vector=0 +HQM_LSP_CQ_QID_CFG_CHECK_DIS +UNWANTED_TXN\",\n\t\t\t\t\"+HQM_SYSTEM_CONTINUE_ON_CTO +eot_vf$i +pcie_ct +pcie_anfes +pcie_fed +pcie_ced\",";
       print "\t\t$test_str => {\n"; 
       print "\t\t\t-simv_args => [ $simv_args \n\t\t\t],\n\t\t},\n";
    } 
 	for(my $i = 0; $i <= 15; $i++) {
       my $cft_str  = "hcw_dmv_vf".$i."_copy_cfg.cft";
       my $test_str = "cpl_timeout_vf".$i."_1";
       my $simv_args = "\"+HQM_SEQ_CFG=aceroot/verif/tb/hqm/hqm_pcie_lib/cft/hqm_range_B1_timeout_cfg.cft +DM_VPA_ERROR_TEST\",\n\t\t\t\t\"+HQM_SEQ_CFG_USER_DATA=aceroot/verif/tb/hqm/tests/$cft_str\",\n\t\t\t\t\"+SLA_MAX_CONFIG_PHASE_TIMEOUT=3000000000 +SLA_MAX_USER_DATA_PHASE_TIMEOUT=3000000000\",\n\t\t\t\t\" +expect_completion_timeout +msix_vector=0 +HQM_LSP_CQ_QID_CFG_CHECK_DIS +UNWANTED_TXN\",\n\t\t\t\t\"+HQM_SYSTEM_CONTINUE_ON_CTO +eot_vf$i +pcie_ct +pcie_anfes +pcie_ned +pcie_ced\",";
       print "\t\t$test_str => {\n"; 
       print "\t\t\t-simv_args => [ $simv_args \n\t\t\t],\n\t\t},\n";
    }
 	for(my $i = 0; $i <= 15; $i++) {
       my $cft_str  = "hcw_dmv_vf".$i."_copy_cfg.cft";
       my $test_str = "cpl_timeout_vf".$i."_1_severity_1";
       my $simv_args = "\"+HQM_SEQ_CFG=aceroot/verif/tb/hqm/hqm_pcie_lib/cft/hqm_range_B1_timeout_cfg_aer_severity_set.cft +DM_VPA_ERROR_TEST\",\n\t\t\t\t\"+HQM_SEQ_CFG_USER_DATA=aceroot/verif/tb/hqm/tests/$cft_str\",\n\t\t\t\t\"+SLA_MAX_CONFIG_PHASE_TIMEOUT=3000000000 +SLA_MAX_USER_DATA_PHASE_TIMEOUT=3000000000\",\n\t\t\t\t\" +expect_completion_timeout +msix_vector=0 +HQM_LSP_CQ_QID_CFG_CHECK_DIS +UNWANTED_TXN\",\n\t\t\t\t\"+HQM_SYSTEM_CONTINUE_ON_CTO +eot_vf$i +pcie_ct +pcie_anfes +pcie_fed +pcie_ced\",";
       print "\t\t$test_str => {\n"; 
       print "\t\t\t-simv_args => [ $simv_args \n\t\t\t],\n\t\t},\n";
    }

