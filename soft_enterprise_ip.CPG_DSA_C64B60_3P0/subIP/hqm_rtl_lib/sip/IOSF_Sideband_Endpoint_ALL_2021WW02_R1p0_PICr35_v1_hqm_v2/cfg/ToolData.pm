#!/usr/intel/bin/perl -w

use warnings FATAL => 'all';
package ToolData;

### BEGIN { 
###    # our $TSA_VER_DEFAULT = "1713.17ww38c";
###    # our $TSA_VER_DEFAULT = "1713plus.17ww48e"; # Needed for SGLINT
###    # our $TSA_VER_DEFAULT = "1713plus.17ww50f"; # Needed for SGCDC
###    # our $TSA_VER_DEFAULT = "1813.18ww04b"; # HDK 1.5
###    # our $TSA_VER_DEFAULT = "1813.18ww09c"; # HDK 1.5
###    # our $TSA_VER_DEFAULT = "1813.18ww13d"; # HDK 1.5
###    # our $TSA_VER_DEFAULT = '18.15.06'; # HDK 1.5
###    our $TSA_VER_DEFAULT = "1813.18ww15g"; # HDK 1.5
###    our $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/baseline_tools/sip_tsa/$TSA_VER_DEFAULT";
###         $TSA_PATH = "$ENV{TSA_PATH_OVR}" if (defined $ENV{TSA_PATH_OVR});
###    push @INC, "${TSA_PATH}/lib/Perl"; 
### };

BEGIN { 
# our $TSA_VER_DEFAULT = "18.37.00"; #HDK 1.5 TSA prime
 our $TSA_VER_DEFAULT = "20.36.06"; # s14nm
 our $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/tsa/master/$TSA_VER_DEFAULT";
 $TSA_PATH = "$ENV{TSA_PATH_OVR}" if (defined $ENV{TSA_PATH_OVR});
   push @INC, "${TSA_PATH}/lib/Perl";

};

use File::Basename;
use Data::Dumper;
use TSA::InitToolData;
use Cwd 'abs_path';
use Switch;
use Exporter ();
@ISA    = qw(Exporter);
@EXPORT = qw( %ToolConfig_int %general_vars %ToolConfig_tools %onecfg);

$onecfg{Facet} = {
    values => {
        CUST    => ['p1273', 'p1274', 's14nm', 'n7', 'n6'],
        dut     => ['sbe',],
        scope   => ['hqm_IOSF_SBC_EP'],
    },
    defaults => {
        dut => 'sbe',
        CUST => 'p1273',
        scope => 'hqm_IOSF_SBC_EP',
    },
    implications => {
       'CUST=p1274' => { toolset => 'mat1.6.4.p2', process => 'p1274' }, # CUST is not pre-registered, process needs explicitely to be defined.
#       'CUST=p1274' => { toolset => 'm1813', process => 'p1274' }, # CUST is not pre-registered, process needs explicitely to be defined.
       'CUST=p1273' => { toolset => 'mat1.4L.11.p0', process => 'p1273' },
       'CUST=n7' => { toolset => 'mat1.6.1.p6', process => 'n7', dot_process => '.0', upf_version => '2.0', STDLIB_TYPE => 'h240', VT_TYPE => 'lvt8' },
       'CUST=n6' => { toolset => 'mat1.6.1.p7', process => 'n6', dot_process => '.0', upf_version => '2.0', STDLIB_TYPE => 'h240', VT_TYPE => 'svt8' },
       'CUST=s14nm' => { toolset => 'mat1.6.4.p1', process => 's14nm', STDLIB_TYPE => 'A9T' },
    },
};
our ($DUT,$CUST) = &InitToolData(
       -no_default_CUST => 1,
       -onecfg_ptr     => \%onecfg,
);

delete $onecfg{Facet}{defaults}{toolset};


#-------VC_CONTOUR VERSION---------#
$ToolConfig_tools{vc_contour}{VERSION} = "1.9.20ww07a"; #"1.7.19ww30a"; # vc_contour-chs-a0-18ww45a";
$ToolConfig_tools{vc_contour}{PATH}    = "$ENV{RTL_CAD_ROOT}/val_ip/vc_contour/&get_tool_version()";


$ENV{LM_PROJECT} = 'EIG_FABRIC';

# might not need this, can use verdefault directly
my $TSA_VER = $TSA_VER_DEFAULT;

&LoadToolData(
   -CUST           => "$CUST",
   -TSA_VER        => "$TSA_VER",
   -onecfg_ptr     => \%onecfg,
);

$ToolConfig::MyVersion = 9;
1;

