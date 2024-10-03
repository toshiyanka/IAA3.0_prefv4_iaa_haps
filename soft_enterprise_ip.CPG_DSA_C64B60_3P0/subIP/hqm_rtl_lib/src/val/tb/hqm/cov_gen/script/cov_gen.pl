#!/usr/intel/pkgs/perl/5.14.1/bin/perl -w

use strict;
use warnings;
use Cwd;

my ($model_root) = @ARGV;
print "$model_root \n";
my $line;
my $list_path;

my $TB_VDB_PATH = "$model_root/target/hqm/vcs_4value/hqm/hqm.simv.vdb";
my $TB_VDB_PATH_MPP = "$model_root/target/hqm/vcs_4value_mpp/hqm/hqm.simv.vdb";
my $HIER_FILE_PATH = "$model_root/verif/tb/hqm/cov_gen/excl/mrb_hqm_cov_excl.hier";
my $EXCL_FILE_PATH = "$model_root/verif/tb/hqm/cov_gen/excl/";
my $EXCL_HVP = "$model_root/verif/tb/hqm/cov_gen/excl/hqmv25_func_coverage.hvp";
my $finput = "$model_root/verif/tb/hqm/cov_gen/script/testlist_path.txt";

my $regress_path = "$model_root/regression/hqm/hqm/" ;
print "$regress_path \n";
print "$finput\n";

open INFILE , $finput or die  "Error in opening $!";

if (not defined $regress_path) {
Usage();
die "Regression path needed !!! \n\n";
}

if (not defined $model_root) {
Usage();
die "MODEL ROOT needed !!! \n\n";
}

