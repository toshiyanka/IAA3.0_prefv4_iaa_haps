#!/usr/intel/bin/perl

print "This file will generate 4 parameters files:\n";
print "     stap_params_include.inc                    - To be used during standalone configuration\n";
print "     tb_param.inc                               - To be used during standalone configuration\n";
print "     output_filename_sTAP_soc_param_values.inc  - To be used during instantiation in SoC\n";
print "     output_filename_sTAP_soc_param_overide.inc - To be used during instantiation in SoC\n";

print "Enter the prefix to be used for parameters and output filename (Default: MIPI): ";
chomp ($file_name = <STDIN>);
if ($file_name eq  "")
{
   $file_name = MIPI;
}
open (output, ">${file_name}_sTAP_soc_param_values.inc");
open (output1, ">tb_param.inc");
open (output2, ">${file_name}_sTAP_soc_param_overide.inc");

print output "//------------------------------------------------------------------------------\n";
print output "//  INTEL CONFIDENTIAL\n";
print output "//\n";
print output "//  Copyright 2016 Intel Corporation All Rights Reserved.\n";
print output "//\n";
print output "//  The source code contained or described herein and all documents related\n";
print output "//  to the source code (Material) are owned by Intel Corporation or its\n";
print output "//  suppliers or licensors. Title to the Material remains with Intel\n";
print output "//  Corporation or its suppliers and licensors. The Material contains trade\n";
print output "//  secrets and proprietary and confidential information of Intel or its\n";
print output "//  suppliers and licensors. The Material is protected by worldwide copyright\n";
print output "//  and trade secret laws and treaty provisions. No part of the Material may\n";
print output "//  be used, copied, reproduced, modified, published, uploaded, posted,\n";
print output "//  transmitted, distributed, or disclosed in any way without Intel's prior\n";
print output "//  express written permission.\n";
print output "//\n";
print output "//  No license under any patent, copyright, trade secret or other intellectual\n";
print output "//  property right is granted to or conferred upon you by disclosure or\n";
print output "//  delivery of the Materials, either expressly, by implication, inducement,\n";
print output "//  estoppel or otherwise. Any license under such intellectual property rights\n";
print output "//  must be express and approved by Intel in writing.\n";
print output "//\n";
print output "//  Collateral Description:\n";
print output "//  %header_collateral%\n";
print output "//\n";
print output "//  Source organization:\n";
print output "//  %header_organization%\n";
print output "//\n";
print output "//  Support Information:\n";
print output "//  %header_support%\n";
print output "//\n";
print output "//  Revision:\n";
print output "//  %header_tag%\n";
print output "//\n";
print output "//  Module <sTAP> :  < put your functional description here in plain text >\n";
print output "//\n";
print output "//------------------------------------------------------------------------------\n";
print output "\n";
print output "//----------------------------------------------------------------------------------------\n";
print output "// NOTE: Log history is at end of file.\n";
print output "//----------------------------------------------------------------------------------------\n";
print output "//\n";
print output "//    FILENAME    : stap_params_include.inc\n";
print output "//    DESIGNER    : Rakesh Kandula\n";
print output "//    PROJECT     : sTAP\n";
print output "//    PURPOSE     : sTAP RTL Parameters\n";
print output "//    DESCRIPTION :\n";
print output "//       This is a RTL parameter file. Please refer IG for more details.\n";
print output "//----------------------------------------------------------------------------------------\n";
print output "//    PARAMETERS  :\n";
print output "//\n";
print output "//    STAP_SIZE_OF_EACH_INSTRUCTION\n";
print output "//       This parameter specifies the width of instruction register in STAP.\n";
print output "//\n";
print output "//    STAP_SWCOMP_ACTIVE\n";
print output "//       This parameter specifies whether SWCOMP is active in STAP or not.\n";
print output "//\n";
print output "//    STAP_SWCOMP_NUM_OF_COMPARE_BITS\n";
print output "//       This parameter specifies the number of compare bits present in the SWCOMP compare window\n";
print output "//\n";
print output "//    STAP_ENABLE_TDO_POS_EDGE\n";
print output "//       There is one exception to this rule for a re-time TAP. A re-time TAP\n";
print output "//       may output TDO to be clocked on the rising edge of TCK. This can only\n";
print output "//       be applied at a Region DFx Unit or a Cluster DFx Unit’s level of hierarchy. \n"; 
print output "//       If this parameter is high TDO is flopped on the rising edge of TCK\n";
print output "//       else if this parameter is LOW TDO is flopped on the falling edge of TCK.\n";
print output "//\n";
print output "//    STAP_ENABLE_BSCAN\n";
print output "//       This parameter enables the Bounday scan operation in sTAP. Unlike CLTAP, this\n";
print output "//       feature is optional in sTAP\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_MANDATORY_REGISTERS\n";
print output "//       This parameter specifies the number of mandatory registers in STAP.\n";
print output "//       This is not a user definable parameter and its value is fixed to either 2 or 12,\n";
print output "//       as BYPASS, IDCODE are the real mandatory registers, but Boundary Scan Registers\n";
print output "//       also get added if BSCAN is enabled in STAP. All other registers are optional.\n";
print output "//\n";
print output "//    STAP_SECURE_GREEN\n";
print output "//       Opcdes that are visible to all customers. Like SLVIDCODE, BYPASS, BSCAN.\n";
print output "//\n";
print output "//    STAP_SECURE_ORANGE\n";
print output "//       Opcdes that are visible to selected customers.\n";
print output "//\n";
print output "//    STAP_SECURE_RED\n";
print output "//       Opcdes that are visible only to Intel.\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK\n";
print output "//       This parameter specifies the number of TAPs that could be present\n";
print output "//       in a TAP NETWORK. This includes the number of STAPs that become part of\n";
print output "//       TAP NETWORK on a STAP\n";
print output "//       This parameter specifies the width of register atap_secsel and tapc_select\n";
print output "//\n";
print output "//    STAP_DFX_SECURE_POLICY_SELECTREG\n";
print output "//       This parameter determines the policy settings of TAPs on Network.\n";
print output "//\n";
print output "//    STAP_ENABLE_TAPC_REMOVE\n";
print output "//       This is a 1-bit DR opcode that will enable the TAP TDI input to pass-thru\n";
print output "//       this TAP to the TAP.7 network. It will gate the internal TDI and TMS signals\n";
print output "//       to the FSM/logic block to logic 1. It will not even add the\n";
print output "//       one clock delay like BYPASS.\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_WTAPS_IN_NETWORK\n";
print output "//       This parameter specifies the number of WTAPs that could be present in a\n";
print output "//       WTAP NETWORK on a STAP\n";
print output "//       This parameter specifies the width of register atap_wtapnw_selectwir.\n";
print output "//\n";
print output "//    STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL\n";
print output "//       This parameter will help us to identify whether the WTAPs on\n";
print output "//       a WTAP NETWORK are connected serially or parallely. Also this helps in\n";
print output "//       generation of necessary control signals for serial or parallel\n";
print output "//       stitching of WTAPs in the WTAP NETWORK\n";
print output "//\n";
print output "//    STAP_ENABLE_WTAP_CTRL_POS_EDGE\n";
print output "//       This parameter specifies when WTAP is enabled then to use the control\n";
print output "//       signals like stap_fsm_capture_dr and stap_fsm_shift_dr on positive edge clk\n";
print output "//       if this parameter is one or negative edge clk if paramater is zero.\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS\n";
print output "//       This parameter specifies the number of User-Defined Remote TEST DATA\n";
print output "//       Registers that the sTAP needs to generate address decode and controls for.\n";
print output "//\n";
print output "//    STAP_ENABLE_RTDR_PROG_RST\n";
print output "//       This parameter specifies the programmable reset option for RTDRs. If the\n";
print output "//       value of this parameter is set to one, then the TAPC_RTDRRSTSEL  &\n";
print output "//       TAPC_TDRRSTEN registers comes into existance. The user has to program\n";
print output "//       which register has the programmable reset option by writing 1 to the\n";
print output "//       corresponding bit position for each of the RTDRs in TAPC_RTDRRSTSEL\n";
print output "//       register. Which programmable reset is applicable would be decided by the\n";
print output "//       value programmed on TAPC_TDRRSTEN register.\n";
print output "//\n";
print output "//    STAP_RTDR_IS_BUSSED\n";
print output "//       This parameter specifies whether the User-Defined Remote TEST DATA Registers\n";
print output "//       related pins are bussed or not.\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_TEST_DATA_REGISTERS\n";
print output "//       This parameter specifies the number of User-Defined Optional TEST DATA\n";
print output "//       Registers that are present in the STAP\n";
print output "//\n";
print output "//    STAP_ENABLE_ITDR_PROG_RST\n";
print output "//       This parameter specifies the programmable reset option for ITDRs. If the\n";
print output "//       value of this parameter is set to one, then the TAPC_ITDRRSTSEL  &\n";
print output "//       TAPC_TDRRSTEN registers comes into existance. The user has to program\n";
print output "//       which register has the programmable reset option by writing 1 to the\n";
print output "//       corresponding bit position for each of the iTDRs in TAPC_ITDRRSTSEL\n";
print output "//       register. Which programmable reset is applicable would be decided by the\n";
print output "//       value programmed on TAPC_TDRRSTEN register.\n";
print output "//\n";
print output "//    STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS\n";
print output "//       This parameter specifies the combined total widths of all the User-Defined Optional\n";
print output "//       TEST DATA Registers that are present in the STAP\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_TOTAL_REGISTERS\n";
print output "//       This is local parameter used to calculate the total number of register\n";
print output "//       that could be present in STAP\n";
print output "//\n";
print output "//    STAP_INSTRUCTION_FOR_DATA_REGISTERS\n";
print output "//       This parameter provides the instruction opcode for all the registers\n";
print output "//       (mandatory + optional) that are present in the STAP\n";
print output "//\n";
print output "//    STAP_NUMBER_OF_BITS_FOR_SLICE\n";
print output "//       This parameter is used as a reference to generate and identify widths of\n";
print output "//       all the register in STAP. This is not a user definable parameter and its\n";
print output "//       value is fixed at 16.\n";
print output "//\n";
print output "//    STAP_SIZE_OF_EACH_TEST_DATA_REGISTER\n";
print output "//       This parameter provides the width of each User-Defined Optional\n";
print output "//       TEST DATA Registers\n";
print output "//\n";
print output "//    STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS\n";
print output "//       This parameter provides the MSB bit position for each of the User-Defined\n";
print output "//       Optional TEST DATA Registers\n";
print output "//\n";
print output "//    STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS\n";
print output "//       This parameter provides the LSB bit position for each of the User-Defined\n";
print output "//       Optional TEST DATA Registers\n";
print output "//\n";
print output "//    STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS\n";
print output "//       This parameter provides the RESET values for each of the User-Defined\n";
print output "//       Optional TEST DATA Registers\n";
print output "//\n";
print output "//    STAP_DFX_NUM_OF_FEATURES_TO_SECURE\n";
print output "//       The minimum number of features to secure is one Although, theoretically\n";
print output "//       it can be any number of features but it is likely to be in an single digits\n";
print output "//\n";
print output "//    STAP_DFX_SECURE_WIDTH\n";
print output "//       This parameter is fixed at 4 for the 14nm chassis generation (Chassis Gen3)\n";
print output "//\n";
print output "//    STAP_DFX_EARLYBOOT_FEATURE_ENABLE\n";
print output "//       This parameter sets the hard coded value for the early debug window for this\n"; 
print output "//       agent/IP-block. For most IP-blocks this will be VISA green only. However, \n";
print output "//       there are in the suspend (SUS) well IPs that require full access.\n";
print output "//       Most IPs:\n";
print output "//       DFX_EARLYBOOT_FEATURE_ENABLE[1:0] = VISA_GREEN\n";
print output "//       DFX_EARLYBOOT_FEATURE_ENABLE[DFX_NUM_OF_FEATURES_TO_SECURE+1 : 2] = \n";
print output "//       {[DFX_NUM_OF_FEATURES_TO_SECURE:2]}{1'b0}}\n";
print output "//\n";
print output "//    STAP_DFX_SECURE_POLICY_MATRIX\n";
print output "//       This parameter determines the lookup table necessary to assign the\n";
print output "//       appropriate policy with the DFx feature(s) including VISA access\n";
print output "//\n";
print output "//    STAP_WTAPCTRL_RESET_VALUE\n";
print output "//       This parameter sets the default value for the STAP_WTAP_CTL register. It is based on the number of WTAPs.\n";
print output "//       This value is only pratical for one WTAP controlled by a sTAP\n";
print output "//----------------------------------------------------------------------------------------\n";
print output "\n";

print "\nEnter the clock period (Integer Value in ps, only for testbench) (Default: 10000ps): ";
chomp ($CLK_PERIOD = <STDIN>);
if ($CLK_PERIOD eq  "")
{
   $CLK_PERIOD = 10000;
}

$STAP_NUMBER_OF_BITS_FOR_SLICE = 16;

print "\nEnter the Size of Instruction Register (Integer Value >= 8, Default: 8): ";
chomp ($STAP_SIZE_OF_EACH_INSTRUCTION = <STDIN>);
#until ($STAP_SIZE_OF_EACH_INSTRUCTION =~ m/^$/ or $STAP_SIZE_OF_EACH_INSTRUCTION =~ m/[1-9]/ or $STAP_SIZE_OF_EACH_INSTRUCTION < 8)
until ($STAP_SIZE_OF_EACH_INSTRUCTION =~ m/^$/ or $STAP_SIZE_OF_EACH_INSTRUCTION =~ m/[1-9]/)
{
   print "Not a valid value, Please enter the Size of Instruction Register (Integer Value >= 8, Default: 8): ";
   chomp ($STAP_SIZE_OF_EACH_INSTRUCTION = <STDIN>);
}
if ($STAP_SIZE_OF_EACH_INSTRUCTION eq  "")
{
   $STAP_SIZE_OF_EACH_INSTRUCTION = 8;
}
print output "parameter ${file_name}_STAP_SIZE_OF_EACH_INSTRUCTION = $STAP_SIZE_OF_EACH_INSTRUCTION;\n";

$STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE = 3;
$STAP_DFX_SECURE_WIDTH = 4;
$STAP_SECURE_GREEN  = STAP_SECURE_GREEN;
$STAP_SECURE_ORANGE = STAP_SECURE_ORANGE;
$STAP_SECURE_RED    = STAP_SECURE_RED;

print "\nEnter the value of STAP_WTAPCTRL_RESET_VALUE ( Default: 0 ): "; 
chomp ($STAP_WTAPCTRL_RESET_VALUE = <STDIN>);
until ($STAP_WTAPCTRL_RESET_VALUE =~ m/^$/ or $STAP_WTAPCTRL_RESET_VALUE =~ m/[0-1]/)
{
   print "Not a valid entry, Please enter 1 or 0: Default: 0: ";
   chomp ($STAP_WTAPCTRL_RESET_VALUE = <STDIN>);
}

if ($STAP_WTAPCTRL_RESET_VALUE eq "")
{
   $STAP_WTAPCTRL_RESET_VALUE = 0;
}


print output "parameter ${file_name}_STAP_WTAPCTRL_RESET_VALUE = $STAP_WTAPCTRL_RESET_VALUE;";


