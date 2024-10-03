#!/usr/intel/bin/perl -w

$ifile="../../../../../../doc/hqmv3_array_list.csv";

open(IFILE,"<$ifile") || die "\n***ERROR: Couldn't open input file: $ifile !!!\n\n";
@ifile=<IFILE>;
close(IFILE);

###########################################################################################
# Create scripts to generate the appropriate memory AW wrapper types
# This is essentially the logical to physical mapping step

$rffile="AWGEN.HQMV3.rf.scr";
$srfile="AWGEN.HQMV3.sr.scr";

open(RFFILE,">$rffile") || die "\n***ERROR: Couldn't open output file: $rffile !!!\n\n";
open(SRFILE,">$srfile") || die "\n***ERROR: Couldn't open output file: $srfile !!!\n\n";

for ($i=0; $i<=$#ifile; $i++) {
 $l=$ifile[$i];
 next if ($l=~/^\s*#/);
 chomp($l);
 @f=split(/,/, $l);
 $type=$f[0];
 $awname=$f[2];
 $depth=$f[3];
 $width=$f[4];
 $rclk=$f[5];
 $wclk=$f[6];
 $pg=$f[7];

 if ($type =~ /regfile/) {

  $mtype="hqm_AW_rf";
  if ($pg) {
   if ($rclk eq $wclk) {$mtype.="_pg";} else {$mtype.="_dc_pg";}
  } else {
   if ($rclk ne $wclk) {$mtype.="_dc";}
  }
  $mdepth=$depth; $ndepth=1; while ($mdepth>1024) {$mdepth=$mdepth>>1; $ndepth=$ndepth<<1;}
  $mwidth=$width; $nwidth=1; while ($mwidth>198) {$mwidth=($mwidth+1)>>1; $nwidth=$nwidth<<1;}
  if ($mwidth%2) {$mwidth++;}
  if ($mwidth<8) {$mwidth=8;}
  $mname="hqm_ip764hd2prf${mdepth}x${mwidth}s0r2p${pg}";
  push(@rffile, sprintf "AW_rf.CMO_1276.4.perl %5d %4d %-15s %2d %2d %s\n",
    $depth, $width, $mtype, $ndepth, $nwidth, $mname);
  $hips{$mname}=1;
  $AWs{$awname}=1;

 } elsif ($type =~ /sram/) {

  $mtype="hqm_AW_sram_pg";
  $mdepth=$depth; $ndepth=1; while ($mdepth>4096) {$mdepth=$mdepth>>1; $ndepth=$ndepth<<1;}
  $mwidth=$width; $nwidth=1; while ($mwidth>100) {$mwidth=($mwidth+1)>>1; $nwidth=$nwidth<<1;}
  $mux=4; if ($mdepth == 4096) {$mux=8;}
  $mname="hqm_ip764hduspsr${mdepth}x${mwidth}m${mux}b2s0r2p1d0";
  push(@srfile, sprintf "AW_sr.CMO_1276.4.perl %5d %4d %-15s %2d %2d %s\n",
    $depth, $width, $mtype, $ndepth, $nwidth, $mname);
  $hips{$mname}=1;
  $AWs{$awname}=1;

 } else {

  printf "***No code for the following:\n$l\n\n";

 }

}

print RFFILE @rffile;
print SRFILE @srfile;

close(RFFILE);
close(SRFILE);

system("sort -k2,2n -k3,3n -u $rffile >${rffile}.tmp; mv ${rffile}.tmp $rffile; chmod 755 $rffile");
system("sort -k2,2n -k3,3n -u $srfile >${srfile}.tmp; mv ${srfile}.tmp $srfile; chmod 755 $srfile");

printf "Created ./$rffile\n";
printf "Created ./$srfile\n";

###########################################################################################
# Create the rtl.f for the memory solution

$filet="rtl.f";
$fileo="$ENV{WORKAREA}/subIP/sip/hqm_memory_solution/filelists/rtl.f";

open(FILET,">$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

printf  FILET "\$ip/src/rtl/hqm_mem_ctech_map.sv\n";
printf  FILET "\$ip/src/rtl/hqm_mem_reset_sync_scan.sv\n";
foreach $hip (sort keys(%hips)) {
 printf FILET "\$WORKAREA/subip/hip/${hip}/src/rtl/${hip}_dfx_wrapper.sv\n";
}

# Hardcoding bcam for now...

printf FILET "\
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_bcam_mbist_inhandler.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_bcam_mbist_outhandler.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_ctech_simple_rtl_timing_override.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_ctech_sync_mux.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_ctech_sync_rstb.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_ctech_sync_setb.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_latch_p.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_latch_phase_b.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_map.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_msff_phase_a.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_swt_obs_ff_phase_a.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_swt_obs_ff_phase_b.sv
\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl/srf026b256e1r1w1cbbeheaa0aaw_dfx_wrapper.sv
+incdir+\$WORKAREA/subip/hip/srf026b256e1r1w1cbbeheaa0aaw/src/rtl
\$ip/src/rtl/hqm_list_sel_mem_AW_bcam_2048x26.sv
";

foreach $AW (sort keys(%AWs)) {
 printf FILET "\$ip/src/rtl/${AW}.sv\n";
}

printf FILET "\$ip/src/rtl/hqm_list_sel_mem_hqm_clk_bcam_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_list_sel_mem_hqm_clk_rf_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_list_sel_mem_hqm_clk_sram_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_qed_mem_hqm_clk_rf_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_qed_mem_hqm_clk_sram_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_system_mem_hqm_clk_rf_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_system_mem_hqm_clk_sram_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_system_mem_pgcb_clk_rf_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_system_mem_prim_clk_rf_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_system_mem_prim_clk_rf_dc_pg_cont.sv\n";
printf FILET "\$ip/src/rtl/hqm_list_sel_mem.sv\n";
printf FILET "\$ip/src/rtl/hqm_qed_mem.sv\n";
printf FILET "\$ip/src/rtl/hqm_system_mem.sv\n";

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.hip.list

$filet="hqm.hip.list";
$fileo="$ENV{WORKAREA}/filelists/hqm.hip.list";

open(FILET,">$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 printf FILET "%-40s %s\n", "${hip},", "subIP/hip/${hip}";
}

printf FILET "%-40s %s\n", "srf026b256e1r1w1cbbeheaa0aaw,", "subIP/hip/srf026b256e1r1w1cbbeheaa0aaw";

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.xprop file

$filet="hqm.xprop";
$fileo="$ENV{WORKAREA}/verif/vcsmpp/hqm.xprop";

system("/bin/cp $fileo ./$filet; sed -i -e '/RAMGEN/d' -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 printf FILET "tree %-40s { xpropOff };\n", "{${hip}}";
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.congruency file

$filet="hqm.congruency";
$fileo="$ENV{WORKAREA}/verif/vcsmpp/hqm.congruency";

system("/bin/cp $fileo ./$filet; sed -i -e '/RAMGEN/d' -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 printf FILET "-moduletree ${hip}\n";
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.sgdc file

$filet="hqm.sgdft.sgdc";
$fileo="$ENV{WORKAREA}/static/sgdft/inputs/constraints/hqm.sgdc";

system("/bin/cp $fileo ./$filet; sed -i -e '/for RFs/d' -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

printf FILET "// no_scan, no_fault, scan_wrap for RFs and SRAMs\n"; 
foreach $hip (sort keys(%hips)) {
 printf FILET "no_scan   -name \"${hip}\"\n";
}
foreach $hip (sort keys(%hips)) {
 printf FILET "no_fault  -name \"${hip}\"\n";
}
foreach $hip (sort keys(%hips)) {
 printf FILET "scan_wrap -name \"${hip}\"\n";
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.sgdft.liblist file

$filet="hqm.sgdft.liblist";
$fileo="$ENV{WORKAREA}/static/sgdft/hqm.sgdft.liblist";

system("/bin/cp $fileo ./$filet; sed -i -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 if ($hip =~ /hd2prf/) {
  printf FILET "\$WORKAREA/subip/hip/${hip}/timing/${hip}_tttt_0.65v_-40c.lib\n";
 } elsif ($hip =~ /hduspsr/) {
  printf FILET "\$WORKAREA/subip/hip/${hip}/timing/${hip}_tttt_0.65v_0.65v_-40c.lib\n";
 }
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.fishtail.liblist file

$filet="hqm.fishtail.liblist";
$fileo="$ENV{WORKAREA}/static/fishtail/hqm.fishtail.liblist";

system("/bin/cp $fileo ./$filet; sed -i -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 if ($hip =~ /hd2prf/) {
  printf FILET "\$WORKAREA/subip/hip/${hip}/timing/${hip}_tttt_0.65v_-40c.lib\n";
 } elsif ($hip =~ /hduspsr/) {
  printf FILET "\$WORKAREA/subip/hip/${hip}/timing/${hip}_tttt_0.65v_0.65v_-40c.lib\n";
 }
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the hqm.vclp.liblist file

$filet="hqm.vclp.liblist";
$fileo="$ENV{WORKAREA}/static/vclp/hqm.vclp.liblist";

system("/bin/cp $fileo ./$filet; sed -i -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 if ($hip =~ /hd2prf/) {
  printf FILET "\$WORKAREA/subip/hip/${hip}/timing/${hip}_tttt_0.65v_-40c.ldb\n";
 } elsif ($hip =~ /hduspsr/) {
  printf FILET "\$WORKAREA/subip/hip/${hip}/timing/${hip}_tttt_0.65v_0.65v_-40c.ldb\n";
 }
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

###########################################################################################
# Create the stop_hip file

$filet="stop_hip.tcl";
$fileo="$ENV{WORKAREA}/static/sglint/inputs/stop_hip.tcl";

system("/bin/cp $fileo ./$filet; sed -i -e '/hqm_ip7[46]/d' $filet");
open(FILET,">>$filet") || die "\n***ERROR: Couldn't open output file: $filet !!!\n\n";

foreach $hip (sort keys(%hips)) {
 printf FILET "set_option stop ${hip}_dfx_wrapper\n";
}

close(FILET);

rename("./$filet", "$fileo") ||
die "\n***ERROR: Couldn't rename $filet to $fileo !!!\n\n";

printf "Created $fileo\n";

printf "\n";
