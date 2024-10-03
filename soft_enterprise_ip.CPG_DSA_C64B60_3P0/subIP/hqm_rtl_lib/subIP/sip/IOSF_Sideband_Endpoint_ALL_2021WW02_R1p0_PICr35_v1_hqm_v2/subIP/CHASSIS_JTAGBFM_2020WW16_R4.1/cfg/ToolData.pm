#!/usr/intel/bin/perl -w

use warnings FATAL => 'all';

package ToolData;

BEGIN { 

  #our $TSA_VER_DEFAULT = "19.12.03";  # 1813.18ww13d"
  our $TSA_VER_DEFAULT = "19.46.05";
#  our $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/baseline_tools/sip_tsa/$TSA_VER_DEFAULT";
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
@ISA = qw(Exporter);
@EXPORT = qw( %ToolConfig_int %general_vars %ToolConfig_tools %onecfg);
$ENV{LM_PROJECT} = 'DTEG';
$onecfg{Facet} = {
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
		    TGPLP
            ADPS
			ADL
			ADP
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
	 dut => "idvp",
	 #CUST => "ADL",
	 CUST => "GNR",
      },
	  implications => {
       'CUST=ADL' => { toolset => 'mat1.5.9.p0',},
       #'CUST=GNR' => { toolset => 'mat1.5.9.p0',},
       'CUST=ADP' => { toolset => 'mat1.4.10a.p3'},
       'CUST=ADPS'  => { toolset => 'm1713f.p2',process => 's14nm',},
       'CUST=GNR' => { toolset => 'mat1.6.1.p1', process => 'p1276', dot_process => '.31', UPF_VER => '2.0', upf_version => '2.0', STDLIB_TYPE => 'g1m', VT_TYPE => 'bn' },
     },
 };

our ($DUT,$CUST) = &InitToolData(
    -no_default_CUST => 1,
    -onecfg_ptr => \%onecfg,
);
delete $onecfg{Facet}{defaults}{toolset};

my $TSA_VER;
#switch ($CUST) {
#    case "CNPLP" { $TSA_VER = "$TSA_VER_DEFAULT"} 
#    else { $TSA_VER = "$TSA_VER_DEFAULT" } 
#};

&LoadToolData( 
    -CUST => "$CUST",
    -TSA_VER => "$TSA_VER_DEFAULT",
    -onecfg_ptr => \%onecfg,
);


1;
