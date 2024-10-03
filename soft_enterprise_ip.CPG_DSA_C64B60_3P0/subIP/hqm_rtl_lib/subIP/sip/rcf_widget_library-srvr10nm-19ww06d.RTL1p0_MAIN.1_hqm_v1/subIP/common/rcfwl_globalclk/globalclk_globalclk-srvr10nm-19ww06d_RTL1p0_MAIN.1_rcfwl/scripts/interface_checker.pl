#!/usr/intel/bin/perl
#This script is intented to see the ports and parameters which are added, deleted, modified in the design which vary from the reference std file of ports and parameter . This script is called after corekit generation step.
#This file takes the user specified std port file, and the build summary fileand returns success (0) if all the interfaces with interface type, port width, portdirection, interface link and parameter type, parameter value and interface link in the reference file  match with the build summary file.
# returns failure (1) along with the modified, added and deleted interfaces along with ports and parameters otherwise.
#interface_checker_2.0.pl --interface_control_file /nfs/pdx/disks/srvr10nm_0563/miyengar/CLONE_SCF_IOCOH/scf_iocoh-srvr10nm/cfg/waivers/scf_iocoh_std_interface_ports_and_parameters.txt --input_port_parameter_file /nfs/pdx/disks/srvr10nm_0563/miyengar/CLONE_SCF_IOCOH/scf_iocoh-srvr10nm/target/collage/ip_kits/scf_iocoh.build.summary
#Please use the help option for usage of the script.
#Please use the debug option to get debug information on the terminal.
   
use Getopt::Long;
use Getopt::Std;
use warnings;
use File::Compare;

print "-I- Executing the script $0\n";
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
$start_line = 0;
$std_field_empty = 0;
$line_temp_count =0;
$modification_type_header = 0;
$modification_port_header = 0;
$modification_parameter_header = 0;
$temp_field_empty = 0;
$error_exit = 0;
$valid_std_file_line = 0;
$line_count = 0;
$added_port_header = 0;
$added_parameter_header = 0;
$deleted_port_header = 0;
$deleted_parameter_header = 0;
if (defined($ENV{COLLAGE_WORK})) {
  $temp_file = $ENV{COLLAGE_WORK}."/temp_std_port_parameter.txt";
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
  $temp_file = "/tmp/temp_std_port_parameter"._.$user._.$model._.$date.".txt";
}
unlink $temp_file if -e $temp_file;
open (TEMP_FILE, ">>$temp_file" ) || die "-F- Can't open output file  $temp_file  \n";
chmod 0777, $temp_file;
print "-D- The intermediate port_parameter file is $temp_file\n" if (defined $debug) ;
chomp($input_port_parameter_file);
open(INPUT_PORT_PARAMETER_FILE, $input_port_parameter_file) || die "-F- Can't open file $input_port_parameter_file \n";
while (<INPUT_PORT_PARAMETER_FILE>)
{
	chomp();
 	next if (/^[\n\s\t]+$/);
	next if (/^$/);	
        print "-D- The current line is $_\n" if (defined $debug);
	if ($start_line == 0 )
	{
		next unless (/^-- Interface/);
		print "-D- Found the starting line of interest $_\n" if (defined $debug); 
		$start_line = 1;
		printf TEMP_FILE "$_";
	}
	else 
	{
		if ((/^-- Interface /) || (/^-- InterfaceType/) || ($_ !~ /^--/ ))
		{
                    #Internal signals for collage, told to ignore as part of #HSD-1208529293
                    next if( (/^NumConsumers/) || (/^NumInternalConsumers/) || (/^SlotNumber/) );
			 printf TEMP_FILE "\n$_";
		}
		else
		{
		 	 next;
		}
	}
}	
close (TEMP_FILE);

