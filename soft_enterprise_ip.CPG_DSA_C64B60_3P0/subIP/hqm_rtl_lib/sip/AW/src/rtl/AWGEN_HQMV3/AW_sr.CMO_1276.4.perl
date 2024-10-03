#!/usr/intel/bin/perl -w

#  -----------------------------------------------------------------------------------------------------
#                                Copyright (c) Intel Corporation, 2022
#                                        All rights reserved.
#
#  -----------------------------------------------------------------------------------------------------
#
#   File Name:     AW_hpc.CMO_1274d3.perl
#   Created by:    Keith Christman
#
# -----------------------------------------------------------------------------------------------------
#
#   This program takes 7 input arguments and creates a wrapper file
#   containing the rtl and instantiations for the desired asacram memory configuration.
#   It can handle single instance and an array {y(depth) & x(width)} of instances
#   to generate larger memories. Max memory array size is 16x16.
#
#   input arguments:
#        depth data prefix sr_number_y sr_number_x sr_memory
#
#   output file:
#         output file naming convention: <outfile>.sv = <prefix>_<depth>x<data>.sv
#
#
#   Usage Examples:
#         sr.array.intel10nm.perl 1024 20 AW_sabram_rw 1 1 ip743srmbdhd1024x20m4k2r2c1 0
#         sr.array.intel10nm.perl 1024 20 AW_sabram_bw_rw 1 1 ip743srmbdhd1024x20m4k2r2c1 1
#         sr.array.intel10nm.perl 2048 40 AW_sabram_byw_rw 2 5 ip743srmbdhd1024x8m4k2r2c1 2
#
#

############################################################
## SUBROUTINES
############################################################

sub log2 {
        my $n = shift;
        return log($n)/log(2);
}

sub ceil {
        my $n = shift;
        return int($n + 0.999999999);
}

############################################################
## FILE GENERATION CODE STARTS HERE
############################################################

if (($ARGV[0] eq "") || ($ARGV[1] eq "") || ($ARGV[2] eq "") || ($ARGV[3] eq "") || ($ARGV[4] eq "") || ($ARGV[5] eq "")) {
        print "  Usage: sr_array.intel10nm.perl <depth> <data> <prefix> <sr_number_y> <sr_number_x> <sr_mem>\n";
        print "  Example 1: sr.array.intel10nm.perl 1024 19 AW_sabram_rw 1 1 ip743srmbdhd1024x20m4k2r2c1 0\n";
        print "  Example 2: sr.array.intel10nm.perl 2048 64 AW_sabram_bw_rw 2 4 ip743srmbdhd1024x16m4k2r2c1 1\n";
        print "  Example 3: sr.array.intel10nm.perl 1024 512 AW_sabram_rw 16 16 ip743srmbdhd64x32m4k2r2c1 0\n";
        die "Failed Script Execution.\n\n";
}

$depth       = $ARGV[0];
$data        = $ARGV[1];
$prefix      = $ARGV[2];
$sr_number_y = $ARGV[3];
$sr_number_x = $ARGV[4];
$sr_memory   = $ARGV[5];

$error_flag  = 0;

$total_memory_cnt = $sr_number_y * $sr_number_x;

$address = ceil(log2($depth));

