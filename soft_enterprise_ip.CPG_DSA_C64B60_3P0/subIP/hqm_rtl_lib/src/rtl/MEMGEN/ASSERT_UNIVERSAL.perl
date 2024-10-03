#!/usr/bin/perl 

##USAGE RAMGEN.perl <list> <all_errors>

for $file ("MEM_UNIVERSAL.hash.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

for $file ("GLOBAL_VARS.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }


open TB_TOP, "<../../../src/rtl/bind_dir/hqm_assert.sv";

open OUT_FINAL, ">hqm_assert.edited.sv";

$original_tb_config_file_content = 1;

while (<TB_TOP>) {

if ($_ =~ /mem_fet_en_b connection ring START/) {
$original_tb_config_file_content = 0;
print OUT_FINAL "\/\/mem_fet_en_b connection ring START\n";

$CNT  = 0;
$CLK  = "\`HQM_SIF_PATH\.prim_freerun_clk";
$RST  = "\`HQM_SIF_PATH\.prim_gated_rst_b";
$PMU  = "\`HQM_MASTER_PATH\.i_hqm_master_core\.i_hqm_pm_unit";
$PMUO = "pgcb_fet_en_b";
$PMUI = "pgcb_fet_en_ack_b";

$SRC  = "${PMU}.${PMUO}";
$DST  = "${PMU}.${PMUI}";
print OUT_FINAL "`HQM_SDG_ASSERTS_FORBIDDEN( PGCB_MEM_FET_EN_${CNT}, ($SRC != $DST), $CLK, $RST, `HQM_SVA_ERR_MSG(\"PGCB_MEM_FET_EN_${CNT} $DST Not Connected\"), SDG_SVA_SOC_SIM) \;\n";
print OUT_FINAL "`ifndef HQM_7NM\n";
$CNT=$CNT+1;

foreach $_cont ( sort {$a cmp $b} keys %{$MEM_hash{hqm_tb}} ) {
        foreach $_inst ( sort {$a cmp $b} keys %{$MEM_hash{hqm_tb}{$_cont}} ) {
                 $hip =      $MEM_hash{hqm_tb}{$_cont}{$_inst}{hip}[0];
                 $gated =      $MEM_hash{hqm_tb}{$_cont}{$_inst}{gated}[0];
                 $inst_mem = $MEM_hash{hqm_tb}{$_cont}{$_inst}{dfx_path}[0];

                 $inst_mem=~s/hqm\.par_hqm_system\.i_hqm_system_mem/\`HQM_SYSTEM_MEM_PATH/g;
                 $inst_mem=~s/hqm\.par_hqm_list_sel_pipe\.i_hqm_list_sel_mem/\`HQM_LIST_SEL_MEM_PATH/g;
                 $inst_mem=~s/hqm\.par_hqm_qed_pipe\.i_hqm_qed_mem/\`HQM_QED_MEM_PATH/g;

                 if ($gated == 0) {
                 } else {
                 if ($hip =~ /${sram_hpc_prefix}/) {
                    $RAM  = ${inst_mem};
                    $RAMO = "PWR_MGMT_OUT";
                    $DST  = "${RAM}.${RAMO}";
                    print OUT_FINAL "`HQM_SDG_ASSERTS_FORBIDDEN( PGCB_MEM_FET_EN_${CNT}, ($SRC != $DST), $CLK, $RST, `HQM_SVA_ERR_MSG(\"PGCB_MEM_FET_EN_${CNT} $DST Not Connected\"), SDG_SVA_SOC_SIM) \;\n"; 
                    $CNT=$CNT+1;
                 } elsif ($hip =~ /${rf_prefix}/) {
                    $RAM  = ${inst_mem};
                    $RAMO = "PWR_MGMT_OUT";
                    $DST  = "${RAM}.${RAMO}";
                    print OUT_FINAL "`HQM_SDG_ASSERTS_FORBIDDEN( PGCB_MEM_FET_EN_${CNT}, ($SRC != $DST), $CLK, $RST, `HQM_SVA_ERR_MSG(\"PGCB_MEM_FET_EN_${CNT} $DST Not Connected\"), SDG_SVA_SOC_SIM) \;\n"; 
                    $CNT=$CNT+1;
                 } elsif ($hip =~ /${bcam_prefix}/) {
                 } else {
                   die "\n***ERROR: Didn't find prefix for: $hip !!!\n\n";
                 }
                 }
        }
}

print OUT_FINAL "`endif\n";
print OUT_FINAL "\/\/mem_fet_en_b connection ring END\n";

}

if ($original_tb_config_file_content  == 1) {
   print OUT_FINAL "$_";
}

if ($_ =~ /mem_fet_en_b connection ring END/) {
$original_tb_config_file_content = 1;
}

}
