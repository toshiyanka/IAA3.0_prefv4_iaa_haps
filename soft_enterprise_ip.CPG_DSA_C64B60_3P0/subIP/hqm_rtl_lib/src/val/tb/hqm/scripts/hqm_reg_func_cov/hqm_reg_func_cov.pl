#!/usr/local/bin/perl

#---------------------------------------------------------------------------------------------------------------
#Description:
#
# This script help verification engineer to check coverage of control and status register 
# (or any other intended register) with functional covergroup. Covergroups are created for
# each register and Coverpoints are created for each field of the register . 
#
#---------------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------------
# Set the Modelroot in which the coverage files need to be generated.
#---------------------------------------------------------------------------------------------------------------

my $model_root = "$IP_MODELS/hqm/hqm-srvr10nm-wave4-latest";

#---------------------------------------------------------------------------------------------------------------
# Path defines where the coverage files will be generated. 
#---------------------------------------------------------------------------------------------------------------

my $path  = "$model_root/verif/tb/hqm/scripts/hqm_reg_func_cov";
my $path_out = "./output";

#---------------------------------------------------------------------------------------------------------------
# Enter the input string / register to be grepped in input.txt file 
#---------------------------------------------------------------------------------------------------------------

my $input = "$path/input.txt";

#---------------------------------------------------------------------------------------------------------------
# Enter the grep path from where the register and their fields can be grepped. 
#---------------------------------------------------------------------------------------------------------------

my $greppath = "$model_root/target/hqm_map_nebulon_lib/nebulon/output/ovm/*";

#---------------------------------------------------------------------------------------------------------------
# Creating an output directory in which the coverage outputs can be stored.
#---------------------------------------------------------------------------------------------------------------

system(" mkdir $path_out ");

#---------------------------------------------------------------------------------------------------------------
# Below are the intermediate outputs which would be generated, Can be retained if run in debug mode. 
#---------------------------------------------------------------------------------------------------------------

my $grepoutput = "$path_out/grepoutput.sv";
my $path_defines = "$path_out/path_defines.sv";
my $tmp_path_defines = "$path_out/tmp_path_defines.sv";
my $register_field_define = "$path_out/register_field_define.sv";
my $coverpoints = "$path_out/coverpoints.sv";

#---------------------------------------------------------------------------------------------------------------
# Below are the output files generated using this script, Covergroups are created for each register and
# Coverpoints are created for each field of the register. 
#---------------------------------------------------------------------------------------------------------------

my $cov_group = "$path_out/hqm_reg_func_cov_groups.sv";
my $cov_define = "$path_out/hqm_reg_func_cov_define.sv";

#---------------------------------------------------------------------------------------------------------------
# Open the files in read , write and append mode respectively.
#---------------------------------------------------------------------------------------------------------------

  unless (open(COVERPOINTS, "+> $coverpoints")) {
          die ("cannot open output file covfile\n");
  }
  unless (open(COV_GROUP, ">$cov_group")) {
          die ("cannot open output file groupfile\n");
  }
  unless (open(PATH_DEFINES, "+>$path_defines")) {
          die ("cannot open output file groupfile\n");
  }
  unless (open(TMP_PATH_DEFINES, ">$tmp_path_defines")) {
          die ("cannot open output file groupfile\n");
  }
  unless (open(INPUTFILE, "<$input")) {
          die ("cannot open input file \n");
  }
  unless (open(GREPOUTPUT, "+>$grepoutput")) {
          die ("cannot open input file status\n");
  }
  unless (open(REGDEFINE, ">$register_field_define")) {
          die ("cannot open input file status define\n");
  }
  unless (open(COV_DEFINE, ">$cov_define")) {
          die ("cannot open input file status define\n");
  }

#----------------------------------------------------------------------------------------------------------------
# Ignores the emptylines and commentedlines ('#' , '\s#') in input.txt, grep excludes the reserved fields of
# the register .
#----------------------------------------------------------------------------------------------------------------