open(STD_PORT_PARAMETER_FILE, $interface_control_file) || die "-F- Can't open file $interface_control_file \n";
open(TEMP_PORT_PARAMETER_FILE, $temp_file) || die "-F- Can't open file $temp_file \n";
print "-D- Preparing hashes for the std port file $interface_control_file\n" if (defined $debug);
while (<STD_PORT_PARAMETER_FILE>)
{	
	$std_field_empty = 0;
	$line_count++;
	$valid_std_file_line = 1 if (/^-- Interface /);
	next unless ($valid_std_file_line == 1);
        next if ((/^-- Report/) || (/^-- InterfaceDefn/) || (/^-- InterfaceVer/)|| (/^-- Definition/) || (/^-- Version/) || (/^-- Tool Version/)
            #Internal signals for collage, told to ignore as part of #HSD-1208529293
            || (/^NumConsumers/) || (/^NumInternalConsumers/) || (/^SlotNumber/) 
            );
	chomp();
	next if (/^#/);
	next unless (/[A-Za-z0-9]/);
	if (/^-- Interface /)
	{
		$_ =~ s/[\s\t]//g;
#commented out after removing  | "comment" | owner | approver from the std reference file
#		@std_interface_array = split('\|', $_);
#		$std_interface_array[0] =~ s/--.*://;
#		print "-D- The std_interface_array elements are @std_interface_array\n" if (defined $debug);
#		print "-D- The number of fields in the std_interface array are $#std_interface_array+1\n" if (defined $debug);
#		for ($i = 0 ; $i <= $#std_interface_array ; $i++)
#        	{
#                	$std_field_empty = 1 if ($std_interface_array[$i] !~ /[A-Za-z0-9]/);  
#        	}
#		if (($#std_interface_array != 3) || ($std_field_empty == 1))
#		{
#			print "-E- One or more fields is missing/empty in the line number $line_count of $interface_control_file\. Please fill all 4 fields \n";
#                print "-E- The line is --> $_\n";
#                print "-E- Exiting $0 with Errors\n";
#                exit 1;
#		}
#		$std_interface_name = $std_interface_array[0];
#new code after removing | "comment" | owner | approver from the std reference file
		$_ =~ s/--.*://;
		$std_interface_name = $_;
 
	}
	elsif (/^-- InterfaceType /)
	{
		$_ =~ s/[\s\t]//g;
		$_ =~ s/--.*://;
		$std_interface_hash{$std_interface_name}{interface_type} = $_;
	}
	elsif (/^Port/)
	{
		$std_interface_port_encountered = 1;
		$std_interface_parameter_encountered = 0;
		next;
	}
	elsif (/^Parameter/)
        {
                $std_interface_port_encountered = 0;
                $std_interface_parameter_encountered = 1;
                next;
        }
	elsif ($std_interface_port_encountered == 1)
	{
		@std_interface_port_array = split(/\s+/, $_);
		$std_interface_port_hash{$std_interface_name}{$std_interface_port_array[0]}{LinkDirection} = $std_interface_port_array[1];
		$std_interface_port_hash{$std_interface_name}{$std_interface_port_array[0]}{PortDirection} = $std_interface_port_array[2];
		if (exists $std_interface_port_array[3])
		{
			$std_interface_port_hash{$std_interface_name}{$std_interface_port_array[0]}{InterfaceLink} = $std_interface_port_array[3];
		}
		else
		{
			 $std_interface_port_hash{$std_interface_name}{$std_interface_port_array[0]}{InterfaceLink} = " ";
		}
	} 
	elsif ($std_interface_parameter_encountered == 1)
	{
		@std_interface_parameter_array = split(/\s+/, $_);
		$std_interface_parameter_hash{$std_interface_name}{$std_interface_parameter_array[0]}{Type} = $std_interface_parameter_array[1];
		$std_interface_parameter_hash{$std_interface_name}{$std_interface_parameter_array[0]}{Value} = $std_interface_parameter_array[2];
		if (exists $std_interface_parameter_array[3])
		{
			$std_interface_parameter_hash{$std_interface_name}{$std_interface_parameter_array[0]}{InterfaceLink} = $std_interface_parameter_array[3];
		}
		else
		{
			 $std_interface_parameter_hash{$std_interface_name}{$std_interface_parameter_array[0]}{InterfaceLink} = " ";
		}
	}
}
print "-D- Preparing hashes for the temp port and parameter file $temp_file\n" if (defined $debug);
while (<TEMP_PORT_PARAMETER_FILE>)
{
        $line_temp_count++;
	chomp();
        next if (/^#/);
        next unless (/[A-Za-z0-9]/);
        if (/^-- Interface /)
        {
                $_ =~ s/[\s\t]//g;
		$_ =~ s/--.*://;
                $temp_field_empty = 1 if ($_ !~ /[A-Za-z0-9]/);
                if ($temp_field_empty == 1)
                {
                        print "-E-  The interface field is missing/empty in the line number $line_temp_count of $temp_file\. Please fill it \n";
                	print "-E- The line is --> $_\n";
                	print "-E- Exiting $0 with Errors\n";
                	exit 1;
                }
                $temp_interface_name = $_;
		print "-D- The temp interface name is $temp_interface_name\n" if (defined $debug); 
        }
        elsif (/^-- InterfaceType /)
        {
                $_ =~ s/[\s\t]//g;
                $_ =~ s/--.*://;
		$temp_field_empty = 1 if ($_ !~ /[A-Za-z0-9]/);
                if ($temp_field_empty == 1)
                {
                        print "-E-  The interfaceType field is missing/empty in the line number $line_temp_count of $temp_file\. Please fill it \n";
                print "-E- The line is --> $_\n";
                print "-E- Exiting $0 with Errors\n";
                exit 1;
                }
                $temp_interface_hash{$temp_interface_name}{interface_type} = $_;
        }
        elsif (/^Port/)
        {
                $temp_interface_port_encountered = 1;
                $temp_interface_parameter_encountered = 0;
                next;
        }
        elsif (/^Parameter/)
        {
                $temp_interface_port_encountered = 0;
                $temp_interface_parameter_encountered = 1;
                next;
        }
        elsif ($temp_interface_port_encountered == 1)
        {
                @temp_interface_port_array = split(/\s+/, $_);
		print "-D- The interface port for temp interface $temp_interface_name is $temp_interface_port_array[0]\n" if (defined $debug);
                $temp_interface_port_hash{$temp_interface_name}{$temp_interface_port_array[0]}{LinkDirection} = $temp_interface_port_array[1];
                $temp_interface_port_hash{$temp_interface_name}{$temp_interface_port_array[0]}{PortDirection} = $temp_interface_port_array[2];
        	if (exists $temp_interface_port_array[3])
		{
			$temp_interface_port_hash{$temp_interface_name}{$temp_interface_port_array[0]}{InterfaceLink} = $temp_interface_port_array[3];
		}
		else
		{
			$temp_interface_port_hash{$temp_interface_name}{$temp_interface_port_array[0]}{InterfaceLink} = " ";
		}		
	}
        elsif ($temp_interface_parameter_encountered == 1)
        {
                @temp_interface_parameter_array = split(/\s+/, $_);
                $temp_interface_parameter_hash{$temp_interface_name}{$temp_interface_parameter_array[0]}{Type} = $temp_interface_parameter_array[1];
                $temp_interface_parameter_hash{$temp_interface_name}{$temp_interface_parameter_array[0]}{Value} = $temp_interface_parameter_array[2];
		if (exists $temp_interface_parameter_array[3])
		{
                	$temp_interface_parameter_hash{$temp_interface_name}{$temp_interface_parameter_array[0]}{InterfaceLink} = $temp_interface_parameter_array[3];
        	}
		else
		{
			$temp_interface_parameter_hash{$temp_interface_name}{$temp_interface_parameter_array[0]}{InterfaceLink} = " ";
		}
	}
}

foreach $i_std_interface (sort keys %std_interface_hash)
{
        if (exists $temp_interface_hash{$i_std_interface})
        {
                if ($std_interface_hash{$i_std_interface}{interface_type} ne $temp_interface_hash{$i_std_interface}{interface_type})
                {
                        $error_exit = 1;
			$modified_interface_name_hash{$i_std_interface} = 1;
                        if ($modification_type_header == 0)
                        {
				 print "-E- *************************************************************************************************\n";
                                print "-E- MODIFIED -- THE FOLLOWING INTERFACE TYPE WAS MODIFIED WHEN COMPARED TO STD INTERFACE FILE :\n";
#                               print "-E- INTERFACE_NAME | STD_INTERFACE_TYPE | MODIFIED_INTERFACE_TYPE\n";
                                printf "%-50s%-25s%-30s\n", "-E- INTERFACE_NAME", "| STD_INTERFACE_TYPE", "| MODIFIED_INTERFACE_TYPE";
                                $modification_type_header = 1;
                        }
                        printf "%-50s%-25s%-30s\n", "-E- $i_std_interface", "| $std_interface_hash{$i_std_interface}{interface_type}", "| $temp_interface_hash{$i_std_interface}{interface_type}";
                }
        }

}

if ($error_exit == 1)
{
print "-E- Exiting $0 with Errors\n";
if (!defined $debug)
{
	unlink $temp_file ;
}
exit 1;
}

print "-D- The Interface related information from reference file $interface_control_file is as below\n" if (defined $debug); 
foreach $i_std_interface (sort keys %std_interface_port_hash)
{
	print "-D- Interface : $i_std_interface\n" if (defined $debug);
	print "-D- The Port \, LinkDirection \, PortDirection and InterfaceLink for the std_interface_hash are\n" if (defined $debug);
	foreach $i_std_interface_port (sort keys %{ $std_interface_port_hash{$i_std_interface} })
        {
		print "$i_std_interface_port | $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{LinkDirection} | $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{PortDirection} | $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{InterfaceLink}\n" if (defined $debug);
	}
	print "-D- The Parameter \, Type \, Value and InterfaceLink for the std_interface_hash are\n" if (defined $debug);
	foreach $i_std_interface_parameter (sort keys %{ $std_interface_parameter_hash{$i_std_interface} })
        {
                print "$i_std_interface_parameter | $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Type} | $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Value} | $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{InterfaceLink}\n" if (defined $debug);
        }
}

print "-D- The Interface related information from input temporary file $temp_file is as below\n" if (defined $debug);
foreach $i_temp_interface (sort keys %temp_interface_port_hash)
{
        print "-D- Interface : $i_temp_interface\n" if (defined $debug);
        print "-D- The Port \, LinkDirection \, PortDirection and InterfaceLink for the temp_interface_hash are\n" if (defined $debug);
        foreach $i_temp_interface_port (sort keys %{ $temp_interface_port_hash{$i_temp_interface} })
        {
                print "$i_temp_interface_port | $temp_interface_port_hash{$i_temp_interface}{$i_temp_interface_port}{LinkDirection} | $temp_interface_port_hash{$i_temp_interface}{$i_temp_interface_port}{PortDirection} | $temp_interface_port_hash{$i_temp_interface}{$i_temp_interface_port}{InterfaceLink}\n" if (defined $debug);
        }
        print "-D- The Parameter \, Type \, Value and InterfaceLink for the temp_interface_hash are\n" if (defined $debug);
        foreach $i_temp_interface_parameter (sort keys %{ $temp_interface_parameter_hash{$i_temp_interface} })
        {
                print "$i_temp_interface_parameter | $temp_interface_parameter_hash{$i_temp_interface}{$i_temp_interface_parameter}{Type} | $temp_interface_parameter_hash{$i_temp_interface}{$i_temp_interface_parameter}{Value} | $temp_interface_parameter_hash{$i_temp_interface}{$i_temp_interface_parameter}{InterfaceLink}\n" if (defined $debug);
        }
}

foreach $i_std_interface (sort keys %std_interface_hash)
{
        if (exists $temp_interface_hash{$i_std_interface})
        {
		print "-D- The interface key $i_std_interface exists in std interface hash and temp interface hash\n"  if (defined $debug);
		foreach $i_std_interface_port (sort keys %{ $std_interface_port_hash{$i_std_interface} })		
		{
		    print "-D- The port in std_interface_hash is $i_std_interface_port \n" if (defined $debug);  	
		    if (exists $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port})
		    {	 
			print "-D- The port $i_std_interface_port of interface $i_std_interface exists in std_interface_hash and temp_interface_hash\n"  if (defined $debug);	
			if (($std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{LinkDirection} ne $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port}{LinkDirection}) || 
			    ($std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{PortDirection} ne $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port}{PortDirection}) || 
			    ($std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{InterfaceLink} ne $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port}{InterfaceLink}))
			{
				$error_exit = 1;
				$modified_interface_name_hash{$i_std_interface} = 1;
				if ($modification_port_header == 0)
                                {
					 print "-E- *************************************************************************************************\n";
                                        print "-E- MODIFIED -- THE FOLLOWING INTERFACE PORTS WERE MODIFIED WHEN COMPARED TO STD FILE PORTS :\n";
                                        printf "%-40s%-30s%-25s%-25s%-36s%-36s%-35s%-25s\n", "-E- INTERFACE_NAME", "| PORT_NAME", "| STD_PORT_LINKDIRECTION", "| STD_PORT_PORTDIRECTION", "| STD_PORT_INTERFACELINK", "| MODIFIED_PORT_LINKDIRECTION", "| MODIFIED_PORT_PORTDIRECTION", "| MODIFIED_PORT_INTERFACELINK";
                                        $modification_port_header = 1;
                                }
				printf "%-40s%-30s%-25s%-25s%-36s%-36s%-35s%-25s\n", "-E- $i_std_interface", "| $i_std_interface_port", "| $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{LinkDirection}", "| $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{PortDirection}", "| $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{InterfaceLink}", "| $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port}{LinkDirection}", "| $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port}{PortDirection}", "| $temp_interface_port_hash{$i_std_interface}{$i_std_interface_port}{InterfaceLink}";
			}
			delete ($std_interface_port_hash{$i_std_interface}{$i_std_interface_port});
			delete ($temp_interface_port_hash{$i_std_interface}{$i_std_interface_port});
		    }
		}
	}
}
foreach $i_std_interface (sort keys %std_interface_hash)
{
	if (exists $temp_interface_hash{$i_std_interface})
        {
		print "-D- the key $i_std_interface exists\n in both hashes"  if (defined $debug);
		foreach $i_std_interface_parameter (sort keys %{ $std_interface_parameter_hash{$i_std_interface} })
		{
		   if (exists $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter})
                    {	
			if (($std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Type} ne $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Type}) || 
			    ($std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Value} ne $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Value}) || 
			    ($std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{InterfaceLink} ne $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{InterfaceLink}))
                        {
                                $error_exit = 1;
				$modified_interface_name_hash{$i_std_interface} = 1;
                                if ($modification_parameter_header == 0)
                                {
					
					 print "-E- *************************************************************************************************\n";
                                        print "-E- MODIFIED -- THE FOLLOWING INTERFACE PARAMETERS WERE MODIFIED WHEN COMPARED TO STD FILE PORTS :\n";
                                        printf "%-40s%-30s%-25s%-25s%-30s%-35s%-30s%-25s\n", "-E- INTERFACE_NAME", "| PARAMETER_NAME", "| STD_PARAMETER_TYPE", "| STD_PARAMETER_VALUE", "| STD_PARAMETER_INTERFACELINK", "| MODIFIED_PARAMETER_TYPE", "| MODIFIED_PARAMETER_VALUE", "| MODIFIED_PARAMETER_INTERFACELINK";
                                        $modification_parameter_header = 1;
                                }
                                printf "%-40s%-30s%-25s%-25s%-30s%-35s%-30s%-25s\n", "-E- $i_std_interface", "| $i_std_interface_parameter", "| $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Type}", "| $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Value}", "| $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{InterfaceLink}", "| $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Type}", "| $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Value}", "| $temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{InterfaceLink}";
                        }
			print "-D- Deleting the parameter hash of $i_std_interface and parameter $i_std_interface_parameter that is $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}\n" if (defined $debug);  
                        delete ($std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter});
                        delete ($temp_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter});
		   } 
                }

	}
}

