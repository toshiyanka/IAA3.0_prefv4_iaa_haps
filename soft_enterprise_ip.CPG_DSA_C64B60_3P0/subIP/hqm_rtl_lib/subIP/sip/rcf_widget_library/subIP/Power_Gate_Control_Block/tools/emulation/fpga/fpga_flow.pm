package fpga_flow;
use ef_lib;

use Data::Dump qw(dump);
use Data::Dumper;

$Data::Dumper::Terse = 1;
$Data::Dumper::Quotekeys  = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Purity = 1;
$Data::Dumper::Sortkeys = 1;


sub handle_libdir_opts {
   my $libdir_opts = shift;
   my $reconfig    = shift;
   my $libdir_list = ();
   my $libdir_command = "set_option -library_path {";
   my %libdir_defined;
   foreach my $libdir (@$libdir_opts) {
      if (defined($libdir_defined{$libdir})==1){
         ef_lib::printl("#DUPLICATE libdir $libdir. \n",$main::log);
      }else{
         $libdir_defined{$libdir} =1;
         $libdir_command.="$libdir;";
         push (@$libdir_list, $libdir);
      }
   }
   $libdir_command.="}";
#   if($libdir_command =~ /set_option -library_path {.+;}/) {
#      $libdir_list = $libdir_command;
#      ef_lib::printl ("NOTE: library path set\n\t$libdir_list\n",$main::log);
#   }
   return $libdir_list;
}

sub handle_incdir_opts {
   my $incdir_opts = shift;
   my $reconfig    = shift;  
#   my $incdir_command = "set_option -include_path {";
   my $incdir_list = ();
   my %incdir_defined;
   foreach my $incdir (@$incdir_opts) {
      if (defined($incdir_defined{$incdir})==1){
         ef_lib::printl("#DUPLICATE incdir $incdir. \n",$main::log);
      }else{
      
         $incdir_defined{$incdir} =1;
#         $incdir_command.="$incdir;";
         push (@$incdir_list, $incdir);
      }
   }
   return $incdir_list;
}
   
sub handle_vlog_opts_others($) {
   my $vlog_opts     = shift;
   my $vlog_opts_info ={};
   foreach my $opt (@$vlog_opts) {
      if ($opt =~ /^-sv$/) {
            #We need not explicitly handle this as the default option for Synplify is system verilog
            ef_lib::printl("handle_vlog_opts_others $opt set.\n",$$main::log);
#set_option -vlog_std v2001
      }elsif ($opt =~ /^-sverilog$/) {
            #We need not explicitly handle this as the default option for Synplify is system verilog
#set_option -vlog_std sysv
            ef_lib::printl("handle_vlog_opts_others $opt set.\n",$$main::log);
      }else{
            ef_lib::printl("handle_vlog_opts_others $opt not supported.\n",$main::log);
      }
   }

}

sub cleanup_vlog_opts_others($) {
   my $vlog_opts     = shift;
   my $vlog_opts_info ={};
   my %opts_set;        # Hash of previously set options
   my $opts_list = ();           # clean list of options.
   foreach my $opt (@$vlog_opts) {
         if (defined($opts_set{$opt})==1){
            ef_lib::printl("#DUPLICATE OPT $opt. \n",$main::log);
         }else{
            push(@$opts_list, "$opt");
            $opts_set{$opt} =1;
         }
   }
   return($opts_list);

}


sub cleanup_vlog_opts_define($) {
   my $vlog_opts     = shift;          # Define inputs
   my %hdl_define_defined;        # Hash of previously defined
   my $hdl_define_list;           # clean list of deifnes.
   foreach my $opt (@$vlog_opts) {
      $opt =~ s/^\+define\+(.*)?$/$1/;
      while (defined($opt)){
         my $tmp_opts;
         ($tmp_opts, $opt) = split('\+', $opt, 2);
         my $macro;
         my $value;
         ($macro, $value) = split ('=', $tmp_opts, 2);
         chomp $macro;
         if (defined($hdl_define_defined{$macro})==1){
            ef_lib::printl("#DUPLICATE DEFINE $macro. \n",$main::log);
         }else{
#            }
            if ((defined($value)!=1)|| ($value =~ /^\s*$/)) {
               push(@$hdl_define_list, "$macro");
            } else {
               chomp $value;
               $value =~ s/\"/\'/g; # replace double qoutes in the value with single qoutes.
               push(@$hdl_define_list, "$macro=$value");
            }
            $hdl_define_defined{$macro} =1;
         }
      }
   }

   return($hdl_define_list);
}