my $string ;
my $message = $ARGV[0];
@inp = <INPUTFILE>;
$in = 0 ;
while($inp[$in] ne "")
  {
    chomp($inp[$in]);
      $inp[$in] =~ s/^\s+//;
      $inp[$in] =~ s/\s+$//;
      if ($inp[$in] =~ /^#/)
       {
           print "line comment out\n"; 
       }
      elsif ($inp[$in] =~ /^$/)
       {
          print "empty line \n";
       }
      else
       {
          system(" grep -ir 'new.*$inp[$in]' $greppath | grep -v 'RSVZ' | grep -v 'RSVD' >> $grepoutput");
       }
    $in++;
  }

#-------------------------------------------------------------------------------------------------------------------------
# Generates the Defines File and coverpoints, Substitutions are done to the grep output to get the desired register
# field defines, path defines and coverpoints.
#
# A sample grepoutput line is given below for reference.
#
# $model_root/target/hqm_map_nebulon_lib/nebulon/output/ovm/hqm_aqed_pipe_bridge_regs.svh:  
# CHICKEN_SIM = new("CHICKEN_SIM", "RW", 1, 0, {"i_hqm_aqed_pipe_core.i_hqm
# _aqed_pipe_register_pfcsr.i_hqm_aqed_target_cfg_control_general.internal_f[0:0]"});
#
#-------------------------------------------------------------------------------------------------------------------------

@stat = <GREPOUTPUT>;
$line_num = 0;
print REGDEFINE " ##-----------------------------------REGISTER FIELD DEFINES-------------------------------##\n\n ";
print COV_DEFINE " ##--------------------------------PATH DEFINES--------------------------------##\n\n ";
while ($stat[$line_num] ne "")
   {
   ## --------sed commands----------- ## 

     $stat[$line_num] =~ s/^.*svh://g; 
     $stat[$line_num] =~ s/^\s+//;
     @s[$line_num] = $stat[$line_num];
     $s[$line_num] =~  s/= new.*\;//g;
     $stat[$line_num] =~ s/= new.*{//g;
     $stat[$line_num] =~ s/"}\);//g;
     my $regname = (split '\.', $stat[$line_num])[-2];
     $regname =~ tr/a-z/A-Z/;

   ##------------change this function as per project ----------##  
     patternmatch(); 
                 
     $stat[$line_num] =~ s/"/`$string./g;

   ##---------- generates define and coverpoints----------##
      print REGDEFINE "`define $regname\_$stat[$line_num]";

      $new[$line_num] = $stat[$line_num];
      $new[$line_num] =~ s/^.*`/`/g;
      my @temp = split '\.', $new[$line_num];
      $temp[-1] = "";
      $new[$line_num]= join(".", @temp);
      $new[$line_num] =~ s/\.$//;
      print TMP_PATH_DEFINES "`define $regname $new[$line_num]\n";
      $str = "CP_REG_$regname\_$s[$line_num]: coverpoint `$regname\_$s[$line_num]  iff (rst_n & cfg_write) ;";
      $str =~ s/\n//g; 
      print COVERPOINTS "$str\n";
     $line_num++
   }

#-------------------------------------------------------------------------------------------------------------------------
# Remove the Duplicates, Merge the path defines and register field defines to hqm_reg_func_cov_define.sv    
#-------------------------------------------------------------------------------------------------------------------------

system (" uniq $tmp_path_defines > $path_defines");
system ("cat $path_defines $register_field_define >> $cov_define ");

#-------------------------------------------------------------------------------------------------------------------------
# Generates the Covergroup File.  
#-------------------------------------------------------------------------------------------------------------------------

module_description();
@cg = <PATH_DEFINES>;
$g =0;
while($cg[$g] ne "")
  {
     my $search = (split '\.', $cg[$g])[-1];
     $search =~ tr/a-z/A-Z/;
     chomp($search);
     $cgs[$g] = $search;
     $g++;
  }
$gn = 0 ;
while($cgs[$gn] ne "")
 {
     chomp($cgs[$gn]);
     covergroup();
     $grep = "$path_out/cp_$gn\_reg.sv";
     system (" grep -ir '$cgs[$gn]' $coverpoints > $grep ");
     unless (open(CPREG, "$grep"))
       {
          die ("cannot open output file cpfile\n");
       }

    @do = <CPREG>;
    $line= 0;
 
    while ($do[$line] ne "")
      {
         $do[$line] =~ s/\t/\n/;
         print COV_GROUP "$do[$line]";
         $line++;
      }
      print COV_GROUP "\n endgroup \n\n";
    $gn++;
 }
  #-----------------
print COV_GROUP "initial begin\n\n";
$gu=0;
while($cgs[$gu] ne "")
  {
     print COV_GROUP " $cgs[$gu]\_functional_reg_CG $cgs[$gu]\_functional_reg_CG_inst = new(`$cgs[$gu].rst_n, `$cgs[$gu].cfg_write);\n\n";
     $gu++;
  }
print COV_GROUP "end\n\n `endif\n\n endmodule\n\n ";

#-------------------------------------------------------------------------------------------------------------------------
# Retain the intermediate outputs if run in debug mode.   
#-------------------------------------------------------------------------------------------------------------------------

if($ARGV[0] =~ m/debug/)
 {
   print "intermediate outputs retained\n" ;
 }
else 
 {
   system("rm $grepoutput $path_defines $tmp_path_defines $register_field_define $coverpoints");
   system("rm $path_out/cp_*"); 
 }

#-------------------------------------------------------------------------------------------------------------------------
# Provides the module description of the covergroup file.   
#-------------------------------------------------------------------------------------------------------------------------

sub module_description
  {
    print COV_GROUP "module hqm_reg_func_cov_groups import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();\n\n\n `ifdef HQM_COVER_ON\n\n "  ;
  }

#-------------------------------------------------------------------------------------------------------------------------
# Generates the covergroup for each register.
#-------------------------------------------------------------------------------------------------------------------------

sub covergroup 
  {
    $material = "covergroup $cgs[$gn]\_functional_reg_CG (ref logic rst_n, ref logic cfg_write ) @ (posedge `$cgs[$gn].clk ) ;\n\n option.comment = \"$cgs[$gn] HQM Functional Register Coverage \";\n\n ";
    print COV_GROUP "$material";
  }

#-------------------------------------------------------------------------------------------------------------------------
# Matches the Pattern and provides the define path.
#-------------------------------------------------------------------------------------------------------------------------

sub patternmatch 
  {
      if($stat[$line_num] =~ m/aqed/  )
        {
            $string = "HQM_AQED_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/atm_pipe/)
        {
            $string = "HQM_ATM_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/list_sel/)
        {
            $string = "HQM_LIST_SEL_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/reorder_pipe/)
        {
            $string = "HQM_REORDER_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/qed/)
        {
            $string = "HQM_QED_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/nalb/)
        {
            $string = "HQM_NALB_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/dir_pipe/)
        {
            $string = "HQM_DIR_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/credit_hist/)
        {
            $string = "HQM_CREDIT_HIST_PIPE_PATH";
        }
      elsif($stat[$line_num] =~ m/master_core/)
        {
            $string = "HQM_MASTER_PATH";
        }
  }