print "\nDo you want to enable SWCOMP (1 for yes, 0 for no, Default: 0 ): "; 
chomp ($STAP_SWCOMP_ACTIVE = <STDIN>);
until ($STAP_SWCOMP_ACTIVE =~ m/^$/ or $STAP_SWCOMP_ACTIVE =~ m/[0-1]/)
{
   print "Not a valid entry, Please enter '1 for yes' (to enable SWCOMP) or '0 for no'; Default: 0: ";
   chomp ($STAP_SWCOMP_ACTIVE = <STDIN>);
}

if ($STAP_SWCOMP_ACTIVE eq "")
{
   $STAP_SWCOMP_ACTIVE = 0;
}


print output "\n";
print output "parameter ${file_name}_STAP_SWCOMP_ACTIVE = $STAP_SWCOMP_ACTIVE;\n";


if($STAP_SWCOMP_ACTIVE == 1)
{
   print "\nEnter the number of compare bits in the comparator window for SWCOMP between 8 and 32, (Default: 10): "; 
   chomp ($STAP_SWCOMP_NUM_OF_COMPARE_BITS = <STDIN>);
   my ($lower, $upper) = (8, 32);
   
   until (($STAP_SWCOMP_NUM_OF_COMPARE_BITS =~ m/^$/)or (($STAP_SWCOMP_NUM_OF_COMPARE_BITS >= $lower) and ($STAP_SWCOMP_NUM_OF_COMPARE_BITS <= $upper)))
   {
      print "Not a valid entry, Please enter a integer value between 8 and 32; Default: 10: ";
      chomp ($STAP_SWCOMP_NUM_OF_COMPARE_BITS= <STDIN>);
   }
   
   if ($STAP_SWCOMP_NUM_OF_COMPARE_BITS eq "")
   {
      $STAP_SWCOMP_NUM_OF_COMPARE_BITS = 10;
   }
   
   
   print output "parameter ${file_name}_STAP_SWCOMP_NUM_OF_COMPARE_BITS = $STAP_SWCOMP_NUM_OF_COMPARE_BITS;\n";
}
else
{
   print output "parameter ${file_name}_STAP_SWCOMP_NUM_OF_COMPARE_BITS = 10;\n";
}
print "\nDo you want to SUPRESS UPDATE and CAPTURE (1 for yes, 0 for no, Default: 0 ): "; 
chomp ($STAP_SUPPRESS_UPDATE_CAPTURE = <STDIN>);
until ($STAP_SUPPRESS_UPDATE_CAPTURE =~ m/^$/ or $STAP_SUPPRESS_UPDATE_CAPTURE =~ m/[0-1]/)
{
   print "Not a valid entry, Please enter '1 for yes' (to enable SUPRESS UPDATE and CAPTURE) or '0 for no'; Default: 0: ";
   chomp ($STAP_SUPPRESS_UPDATE_CAPTURE = <STDIN>);
}

if ($STAP_SUPPRESS_UPDATE_CAPTURE eq "")
{
   $STAP_SUPPRESS_UPDATE_CAPTURE = 0;
}


print output "\n";
print output "parameter ${file_name}_STAP_SUPPRESS_UPDATE_CAPTURE = $STAP_SUPPRESS_UPDATE_CAPTURE;\n";
print "\nDo you want to enable TDO to change on posedge(Re-time) (1 for yes, 0 for no, Default: 0): ";
chomp ($STAP_ENABLE_TDO_POS_EDGE = <STDIN>);
until ($STAP_ENABLE_TDO_POS_EDGE =~ m/^$/ or $STAP_ENABLE_TDO_POS_EDGE =~ m/[0-1]/)
{
   print "Not a valid entry, Please enter '1 for yes' (to enable TDO to change on posedge/Re-time) or '0 for no'; Default: 0: ";
   chomp ($STAP_ENABLE_TDO_POS_EDGE = <STDIN>);
}
if ($STAP_ENABLE_TDO_POS_EDGE eq "")
{
   $STAP_ENABLE_TDO_POS_EDGE = 0;
}
print output "parameter ${file_name}_STAP_ENABLE_TDO_POS_EDGE = $STAP_ENABLE_TDO_POS_EDGE;\n";

if ($STAP_ENABLE_TDO_POS_EDGE == 1)
{
   print "\nWhen TDO on posedge/Re-time tap is enabled then Boundary scan option is disabled.";
   print output "\n";
   print output "parameter ${file_name}_STAP_ENABLE_BSCAN = 0;\n";
}
else
{
   print "\nDo you have boundary scan registers (1 for yes, 0 for no, Default: 0): ";
   chomp ($STAP_ENABLE_BSCAN = <STDIN>);
   until ($STAP_ENABLE_BSCAN =~ m/^$/ or $STAP_ENABLE_BSCAN =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter '1 for yes' (if you have boundary scan registers) or '0 for no'; Default: 0: ";
      chomp ($STAP_ENABLE_BSCAN = <STDIN>);
   }
   if ($STAP_ENABLE_BSCAN eq  "")
   {
      $STAP_ENABLE_BSCAN = 0;
   }
   print output "\n";
   print output "parameter ${file_name}_STAP_ENABLE_BSCAN = $STAP_ENABLE_BSCAN;\n";
}

if ($STAP_ENABLE_BSCAN == 1)
{
   $STAP_NUMBER_OF_MANDATORY_REGISTERS = 12;
   $LENGTH_OF_BSCAN_CHAIN = 3;
}
else 
{
   $STAP_NUMBER_OF_MANDATORY_REGISTERS = 2;
   $LENGTH_OF_BSCAN_CHAIN = 3;
}




print output "parameter ${file_name}_STAP_NUMBER_OF_MANDATORY_REGISTERS = $STAP_NUMBER_OF_MANDATORY_REGISTERS;\n";
print output "\n";
print output "parameter ${file_name}_STAP_SECURE_GREEN  = 2'b00;\n";
print output "parameter ${file_name}_STAP_SECURE_ORANGE = 2'b01;\n";
print output "parameter ${file_name}_STAP_SECURE_RED    = 2'b10;\n";
print output "\n";

if ($STAP_ENABLE_TDO_POS_EDGE == 1)
{
   print "\nWhen TDO on posedge/Re-time tap is enabled then TAP Network on this TAP is disabled.";
   $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0;
}
else
{
   print "\nEntering a non-zero value will enable the TAP Network on this TAP\n";
   print "Enter the number of Slave Taps in the TAP Network (Integer Value, Default: 0): ";
   chomp ($STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = <STDIN>);
   until ($STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK =~ m/^$/ or $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK =~ m/[0-9]/)
   {
      print "Not a valid entry, Please enter the number of Slave Taps in the TAP Network (Integer Value, Default: 0): ";
      chomp ($STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = <STDIN>);
   }
   if ($STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK eq  "")
   {
      $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0;
   }
}

if ($STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0)
{
   $STAP_ENABLE_TAP_NETWORK = 0;
}
else
{
   $STAP_ENABLE_TAP_NETWORK = 1;
   for ($i = 0; $i <= $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK - 1; $i++)
   {
      COLOR_NW_LOOP:print "Enter the Network Security (g for green, o for orange, r for red) of TAP_", $i, " (Alphabetical Value, Default: green): ";
      chomp($colornwaddress[$i] = <STDIN>);
      until ($colornwaddress[$i] =~ m/^$/ or $colornwaddress[$i] =~ m/[gorGOR]/)
      {
         print "Not a valid value, enter the Network Security (g for green, o for orange, r for red) of TAP_", $i, " again (Alphabetical Value, Default: green): ";
         chomp ($colornwaddress[$i] = <STDIN>);
      }
      if ($colornwaddress[$i] eq  "")
      {
         $colornwaddress[$i] = g;
      }
   }
}

if ($STAP_ENABLE_TAP_NETWORK == 0)
{
   $STAP_NUMBER_OF_TAP_SELECT_REGISTERS = 0;
   $STAP_ENABLE_TAPC_SEC_SEL = 0;
}
else
{
   $STAP_NUMBER_OF_TAP_SELECT_REGISTERS = 1;
   $STAP_ENABLE_TAPC_SEC_SEL = 1;

   if ($STAP_ENABLE_TAPC_SEC_SEL == 0)
   {
      $SIZE_OF_SEC_SEL = 0;
   }
   else
   {
      $SIZE_OF_SEC_SEL = $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK;
   }
}
print output "parameter ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK;\n";
if ($STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0)
{
   print output "parameter [((2 * ((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK)) - 1) : 0] ${file_name}_STAP_DFX_SECURE_POLICY_SELECTREG = {\n";
   print output "$STAP_SECURE_GREEN\n";
   print output "};\n";
}
else
{
   print output "parameter [((2 * ((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK)) - 1) : 0] ${file_name}_STAP_DFX_SECURE_POLICY_SELECTREG = {\n";
   for ($i = $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK - 1; $i >= 0; $i--)
   {
      if($i == 0)
      {
         if(($colornwaddress[$i] eq r) || ($colornwaddress[$i] eq R))
         {
            $colornwaddress[$i] = STAP_SECURE_RED;
            print output $colornwaddress[$i],   "     //Network Security for TAP$i\n";
         }
         if(($colornwaddress[$i] eq o) || ($colornwaddress[$i] eq O))
         {
            $colornwaddress[$i] = STAP_SECURE_ORANGE;
            print output $colornwaddress[$i],   "  //Network Security for TAP$i\n";
         }
         if(($colornwaddress[$i] eq g) || ($colornwaddress[$i] eq G))
         {
            $colornwaddress[$i] = STAP_SECURE_GREEN;
            print output $colornwaddress[$i],   "   //Network Security for TAP$i\n";
         }
      }
      else
      {
         if(($colornwaddress[$i] eq r) || ($colornwaddress[$i] eq R))
         {
            $colornwaddress[$i] = STAP_SECURE_RED;
            print output $colornwaddress[$i],",",   "    //Network Security for TAP$i\n";
         }
         if(($colornwaddress[$i] eq o) || ($colornwaddress[$i] eq O))
         {
            $colornwaddress[$i] = STAP_SECURE_ORANGE;
            print output $colornwaddress[$i],",",   " //Network Security for TAP$i\n";
         }
         if(($colornwaddress[$i] eq g) || ($colornwaddress[$i] eq G))
         {
            $colornwaddress[$i] = STAP_SECURE_GREEN;
            print output $colornwaddress[$i],",",   "  //Network Security for TAP$i\n";
         }
      }
   }
   print output "};\n";
}

if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   print "\nDo you want to include Remove bit logic (1 for yes, 0 for no, Default: 0): ";
   chomp ($STAP_ENABLE_TAPC_REMOVE = <STDIN>);
   until ($STAP_ENABLE_TAPC_REMOVE =~ m/^$/ or $STAP_ENABLE_TAPC_REMOVE =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter Do you want to include Remove bit logic (1 for yes, 0 for no, Default: 0): ";
      chomp ($STAP_ENABLE_TAPC_REMOVE = <STDIN>);
   }
   if ($STAP_ENABLE_TAPC_REMOVE eq  "")
   {
      $STAP_ENABLE_TAPC_REMOVE = 0;
   }
}
else
{
   $STAP_ENABLE_TAPC_REMOVE = 0;
}
print output "parameter ${file_name}_STAP_ENABLE_TAPC_REMOVE = $STAP_ENABLE_TAPC_REMOVE;\n";
print output "\n";

if ($STAP_ENABLE_TDO_POS_EDGE == 1)
{
   print "\nWhen TDO on posedge/Re-time tap is enabled then WTAP Network on this TAP is disabled.";
   $STAP_NUMBER_OF_WTAPS_IN_NETWORK = 0;
}
else
{
   print "\nEntering a non-zero value will enable the WTAP Network on this TAP\n";
   print "Enter the number of WTAPS in the WTAP Network (Integer Value, Default: 0): ";
   chomp ($STAP_NUMBER_OF_WTAPS_IN_NETWORK = <STDIN>);
   until ($STAP_NUMBER_OF_WTAPS_IN_NETWORK =~ m/^$/ or $STAP_NUMBER_OF_WTAPS_IN_NETWORK =~ m/[0-9]/)
   {
      print "Not a valid entry, Please enter the number of WTAPS in the WTAP Network (Integer Value, Default: 0): ";
      chomp ($STAP_NUMBER_OF_WTAPS_IN_NETWORK = <STDIN>);
   }
   if ($STAP_NUMBER_OF_WTAPS_IN_NETWORK eq  "")
   {
      $STAP_NUMBER_OF_WTAPS_IN_NETWORK = 0;
   }
}
if ($STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0)
{
   $STAP_ENABLE_WTAP_NETWORK = 0;
}
else
{
   $STAP_ENABLE_WTAP_NETWORK = 1;
}

if ($STAP_ENABLE_WTAP_NETWORK == 0)
{
   $STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS = 0;
   $STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;
   $STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0;
}
else
{
   $STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS = 1;
   print "Do you wish to have a SERIAL WTAP network or a PARALLEL WTAP network (1 for Series, 0 for Parallel, Default: 0): ";
   chomp ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = <STDIN>);
   until ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL =~ m/^$/ or $STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter Do you wish to have a SERIAL WTAP network or a PARALLEL WTAP network (1 for Series, 0 for Parallel, Default: 0): ";
      chomp ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = <STDIN>);
   }
   if ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL eq  "")
   {
      $STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;
   }
   print "Which edge do you want WTAP Control signals (1 for POS Edge, 0 for NEG Edge, Default: 0): ";
   chomp ($STAP_ENABLE_WTAP_CTRL_POS_EDGE = <STDIN>);
   until ($STAP_ENABLE_WTAP_CTRL_POS_EDGE =~ m/^$/ or $STAP_ENABLE_WTAP_CTRL_POS_EDGE =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter Which edge do you want WTAP Control signals (1 for POS Edge, 0 for NEG Edge, Default: 0): ";
      chomp ($STAP_ENABLE_WTAP_CTRL_POS_EDGE = <STDIN>);
   }
   if ($STAP_ENABLE_WTAP_CTRL_POS_EDGE eq  "")
   {
      $STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0;
   }
}
print output "parameter ${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK = $STAP_NUMBER_OF_WTAPS_IN_NETWORK;\n";
print output "parameter ${file_name}_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = $STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL;\n";
print output "parameter ${file_name}_STAP_ENABLE_WTAP_CTRL_POS_EDGE = $STAP_ENABLE_WTAP_CTRL_POS_EDGE;\n";

print output "\n";
print "\n";

#######

