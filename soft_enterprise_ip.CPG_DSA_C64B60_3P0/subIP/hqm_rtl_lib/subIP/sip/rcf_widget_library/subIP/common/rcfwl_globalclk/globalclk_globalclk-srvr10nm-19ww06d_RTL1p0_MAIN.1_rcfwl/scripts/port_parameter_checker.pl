#!/usr/intel/bin/perl

#This script is intented to see the ports which are added, deleted, modified in the design which vary from the reference std file of ports with port widths and port direction. This script is called after corekit generation step.
#This file takes the user specified std port file, and the build summary file and returns success (0) if both the port list with the port width and direction match.
#This file returns failure (1) and displays the modified ports, added ports and deleted ports in the design which vary from the port list in the std port file. 
#example - port_checker.pl --interface_control_file /nfs/pdx/home/miyengar/MY_SCRIPTS/std_repo/scf_iocoh_interface_control_file.txt --input_port_parameter_file /nfs/site/disks/sdg74_ipm_0004/scf_iocoh/scf_iocoh-srvr10nm-15ww16e/target/collage/ip_kits/scf_iocoh.build.summary
#Please use the help option for usage of the script.
#Please use the debug option to get debug information on the terminal.
   
use Getopt::Long;
use Getopt::Std;
use warnings;
use File::Compare;

print "-I- Executing the script $0 \n";
GetOptions( "interface_control_file=s" => \$interface_control_file,
	    "input_port_parameter_file=s" => \$input_port_parameter_file,	
            "help" => \$help,
            "debug" => \$debug );
            
my $help1 = 1 if (defined $help);
my $help2 = 1 unless ((defined $interface_control_file) && (defined $input_port_parameter_file));

if ((defined $help1) || (defined $help2))
{
	print "\n USAGE : \n";
   	print "\n $0 [--help] --interface_control_file full_path_of_interface_control_file --input_port_parameter_file full_path_to_build_summary_file [--debug]\n";
        print "\n EXAMPLE : \n";
   	print "\n Mandatory - providing interface_control_file and input_port_parameter_file option with full paths \n";
   	exit 1;
}

# Variables for the Parameter comparision
$valid_parameter_line = 0;
$field_parameter_empty = 0;
$modification_parameter_header = 0;
$error_exit = 0;
$parameter_line_count = 0;
if (defined($ENV{COLLAGE_WORK})) {
  $temp_parameter_file = $ENV{COLLAGE_WORK}."/temp_parameter.txt";
} else {
  $user = `whoami`;
  chomp($user);
  $date = `date`;
  $date =~ s/\s+/_/g;
  $date =~ s/_$//;	
  chomp($date);
  my $model = $input_port_parameter_file;
  $model =~ s/.*\///;
  $model =~ s/\.build\.summary.*//;
  $temp_parameter_file = "/tmp/temp_parameter"._.$user._.$model._.$date.".txt";
}
unlink $temp_parameter_file if -e $temp_parameter_file;

# Variables for the Port comparision
$valid_line = 0;
$field_empty = 0;
$modification_header = 0;
$line_count = 0;

if (defined($ENV{COLLAGE_WORK})) {
  $temp_file = $ENV{COLLAGE_WORK}."/temp_port.txt";
} else {
  $user = `whoami`;
  chomp($user);
  $date = `date`;
  $date =~ s/\s+/_/g;
  $date =~ s/_$//;
  chomp($date);
  $temp_file = "/tmp/temp_port"._.$user._.$date.".txt";
}
unlink $temp_file if -e $temp_file;

$error_exit = 0;
 