##if (defined $osetup_needed) {
##}
##print "Regress dir: $regress_path;\n MODEL ROOT: $model_root\n";

 while(<INFILE>){
  chomp($line=$_);
  ##check for comment or empty line
  if($line =~ /^#/){print "line comment out\n"; }
  elsif($line =~ /^$/){print "empty line \n"; }
  else { 
   $list_path= "${regress_path}". "$_";
   print "$list_path";
   gen_coverage();
  }
 } ##while
print "generate merging covergae \n";
##gen_merged_cov();


sub gen_merged_cov{
 	chdir($model_root);
 	my $dir = getcwd();
  print "generating merged coverae at path $model_root \n";
  system(" find $EXCL_FILE_PATH -name 'hqmv25_i_*.el' > $EXCL_FILE_PATH/hqmv2_excl_list ");
 	system(" echo $TB_VDB_PATH > vdbfiles.list");
 	system(" echo $TB_VDB_PATH_MPP >> vdbfiles.list");
  system(" find ${model_root}/regression/hqm/hqm/*.list* -maxdepth 1 -name 'hqm_tb_cov.vdb' >> vdbfiles.list");
 	system(" cat vdbfiles.list ");
  system(" sed '/hqm_reg_tests\\|hqm_reg_reset_tests/d' vdbfiles.list > vdbfiles_func.list ");  
  ## system("nbjob run --mode interactive --target sc_normal3 --qslot /NCSG/sdg74/fe/rgr/hqm/regress --class 'SLES11SP4&&10G'  urg -full64  -show tests -f vdbfiles.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_all -report hqm_merged_all  -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks -plan $EXCL_HVP -log urg_warning.log ");
  ## system("nbjob run --mode interactive --target sc_normal3 --qslot /NCSG/sdg74/fe/rgr/hqm/regress --class 'SLES11SP4&&10G'  urg -full64  -show tests -f vdbfiles_func.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_func -report hqm_merged_func  -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks -plan $EXCL_HVP -log urg_warning_func.log ");
  ## system("nbjob run --mode interactive --target sc_normal3 --qslot /NCSG/sdg74/fe/rgr/hqm/regress --class 'SLES11SP4&&10G'  urg -full64  -show ratios -f vdbfiles_func.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_ratios -report hqm_merged_ratios  -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks -plan $EXCL_HVP -log urg_warning_ratios.log ");
system(" urg -full64  -show tests -f vdbfiles.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_all -report hqm_merged_all  -plan $EXCL_HVP -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks -log urg_warning.log  ");
  ##system(" urg -full64  -show tests -f vdbfiles.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_all -report hqm_merged_all  -merge_across_libs -plan $EXCL_HVP -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -metric assert -metric group -group ratio -excl_bypass_checks -log urg_warning.log  ");
#  system(" urg -full64  -show tests -f vdbfiles_func.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_func -report hqm_merged_func  -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks -merge_across_libs -plan $EXCL_HVP -log urg_warning_func.log -metric assert  ");
##system(" urg -full64  -show tests -group ratio -f vdbfiles_func.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_ratios -report hqm_merged_ratios -merge_across_libs -plan $EXCL_HVP -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks  -log urg_warning_ratios.log -metric assert -metric group -group ratio ");
system(" urg -full64  -show tests -group ratio -f vdbfiles_func.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_merged_ratios -report hqm_merged_ratios -merge_across_libs -plan $EXCL_HVP -elfilelist $EXCL_FILE_PATH/hqmv2_excl_list -excl_bypass_checks -metric group -metric assert   -log urg_warning_ratios.log ");

}



 
 sub gen_coverage{
  print "generate coverae for list = $line \n";
  chomp($list_path);  
  if (-e $list_path and -d $list_path) {
 	    chdir($list_path);
 	    my $dir = getcwd();
 	    print "In regression directory $dir\n";
      system(" find `pwd` -name postsim.fail > fail.list ");  
      system(" sed -i 's/postsim.fail/*.vdb/g' fail.list ");
      system(" sed -i 's/^/rm -rf /g' fail.list " );
      system(" chmod +x ./fail.list " );
      system(" ./fail.list " );
 	    system ('gunzip -d -r */*.vdb/*');
 	    ##system("nbjob run --mode interactive --target sc_normal3 --qslot /NCSG/sdg74/fe/rgr/hqm/regress --class 'SLES11SP4&&8G'  gunzip -d -r */*.vdb/* ");
 	    if(-e $model_root and -d $model_root) {
 	      system("echo $TB_VDB_PATH > vdbfiles.list");
 	      system(" echo $TB_VDB_PATH_MPP >> vdbfiles.list");
 	      system('find `pwd` -name "*.vdb" >> vdbfiles.list');
 	      ##system('cat vdbfiles.list');
 	      ##system("nbjob run --mode interactive --target sc_normal3 --qslot /NCSG/sdg74/fe/rgr/hqm/regress --class 'SLES11SP4&&10G'  urg -full64 -show tests -f vdbfiles.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_tb_cov ");
 	      system(" urg -full64 -show tests -f vdbfiles.list -dir $TB_VDB_PATH -hier $HIER_FILE_PATH  -dbname hqm_tb_cov ");
 	      ##system("nbjob run --mode interactive --target sc_normal3 --qslot /NCSG/sdg74/fe/rgr/hqm/regress --class 'SLES11SP4&&8G'  gzip -d -r */*.vdb/* ");
 	      system("gzip -d -r */*.vdb/* ");
 	    }
 	    else  {
 	      Usage();
 	      die "Provide valid MODEL ROOT dir!!! \n\n";
 	    }
   }
   else	{
 	    Usage();
 	    die "Provide valid regression dir!!! \n\n";
   }
 }
 
 sub Usage{
    print "Call this script to generate coverage report from compressed db dumped by simregress command\n";
    print "regression list name should present in ./cov_gen/script/testlist_path.txt \n";
    print "cov_gen.pl <model_root> \n";
    print "\tE.g, cov_gen.pl <model_root> )\n";
   ## print "\tOr \n\tE.g, cov_gen.pl <regression_path> <model_root> 0 (if vcs is already setup)\n";
 }

close(INFILE);