print "\nEntering a non-zero value will enable the Remote Test Data Registers on this TAP\n";
print "Enter The number of remote test data registers (Integer Value, Default: 0): ";
chomp ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = <STDIN>);
   until ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS =~ m/^$/ or $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS =~ m/[0-9]/)
   {
      print "Not a valid entry, Please enter The number of remote test data registers(Integer Value, Default: 0): ";
      chomp ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = <STDIN>);
   }
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS eq  "")
{
   $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = 0;
}
print output "parameter ${file_name}_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS;\n";
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   $STAP_ENABLE_RTDR_PROG_RST = 0;
}
else
{
   print "Do you want Programmable Reset Enabled for RTDRs (1 for yes, 0 for no, Default: 0): ";
   chomp ($STAP_ENABLE_RTDR_PROG_RST = <STDIN>);
   until ($STAP_ENABLE_RTDR_PROG_RST =~ m/^$/ or $STAP_ENABLE_RTDR_PROG_RST =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter Do you want Programmable Reset Enabled for RTDRs (1 for yes, 0 for no, Default: 0): ";
      chomp ($STAP_ENABLE_RTDR_PROG_RST = <STDIN>);
   }
   if ($STAP_ENABLE_RTDR_PROG_RST eq  "")
   {
      $STAP_ENABLE_RTDR_PROG_RST = 0;
   }
}
print output "parameter ${file_name}_STAP_ENABLE_RTDR_PROG_RST = $STAP_ENABLE_RTDR_PROG_RST;\n";
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS < 2)
{
   print output "parameter ${file_name}_STAP_RTDR_IS_BUSSED = 0;\n";
}
else
{
   print "Do you want the bussed remote test data register pins (1 for yes, 0 for no, Default: 0): ";
   chomp ($STAP_RTDR_IS_BUSSED = <STDIN>);
   until ($STAP_RTDR_IS_BUSSED =~ m/^$/ or $STAP_RTDR_IS_BUSSED =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter Do you want the bussed remote test data register pins (1 for yes, 0 for no, Default: 0): ";
      chomp ($STAP_RTDR_IS_BUSSED = <STDIN>);
   }
   if ($STAP_RTDR_IS_BUSSED eq  "")
   {
      $STAP_RTDR_IS_BUSSED = 0;
   }
   print output "parameter ${file_name}_STAP_RTDR_IS_BUSSED = $STAP_RTDR_IS_BUSSED;\n";
}

if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   $STAP_ENABLE_REMOTE_TEST_DATA_REGISTER = 0;
}
else
{
   $STAP_ENABLE_REMOTE_TEST_DATA_REGISTER = 1;
}

if ($STAP_ENABLE_REMOTE_TEST_DATA_REGISTER == 1)
{
   DW_LOOP1:for ($i = 0; $i <= $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1 ; $i++)
   {
      print "Enter the Address of Remote_test_data_register_",$i." (Hex Value): ";
      chomp ($rem_address[$i] = <STDIN>);
      if ($rem_address[$i] eq  "")
      {
         print "The Address can not be empty. Please re-enter Address of all Remote TDRs!!\n";
         goto DW_LOOP1;
      }

      for ($j = 0; $j < $i; $j++)
      {
         if ($rem_address[$j] eq "$rem_address[$i]")
         {
            print "The Address entered by you is matching with REMOTE_TEST_DATA_REGISTER_", $j, "!!\n";
            print "Please re-enter Address of all Remote TDRs!!\n";
            goto DW_LOOP1;
         }
      }
      until ($rem_address[$i] =~ m/^$/ or $rem_address[$i] =~ m/[0-9A-Fa-f]/)
      {
         print "Not a valid value, enter the Address of Test_Data_Register_", $i, " again (Hex Value): ";
         chomp ($rem_address[$i] = <STDIN>);
         print "\n";
      }

      if (($rem_address[$i] eq "00") || ($rem_address[$i] eq "0") || ($rem_address[$i] eq "01") || ($rem_address[$i] eq "1") || ($rem_address[$i] eq "02") || ($rem_address[$i] eq "2") || ($rem_address[$i] eq "03") || ($rem_address[$i] eq "3") || ($rem_address[$i] eq "04") || ($rem_address[$i] eq "4") || ($rem_address[$i] eq "05") || ($rem_address[$i] eq "5") || ($rem_address[$i] eq "06") || ($rem_address[$i] eq "6") || ($rem_address[$i] eq "07") || ($rem_address[$i] eq "7") || ($rem_address[$i] eq "08") || ($rem_address[$i] eq "8") || ($rem_address[$i] eq "09") || ($rem_address[$i] eq "9") || ($rem_address[$i] eq "0A") || ($rem_address[$i] eq "A") || ($rem_address[$i] eq "0a") || ($rem_address[$i] eq "a") || ($rem_address[$i] eq "0B") || ($rem_address[$i] eq "B") || ($rem_address[$i] eq "0b") || ($rem_address[$i] eq "b") || ($rem_address[$i] eq "0C") || ($rem_address[$i] eq "C") || ($rem_address[$i] eq "0c") || ($rem_address[$i] eq "c") || ($rem_address[$i] eq "0D") || ($rem_address[$i] eq "D") || ($rem_address[$i] eq "0d") || ($rem_address[$i] eq "d") || ($rem_address[$i] eq "0E") || ($rem_address[$i] eq "E") || ($rem_address[$i] eq "0e") || ($rem_address[$i] eq "e") || ($rem_address[$i] eq "0F") || ($rem_address[$i] eq "F") || ($rem_address[$i] eq "0f") || ($rem_address[$i] eq "f") || ($rem_address[$i] eq "10") || ($rem_address[$i] eq "11") || ($rem_address[$i] eq "12") || ($rem_address[$i] eq "13") || ($rem_address[$i] eq "14") || ($rem_address[$i] eq "15") || ($rem_address[$i] eq "16") || ($rem_address[$i] eq "17") || ($rem_address[$i] eq "18") || ($rem_address[$i] eq "19") || ($rem_address[$i] eq "1A") || ($rem_address[$i] eq "1a") || ($rem_address[$i] eq "1B") || ($rem_address[$i] eq "1b") || ($rem_address[$i] eq "1C") || ($rem_address[$i] eq "1c") || ($rem_address[$i] eq "1D") || ($rem_address[$i] eq "1d") || ($rem_address[$i] eq "1E") || ($rem_address[$i] eq "1e") || ($rem_address[$i] eq "1F") || ($rem_address[$i] eq "1f") || ($rem_address[$i] eq "20") || ($rem_address[$i] eq "21") || ($rem_address[$i] eq "22") || ($rem_address[$i] eq "23") || ($rem_address[$i] eq "24") || ($rem_address[$i] eq "25") || ($rem_address[$i] eq "26") || ($rem_address[$i] eq "27") || ($rem_address[$i] eq "28") || ($rem_address[$i] eq "29") || ($rem_address[$i] eq "2A") || ($rem_address[$i] eq "2a") || ($rem_address[$i] eq "2B") || ($rem_address[$i] eq "2b") || ($rem_address[$i] eq "2C") || ($rem_address[$i] eq "2c") || ($rem_address[$i] eq "2D") || ($rem_address[$i] eq "2d") || ($rem_address[$i] eq "2E") || ($rem_address[$i] eq "2e") || ($rem_address[$i] eq "2F") || ($rem_address[$i] eq "2f"))
      {
         print "The address cannot be one of the mandatory registers\n";
         goto DW_LOOP1;
      }
      COLOR_RTDR_LOOP:
      print "Enter the Color(g for green, o for orange, r for red) of Remote_test_data_register_",$i." (Alphabetical Value, Default: green): ";
      chomp ($colorrtdraddress[$i] = <STDIN>);
      until ($colorrtdraddress[$i] =~ m/^$/ or $colorrtdraddress[$i] =~ m/[gorGOR]/)
      {
         print "Not a valid value, enter colors (g for green, o for orange, r for red) of Remote_Test_Data_Register_", $i, " again (Alphabetical Value, Default: green): ";
         chomp ($colorrtdraddress[$i] = <STDIN>);
         print "\n";
      }
      if ($colorrtdraddress[$i] eq  "")
      {
         $colorrtdraddress[$i] = g;
      }
   }
}
print output "\n";

#######

print "\nEntering a non-zero value will enable the Internal TEST DATA Registers on this TAP\n";
print "Enter the number of TEST DATA REGISTERS (Integer Value, Default: 0): ";
chomp($STAP_NUMBER_OF_TEST_DATA_REGISTERS = <STDIN>);
until ($STAP_NUMBER_OF_TEST_DATA_REGISTERS =~ m/^$/ or $STAP_NUMBER_OF_TEST_DATA_REGISTERS =~ m/[0-9]/)
{
   print "Not a valid entry, Please enter Enter the number of TEST DATA REGISTERS(Integer Value, Default: 0): ";
   chomp ($STAP_NUMBER_OF_TEST_DATA_REGISTERS = <STDIN>);
}
if ($STAP_NUMBER_OF_TEST_DATA_REGISTERS eq  "")
{
   $STAP_NUMBER_OF_TEST_DATA_REGISTERS = 0;
}
if ($STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0)
{
   $STAP_ENABLE_ITDR_PROG_RST = 0;
}
else
{
   print "Do you want Programmable Reset Enabled for iTDRs (1 for yes, 0 for no, Default: 0): ";
   chomp ($STAP_ENABLE_ITDR_PROG_RST = <STDIN>);
   until ($STAP_ENABLE_ITDR_PROG_RST =~ m/^$/ or $STAP_ENABLE_ITDR_PROG_RST =~ m/[0-1]/)
   {
      print "Not a valid entry, Please enter Do you want Programmable Reset Enabled for iTDRs (1 for yes, 0 for no, Default: 0): ";
      chomp ($STAP_ENABLE_ITDR_PROG_RST = <STDIN>);
   }
   if ($STAP_ENABLE_ITDR_PROG_RST eq  "")
   {
      $STAP_ENABLE_ITDR_PROG_RST = 0;
   }
}

if ($STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0)
{
   $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = 0;
}
if ($STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0)
{
   $STAP_ENABLE_TEST_DATA_REGISTERS = 0;
}
else
{
   $STAP_ENABLE_TEST_DATA_REGISTERS = 1;
}
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   for ($i = 0; $i <= $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i++)
   {
      DW_LOOP:print "Enter the Address of Test_Data_Regsiter_", $i, " (Hex Value): ";
      chomp($address[$i] = <STDIN>);
      for ($j = 0; $j < $i; $j++)
      {
         if ($address[$j] eq "$address[$i]")
         {
            print "The address entered by you is matching with TEST_DATA_REGISTER_", $j, "!!\n";
            goto DW_LOOP;
         }
      }
      for ($j = 0; $j < $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS; $j++)
      {
         if ($rem_address[$j] eq "$address[$i]")
         {
            print "The address entered by you is matching with REMOTE_TEST_DATA_REGISTER_", $j, "!!\n";
            goto DW_LOOP;
         }
      }
      until ($address[$i] =~ m/^$/ or $address[$i] =~ m/[0-9A-Fa-f]/)
      {
         print "Not a valid value, enter the Address of Test_Data_Regsiter_", $i, " again (Hex Value): ";
         chomp ($address[$i] = <STDIN>);
      }

      if (($address[$i] eq "00") || ($address[$i] eq "0") || ($address[$i] eq "01") || ($address[$i] eq "1") || ($address[$i] eq "02") || ($address[$i] eq "2") || ($address[$i] eq "03") || ($address[$i] eq "3") || ($address[$i] eq "04") || ($address[$i] eq "4") || ($address[$i] eq "05") || ($address[$i] eq "5") || ($address[$i] eq "06") || ($address[$i] eq "6") || ($address[$i] eq "07") || ($address[$i] eq "7") || ($address[$i] eq "08") || ($address[$i] eq "8") || ($address[$i] eq "09") || ($address[$i] eq "9") || ($address[$i] eq "0A") || ($address[$i] eq "A") || ($address[$i] eq "0a") || ($address[$i] eq "a") || ($address[$i] eq "0B") || ($address[$i] eq "B") || ($address[$i] eq "0b") || ($address[$i] eq "b") || ($address[$i] eq "0C") || ($address[$i] eq "C") || ($address[$i] eq "0c") || ($address[$i] eq "c") || ($address[$i] eq "0D") || ($address[$i] eq "D") || ($address[$i] eq "0d") || ($address[$i] eq "d") || ($address[$i] eq "0E") || ($address[$i] eq "E") || ($address[$i] eq "0e") || ($address[$i] eq "e") || ($address[$i] eq "0F") || ($address[$i] eq "F") || ($address[$i] eq "0f") || ($address[$i] eq "f") || ($address[$i] eq "10") || ($address[$i] eq "11") || ($address[$i] eq "12") || ($address[$i] eq "13") || ($address[$i] eq "14") || ($address[$i] eq "15") || ($address[$i] eq "16") || ($address[$i] eq "17") || ($address[$i] eq "18") || ($address[$i] eq "19") || ($address[$i] eq "1A") || ($address[$i] eq "1a") || ($address[$i] eq "1B") || ($address[$i] eq "1b") || ($address[$i] eq "1C") || ($address[$i] eq "1c") || ($address[$i] eq "1D") || ($address[$i] eq "1d") || ($address[$i] eq "1E") || ($address[$i] eq "1e") || ($address[$i] eq "1F") || ($address[$i] eq "1f") || ($address[$i] eq "20") || ($address[$i] eq "21") || ($address[$i] eq "22") || ($address[$i] eq "23") || ($address[$i] eq "24") || ($address[$i] eq "25") || ($address[$i] eq "26") || ($address[$i] eq "27") || ($address[$i] eq "28") || ($address[$i] eq "29") || ($address[$i] eq "2A") || ($address[$i] eq "2a") || ($address[$i] eq "2B") || ($address[$i] eq "2b") || ($address[$i] eq "2C") || ($address[$i] eq "2c") || ($address[$i] eq "2D") || ($address[$i] eq "2d") || ($address[$i] eq "2E") || ($address[$i] eq "2e") || ($address[$i] eq "2F") || ($address[$i] eq "2f"))
      {
         print "The address cannot be one of the mandatory registers\n";
         goto DW_LOOP;
      }
      COLOR_TDR_LOOP:print "Enter the Color(g for green, o for orange, r for red) of Test_Data_Regsiter_", $i, " (Alphabetical Value, Default: green): ";
      chomp($colortdraddress[$i] = <STDIN>);
      until ($colortdraddress[$i] =~ m/^$/ or $colortdraddress[$i] =~ m/[gorGOR]/)
      {
         print "Not a valid value, enter the colors (g for green, o for orange, r for red) of Test_Data_Regsiter_", $i, " again (Alphabetical Value, Default: green): ";
         chomp ($colortdraddress[$i] = <STDIN>);
      }
      if ($colortdraddress[$i] eq  "")
      {
         $colortdraddress[$i] = g;
      }
   }
}

print "\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   LOOP:for ($i = 0; $i <= $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i++)
   {
      LOOP1:print "Enter the width of TEST_DATA_REGISTER_", $i, " (Integer Value, Default: 1): ";
      chomp($dw[$i] = <STDIN>);
      until ($dw[$i] =~ /^$/ or ($dw[$i] =~ /^[0-9]+$/) )
      {
         print "Enter the width of TEST_DATA_REGISTER_", $i, " (Integer Value, Default: 1): ";
         chomp ($dw[$i] = <STDIN>);
      }
      if ($dw[$i] =~ /^$/)
      {
         $dw[$i] = 1;
         print "Do you want to proceed with default value (y for yes, n for no): ";
         $Decision = <STDIN>;
         if ($Decision =~ /y/)
         {
            goto LOOP2;
         }
         elsif ($Decision =~ /n/)
         {
            goto LOOP1;
         }
      }
      LOOP2:if ($dw[$i] < 1)
      {
         print "value cannot be less than 1\n\n";
         goto LOOP1;
      }
   }

   PROCEED_LOOP1:$sum = 0;
   for ($i = 0; $i <= $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i++)
   {
      $sum  = $sum + $dw[$i];
   }
   $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = $sum;
}

