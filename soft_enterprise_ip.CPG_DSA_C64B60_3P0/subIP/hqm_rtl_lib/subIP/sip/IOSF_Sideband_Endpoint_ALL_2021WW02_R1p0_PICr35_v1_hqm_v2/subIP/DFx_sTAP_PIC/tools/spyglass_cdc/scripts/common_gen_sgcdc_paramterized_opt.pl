#!/usr/bin/perl
use strict;
use warnings;
# Author : Shrinidhi Deshpande
# Date   : 22-Nov-2018
# Desc   : perl <path_name>/common_gen_sgcdc_parameterized_opt.pl <subsystem_prefix>
# Using of ip_override_sgcdc_params.txt : Just enter the value of parameter you wish to override. Else let it be as it is. Dont remove the (=) equal to sign. Do not use any commas or semicolons
#
#

my $line = 0;
my $var = $ARGV[0];                 # Please specify the subsystem prefix name  
until ($var =~ /[a-zA-Z0-1000]/ )
{   
	   print "PLEASE ENTER THE PREFIX :";
	   $var=(<STDIN>);
	   chomp($var);
}
my $work_dir=`pwd`;                 # Please run this script in $IP_ROOT
chomp ($work_dir);

print "Please enter the IP name you wish to work on :\n\n ";
print "The List of IP names are : \n\n";
print "taplinknw \n";
print "stap\n";
print "dfxsecure_plugin\n";
print "idvp_controller\n";
print "cltapc\n";
print "tap2iosfsb\n";
print "lcp_controller\n";
print "odi_vdm_controller\n";
print "stf_hub\n";
print "stf_ep\n";


my $a=<STDIN>;
until ($a=~ /[a-zA-Z0-1000]/ )
{
   print "please enter IP name you wish to work on :";
   $a=<STDIN>;
   chomp($a);
}

######################################################STAP#######################################################################################
##


if ($a=~ "stap" )
{

my $file_name = "$work_dir/verif/tests/spyglasscdc/stap/stap.opt";        # input uniquified opt file for reading
my $file_name1 = "$work_dir/scripts/ip_override_sgcdc_params.txt";        # ip_override_sgcdc_params.txt for reading
my $file_name2 = "$work_dir/verif/tests/spyglasscdc/stap/stap_new.opt";   # output file  

open(my $fh, '<', $file_name) || die " current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name1) || die " current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name2) || die " current working directory = $work_dir is not for IP=$a $! \n";             

# While loop to go inside the OPT file, search for the field spyglass_exe_opts and update the overrideen parameters taken from ip_override_sgcdc_params.txt
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             chomp($line);
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_stap.$list[0]=$list[1]\",\n"; #Command to print the overridden parameter in the OPT file
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/spyglasscdc/stap/stap_new.opt verif/tests/spyglasscdc/stap/stap.opt `;  #Copy back the OPT

#Make backup of the original files
`cp -r ace/stap_hdl.udf ace/stap_hdl_bkp.udf`;
`cp -r ace/stap_integ.udf ace/stap_integ_bkp.udf`;
`cp -r ace/stap.acerc ace/stap_bkp.acerc`;


`find ace/stap_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "stap"/{ACE_PROJECT} eq "$var\_stap"/g' {} \\\;`; #Uniquify the scope name

`find ace/stap_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;   #Comment out any JTAG related libraries

`find ace/stap_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`; #Comment out any JTAG related libraries

`find ace/stap_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`; #Comment out any JTAG related libraries

`find ace/stap_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;  #Comment out d04 cell paths as SDG SS do not have access to them

`find ace/stap_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`; #Comment out JTAG BFM UDF

`find ace/stap.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`; #Comment out d04 cell paths as SDG SS do not have access to them

}

####################################################TAPLINKNW#######################################################################################

elsif ($a=~ "taplinknw")
{

my $file_name4 = "$work_dir/verif/tests/taplinknw/spyglasscdc/taplinknw/taplinknw.opt";        # input uniquified opt file for reading
my $file_name5 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name6 = "$work_dir/verif/tests/taplinknw/spyglasscdc/taplinknw/taplinknw_new.opt";   # output file  

open(my $fh, '<', $file_name4) || die " current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name5) || die " current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name6) || die " current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_taplinknw.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/taplinknw/spyglasscdc/taplinknw/taplinknw_new.opt verif/tests/taplinknw/spyglasscdc/taplinknw/taplinknw.opt `;