sub split_vlog_opts($) {
   my $vlog_opts     = shift;
   my $vlog_opts_info ={};
   my $define_list   = ();
   my $incdir_list   = ();
   my $other_vlog_opts_list    = ();
   my $libext_list   = ();
   my $opt_count=-1;
   foreach my $opt (@$vlog_opts) {
   $opt_count++;
      my $tmp_split;
      while (defined($opt)){
         my $tmp_opts;
         # Split $opt string into sepperate strings 
         ($tmp_opts, $opt) = split(' ', $opt, 2);
         if (defined($opt)==1){
            my $leading_char = substr($opt, 0, 1);
            while (($leading_char ne '-') & ($leading_char ne '+') & ($leading_char ne '')){
               my $add_opts;
               ($add_opts, $opt) = split(' ', $opt);
               $tmp_opts = $tmp_opts." ".$add_opts;
               if (defined($opt)==1){
                  $leading_char = substr($opt, 0, 1);
               }else{
                  $leading_char = '';
               }
            }
         }
         # Store opt into correct array
          if($tmp_opts =~ /^\+define\+(\w+)\s*(=)?\s*(.*)?$/) { #handling +define+<macro>
            push(@$define_list, $tmp_opts);
         } elsif($tmp_opts =~ /^\+libext\+.*$/) { #For handling the libext option
            push(@$libext_list, $tmp_opts);
         } elsif($tmp_opts =~ /^\+incdir\+.*$/) { #For handling the libext option
            push(@$incdir_list, $tmp_opts);
         } else {#if (($tmp_opts =~ /^-sv$/) | ($tmp_opts =~ /^-sverilog$/)) {
               #We need not explicitly handle this as the default option for Synplify is system verilog
               push(@$other_vlog_opts_list, $tmp_opts);
         }
      }
   }
   $vlog_opts_info->{'define'} = $define_list;
   $vlog_opts_info->{'libext'} = $libext_list;
   $vlog_opts_info->{'incdir'} = $incdir_list;
   $vlog_opts_info->{'other'}  = $other_vlog_opts_list;
   return($vlog_opts_info);
}

sub handle_vcom_opts {
   my $vcom_opts = shift;
   my $reconfig               = shift;  
   my $vcom_opts_info ={};
   foreach my $opt (@$vcom_opts) {
      #handles -sv
      if ($opt =~ /^-93$/) {
            #We need not explicitly handle this as the default option for Synplify is VHDL-93
            ef_lib::printl("- $opt set. Default VHDL standard is VHDL-93 in Synplify.\n",$main::log);
      } else {
         ef_lib::printl("Warning: $opt. Not honouring the option. Either not supported for Synthesis/ handling not added in the script\n",$main::log);
      }

   }
   return($vcom_opts_info);
}


sub Process_vlog_opts_define($$$){
      my $define_lst      = shift;
      my $reconfig        = shift;
      my $mod_define_lst  = shift;

      my $lib_vlog_opts_define_index= 0;                                         # Points to current vlog file in source list
      foreach my $define_name (@{$define_lst}) {
         my $skip_define_name = 0;                                       # Controll add current vfile for remove and replace commands.
         # if defined removefile section is defined in reconfig module 
         if (defined($reconfig->{'-remove'})==1){
            foreach (@{$reconfig->{'-remove'}}) {
               if (($define_name=~/$_/)==1){
                  $skip_define_name = 1;
                  $cmd_str = sprintf("#RECONFIG vlog_opts_define -remove matching %s : #%d %s\n", $_, $lib_vlog_opts_define_index, $define_name);
                  ef_lib::printl($cmd_str,$main::log);                # printf(PRJ "$cmd_str");
               }
            }

         }
         if ($skip_define_name == 0){
            $cmd_str = sprintf("define \"$define_name\"\n");
            ef_lib::printl($cmd_str,$main::log);        
            push(@{$mod_define_lst},$define_name); 
         }
         $lib_vlog_opts_define_index++;
      }

      foreach my $define_name (@{$reconfig->{'-add'}}) {
         push(@{$mod_define_lst},$define_name); 
      }
      $main::debug=$main::debug;
}