if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
{
   $STAP_ENABLE_PROG_RST = 1;
}
else
{
   $STAP_ENABLE_PROG_RST = 0;
}
print "\nEnter the TAP Color for opcodes you want to expose for EnDebug Policy (Policy6) (Available choices : r for red, o for orange, g for green, Default:r): ";
chomp ($SEC_POLICY_6_color = <STDIN>);
until ($SEC_POLICY_6_color =~ m/^$/ or $SEC_POLICY_6_color =~ m/[gorGOR]/)
{
   print "Not a valid value, enter colors (g for green, o for orange, r for red) again (Alphabetical Value, Default: g): ";
   chomp ($SEC_POLICY_6_color = <STDIN>);
   print "\n";
}
if ($SEC_POLICY_6_color eq  "")
{
   $SEC_POLICY_6_color = r;
}
if($SEC_POLICY_6_color eq g)
{
   $SEC_POLICY_6 = "001";
}
elsif($SEC_POLICY_6_color eq o)
{
   $SEC_POLICY_6 = "010";
}
else
{
   $SEC_POLICY_6 = "100";
}
if($STAP_SWCOMP_ACTIVE == 1)
{
$NO_OF_SWCOMP_REGISTERS = 2;
}
else
{
$NO_OF_SWCOMP_REGISTERS = 0;
}

print output "parameter ${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS = $STAP_NUMBER_OF_TEST_DATA_REGISTERS;\n";
print output "parameter ${file_name}_STAP_ENABLE_ITDR_PROG_RST = $STAP_ENABLE_ITDR_PROG_RST;\n";
print output "parameter ${file_name}_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS;\n";
print output "\n";
$STAP_NUMBER_OF_TOTAL_REGISTERS = $STAP_NUMBER_OF_MANDATORY_REGISTERS + $STAP_NUMBER_OF_TAP_SELECT_REGISTERS + $STAP_ENABLE_TAPC_SEC_SEL + $STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS + $STAP_NUMBER_OF_TEST_DATA_REGISTERS + $STAP_ENABLE_TAPC_REMOVE + $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS + $STAP_ENABLE_PROG_RST + $STAP_ENABLE_RTDR_PROG_RST + $STAP_ENABLE_ITDR_PROG_RST + $NO_OF_SWCOMP_REGISTERS+$STAP_SUPPRESS_UPDATE_CAPTURE;

print output "parameter ${file_name}_STAP_NUMBER_OF_TOTAL_REGISTERS = $STAP_NUMBER_OF_TOTAL_REGISTERS;\n";
print output "\n";
print output "parameter [(((${file_name}_STAP_SIZE_OF_EACH_INSTRUCTION + 2) * ${file_name}_STAP_NUMBER_OF_TOTAL_REGISTERS) - 1):0] ${file_name}_STAP_INSTRUCTION_FOR_DATA_REGISTERS = {\n";

for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
{
   if(($colorrtdraddress[$i] eq r) || ($colorrtdraddress[$i] eq R))
   {
      $colorrtdraddress[$i] = STAP_SECURE_RED;
      print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $rem_address[$i], ", ",$colorrtdraddress[$i],"},","    //Opcode for RTDR$i\n";
   }
   if(($colorrtdraddress[$i] eq o) || ($colorrtdraddress[$i] eq O))
   {
      $colorrtdraddress[$i] = STAP_SECURE_ORANGE;
      print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $rem_address[$i], ", ",$colorrtdraddress[$i],"},"," //Opcode for RTDR$i\n";
   }
   if(($colorrtdraddress[$i] eq g) || ($colorrtdraddress[$i] eq G))
   {
      $colorrtdraddress[$i] = STAP_SECURE_GREEN;
      print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $rem_address[$i], ", ",$colorrtdraddress[$i],"},","  //Opcode for RTDR$i\n";
   }
}

if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if(($colortdraddress[$i] eq r) || ($colortdraddress[$i] eq R))
      {
         $colortdraddress[$i] = STAP_SECURE_RED;
         print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $address[$i], ", ",$colortdraddress[$i],"},","    //Opcode for iTDR$i\n";
      }
      if(($colortdraddress[$i] eq o) || ($colortdraddress[$i] eq O))
      {
         $colortdraddress[$i] = STAP_SECURE_ORANGE;
         print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $address[$i], ", ",$colortdraddress[$i],"},"," //Opcode for iTDR$i\n";
      }
      if(($colortdraddress[$i] eq g) || ($colortdraddress[$i] eq G))
      {
         $colortdraddress[$i] = STAP_SECURE_GREEN;
         print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $address[$i], ", ",$colortdraddress[$i],"},","  //Opcode for iTDR$i\n";
      }
   }
}
if ($STAP_SUPPRESS_UPDATE_CAPTURE == 1){
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h22, ",$STAP_SECURE_GREEN,"},", "  //Opcode for SUPRESS_UPDATE_CAPTURE_REG\n";
}
if ($STAP_SWCOMP_ACTIVE == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h21, ",$STAP_SECURE_GREEN,"},", "  //Opcode for SWCOMP_STAT\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h20, ",$STAP_SECURE_GREEN,"},", "  //Opcode for SWCOMP_CTRL\n";
}
if ($STAP_ENABLE_RTDR_PROG_RST == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h17, ",$STAP_SECURE_GREEN,"},", "  //Opcode for TAPC_RTDRRSTSEL\n";
}
if ($STAP_ENABLE_ITDR_PROG_RST == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h16, ",$STAP_SECURE_GREEN,"},", "  //Opcode for TAPC_ITDRRSTSEL\n";
}
if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h15, ",$STAP_SECURE_GREEN,"},", "  //Opcode for TAPC_TDRRSTEN\n";
}
if ($STAP_ENABLE_TAPC_REMOVE == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h14, ",$STAP_SECURE_GREEN,"},", "  //Opcode for TAPC_REMOVE\n";
}
if ($STAP_ENABLE_WTAP_NETWORK == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h13, ",$STAP_SECURE_ORANGE,"},", " //Opcode for TAPC_WTAP_SEL\n";
}
if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h10, ",$STAP_SECURE_ORANGE,"},", " //Opcode for TAPC_SEC_SEL\n";
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h0D, ",$STAP_SECURE_GREEN,"},", "  //Opcode for EXTEST_TOGGLE\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h07, ",$STAP_SECURE_GREEN,"},", "  //Opcode for RUNBIST\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h06, ",$STAP_SECURE_GREEN,"},", "  //Opcode for INTEST\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h04, ",$STAP_SECURE_GREEN,"},", "  //Opcode for CLAMP\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h03, ",$STAP_SECURE_GREEN,"},", "  //Opcode for PRELOAD\n";
}
if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h11, ",$STAP_SECURE_GREEN,"},", "  //Opcode for TAPC_SELECT\n";
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h0F, ",$STAP_SECURE_GREEN,"},", "  //Opcode for EXTEXT_TRAIN\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h0E, ",$STAP_SECURE_GREEN,"},", "  //Opcode for EXTEXT_PULSE\n";
}
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h0C, ",$STAP_SECURE_GREEN,"},", "  //Opcode for SLVIDCODE\n";
if ($STAP_ENABLE_BSCAN == 1)
{
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h09, ",$STAP_SECURE_GREEN,"},", "  //Opcode for EXTEXT\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h08, ",$STAP_SECURE_GREEN,"},", "  //Opcode for HIGHZ\n";
   print output "{",$STAP_SIZE_OF_EACH_INSTRUCTION, "'h01, ",$STAP_SECURE_GREEN,"},", "  //Opcode for SAMPLE/PRELOAD\n";
}


print output "{","{STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}, ","$STAP_SECURE_GREEN","}", "  //Opcode for BYPASS\n";
print output "};\n";

print "\n";

print output "parameter ${file_name}_STAP_NUMBER_OF_BITS_FOR_SLICE = $STAP_NUMBER_OF_BITS_FOR_SLICE;\n";
print output "parameter [((${file_name}_STAP_NUMBER_OF_BITS_FOR_SLICE * ((${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] ${file_name}_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER = {\n";

if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print output $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $dw[$i], "  //Width of iTDR $i\n";
      }
      else
      {
         print output $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $dw[$i], ", //Width of iTDR $i\n";
      }
   }
}
else
{
   print output $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d0\n";
}
print output "};\n";
print output "parameter [((${file_name}_STAP_NUMBER_OF_BITS_FOR_SLICE * ((${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] ${file_name}_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS = {\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   $j = 0;
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print output "16'd", $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - $j - 1, "  //MSB Value of iTDR $i\n";
         $j = $j + $dw[$i];
      }
      else
      {
         print output "16'd", $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - $j - 1, ", //MSB Value of iTDR $i\n";
         $j = $j + $dw[$i];
      }
   }
}
else
{
   print output "16'd0\n";
}
print output "};\n";
print output "parameter [((${file_name}_STAP_NUMBER_OF_BITS_FOR_SLICE * ((${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] ${file_name}_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS = {\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   $k = 0;
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         $k = $k + $dw[$i];
         print output "16'd", $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - $k, "  //LSB Value of iTDR $i\n";
      }
      else
      {
         $k = $k + $dw[$i];
         print output "16'd", $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - $k, ", //LSB Value of iTDR $i\n";
      }
   }
}
else
{
   print output "16'd0\n";
}
print output "};\n";
print output "parameter [(((${file_name}_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : ${file_name}_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] ${file_name}_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS = {\n";
print "\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   for ($i = 0; $i <= $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i++)
   {
      LOOP_DT_RESET:print "Enter RESET VALUE of TEST_DATA_REGISTER_", $i, " (Hex Value, Default: 0): ";
      chomp($reset[$i] = <STDIN>);
      until ($reset[$i] =~ /^$/ or $reset[$i] =~ /[0-9A-Fa-f]/)
      {
         print "Enter RESET VALUE of TEST_DATA_REGISTER_", $i, " (Hex Value, Default: 0): ";
         chomp ($reset[$i] = <STDIN>);
      }
      if ($reset[$i] =~ /^$/)
      {
         $reset[$i] = 0;
         print "Do you want to proceed with Default value (y for yes, n for no): ";
         $Decision = <STDIN>;
         if ($Decision =~ /y/)
         {
            goto PROCEED_DT_RESET;
         }
         elsif ($Decision =~ /n/)
         {
            goto LOOP_DT_RESET;
         }
      }
      PROCEED_DT_RESET:
   }

   for ($i = 0; $i <= $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i++)
   {
      if ($reset[$i] =~ /^$/)
      {
         $reset[$i] = 0;
      }
   }
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print output $dw[$i], "'h", $reset[$i], "  //Reset Value of iTDR $i\n";
      }
      else
      {
         print output $dw[$i], "'h", $reset[$i], ", //Reset Value of iTDR $i\n";
      }
   }
}
else
{
   print output "1'b0\n";
}

print "\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   for ($i = 0; $i <= $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i++)
   {
      if ($a[$i] =~ /^$/)
      {
         $a[$i] = 0;
      }
   }

}
print output "};\n";
print output "\n";
print "\nEnter the Color you want to use for STAP_DFX_EARLYBOOT_FEATURE_ENABLE (Available choices : r for red, o for orange, g for green, Default:g): ";
chomp ($STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color = <STDIN>);
until ($STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color =~ m/^$/ or $STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color =~ m/[gorGOR]/)
{
   print "Not a valid value, enter colors (g for green, o for orange, r for red) again (Alphabetical Value, Default: g): ";
   chomp ($STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color = <STDIN>);
   print "\n";
}
if ($STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color eq  "")
{
   $STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color = g;
}
if($STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color eq r)
{
   $STAP_DFX_EARLYBOOT_FEATURE_ENABLE = "100";
}
elsif($STAP_DFX_EARLYBOOT_FEATURE_ENABLE_color eq o)
{
   $STAP_DFX_EARLYBOOT_FEATURE_ENABLE = "010";
}
else
{
   $STAP_DFX_EARLYBOOT_FEATURE_ENABLE = "001";
}

print output "\n";
print output "parameter ${file_name}_STAP_DFX_EARLYBOOT_FEATURE_ENABLE = {3'b${STAP_DFX_EARLYBOOT_FEATURE_ENABLE},2'b11};\n";
print output "// size of the SECURE_POLICY_MATRIX : [(((STAP_DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** STAP_DFX_SECURE_WIDTH)) - 1):0]\n"; 
print output "parameter [(((3+2)*(2**4))-1):0] ${file_name}_STAP_DFX_SECURE_POLICY_MATRIX = \n"; 
print output "{\n";
print output "// 3 dfx features + 2 visa controls\n";
print output "{3'b001,2'b11},  //  => Policy_15 (Part Disabled)\n";
print output "{3'b010,2'b11},  //  => Policy_14 (User8 Unlocked\n";
print output "{3'b010,2'b11},  //  => Policy_13 (User7 Unlocked)\n";
print output "{3'b010,2'b11},  //  => Policy_12 (User6 Unlocked)\n";
print output "{3'b010,2'b11},  //  => Policy_11 (User5 Unlocked)\n";
print output "{3'b010,2'b11},  //  => Policy_10 (User4 Unlocked)\n";
print output "{3'b100,2'b11},  //  => Policy_9  (FuSa Unlocked)\n";
print output "{3'b010,2'b11},  //  => Policy_8  (DRAM Debug Unlocked)\n";
print output "{3'b100,2'b11},  //  => Policy_7  (InfraRed Unlocked)\n";
print output "{3'b${SEC_POLICY_6},2'b11},  //  => Policy_6  (enDebug Unlocked)\n";
print output "{3'b010,2'b11},  //  => Policy_5  (OEM Unlocked)\n";
print output "{3'b100,2'b11},  //  => Policy_4  (Intel Unlocked)\n";
print output "{3'b001,2'b11},  //  => Policy_3  (Delayed Auth Locked)\n";
print output "{3'b100,2'b11},  //  => Policy_2  (Security Unlocked)\n";
print output "{3'b001,2'b11},  //  => Policy_1  (Functionality Locked)\n";
print output "{3'b001,2'b11}   //  => Policy_0  (Security Locked)\n";
print output "};Replace\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "// NOTE: Log history is at end of file.\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "//\n";
print output1 "//    FILENAME    : tb_param.inc\n";
print output1 "//    DESIGNER    : Sudheer V Bandana\n";
print output1 "//    PROJECT     : sTAP\n";
print output1 "//    PURPOSE     : sTAP TB Parameters\n";
print output1 "//    REVISION    : 2016WW28_RTL1P0_V1\n";
print output1 "//    DESCRIPTION :\n";
print output1 "//      This is a TB parameter file. Please refer IG for more details.\n";
print output1 "//    PARAMETERS  :\n";
print output1 "//    CLOCK_PERIOD                         : To Configure the Clock Period\n";
print output1 "//    SIZE_OF_IR_REG_STAP                  : Size of the Instruction REGISTER\n";
print output1 "//    STAP_NUMBER_OF_SLAVE_TAPS_IN_NETWORK : Number of Slave Tap present in the TAP Network\n";
print output1 "//    STAP_NUMBER_OF_WTAPS_IN_NETWORK      : Number of WTAP present in the TAP Network\n";
print output1 "//    STAP_NUMBER_OF_TAPS                  : Number of Taps present in the TAP Network\n";
print output1 "//    NO_OF_RW_REG                         : Number of registers in the TAP\n";
print output1 "//                                           This includes: TAP Network registers,\n";
print output1 "//                                           Optional Register\n";
print output1 "//                                           It does NOT include : Mandatory Register\n";
print output1 "//    TOTAL_DATA_REGISTER_WIDTH            : Sum of the register width of al the register\n";
print output1 "//                                           except Mandatory Register\n";
print output1 "//    BYPASS_TRANS_WIDTH                   : This the number of transaction that user wants\n";
print output1 "//                                           to carry out in Bypass state.\n";
print output1 "//    RO_REGISTER_WIDTH                    : Width of Register which do not have parallel Data in\n";
print output1 "//    RW_REG_ADDR                          : This defines the address for all the RW registers\n";
print output1 "//    RW_REG_WIDTH                         : This defines the width for all the RW registers\n";
print output1 "//    TB_DATA_REGISTER_RESET_VALUES        : This defines the Reset value of all the RW registers\n";
print output1 "//    TB_LOAD_PIN_OR_NOT_LOOPBACK          : This parameter is a per-bit value used to specify whether\n";
print output1 "//                                           the each bit of the iTDR captures a fixed value (from tdr_data_in bus)\n";
print output1 "//                                           or the recirculated value coming from the corresponding bit\n";
print output1 "//                                           of tdr_data_out bus\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "//--------------------FIXED PARAMETER DO NOT CHANGE---------------------\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "//If there are Multiple TAP in the ENV the value is 1\n";
print output1 "//(e.g WTAP or TAP NW ENV) Else 0 (STAP ENV)\n";
print output1 "parameter MULTIPLE_TAP         = 0;\n";
print output1 "parameter NO_OF_SLAVE_TAP      = 1;\n";
print output1 "parameter IDCODE_WIDTH         = 32;\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "//--------------------------USER AREA-----------------------------------\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "parameter CLOCK_PERIOD                         = $CLK_PERIOD;\n";
print output1 "parameter LENGTH_OF_BSCAN_CHAIN                = $LENGTH_OF_BSCAN_CHAIN;\n";
print output1 "parameter SIZE_OF_IR_REG_STAP                  = $STAP_SIZE_OF_EACH_INSTRUCTION;\n";
print output1 "parameter STAP_EN_TAP_NETWORK                  = $STAP_ENABLE_TAP_NETWORK;\n";
print output1 "parameter STAP_NUM_OF_TAPS_IN_TAP_NETWORK      = $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK;\n";
$STAP_NUM_OF_TAPS_IN_TAP_NETWORK = $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK;
print output1 "parameter NUM_OF_DFX_FEATURES_TO_SECURE        = $STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE;\n";
print output1 "parameter DFX_SECURE_WIDTH                     = $STAP_DFX_SECURE_WIDTH;\n";

