#!/usr/intel/bin/perl -w

#  -----------------------------------------------------------------------------------------------------
#                                Copyright (c) Intel Corporation, 2019
#                                        All rights reserved.
#
#  -----------------------------------------------------------------------------------------------------
#
#   File Name:     AW_rf.CMO_1274d3.perl
#   Created by:    Keith Christman	
#
# -----------------------------------------------------------------------------------------------------
#
#   This program takes 8 input arguments and creates a wrapper file
#   containing the rtl and instantiations for the desired rf memory configuration.
#   It can handle single instance and an array {y(depth) & x(width)} of instances
#   to generate larger memories. Max memory array size is 16x16.
#
#   input arguments:
#        wrapper_depth wrapper_data prefix rf_number_y rf_number_x rf_memory
#
#   output file:
#         output file naming convention: <outfile>.sv = <prefix>_<depth>x<data>.sv
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

if ((scalar(@ARGV)>0) && ($ARGV[0] eq "-d")) {shift(@ARGV); $debug=1;} else {$debug=0;}

if (($ARGV[0] eq "") || ($ARGV[1] eq "") || ($ARGV[2] eq "") || ($ARGV[3] eq "") || ($ARGV[4] eq "") || ($ARGV[5] eq "")) {
        print "  Usage:  AW_rf.CMO_1274d3.perl <depth> <data> <prefix> <rf_num_y> <rf_num_x> <rf_mem>\n";
        print "  Example 1: rf_array.intel10nm.perl    64    32  AW_sacram_1r_1w 1 1 ip743rfshpm1r1w64x32 0 0\n";
        print "  Example 2: rf_array.intel10nm.perl    64    80  AW_sacram_bw_1r_1w 1 2 ip743rfshpm1r1w64x40be40 1 0\n";
        print "  Example 3: rf_array.intel10nm.perl    64    80  AW_dcsacram_bw_1r_1w 1 2 ip743rfshpm1r1w64x40be40 1 1\n";
        die "Failed Script Execution.\n\n";
}

$depth       = $ARGV[0];
$data        = $ARGV[1];
$prefix      = $ARGV[2];
$rf_number_y = $ARGV[3];
$rf_number_x = $ARGV[4];
$rf_memory   = $ARGV[5];

if ($debug) {printf "DEBUG: depth=$depth data=$data prefix=$prefix rf#y=$rf_number_y rf#x=$rf_number_x hip=$rf_memory\n";}

$error_flag = 0;

$total_memory_cnt = $rf_number_y * $rf_number_x;

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

if (! -r "../../../../../hip/${rf_memory}/doc/${rf_memory}_tttt_0.65v_100c_datasheet.txt") {
 die "\nERROR: Couldn't find memory datasheet for ${rf_memory}; check CMO delivery inventory!!!\n\n";
}

################################################
## CHECK PARAMETERS
################################################

$pg_option = ($rf_memory =~ /p1$/) ? 1 : 0;

$rf_memory =~ m/(\d+)x(\d+)/;
$rf_name_depth = $1;
$rf_name_width = $2;
$total_depth = $rf_number_y * $rf_name_depth;
$total_width = $rf_number_x * $rf_name_width;
if ($debug) {print "rf_name_depth=$rf_name_depth rf_name_width=$rf_name_width total_depth=$total_depth total_width=$total_width\n";}
$rf_name_address = ceil(log2($rf_name_depth));
$addr_decode = $address - $rf_name_address;
$rf_name_address_log = log2($rf_name_depth);
if ($debug) {print "rf_name_address=$rf_name_address addr_decode=$addr_decode rf_name_address_log=$rf_name_address_log\n";}

if ($rf_number_y > 1) {
  if ( $rf_name_address_log != $rf_name_address) {
    print "WARNING: rf_name_depth is not a power of 2! Unused addr space in rf memory inst array components.\n";
  }
}

$data_pad = $total_width - $data;

$total_address = ceil(log2($total_depth));
$addr_pad = $total_address - $address;

# x_index refers to memory depth segments
# y_index refers to memory width (bit IO) segments

if (($rf_number_x > 16) && ( $rf_number_x > 0)) {
  print "ERROR: Bad value for rf_number_x (valid is 1-16)! ${rf_number_x}\n";
  $error_flag = 1;
}