sub Process_files($$$$$){
      my $prj_lib_name           = shift;
      my $file_lst               = shift;
      my $reconfig               = shift;  
      my $mod_file_lst           = shift;


      my $cmd_str;
      my $reconfig_add_vlog_files_index= 0;                                # Points to current vlog -add file in reconfig list
      my $lib_vlog_files_index= 0; 
      foreach my $file_name (@{$file_lst}) {
         my $skip_current_vfile = 0;                                       # Controll add current vfile for remove and replace commands.
         # if defined add file section is defined in reconfig module 
         if ((defined($reconfig->{'-add'})==1)&&(scalar(@{$reconfig->{'-add'}})>0)){
            #add vlog file at vlog file index indicated by reconfig file.
            while ((defined($reconfig->{'-add'}->[$reconfig_add_vlog_files_index][0])==1)&&($reconfig->{'-add'}->[$reconfig_add_vlog_files_index][0]==$lib_vlog_files_index)) {       
               my @add_entry = @{$reconfig->{'-add'}}[$reconfig_add_vlog_files_index];
               $cmd_str = sprintf("#RECONFIG vlog_files -add #%d\nadd_file -verilog  -lib %s \"%s\"\n",  $add_entry[0][0], $prj_lib_name,  $add_entry[0][1]);
               push(@{$mod_file_lst},$add_entry[0][1]);
               ef_lib::printl($cmd_str,$main::log);                # print PRJ $cmd_str;
               $reconfig_add_vlog_files_index++;                               # Increment pointer to vlog_files add list after each match with vlog_files index
            }
         }
         # if defined removefile section is defined in reconfig module 
         if (defined($reconfig->{'-remove'}[0])==1){
            foreach (@{$reconfig->{'-remove'}[0]}) {
               if (($file_name=~/$_/)==1){
                  $skip_current_vfile = 1;
                  $cmd_str = sprintf("#RECONFIG vlog_files -remove matching %s : #%d %s\n", $_, $lib_vlog_files_index, $file_name);
                  ef_lib::printl($cmd_str,$main::log);                # printf(PRJ "$cmd_str");
               }
            }

         }
         # if defined replacefile section is defined in reconfig module 
         if (defined($reconfig->{'-replace'})==1){
            my $match_str;
            my $replace_str;
            foreach (@{$reconfig->{'-replace'}}) {
               $match_str = @{$_}[0];
               $replace_str = @{$_}[1];
               if (($file_name=~/$match_str/)==1){ 

                  $skip_current_vfile = 1;
                  $cmd_str = sprintf("#RECONFIG vlog_files -replace matching \"%s\" : #%d %s\n", $match_str, $lib_vlog_files_index, $file_name);
                  ef_lib::printl($cmd_str,$main::log);                # print PRJ $cmd_str;
                  $cmd_str = sprintf("add_file -verilog  -lib %s \"%s\"\n", $prj_lib_name,  $replace_str);
                  ef_lib::printl($cmd_str,$main::log);                # print PRJ $cmd_str;
                  push(@{$mod_file_lst},$replace_str); 
               }
            }
         }
         if ($skip_current_vfile == 0){
            $cmd_str = sprintf("add_file -verilog  -lib $prj_lib_name \"$file_name\"\n");
#            printf(STDOUT " $lib_vlog_files_index src : $cmd_str\n");
            ef_lib::printl($cmd_str,$main::log);                # print PRJ $cmd_str;
            push(@{$mod_file_lst},$file_name); 
         }
         $lib_vlog_files_index++;
      }
}


sub Process_vlog_opts_other($$$){
      my $other_lst               = shift;
      my $reconfig               = shift;  

      my $mod_other_lst           = shift;
      my $lib_vlog_opts_other_index= 0;                                         # Points to current vlog file in source list
      foreach my $other_name (@{$other_lst}) {
         my $skip_other_name = 0;                                       # Controll add current vfile for remove and replace commands.
         # if otherd removefile section is otherd in reconfig module 
         if (defined($reconfig->{'-remove'})==1){
            foreach (@{$reconfig->{'-remove'}}) {
               if (($other_name eq $_)==1){
                  $skip_other_name = 1;
                  $cmd_str = sprintf("#RECONFIG vlog_opts_other -remove matching %s : #%d %s\n", $_, $lib_vlog_opts_other_index, $other_name);
                  ef_lib::printl($cmd_str,$main::log);                # printf(PRJ "$cmd_str");
               }
            }

         }
         if ($skip_other_name == 0){
            $cmd_str = sprintf("#RECONFIG vlog_opts_other \"$other_name\"\n");
            ef_lib::printl($cmd_str,$main::log);        
            push(@{$mod_other_lst},$other_name); 
         }
         $lib_vlog_opts_other_index++;
      }

      foreach my $other_name (@{$reconfig->{'-add'}}) {
         $cmd_str = sprintf("#RECONFIG vlog_opts_other -add %s \n", $other_name);
         ef_lib::printl($cmd_str,$main::log);                # printf(PRJ "$cmd_str");
         push(@{$mod_other_lst},$other_name); 
      }
      $main::debug=$main::debug;
}


sub dump_hash($$$){
  my $var_name = shift;
  my $ref = shift;
  my $filename = shift;

   my $h;
   open($h, ">", $filename) or die "cannot open < $filename : $!";
   my $Str = Dumper($ref);
   my @Lines = split(/\n/, $Str);
   my $timestamp = localtime;
   $timestamp =~ s/\s/_/g;
   print $h  "# $timestamp\n";
   print $h  "\%$var_name = (\n";
   for(my $i=1; $i<$#Lines; $i++){ 
      print $h  "$Lines[$i]\n";
   }
   print $h  ");\n";
   close($h);

}