if($STAP_SWCOMP_ACTIVE == 1)
{
   print output1 "parameter STAP_SWCOMP_ACTIVE                   = $STAP_SWCOMP_ACTIVE;\n";
   print output1 "parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS      = $STAP_SWCOMP_NUM_OF_COMPARE_BITS;\n";
}
else 
{
   print output1 "parameter STAP_SWCOMP_ACTIVE                   = $STAP_SWCOMP_ACTIVE;\n";
   print output1 "parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS      = 10;\n";
}
print output1 "parameter STAP_SUPPRESS_UPDATE_CAPTURE   = $STAP_SUPPRESS_UPDATE_CAPTURE;\n";
if ($STAP_NUM_OF_TAPS_IN_TAP_NETWORK == 0)
{
   print output1 "parameter STAP_NO_OF_TAPS_IN_TAP_NETWORK       = 1;\n";
}
else
{
   print output1 "parameter STAP_NO_OF_TAPS_IN_TAP_NETWORK       = $STAP_NUM_OF_TAPS_IN_TAP_NETWORK;\n";
}
if ($STAP_NUM_OF_TAPS_IN_TAP_NETWORK == 0)
{
   $STAP_NO_OF_TAPS_IN_TAP_NETWORK = 0;
}
else
{
   $STAP_NO_OF_TAPS_IN_TAP_NETWORK = $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK;
}
if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   print output1 "parameter STAP_WIDTH_OF_SEC_SEL_REG_IN_STAP    = $STAP_NUM_OF_TAPS_IN_TAP_NETWORK;\n";
}
else
{
   print output1 "parameter STAP_WIDTH_OF_SEC_SEL_REG_IN_STAP    = 0;\n";
}

print output1 "parameter STAP_EN_WTAP_NETWORK                 = $STAP_ENABLE_WTAP_NETWORK;\n";
print output1 "parameter STAP_NUMBER_OF_WTAPS_IN_WTAP_NETWORK = $STAP_NUMBER_OF_WTAPS_IN_NETWORK;\n";
print output1 "parameter STAP_WTAP_NETWORK_SERIES_OR_PARALLEL = $STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL;\n";
if ($STAP_ENABLE_WTAP_NETWORK == 0)
{
   print output1 "parameter STAP_NO_OF_WTAPS_IN_WTAP_NETWORK     = 1;\n";
   print output1 "parameter STAP_NUM_OF_WTAPS_IN_WTAP_NETWORK    = 0;\n";
}
else
{
print output1 "parameter STAP_WTAPCTRL_RESET_VALUE = $STAP_WTAPCTRL_RESET_VALUE;\n";

   if ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1)
   {
      print output1 "parameter STAP_NO_OF_WTAPS_IN_WTAP_NETWORK     = 1;\n";
      print output1 "parameter STAP_NUM_OF_WTAPS_IN_WTAP_NETWORK    = 1;\n";
   }
   else
   {
      if ($STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0)
      {
         print output1 "parameter STAP_NO_OF_WTAPS_IN_WTAP_NETWORK     = 1;\n";
         print output1 "parameter STAP_NUM_OF_WTAPS_IN_WTAP_NETWORK    = 1;\n";
      }
      else
      {
         print output1 "parameter STAP_NO_OF_WTAPS_IN_WTAP_NETWORK     = $STAP_NUMBER_OF_WTAPS_IN_NETWORK;\n";
         print output1 "parameter STAP_NUM_OF_WTAPS_IN_WTAP_NETWORK    = $STAP_NUMBER_OF_WTAPS_IN_NETWORK;\n";
      }
   }
}

if ($STAP_ENABLE_BSCAN == 1)
{
   $NO_OF_MANDATORY_BOUNDARY_SCAN = 7;
}
else
{
   $NO_OF_MANDATORY_BOUNDARY_SCAN = 0;
}

if ($STAP_SWCOMP_ACTIVE == 1)
{
   $NO_OF_SWCOMP_REGISTERS = 2;
}
else
{
   $NO_OF_SWCOMP_REGISTERS = 0; 
}

$NO_OF_RW_REG = $NO_OF_MANDATORY_BOUNDARY_SCAN + $STAP_NUMBER_OF_TAP_SELECT_REGISTERS + $STAP_ENABLE_TAPC_SEC_SEL + $STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS + $STAP_NUMBER_OF_TEST_DATA_REGISTERS + $STAP_ENABLE_TAPC_REMOVE + $STAP_ENABLE_PROG_RST + $STAP_ENABLE_ITDR_PROG_RST + $STAP_ENABLE_RTDR_PROG_RST + $NO_OF_SWCOMP_REGISTERS+$STAP_SUPPRESS_UPDATE_CAPTURE ;
if ($NO_OF_RW_REG == 0)
{
   print output1 "parameter NO_OF_RW_REG                         = 1;\n";
}
else
{
   print output1 "parameter NO_OF_RW_REG                         = ", $NO_OF_RW_REG, ";\n";
}

if($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
	if ($STAP_SWCOMP_ACTIVE == 1)
	{
$TOTAL_DATA_REGISTER_WIDTH = 34 + $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS + $STAP_ENABLE_TAPC_REMOVE + (2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK) + ($NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN) + $SIZE_OF_SEC_SEL + $STAP_NUMBER_OF_WTAPS_IN_NETWORK + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_ITDR_PROG_RST * $STAP_NUMBER_OF_TEST_DATA_REGISTERS) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) + 2*((3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS) + 13)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0) ;
    }
	else
	{
    $TOTAL_DATA_REGISTER_WIDTH = 34 + $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS + $STAP_ENABLE_TAPC_REMOVE + (2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK) + ($NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN) + $SIZE_OF_SEC_SEL + $STAP_NUMBER_OF_WTAPS_IN_NETWORK + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_ITDR_PROG_RST * $STAP_NUMBER_OF_TEST_DATA_REGISTERS) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0); 
	}
}
else
{
	if ($STAP_SWCOMP_ACTIVE == 1)
	{
$TOTAL_DATA_REGISTER_WIDTH = 34 + $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS + $STAP_ENABLE_TAPC_REMOVE + (2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK) + ($NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN) + $SIZE_OF_SEC_SEL + $STAP_NUMBER_OF_WTAPS_IN_NETWORK + 1 + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) + 2*((3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS) + 13)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0);
	}
	else
	{
    $TOTAL_DATA_REGISTER_WIDTH = 34 + $STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS + $STAP_ENABLE_TAPC_REMOVE + (2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK) + ($NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN) + $SIZE_OF_SEC_SEL + $STAP_NUMBER_OF_WTAPS_IN_NETWORK + 1 + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0);
	}
}
if ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1)
{
   $WTAP_NW_SIZE = 1;
}
else
{
   $WTAP_NW_SIZE = $STAP_NUMBER_OF_WTAPS_IN_NETWORK;
}

if ($STAP_SWCOMP_ACTIVE == 1)
{
$RO_REGISTER_WIDTH = $STAP_ENABLE_TAPC_REMOVE + (2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK) + ($NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN) + $SIZE_OF_SEC_SEL + $WTAP_NW_SIZE + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_ITDR_PROG_RST * $STAP_NUMBER_OF_TEST_DATA_REGISTERS) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) + 2*((3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS) + 13)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0);
}
else 
{
$RO_REGISTER_WIDTH = $STAP_ENABLE_TAPC_REMOVE + (2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK) + ($NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN) + $SIZE_OF_SEC_SEL + $WTAP_NW_SIZE + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_ITDR_PROG_RST * $STAP_NUMBER_OF_TEST_DATA_REGISTERS) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0);
}

if ($STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 0)
{
   $TOTAL_DATA_REGISTER_WIDTH_SERIAL = $TOTAL_DATA_REGISTER_WIDTH
}
else
{
   $TOTAL_DATA_REGISTER_WIDTH_SERIAL = $TOTAL_DATA_REGISTER_WIDTH + $WTAP_NW_SIZE - $STAP_NUMBER_OF_WTAPS_IN_NETWORK;
}

print output1 "parameter TOTAL_DATA_REGISTER_WIDTH            = ", $TOTAL_DATA_REGISTER_WIDTH_SERIAL, ";\n";
print output1 "parameter BYPASS_TRANS_WIDTH                   = 3;\n";
print output1 "parameter RO_REGISTER_WIDTH                    = ", $RO_REGISTER_WIDTH, ";\n";
print output1 "parameter TB_STAP_SECURE_GREEN                 = 2'b00;\n";
print output1 "parameter TB_STAP_SECURE_ORANGE                = 2'b01;\n";
print output1 "parameter TB_STAP_SECURE_RED                   = 2'b10;\n";
print output1 "parameter STAP_NUM_OF_ITDRS                    = $STAP_NUMBER_OF_TEST_DATA_REGISTERS;\n";

print output1 "\n";

print output1 "parameter [(SIZE_OF_IR_REG_STAP*NO_OF_RW_REG)-1:0] RW_REG_ADDR = {\n";

if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_PROG_RST == 0 ) && ($STAP_SWCOMP_ACTIVE == 0))
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         if ($i == 0)
         {
            print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $address[$i], "  //Opcode Address for iTDR$i\n";
         }
         else
         {
            print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $address[$i], ", //Opcode Address for iTDR$i\n";
         }
      }
   }
   else
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h", $address[$i], ", //Opcode Address for iTDR$i\n";
      }
   }
}

if ($STAP_SUPPRESS_UPDATE_CAPTURE == 1){
    print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h22,", " //Opcode Address for SUPRESS_UPDATE_CAPTURE_REG\n";
}
if($STAP_SWCOMP_ACTIVE == 1)
{
    print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h21,", " //Opcode Address for SWCOMP_STAT\n";


if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_RTDR_PROG_RST == 0) && ($STAP_ENABLE_ITDR_PROG_RST == 0) )
{
    print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h20", " //Opcode Address for SWCOMP_CTRL\n";
}
else 
{
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h20,", " //Opcode Address for SWCOMP_CTRL\n";
}

}

if ($STAP_ENABLE_RTDR_PROG_RST == 1)
{
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h17,", " //Opcode Address for TAPC_RTDRRSTSEL\n";
}
if ($STAP_ENABLE_ITDR_PROG_RST == 1)
{
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h16,", " //Opcode Address for TAPC_ITDRRSTSEL\n";
}
if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0))
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h15", " //Opcode Address for TAPC_TDRRSTEN\n";
   }
}
else
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h15,", " //Opcode Address for TAPC_TDRRSTEN\n";
   }
}
if ($STAP_ENABLE_TAPC_REMOVE == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1) || ($STAP_ENABLE_WTAP_NETWORK == 1))
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h14,", " //Opcode Address for TAPC_REMOVE\n";
   }
   else
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h14", "  //Opcode Address for TAPC_REMOVE\n";
   }
}
if ($STAP_ENABLE_WTAP_NETWORK == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h13,", " //Opcode Address for TAPC_WTAP_SEL\n";
   }
   else
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h13", "  //Opcode Address for TAPC_WTAP_SEL\n";
   }
}
if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   if (($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h10,", " //Opcode Address for TAPC_SEC_SEL\n";
   }
   else
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h10", "  //Opcode Address for TAPC_SEC_SEL\n";
   }
}

if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h0D,", " //Opcode Address for EXTEST_TOGGLE\n";
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h06,", " //Opcode Address for INTEST\n";
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h03,", " //Opcode Address for PRELOAD\n";
}
if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   if ($STAP_ENABLE_BSCAN == 1)
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h11,", " //Opcode Address for TAPC_SELECT\n";
   }
   else
   {
      print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h11", "  //Opcode Address for TAPC_SELECT\n";
   }
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h0F,", " //Opcode Address for EXTEXT_TRAIN\n";
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h0E,", " //Opcode Address for EXTEXT_PULSE\n";
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h09,", " //Opcode Address for EXTEXT\n";
   print output1 $STAP_SIZE_OF_EACH_INSTRUCTION, "'h01", "  //Opcode Address for SAMPLE/PRELOAD\n";
}
if ($NO_OF_RW_REG == 0)
{
   print output1 "8'b0", "\n";
}
print output1 "};\n";

print output1 "parameter [(2*NO_OF_RW_REG)-1:0] RW_REG_COLOR = {\n";