for $file ("../../../../../../src/rtl/MEMGEN/GLOBAL_VARS.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

################################################

if (! -r "../../../../../hip/${sr_memory}/doc/${sr_memory}_tttt_0.65v_0.65v_100c_datasheet.txt") {
 die "\nERROR: Couldn't find memory datasheet for ${sr_memory}; check CMO delivery inventory!!!\n\n";
}

if ((! -r "../../../../../hip/${sr_memory}/timing/${sr_memory}_tttt_0.65v_0.65v_100c.max.lib") &&
    (! -r "../../../../../hip/${sr_memory}/timing/${sr_memory}_tttt_0.65v_0.65v_100c.lib")) {
 die "\nERROR: Couldn't find memory lib for ${sr_memory}; check CMO delivery inventory!!!\n\n";
}

################################################
## CHECK PARAMETERS
################################################

$pg_option = ($sr_memory =~ /p1d0$/) ? 1 : 0;

$sr_memory =~ m/(\d+)x(\d+)/;
$sr_name_depth = $1;
$sr_name_width = $2;
$total_depth = $sr_number_y * $sr_name_depth;
$total_width = $sr_number_x * $sr_name_width;
if ($debug) {print "sr_name_depth=$sr_name_depth sr_name_width=$sr_name_width total_depth=$total_depth total_width=$total_width\n";}
$sr_name_address = ceil(log2($sr_name_depth));
$addr_decode = $address - $sr_name_address;
$sr_name_address_log = log2($sr_name_depth);
if ($debug) {print "sr_name_address=$sr_name_address addr_decode=$addr_decode sr_name_address_log=$sr_name_address_log\n";}

if ($sr_number_y > 1) {
  if ( $sr_name_address_log != $sr_name_address) {
    print "WARNING: sr_name_depth is not a power of 2! Unused addr space in sr memory inst array components.\n";
  }
}

$data_pad = $total_width - $data;

$total_address = ceil(log2($total_depth));
$addr_pad = $total_address - $address;

# x_index refers to memory depth segments
# y_index refers to memory width (bit IO) segments

if ($sr_number_x > 16) {
  print "***ERROR: Bad value for sr_number_x (valid is 1-16)! ${sr_number_x}\n";
  $error_flag = 1;
}

if ($sr_number_y > 16) {
  print "***ERROR: Bad value for sr_number_y (valid is 1-16)! ${sr_number_y}\n";
  $error_flag = 1;
}

if (($sr_number_x == 1) || ($sr_number_x > 1) && ($addr_pad == 0)) {
} else {
  print "***ERROR: Bad combo values for sr_number_x & addr_pad! ${sr_number_x}  ${addr_pad}\n";
  $error_flag = 1;
}

if ($data_pad >= $sr_name_width) {
  print "***ERROR: Bad combo values for data_pad & sr_name_width! ${data_pad}  ${sr_name_width}\n";
  $error_flag = 1;
}

if ( $total_depth >= $depth ) {
  if ( $total_depth > $depth ) {
    print "WARNING: Size is too deep $total_depth ${depth}x${total_width}\n";
  }
} else {
  print "***ERROR: Depth of ram array is too small! ${total_depth}\n";
  $error_flag = 1;
}

if ( $total_width >= $data ) {
  if ( $total_width > $data ) {
    print "WARNING: Size is too wide $total_width ${depth}x${total_width}\n";
  }
} else {
  print "***ERROR: Width of ram array is too small! ${total_width}\n";
  $error_flag = 1;
}

if ($error_flag == 1) {
  print "\n***ATTENTION: ERRORS FOUND!\n\n";
  exit;
}

if ($debug) {print "addr_pad: ${addr_pad}    data_pad: ${data_pad}\n";}

################################################

$outfile = "${prefix}_${depth}x${data}";
open OUTFILE, ">${outfile}.sv";

open TB_BUILD_TEMP, "<VCS/build_sr_temp";
open TB_BUILD_OUT, ">VCS/build_${outfile}";

while (<TB_BUILD_TEMP>) {

   if ($_ =~ /Insert CMO Start/) {
      print TB_BUILD_OUT "-y \$WORKAREA/subip/hip/${sr_memory}/src/rtl \\\n";
      print TB_BUILD_OUT "   \$WORKAREA/subip/hip/${sr_memory}/src/rtl/${sr_memory}_dfx_wrapper.sv \\\n";
      print TB_BUILD_OUT "   \$WORKAREA/subip/hip/${sr_memory}/src/rtl/${sr_memory}.sv \\\n";
   } elsif ($_ =~ /Insert TB/) {
      print TB_BUILD_OUT "${outfile}_tb.sv \\\n";
   } else {
      print TB_BUILD_OUT "$_";
   }
}

open TB_TEMP, "<VCS/sr_temp.sv";
open TB_OUT, ">VCS/${outfile}_tb.sv";

while (<TB_TEMP>) {

   if ($_ =~ /KAC-begin param/) {
      print  TB_OUT "localparam DEPTH   = ${depth};\n";
      print  TB_OUT "localparam DEPTHB2 = ${address};\n";
      print  TB_OUT "localparam WIDTH   = ${data};\n";
   } elsif ($_ =~ /KAC-begin inst/) {
      print  TB_OUT  "${outfile} i_dut (\n";
      print  TB_OUT  "     .clk                  (clk)\n";
      print  TB_OUT  "    ,.clk_rst_n            (1'b1)\n";
      print  TB_OUT  "    ,.addr                 (addr)\n";
      print  TB_OUT  "    ,.wdata                (wdata)\n";
      print  TB_OUT  "    ,.we                   (we)\n";
      print  TB_OUT  "    ,.re                   (re)\n\n";
      print  TB_OUT  "    ,.rdata                (rdata)\n\n";

      if ($pg_option == 1) {
       print TB_OUT  "    ,.pgcb_isol_en         (1'b0)\n";
       print TB_OUT  "    ,.pwr_enable_b_in      (1'b0)\n";
       print TB_OUT  "    ,.pwr_enable_b_out     ()\n\n";
      }

      print  TB_OUT  "    ,.ip_reset_b           (clk_rst_b)\n\n";
      print  TB_OUT  "    ,.fscan_byprst_b       ('1)\n";
      print  TB_OUT  "    ,.fscan_clkungate      ('0)\n";
      print  TB_OUT  "    ,.fscan_rstbypen       ('0)\n";
      print  TB_OUT  ");\n";
   } else {
      print  TB_OUT "$_";
   }

}
close TB_OUT;

open  REGRESS_OUT, ">>VCS/hqm_full_AW_regression";
print REGRESS_OUT "/bin/rm -Rf vc_hdrs.h simv csrc simv.daidir simv.vdb ucli.key DVEfiles dump.vpd\n";
print REGRESS_OUT "./build_${outfile} 2>&1 >> regression_model_build.log\n";
print REGRESS_OUT "./simv +ntb_random_seed=0 2>&1 >> regression_sim.log\n";
close REGRESS_OUT;

system "chmod 755 VCS/build_${outfile}";
system "chmod 755 VCS/hqm_full_AW_regression";

################################################
## OUTFILE HEADER
################################################

printf  OUTFILE "//-----------------------------------------------------------------------------------------------------\n";
printf  OUTFILE "// INTEL CONFIDENTIAL\n";
printf  OUTFILE "//\n";
printf  OUTFILE "// Copyright 2022 Intel Corporation All Rights Reserved.\n";
printf  OUTFILE "//\n";
printf  OUTFILE "// The source code contained or described herein and all documents related to the source code\n";
printf  OUTFILE "// (\"Material\") are owned by Intel Corporation or its suppliers or licensors. Title to the Material\n";
printf  OUTFILE "// remains with Intel Corporation or its suppliers and licensors. The Material contains trade\n";
printf  OUTFILE "// secrets and proprietary and confidential information of Intel or its suppliers and licensors.\n";
printf  OUTFILE "// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.\n";
printf  OUTFILE "// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,\n";
printf  OUTFILE "// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.\n";
printf  OUTFILE "//\n";
printf  OUTFILE "// No license under any patent, copyright, trade secret or other intellectual property right is\n";
printf  OUTFILE "// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by\n";
printf  OUTFILE "// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights\n";
printf  OUTFILE "// must be express and approved by Intel in writing.\n";
printf  OUTFILE "//\n";
printf  OUTFILE "//-----------------------------------------------------------------------------------------------------\n\n";

printf  OUTFILE "module $outfile (\n\n";

################################################
## OUTFILE MODULE IO PORTS
################################################

printf  OUTFILE "     input  logic              clk\n";
printf  OUTFILE "    ,input  logic              clk_rst_n\n";
printf  OUTFILE "    ,input  logic              re\n";
printf  OUTFILE "    ,input  logic              we\n";
printf  OUTFILE "    ,input  logic %-12s addr\n", "[${address}-1:0]";
printf  OUTFILE "    ,input  logic %-12s wdata\n\n", "[${data}-1:0]";
printf  OUTFILE "    ,output logic %-12s rdata\n\n", "[${data}-1:0]";

if ($pg_option == 1) {
 printf OUTFILE "    // PWR Interface\n\n";
 printf OUTFILE "    ,input  logic              pgcb_isol_en\n";
 printf OUTFILE "    ,input  logic              pwr_enable_b_in\n";
 printf OUTFILE "    ,output logic              pwr_enable_b_out\n\n";
}

printf  OUTFILE "    ,input  logic              ip_reset_b\n\n";
printf  OUTFILE "    ,input  logic              fscan_byprst_b\n";
printf  OUTFILE "    ,input  logic              fscan_clkungate\n";
printf  OUTFILE "    ,input  logic              fscan_rstbypen\n";

printf  OUTFILE ");\n\n";

###############################################

if  ($sr_number_y == 1 && $sr_number_x == 1) {
 printf OUTFILE "logic [${sr_name_width}-1:0] rdata_tdo;\n";
} elsif ($sr_number_y == 1 && $sr_number_x > 1) {
 printf OUTFILE "logic [${sr_name_width}*$total_memory_cnt-1:0] rdata_tdo;\n";
} elsif ($sr_number_y > 1 && $sr_number_x == 1) {
 for (my ${y_index}=0; ${y_index} <= (${sr_number_y}-1); ${y_index}++) {
  printf OUTFILE "logic [${sr_name_width}-1:0] rdata_tdo_${y_index};\n";
 }
} else {
 for (my ${y_index}=0; ${y_index} <= (${sr_number_y}-1); ${y_index}++) {
  printf OUTFILE "logic [${sr_name_width}*${sr_number_x}-1:0] data_tdo_${y_index};\n";
 }
}

printf  OUTFILE "\n";
printf  OUTFILE "logic ip_reset_b_sync;\n\n";
printf  OUTFILE "`ifndef INTEL_NO_PWR_PINS\n\n";
printf  OUTFILE "  `ifdef INTC_ADD_VSS\n\n";
printf  OUTFILE "     logic  dummy_vss;\n\n";
printf  OUTFILE "     assign dummy_vss = 1'b0;\n\n";
printf  OUTFILE "  `endif\n\n";
printf  OUTFILE "`endif\n\n";

printf  OUTFILE "hqm_mem_reset_sync_scan i_ip_reset_b_sync (\n\n";
printf  OUTFILE "     .clk                     (clk)\n";
printf  OUTFILE "    ,.rst_n                   (ip_reset_b)\n\n";
printf  OUTFILE "    ,.fscan_rstbypen          (fscan_rstbypen)\n";
printf  OUTFILE "    ,.fscan_byprst_b          (fscan_byprst_b)\n\n";
printf  OUTFILE "    ,.rst_n_sync              (ip_reset_b_sync)\n";
printf  OUTFILE ");\n\n";

################################################
## SINGLE SRAM
################################################

if (($sr_number_y == 1) && ($sr_number_x == 1)) {

  printf  OUTFILE "//*******************************************************************\n";
  printf  OUTFILE "// Hook up SINGLE SRAM\n";
  printf  OUTFILE "//*******************************************************************\n\n";
	
  printf  OUTFILE "${sr_memory}_dfx_wrapper i_sram (\n\n";

  printf  OUTFILE "     .FUNC_CLK_IN              (clk)\n";
  printf  OUTFILE "    ,.FUNC_RD_EN_IN            (re)\n";
  printf  OUTFILE "    ,.FUNC_WR_EN_IN            (we)\n";

  if ($addr_pad > 0) {
   printf OUTFILE "    ,.FUNC_ADDR_IN             ({${addr_pad}'b0, addr})\n";
  } else {
   printf OUTFILE "    ,.FUNC_ADDR_IN             (addr)\n";
  }

  if ($data_pad > 0) {
   printf OUTFILE "    ,.FUNC_WR_DATA_IN          ({${data_pad}'b0, wdata})\n\n";
  } else {
   printf OUTFILE "    ,.FUNC_WR_DATA_IN          (wdata)\n\n";
  }

  printf  OUTFILE "    ,.DATA_OUT                 (rdata_tdo)\n\n";

  printf  OUTFILE "    ,.IP_RESET_B               (ip_reset_b_sync)\n";
  printf  OUTFILE "    ,.OUTPUT_RESET             ('0)\n\n";

  printf  OUTFILE "    ,.ISOLATION_CONTROL_IN     (pgcb_isol_en)\n";
  if ($pg_option == 1) {
   printf OUTFILE "    ,.PWR_MGMT_IN              ({4'd0, pwr_enable_b_in, pwr_enable_b_in})\n";
   printf OUTFILE "    ,.PWR_MGMT_OUT             (pwr_enable_b_out)\n\n";
  } else {
   printf OUTFILE "    ,.PWR_MGMT_IN              ('0)\n";
   printf OUTFILE "    ,.PWR_MGMT_OUT             ()\n\n";
  }

  printf  OUTFILE "    ,.WRAPPER_CLK_EN           ('1)\n\n";

  printf  OUTFILE "    ,.COL_REPAIR_IN            ('0)\n";
  printf  OUTFILE "    ,.GLOBAL_RROW_EN_IN        ('0)\n";
  printf  OUTFILE "    ,.ROW_REPAIR_IN            ('0)\n";
  printf  OUTFILE "    ,.SLEEP_FUSE_IN            ('0)\n";
  printf  OUTFILE "    ,.TRIM_FUSE_IN             ('0)\n\n";

  printf  OUTFILE "    ,.ARRAY_FREEZE             ('0)\n\n";

  printf  OUTFILE "    ,.BIST_ENABLE              ('0)\n";
  printf  OUTFILE "    ,.BIST_ADDR_IN             ('0)\n";
  printf  OUTFILE "    ,.BIST_CLK_IN              ('0)\n";
  printf  OUTFILE "    ,.BIST_RD_EN_IN            ('0)\n";
  printf  OUTFILE "    ,.BIST_WR_DATA_IN          ('0)\n";
  printf  OUTFILE "    ,.BIST_WR_EN_IN            ('0)\n\n";

  printf  OUTFILE "    ,.FSCAN_CLKUNGATE          (fscan_clkungate)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_BYPSEL         ('0)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_INIT_EN        ('0)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_INIT_VAL       ('0)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_RDIS_B         ('1)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_WDIS_B         ('1)\n\n";

  printf  OUTFILE "`ifndef INTEL_NO_PWR_PINS\n\n";
  printf  OUTFILE "  `ifdef INTC_ADD_VSS\n\n";
  printf  OUTFILE "    ,.vss                      (dummy_vss)\n\n";
  printf  OUTFILE "  `endif\n\n";
  printf  OUTFILE "    ,.vccsoc_lv                ('1)\n";
  printf  OUTFILE "    ,.vccsocaon_lv             ('1)\n\n";
  printf  OUTFILE "`endif\n\n";

  printf  OUTFILE  ");\n\n";

  printf  OUTFILE "assign rdata = rdata_tdo[$data-1:0];\n\n";

} else {

  ################################################
  ## Hook up array of SRAMs
  ################################################

  printf  OUTFILE "//*******************************************************************\n";
  printf  OUTFILE "// Placeholder array of SRAMs\n";
  printf  OUTFILE "//*******************************************************************\n\n";

  if ($pg_option == 1) {
   printf OUTFILE "logic [$total_memory_cnt:0] pwr_mgmt_enable;\n\n";
   printf OUTFILE "assign pwr_mgmt_enable[0] = pwr_enable_b_in;\n\n";
  }

  if ($sr_number_y == 1) {
   printf OUTFILE "logic      WE_SEL;\n";
   printf OUTFILE "logic      RE_SEL;\n\n";
  } else {
   printf OUTFILE "logic [$sr_number_y-1:0] WE_SEL;\n";
   printf OUTFILE "logic [$sr_number_y-1:0] RE_SEL;\n";
   printf OUTFILE "logic [$sr_number_y-1:0] RE_SEL_reg;\n\n";
  }

  if ($sr_number_y == 1) {
   printf OUTFILE "assign WE_SEL = we;\n";
   printf OUTFILE "assign RE_SEL = re;\n\n";
  }

  if ($sr_number_y == 2) {
   printf OUTFILE "assign WE_SEL[1] =  addr[$address-1] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & we;\n";
   printf OUTFILE "assign RE_SEL[1] =  addr[$address-1] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & re;\n\n";
  }

  if ($sr_number_y == 3) {
   printf OUTFILE "assign WE_SEL[2] =  addr[$address-1] & ~addr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] &  addr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & we;\n";
   printf OUTFILE "assign RE_SEL[2] =  addr[$address-1] & ~addr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] &  addr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & re;\n\n";
  }

  if ($sr_number_y == 4) {
   printf OUTFILE "assign WE_SEL[3] =  addr[$address-1] &  addr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[2] =  addr[$address-1] & ~addr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] &  addr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & we;\n";
   printf OUTFILE "assign RE_SEL[3] =  addr[$address-1] &  addr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[2] =  addr[$address-1] & ~addr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] &  addr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & re;\n\n";
  }

  if ($sr_number_y == 5) {
   printf OUTFILE "assign WE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & re;\n\n";
  }

  if ($sr_number_y == 6) {
   printf OUTFILE "assign WE_SEL[5] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[5] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n\n";
  }

  if ($sr_number_y == 7) {
   printf OUTFILE "assign WE_SEL[6] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[5] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[6] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[5] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & re;\n\n";
  }

  if ($sr_number_y == 8) {
   printf OUTFILE "assign WE_SEL[7] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[6] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[5] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[7] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[6] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[5] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[4] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & re;\n\n";
  }

  if ($sr_number_y == 9) {
   printf OUTFILE "assign WE_SEL[8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 10) {
   printf OUTFILE "assign WE_SEL[9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 11) {
   printf OUTFILE "assign WE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 12) {
   printf OUTFILE "assign WE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 13) {
   printf OUTFILE "assign WE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 14) {
   printf OUTFILE "assign WE_SEL[13] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[13] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 15) {
   printf OUTFILE "assign WE_SEL[14] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[13] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[14] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[13] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y == 16) {
   printf OUTFILE "assign WE_SEL[15] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[14] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[13] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[15] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[14] =  addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[13] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[12] =  addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~addr[$address-1] &  addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~addr[$address-1] &  addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~addr[$address-1] & ~addr[$address-2] &  addr[$address-3] & ~addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] &  addr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~addr[$address-1] & ~addr[$address-2] & ~addr[$address-3] & ~addr[$address-4] & re;\n\n";
  }

  if ($sr_number_y > 1) {
   printf OUTFILE "always_ff @ (posedge clk or negedge clk_rst_n ) begin\n";
   printf OUTFILE "  if ( ! clk_rst_n ) begin\n";
   printf OUTFILE "    RE_SEL_reg <= '0;\n";
   printf OUTFILE "  end else begin\n";
   printf OUTFILE "    if (re) RE_SEL_reg <= RE_SEL;\n";
   printf OUTFILE "  end\n";
   printf OUTFILE "end\n\n";
  }

  $memory_cnt = 0;

  # y_index refers to memory depth segments
  # x_index refers to memory width (bit IO) segments
  for (my ${y_index}=0; ${y_index} <= (${sr_number_y}-1); ${y_index}++) {
    for (my ${x_index}=0; ${x_index} <= (${sr_number_x}-1); ${x_index}++) {

      # print "y:${sr_number_y} y_index:${y_index} x:${sr_number_x} x_index:${x_index}\n";

      if ($sr_number_y == 1 && $sr_number_x > 1) {
       printf OUTFILE "${sr_memory}_dfx_wrapper i_sram_b${x_index} (\n\n";
      } elsif ($sr_number_y > 1 && $sr_number_x == 1) {
       printf OUTFILE "${sr_memory}_dfx_wrapper i_sram_b${y_index} (\n\n";
      } else {
       printf OUTFILE "${sr_memory}_dfx_wrapper i_sram_b${y_index}_${x_index} (\n\n";
      }

      printf  OUTFILE "     .FUNC_CLK_IN              (clk)\n";
      if (${sr_number_y} > 1) {
       printf OUTFILE "    ,.FUNC_RD_EN_IN            (RE_SEL[${y_index}])\n";
       printf OUTFILE "    ,.FUNC_WR_EN_IN            (WE_SEL[${y_index}])\n";
      } else {
       printf OUTFILE "    ,.FUNC_RD_EN_IN            (RE_SEL)\n";
       printf OUTFILE "    ,.FUNC_WR_EN_IN            (WE_SEL)\n";
      }

      if ($addr_pad > 0) {
       printf OUTFILE "    ,.FUNC_ADDR_IN             ({${addr_pad}'b0, addr})\n";
      } else {
       printf OUTFILE "    ,.FUNC_ADDR_IN             (addr[${sr_name_address}-1:0])\n";
      }

      if (($data_pad > 0) && (${x_index} == ${sr_number_x}-1)) {
       printf OUTFILE "    ,.FUNC_WR_DATA_IN          ({${data_pad}'b0, wdata[(${x_index}*${sr_name_width}+${sr_name_width}-1-${data_pad}):(${x_index}*${sr_name_width})]})\n\n";
      } else {
       printf OUTFILE "    ,.FUNC_WR_DATA_IN          (wdata[(${x_index}*${sr_name_width}+${sr_name_width}-1):(${x_index}*${sr_name_width})])\n\n";
      }

      if ($sr_number_y == 1 && $sr_number_x > 1) {
       printf OUTFILE "    ,.DATA_OUT                 (rdata_tdo[(${x_index}*${sr_name_width}+${sr_name_width}-1):(${x_index}*${sr_name_width})])\n\n";
      } elsif ($sr_number_y > 1 && $sr_number_x == 1) {
       printf OUTFILE "    ,.DATA_OUT                 (rdata_tdo_${y_index}[(${x_index}*${sr_name_width}+${sr_name_width}-1):(${x_index}*${sr_name_width})])\n\n";
      } else {
       printf OUTFILE "    ,.DATA_OUT                 (rdata_tdo_${y_index}[(${x_index}*${sr_name_width}+${sr_name_width}-1):(${x_index}*${sr_name_width})])\n\n";
      }

      printf  OUTFILE "    ,.IP_RESET_B               (ip_reset_b_sync)\n";
      printf  OUTFILE "    ,.OUTPUT_RESET             ('0)\n\n";

      printf  OUTFILE "    ,.ISOLATION_CONTROL_IN     (pgcb_isol_en)\n";
      if ($pg_option == 1) {
       $next_memory = $memory_cnt + 1;
       printf OUTFILE "    ,.PWR_MGMT_IN              ({4'd0, pwr_mgmt_enable[${memory_cnt}], pwr_mgmt_enable[${memory_cnt}]})\n";
       printf OUTFILE "    ,.PWR_MGMT_OUT             (pwr_mgmt_enable[${next_memory}])\n\n";
      } else {
       printf OUTFILE "    ,.PWR_MGMT_IN              ('0)\n";
       printf OUTFILE "    ,.PWR_MGMT_OUT             ()\n\n";
      }

      printf  OUTFILE "    ,.WRAPPER_CLK_EN           ('1)\n\n";

      printf  OUTFILE "    ,.COL_REPAIR_IN            ('0)\n";
      printf  OUTFILE "    ,.GLOBAL_RROW_EN_IN        ('0)\n";
      printf  OUTFILE "    ,.ROW_REPAIR_IN            ('0)\n";
      printf  OUTFILE "    ,.SLEEP_FUSE_IN            ('0)\n";
      printf  OUTFILE "    ,.TRIM_FUSE_IN             ('0)\n\n";

      printf  OUTFILE "    ,.ARRAY_FREEZE             ('0)\n\n";

      printf  OUTFILE "    ,.BIST_ENABLE              ('0)\n";
      printf  OUTFILE "    ,.BIST_ADDR_IN             ('0)\n";
      printf  OUTFILE "    ,.BIST_CLK_IN              ('0)\n";
      printf  OUTFILE "    ,.BIST_RD_EN_IN            ('0)\n";
      printf  OUTFILE "    ,.BIST_WR_DATA_IN          ('0)\n";
      printf  OUTFILE "    ,.BIST_WR_EN_IN            ('0)\n\n";

      printf  OUTFILE "    ,.FSCAN_CLKUNGATE          (fscan_clkungate)\n";
      printf  OUTFILE "    ,.FSCAN_RAM_BYPSEL         ('0)\n";
      printf  OUTFILE "    ,.FSCAN_RAM_INIT_EN        ('0)\n";
      printf  OUTFILE "    ,.FSCAN_RAM_INIT_VAL       ('0)\n";
      printf  OUTFILE "    ,.FSCAN_RAM_RDIS_B         ('1)\n";
      printf  OUTFILE "    ,.FSCAN_RAM_WDIS_B         ('1)\n\n";

      printf  OUTFILE "`ifndef INTEL_NO_PWR_PINS\n\n";
      printf  OUTFILE "  `ifdef INTC_ADD_VSS\n\n";
      printf  OUTFILE "    ,.vss                      (dummy_vss)\n\n";
      printf  OUTFILE "  `endif\n\n";
      printf  OUTFILE "    ,.vccsoc_lv                ('1)\n";
      printf  OUTFILE "    ,.vccsocaon_lv             ('1)\n\n";
      printf  OUTFILE "`endif\n\n";

      printf  OUTFILE  ");\n\n";
   
      ${memory_cnt} = ${memory_cnt} + 1;

    } # close bracket for loop of x array (memory depth) of memories

  } # close bracket for loop of y array (bit or IO width) of memories

  if ($pg_option == 1) {
   printf OUTFILE "assign pwr_enable_b_out = pwr_mgmt_enable[${total_memory_cnt}];\n\n";
  }

  ######### RDATA mux selection

  if (${sr_number_y} == 1) {
   printf OUTFILE "assign rdata = rdata_tdo[$data-1:0];\n\n";
  }

  if (${sr_number_y} == 2) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    2'b01:   rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    2'b10:   rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    default: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 3) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    3'b001:  rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    3'b010:  rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    3'b100:  rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    default: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 4) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    4'b0001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    4'b0010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    4'b0100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    4'b1000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    default: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 5) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    5'b00001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    5'b00010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    5'b00100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    5'b01000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    5'b10000: rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "    default:  rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 6) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    6'b000001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    6'b000010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    6'b000100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    6'b001000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    6'b010000: rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "    6'b100000: rdata = rdata_tdo_5[$data-1:0];\n";
   printf OUTFILE "    default:   rdata = rdata_tdo_5[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 7) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    7'b0000001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    7'b0000010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    7'b0000100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    7'b0001000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    7'b0010000: rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "    7'b0100000: rdata = rdata_tdo_5[$data-1:0];\n";
   printf OUTFILE "    7'b1000000: rdata = rdata_tdo_6[$data-1:0];\n";
   printf OUTFILE "    default:    rdata = rdata_tdo_6[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 8) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    8'b00000001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    8'b00000010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    8'b00000100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    8'b00001000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    8'b00010000: rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "    8'b00100000: rdata = rdata_tdo_5[$data-1:0];\n";
   printf OUTFILE "    8'b01000000: rdata = rdata_tdo_6[$data-1:0];\n";
   printf OUTFILE "    8'b10000000: rdata = rdata_tdo_7[$data-1:0];\n";
   printf OUTFILE "    default:     rdata = rdata_tdo_7[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 9) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    9'b000000001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    9'b000000010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    9'b000000100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    9'b000001000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    9'b000010000: rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "    9'b000100000: rdata = rdata_tdo_5[$data-1:0];\n";
   printf OUTFILE "    9'b001000000: rdata = rdata_tdo_6[$data-1:0];\n";
   printf OUTFILE "    9'b010000000: rdata = rdata_tdo_7[$data-1:0];\n";
   printf OUTFILE "    9'b100000000: rdata = rdata_tdo_8[$data-1:0];\n";
   printf OUTFILE "    default:      rdata = rdata_tdo_8[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 10) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    10'b0000000001: rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    10'b0000000010: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    10'b0000000100: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    10'b0000001000: rdata = rdata_tdo_3[$data-1:0];\n";
   printf OUTFILE "    10'b0000010000: rdata = rdata_tdo_4[$data-1:0];\n";
   printf OUTFILE "    10'b0000100000: rdata = rdata_tdo_5[$data-1:0];\n";
   printf OUTFILE "    10'b0001000000: rdata = rdata_tdo_6[$data-1:0];\n";
   printf OUTFILE "    10'b0010000000: rdata = rdata_tdo_7[$data-1:0];\n";
   printf OUTFILE "    10'b0100000000: rdata = rdata_tdo_8[$data-1:0];\n";
   printf OUTFILE "    10'b1000000000: rdata = rdata_tdo_9[$data-1:0];\n";
   printf OUTFILE "    default:        rdata = rdata_tdo_9[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 11) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    11'b00000000001: rdata = rdata_tdo_0[ $data-1:0];\n";
   printf OUTFILE "    11'b00000000010: rdata = rdata_tdo_1[ $data-1:0];\n";
   printf OUTFILE "    11'b00000000100: rdata = rdata_tdo_2[ $data-1:0];\n";
   printf OUTFILE "    11'b00000001000: rdata = rdata_tdo_3[ $data-1:0];\n";
   printf OUTFILE "    11'b00000010000: rdata = rdata_tdo_4[ $data-1:0];\n";
   printf OUTFILE "    11'b00000100000: rdata = rdata_tdo_5[ $data-1:0];\n";
   printf OUTFILE "    11'b00001000000: rdata = rdata_tdo_6[ $data-1:0];\n";
   printf OUTFILE "    11'b00010000000: rdata = rdata_tdo_7[ $data-1:0];\n";
   printf OUTFILE "    11'b00100000000: rdata = rdata_tdo_8[ $data-1:0];\n";
   printf OUTFILE "    11'b01000000000: rdata = rdata_tdo_9[ $data-1:0];\n";
   printf OUTFILE "    11'b10000000000: rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "    default:         rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 12) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    12'b000000000001: rdata = rdata_tdo_0[ $data-1:0];\n";
   printf OUTFILE "    12'b000000000010: rdata = rdata_tdo_1[ $data-1:0];\n";
   printf OUTFILE "    12'b000000000100: rdata = rdata_tdo_2[ $data-1:0];\n";
   printf OUTFILE "    12'b000000001000: rdata = rdata_tdo_3[ $data-1:0];\n";
   printf OUTFILE "    12'b000000010000: rdata = rdata_tdo_4[ $data-1:0];\n";
   printf OUTFILE "    12'b000000100000: rdata = rdata_tdo_5[ $data-1:0];\n";
   printf OUTFILE "    12'b000001000000: rdata = rdata_tdo_6[ $data-1:0];\n";
   printf OUTFILE "    12'b000010000000: rdata = rdata_tdo_7[ $data-1:0];\n";
   printf OUTFILE "    12'b000100000000: rdata = rdata_tdo_8[ $data-1:0];\n";
   printf OUTFILE "    12'b001000000000: rdata = rdata_tdo_9[ $data-1:0];\n";
   printf OUTFILE "    12'b010000000000: rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "    12'b100000000000: rdata = rdata_tdo_11[$data-1:0];\n";
   printf OUTFILE "    default:          rdata = rdata_tdo_11[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 13) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    13'b0000000000001: rdata = rdata_tdo_0[ $data-1:0];\n";
   printf OUTFILE "    13'b0000000000010: rdata = rdata_tdo_1[ $data-1:0];\n";
   printf OUTFILE "    13'b0000000000100: rdata = rdata_tdo_2[ $data-1:0];\n";
   printf OUTFILE "    13'b0000000001000: rdata = rdata_tdo_3[ $data-1:0];\n";
   printf OUTFILE "    13'b0000000010000: rdata = rdata_tdo_4[ $data-1:0];\n";
   printf OUTFILE "    13'b0000000100000: rdata = rdata_tdo_5[ $data-1:0];\n";
   printf OUTFILE "    13'b0000001000000: rdata = rdata_tdo_6[ $data-1:0];\n";
   printf OUTFILE "    13'b0000010000000: rdata = rdata_tdo_7[ $data-1:0];\n";
   printf OUTFILE "    13'b0000100000000: rdata = rdata_tdo_8[ $data-1:0];\n";
   printf OUTFILE "    13'b0001000000000: rdata = rdata_tdo_9[ $data-1:0];\n";
   printf OUTFILE "    13'b0010000000000: rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "    13'b0100000000000: rdata = rdata_tdo_11[$data-1:0];\n";
   printf OUTFILE "    13'b1000000000000: rdata = rdata_tdo_12[$data-1:0];\n";
   printf OUTFILE "    default:           rdata = rdata_tdo_12[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 14) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    14'b00000000000001: rdata = rdata_tdo_0[ $data-1:0];\n";
   printf OUTFILE "    14'b00000000000010: rdata = rdata_tdo_1[ $data-1:0];\n";
   printf OUTFILE "    14'b00000000000100: rdata = rdata_tdo_2[ $data-1:0];\n";
   printf OUTFILE "    14'b00000000001000: rdata = rdata_tdo_3[ $data-1:0];\n";
   printf OUTFILE "    14'b00000000010000: rdata = rdata_tdo_4[ $data-1:0];\n";
   printf OUTFILE "    14'b00000000100000: rdata = rdata_tdo_5[ $data-1:0];\n";
   printf OUTFILE "    14'b00000001000000: rdata = rdata_tdo_6[ $data-1:0];\n";
   printf OUTFILE "    14'b00000010000000: rdata = rdata_tdo_7[ $data-1:0];\n";
   printf OUTFILE "    14'b00000100000000: rdata = rdata_tdo_8[ $data-1:0];\n";
   printf OUTFILE "    14'b00001000000000: rdata = rdata_tdo_9[ $data-1:0];\n";
   printf OUTFILE "    14'b00010000000000: rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "    14'b00100000000000: rdata = rdata_tdo_11[$data-1:0];\n";
   printf OUTFILE "    14'b01000000000000: rdata = rdata_tdo_12[$data-1:0];\n";
   printf OUTFILE "    14'b10000000000000: rdata = rdata_tdo_13[$data-1:0];\n";
   printf OUTFILE "    default:            rdata = rdata_tdo_13[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 15) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    15'b000000000000001: rdata = rdata_tdo_0[ $data-1:0];\n";
   printf OUTFILE "    15'b000000000000010: rdata = rdata_tdo_1[ $data-1:0];\n";
   printf OUTFILE "    15'b000000000000100: rdata = rdata_tdo_2[ $data-1:0];\n";
   printf OUTFILE "    15'b000000000001000: rdata = rdata_tdo_3[ $data-1:0];\n";
   printf OUTFILE "    15'b000000000010000: rdata = rdata_tdo_4[ $data-1:0];\n";
   printf OUTFILE "    15'b000000000100000: rdata = rdata_tdo_5[ $data-1:0];\n";
   printf OUTFILE "    15'b000000001000000: rdata = rdata_tdo_6[ $data-1:0];\n";
   printf OUTFILE "    15'b000000010000000: rdata = rdata_tdo_7[ $data-1:0];\n";
   printf OUTFILE "    15'b000000100000000: rdata = rdata_tdo_8[ $data-1:0];\n";
   printf OUTFILE "    15'b000001000000000: rdata = rdata_tdo_9[ $data-1:0];\n";
   printf OUTFILE "    15'b000010000000000: rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "    15'b000100000000000: rdata = rdata_tdo_11[$data-1:0];\n";
   printf OUTFILE "    15'b001000000000000: rdata = rdata_tdo_12[$data-1:0];\n";
   printf OUTFILE "    15'b010000000000000: rdata = rdata_tdo_13[$data-1:0];\n";
   printf OUTFILE "    15'b100000000000000: rdata = rdata_tdo_14[$data-1:0];\n";
   printf OUTFILE "    default:             rdata = rdata_tdo_14[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${sr_number_y} == 16) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    16'b0000000000000001: rdata = rdata_tdo_0[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000000000010: rdata = rdata_tdo_1[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000000000100: rdata = rdata_tdo_2[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000000001000: rdata = rdata_tdo_3[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000000010000: rdata = rdata_tdo_4[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000000100000: rdata = rdata_tdo_5[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000001000000: rdata = rdata_tdo_6[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000010000000: rdata = rdata_tdo_7[ $data-1:0];\n";
   printf OUTFILE "    16'b0000000100000000: rdata = rdata_tdo_8[ $data-1:0];\n";
   printf OUTFILE "    16'b0000001000000000: rdata = rdata_tdo_9[ $data-1:0];\n";
   printf OUTFILE "    16'b0000010000000000: rdata = rdata_tdo_10[$data-1:0];\n";
   printf OUTFILE "    16'b0000100000000000: rdata = rdata_tdo_11[$data-1:0];\n";
   printf OUTFILE "    16'b0001000000000000: rdata = rdata_tdo_12[$data-1:0];\n";
   printf OUTFILE "    16'b0010000000000000: rdata = rdata_tdo_13[$data-1:0];\n";
   printf OUTFILE "    16'b0100000000000000: rdata = rdata_tdo_14[$data-1:0];\n";
   printf OUTFILE "    16'b1000000000000000: rdata = rdata_tdo_15[$data-1:0];\n";
   printf OUTFILE "    default:              rdata = rdata_tdo_15[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

} # close bracket for case of array of memories
	