sub CreateSynplifyProjectsSrcFiles($$$){
   my $prj  = shift;
   my $project_info  = shift;
   my $prj_src       = shift;

   my $cmd_str;
   my $hierarchy = $project_info->{'-hierarchy'}; 
   push (@{$prj_src}, "#hierarchy $hierarchy \n");
   #Adding verilog files to the project

   push (@{$prj_src}, "#Adding Verilog files\n");
   my $vlog_files_arr            = $project_info->{'vlog_files'};
   foreach my $file_name (@{$vlog_files_arr}) {
      $cmd_str = sprintf("add_file -verilog  -lib $prj \"$file_name\"\n");
      push (@{$prj_src}, $cmd_str);
   }
   push (@{$prj_src}, "\n\n");

   push (@{$prj_src}, "#Adding Sverilog files\n");
   my $sverilog_files_arr            = $project_info->{'sverilog_files'};
   foreach my $file_name (@{$sverilog_files_arr}) {
      $cmd_str = sprintf("add_file -verilog -vlog_std sysv  -lib $prj \"$file_name\"\n");
      push (@{$prj_src}, $cmd_str);
   }
   push (@{$prj_src}, "\n\n");

   #Adding vhdl files to the project
   push (@{$prj_src}, "#Adding VHDL files\n");
   foreach my $file_name (@{$project_info->{'vhdl_files'}}) {
      push (@{$prj_src}, "add_file -vhdl  -lib $prj \"$file_name\"\n");
   }
}


sub WriteSynplifyImpl($$$){
   my $entity = shift;
   my $project_info = shift;
   my $impl_txt = shift;

   @{$impl_txt}= ();
   push (@{$impl_txt}, "#implementation: \"$entity"); push (@{$impl_txt}, "_rev\"\n");
   push (@{$impl_txt}, "impl -add $entity"); push (@{$impl_txt}, "_rev -type fpga\n");
   push (@{$impl_txt}, "\n");

   push (@{$impl_txt}, "source $ENV{'EMU_CFG_DIR'}/FPGA_flow/defaul_impl.tcl\n");
   push (@{$impl_txt}, "#set result format/file last\n");
   push (@{$impl_txt}, "project -result_file \"./$entity"); push (@{$impl_txt}, "_rev/$entity"); push (@{$impl_txt}, ".edf\"\n");
   push (@{$impl_txt}, "\n");
   push (@{$impl_txt}, "#design plan options\n");
   push (@{$impl_txt}, "impl -active \"$entity"); push (@{$impl_txt}, "_rev\"\n");
   push (@{$impl_txt}, "\n");
}