if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_PROG_RST == 0)&& ($STAP_SWCOMP_ACTIVE == 0))
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         if ($i == 0)
         {
            print output1 "TB_",$colortdraddress[$i], "  //Opcode Color for iTDR$i\n";
         }
         else
         {
            print output1 "TB_",$colortdraddress[$i], ", //Opcode Color for iTDR$i\n";
         }
      }
   }
   else
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         print output1 "TB_",$colortdraddress[$i], ", //Opcode Color for iTDR$i\n";
      }
   }
}




if ($STAP_SUPPRESS_UPDATE_CAPTURE == 1){
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for STAP_SUPPRESS_UPDATE_CAPTURE\n";
}
if ($STAP_SWCOMP_ACTIVE == 1)
{
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for SWCOMP_STAT\n";

   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0)&& ($STAP_ENABLE_RTDR_PROG_RST == 0) && ($STAP_ENABLE_ITDR_PROG_RST == 0) )   
   {
	print output1 "TB_STAP_SECURE_GREEN", "  //Opcode Color for SWCOMP_CTRL\n";
   }
   else
   {
	print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for SWCOMP_CTRL\n";
   }
}


if ($STAP_ENABLE_RTDR_PROG_RST == 1)
{
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for TAPC_RTDRRSTSEL\n";
}
if ($STAP_ENABLE_ITDR_PROG_RST == 1)
{
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for TAPC_ITDRRSTSEL\n";
}
if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0))
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 "TB_STAP_SECURE_GREEN", "  //Opcode Color for TAPC_TDRRSTEN\n";
   }
}
else
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for TAPC_TDRRSTEN\n";
   }
}
if ($STAP_ENABLE_TAPC_REMOVE == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1) || ($STAP_ENABLE_WTAP_NETWORK == 1))
   {
      print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for TAPC_REMOVE\n";
   }
   else
   {
      print output1 "TB_STAP_SECURE_GREEN", "   //Opcode Color for TAPC_REMOVE\n";
   }
}

if ($STAP_ENABLE_WTAP_NETWORK == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 "TB_STAP_SECURE_ORANGE,", " //Opcode Color for TAPC_WTAP_SEL\n";
   }
   else
   {
      print output1 "TB_STAP_SECURE_ORANGE", "  //Opcode Color for TAPC_WTAP_SEL\n";
   }
}
if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   if (($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 "TB_STAP_SECURE_ORANGE,", " //Opcode Color for TAPC_SEC_SEL\n";
   }
   else
   {
      print output1 "TB_STAP_SECURE_ORANGE", "  //Opcode Color for TAPC_SEC_SEL\n";
   }
}

if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for EXTEST_TOGGLE\n";
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for INTEST\n";
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for PRELOAD\n";
}
if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   if ($STAP_ENABLE_BSCAN == 1)
   {
      print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for TAPC_SELECT\n";
   }
   else
   {
      print output1 "TB_STAP_SECURE_GREEN", "   //Opcode Color for TAPC_SELECT\n";
   }
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for EXTEXT_TRAIN\n";
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for EXTEXT_PULSE\n";
   print output1 "TB_STAP_SECURE_GREEN,", "  //Opcode Color for EXTEXT\n";
   print output1 "TB_STAP_SECURE_GREEN", "   //Opcode Color for SAMPLE/PRELOAD\n";
}
if ($NO_OF_RW_REG == 0)
{
   print output1 "TB_STAP_SECURE_GREEN", "\n";
}
print output1 "};\n";

print output1 "parameter [(16*NO_OF_SLAVE_TAP)-1:0]CON_NO_OF_DR_REG_STAP = {\n";
print output1 "16'd", $NO_OF_RW_REG, "\n";
print output1 "};\n";
print output1 "parameter [(16*NO_OF_RW_REG)-1:0] RW_REG_WIDTH = {\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_PROG_RST == 0)&& ($STAP_SWCOMP_ACTIVE == 0))
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         if ($i == 0)
         {
            print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $dw[$i], "\n";
         }
         else
         {
            print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $dw[$i], ",\n";
         }
      }
   }
   else {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $dw[$i], ",\n";
      }
   }
}


if($STAP_SWCOMP_ACTIVE == 1)
{
  print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", (3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS  + 13), ",\n";
 
  if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0)&& ($STAP_ENABLE_RTDR_PROG_RST == 0) && ($STAP_ENABLE_ITDR_PROG_RST == 0) )
  {
    print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", (3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS  + 13), "\n";
  }
  else 
  {
	print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", (3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS  + 13), ",\n";
  }
}
if ($STAP_SUPPRESS_UPDATE_CAPTURE == 1){
  print output1 "16'd2,\n";
}
if ($STAP_ENABLE_RTDR_PROG_RST == 1)
{
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS, ",\n";
}
if ($STAP_ENABLE_ITDR_PROG_RST == 1)
{
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $STAP_NUMBER_OF_TEST_DATA_REGISTERS, ",\n";
}
if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0))
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", (2 * $STAP_ENABLE_PROG_RST), "\n";
   }
}
else
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", (2 * $STAP_ENABLE_PROG_RST), ",\n";
   }
}
if ($STAP_ENABLE_TAPC_REMOVE == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1) || ($STAP_ENABLE_WTAP_NETWORK == 1))
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $STAP_ENABLE_TAPC_REMOVE, ",\n";
   }
   else
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $STAP_ENABLE_TAPC_REMOVE, "\n";
   }
}

if($STAP_ENABLE_WTAP_NETWORK == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $WTAP_NW_SIZE, ",\n";
   }
   else
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $WTAP_NW_SIZE, "\n";
   }
}
if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   if (($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK, ",\n";
   }
   else
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK, "\n";
   }
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, ",\n";
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, ",\n";
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, ",\n";
}
if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   if ($STAP_ENABLE_BSCAN == 1)
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", 2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK, ",\n";
   }
   else
   {
      print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", 2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK, "\n";
   }
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, ",\n";
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, ",\n";
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, ",\n";
   print output1 $STAP_NUMBER_OF_BITS_FOR_SLICE, "'d", $LENGTH_OF_BSCAN_CHAIN, "\n";
}
if ($NO_OF_RW_REG == 0)
{
   print output1 "16'd0", "\n";
}
print output1 "};\n";

print output1 "parameter [(TOTAL_DATA_REGISTER_WIDTH - 1):0] TB_DATA_REGISTER_RESET_VALUES = {\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_PROG_RST == 0)&& ($STAP_SWCOMP_ACTIVE == 0))
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         if ($i == 0)
         {
            print output1 $dw[$i], "'h", $reset[$i], "\n";
         }
         else
         {
            print output1 $dw[$i], "'h", $reset[$i], ",\n";
         }
      }
   }
   else
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         print output1 $dw[$i], "'h", $reset[$i], ",\n";
      }
   }
}


if($STAP_SWCOMP_ACTIVE == 1)
{
   print output1 3*$STAP_SWCOMP_NUM_OF_COMPARE_BITS + 13, "'d0,\n";
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_RTDR_PROG_RST == 0) && ($STAP_ENABLE_ITDR_PROG_RST == 0) )
   {
    print output1 3*$STAP_SWCOMP_NUM_OF_COMPARE_BITS + 13, "'d0\n";
   }
   else
   {
    print output1 3*$STAP_SWCOMP_NUM_OF_COMPARE_BITS + 13, "'d0,\n";
   }
}
if ($STAP_SUPPRESS_UPDATE_CAPTURE == 1){
  print output1 "2'd0,\n";
}

if ($STAP_ENABLE_RTDR_PROG_RST == 1)
{
   print output1 $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS, "'d0,\n";
}
if ($STAP_ENABLE_ITDR_PROG_RST == 1)
{
   print output1 $STAP_NUMBER_OF_TEST_DATA_REGISTERS, "'d0,\n";
}
if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0))
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 (2 * $STAP_ENABLE_PROG_RST), "'d0\n";
   }
}
else
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 (2 * $STAP_ENABLE_PROG_RST), "'d0,\n";
   }
}
if ($STAP_ENABLE_TAPC_REMOVE == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1) || ($STAP_ENABLE_WTAP_NETWORK == 1))
   {
      print output1 $STAP_ENABLE_TAPC_REMOVE, "'d0,\n";
   }
   else
   {
      print output1 $STAP_ENABLE_TAPC_REMOVE, "'d0\n";
   }
}

if($STAP_ENABLE_WTAP_NETWORK == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $WTAP_NW_SIZE, "'d0,\n";
   }
   else
   {
      print output1 $WTAP_NW_SIZE, "'d0\n";
   }
}

if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   if (($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK, "'d0,\n";
   }
   else
   {
      print output1 $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK, "'d0\n";
   }
}

if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
}
if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   if ($STAP_ENABLE_BSCAN == 1)
   {
      print output1 2*$STAP_NO_OF_TAPS_IN_TAP_NETWORK, "'d0,\n";
   }
   else
   {
      print output1 2*$STAP_NO_OF_TAPS_IN_TAP_NETWORK, "'d0\n";
   }
}

if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0\n";
}
if ($NO_OF_RW_REG == 0)
{
   print output1 "1'd0", "\n";
}
print output1 "};\n";

print output1 "parameter [TOTAL_DATA_REGISTER_WIDTH - 1:0] TB_LOAD_PIN_OR_NOT_LOOPBACK = {\n";
if ($STAP_ENABLE_TEST_DATA_REGISTERS == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_PROG_RST == 0)&& ($STAP_SWCOMP_ACTIVE == 0))
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         if ($i == 0)
         {
            print output1 $dw[$i], "'h", $a[$i], "\n";
         }
         else
         {
            print output1 $dw[$i], "'h", $a[$i], ",\n";
         }
      }
   }
   else
   {
      for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
      {
         print output1 $dw[$i], "'h", $a[$i], ",\n";
      }
   }
}



if($STAP_SWCOMP_ACTIVE == 1)
{
   print output1 3*$STAP_SWCOMP_NUM_OF_COMPARE_BITS + 13, "'d0,\n";
   if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0) && ($STAP_ENABLE_RTDR_PROG_RST == 0) && ($STAP_ENABLE_ITDR_PROG_RST == 0) )
   {
   print output1 3*$STAP_SWCOMP_NUM_OF_COMPARE_BITS + 13, "'d0\n";
   }
   else
   {
    print output1 3*$STAP_SWCOMP_NUM_OF_COMPARE_BITS + 13, "'d0,\n";
   }
}
if ($STAP_SUPPRESS_UPDATE_CAPTURE == 1){
  print output1 "2'd0,\n";
}


if ($STAP_ENABLE_RTDR_PROG_RST == 1)
{
   print output1 $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS, "'d0,\n";
}
if ($STAP_ENABLE_ITDR_PROG_RST == 1)
{
   print output1 $STAP_NUMBER_OF_TEST_DATA_REGISTERS, "'d0,\n";
}
if (($STAP_ENABLE_TAPC_SEC_SEL == 0) && ($STAP_ENABLE_BSCAN == 0) && ($STAP_ENABLE_TAP_NETWORK == 0) && ($STAP_ENABLE_WTAP_NETWORK == 0))
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 (2 * $STAP_ENABLE_PROG_RST), "'d0\n";
   }
}
else
{
   if (($STAP_ENABLE_RTDR_PROG_RST == 1) || ($STAP_ENABLE_ITDR_PROG_RST == 1))
   {
      print output1 (2 * $STAP_ENABLE_PROG_RST), "'d0,\n";
   }
}
if ($STAP_ENABLE_TAPC_REMOVE == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1) || ($STAP_ENABLE_WTAP_NETWORK == 1))
   {
      print output1 $STAP_ENABLE_TAPC_REMOVE, "'d0,\n";
   }
   else
   {
      print output1 $STAP_ENABLE_TAPC_REMOVE, "'d0\n";
   }
}

if($STAP_ENABLE_WTAP_NETWORK == 1)
{
   if (($STAP_ENABLE_TAPC_SEC_SEL == 1) || ($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $WTAP_NW_SIZE, "'d0,\n";
   }
   else
   {
      print output1 $WTAP_NW_SIZE, "'d0\n";
   }
}

if ($STAP_ENABLE_TAPC_SEC_SEL == 1)
{
   if (($STAP_ENABLE_BSCAN == 1) || ($STAP_ENABLE_TAP_NETWORK == 1))
   {
      print output1 $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK, "'d0,\n";
   }
   else
   {
      print output1 $STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK, "'d0\n";
   }
}

if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
}
if ($STAP_ENABLE_TAP_NETWORK == 1)
{
   if ($STAP_ENABLE_BSCAN == 1)
   {
      print output1 2*$STAP_NO_OF_TAPS_IN_TAP_NETWORK, "'d0,\n";
   }
   else
   {
      print output1 2*$STAP_NO_OF_TAPS_IN_TAP_NETWORK, "'d0\n";
   }
}
if ($STAP_ENABLE_BSCAN == 1)
{
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0,\n";
   print output1 $LENGTH_OF_BSCAN_CHAIN, "'d0\n";
}
if ($NO_OF_RW_REG == 0)
{
   print output1 "1'd0", "\n";
}
print output1 "};\n";

if($STAP_SWCOMP_ACTIVE == 1)
{
$NO_PARALLEL_OUT_BIT_WIDTH = $STAP_ENABLE_TAPC_REMOVE + 2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK + $NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN + $SIZE_OF_SEC_SEL + $WTAP_NW_SIZE + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_ITDR_PROG_RST * $STAP_NUMBER_OF_TEST_DATA_REGISTERS) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) + 2 * ((3 * $STAP_SWCOMP_NUM_OF_COMPARE_BITS) + 13 )+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0);
}
else
{
$NO_PARALLEL_OUT_BIT_WIDTH = $STAP_ENABLE_TAPC_REMOVE + 2 * $STAP_NO_OF_TAPS_IN_TAP_NETWORK + $NO_OF_MANDATORY_BOUNDARY_SCAN * $LENGTH_OF_BSCAN_CHAIN + $SIZE_OF_SEC_SEL + $WTAP_NW_SIZE + (2 * $STAP_ENABLE_PROG_RST) + ($STAP_ENABLE_ITDR_PROG_RST * $STAP_NUMBER_OF_TEST_DATA_REGISTERS) + ($STAP_ENABLE_RTDR_PROG_RST * $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)+($STAP_SUPPRESS_UPDATE_CAPTURE==1?2:0) ;
}
print output1 "parameter NO_PARALLEL_OUT_BIT_WIDTH = $NO_PARALLEL_OUT_BIT_WIDTH;\n";

