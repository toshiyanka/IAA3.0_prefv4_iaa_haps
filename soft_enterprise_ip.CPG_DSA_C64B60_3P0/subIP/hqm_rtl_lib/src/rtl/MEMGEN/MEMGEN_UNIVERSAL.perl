#!/usr/bin/perl 

##USAGE MEM_CFG_GEN.perl <module>

$module = shift;

for $file ("../../../subIP/sip/AW/src/rtl/AWGEN_HQMV3/BCAM.def",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

for $file ("MEM_SOLUTION_CFG.hash.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

for $file ("../../../subIP/sip/AW/src/rtl/AWGEN_HQMV3/AW_SOLUTION.hash.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

open OUTFILE, ">MEM_UNIVERSAL.hash.txt";

## Generating mbist container level

    foreach $_module ( sort {$a cmp $b} keys %MEM_CFG_HASH ) {
      foreach $_bclk ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}} ) {
        foreach $_type ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}} ) {

           $container = "${_module}_${_bclk}_${_type}_cont";

           foreach $_name ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}{$_type}} ) {


               if ($_type =~ /rf/) {
                   $inst_name = "i_rf_${_name}";
               }

               if ($_type =~ /sram/) {
                   $inst_name = "i_sr_${_name}";
               }

               if ($_type =~ /bcam/) {
                   $inst_name = "i_${_name}";
               }

               $wrapper = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{base_wrapper}[0];

               $hip = $AW_hash{$wrapper}{hip}[0];
               $gated = $AW_hash{$wrapper}{gated}[0];

               for ($i=0;$i<@{$AW_hash{${wrapper}}{instance}};$i++) {

                   $dfx_wrapper_instance = $AW_hash{$wrapper}{instance}[$i];
                   $func_inst = "${inst_name}.${dfx_wrapper_instance}";

                   if ($wrapper =~ /hqm_AW_bcam/) {
                      $phys_inst = "${inst_name}.${dfx_wrapper_instance}.mswt_mode_00_ram_sequential.array";
                   } else {
                      $phys_inst = "${inst_name}.${dfx_wrapper_instance}.${hip}_upf_wrapper.${hip}";
                   }

                   #### Determine MBIST Container and instance_path

                   print OUTFILE "push(\@\{\$MEM_hash\{${container}\}\{${container}\}\{\"$func_inst\"\}\{hip_path\}\},\"${phys_inst}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${container}\}\{${container}\}\{\"$func_inst\"\}\{dfx_path\}\},\"${func_inst}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${container}\}\{${container}\}\{\"$func_inst\"\}\{hip\}\},\"${hip}\")\;\n";

                   #### Corekit and instance_path

                   $block_prefix = "i_${container}";

                   $ck_func_instance = "${block_prefix}\.${func_inst}";
                   $ck_phys_instance = "${block_prefix}\.${phys_inst}";

                   print OUTFILE "push(\@\{\$MEM_hash\{${_module}\}\{${container}\}\{\"$func_inst\"\}\{hip_path\}\},\"${ck_phys_instance}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${_module}\}\{${container}\}\{\"$func_inst\"\}\{dfx_path\}\},\"${ck_func_instance}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${_module}\}\{${container}\}\{\"$func_inst\"\}\{hip\}\},\"${hip}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${_module}\}\{${container}\}\{\"$func_inst\"\}\{gated\}\},\"${gated}\")\;\n";

                   #### Partition

                   if ($_module eq "hqm_qed_mem" ) {
                      $partition = "par_hqm_qed_pipe";
                   } elsif ( $_module eq "hqm_list_sel_mem" ) {
                      $partition = "par_hqm_list_sel_pipe";
                   } elsif ( $_module eq "hqm_system_mem" ) {
                      $partition = "par_hqm_system";
                   }
                      $block_prefix = "i_${_module}";

                   $par_func_instance = "${block_prefix}\.${ck_func_instance}";
                   $par_phys_instance = "${block_prefix}\.${ck_phys_instance}";

                   print OUTFILE "push(\@\{\$MEM_hash\{${_module}\}\{${container}\}\{\"$func_inst\"\}\{upf_up_path\}\},\"${par_phys_instance}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${partition}\}\{${container}\}\{\"$func_inst\"\}\{hip_path\}\},\"${par_phys_instance}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${partition}\}\{${container}\}\{\"$func_inst\"\}\{dfx_path\}\},\"${par_func_instance}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{${partition}\}\{${container}\}\{\"$func_inst\"\}\{hip\}\},\"${hip}\")\;\n";

                   #### HQM LEVEL

                   if ($_module eq "hqm_qed_mem" ) {
                      $block_prefix = "par_hqm_qed_pipe";
                   } elsif ( $_module eq "hqm_list_sel_mem" ) {
                      $block_prefix = "par_hqm_list_sel_pipe";
                   } elsif ( $_module eq "hqm_system_mem" ) {
                      $block_prefix = "par_hqm_system";
                   }

                   $top_func_instance = "${block_prefix}\.${par_func_instance}";
                   $top_phys_instance = "${block_prefix}\.${par_phys_instance}";

                   print OUTFILE "push(\@\{\$MEM_hash\{hqm\}\{${container}\}\{\"$func_inst\"\}\{hip_path\}\},\"${top_phys_instance}\")\;\n";
                   print OUTFILE "push(\@\{\$MEM_hash\{hqm\}\{${container}\}\{\"$func_inst\"\}\{dfx_path\}\},\"${top_func_instance}\")\;\n";

                   print OUTFILE "push(\@\{\$MEM_hash\{hqm\}\{${container}\}\{\"$func_inst\"\}\{hip\}\},\"${hip}\")\;\n";

      ##### HQM_TB or full level

      $block_prefix = "hqm";

      $tb_func_instance = "${block_prefix}\.${top_func_instance}";
      $tb_phys_instance = "${block_prefix}\.${top_phys_instance}";

      print OUTFILE "push(\@\{\$MEM_hash\{hqm_tb\}\{${container}\}\{\"$func_inst\"\}\{hip_path\}\},\"${tb_phys_instance}\")\;\n";
      print OUTFILE "push(\@\{\$MEM_hash\{hqm_tb\}\{${container}\}\{\"$func_inst\"\}\{dfx_path\}\},\"${tb_func_instance}\")\;\n";
      print OUTFILE "push(\@\{\$MEM_hash\{hqm_tb\}\{${container}\}\{\"$func_inst\"\}\{hip\}\},\"${hip}\")\;\n";
      print OUTFILE "push(\@\{\$MEM_hash\{hqm_tb\}\{${container}\}\{\"$func_inst\"\}\{gated\}\},\"${gated}\")\;\n";

               }
           }
        }
    }
}

