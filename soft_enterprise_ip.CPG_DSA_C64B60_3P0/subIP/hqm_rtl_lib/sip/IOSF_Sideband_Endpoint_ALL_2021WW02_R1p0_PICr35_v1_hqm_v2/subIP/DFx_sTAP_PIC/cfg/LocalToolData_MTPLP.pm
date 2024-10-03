# DO NOT REMOVE!!!  Learn to code warning-free perl instead.

use warnings FATAL => 'all';
package ToolData;
my @add_replace_ctech_files = (
  glob("/p/hdk/cad/ctech/n7/c4v19ww40d_hdk162_v1.0.6_pre.2_mtp_sip_sbx/source/h240/lvt8/*ctech_lib*.sv"),
  glob("/p/hdk/cad/ctech/n7/ctech_exp_c4v19ww43b_hdk161_mtp_sip_sbx/source/n7/h240/lvt8/*ctech_lib*.sv"),
);

my @replace_files;
foreach my $file (@add_replace_ctech_files) {
      my @source = split(/source/,$file);
      my @function = split(/ctech_lib_/,$source[1]);
      my $replace = {
             match => "source/v/ctech_lib_$function[1]",
             replace => "source$function[0]ctech_lib_$function[1]",
      };
     push(@replace_files,$replace);
}