foreach $i_temp_interface (sort keys %temp_interface_hash)
{
	if (keys %{ $temp_interface_port_hash{$i_temp_interface} })
	{
        	$error_exit = 1;
		$added_interface_name_hash{$i_temp_interface} = 1;
		if ($added_port_header == 0)
                {
			 print "-E- *************************************************************************************************\n";
        		print "-E- ADDED -- THE FOLLOWING INTERFACE PORTS WERE ADDTIONAL WHEN COMPARED TO STD FILE PORTS :\n";
			printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- INTERFACE_NAME", "| PORT_NAME", "| PORT_LINKDIRECTION", "| PORT_PORTDIRECTION", "| PORT_INTERFACELINK";
        		$added_port_header = 1;
		}
		foreach $i_temp_interface_port (sort keys %{ $temp_interface_port_hash{$i_temp_interface} })
		{
			printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- $i_temp_interface", "| $i_temp_interface_port", "| $temp_interface_port_hash{$i_temp_interface}{$i_temp_interface_port}{LinkDirection}", "| $temp_interface_port_hash{$i_temp_interface}{$i_temp_interface_port}{PortDirection}", "| $temp_interface_port_hash{$i_temp_interface}{$i_temp_interface_port}{InterfaceLink}";
		}
	}
}
foreach $i_temp_interface (sort keys %temp_interface_hash)
{
	if (keys %{ $temp_interface_parameter_hash{$i_temp_interface} })
        {
                $error_exit = 1;
		$added_interface_name_hash{$i_temp_interface} = 1;
		if ($added_parameter_header == 0)
                {
			 print "-E- *************************************************************************************************\n";
                	print "-E- ADDED -- THE FOLLOWING INTERFACE PARAMETER WERE ADDTIONAL WHEN COMPARED TO STD FILE PARAMETERS :\n";
                	printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- INTERFACE_NAME", "| PARAMETER_NAME", "| PARAMETER_TYPE", "| PARAMETER_VALUE", "| PARAMETER_INTERFACELINK";
                	$added_parameter_header = 1;
		}
		foreach $i_temp_interface_parameter (sort keys %{ $temp_interface_parameter_hash{$i_temp_interface} })
                {
                        printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- $i_temp_interface", "| $i_temp_interface_parameter", "| $temp_interface_parameter_hash{$i_temp_interface}{$i_temp_interface_parameter}{Type}", "| $temp_interface_parameter_hash{$i_temp_interface}{$i_temp_interface_parameter}{Value}", "| $temp_interface_parameter_hash{$i_temp_interface}{$i_temp_interface_parameter}{InterfaceLink}";
                } 
        }
}
foreach $i_std_interface (sort keys %std_interface_hash)
{
        if (keys %{ $std_interface_port_hash{$i_std_interface} })
        {
                $error_exit = 1;
		$deleted_interface_name_hash{$i_std_interface} = 1;
		if ($deleted_port_header == 0)
                {
			 print "-E- *************************************************************************************************\n";
			print "-E- DELETED -- THE FOLLOWING INTERFACE PORTS WERE MISSING WHEN COMPARED TO STD FILE PORTS :\n";
           		printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- INTERFACE_NAME", "| PORT_NAME", "| PORT_LINKDIRECTION", "| PORT_PORTDIRECTION", "| PORT_INTERFACELINK";
			$deleted_port_header = 1;
		}
                foreach $i_std_interface_port (sort keys %{ $std_interface_port_hash{$i_std_interface} })
                {
                        printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- $i_std_interface", "| $i_std_interface_port", "| $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{LinkDirection}", "| $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{PortDirection}", "| $std_interface_port_hash{$i_std_interface}{$i_std_interface_port}{InterfaceLink}";
                }
        }
}
foreach $i_std_interface (sort keys %std_interface_hash)
{
        if (keys %{ $std_interface_parameter_hash{$i_std_interface} })
        {
                $error_exit = 1;
		$deleted_interface_name_hash{$i_std_interface} = 1;	
		if ($deleted_parameter_header == 0)
                {
			print "-E- *************************************************************************************************\n";
                	print "-E- DELETED -- THE FOLLOWING INTERFACE PARAMETERS WERE MISSING WHEN COMPARED TO STD FILE PARAMETERS :\n";
                	printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- INTERFACE_NAME", "| PARAMETER_NAME", "| PARAMETER_TYPE", "| PARAMETER_VALUE", "| PARAMETER_INTERFACELINK";
                	$deleted_parameter_header = 1;
		}
		foreach $i_std_interface_parameter (sort keys %{ $std_interface_parameter_hash{$i_std_interface} })
                {
                        printf "%-50s%-30s%-30s%-30s%-30s\n", "-E- $i_std_interface", "| $i_std_interface_parameter", "| $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Type}", "| $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{Value}", "| $std_interface_parameter_hash{$i_std_interface}{$i_std_interface_parameter}{InterfaceLink}";
                }
        }
}
if (!defined $debug)
{
	unlink $temp_file;
}
if ($error_exit == 1)
{
	print "=====================================================================================\n";
	print "-E- ERROR_SUMMARY :\n";
	if (keys %modified_interface_name_hash)
	{
		print "=====================================================================================\n";
		print "-E- MODIFIED - The following Interfaces were modified :\n\n";
		print "-E- $_\n" for keys %modified_interface_name_hash;
	}
	if (keys %added_interface_name_hash)
	{
		print "=====================================================================================\n";
		print "-E- ADDED - The following Interfaces were added or had additional ports/parameters :\n\n";
		print "-E- $_\n" for keys %added_interface_name_hash;
	}
	if (keys %deleted_interface_name_hash)
	{
		print "=====================================================================================\n";
		print "-E- DELETED - The following Interfaces were deleted or had missing ports/parameters :\n\n";
		print "-E- $_\n" for keys %deleted_interface_name_hash;
	}
	print "=====================================================================================\n";	
	print "-E- Exiting $0 with Errors\n";
	exit 1;
}
if (!defined $debug)
{
unlink $temp_file;
}
print "-I- End of $0. Interface port and parameter list matched successfully\n";