sub CreateSynplifyImplOptsPaths($$$){

   my $entity = shift;
   my $project_info = shift;
   my $impl_txt = shift;

   @{$impl_txt}= ();

   #Setting the vlog_opts to the project
   push (@{$impl_txt}, "#Setting the Verilog related options\n");
   #defines
   push (@{$impl_txt}, "#Defines\n");
   my $vlog_opts_define = $project_info->{'vlog_opts'}->{'vlog_opts_define'};
   if (defined($vlog_opts_define)==1) {
      $cmd_str = sprintf("set_option -hdl_define -set \"%s", pop(@{$vlog_opts_define}));
      while (scalar (@{$vlog_opts_define})>0){
         $cmd_str = sprintf("%s, %s", $cmd_str, pop(@{$vlog_opts_define}));
      }
      push (@{$impl_txt}, $cmd_str."\"\n");
   }
   push (@{$impl_txt}, "\n");

   #libext 
   my $libext = $project_info->{'vlog_opts'}->{'libext'};
   if (defined($libext)==1){
      push (@{$impl_txt}, "#libext\n");
      push (@{$impl_txt}, "$libext\n");
      push (@{$impl_txt}, "\n\n");
   }

   #Setting the vcom_opts to the project
   push (@{$impl_txt}, "#Setting the VHDL related options\n");
   push (@{$impl_txt}, "\n\n");


   #incdirs
   push (@{$impl_txt}, "#Include dirs\n");
#   my $incdir = $project_info->{'vlog_incdirs'};
   push (@{$impl_txt}, "set_option -include_path {");
   foreach my $incdir (@{$project_info->{'vlog_incdirs'}}){
      push (@{$impl_txt}, "$incdir;");
   }
   push (@{$impl_txt}, " }");
   push (@{$impl_txt}, "\n\n");

   #libdirs
   push (@{$impl_txt}, "#library dirs\n");
   push (@{$impl_txt}, "set_option -library_path { ");
   foreach my $libdir (@{$project_info->{'vlog_libdirs'}}){
      push (@{$impl_txt}, "$libdir;");
   }
   push (@{$impl_txt}, " }");
   push (@{$impl_txt}, "\n\n");

# the options v2001 and sysv are not independent.
# First determin requested options, later decide which to write to th eproject file.
   my $Set_v2k=0;
   my $Set_sysv=0;
   foreach my $opt (@{$project_info->{'vlog_opts'}->{'vlog_opts_other'}}){
      if ($opt eq '+v2k'){
         $Set_v2k=1;
      }elsif ($opt eq '-sverilog'){
         $Set_sysv=1;
      }else{
#         ef_lib::printl(sprintf("NOTE: Skipping vlog_opts_other %s\n",$opt) ,$main::log);
      }

   }
   if ($Set_sysv==1){
         push (@{$impl_txt}, "set_option -vlog_std sysv \n");
   }elsif ($Set_v2k==1){
         push (@{$impl_txt}, "set_option -vlog_std v2001 \n");
   }

}
sub CreateSynplifyLibMap($$$){

   my $entity = shift;
   my $project_info = shift;
   my $impl_txt = shift;

   @{$impl_txt}= ();

   push (@{$impl_txt}, "library $entity;\n");

   #Setting the vlog_opts to the project
   push (@{$impl_txt}, "#Setting the Verilog related options\n");
   #defines
   push (@{$impl_txt}, "#Defines\n");
   my $vlog_opts_define = $project_info->{'vlog_opts'}->{'vlog_opts_define'};
   if (defined($vlog_opts_define)==1) {
      $cmd_str = sprintf("set_option -hdl_define -set {%s", pop(@{$vlog_opts_define}));
      while (scalar (@{$vlog_opts_define})>0){
         $cmd_str = sprintf("%s %s", $cmd_str, pop(@{$vlog_opts_define}));
      }
      push (@{$impl_txt}, $cmd_str."}\n");
   }
   push (@{$impl_txt}, "\n");

   #libext 
   my $libext = $project_info->{'vlog_opts'}->{'libext'};
   if (defined($libext)==1){
      push (@{$impl_txt}, "#libext\n");
      push (@{$impl_txt}, "$libext\n");
      push (@{$impl_txt}, "\n\n");
   }

   #Setting the vcom_opts to the project
   push (@{$impl_txt}, "#Setting the VHDL related options\n");
   push (@{$impl_txt}, "\n\n");


   #incdirs
   push (@{$impl_txt}, "#Include dirs\n");
#   my $incdir = $project_info->{'vlog_incdirs'};
   push (@{$impl_txt}, "set_option -include_path {");
   foreach my $incdir (@{$project_info->{'vlog_incdirs'}}){
      push (@{$impl_txt}, "$incdir;");
   }
   push (@{$impl_txt}, " }");
   push (@{$impl_txt}, "\n\n");

#    #libdirs
#    push (@{$impl_txt}, "#library dirs\n");
#    push (@{$impl_txt}, "set_option -library_path { ");
#    foreach my $libdir (@{$project_info->{'vlog_libdirs'}}){
#       push (@{$impl_txt}, "$libdir;");
#    }
#    push (@{$impl_txt}, " }");
#    push (@{$impl_txt}, "\n\n");

# # the options v2001 and sysv are not independent.
# # First determin requested options, later decide which to write to th eproject file.
#    my $Set_v2k=0;
#    my $Set_sysv=0;
#    foreach my $opt (@{$project_info->{'vlog_opts'}->{'vlog_opts_other'}}){
#       if ($opt eq '+v2k'){
#          $Set_v2k=1;
#       }elsif ($opt eq '-sverilog'){
#          $Set_sysv=1;
#       }else{
# #         ef_lib::printl(sprintf("NOTE: Skipping vlog_opts_other %s\n",$opt) ,$main::log);
#       }
# 
#    }
#    if ($Set_sysv==1){
#          push (@{$impl_txt}, "set_option -vlog_std sysv \n");
#    }elsif ($Set_v2k==1){
#          push (@{$impl_txt}, "set_option -vlog_std v2001 \n");
#    }

   push (@{$impl_txt}, "endlibrary\n");
}
sub HandleLib($$$$$){
   my $reconfig_ref  = shift;
   my $entity        = shift;
   my $sub_proj_info = shift;
   my $project_info  = shift;
   my $all_projects_info = shift;

   my $reconfig_enable = 0;
   my $ignore_lib = 0;
   if ($main::reconfig_proto_enable){
      $main::reconfig_proto->{$entity} =  {'-ignore_lib' => 0};
   }
   if (defined($reconfig_ref->{$entity})==1){
     if ($reconfig_ref->{$entity}{'-ignore_lib'}==1){
         $ignore_lib = 1;
         $main::reconfig_enable = 0;
     }else{
         $main::reconfig_enable = 1;
      }
   }
   if ($ignore_lib ==0){
      $main::project_cnt++;   
      push(@main::dependecy, $entity);
      ef_lib::printl(sprintf("NOTE: HandleLib  Entity $entity Hierarchy level $main::deep Dependent on @main::dependecy\n"),$main::log);
      $main::deep++ ;
      #Finding the top-language
      my $top_lang = $sub_proj_info->{'-top_language'};
      if(!(($top_lang =~ /verilog/i) || ($top_lang =~ /vhdl/i))) {   #To ensure that top language is vhdl/verilog
         ef_lib::printl("WARNING: -top_language not specified for entity $entity. Skipping project creation for this entity\n",$main::log);
      }
      ef_lib::printl("NOTE: Top language $top_lang\n",$main::log);
      $project_info->{'top_language'} = $top_lang;


      $project_info->{'-BluePearlOpts'} = $reconfig_ref->{$entity}{'-BluePearlOpts'};



      ef_lib::printl("NOTE: handling vlog_opts\n",$main::log);
      #To check the vlog_opts swithes
#      # Split opt lines into single entry field and store on one of the vlog opts arrays stored in $vlog_opts_info  hash
      my $vlog_opts_info ={};
      my $reconfig_add_vlog_opts_info ={};
      my $reconfig_remove_vlog_opts_info ={};
      $vlog_opts_info = fpga_flow::split_vlog_opts($sub_proj_info->{'-vlog_opts'});
      $reconfig_add_vlog_opts_info = fpga_flow::split_vlog_opts($reconfig_ref->{$entity}{'-vlog_opts'}{'-add'});
      $reconfig_remove_vlog_opts_info = fpga_flow::split_vlog_opts($reconfig_ref->{$entity}{'-vlog_opts'}{'-remove'});


      # Process DEFINE's
      my $vlog_opts_define =();
      $vlog_opts_define = fpga_flow::cleanup_vlog_opts_define($vlog_opts_info->{'define'});    # Remove duplicates from define's
      $reconfig_ref->{$entity}{'-vlog_opts'}{'define'}{'-add'} = fpga_flow::cleanup_vlog_opts_define($reconfig_add_vlog_opts_info->{'define'});     # Remove duplicates from define's
      $reconfig_ref->{$entity}{'-vlog_opts'}{'define'}{'-remove'} = fpga_flow::cleanup_vlog_opts_define($reconfig_remove_vlog_opts_info->{'define'});     # Remove duplicates from define's

      my $mod_vlog_opts_define =[];
      Process_vlog_opts_define($vlog_opts_define, $reconfig_ref->{$entity}{'-vlog_opts'}->{'define'}, $mod_vlog_opts_define); 
      $project_info->{'vlog_opts'}->{'vlog_opts_define'} =  $mod_vlog_opts_define;


      #To check the vcom_opts swithes
      my $vcom_opts = $sub_proj_info->{'-vcom_opts'};
      ef_lib::printl("NOTE: handling vcom_opts\n",$main::log);
      my $vcom_opts_info = fpga_flow::handle_vcom_opts($vcom_opts, $reconfig_ref->{$entity}{'-vcom_opts'});
      ef_lib::printl("-----------------\n",$main::log);
      $project_info->{'vcom_opts'}= $vcom_opts_info;

      my $top_modules;
      if (defined($reconfig_ref->{$entity}{'-top'})==1){
         $project_info->{'-top'}  = $reconfig_ref->{$entity}{'-top'};
      }else{
         $project_info->{'-top'} = ();
      }

       #Getting the list of RTL files 
      my $sverilog_files;
      my $sverilog_files_cnt;
      if (defined($sub_proj_info->{'-sverilog_files'})==1){
         $sverilog_files = $sub_proj_info->{'-sverilog_files'};
         $sverilog_files_cnt = @$sverilog_files;
      }else{
         $sverilog_files = ();
         $sverilog_files_cnt = 0;
      }
      my $vhdl_files;
      my $vhdl_files_cnt;
      if (defined($sub_proj_info->{'-vhdl_files'})==1){
         $vhdl_files = $sub_proj_info->{'-vhdl_files'};
         $vhdl_files_cnt = @$vhdl_files;
      }else{
         $vhdl_files = ();
         $vhdl_files_cnt = 0;
      }
      my $vlog_lib_dirs;
      my $vlog_lib_dirs_cnt;
      if (defined($sub_proj_info->{'-vlog_lib_dirs'})==1){
         $vlog_lib_dirs = $sub_proj_info->{'-vlog_lib_dirs'};
         $vlog_lib_dirs_cnt = @$vlog_lib_dirs;
      }else{
         $vlog_lib_dirs = ();
         $vlog_lib_dirs_cnt = 0;
      }
      my $vlog_files;
      my $vlog_files_cnt;
      if (defined($sub_proj_info->{'-vlog_files'})==1){
         $vlog_files = $sub_proj_info->{'-vlog_files'};
         $vlog_files_cnt = @$vlog_files;
      }else{
         $vlog_files = ();
         $vlog_files_cnt = 0;
      }
      my $vlog_incdirs;
      my $vlog_incdirs_cnt;
      if (defined($sub_proj_info->{'-vlog_incdirs'})==1){
         $vlog_incdirs = $sub_proj_info->{'-vlog_incdirs'};
         $vlog_incdirs_cnt = @$vlog_incdirs;
      }else{
         $vlog_incdirs = ();
         $vlog_incdirs_cnt = 0;
      }
      
      if (($vlog_files_cnt+$sverilog_files_cnt+$vhdl_files_cnt)>0){
         $project_info->{'-non_empty_project'} = 1;
      }else{
         $main::project_cnt--;   
      }
#      printf(STDOUT "checks to ensure that top_language switch is valid one in $entity $main::deep\n");
      #checks to ensure that top_language switch is valid one
      if(!defined($top_lang )){
         ef_lib::printl("WARNING: Strange!! top_language not set\n",$main::log);
      }
      if(($top_lang =~ /[v|V]erilog/) && ($vlog_files_cnt == 0)) {
         ef_lib::printl("WARNING: Strange!! no filelist under -vlog_files but top_language set to verilog. Skipping project creation for this entity\n",$main::log);
      }
      if(($top_lang =~ /s[v|V]erilog/) && ($sverilog_files_cnt == 0)) {
         ef_lib::printl("WARNING: Strange!! no filelist under -sverilog_files but top_language set to sverilog. Skipping project creation for this entity\n",$main::log);
      }
      if(($top_lang =~ /vhdl/) && ($vhdl_files_cnt == 0)) {
         ef_lib::printl("WARNING: Strange!! no filelist under -vhdl_files but top_language set to vhdl. Skipping project creation for this entity\n",$main::log);
      }
      ef_lib::printl("\nNOTE: Vlog file list\n",$main::log);
      map {ef_lib::printl("$_\n",$main::log);} @$vlog_files;
      ef_lib::printl("\n------------------\n",$main::log);
      my $mod_vlog_files = [];
      &Process_files($entity, $vlog_files, $reconfig_ref->{$entity}{'-vlog_files'}, $mod_vlog_files);
      
      ef_lib::printl("\nNOTE: Svlog file list\n",$main::log);
      map {ef_lib::printl("$_\n",$main::log);} @$sverilog_files;
      ef_lib::printl("\n------------------\n",$main::log);
      my $mod_sverilog_files = [];
      &Process_files($entity, $sverilog_files, $reconfig_ref->{$entity}{'-sverilog_files'}, $mod_sverilog_files);
      
      ef_lib::printl("\nNOTE: VHDL file list\n",$main::log);
      map {ef_lib::printl("$_\n",$main::log);} @$vhdl_files;
      ef_lib::printl("\n------------------\n",$main::log);
      my $mod_vhdl_files = [];
      &Process_files($entity, $vhdl_files,  $reconfig_ref->{$entity}{'-vhdl_files'}, $mod_vhdl_files);
      ef_lib::printl("\n------------------\n",$main::log);

      ef_lib::printl("\nNOTE: verilog lib dirs list\n",$main::log);
      map {ef_lib::printl("$_\n",$main::log);} @$vlog_lib_dirs;
      ef_lib::printl("\n------------------\n",$main::log);
      my $mod_vlog_lib_dirs = [];
      &Process_files($entity, $vlog_lib_dirs,  $reconfig_ref->{$entity}{'-vlog_lib_dirs'}, $mod_vlog_lib_dirs);
      ef_lib::printl("\n------------------\n",$main::log);
      ef_lib::printl("NOTE: handling vlog_lib_dirs\n",$main::log);
      $vlog_lib_dirs = &fpga_flow::handle_libdir_opts($mod_vlog_lib_dirs, $reconfig_ref->{$entity}{'-vlog_lib_dirs'});


      ef_lib::printl("NOTE: handling vlog_opts, non define and non inc path\n",$main::log);
      # Process OTHER options
      my $vlog_opts_other =();
      $vlog_opts_other = fpga_flow::cleanup_vlog_opts_others($vlog_opts_info->{'other'});    # Remove duplicates from others
      if ($project_info->{'top_language'} eq  'SystemVerilog'){
         push(@{$vlog_opts_other}, '-sverilog')
      }
      $reconfig_ref->{$entity}{'-vlog_opts'}{'other'}{'-add'} = fpga_flow::cleanup_vlog_opts_others($reconfig_add_vlog_opts_info->{'other'});     # Remove duplicates from add others
      $reconfig_ref->{$entity}{'-vlog_opts'}{'other'}{'-remove'} = fpga_flow::cleanup_vlog_opts_others($reconfig_remove_vlog_opts_info->{'other'});     # Remove duplicates from remove others

      my $mod_vlog_opts_other =[];
      fpga_flow::Process_vlog_opts_other($vlog_opts_other, $reconfig_ref->{$entity}{'-vlog_opts'}->{'other'}, $mod_vlog_opts_other); 
      $project_info->{'vlog_opts'}->{'vlog_opts_other'} = fpga_flow::cleanup_vlog_opts_others($mod_vlog_opts_other);     # Remove duplicates from remove others


      ef_lib::printl("\nNOTE: handling verilog incdirs list\n",$main::log);
      # Add "+incdir+path" vlog_opts paths to the list of vlog incllude paths.
      foreach my $inc_plus_arg (@{$vlog_opts_info->{'incdir'}}) { 
         $inc_plus_arg =~ s/\+incdir\+(.*)/$1/; 
         push ( @{$sub_proj_info->{'-vlog_incdirs'}}, $inc_plus_arg);
      }

      map {ef_lib::printl("$_\n",$main::log);} @$vlog_incdirs;
      ef_lib::printl("\n------------------\n",$main::log);
      my $mod_vlog_incdirs = [];
      &Process_files($entity, $vlog_incdirs,  $reconfig_ref->{$entity}{'-vlog_incdirs'}, $mod_vlog_incdirs);
      ef_lib::printl("\n------------------\n",$main::log);
      ef_lib::printl("NOTE: handling vlog_incdirs\n",$main::log);
      $vlog_incdirs = &fpga_flow::handle_incdir_opts($mod_vlog_incdirs, $reconfig_ref->{$entity}{'-vlog_incdirs'});

      $project_info->{'vlog_files'} = $mod_vlog_files;
      $project_info->{'sverilog_files'} = $mod_sverilog_files;
      $project_info->{'vhdl_files'} = $mod_vhdl_files;
      $project_info->{'vlog_lib_dirs'} = $mod_vlog_lib_dirs;
      $project_info->{'vlog_incdirs'} = $vlog_incdirs;
      $project_info->{'vlog_lib_dirs'} = $vlog_lib_dirs;

     if  ($sub_proj_info->{'-has_sublibs'}== 1){
         fpga_flow::Handle_SubLibs($reconfig_ref, $entity, $sub_proj_info, $all_projects_info);
      }
      $main::deep-- ;
      my $dependecy_str= "";
      for (my $i=0; $i<=$#dependecy; $i++){
         $dependecy_str = $dependecy_str.".".$dependecy[$i];
      }
      $project_info->{'-hierarchy'}= $dependecy_str;
      pop(@main::dependecy);
   }else{
      ef_lib::printl(sprintf("NOTE: HandleLib Ignoring Entity $entity Hierarchy level $main::deep Dependent on @main::dependecy\n"),$main::log);
   }
}

