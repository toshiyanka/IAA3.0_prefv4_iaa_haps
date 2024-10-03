#!/usr/local/bin/perl -w
use strict;

#system("rm -rf summary.rpt");
#system("touch summary.rpt");
my $tool=$ENV{"SFM_TOOL"};
if ($tool =~/lintra/i) {
  generate_lintra_report();
}elsif($tool =~/regression/i) {
  generate_regression_report();
}elsif($tool =~/cdc/i) {
  generate_cdc_report();
}elsif($tool =~/syn/i) {
  generate_syn_report();
}elsif($tool =~/gls/i) {
  generate_gls_report();
}elsif($tool =~/scancov/i) {
  generate_scancov_report();
}


sub generate_lintra_report{
    my $file_name=$ENV{"LINTRA_REPORT"};
    open (my $parfile,">> summary.rpt") or warn "$!\n";
    my $i=0;
    my $start="";
    print $parfile "================================================================================ \n";
    print $parfile "LINTRA SUMMARY.\n";
    print $parfile "================================================================================ \n";
    if (-e $file_name) {
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
            print $parfile $line;
        }
        close FILE;
    } else {
       print $parfile "LINTRA Not successfully completed. \n"; 
    }    
    close $parfile;
}

sub generate_regression_report {
    my $file_name=$ENV{"REGRESSION_LOG_PATH"};
    open (my $parfile,">> summary.rpt") or warn "$!\n";
    my $i=0;
    my $start="";
    print $parfile "================================================================================ \n";
    print $parfile "REGRESSION SUMMARY.:\n\n";
    print $parfile "================================================================================ \n";
    if (-e $file_name) {
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          if($line =~/^Summary$/){
            $start=$i;
          }
        $i++;  
        }
        close FILE;
        $i=0;
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          if ($start ne "") {
            if ($i >= $start) {
              print $parfile $line;
            }
          } else {
            print $parfile " Regression Summary Not found. \n";
            goto END;
          }
          $i++;
        }
        close FILE;
    } else {
             print $parfile "Regression is not successfully completed. \n";    
    }
    END:
    close $parfile;
}
sub generate_cdc_report {
    my $file_name=$ENV{"CDC_LOG_PATH"};
    print $file_name."\n";
    open (my $parfile,">> summary.rpt") or warn "$!\n";
    my $i=0;
    my $start="";
    print $parfile "================================================================================ \n";
    print $parfile "CDC SUMMARY.\n";
    print $parfile "================================================================================ \n";
    if (-e $file_name) {
    open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          if($line =~/^Error\/Warning Summary/){
            $start=$i;
          }
        $i++;  
        }
        close FILE;
        $i=0;
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          
          if ($i >= $start) {
            print $parfile $line;
          }
          $i++;
        }
            close FILE;
    } else {
        print $parfile "CDC is not completed successfully. \n";    
    }
    close $parfile;
}
sub generate_syn_report {
    my $file_name=$ENV{"SYN_LOG_PATH"};
    open (my $parfile,">> summary.rpt") or warn "$!\n";
    my $i=0;
    my $start="";
    print $parfile "================================================================================ \n";
    print $parfile "Synthesis SUMMARY. \n";
    print $parfile "================================================================================ \n";
    if (-e $file_name) {
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
              print $parfile $line;
        }
        print $parfile "Please find the attachments for Synthesis logs.\n";
        close FILE;
    } else {
            print $parfile "Synthesis is not completed successfully. \n";
            goto END;
    }
    END:    
    close $parfile;
}

sub generate_gls_report {
    my $file_name=$ENV{"GLS_LOG_PATH"};
    open (my $parfile,">> summary.rpt") or warn "$!\n";
    my $i=0;
    my $start="";
    print $parfile "================================================================================ \n";
    print $parfile "GLS SUMMARY.\n";
    print $parfile "================================================================================ \n";
    if (-e $file_name) {
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          if($line =~/^Test results$/){
            $start=$i;
          }
        $i++;  
        }
        close FILE;
        $i=0;
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          if ($i >= $start) {
            print $parfile $line;
          }
          $i++;
        }
        close FILE;
    } else {
             print $parfile "GLS is not successfully completed. \n";
             goto END;
    }
    END:
    close $parfile;
    
}
sub generate_scancov_report {
    my $file_name=$ENV{"SCAN_COV_LOG_PATH"};
    open (my $parfile,">> summary.rpt") or warn "$!\n";
    my $i=0;
    my $start="0";
    print $parfile "================================================================================ \n";
    print $parfile "SCAN COVERAGE SUMMARY.\n";
    print $parfile "================================================================================ \n";
    if (-e $file_name) {
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          if($line =~ /^\s+Statistics Report\s+/){
            $start=$i;
          } $i++;  
        }
        close FILE;
        $i=0;
        open(FILE,"<$file_name"); #open the file
        while(my $line=<FILE>) #read file
        {
          
          if (($i >= $start) && ($i > 0)) {
            print $parfile $line;
          }
          $i++;
        }
    close FILE;    
    } else {
        print $parfile "Scan Coverage is not completed successfully. \n";
        goto END;
    }
    END:
    close $parfile;

}