`cp -r ace/taplinknw_hdl.udf ace/taplinknw_hdl_bkp.udf`;
`cp -r ace/taplinknw_integ.udf ace/taplinknw_integ_bkp.udf`;
`cp -r ace/taplinknw.acerc ace/taplinknw_bkp.acerc`;


`find ace/taplinknw_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "taplinknw"/{ACE_PROJECT} eq "$var\_taplinknw"/g' {} \\\;`;

`find ace/taplinknw_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;

`find ace/taplinknw_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/taplinknw_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/taplinknw_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/taplinknw_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/taplinknw.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;
}

####################################################DFXSECURE_PLUGIN#######################################################################################

elsif ($a=~ "dfxsecure_plugin")
{
   
my $file_name7 = "$work_dir/verif/tests/spyglasscdc/dfxsecure_plugin/dfxsecure_plugin.opt";        # input uniquified opt file for reading
my $file_name8 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name9 = "$work_dir/verif/tests/spyglasscdc/dfxsecure_plugin/dfxsecure_plugin_new.opt";   # output file  

open(my $fh, '<', $file_name7) || die " current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name8) || die " current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name9) || die " current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
			  chomp($line);
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_dfxsecure_plugin.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/spyglasscdc/dfxsecure_plugin/dfxsecure_plugin_new.opt verif/tests/spyglasscdc/dfxsecure_plugin/dfxsecure_plugin.opt `;

`cp -r ace/dfxsecure_plugin_hdl.udf ace/dfxsecure_plugin_hdl_bkp.udf`;

`find ace/dfxsecure_plugin_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "dfxsecure_plugin"/{ACE_PROJECT} eq "$var\_dfxsecure_plugin"/g' {} \\\;`;

`find ace/dfxsecure_plugin_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;

`find ace/dfxsecure_plugin_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/dfxsecure_plugin_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/dfxsecure_plugin_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/dfxsecure_plugin_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/dfxsecure_plugin.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;
}


########################################################CLTAPC#######################################################################################



elsif ($a=~"cltapc")
{

my $file_name10 = "$work_dir/verif/tests/spyglasscdc/cltapc/cltapc.opt";        # input uniquified opt file for reading
my $file_name11 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name12 = "$work_dir/verif/tests/spyglasscdc/cltapc/cltapc_new.opt";   # output file  

open(my $fh, '<', $file_name10) || die " current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name11) || die " current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name12) || die " current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_cltapc.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/spyglasscdc/cltapc/cltapc_new.opt verif/tests/spyglasscdc/cltapc/cltapc.opt `;

`cp -r ace/cltapc_hdl.udf ace/cltapc_hdl_bkp.udf`;
`cp -r ace/cltapc_integ.udf ace/cltapc_integ_bkp.udf`;
`cp -r ace/cltapc.acerc ace/cltapc_bkp.acerc`;


`find ace/cltapc_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "cltapc"/{ACE_PROJECT} eq "$var\_cltapc"/g' {} \\\;`;

`find ace/cltapc_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;

`find ace/cltapc_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/cltapc_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/cltapc_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/cltapc_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/cltapc.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;

}




####################################################IDVP_CONTROLLER##################################################################################


elsif ($a =~"idvp_controller")
{

my $file_name13 = "$work_dir/verif/tests/spyglasscdc/idvp/idvp.opt";        # input uniquified opt file for reading
my $file_name14 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name15 = "$work_dir/verif/tests/spyglasscdc/idvp/idvp_new.opt";   # output file  

open(my $fh, '<', $file_name13) || die " current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name14) || die " current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name15) || die " current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
			  chomp($line);
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_idvp_controller.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/spyglasscdc/idvp/idvp_new.opt verif/tests/spyglasscdc/idvp/idvp.opt `;

`cp -r ace/idvp_hdl.udf ace/idvp_hdl_bkp.udf`;
`cp -r ace/idvp_integ.udf ace/idvp_integ_bkp.udf`;
`cp -r ace/idvp.acerc ace/idvp_bkp.acerc`;


`find ace/idvp_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "idvp"/{ACE_PROJECT} eq "$var\_idvp"/g' {} \\\;`;

`find ace/idvp_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;

`find ace/idvp_hdl.udf -exec sed -i 's/"idvp_jtag_bfm_pkg_lib"/\#"idvp_jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/idvp_hdl.udf -exec sed -i 's/"idvp_jtag_bfm_ti_lib",/\#"idvp_jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/idvp_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/idvp_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/idvp.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find verif/tb/idvp_pkg.hdl -exec sed -i '/Jtag/ s/^/#/' {} \\\;`;

}



