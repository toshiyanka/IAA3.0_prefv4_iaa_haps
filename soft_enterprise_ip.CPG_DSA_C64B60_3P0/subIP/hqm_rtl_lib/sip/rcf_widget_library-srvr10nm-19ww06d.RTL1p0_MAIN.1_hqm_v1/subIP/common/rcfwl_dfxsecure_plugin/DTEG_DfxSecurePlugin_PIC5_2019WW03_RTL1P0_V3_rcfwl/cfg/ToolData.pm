#!/usr/intel/bin/perl -w

use warnings FATAL => 'all';

package ToolData;

BEGIN { 

  our $TSA_VER_DEFAULT = "18.37.04";
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
			ADL
			ADP
		    TGL
			ADPS
		    TGPLP
		    ICPLP
		    CDF
	)],
	dut  => [qw(
        )],
        VT_TYPE => [qw(
                        wn
        )],
      },

      defaults => {
	 dut => "dfxsecure_plugin",
	 CUST => "ADL",
      },
	  
	 implications => {
       'CUST=ADL' => { toolset => 'mat1.5.3.p0' },
       'CUST=ADP' => { toolset => 'mat1.4.10a.p3' },
       'CUST=ADPS'  => { toolset => 'm1713f.p2',process => 's14nm',},
     },
 };

our ($DUT,$CUST) = &InitToolData(
    -no_default_CUST => 1,
    -onecfg_ptr => \%onecfg,
);
delete $onecfg{Facet}{defaults}{toolset};

my $TSA_VER;
#switch ($CUST) {
#    case "CNPLP" { $TSA_VER = '1.02.10' } 
#    else { $TSA_VER = "$TSA_VER_DEFAULT" } 
#};

&LoadToolData( 
    -CUST => "$CUST",
    -TSA_VER => "$TSA_VER_DEFAULT",
    -onecfg_ptr => \%onecfg,
);

#$ToolConfig::MyVersion = 9;

1;
