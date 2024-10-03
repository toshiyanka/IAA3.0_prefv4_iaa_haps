#!/usr/intel/bin/perl

#This script is intented to see the ports which are added, deleted, modified in the design which vary from the reference std file of ports with port widths and port direction. This script is called after corekit generation step.
#This file takes the user specified std port file, and the build summary file and returns success (0) if both the port list with the port width and direction match.
#This file returns failure (1) and displays the modified ports, added ports and deleted ports in the design which vary from the port list in the std port file. 
#example - port_checker.pl --std_port_parameter_file /nfs/pdx/home/miyengar/MY_SCRIPTS/std_repo/scf_iocoh_std_port_parameter_file.txt --input_port_file /nfs/site/disks/sdg74_ipm_0004/scf_iocoh/scf_iocoh-srvr10nm-15ww16e/target/collage/ip_kits/scf_iocoh.build.summary
#Please use the help option for usage of the script.
#Please use the debug option to get debug information on the terminal.
   
use Getopt::Long;
use Getopt::Std;
use warnings;
use File::Compare;

print "-I- Executing the script $0 \n";
GetOptions( "ref_build_summary_file=s" => \$ref_build_summary_file,
            "help" => \$help,
            "debug" => \$debug );
            
my $help1 = 1 if (defined $help);
my $help2 = 1 unless (defined $ref_build_summary_file);

if ((defined $help1) || (defined $help2))
{
	print "\n USAGE : \n";
   	print "\n $0 [--help] --ref_build_summary_file full_path_of_ref_build_summary_file [--debug]\n";
        print "\n EXAMPLE : \n";
   	print "\n Mandatory - providing ref_build_summary_file path \n";
   	exit 1;
}

$valid_parameter_line = 0;
$valid_port_line = 0; 
$valid_interface_line = 0;
$tools_dir = "./tools";
#$ifccntl_dir = "./tools/intferface_control";
#$interface_control_file = "$ifccntl_dir/ss_ifccntl.txt";	
unless (-d $tools_dir)
{
	print "-E- Directory $tools_dir does not exist in this path. Please invoke the script from your model's home directory\n";
	print "\n EXAMPLE : scripts/create_interface_control.pl --ref_build_summary_file ./target/collage/ip_kits/scf_iocoh.build.summary \n";
	exit(1);
}
else
{ 
	$ifccntl_dir = "./tools/interface_control";
	(my $ss_ifccntl_file = $ref_build_summary_file) =~ s/.build.summary/_ifccntl.txt/;
	$ss_ifccntl_file =~ s/.*\///g;
	print "The file is $ss_ifccntl_file\n" if (defined $debug);
	$interface_control_file = "$ifccntl_dir/$ss_ifccntl_file";
}
mkdir($ifccntl_dir) unless(-d $ifccntl_dir);
`rm -rf $interface_control_file` if -e $interface_control_file; 
open (IFCCNTL_FILE, ">>$interface_control_file" ) || die "-F- Can't open output file  $interface_control_file  \n";
print "The output interface_control file is $interface_control_file\n" if (defined $debug) ;
chomp($ref_build_summary_file);
open(REF_BUILD_SUMMARY_FILE, $ref_build_summary_file) || die "-F- Can't open ref build summary file $ref_build_summary_file \n";
while (<REF_BUILD_SUMMARY_FILE>)
{
        chomp();
        print "-D- The current line is $_\n" if (defined $debug);
	if (/^#RTL\s+Parameter\s+Value/)
	{
		$valid_parameter_line = 1;
		printf IFCCNTL_FILE "#RTL Parameter , Value , comment , owner , approver\n";
		next;
	}

	if (/^#Port_name\s+PortWidth\s+Port_Direction/)
	{
#                print "-D- Found the starting line of interest $_\n" if (defined $debug);
                 $valid_port_line = 1;		
	}
	if (/^-- Report/)        
	{
		$valid_interface_line = 1;
	}
        if ($valid_parameter_line == 1 )
        {
 	        if (/^#####/)
                {
                        $valid_parameter_line = 0;
			printf IFCCNTL_FILE "\n\n$_\n";
			next;
                }
		else
		{
	        	next unless (/[A-Za-z0-9]/);	
                	$_ =~ s/[\s+\t+]/ /g;
                	$_ =~ s/\s/ , /g;
                	$_ =~ s/$/, comment , owner , approver/;
                	printf IFCCNTL_FILE "\n$_";
		}

        }
	elsif ($valid_port_line == 1)
        {
                if (/^#####/)
                {
                        $valid_port_line = 0;
                        printf IFCCNTL_FILE "\n$_";
			printf IFCCNTL_FILE "\n";
			printf IFCCNTL_FILE "\n To Be Implemented";
			printf IFCCNTL_FILE "\n\n\n";
			printf IFCCNTL_FILE "########################################";
                        next;			
                }
		else
		{
			next unless (/[A-Za-z0-9]/);
                	$_ =~ s/\s+/ /g;
                	$_ =~ s/\s/ , /g;
                	$_ =~ s/$/, area , clock requirement , power domain , interface spec name , comment , owner , approver/;
                	printf IFCCNTL_FILE "\n$_";
                }
	}
	elsif ($valid_interface_line == 1)
	{
                        printf IFCCNTL_FILE "\n$_";			
	}
	next;
}
close (REF_BUILD_SUMMARY_FILE);
close (IFCCNTL_FILE);	
print "-I- The interface control script is created in $interface_control_file\n";
		
print "-I- Completed Execution of the script $0 \n";
