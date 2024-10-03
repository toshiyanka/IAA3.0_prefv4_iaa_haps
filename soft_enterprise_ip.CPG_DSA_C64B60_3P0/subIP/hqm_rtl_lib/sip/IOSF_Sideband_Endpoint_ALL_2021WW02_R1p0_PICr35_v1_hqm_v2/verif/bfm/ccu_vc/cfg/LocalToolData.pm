#-*-perl-*-
#--------------------------------------------------------------------------------
# INTEL CONFIDENTIAL
#
# Copyright (June 2005)2 (May 2008)3 Intel Corporation All Rights Reserved.
# The source code contained or described herein and all documents related to the
# source code ("Material") are owned by Intel Corporation or its suppliers or
# licensors. Title to the Material remains with Intel Corporation or its
# suppliers and licensors. The Material contains trade secrets and proprietary
# and confidential information of Intel or its suppliers and licensors. The
# Material is protected by worldwide copyright and trade secret laws and treaty
# provisions. No part of the Material may be used, copied, reproduced, modified,
# published, uploaded, posted, transmitted, distributed, or disclosed in any way
# without Intels prior express written permission.
#
# No license under any patent, copyright, trade secret or other intellectual
# property right is granted to or conferred upon you by disclosure or delivery
# of the Materials, either expressly, by implication, inducement, estoppel or
# otherwise. Any license under such intellectual property rights must be express
# and approved by Intel in writing.
#
#--------------------------------------------------------------------------------
# Author: vromaso
#
# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
#
use warnings FATAL => 'all';

package ToolData;

$general_vars{NBPOOL}  = 'NBPOOL_NAME';
$general_vars{NBCLASS} = 'NBCLASS_NAME';
$general_vars{NBQSLOT} = 'NBQSLOT_NAME';

#########################################################################
# START: VC Contour Setup
#########################################################################
BEGIN {#Code in begin block must run first to make it available for the "use lib" call. 
    $ToolData::ToolConfig_tools{ipconfig}{OTHER}{OVERRIDES_FIRST} = 1;# this should allow a vc to override itself. 
    my $VC_CONTOUR_RELEASE_AREA = "/nfs/site/disks/sbx_vccontour_models_00001/VC_RELEASE_DISK/SharedVal/Contours/intel/vc_contour";
    $ToolConfig_tools{vc_contour}{VERSION} = "0.0";
    $ToolConfig_tools{vc_contour}{PATH} = "$VC_CONTOUR_RELEASE_AREA/$ToolConfig_tools{vc_contour}{VERSION}";
}
use lib  $ToolConfig_tools{vc_contour}{PATH} . "/cfg";#This provides the full path to where the vc_contour_API.pm is
use vc_contour_API qw(import_files get_version_from_path do_with_warn); #we need at least the do_with_warn method
do_with_warn "$ToolConfig_tools{vc_contour}{PATH}/cfg/vc_contour_IPToolData.pm";
#########################################################################
# END: VC Contour Setup
#########################################################################


my %LocalToolData = (

 # example on how to override Tool VERSION and/or PATH 
 #nebulon => {
 #       VERSION => "2.07p3",
 #       PATH    => "/p/com/eda/intel/nebulon/2.07p3",
 #},
 tsa_shell => {
     #For each $ENV{<SOMETHINGS_ENV_VAR>} reference in a UDF/HDL, there must be both
     # a corresponding $ToolConfig_ips{<SOMETHING>}{ENV}{<SOMETHINGS_ENV_VAR>}
     # and a '<SOMETHING>' in the tsetup_add, in order for TSA-based envs
     # to be able to locate the ENV vars and set them into the env.
     tsetup_add => [
         'saola',
         'vggnu', #used by saola in some cases, for C DPI
    	 'xvm',
         'uvm',
         'ovm', #its defaulted/automatically in there, but to be consistent...
	 ],

     # example to ADD environment variables to ACE-shell
     setenv => [
             'GCC_LIB_VER gcc-4.2.2_64',#necessary for saola
     ],
 },
 tsa_dc_config => {
     # Plug-in SIP specific ACE commands 
     lintra_build => {
         #-command => "ace -ccolt -use_lint_compile_options -filter Lint",
     },
     lintra_elab => {
         #-command => 'ace -sc -t <BLOCK> ',
     },
     spyglass_build => {
         #-command => "ace -ccsg -use_lint_compile_options -filter Lint",
     },
     spyglass_lp => {
         #-ace_args => '-sc -t <BLOCK> ',
     },
     sgdft => {
         drc => {
             -ace_args => '-noenable_runsim_postsim_checks -noenable_onda_postchecker -results FEBE.sgdft',
         },
     },
     power_artist => {
         -setenv => { LM_PROJECT => "...", },
     }, 
 },
 tsa_finalized => {
     finalized => {
       # configure FEBE design blocks here
       'BLOCK_NAME' => {
         -dut           => [ '&get_facet(dut)' ],
         -lib_variant => "&get_facet(VT_TYPE)",
         -stdlib_type => "&get_facet(STDLIB_TYPE)",
         -block_type      => 'unit',
         -enable_sg_dft   => 0,
         -enable_gkturnin => 0,
         -rm_ctech_files  => [".*\/source/v/ctech_lib_.*.v", ],
         -rm_defines      => [],
       },
     },
 }, #end tsa_finalized

);

# function that merges %LocalToolData with %ToolConfig_tools
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);

#--------------------------------------------------------------
1;