sub Handle_SubLibs($$$$){
   my $reconfig_ref        = shift;
   my $entity              = shift;
   my $sub_proj_info       = shift;
   my $all_projects_info   = shift;

   my @sub_entities_order = ();
   @sub_entities_order = keys %{$sub_proj_info->{'-sub_lib_hash'}};
   ef_lib::printl("NOTE: $entity sub libs : @sub_entities_order\n",$main::log);
   if (@sub_entities_order<1) {
      ef_lib::mydie("ERROR: Could not find -sub_lib_hash  in the metadata file $metadata_file in lib $entity. Please check the file.\n", $main::log);
   }

   foreach my $sub_entity (@sub_entities_order) {
      if (exists $sub_proj_info->{'-sub_lib_hash'}{$sub_entity}) {   
         if (exists $all_projects_info->{$sub_entity}) {   
            ef_lib::printl("NOTE: Skipping previously processed lib  $sub_entity\n",$main::log);
         }else{
            my $sub_project_info = {};
            $all_projects_info->{$sub_entity} = $sub_project_info;
            ef_lib::printl("NOTE: Analyzing entity $sub_entity\n",$main::log);
            &HandleLib($reconfig_ref, $sub_entity, $sub_proj_info->{'-sub_lib_hash'}{$sub_entity}, $sub_project_info, $all_projects_info);
            ef_lib::printl("NOTE: End analyzing entity $sub_entity\n",$main::log);
         }
      } else {
         ef_lib::mydie("ERROR: Counld not find project information for entity $entity in the metadata file\n", $main::log);
      }

   }
}

