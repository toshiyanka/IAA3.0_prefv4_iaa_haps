#!/usr/bin/perl
use strict;
use warnings;
# Author : Shrinidhi Deshpande
# Date   : 22-Nov-2018
# Desc   : perl gen_sgcdc_parameterized_opt.pl <subsystem_prefix>
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
my $work_dir=`pwd`;                                                                           # Please run this script in $IP_ROOT
chomp ($work_dir);
my $file_name = "$work_dir/verif/tests/spyglasscdc/stap/stap.opt";        # input uniquified opt file for reading
my $file_name1 = "$work_dir/scripts/ip_override_sgcdc_params.txt";                            # ip_override_sgcdc_params.txt for reading
my $file_name2 = "$work_dir/verif/tests/spyglasscdc/stap/stap_new.opt";   # output file  

open(my $fh, '<', $file_name) || die "file could not open $! \n";            
open(my $mainfile, '<', $file_name1) || die "file could not open $! \n";      
open(my $fa,'>',$file_name2) || die "file could not open $! \n";             
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
                     print {$fa} ' ' x 37 ."\"set_option param $var\_stap.$list[0]=$list[1]\",\n";
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
`mv verif/tests/spyglasscdc/stap/stap_new.opt verif/tests/spyglasscdc/stap/stap.opt `;

`cp -r ace/stap_hdl.udf ace/stap_hdl_bkp.udf`;
`cp -r ace/stap_integ.udf ace/stap_integ_bkp.udf`;
`cp -r ace/stap.acerc ace/stap_bkp.acerc`;


`find ace/stap_hdl.udf -exec sed -i 's/{ACE_PROJECT} eq "stap"/{ACE_PROJECT} eq "$var\_stap"/g' {} \\\;`;

`find ace/stap_hdl.udf -exec sed -i 's/jtagbfm/\#jtagbfm/g' {} \\\;`;

`find ace/stap_hdl.udf -exec sed -i 's/"jtag_bfm_pkg_lib"/\#"jtag_bfm_pkg_lib"/g' {} \\\;`;

`find ace/stap_hdl.udf -exec sed -i 's/"jtag_bfm_ti_lib",/\#"jtag_bfm_ti_lib"\\\n/g' {} \\\;`;

`find ace/stap_hdl.udf -exec sed -i '/d04/ s/^/#/' {} \\\;`;

`find ace/stap_integ.udf -exec sed -i 's/"ace\\\/jtagbfm_integ.udf",/\#"ace\\\/jtagbfm_integ.udf",/g' {} \\\;`;

`find ace/stap.acerc -exec sed -i '/d04/ s/^/#/' {} \\\;`;