my %LocalToolData = (
stage_collage_build => {
                PATH => "&get_tool_path('rtltools')/stages/collage_build.pm",
                OTHER => {
                     collage_build_enable => "on",
                },
         },
    collage  => {
        OTHER => {
            collage_build_ip => "stap",
            collage_build_script => "tools/collage/build/builder.stap.tcl",
        },
    },

tsa_dc_config => {
   #  Comment out the execiting SETUP and be_tool_override SETUP => {
   #  -be_tool_override => {
   #  },
   #},
'INPUTS' => {
      -use_vcs_xml => '1',         
      -top_hier => "", # Make empty top.hier pointer
	  -chip_dump =>    "$MODEL_ROOT/target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/DC/fev_v2k/fullchipdump.final.pl"
   },
    #tophiergen HASH is only required is you use FEBE tophiergen method, for simbuild method  you would not need it 
	# 'tophiergen' => {
   	#      -hier_dump_top => 'bare_ip_tb_lib.bare_ip_tbtop',
   	#      -test_name     => 'verif/tests/dump_hier_test',# or simply -test_name     => 'dump_hier_test'
   	#      -args => '-no-tim -no-enable_hier_dump -no-hier_dump' , # simply -args => ,
   	#    },
   'V2K_PREP' => {
	   #-hier => '^STapTop',  # Specify the testbench name  FIXME 
		 -vcs_xml    =>  "$MODEL_ROOT/target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/vcs_lib/P-2019.06-SP1-1/models/stap_model/config_diagnostics.xml",
		  -hier => '^top',  # Specify the testbench name  FIXME 
		  -ace_command => "ace -rtl M:stap_model",  # Command to dump out the ace file list includes simulation content  
		  -ace_filter_command => "ace -rtl M:stap_model -filter Synthesis", # Command to dump out the ace file list with synthesis filter, used for constrction 
          ##below are the pointers of ace-filelists created and used in flg_v2k stage
		  -acefilelist => "$MODEL_ROOT/target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/stap.Mstap_model.filelist.Synthesis.pl",
		   -acefullfilelist => "$MODEL_ROOT/target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/stap.Mstap_model.filelist.pl",
		   #"-elab_log" => "target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/makefiles/vcs/makeLogs/stap_model__ELAB_MODELS__vcs.log",
					    "-elab_log" => "",
         },
 'flg_v2k' => {
    -enable_ctech => 0,
    -enable_ctech_replace =>1,
    -enable_all_dependent_libs => 1,
    -golden_v2k_cfg => 1,
    -v2k_cfg_lrm => 1,
    -disable_suffix_lib => 1,
	# -vcsmakelogsdir => "target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/makefiles/vcs/makeLogs", # Reference to VCS makelogs area
#    -extra_commands_post_fe => "$MODEL_ROOT/tools/febe/inputs/scripts/rtl_list_2stage_ctech_sanity_checker.pl"  #Sanity checks for ctechs 
    # Copy /nfs/iind/disks/iind_lpss_00013/msasikum/lpss_mtplp/new/ip-lpss-siip/tools/febe/inputs/scripts/rtl_list_2stage_ctech_sanity_checker.pl to your local       
    # tools/febe/inputs/scripts/rtl_list_2stage_ctech_sanity_checker.pl
        
                },
   'RUN_MODE' => {
     -domain => "cheetah",
     #-setup_nonhdk => '/p/hdk/bin/cth_eps -groups tbh,soc,n7,mp_tech_n7 -scope hpg,thb,A,cth1.1',
     #-setup_nonhdk => ' cd $WARD;/p/hdk/bin/cth_eps -groups tbh,soc,n7,n7blr,mlpss -scope hpg,thb,A,2019.06,n7_tsmc_snps_h240_M13',
	 #-setup_nonhdk => '/p/hdk/bin/cth_eps  -groups n7,mp_tech_n7  -scope pcth.MTPLPA0P00',  # Use the recommended cheetah model 
	 #-additional_passthru_vars => [
	 #    'TAGS_PM',
	 #     ],
     },
#     'hip_list' => {
#        # Cheetah Modifications
#        -no_setproj        => 1,
#        -no_setup          => 1,
#        -gen_hip_list_args => '--strict --no-mw --no-ndm --no-stm',  #optional to ignore non-available views
#      },
	  sgdft => {
                     setup => {
                               },
                    drc =>    {
                             },
                    package => {
                              "-args" => "-cheetah_scan_config",
                                },
                },

 'gen_collateral' => {         
    # Cheetah Modifications          
     -no_setproj          => 1,   #default thru TSA        
     -no_setup            => 1,     #default thru TSA      
     -extra_commands_pre  => " ",   #Make the switch empty  if you use VCS-based 2stageFL
     -extra_commands_post_populate  => [ ],  #optional
     -extra_commands_post  => [], #optional
	 -extra_commands_pre  => ['setenv ONECFG_USERID $USER',],
     -configulate_command => "", #optional
     }, 

#'power_artist' => {
#    #TFM required 19.51.01 pacific and PowerArtist 2019.R2.4 version 
#    #Design required to bring fsdb and what tests need to run
#    -fsdbs => '$MODEL_ROOT/regression/mdf_syn/mdf/doa_phy.list/mdf_tap2cri_test_mdfo/novas_000.fsdb.gz:2795000ps:9000000ps',
#    -test => 'idle_power',
#    -pa_args => '-project soc_t7nm',  # Use relevant pcfg file to consume 2stageFL only
#     # For multiple tests at the same time  Use the following switches
#     #-fsdbs => 
#'$MODEL_ROOT/tools/power/async_active_idle/verilog_000.fsdb.gz:12845000ps:13325000ps,$MODEL_ROOT/tools/power/sync_active_idle/verilog_000.fsdb.gz:1925000ps:2405000ps',
#     #    -test => "async_active_idle,sync_active_idle",
#     },
     },


# please move all finalized/<unit>_final_cfg data to this hash
  # (except -lib_variant & -stdlib_type as these are meant to be CUST specific information)
  tsa_finalized => {
     OTHER => {
           "CTECH" => {
                 -path => '',
                 -replace => [@replace_files,],                     
           },
           "COMMON_CFG" => {
                 -add_ctech_files => [],
                 -rm_ctech_files => ["\/ctech_lib_.*\.*"],
           },
     },

   },



);
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);
#my @add_replace_ctech_files = (
#  glob("/p/hdk/cad/ctech/n7/c4v19ww40d_hdk162_v1.0.6_pre.2_mtp_sip_sbx/source/h240/lvt8/*ctech_lib*.sv"),
#  glob("/p/hdk/cad/ctech/n7/ctech_exp_c4v19ww43b_hdk161_mtp_sip_sbx/source/n7/h240/lvt8/*ctech_lib*.sv"),
#);

#my @replace_files;
#foreach my $file (@add_replace_ctech_files) {
#my @source = split(/source/,$file);
#     my @function = split(/ctech_lib_/,$source[1]);
#     my $replace = {
#            match => "source/v/ctech_lib_$function[1]",
#            replace => "source$function[0]ctech_lib_$function[1]",
#     };
#    push(@replace_files,$replace);
#}

$ToolConfig_tools{isaf}{VERSION} = "2.4.9.2";

1;