if (($rf_number_y > 16) && ( $rf_number_y > 0)) {
  print "ERROR: Bad value for rf_number_y (valid is 1-16)! ${rf_number_y}\n";
  $error_flag = 1;
}

if (($rf_number_x == 1) || ($rf_number_x > 1) && ($addr_pad == 0)) {
} else {
  print "ERROR: Bad combo values for rf_number_x & addr_pad! ${rf_number_x}  ${addr_pad}\n";
  $error_flag = 1;
}

if ($data_pad >= $rf_name_width) {
  print "ERROR: Bad combo values for data_pad & rf_name_width! ${data_pad}  ${rf_name_width}\n";
  $error_flag = 1;
}

if ( $total_depth >= $depth ) {
    if ( $total_depth > $depth ) {
       print "WARNING: Oversized depth ${total_depth} for ${depth}x${data}\n";
    }
} else {
  print "ERROR: Depth of ram array is too small! ${total_depth}\n";
  $error_flag = 1;
}

if( $total_width >= $data ) {
    if ( $total_width > $data ) {
       if (($total_width - $data) == 1) {
          print "INFO: Oversized by 1 bit for odd size ${depth}x${data}\n";
       } else {
          if ($data < 8) {
              print "INFO: Oversized for min rf width ${depth}x${data}\n";
          } else {
              print "WARNING: Oversized width ${total_width} for ${depth}x${data}\n";
          }
       }
    }
} else {
  print "ERROR: Width of regfile array is too small! ${total_width}\n";
  $error_flag = 1;
}

if ($debug) {print "addr_pad: ${addr_pad}    data_pad: ${data_pad}\n";}

if ($error_flag == 1) {
  die "\n***ATTENTION: ERRORS FOUND!\n\n";
}

################################################

$outfile = "${prefix}_${depth}x${data}";
open OUTFILE, ">${outfile}.sv";

open TB_BUILD_TEMP, "<VCS/build_rf_temp";
open TB_BUILD_OUT, ">VCS/build_${outfile}";
#
while (<TB_BUILD_TEMP>) {

   if ($_ =~ /Insert CMO Start/) {
      print TB_BUILD_OUT "-y \$WORKAREA/subip/hip/${rf_memory}/src/rtl \\\n";
      print TB_BUILD_OUT "   \$WORKAREA/subip/hip/${rf_memory}/src/rtl/${rf_memory}_dfx_wrapper.sv \\\n";
      print TB_BUILD_OUT "   \$WORKAREA/subip/hip/${rf_memory}/src/rtl/${rf_memory}.sv \\\n";
   } elsif ($_ =~ /Insert TB/) {
      print TB_BUILD_OUT "${outfile}_tb.sv \\\n";
   } else {
      print TB_BUILD_OUT "$_";
   }
}

open TB_TEMP, "<VCS/rf_temp.sv";
open TB_OUT, ">VCS/${outfile}_tb.sv";