open (TEMP_PARAMETER_FILE, ">>$temp_parameter_file" ) || die "-F- Can't open output file  $temp_parameter_file  \n";
chmod 0777, $temp_parameter_file;
print "The intermediate parameter file is $temp_parameter_file\n" if (defined $debug) ;
chomp($input_port_parameter_file);
open(INPUT_PARAMETER_FILE, $input_port_parameter_file) || die "-F- Can't open file $input_port_parameter_file \n";
while (<INPUT_PARAMETER_FILE>)
{
        chomp();
        print "-D- The current line is $_\n" if (defined $debug);
        if ($valid_parameter_line == 0 )
        {
                next unless (/^#RTL\s+Parameter\s+Value/);
                print "-D- Found the starting line of interest $_\n" if (defined $debug);
                $valid_parameter_line = 1;
                printf TEMP_PARAMETER_FILE "$_";
        }
        else
        {
                if (/####+/)
                {
                        last;
                }
                else
                {
                        next unless (/[A-Za-z0-9]/);
                        printf TEMP_PARAMETER_FILE "\n$_";
                }
        }
}
close (TEMP_PARAMETER_FILE);
$valid_parameter_line = 0;

open(STD_PARAMETER_FILE, $interface_control_file) || die "-F- Can't open file $interface_control_file \n";
open(TEMP_PARAMETER_FILE, $temp_parameter_file) || die "-F- Can't open file $temp_parameter_file \n";
print "-D- Preparing parameter hashes for the std parameter file $interface_control_file\n" if (defined $debug);
while (<STD_PARAMETER_FILE>)
{       $parameter_line_count++;
        if ($valid_parameter_line == 0 )
	{
		next unless (/^#RTL\s*Parameter\s*,\s*Value/);
		$valid_parameter_line = 1;
	}
	else
	{
		last if (/####+/);
#		last if (/----+/);
#        	last if (/^#Port_name\s*,\s*PortWidth\s*,\s*Port_Direction/);
        	next if (/^#/);
        	next unless (/[A-Za-z0-9]/);
        	$_ =~ s/[\s\t]//g;
        	@std_parameter_array = split(',', $_);
        	print "The number of fields is $#std_parameter_array+1 \n" if (defined $debug);
        	print "The array elements are @std_parameter_array \n" if (defined $debug);
        	for ($i = 0 ; $i <= $#std_parameter_array ; $i++)
        	{
                	$field_parameter_empty = 1 if ($std_parameter_array[$i] !~ /[A-Za-z0-9]/);
        	}
        	if ($#std_parameter_array+1 == 5  && ($field_parameter_empty ==0))
        	{
                	$std_parameter_hash{$std_parameter_array[0]}{parameter_value} = $std_parameter_array[1];
        	}
        	else
        	{
                	print "-E- One or more fields is missing/empty in the line number $parameter_line_count of $interface_control_file\. Please fill all 5 fields \n";
                	print "-E- The line is --> $_\n";
                	print "-E- Exiting $0 with Errors\n";
			if (!defined $debug)
			{
				unlink $temp_file;
				unlink $temp_parameter_file;
			}
                	exit 1;
        	}
	}
}

print "-D- Preparing hashes for the temp parameter file $temp_parameter_file\n" if (defined $debug);
while (<TEMP_PARAMETER_FILE>)
{
        next if (/^#/);
        $_ =~ s/\s+/ /g;
        @temp_parameter_array = split(/\s+/, $_);
        $temp_parameter_hash{$temp_parameter_array[0]}{parameter_value} = $temp_parameter_array[1];
}

print "The keys and parameter_value for the std_parameter_hash are\n" if (defined $debug);
foreach $i_std_parameter (sort keys %std_parameter_hash)
{
        print "$i_std_parameter | $std_parameter_hash{$i_std_parameter}{parameter_value}\n" if (defined $debug);
}

print "The keys and parameter_value for the temp_parameter_hash are\n" if (defined $debug);
foreach $i_temp_parameter (sort keys %temp_parameter_hash)
{
        print "$i_temp_parameter | $temp_parameter_hash{$i_temp_parameter}{parameter_value}\n" if (defined $debug);
}
foreach $i_std_parameter (sort keys %std_parameter_hash)
{
        if (exists $temp_parameter_hash{$i_std_parameter})
        {
                if ($std_parameter_hash{$i_std_parameter}{parameter_value} ne $temp_parameter_hash{$i_std_parameter}{parameter_value})
                {
                        $error_exit = 1;
                        if ($modification_parameter_header == 0)
                        {
                                print "-E- *****************************************************************************************\n";
                                print "-E- MODIFIED -- THE FOLLOWING RTL PARAMETERS WERE MODIFIED WHEN COMPARED TO STD FILE PARAMETERS :\n";
                                print "-E- PARAMETER_NAME | STD_PARAMETER_VALUE | MODIFIED_PARAMETER_VALUE \n";
                                $modification_parameter_header = 1;
                        }
                        print "-E- $i_std_parameter | $std_parameter_hash{$i_std_parameter}{parameter_value} | $temp_parameter_hash{$i_std_parameter}{parameter_value} \n";
                }
                delete $temp_parameter_hash{$i_std_parameter};
                delete $std_parameter_hash{$i_std_parameter};
        }
}
if (%temp_parameter_hash)
{
        $error_exit = 1;
        print "-E- *****************************************************************************************\n";
        print "-E- ADDED -- THE FOLLOWING INTERFACE PARAMETERS WERE ADDTIONAL WHEN COMPARED TO STD FILE PARAMETERS :\n";
        print "-E- PARAMETER_NAME | PARAMETER_VALUE \n";
        foreach $i_temp_parameter (sort keys %temp_parameter_hash)
        {
                print "-E- $i_temp_parameter | $temp_parameter_hash{$i_temp_parameter}{parameter_value} \n";
        }
}
if (%std_parameter_hash)
{
        $error_exit = 1;
        print "-E- *****************************************************************************************\n";
        print "-E- DELETED -- THE FOLLOWING INTERFACE PARAMETERS WERE MISSING WHEN COMPARED TO STD FILE PARAMETERS :\n";
        print "-E- PARAMETER_NAME | PARAMETER_VALUE\n";
        foreach $i_std_parameter (sort keys %std_parameter_hash)
        {
                 print "-E- $i_std_parameter | $std_parameter_hash{$i_std_parameter}{parameter_value}\n";
        }
}

open (TEMP_FILE, ">>$temp_file" ) || die "-F- Can't open output file  $temp_file  \n";
chmod 0777, $temp_file;
print "The intermediate port file is $temp_file\n" if (defined $debug) ;
chomp($input_port_parameter_file);
open(INPUT_PORT_FILE, $input_port_parameter_file) || die "-F- Can't open file $input_port_parameter_file \n";
while (<INPUT_PORT_FILE>)
{
	chomp();
        print "-D- The current line is $_\n" if (defined $debug);
	if ($valid_line == 0 )
	{
		next unless (/^#Port_name\s+PortWidth\s+Port_Direction/);
		print "-D- Found the starting line of interest $_\n" if (defined $debug); 
		$valid_line = 1;
		printf TEMP_FILE "$_";
	}
	else 
	{
		if (/####+/)
		{
			last;
		}
		else
		{
			next unless (/[A-Za-z0-9]/); 
			printf TEMP_FILE "\n$_";
		}
	}
}	
close (TEMP_FILE);
$valid_line = 0;

open(STD_PORT_FILE, $interface_control_file) || die "-F- Can't open file $interface_control_file \n";
open(TEMP_PORT_FILE, $temp_file) || die "-F- Can't open file $temp_file \n";
print "-D- Preparing hashes for the std port file $interface_control_file\n" if (defined $debug);
while (<STD_PORT_FILE>)
{	$line_count++;
        if ($valid_line == 0 )
        {
		next unless (/^#Port_name\s*,\s*PortWidth\s*,\s*Port_Direction/);
		$valid_line = 1;
	}
	else
	{
		last if (/####+/);
		next if (/^#/);
		next unless (/[A-Za-z0-9]/);
		$_ =~ s/[\s\t]//g;
		@std_port_array = split(',', $_);
		print "The number of fields is $#std_port_array+1 \n" if (defined $debug);
		print "The array elements are @std_port_array \n" if (defined $debug);
		for ($i = 0 ; $i <= $#std_port_array ; $i++)
		{
			$field_empty = 1 if ($std_port_array[$i] !~ /[A-Za-z0-9]/);  
		}  
		if ($#std_port_array+1 == 10 && ($field_empty ==0))
		{ 
			$std_port_hash{$std_port_array[0]}{port_width} = $std_port_array[1];
			$std_port_hash{$std_port_array[0]}{port_direction} = $std_port_array[2];
		}
		else
		{
			print "-E- One or more fields is missing/empty in the line number $line_count of $interface_control_file\. Please fill all 10 fields \n";
			print "-E- The line is --> $_\n";
			print "-E- Exiting $0 with Errors\n";
			if (!defined $debug)
			{
				unlink $temp_file;
				unlink $temp_parameter_file;
			}
			exit 1;
		}
	}
}
print "-D- Preparing hashes for the temp port file $temp_file\n" if (defined $debug);
while (<TEMP_PORT_FILE>)
{
        next if (/^#/);
        $_ =~ s/\s+/ /g;
        @temp_port_array = split(/\s+/, $_);
	$temp_port_hash{$temp_port_array[0]}{port_width} = $temp_port_array[1];
	$temp_port_hash{$temp_port_array[0]}{port_direction} = $temp_port_array[2]; 
}

print "The keys \, port_width and port_direction for the std_port_hash are\n" if (defined $debug);
foreach $i_std_port (sort keys %std_port_hash)
{
        print "$i_std_port | $std_port_hash{$i_std_port}{port_width} | $std_port_hash{$i_std_port}{port_direction}\n" if (defined $debug);
}

print "The keys \, port_width and port_direction for the temp_port_hash are\n" if (defined $debug);
foreach $i_temp_port (sort keys %temp_port_hash)
{
	print "$i_temp_port | $temp_port_hash{$i_temp_port}{port_width} | $temp_port_hash{$i_temp_port}{port_direction}\n" if (defined $debug);
}
foreach $i_std_port (sort keys %std_port_hash)
{
	if (exists $temp_port_hash{$i_std_port})
	{
		if (($std_port_hash{$i_std_port}{port_width} ne $temp_port_hash{$i_std_port}{port_width}) || ($std_port_hash{$i_std_port}{port_direction} ne $temp_port_hash{$i_std_port}{port_direction}))
		{
			$error_exit = 1; 
			if ($modification_header == 0)
			{
				print "-E- *****************************************************************************************\n";
				print "-E- MODIFIED -- THE FOLLOWING INTERFACE PORTS WERE MODIFIED WHEN COMPARED TO STD FILE PORTS :\n";
				print "-E- PORT_NAME | STD_PORT_WIDTH | STD_PORT_DIRECTION | MODIFIED_PORT_WIDTH | MODIFIED_PORT_DIRECTION\n";
				$modification_header = 1;
			}
			print "-E- $i_std_port | $std_port_hash{$i_std_port}{port_width} | $std_port_hash{$i_std_port}{port_direction} | $temp_port_hash{$i_std_port}{port_width} | $temp_port_hash{$i_std_port}{port_direction}\n"; 
		}
		delete $temp_port_hash{$i_std_port};
		delete $std_port_hash{$i_std_port};
	}
}
if (%temp_port_hash)
{
	$error_exit = 1;
 	print "-E- *****************************************************************************************\n";
	print "-E- ADDED -- THE FOLLOWING INTERFACE PORTS WERE ADDTIONAL WHEN COMPARED TO STD FILE PORTS :\n";
	print "-E- PORT_NAME | PORT_WIDTH | PORT_DIRECTION\n";
	foreach $i_temp_port (sort keys %temp_port_hash)
	{
		print "-E- $i_temp_port | $temp_port_hash{$i_temp_port}{port_width} | $temp_port_hash{$i_temp_port}{port_direction}\n";
	}
}
if (%std_port_hash)
{
	$error_exit = 1;
 	print "-E- *****************************************************************************************\n";
	print "-E- DELETED -- THE FOLLOWING INTERFACE PORTS WERE MISSING WHEN COMPARED TO STD FILE PORTS :\n";
	print "-E- PORT_NAME | PORT_WIDTH | PORT_DIRECTION\n";
	foreach $i_std_port (sort keys %std_port_hash)
	{
		 print "-E- $i_std_port | $std_port_hash{$i_std_port}{port_width} | $std_port_hash{$i_std_port}{port_direction}\n";
	}
}
if (!defined $debug)
{
	unlink $temp_file;
	unlink $temp_parameter_file;
}
if ($error_exit == 1)
{
print "-E- ****************************************************************************\n";
print "-E- Exiting $0 with Errors\n";
exit 1;
}
if (!defined $debug)
{
        unlink $temp_parameter_file;
        unlink $temp_file;
}
print "-I- End of $0 \. The port list matched successfully\n"; 
