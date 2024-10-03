#!/usr/intel/bin/perl -w

use warnings FATAL => 'all';
package ToolData;

BEGIN {
our $TSA_VER_DEFAULT = "1813.18ww13d";

       $TSA_PATH = "$ENV{RTL_PROJ_TOOLS}/baseline_tools/sip_tsa/$TSA_VER_DEFAULT";
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
        CUST    => [ 'p1273', 'p1274' ],
        dut     => ['pgcb_collection',],
        VT_TYPE => ['gd', 'wn' ],
    },
    defaults => {
        dut => 'pgcb_collection',
        CUST => 'p1274',
    },
};


my $TSA_VER;
switch ($CUST) {
   # We don't need these lines if they are just going to be set to DEFAULT anyway - xsaw
   case "p1273" { $TSA_VER = "$TSA_VER_DEFAULT" }
   case "p1274" { $TSA_VER = "$TSA_VER_DEFAULT" }

   else         { $TSA_VER = "$TSA_VER_DEFAULT" }
};

our ($DUT,$CUST) = &InitToolData(
       -no_default_CUST => 1,
       -onecfg_ptr     => \%onecfg,
);

&LoadToolData(
   -CUST           => "$CUST",
   -TSA_VER        => "$TSA_VER",
   -onecfg_ptr     => \%onecfg,
);
#------------------------------------------------------
# EFFM 
#------------------------------------------------------
#VR needs to be removed or migrated to LocalToolData_*.pm
$ToolConfig_tools{effm} = {
   VERSION => '2015.23',
   PATH => "$RTL_CAD_ROOT/intel/effm/&get_tool_version()",
   SUB_TOOLS => {
      "synplifypro" => "&get_tool(synplifypro)",
   },
};


$ToolConfig::MyVersion = 9;
1;
