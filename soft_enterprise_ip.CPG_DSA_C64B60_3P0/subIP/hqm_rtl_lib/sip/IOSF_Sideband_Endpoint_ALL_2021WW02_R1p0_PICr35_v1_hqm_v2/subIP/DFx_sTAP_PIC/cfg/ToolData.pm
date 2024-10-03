#!/usr/intel/bin/perl -w

use warnings FATAL => 'all';

package ToolData;
BEGIN {
 # our $TSA_VER_DEFAULT = '19.12.03';
  our $TSA_VER_DEFAULT = '19.46.02';

  # Note the change of TSA_PATH to tsa/master!!!
  $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/tsa/master/$TSA_VER_DEFAULT";

  $TSA_PATH = $ENV{TSA_PATH_OVR} if(defined $ENV{TSA_PATH_OVR});
  push @INC, "${TSA_PATH}/lib/Perl";
};
#BEGIN { 
#
#  #our $TSA_VER_DEFAULT = "1813.18ww04b"; #"1713.17ww38c";
#  our $TSA_VER_DEFAULT = "1813.18ww09c"; #"1713.17ww38c";
#  our $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/baseline_tools/sip_tsa/$TSA_VER_DEFAULT";
#  $TSA_PATH = "$ENV{TSA_PATH_OVR}" if (defined $ENV{TSA_PATH_OVR});
#  push @INC, "${TSA_PATH}/lib/Perl"; 
#
#};

use File::Basename;
use Data::Dumper;
use TSA::InitToolData;
use Cwd 'abs_path';
use Switch;
use Exporter ();
@ISA = qw(Exporter);
@EXPORT = qw( %ToolConfig_int %general_vars %ToolConfig_tools %onecfg);

$onecfg{Facet} = {

    implications => {
       'CUST=ADL'   => { toolset => 'mat1.5.9.p0'  },
       'CUST=ADP'   => { toolset => 'mat1.4.10a.p3'},
       'CUST=ADPS'  => { toolset => 'm1713f.p2',   process => 's14nm',},
       'CUST=LBG'  => {  process => 'p1222', VT_TYPE => 'ln' },
	   'CUST=MTPLP' => { toolset => 'mat1.6.1.p1', process => 'n7',    dot_process => '.0',  STDLIB_TYPE => 'h240', VT_TYPE => 'lvt8' },
       'CUST=GNR'   => { toolset => 'mat1.6.1.p1', process => 'p1276', dot_process => '.31', upf_version => '2.0', STDLIB_TYPE => 'g1m',  VT_TYPE => 'bn'   },
     },

    values => {
        CUST => [qw(
            BXT
            BXTP
            CNL
            CNPLP
            DNV
            LBG
            SPTH
            SPTLP    
            ICL
            TGL
            ADL
            ADP
            ADPS
            TGPLP
			MTPLP
            ICPLP
            CDF
            GNR
    )],
    dut  => [qw(
        )],
        VT_TYPE => [qw(
                        wn
        )],
      },

      defaults => {
     dut => "stap",
     #CUST => "ADL",
     CUST => "GNR",
      },
 };

our ($DUT,$CUST) = &InitToolData(
    -no_default_CUST => 0,
    -onecfg_ptr => \%onecfg,
);
delete $onecfg{Facet}{defaults}{toolset};

my $TSA_VER;
#switch ($CUST) {
#    case "CNPLP" { $TSA_VER = "$TSA_VER_DEFAULT" } 
#    else { $TSA_VER = "$TSA_VER_DEFAULT" } 
#};

&LoadToolData( 
    -CUST => "$CUST",
    -TSA_VER => "$TSA_VER_DEFAULT",
    -onecfg_ptr => \%onecfg,
);

$ToolConfig::MyVersion = 9;

$ENV{LM_PROJECT} = 'DTEG';
1;