####################################################TAP2IOSFSB#######################################################################################

elsif( $a=~"tap2iosfsb")

{


my $file_name16 = "$work_dir/verif/tests/spyglasscdc/tap2iosfsb/tap2iosfsb.opt";        # input uniquified opt file for reading
my $file_name17 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name18 = "$work_dir/verif/tests/spyglasscdc/tap2iosfsb/tap2iosfsb_new.opt";   # output file  

open(my $fh, '<', $file_name16) || die "current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name17) || die "current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name18) || die "current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_tap2iosfsb.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/spyglasscdc/tap2iosfsb/tap2iosfsb_new.opt verif/tests/spyglasscdc/tap2iosfsb/tap2iosfsb.opt `;

`cp -r ace/tap2iosfsb_hdl.udf ace/tap2iosfsb_hdl_bkp.udf`;
`cp -r ace/tap2iosfsb_integ.udf ace/tap2iosfsb_integ_bkp.udf`;
`cp -r ace/tap2iosfsb.acerc ace/tap2iosfsb_bkp.acerc`;


`find ace/tap2iosfsb_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "tap2iosfsb"/{ACE_PROJECT} eq "$var\_tap2iosfsb"/g' {} \\\;`;

`find ace/tap2iosfsb_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;

`find ace/tap2iosfsb_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/tap2iosfsb_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/tap2iosfsb_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/tap2iosfsb_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/tap2iosfsb.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;

}


###################################################LCP_CONTROLLER#######################################################################################


elsif ($a=~ "lcp_controller" )
{

my $file_name19 = "$work_dir/verif/tests/lcp_controller/spyglasscdc/lcp_controller/lcp_controller.opt";        # input uniquified opt file for reading
my $file_name20 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name21 = "$work_dir/verif/tests/lcp_controller/spyglasscdc/lcp_controller/lcp_new_controller.opt";   # output file  
open(my $fh, '<', $file_name19) || die "Current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name20) || die "Current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name21) || die "Current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if( $list[1] =~ /\S/)
				 {
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_lcp_controller.$list[0]=$list[1]\",\n";
			     }
             }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/lcp_controller/spyglasscdc/lcp_controller/lcp_new_controller.opt verif/tests/lcp_controller/spyglasscdc/lcp_controller/lcp_controller.opt `;

}


###################################################ODI_VDM_CONTROLLER#######################################################################################


elsif ($a =~ "odi_vdm_controller")
{

my $file_name22 = "$work_dir/verif/tests/odi_vdm_ctl/spyglasscdc/odi_vdm_controller/odi_vdm_controller.opt";        # input uniquified opt file for reading
my $file_name23 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name24 = "$work_dir/verif/tests/odi_vdm_ctl/spyglasscdc/odi_vdm_controller/odi_vdm_new_controller.opt";   # output file

open(my $fh, '<', $file_name22) || die "Current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name23) || die "Current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name24) || die "Current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if( $list[1] =~ /\S/)
				 {
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_odi_vdm_ctl.$list[0]=$list[1]\",\n";
			     }
             }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/odi_vdm_ctl/spyglasscdc/odi_vdm_controller/odi_vdm_new_controller.opt verif/tests/odi_vdm_ctl/spyglasscdc/odi_vdm_controller/odi_vdm_controller.opt `;

}