# printf  OUTFILE "// AW_unused_bits #(.WIDTH(1)) u_unused_rstb(.A(RSTB));\n\n";

printf  OUTFILE "endmodule // $outfile\n\n";

close OUTFILE;

print "Generated ${outfile}.sv\n";

### ESTABLISH UNIVERSAL HASHES OF AW DATA FOR USE BY POST UNIVERALS UTILITY

### Fist hash is instances in an AW wrapper utilized to contruct AW wrapper instantion paths
### $instances{"(AW_wrapper)"}{"instance#"} = "(instance name)";

open AW_SOLUTION_OUTFILE, ">>AW_SOLUTION.hash.txt";

printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{addr_width\}\},\"${address}\");\n";
printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{hip\}\},\"${sr_memory}\");\n";
printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{gated\}\},\"${pg_option}\");\n";

for (my ${y_index}=0; ${y_index} <= (${sr_number_y}-1); ${y_index}++) {
  for (my ${x_index}=0; ${x_index} <= (${sr_number_x}-1); ${x_index}++) {

    if ($sr_number_y == 1 && $sr_number_x == 1) {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_sram\");\n";
    } elsif ($sr_number_y == 1 && $sr_number_x > 1) {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_sram_b${x_index}\");\n";
    } elsif ($sr_number_y > 1 && $sr_number_x == 1) {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_sram_b${y_index}\");\n";
    } else {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_sram_b${y_index}_${x_index}\");\n";
    }

  }
}
