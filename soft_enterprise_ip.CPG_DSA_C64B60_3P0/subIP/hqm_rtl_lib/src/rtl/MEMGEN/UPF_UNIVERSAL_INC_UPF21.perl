#!/usr/bin/perl 

##USAGE RAMGEN.perl <list> <all_errors>

$MODULE = shift;

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

open UPF_OUT, ">${MODULE}_upf.cfg";

print UPF_OUT "if \{\[info exists __SIM\] \&\& \!\$__SIM\} \{\n";
print UPF_OUT "\} else \{\n";

if ($MODULE =~ /_list_sel_/) {
    $PAR_PATH   = "PAR_HQM_LIST_SEL_PIPE_PATH";
    $PAR_SUFFIX = "_plsp";
} elsif ($MODULE =~ /_qed_/) {
    $PAR_PATH   = "PAR_HQM_QED_PIPE_PATH";
    $PAR_SUFFIX = "_pqed";
} elsif ($MODULE =~ /_system_/) {
    $PAR_PATH   = "PAR_HQM_SYSTEM_PATH";
    $PAR_SUFFIX = "_psys";
} else {
    die "\nUnknown MODULE argument: $MODULE\n\n";
}

foreach $_cont ( sort {$a cmp $b} keys %{$MEM_hash{$MODULE}} ) {
        foreach $_inst ( sort {$a cmp $b} keys %{$MEM_hash{$MODULE}{$_cont}} ) {

                 $hip =      $MEM_hash{$MODULE}{$_cont}{$_inst}{hip}[0];

                 $inst_mem = $MEM_hash{$MODULE}{$_cont}{$_inst}{upf_up_path}[0];
                 $inst_mem=~s/\./\//g;
                 $inst_mem=~s/mswt_mode_00_ram_sequential\/array/mswt_mode_00_ram_sequential\.array/g;

                 if ($hip =~ /${sram_hpc_prefix}/) {
                   print UPF_OUT "load_upf \"\$\{SSA_UPF_BASE\}\/subip\/hip\/${hip}\/tools\/upf\/${hip}.upf\" -scope \"${inst_mem}\"\n";
                 } elsif ($hip =~ /${rf_prefix}/) {
                   print UPF_OUT "load_upf \"\$\{RF_UPF_BASE\}\/subip\/hip\/${hip}\/tools\/upf\/${hip}.upf\" -scope \"${inst_mem}\"\n";
                 } elsif ($hip =~ /${bcam_prefix}/) {
                   print UPF_OUT "load_upf \"\$\{BCAM_UPF_BASE\}\/subip\/hip\/${hip}\/tools\/upf\/${hip}.upf\" -scope \"${inst_mem}\"\n";
                 } else {
                   print "FATAL\n";
                 }
        }
}

print UPF_OUT "}\n";

foreach $_cont ( sort {$a cmp $b} keys %{$MEM_hash{$MODULE}} ) {
        foreach $_inst ( sort {$a cmp $b} keys %{$MEM_hash{$MODULE}{$_cont}} ) {
                 $hip =      $MEM_hash{$MODULE}{$_cont}{$_inst}{hip}[0];

                 $inst_mem = $MEM_hash{$MODULE}{$_cont}{$_inst}{upf_up_path}[0];
                 $inst_mem=~s/\./\//g;
                 $inst_mem=~s/mswt_mode_00_ram_sequential\/array/mswt_mode_00_ram_sequential\.array/g;

                 if ($hip =~ /${sram_hpc_prefix}/) {
                   print UPF_OUT "connect_supply_net \"ss_vcccfn\.power\"  -ports \"${inst_mem}\/${sram_power_pin}\"\n";
                   print UPF_OUT "connect_supply_net \"ss_vcccfn\.ground\" -ports \"${inst_mem}\/${sram_ground_pin}\"\n";
                 } elsif ($hip =~ /${rf_prefix}/) {
                   print UPF_OUT "connect_supply_net \"ss_vcccfn\.power\"  -ports \"${inst_mem}\/${rf_power_pin}\"\n";
                   print UPF_OUT "connect_supply_net \"ss_vcccfn\.ground\" -ports \"${inst_mem}\/${rf_ground_pin}\"\n";
                 } elsif ($hip =~ /${bcam_prefix}/) {
                   print UPF_OUT "connect_supply_net \"ss_vcccfn\.power\"  -ports \"${inst_mem}\/${bcam_power_pin}\"\n";
                   print UPF_OUT "connect_supply_net \"ss_vcccfn\.ground\" -ports \"${inst_mem}\/${bcam_ground_pin}\"\n";
                 } else {
                   print UPF_OUT "FATAL\n";
                 }
        }
}


print UPF_OUT "\n";

print UPF_OUT "if \{\!\$__SIM \&\& \!\$__FEV\} \{\n";

foreach $_cont ( sort {$a cmp $b} keys %{$MEM_hash{$MODULE}} ) {
        foreach $_inst ( sort {$a cmp $b} keys %{$MEM_hash{$MODULE}{$_cont}} ) {

                 $hip =      $MEM_hash{$MODULE}{$_cont}{$_inst}{hip}[0];
                 $gated =      $MEM_hash{$MODULE}{$_cont}{$_inst}{gated}[0];

                 $inst_mem = $MEM_hash{$MODULE}{$_cont}{$_inst}{upf_up_path}[0];
                 $inst_mem=~s/\./\//g;
                 $inst_mem=~s/mswt_mode_00_ram_sequential\/array/mswt_mode_00_ram_sequential\.array/g;

                 if ($gated == 0) {
                 } else {
                 if ($hip =~ /${sram_hpc_prefix}/) {
                   print UPF_OUT "connect_supply_net \"ss_vcccfn_gated_virtual\.power\" -ports \"${inst_mem}\/${sram_gated_power_supply}\"\n";
                 } elsif ($hip =~ /${rf_prefix}/) {
                   print UPF_OUT "connect_supply_net \"ss_vcccfn_gated_virtual\.power\" -ports \"${inst_mem}\/${rf_gated_power_supply}\"\n";
                 } elsif ($hip =~ /${bcam_prefix}/) {
                 } else {
                   print UPF_OUT "FATAL\n";
                 }
                 }
        }
}

print UPF_OUT "}\n";