print output1 "//----------------------------------------------------------------------\n";
print output1 "//--------------------FIXED PARAMETER DO NOT CHANGE---------------------\n";
print output1 "//----------------------------------------------------------------------\n";
print output1 "parameter SIZE_OF_IR_REG = (NO_OF_SLAVE_TAP * SIZE_OF_IR_REG_STAP);\n";
print output1 "//----------------------------------------------------------------------------------------\n";
print output1 "//--------------------REMOTE TDR PARAMS---------------------------------\n";
$TB_RTDR_IS_BUSSED_NZ = ($STAP_RTDR_IS_BUSSED == 0) ? 1 : $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS;
if ($STAP_ENABLE_REMOTE_TEST_DATA_REGISTER == 1)
{
   print output1 "parameter TB_REMOTE_TDR_ENABLE     = 1;\n";
   print output1 "parameter TB_NO_OF_REMOTE_TDR      = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS;\n";
   print output1 "parameter TB_NO_OF_REMOTE_TDR_NZ   = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS;\n";
   print output1 "parameter TB_RTDR_IS_BUSSED_NZ     = $TB_RTDR_IS_BUSSED_NZ;\n";
   print output1 "\n";
   print output1 "parameter TB_SIZE_OF_REMOTE_TDR    = 32;\n";
}
else
{
   print output1 "parameter TB_REMOTE_TDR_ENABLE     = 0;\n";
   print output1 "parameter TB_NO_OF_REMOTE_TDR      = 0;\n";
   print output1 "parameter TB_NO_OF_REMOTE_TDR_NZ   = 1;\n";
   print output1 "parameter TB_RTDR_IS_BUSSED_NZ     = $TB_RTDR_IS_BUSSED_NZ;\n";
   print output1 "\n";
   print output1 "parameter TB_SIZE_OF_REMOTE_TDR    = 0;\n";
}
print output1 "parameter TB_DISABLE_MISC_DRIVE    = 0;\n";
print output1 "\n";
print output1 "// DfxSecurePlugin abbreviated to DSP\n";
print output1 "`ifndef STAP_DSP_TB_PARAMS_DECL\n";
print output1 "`define STAP_DSP_TB_PARAMS_DECL \\";
print output1 "\n";
print output1 "    parameter \\";
print output1 "\n";
print output1 "    TB_DFX_NUM_OF_FEATURES_TO_SECURE    = 3,\\";
print output1 "\n";
print output1 "    TB_DFX_SECURE_WIDTH                 = 4,\\";
print output1 "\n";
print output1 "    TB_DFX_USE_SB_OVR                   = 0,\\";
print output1 "\n";
print output1 "    TB_CLK_PERIOD                       = 10ns\n";
print output1 "`endif\n";
print output1 "\n";
print output1 "`ifndef STAP_DSP_TB_PARAMS_INST\n";
print output1 "`define STAP_DSP_TB_PARAMS_INST \\";
print output1 "\n";
print output1 "    .TB_DFX_NUM_OF_FEATURES_TO_SECURE (TB_DFX_NUM_OF_FEATURES_TO_SECURE),\\";
print output1 "\n";
print output1 "    .TB_DFX_SECURE_WIDTH              (TB_DFX_SECURE_WIDTH),\\";
print output1 "\n";
print output1 "    .TB_DFX_USE_SB_OVR                (TB_DFX_USE_SB_OVR),\\";
print output1 "\n";
print output1 "    .TB_CLK_PERIOD                    (TB_CLK_PERIOD)\n";
print output1 "`endif\n";
print output1 "\n";
print output1 "`ifndef SOC_JTAG_IF_PARAMS_INST\n";
print output1 " `define SOC_PRI_JTAG_IF_PARAMS_INST   .CLOCK_PERIOD (10000), .PWRGOOD_SRC (0), .CLK_SRC (0)\n";
print output1 "`endif\n";

print output2 ".STAP_SIZE_OF_EACH_INSTRUCTION                      ",  "(",${file_name},    "_STAP_SIZE_OF_EACH_INSTRUCTION),\n";
print output2 ".STAP_ENABLE_TDO_POS_EDGE                           ",  "(",${file_name},    "_STAP_ENABLE_TDO_POS_EDGE),\n";
print output2 ".STAP_ENABLE_BSCAN                                  ",  "(",${file_name},    "_STAP_ENABLE_BSCAN),\n";
print output2 ".STAP_NUMBER_OF_MANDATORY_REGISTERS                 ",  "(",${file_name},    "_STAP_NUMBER_OF_MANDATORY_REGISTERS),\n";
print output2 ".STAP_SECURE_GREEN                                  ",  "(",${file_name},    "_STAP_SECURE_GREEN),\n";
print output2 ".STAP_SECURE_ORANGE                                 ",  "(",${file_name},    "_STAP_SECURE_ORANGE),\n";
print output2 ".STAP_SECURE_RED                                    ",  "(",${file_name},    "_STAP_SECURE_RED),\n";
print output2 ".STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                 ",  "(",${file_name},    "_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK),\n";
print output2 ".STAP_DFX_SECURE_POLICY_SELECTREG                   ",  "(",${file_name},    "_STAP_DFX_SECURE_POLICY_SELECTREG),\n";
print output2 ".STAP_ENABLE_TAPC_REMOVE                            ",  "(",${file_name},    "_STAP_ENABLE_TAPC_REMOVE),\n";
print output2 ".STAP_NUMBER_OF_WTAPS_IN_NETWORK                    ",  "(",${file_name},    "_STAP_NUMBER_OF_WTAPS_IN_NETWORK),\n";
print output2 ".STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL ",  "(",${file_name},    "_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL),\n";
print output2 ".STAP_ENABLE_WTAP_CTRL_POS_EDGE                     ",  "(",${file_name},    "_STAP_ENABLE_WTAP_CTRL_POS_EDGE),\n";
print output2 ".STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS          ",  "(",${file_name},    "_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),\n";
print output2 ".STAP_ENABLE_RTDR_PROG_RST                          ",  "(",${file_name},    "_STAP_ENABLE_RTDR_PROG_RST),\n";
print output2 ".STAP_RTDR_IS_BUSSED                                ",  "(",${file_name},    "_STAP_RTDR_IS_BUSSED),\n";
print output2 ".STAP_NUMBER_OF_TEST_DATA_REGISTERS                 ",  "(",${file_name},    "_STAP_NUMBER_OF_TEST_DATA_REGISTERS),\n";
print output2 ".STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS            ",  "(",${file_name},    "_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),\n";
print output2 ".STAP_ENABLE_ITDR_PROG_RST                          ",  "(",${file_name},    "_STAP_ENABLE_ITDR_PROG_RST),\n";
print output2 ".STAP_NUMBER_OF_TOTAL_REGISTERS                     ",  "(",${file_name},    "_STAP_NUMBER_OF_TOTAL_REGISTERS),\n";
print output2 ".STAP_INSTRUCTION_FOR_DATA_REGISTERS                ",  "(",${file_name},    "_STAP_INSTRUCTION_FOR_DATA_REGISTERS),\n";
print output2 ".STAP_NUMBER_OF_BITS_FOR_SLICE                      ",  "(",${file_name},    "_STAP_NUMBER_OF_BITS_FOR_SLICE),\n";
print output2 ".STAP_SIZE_OF_EACH_TEST_DATA_REGISTER               ",  "(",${file_name},    "_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER),\n";
print output2 ".STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS             ",  "(",${file_name},    "_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS),\n";
print output2 ".STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS             ",  "(",${file_name},    "_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS),\n";
print output2 ".STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS           ",  "(",${file_name},    "_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS),\n";
print output2 ".STAP_DFX_EARLYBOOT_FEATURE_ENABLE                  ",  "(",${file_name},    "_STAP_DFX_EARLYBOOT_FEATURE_ENABLE),\n";
print output2 ".STAP_DFX_SECURE_POLICY_MATRIX                      ",  "(",${file_name},    "_STAP_DFX_SECURE_POLICY_MATRIX),\n";
print output2 ".STAP_WTAPCTRL_RESET_VALUE                          ",  "(",${file_name},    "_STAP_WTAPCTRL_RESET_VALUE)\n";

close (output);
close (output1);
close (output2);

open (output, ">stap_params_include.inc");
system "sed -e 's/;/,/'g ${file_name}_sTAP_soc_param_values.inc > stap_params_include.inc";
system "sed -i 's/,Replace//'g stap_params_include.inc";
system "sed -i 's/;Replace/;/'g ${file_name}_sTAP_soc_param_values.inc";
close (output);

#NEW Code added
system "cp -f stap_params_include.inc ${file_name}_stap_params_include.inc";
system "sed -i 's/STAP/${file_name}_STAP/'g ${file_name}_stap_params_include.inc";

#open (output_tmp, ">tmp1");
#system "sed -e 's/STAP/${file_name}_STAP/'g ${file_name}_sTAP_soc_param_values.inc > tmp1";
#system "sed -e 's/DFX_${file_name}_SECURE_/DFX_SECURE_/'g tmp1 > tmp2";
#system "sed -e 's/stap_params_include/${file_name}_sTAP_soc_param_values/'g tmp2 > tmp3";
#system "sed -e 's/}/};/'g tmp3 > tmp4";
#system "sed -e 's/;;/;/'g tmp4 > tmp5";
#system "sed -e 's/;,/,/'g tmp5 > tmp6";
#system "sed -e 's/};}/}}/'g tmp6 > tmp7";
#system "sed -e 's/STAP_SECURE_GREEN};/STAP_SECURE_GREEN}/'g tmp7 > tmp8";
#close (output_tmp);
#system "mv tmp8 ${file_name}_sTAP_soc_param_values.inc";
#system "rm -r tmp7 tmp6 tmp5 tmp4 tmp3 tmp2 tmp1";

print "\n\n\n\n";
print "Parameter file generation is completed...\n\n";
print "To run standalone simulation:\n";
print "     cp  stap_params_include.inc ../source/rtl/include/stap_params_include.inc\n";
print "     cp  tb_param.inc  ../verif/tb/include/tb_param.inc\n\n";
print "For sTAP integration in SoC/Cluster/OtherIP:\n";
print "     Use this file - ${file_name}_sTAP_soc_param_values.inc\n";
print "     Use this file - ${file_name}_sTAP_soc_param_overide.inc\n";
print "     Use this file - ${file_name}_stap_params_include.inc\n\n";
print "For sTAP instantiation by splitting the TDR & RTDR signals:\n";
print "     Use this file - ${file_name}_stap_instance.sv\n";

## Code for generating instantiation file. This will split the remote and tdr_data_in bus according to opcodes
open (instance_file, ">${file_name}_stap_instance.sv");

print instance_file "//----------------------------------------------------------------------\n";
print instance_file "// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved\n";
print instance_file "//----------------------------------------------------------------------\n";
print instance_file "// NOTE: Log history is at end of file.\n";
print instance_file "//----------------------------------------------------------------------\n";
print instance_file "//\n";
print instance_file "//    FILENAME    : stap_instance.sv\n";
print instance_file "//    DESIGNER    : Rakesh Kandula\n";
print instance_file "//    PROJECT     : sTAP\n";
print instance_file "//\n";
print instance_file "//    PURPOSE     : To instantiate sTAP Top Level\n";
print instance_file "//    DESCRIPTION :\n";
print instance_file "//       This is top module which instantiates the sTAP Top Level.\n";
print instance_file "//----------------------------------------------------------------------\n";
print instance_file "\n";
#print instance_file "// Parameters\n";
#print instance_file "`include \"${file_name}_sTAP_soc_param_values.inc\"\n";
#print instance_file "\n";
print instance_file "module stap_instance\n";
print instance_file "  #(\n";
print instance_file "    // Parameters\n";
#NEW Code added
print instance_file "    `include \"${file_name}_stap_params_include.inc\"\t \/\/HSD\:1204862651\n";    
print instance_file "   )\n";
#NEW Code added
print instance_file "   (\n";
print instance_file "   // // -----------------------------------------------------------------\n";
print instance_file "   // // Primary JTAG ports\n";
print instance_file "   // // -----------------------------------------------------------------\n";
print instance_file "   input  logic        ftap_tck,\n";
print instance_file "   input  logic        ftap_tms,\n";
print instance_file "   input  logic        ftap_trst_b,\n";
print instance_file "   input  logic        ftap_tdi,\n";
print instance_file "   input  logic [31:0] ftap_slvidcode,\n";
print instance_file "   output logic        atap_tdo,\n";
print instance_file "   output logic        atap_tdoen,\n";
print instance_file "   input  logic        fdfx_powergood,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Parallel ports of optional data registers\n";
print instance_file "   // -----------------------------------------------------------------\n";
## For TDR
if ($STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0)
{
print instance_file "   output logic        tdr_data_out,\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "   output logic [";
         print instance_file  $dw[$i] - 1, ":" ;
         print instance_file  0, "] ";
         print instance_file "tdr_data_out_", $address[$i], ",\n";
      }
      else
      {
         print instance_file "   output logic [";
         print instance_file  $dw[$i] - 1, ":" ;
         print instance_file  0, "] ";
         print instance_file "tdr_data_out_", $address[$i], ",\n";
      }
   }
}
if ($STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0)
{
   print instance_file "   input  logic        tdr_data_in,\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "   input  logic [";
         print instance_file  $dw[$i] - 1, ":" ;
         print instance_file  0, "] ";
         print instance_file "tdr_data_in_", $address[$i], ",\n";
      }
      else
      {
         print instance_file "   input  logic [";
         print instance_file  $dw[$i] - 1, ":" ;
         print instance_file  0, "] ";
         print instance_file "tdr_data_in_", $address[$i], ",\n";
      }
   }
}
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // DFX Secure signals\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   input  logic [3:0] fdfx_secure_policy,\n";
print instance_file "   input  logic       fdfx_earlyboot_exit,\n";
print instance_file "   input  logic       fdfx_policy_update,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Control signals to 0.7 TAPNetwork\n";
print instance_file "   // -----------------------------------------------------------------\n";
#print instance_file "   output logic [(((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_secsel,\n";
#print instance_file "   output logic [(((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletdo,\n";
#print instance_file "   output logic [(((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletap,\n";
print instance_file "   output logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_secsel,\n";
print instance_file "   output logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletdo,\n";
print instance_file "   output logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletap,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Primary JTAG ports to 0.7 TAPNetwork\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic                                                 sntapnw_ftap_tck,\n";
print instance_file "   output logic                                                 sntapnw_ftap_tms,\n";
print instance_file "   output logic                                                 sntapnw_ftap_trst_b,\n";
print instance_file "   output logic                                                 sntapnw_ftap_tdi,\n";
print instance_file "   input  logic                                                 sntapnw_atap_tdo,\n";
#print instance_file "   input  logic [(((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo_en,\n";
print instance_file "   input  logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo_en,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Secondary JTAG ports\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   input  logic ftapsslv_tck,\n";
print instance_file "   input  logic ftapsslv_tms,\n";
print instance_file "   input  logic ftapsslv_trst_b,\n";
print instance_file "   input  logic ftapsslv_tdi,\n";
print instance_file "   output logic atapsslv_tdo,\n";
print instance_file "   output logic atapsslv_tdoen,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Secondary JTAG ports to 0.7 TAPNetwork\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic                                                 sntapnw_ftap_tck2,\n";
print instance_file "   output logic                                                 sntapnw_ftap_tms2,\n";
print instance_file "   output logic                                                 sntapnw_ftap_trst2_b,\n";
print instance_file "   output logic                                                 sntapnw_ftap_tdi2,\n";
print instance_file "   input  logic                                                 sntapnw_atap_tdo2,\n";
#print instance_file "   input  logic [(((${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo2_en,\n";
print instance_file "   input  logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : ${file_name}_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo2_en,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Control Signals common to WTAP/WTAP Network\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic sn_fwtap_wrck,\n";
print instance_file "   output logic sn_fwtap_wrst_b,\n";
print instance_file "   output logic sn_fwtap_capturewr,\n";
print instance_file "   output logic sn_fwtap_shiftwr,\n";
print instance_file "   output logic sn_fwtap_updatewr,\n";
print instance_file "   output logic sn_fwtap_rti,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Control Signals only to WTAP Network\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic                                              sn_fwtap_selectwir,\n";
#print instance_file "   input  logic [(((${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (${file_name}_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : ${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK)- 1):0] sn_awtap_wso,\n";
#print instance_file "   output logic [(((${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (${file_name}_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : ${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK) - 1):0] sn_fwtap_wsi,\n";
print instance_file "   input  logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (${file_name}_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : ${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK)- 1):0] sn_awtap_wso,\n";
print instance_file "   output logic [(((${file_name}_STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (${file_name}_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : ${file_name}_STAP_NUMBER_OF_WTAPS_IN_NETWORK) - 1):0] sn_fwtap_wsi,\n";

