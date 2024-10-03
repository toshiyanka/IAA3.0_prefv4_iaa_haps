#!/usr/intel/bin/perl -w
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

use warnings FATAL => 'all';
package ToolData;

BEGIN { 
   our $TSA_VER_DEFAULT = "18.15.00";
       $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/tsa/master/$TSA_VER_DEFAULT";
   push @INC, "${TSA_PATH}/lib/Perl"; 
};
use File::Basename;
use Data::Dumper;
use TSA::InitToolData;
use Cwd 'abs_path';
use Switch;
use Exporter ();
@ISA    = qw(Exporter);
@EXPORT = qw( %ToolConfig_int %general_vars %ToolConfig_tools %ToolConfig_ips %onecfg);

$onecfg{Facet} = {
    values => {
        stepping => ['chs-a0'],
        cluster => ['ChassisPowerGatingVC'],
        project => ['chs'],
        domain => ['sbxhdk', 'sip', 'cds'],
        CUST => [ 'SIIP'],
        dut  => [ 'ChassisPowerGatingVC', ],
        ## other unique facet names and values
    },
    defaults => {
        dut => "ChassisPowerGatingVC",
        CUST => "SIIP",
        process => "p1274", #shouldn't matter; have to pick something.
        # other default facet settings
    },
};

our ($DUT,$CUST) = &InitToolData(
       -onecfg_ptr     => \%onecfg,
);



# Load ToolData
&LoadToolData(
   -CUST           => "$CUST",
   -TSA_VER        => "$TSA_VER_DEFAULT",
   -onecfg_ptr     => \%onecfg,
);
$ToolConfig_tools{ipconfig}{SUB_TOOLS} = \%ToolConfig_ips;

$ToolConfig::MyVersion = 9;
1;