elsif ($a=~"stf_hub")
{

my $file_name = "$work_dir/verif/tests/spyglasscdc/stf_hub/stf_hub.opt";        # input uniquified opt file for reading
my $file_name1 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name2 = "$work_dir/verif/tests/spyglasscdc/stf_hub/stf_hub_new.opt";   # output file  

open(my $fh, '<', $file_name) || die " Current working directory = $work_dir is not for IP=$a $! \n";            
open(my $mainfile, '<', $file_name1) || die "Current working directory = $work_dir is not for IP=$a $! \n";      
open(my $fa,'>',$file_name2) || die "Current working directory = $work_dir is not for IP=$a $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_stf_hub.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/spyglasscdc/stf_hub/stf_hub_new.opt verif/tests/spyglasscdc/stf_hub/stf_hub.opt `;

`cp -r ace/stf_hub_hdl.udf ace/stf_hub_hdl_bkp.udf`;

`find ace/stf_hub_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "stf_hub"/{ACE_PROJECT} eq "$var\_stf_hub"/g' {} \\\;`;

#paiashwi
`find ace/stf_hub.udf -exec sed -i 's/"jtagbfm:/\#"jtagbfm:/g' {} \\\;`;
`find ace/stf_hub.udf -exec sed -i 's/"stf_bfm:/\#"stf_bfm:/g' {} \\\;`;
`find ace/stf_hub_hdl.udf -exec sed -i 's/"stf_bfm:stf_bfm_model"//g' {} \\\;`;
`find ace/stf_hub_hdl.udf -exec sed -i 's/"jtagbfm:/\#"jtagbfm:/g' {} \\\;`;
`find ace/stf_hub_hdl.udf -exec sed -i 's/jtagbfm /\#jtagbfm /g' {} \\\;`;

`find subIP/ip-stf_ep/verif/dfx/ip-stap/ace/stap_hdl.udf -exec sed -i 's/"jtagbfm:jtagbfm_model",//g' {} \\\;`;

`find ace/stf_hub_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/stf_hub_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

}

elsif($a=~/stf_ep/)

{

my $file_name = "$work_dir/verif/tests/static_checks/spyglass_cdc/stf_endpoint/stf_endpoint.opt";        # input uniquified opt file for reading
my $file_name1 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name2 = "$work_dir/verif/tests/static_checks/spyglass_cdc/stf_endpoint/stf_endpoint_new.opt";   # output file  

open(my $fh, '<', $file_name) || die "current working directory = $work_dir is not for IP=$a  $! \n";            
open(my $mainfile, '<', $file_name1) || die "current working directory = $work_dir is not for IP=$a  $! \n";      
open(my $fa,'>',$file_name2) || die "current working directory = $work_dir is not for IP=$a  $! \n";             
while (($line = <$fh>))
{ 
    if ( $line =~ /-spyglass_exe_opts/)                   
    {  chomp ($line);
       print {$fa} "$line\n";
       while (($line = <$fh>))
       {                                     
          chomp($line);
          if ( $line =~ /\s+\],/)
          {
             while(my $ln = <$mainfile>)
             { 
                 chomp ($ln);
                 my @list = split(/=/,$ln);
				 if (exists($list[1]))
				 {
				 if( $list[1] =~ /\S/)
				 {   
					 $list[0] =~ s/^\s+|\s+$//g;
					 $list[1] =~ tr/ //ds;
                     print {$fa} ' ' x 37 ."\"set_option param $var\_stf_endpoint.$list[0]=$list[1]\",\n";
			     }
             }
		 }
          }
          print "\t";
          print {$fa} "$line\n";
        }
    }
    else  
    {
       print{$fa} "$line";
    }
}
close $fh;
close $mainfile;
close $fa;
`mv verif/tests/static_checks/spyglass_cdc/stf_endpoint/stf_endpoint_new.opt ./verif/tests/static_checks/spyglass_cdc/stf_endpoint/stf_endpoint.opt `;

`cp -r ace/stf_endpoint_hdl.udf ace/stf_endpoint_hdl_bkp.udf`;
`cp -r ace/stf_endpoint_integ.udf ace/stf_endpoint_integ_bkp.udf`;
`cp -r ace/stf_endpoint.acerc ace/stf_endpoint_bkp.acerc`;


`find ace/stf_endpoint_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "stf_endpoint"/{ACE_PROJECT} eq "$var\_stf_endpoint"/g' {} \\\;`;
#paiashwi
`find ace/stf_endpoint_hdl.udf -exec sed -i 's/"jtagbfm/\#"jtagbfm/g' {} \\\;`;
`find ace/stf_endpoint.udf -exec sed -i 's/"stf_bfm:/\#"stf_bfm:/g' {} \\\;`;
`find ace/stf_endpoint_hdl.udf -exec sed -i 's/"stf_bfm:stf_bfm_model"//g' {} \\\;`;
`find ace/stf_endpoint_hdl.udf -exec sed -i 's/jtagbfm /\#jtagbfm /g' {} \\\;`;

`find verif/dfx/ip-stap/ace/stap_hdl.udf -exec sed -i 's/"jtagbfm:jtagbfm_model",//g' {} \\\;`;

`find ace/stf_endpoint_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/stf_endpoint_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/stf_endpoint_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/stf_endpoint_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/stf_endpoint.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;
}




else
{
   print " Please Enter the correct name of the IP ";
}