while (<TB_TEMP>) {

   if ($_ =~ /KAC-begin param/) {
      print  TB_OUT "localparam DEPTH   = ${depth};\n";
      print  TB_OUT "localparam DEPTHB2 = ${address};\n";
      print  TB_OUT "localparam WIDTH   = ${data};\n";
   } elsif ($_ =~ /KAC-begin inst/) {
      print  TB_OUT  "${outfile} i_dut (\n";
      print  TB_OUT  "     .wclk                 (wclk)\n";
      print  TB_OUT  "    ,.wclk_rst_n           (1'b1)\n";
      print  TB_OUT  "    ,.rclk                 (rclk)\n";
      print  TB_OUT  "    ,.rclk_rst_n           (1'b1)\n";
      print  TB_OUT  "    ,.waddr                (waddr)\n";
      print  TB_OUT  "    ,.raddr                (raddr)\n";
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

###############################################
# OUTFILE HEADER
###############################################

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

################################################
## SINGLE RF MEMORY
################################################

if (($rf_number_y == 1) && ($rf_number_x == 1)) {

  printf  OUTFILE "module $outfile (\n\n";
  printf  OUTFILE "     input  logic              wclk\n";
  printf  OUTFILE "    ,input  logic              wclk_rst_n\n";
  printf  OUTFILE "    ,input  logic              we\n";
  printf  OUTFILE "    ,input  logic %-12s waddr\n", "[${address}-1:0]";
  printf  OUTFILE "    ,input  logic %-12s wdata\n\n", "[${data}-1:0]";
  printf  OUTFILE "    ,input  logic              rclk\n";
  printf  OUTFILE "    ,input  logic              rclk_rst_n\n";
  printf  OUTFILE "    ,input  logic              re\n";
  printf  OUTFILE "    ,input  logic %-12s raddr\n\n", "[${address}-1:0]";
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
  printf  OUTFILE "//-----------------------------------------------------------------------------------------------------\n\n";

  printf  OUTFILE "logic [$rf_name_width-1:0] rdata_tdo;\n";
  printf  OUTFILE "logic ip_reset_b_sync;\n\n";

  printf  OUTFILE "`ifndef INTEL_NO_PWR_PINS\n\n";
  printf  OUTFILE "  `ifdef INTC_ADD_VSS\n\n";
  printf  OUTFILE "        logic  dummy_vss;\n\n";
  printf  OUTFILE "        assign dummy_vss = 1'b0;\n\n";
  printf  OUTFILE "  `endif\n\n";
  printf  OUTFILE "`endif\n\n";

  printf  OUTFILE "hqm_mem_reset_sync_scan i_ip_reset_b_sync (\n\n";
  printf  OUTFILE "     .clk                     (rclk)\n";
  printf  OUTFILE "    ,.rst_n                   (ip_reset_b)\n\n";
  printf  OUTFILE "    ,.fscan_rstbypen          (fscan_rstbypen)\n";
  printf  OUTFILE "    ,.fscan_byprst_b          (fscan_byprst_b)\n\n";
  printf  OUTFILE "    ,.rst_n_sync              (ip_reset_b_sync)\n";
  printf  OUTFILE ");\n\n";

  printf  OUTFILE "//------------------------------------------------------------\n";
  printf  OUTFILE "// RF IP Placeholder\n\n";

  if ($ARGV[2] =~ /_dc/) {
   printf OUTFILE "${rf_memory}_dfx_wrapper #(.BYPASS_RD_CLK_MUX(0)) i_rf (\n\n";
  } else {
   printf OUTFILE "${rf_memory}_dfx_wrapper i_rf (\n\n";
  }

  printf  OUTFILE "     .FUNC_WR_CLK_IN          (wclk)\n";
  printf  OUTFILE "    ,.FUNC_WR_EN_IN           (we)\n";

  if ($addr_pad > 0) {
   printf OUTFILE "    ,.FUNC_WR_ADDR_IN         ({${addr_pad}'b0, waddr})\n";
  } else {
   printf OUTFILE "    ,.FUNC_WR_ADDR_IN         (waddr)\n";
  }

  if ($data_pad > 0) {
   printf OUTFILE "    ,.FUNC_WR_DATA_IN         ({${data_pad}'b0, wdata})\n\n";
  } else {
   printf OUTFILE "    ,.FUNC_WR_DATA_IN         (wdata)\n\n";
  }

  printf  OUTFILE "    ,.FUNC_RD_CLK_IN          (rclk)\n";
  printf  OUTFILE "    ,.FUNC_RD_EN_IN           (re)\n";

  if ($addr_pad > 0) {
   printf OUTFILE "    ,.FUNC_RD_ADDR_IN         ({${addr_pad}'b0, raddr})\n";
  } else {
   printf OUTFILE "    ,.FUNC_RD_ADDR_IN         (raddr)\n";
  }

  printf  OUTFILE "    ,.DATA_OUT                (rdata_tdo)\n\n";

  printf  OUTFILE "    ,.IP_RESET_B              (ip_reset_b_sync)\n";
  printf  OUTFILE "    ,.OUTPUT_RESET            ('0)\n\n";

  printf  OUTFILE "    ,.WRAPPER_RD_CLK_EN       ('1)\n";
  printf  OUTFILE "    ,.WRAPPER_WR_CLK_EN       ('1)\n\n";

  if ($pg_option == 1) {
   printf OUTFILE "    ,.ISOLATION_CONTROL_IN    (pgcb_isol_en)\n";
   printf OUTFILE "    ,.PWR_MGMT_IN             ({pwr_enable_b_in, 3'd0, pwr_enable_b_in})\n";
   printf OUTFILE "    ,.PWR_MGMT_OUT            (pwr_enable_b_out)\n\n";
  } else {
   printf OUTFILE "    ,.ISOLATION_CONTROL_IN    ('0)\n";
   printf OUTFILE "    ,.PWR_MGMT_IN             ('0)\n";
   printf OUTFILE "    ,.PWR_MGMT_OUT            ()\n\n";
  }

  printf  OUTFILE "    ,.COL_REPAIR_IN           ('0)\n";
  printf  OUTFILE "    ,.GLOBAL_RROW_EN_IN_RD    ('0)\n";
  printf  OUTFILE "    ,.GLOBAL_RROW_EN_IN_WR    ('0)\n";
  printf  OUTFILE "    ,.ROW_REPAIR_IN           ('0)\n";
  printf  OUTFILE "    ,.SLEEP_FUSE_IN           ('0)\n";
  printf  OUTFILE "    ,.TRIM_FUSE_IN            (11'h008)\n\n";
         
  printf  OUTFILE "    ,.ARRAY_FREEZE            ('0)\n\n";
         
  printf  OUTFILE "    ,.BIST_ENABLE             ('0)\n";
  printf  OUTFILE "    ,.BIST_WR_CLK_IN          ('0)\n";
  printf  OUTFILE "    ,.BIST_WR_EN_IN           ('0)\n";
  printf  OUTFILE "    ,.BIST_WR_ADDR_IN         ('0)\n";
  printf  OUTFILE "    ,.BIST_WR_DATA_IN         ('0)\n";
  printf  OUTFILE "    ,.BIST_RD_CLK_IN          ('0)\n";
  printf  OUTFILE "    ,.BIST_RD_EN_IN           ('0)\n";
  printf  OUTFILE "    ,.BIST_RD_ADDR_IN         ('0)\n\n";
         
  printf  OUTFILE "    ,.FSCAN_CLKUNGATE         (fscan_clkungate)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_BYPSEL        ('0)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_INIT_EN       ('0)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_INIT_VAL      ('0)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_RDIS_B        ('1)\n";
  printf  OUTFILE "    ,.FSCAN_RAM_WDIS_B        ('1)\n\n";
         
  printf  OUTFILE "  `ifndef INTEL_NO_PWR_PINS\n\n";
  printf  OUTFILE "    ,.vddp                    ('1)\n\n";
  printf  OUTFILE "    `ifdef INTC_ADD_VSS\n\n";
  printf  OUTFILE "    ,.vss                     (dummy_vss)\n\n";
  printf  OUTFILE "    `endif\n\n";
  printf  OUTFILE "  `endif\n\n";
  printf  OUTFILE ");\n\n";

  printf  OUTFILE "assign rdata = rdata_tdo[$data-1:0];\n\n";

  printf  OUTFILE "endmodule // $outfile\n\n";

} else {

  printf  OUTFILE "module $outfile (\n\n";

  ################################################
  ## OUTFILE MODULE IO PORTS
  ################################################

  printf  OUTFILE "     input  logic              wclk\n";
  printf  OUTFILE "    ,input  logic              wclk_rst_n\n";
  printf  OUTFILE "    ,input  logic              we\n";
  printf  OUTFILE "    ,input  logic %-12s waddr\n", "[${address}-1:0]";
  printf  OUTFILE "    ,input  logic %-12s wdata\n\n", "[${data}-1:0]";
  printf  OUTFILE "    ,input  logic              rclk\n";
  printf  OUTFILE "    ,input  logic              rclk_rst_n\n";
  printf  OUTFILE "    ,input  logic              re\n";
  printf  OUTFILE "    ,input  logic %-12s raddr\n\n", "[${address}-1:0]";
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

  print OUTFILE ");\n\n";

  if (${rf_number_y} > 1) {
   for (my ${y_index}=0; ${y_index} <= (${rf_number_y}-1); ${y_index}++) {
    print OUTFILE "logic [$rf_name_width-1:0] rdata_tdo_${y_index};\n";
   }
   print OUTFILE  "\n";
  } else {
   print OUTFILE  "logic [$total_memory_cnt*$rf_name_width-1:0] rdata_tdo;\n\n";
  }
  printf  OUTFILE "logic ip_reset_b_sync;\n\n";

  printf  OUTFILE "`ifndef INTEL_NO_PWR_PINS\n\n";
  printf  OUTFILE "  `ifdef INTC_ADD_VSS\n\n";
  printf  OUTFILE "        logic  dummy_vss;\n\n";
  printf  OUTFILE "        assign dummy_vss = 1'b0;\n\n";
  printf  OUTFILE "  `endif\n\n";
  printf  OUTFILE "`endif\n\n";

  printf  OUTFILE "hqm_mem_reset_sync_scan i_ip_reset_b_sync (\n\n";
  printf  OUTFILE "     .clk                     (rclk)\n";
  printf  OUTFILE "    ,.rst_n                   (ip_reset_b)\n\n";
  printf  OUTFILE "    ,.fscan_rstbypen          (fscan_rstbypen)\n";
  printf  OUTFILE "    ,.fscan_byprst_b          (fscan_byprst_b)\n\n";
  printf  OUTFILE "    ,.rst_n_sync              (ip_reset_b_sync)\n";
  printf  OUTFILE ");\n\n";

  ################################################
  ## Hook up ARRAY OF RFs
  ################################################

  printf  OUTFILE "//*******************************************************************\n";
  printf  OUTFILE "// Placeholder ARRAY OF RFs\n";
  printf  OUTFILE "//*******************************************************************\n\n";

  if ($pg_option == 1)       {
   printf OUTFILE "logic [$total_memory_cnt:0] pwr_mgmt_enable;\n\n";
   printf OUTFILE "assign pwr_mgmt_enable[0] = pwr_enable_b_in;\n\n";
  }

  if ($rf_number_y == 1) {
   printf OUTFILE "logic      WE_SEL;\n";
   printf OUTFILE "logic      RE_SEL;\n\n";
  } else {
   printf OUTFILE "logic [$rf_number_y-1:0] WE_SEL;\n";
   printf OUTFILE "logic [$rf_number_y-1:0] RE_SEL;\n";
   printf OUTFILE "logic [$rf_number_y-1:0] RE_SEL_reg;\n\n";
  }

  if ($rf_number_y == 1) {
   printf OUTFILE "assign WE_SEL = we;\n";
   printf OUTFILE "assign RE_SEL = re;\n\n";
  }

  if ($rf_number_y == 2) {
   printf OUTFILE "assign WE_SEL[1] =  waddr[$address-1] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & we;\n";
   printf OUTFILE "assign RE_SEL[1] =  raddr[$address-1] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & re;\n\n";
  }

  if ($rf_number_y == 3) {
   printf OUTFILE "assign WE_SEL[2] =  waddr[$address-1] & ~waddr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] &  waddr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & we;\n";
   printf OUTFILE "assign RE_SEL[2] =  raddr[$address-1] & ~raddr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] &  raddr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & re;\n\n";
  }

  if ($rf_number_y == 4) {
   printf OUTFILE "assign WE_SEL[3] =  waddr[$address-1] &  waddr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[2] =  waddr[$address-1] & ~waddr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] &  waddr[$address-2] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & we;\n";
   printf OUTFILE "assign RE_SEL[3] =  raddr[$address-1] &  raddr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[2] =  raddr[$address-1] & ~raddr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] &  raddr[$address-2] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & re;\n\n";
  }

  if ($rf_number_y == 5) {
   printf OUTFILE "assign WE_SEL[4] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[4] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & re;\n\n";
  }

  if ($rf_number_y == 6) {
   printf OUTFILE "assign WE_SEL[5] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[4] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[5] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[4] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[3] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[2] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & we;\n\n";
  }

  if ($rf_number_y == 7) {
   printf OUTFILE "assign WE_SEL[6] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[5] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[4] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[6] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[5] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[4] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & re;\n\n";
  }

  if ($rf_number_y == 8) {
   printf OUTFILE "assign WE_SEL[7] =  waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[6] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[5] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[4] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & we;\n";
   printf OUTFILE "assign RE_SEL[7] =  raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[6] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[5] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[4] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & re;\n\n";
  }

  if ($rf_number_y == 9) {
   printf OUTFILE "assign WE_SEL[8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 10) {
   printf OUTFILE "assign WE_SEL[9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 11) {
   printf OUTFILE "assign WE_SEL[10] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[10] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 12) {
   printf OUTFILE "assign WE_SEL[11] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[11] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 13) {
   printf OUTFILE "assign WE_SEL[12] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[12] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 14) {
   printf OUTFILE "assign WE_SEL[13] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[12] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[13] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[12] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 15) {
   printf OUTFILE "assign WE_SEL[14] =  waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[13] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[12] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[14] =  raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[13] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[12] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y == 16) {
   printf OUTFILE "assign WE_SEL[15] =  waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[14] =  waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[13] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[12] =  waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[11] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[10] =  waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 9] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 8] =  waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 7] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 6] = ~waddr[$address-1] &  waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 5] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 4] = ~waddr[$address-1] &  waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 3] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 2] = ~waddr[$address-1] & ~waddr[$address-2] &  waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 1] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] &  waddr[$address-4] & we;\n";
   printf OUTFILE "assign WE_SEL[ 0] = ~waddr[$address-1] & ~waddr[$address-2] & ~waddr[$address-3] & ~waddr[$address-4] & we;\n";
   printf OUTFILE "assign RE_SEL[15] =  raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[14] =  raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[13] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[12] =  raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[11] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[10] =  raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 9] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 8] =  raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 7] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 6] = ~raddr[$address-1] &  raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 5] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 4] = ~raddr[$address-1] &  raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 3] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 2] = ~raddr[$address-1] & ~raddr[$address-2] &  raddr[$address-3] & ~raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 1] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] &  raddr[$address-4] & re;\n";
   printf OUTFILE "assign RE_SEL[ 0] = ~raddr[$address-1] & ~raddr[$address-2] & ~raddr[$address-3] & ~raddr[$address-4] & re;\n\n";
  }

  if ($rf_number_y > 1) {
   printf OUTFILE "always_ff @ (posedge rclk or negedge rclk_rst_n ) begin\n";
   printf OUTFILE "  if ( ! rclk_rst_n ) begin\n";
   printf OUTFILE "    RE_SEL_reg <= '0;\n";
   printf OUTFILE "  end else begin\n";
   printf OUTFILE "    if (re) RE_SEL_reg <= RE_SEL;\n";
   printf OUTFILE "  end\n";
   printf OUTFILE "end\n\n";
  }

  $memory_cnt = 0;

  # y_index refers to memory depth segments
  # x_index refers to memory width (bit IO) segments
  for (my ${y_index}=0; ${y_index} <= (${rf_number_y}-1); ${y_index}++) {
    for (my ${x_index}=0; ${x_index} <= (${rf_number_x}-1); ${x_index}++) {

      # printf "y:${rf_number_y} y_index:${y_index} x:${rf_number_x} x_index:${x_index}\n";

      if ((${rf_number_y} > 1) && (${rf_number_x} > 1)) {
       if ($ARGV[2] =~ /_dc/) {
        printf OUTFILE "${rf_memory}_dfx_wrapper #(.BYPASS_RD_CLK_MUX(0)) i_rf_b${y_index}_${x_index} (\n\n";
       } else {
        printf OUTFILE "${rf_memory}_dfx_wrapper i_rf_b${y_index}_${x_index} (\n\n";
       }
      } elsif (${rf_number_y} > 1) {
       if ($ARGV[2] =~ /_dc/) {
        printf OUTFILE "${rf_memory}_dfx_wrapper #(.BYPASS_RD_CLK_MUX(0)) i_rf_b${y_index} (\n\n";
       } else {
        printf OUTFILE "${rf_memory}_dfx_wrapper i_rf_b${y_index} (\n\n";
       }
      } else {
       if ($ARGV[2] =~ /_dc/) {
        printf OUTFILE "${rf_memory}_dfx_wrapper #(.BYPASS_RD_CLK_MUX(0)) i_rf_b${x_index} (\n\n";
       } else {
        printf OUTFILE "${rf_memory}_dfx_wrapper i_rf_b${x_index} (\n\n";
       }
      }

      printf   OUTFILE "     .FUNC_WR_CLK_IN          (wclk)\n";
      if (${rf_number_y} > 1) {
       printf  OUTFILE "    ,.FUNC_WR_EN_IN           (WE_SEL[${y_index}])\n";
      } else {
       printf  OUTFILE "    ,.FUNC_WR_EN_IN           (WE_SEL)\n";
      }

      printf   OUTFILE "    ,.FUNC_WR_ADDR_IN         (waddr[${rf_name_address}-1:0])\n";

      if (($data_pad > 0) && (${x_index} == ${rf_number_x}-1)) {
       printf  OUTFILE "    ,.FUNC_WR_DATA_IN         ({${data_pad}'b0, wdata[(${x_index}*${rf_name_width}+${rf_name_width}-1-${data_pad}):(${x_index}*${rf_name_width})]})\n\n";
      } else {
       printf  OUTFILE "    ,.FUNC_WR_DATA_IN         (wdata[(${x_index}*${rf_name_width}+${rf_name_width}-1):(${x_index}*${rf_name_width})])\n\n";
      }

      printf   OUTFILE "    ,.FUNC_RD_CLK_IN          (rclk)\n";
      if (${rf_number_y} > 1) {
       printf  OUTFILE "    ,.FUNC_RD_EN_IN           (RE_SEL[${y_index}])\n";
      } else {
       printf  OUTFILE "    ,.FUNC_RD_EN_IN           (RE_SEL)\n";
      }

      printf   OUTFILE "    ,.FUNC_RD_ADDR_IN         (raddr[${rf_name_address}-1:0])\n";

      if (${rf_number_y} > 1) {
       printf  OUTFILE "    ,.DATA_OUT                (rdata_tdo_${y_index}[(${x_index}*${rf_name_width}+${rf_name_width}-1):(${x_index}*${rf_name_width})])\n\n";
      } else {
       printf  OUTFILE "    ,.DATA_OUT                (rdata_tdo[(${x_index}*${rf_name_width}+${rf_name_width}-1):(${x_index}*${rf_name_width})])\n\n";
      }

      printf   OUTFILE "    ,.IP_RESET_B              (ip_reset_b_sync)\n";
      printf   OUTFILE "    ,.OUTPUT_RESET            ('0)\n\n";

      printf   OUTFILE "    ,.WRAPPER_RD_CLK_EN       ('1)\n";
      printf   OUTFILE "    ,.WRAPPER_WR_CLK_EN       ('1)\n\n";

      if ($pg_option == 1) {
       $next_memory = $memory_cnt + 1;
       printf  OUTFILE "    ,.ISOLATION_CONTROL_IN    (pgcb_isol_en)\n";
       printf  OUTFILE "    ,.PWR_MGMT_IN             ({pwr_mgmt_enable[${memory_cnt}], 3'd0, pwr_mgmt_enable[${memory_cnt}]})\n";
       printf  OUTFILE "    ,.PWR_MGMT_OUT            (pwr_mgmt_enable[${next_memory}])\n\n";
      } else {
       printf  OUTFILE "    ,.ISOLATION_CONTROL_IN    ('0)\n";
       printf  OUTFILE "    ,.PWR_MGMT_IN             ('0)\n";
       printf  OUTFILE "    ,.PWR_MGMT_OUT            ()\n\n";
      }

      printf   OUTFILE "    ,.COL_REPAIR_IN           ('0)\n";
      printf   OUTFILE "    ,.GLOBAL_RROW_EN_IN_RD    ('0)\n";
      printf   OUTFILE "    ,.GLOBAL_RROW_EN_IN_WR    ('0)\n";
      printf   OUTFILE "    ,.ROW_REPAIR_IN           ('0)\n";
      printf   OUTFILE "    ,.SLEEP_FUSE_IN           ('0)\n";
      printf   OUTFILE "    ,.TRIM_FUSE_IN            (11'h008)\n\n";

      printf   OUTFILE "    ,.ARRAY_FREEZE            ('0)\n\n";

      printf   OUTFILE "    ,.BIST_ENABLE             ('0)\n";
      printf   OUTFILE "    ,.BIST_WR_CLK_IN          ('0)\n";
      printf   OUTFILE "    ,.BIST_WR_EN_IN           ('0)\n";
      printf   OUTFILE "    ,.BIST_WR_ADDR_IN         ('0)\n";
      printf   OUTFILE "    ,.BIST_WR_DATA_IN         ('0)\n";
      printf   OUTFILE "    ,.BIST_RD_CLK_IN          ('0)\n";
      printf   OUTFILE "    ,.BIST_RD_EN_IN           ('0)\n";
      printf   OUTFILE "    ,.BIST_RD_ADDR_IN         ('0)\n\n";

      printf   OUTFILE "    ,.FSCAN_CLKUNGATE         (fscan_clkungate)\n";
      printf   OUTFILE "    ,.FSCAN_RAM_BYPSEL        ('0)\n";
      printf   OUTFILE "    ,.FSCAN_RAM_INIT_EN       ('0)\n";
      printf   OUTFILE "    ,.FSCAN_RAM_INIT_VAL      ('0)\n";
      printf   OUTFILE "    ,.FSCAN_RAM_RDIS_B        ('1)\n";
      printf   OUTFILE "    ,.FSCAN_RAM_WDIS_B        ('1)\n\n";

      printf   OUTFILE "  `ifndef INTEL_NO_PWR_PINS\n\n";
      printf   OUTFILE "    ,.vddp                    ('1)\n\n";
      printf   OUTFILE "    `ifdef INTC_ADD_VSS\n\n";
      printf   OUTFILE "    ,.vss                     (dummy_vss)\n\n";
      printf   OUTFILE "    `endif\n\n";
      printf   OUTFILE "  `endif\n\n";
      printf   OUTFILE ");\n\n";

      ${memory_cnt} = ${memory_cnt} + 1;

    } # close bracket for loop of x array (memory depth) of memories

  } # close bracket for loop of y array (bit or IO width) of memories

  if ($pg_option == 1) {
   printf OUTFILE "assign pwr_enable_b_out = pwr_mgmt_enable[${total_memory_cnt}];\n\n";
  }

  ######### RDATA mux selection

  if (${rf_number_y} == 1) {
   printf OUTFILE "assign rdata = rdata_tdo[$data-1:0];\n\n";
  }

  if (${rf_number_y} == 2) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    2'b01:   rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    2'b10:   rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    default: rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${rf_number_y} == 3) {
   printf OUTFILE "always_comb begin: read_data\n";
   printf OUTFILE "  case (RE_SEL_reg)\n";
   printf OUTFILE "    3'b001:  rdata = rdata_tdo_0[$data-1:0];\n";
   printf OUTFILE "    3'b010:  rdata = rdata_tdo_1[$data-1:0];\n";
   printf OUTFILE "    3'b100:  rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "    default: rdata = rdata_tdo_2[$data-1:0];\n";
   printf OUTFILE "  endcase\n";
   printf OUTFILE "end\n\n";
  }

  if (${rf_number_y} == 4) {
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

  if (${rf_number_y} == 5) {
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

  if (${rf_number_y} == 6) {
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

  if (${rf_number_y} == 7) {
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

  if (${rf_number_y} == 8) {
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

  if (${rf_number_y} == 9) {
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

  if (${rf_number_y} == 10) {
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

  if (${rf_number_y} == 11) {
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

  if (${rf_number_y} == 12) {
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

  if (${rf_number_y} == 13) {
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

  if (${rf_number_y} == 14) {
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

  if (${rf_number_y} == 15) {
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

  if (${rf_number_y} == 16) {
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

  # printf OUTFILE "// AW_unused_bits #(.WIDTH(1)) u_unused_rstb(.A(RSTB));\n\n";

  printf  OUTFILE "endmodule // $outfile\n\n";

  close OUTFILE;

} # close bracket for case of array of memories

printf"Generated ${outfile}.sv\n";

### ESTABLISH UNIVERSAL HASHES OF AW DATA FOR USE BY POST UNIVERALS UTILITY

### Fist hash is instances in an AW wrapper utilized to contruct AW wrapper instantion paths
### $instances{"(AW_wrapper)"}{"instance#"} = "(instance name)";

open AW_SOLUTION_OUTFILE, ">>AW_SOLUTION.hash.txt";

printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{addr_width\}\},\"${address}\");\n";
printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{hip\}\},\"${rf_memory}\");\n";
printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{gated\}\},\"${pg_option}\");\n";

for (my ${y_index}=0; ${y_index} <= (${rf_number_y}-1); ${y_index}++) {
  for (my ${x_index}=0; ${x_index} <= (${rf_number_x}-1); ${x_index}++) {

    if ($rf_number_y == 1 && $rf_number_x == 1) {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_rf\");\n";
    } elsif ($rf_number_y == 1 && $rf_number_x > 1) {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_rf_b${x_index}\");\n";
    } elsif ($rf_number_y > 1 && $rf_number_x == 1) {
      printf AW_SOLUTION_OUTFILE "push(\@\{\$AW_hash\{$outfile\}\{instance\}\},\"i_rf_b${y_index}\");\n";
    } else {
      printf "ERROR\n";
    }

  }
}