print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Boundary Scan Signals\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Control Signals from fsm\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic stap_fbscan_tck,\n";
print instance_file "   input  logic stap_abscan_tdo,\n";
print instance_file "   output logic stap_fbscan_capturedr,\n";
print instance_file "   output logic stap_fbscan_shiftdr,\n";
print instance_file "   output logic stap_fbscan_updatedr,\n";
print instance_file "   output logic stap_fbscan_updatedr_clk,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Instructions\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic stap_fbscan_runbist_en,\n";
print instance_file "   output logic stap_fbscan_highz,\n";
print instance_file "   output logic stap_fbscan_extogen,\n";
print instance_file "   output logic stap_fbscan_intest_mode,\n";
print instance_file "   output logic stap_fbscan_chainen,\n";
print instance_file "   output logic stap_fbscan_mode,\n";
print instance_file "   output logic stap_fbscan_extogsig_b,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // 1149.6 AC mode\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   output logic stap_fbscan_d6init,\n";
print instance_file "   output logic stap_fbscan_d6actestsig_b,\n";
print instance_file "   output logic stap_fbscan_d6select,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Isolation Enable\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   input logic stap_isol_en_b,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   input logic ftap_pwrdomain_rst_b,\n";
print instance_file "   output logic stap_fsm_tlrs,\n";
print instance_file "   // -----------------------------------------------------------------\n";
print instance_file "   // Remote Test data register\n";
print instance_file "   // -----------------------------------------------------------------\n";
## For remote TDR
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   print instance_file "   input  logic                                                           rtdr_tap_tdo", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      print instance_file "   input  logic                                                           rtdr_tap_tdo_", $rem_address[$i], ",\n";
   }
}
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   print instance_file "   output logic                                                           tap_rtdr_irdec", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      print instance_file "   output logic                                                           tap_rtdr_irdec_", $rem_address[$i], ",\n";
   }
}
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   print instance_file "   output logic                                                           tap_rtdr_prog_rst_b", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      print instance_file "   output logic                                                           tap_rtdr_prog_rst_b_", $rem_address[$i], ",\n";
   }
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "   output logic                                                           tap_rtdr_tdi", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
       print instance_file "   output logic                                                           tap_rtdr_tdi_", $rem_address[$i], ",\n";
   }
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "   output logic                                                           tap_rtdr_capture", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
       print instance_file "   output logic                                                           tap_rtdr_capture_", $rem_address[$i], ",\n";
   }
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "   output logic                                                           tap_rtdr_shift", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
       print instance_file "   output logic                                                           tap_rtdr_shift_", $rem_address[$i], ",\n";
   }
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "   output logic                                                           tap_rtdr_update", ",\n";
}
else
{
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
       print instance_file "   output logic                                                           tap_rtdr_update_", $rem_address[$i], ",\n";
   }
}
print instance_file "   output logic                                                           tap_rtdr_tck,\n";
print instance_file "   output logic                                                           tap_rtdr_powergood,\n";
print instance_file "   output logic                                                           tap_rtdr_selectir,\n";
print instance_file "   output logic                                                           tap_rtdr_rti\n";
print instance_file "   );\n";
print instance_file "\n";
print instance_file "    //sTAP Top Instance\n";
print instance_file "   stap #(";
print instance_file "`include \"${file_name}_sTAP_soc_param_overide.inc\"";
print instance_file ")\n";
print instance_file "   stap_inst (\n";
print instance_file "              //Primary JTAG ports\n";
print instance_file "              .ftap_tck                  (ftap_tck),\n";
print instance_file "              .ftap_tms                  (ftap_tms),\n";
print instance_file "              .ftap_trst_b               (ftap_trst_b),\n";
print instance_file "              .ftap_tdi                  (ftap_tdi),\n";
print instance_file "              .ftap_slvidcode            (ftap_slvidcode),\n";
print instance_file "              .atap_tdo                  (atap_tdo),\n";
print instance_file "              .atap_tdoen                (atap_tdoen),\n";
print instance_file "              .fdfx_powergood            (fdfx_powergood),\n";
print instance_file "\n";
print instance_file "              //Parallel ports of optional data registers\n";
## For TDR
if ($STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0)
{
   print instance_file "              .tdr_data_out              (tdr_data_out),\n";
}
else
{
   print instance_file "              .tdr_data_out              ({";
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "tdr_data_out_", $address[$i];
      }
      else
      {
         print instance_file "tdr_data_out_", $address[$i], ",";
      }
   }
   print instance_file "}),\n";
}
if ($STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0)
{
   print instance_file "              .tdr_data_in               (tdr_data_in),\n";
}
else
{
   print instance_file "              .tdr_data_in               ({";
   for ($i = $STAP_NUMBER_OF_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "tdr_data_in_", $address[$i];
      }
      else
      {
         print instance_file "tdr_data_in_", $address[$i], ",";
      }
   }
   print instance_file "}),\n";
}
print instance_file "\n";
print instance_file "              //Lock signals\n";
print instance_file "              .fdfx_secure_policy        (fdfx_secure_policy),\n";
print instance_file "              .fdfx_earlyboot_exit       (fdfx_earlyboot_exit),\n";
print instance_file "              .fdfx_policy_update        (fdfx_policy_update),\n";
print instance_file "\n";
print instance_file "              //Control signals to Slave TAPNetwork\n";
print instance_file "              .sftapnw_ftap_secsel       (sftapnw_ftap_secsel),\n";
print instance_file "              .sftapnw_ftap_enabletdo    (sftapnw_ftap_enabletdo),\n";
print instance_file "              .sftapnw_ftap_enabletap    (sftapnw_ftap_enabletap),\n";
print instance_file "\n";
print instance_file "              //Primary JTAG ports to Slave TAPNetwork\n";
print instance_file "              .sntapnw_ftap_tck          (sntapnw_ftap_tck),\n";
print instance_file "              .sntapnw_ftap_tms          (sntapnw_ftap_tms),\n";
print instance_file "              .sntapnw_ftap_trst_b       (sntapnw_ftap_trst_b),\n";
print instance_file "              .sntapnw_ftap_tdi          (sntapnw_ftap_tdi),\n";
print instance_file "              .sntapnw_atap_tdo          (sntapnw_atap_tdo),\n";
print instance_file "              .sntapnw_atap_tdo_en       (sntapnw_atap_tdo_en),\n";
print instance_file "\n";
print instance_file "              //Secondary JTAG Ports\n";
print instance_file "              .ftapsslv_tck              (ftapsslv_tck),\n";
print instance_file "              .ftapsslv_tms              (ftapsslv_tms),\n";
print instance_file "              .ftapsslv_trst_b           (ftapsslv_trst_b),\n";
print instance_file "              .ftapsslv_tdi              (ftapsslv_tdi),\n";
print instance_file "              .atapsslv_tdo              (atapsslv_tdo),\n";
print instance_file "              .atapsslv_tdoen            (atapsslv_tdoen),\n";
print instance_file "\n";
print instance_file "              //Secondary JTAG ports to Slave TAPNetwork\n";
print instance_file "              .sntapnw_ftap_tck2         (sntapnw_ftap_tck2),\n";
print instance_file "              .sntapnw_ftap_tms2         (sntapnw_ftap_tms2),\n";
print instance_file "              .sntapnw_ftap_trst2_b      (sntapnw_ftap_trst2_b),\n";
print instance_file "              .sntapnw_ftap_tdi2         (sntapnw_ftap_tdi2),\n";
print instance_file "              .sntapnw_atap_tdo2         (sntapnw_atap_tdo2),\n";
print instance_file "              .sntapnw_atap_tdo2_en      (sntapnw_atap_tdo2_en),\n";
print instance_file "\n";
print instance_file "              //Control Signals  common to WTAP/WTAP Network\n";
print instance_file "              .sn_fwtap_wrck             (sn_fwtap_wrck),\n";
print instance_file "              .sn_fwtap_wrst_b           (sn_fwtap_wrst_b),\n";
print instance_file "              .sn_fwtap_capturewr        (sn_fwtap_capturewr),\n";
print instance_file "              .sn_fwtap_shiftwr          (sn_fwtap_shiftwr),\n";
print instance_file "              .sn_fwtap_updatewr         (sn_fwtap_updatewr),\n";
print instance_file "              .sn_fwtap_rti              (sn_fwtap_rti),\n";
print instance_file "\n";
print instance_file "              //Control Signals only to WTAP Network\n";
print instance_file "              .sn_fwtap_selectwir        (sn_fwtap_selectwir),\n";
print instance_file "              .sn_awtap_wso              (sn_awtap_wso),\n";
print instance_file "              .sn_fwtap_wsi              (sn_fwtap_wsi),\n";
print instance_file "\n";
print instance_file "              //Boundary Scan Signals\n";
print instance_file "\n";
print instance_file "              //Control Signals from fsm\n";
print instance_file "              .stap_fbscan_tck           (stap_fbscan_tck),\n";
print instance_file "              .stap_abscan_tdo           (stap_abscan_tdo),\n";
print instance_file "              .stap_fbscan_capturedr     (stap_fbscan_capturedr),\n";
print instance_file "              .stap_fbscan_shiftdr       (stap_fbscan_shiftdr),\n";
print instance_file "              .stap_fbscan_updatedr      (stap_fbscan_updatedr),\n";
print instance_file "              .stap_fbscan_updatedr_clk  (stap_fbscan_updatedr_clk),\n";
print instance_file "\n";
print instance_file "              //Instructions\n";
print instance_file "              .stap_fbscan_runbist_en    (stap_fbscan_runbist_en),\n";
print instance_file "              .stap_fbscan_highz         (stap_fbscan_highz),\n";
print instance_file "              .stap_fbscan_extogen       (stap_fbscan_extogen),\n";
print instance_file "              .stap_fbscan_intest_mode   (stap_fbscan_intest_mode),\n";
print instance_file "              .stap_fbscan_chainen       (stap_fbscan_chainen),\n";
print instance_file "              .stap_fbscan_mode          (stap_fbscan_mode),\n";
print instance_file "              .stap_fbscan_extogsig_b    (stap_fbscan_extogsig_b),\n";
print instance_file "\n";
print instance_file "              //1149.6 AC mode\n";
print instance_file "              .stap_fbscan_d6init        (stap_fbscan_d6init),\n";
print instance_file "              .stap_fbscan_d6actestsig_b (stap_fbscan_d6actestsig_b),\n";
print instance_file "              .stap_fbscan_d6select      (stap_fbscan_d6select),\n";
print instance_file "\n";

print instance_file "              //STAP Isolation Enable\n";
print instance_file "               .stap_isol_en_b           (stap_isol_en_b),\n";
print instance_file "               .ftap_pwrdomain_rst_b     (ftap_pwrdomain_rst_b),\n";
print instance_file "               .stap_fsm_tlrs            (stap_fsm_tlrs),\n";
print instance_file "\n";

print instance_file "              //Remote Test Data Register pins\n";
## For remote TDR
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   print instance_file "              .rtdr_tap_tdo              (rtdr_tap_tdo),\n";
}
else
{
   print instance_file "              .rtdr_tap_tdo              ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "rtdr_tap_tdo_", $rem_address[$i], "";
      }
      else
      {
         print instance_file "rtdr_tap_tdo_", $rem_address[$i], ",";
      }
   }
   print instance_file "}),\n";
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "              .tap_rtdr_tdi              (tap_rtdr_tdi),\n";
}
else
{
   print instance_file "              .rtdr_tap_tdi              ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
     if ($i == 0)
     {
        print instance_file "rtdr_tap_tdi_", $rem_address[$i], "";
     }
     else
     {
        print instance_file "rtdr_tap_tdi_", $rem_address[$i], ",";
     }
   }
   print instance_file "}),\n";
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "              .tap_rtdr_capture          (tap_rtdr_capture),\n";
}
else
{
   print instance_file "              .tap_rtdr_capture          ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
     if ($i == 0)
     {
        print instance_file "tap_rtdr_capture_", $rem_address[$i], "";
     }
     else
     {
        print instance_file "tap_rtdr_capture_", $rem_address[$i], ",";
     }
   }
   print instance_file "}),\n";
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "              .tap_rtdr_shift            (tap_rtdr_shift),\n";
}
else
{
   print instance_file "              .tap_rtdr_shift            ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
     if ($i == 0)
     {
        print instance_file "tap_rtdr_shift_", $rem_address[$i], "";
     }
     else
     {
        print instance_file "tap_rtdr_shift_", $rem_address[$i], ",";
     }
   }
   print instance_file "}),\n";
}
if ($STAP_RTDR_IS_BUSSED == 0)
{
   print instance_file "              .tap_rtdr_update           (tap_rtdr_update),\n";
}
else
{
   print instance_file "              .tap_rtdr_update           ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
     if ($i == 0)
     {
        print instance_file "tap_rtdr_update_", $rem_address[$i], "";
     }
     else
     {
        print instance_file "tap_rtdr_update_", $rem_address[$i], ",";
     }
   }
   print instance_file "}),\n";
}
print instance_file "              .tap_rtdr_selectir         (tap_rtdr_selectir),\n";
print instance_file "              .tap_rtdr_powergood        (tap_rtdr_powergood),\n";
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   print instance_file "              .tap_rtdr_irdec            (tap_rtdr_irdec),\n";
}
else
{
   print instance_file "              .tap_rtdr_irdec            ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "tap_rtdr_irdec_", $rem_address[$i], "";
      }
      else
      {
         print instance_file "tap_rtdr_irdec_", $rem_address[$i], ",";
      }
   }
   print instance_file "}),\n";
}
print instance_file "              .tap_rtdr_tck              (tap_rtdr_tck),\n";
print instance_file "              .tap_rtdr_rti              (tap_rtdr_rti),\n";
if ($STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0)
{
   print instance_file "              .tap_rtdr_prog_rst_b       (tap_rtdr_prog_rst_b)\n";
}
else
{
   print instance_file "              .tap_rtdr_prog_rst_b       ({";
   for ($i = $STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS - 1; $i >= 0; $i--)
   {
      if ($i == 0)
      {
         print instance_file "tap_rtdr_prog_rst_b_", $rem_address[$i], "";
      }
      else
      {
         print instance_file "tap_rtdr_prog_rst_b_", $rem_address[$i], ",";
      }
   }
   print instance_file "})\n";
}
print instance_file "             );\n";
print instance_file "\n";
print instance_file "endmodule\n";