sub ProcessMetadata($$$$$){
   my $top_module    = shift;
   my $metadata_file = shift;
   my $all_projects_info   = shift;
   my $reconfig = shift;
   my $dump = shift;
   #To check for the entities present in the meta-data file from the -entities_order element
   #uses this list to find out the different sub-projects to be created
   my $entities_order = ();

   if (exists $dump->{'-entities_order'}) {
      $entities_order =  $dump->{'-entities_order'};
   } else {
      ef_lib::mydie("ERROR: Could not find -entities_order key in the metadata file $metadata_file. Please check the file.\n", $main::log);
   }

   if ($main::start_from_top){
      my $project_info = {};
      $all_projects_info->{$top_module} = $project_info;
      ef_lib::printl("NOTE: Analyzing entity $top_module\n",$main::log);
      my $sub_proj_info = {};
      $sub_proj_info = $dump->{$top_module};
      &fpga_flow::HandleLib($reconfig, $top_module, $sub_proj_info, $project_info, $all_projects_info);
      my $dependent_libs =  $dump->{$top_module}{'-dependent_libs'};
      foreach my $entity (@$dependent_libs) {
         if (exists $dump->{$entity}) {   
            my $project_info = {};
            $all_projects_info->{$entity} = $project_info;
            ef_lib::printl("NOTE: Analyzing entity $entity\n",$main::log);
            my $sub_proj_info = {};
              $sub_proj_info = $dump->{$entity};
            &fpga_flow::HandleLib($reconfig, $entity, $sub_proj_info, $project_info, $all_projects_info);

         } else {
            ef_lib::mydie("ERROR: Counld not find project information for entity $entity in the metadata file\n", $main::log);
         }

      }
   }else{
       foreach my $entity (@$entities_order) {
          if (exists $dump->{$entity}) {   
             my $project_info = {};
             $all_projects_info->{$entity} = $project_info;
             ef_lib::printl("NOTE: Analyzing entity $entity\n",$main::log);
             my $sub_proj_info = {};
               $sub_proj_info = $dump->{$entity};
               &fpga_flow::HandleLib($reconfig, $entity, $sub_proj_info, $project_info, $all_projects_info);

          } else {
             ef_lib::mydie("ERROR: Coudn't not find project information for entity $entity in the metadata file\n", $main::log);
          }

       }
   }

}

1;
