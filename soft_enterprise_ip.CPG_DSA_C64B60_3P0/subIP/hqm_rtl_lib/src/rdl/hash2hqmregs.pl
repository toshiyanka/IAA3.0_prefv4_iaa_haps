#!/usr/bin/perl -w
use Data::Dumper;
use Switch;
#Author: Murali Arulambalam
#Comments: For v2 the XML structures are different from V1.  The code has been re-adjusted from v1 to account for this.  Do not use this for V1.

## This script is required by gen_hqm_regs to generate the Hash of cfg targets used in FPGAs
$DEBUG = 0;
$DEBUG1 = 0;

$hqm = {};
for $filename (
		  "hqm_csr_bar_regs_hash.pl",
		  "hqm_func_pf_bar_regs_hash.pl",
                  "hqm_pf_cfg_regs_hash.pl",
                 ) { 
  my $w;
  open(my $fh, '<', $filename) or die "cannot open file $filename";
   {
    local $/;
    $w = <$fh>;
   }
  close($fh);

  $w =~ s{\A\$VAR\d+\s*=\s*}{};
  my $q = eval $w;


########################################################################
#The following gets the perl hash structure for HQM Register Space
########################################################################
 my $base = 0x0;

 $max = 1;

 if (defined @{ $q->{addrmap} } ) {
   $max = @{ $q->{addrmap} };
 }
 for ($am_idx=0; $am_idx<$max; $am_idx++) {
   $s = $q->{addrmap}[$am_idx];
   $maxidx = 1;
   if (defined @{ $s->{addrmap} } ) {
     $maxidx = @{ $s->{addrmap} }; 
   }
   #determine the base register for the regfile
   $base = eval($q->{addrmap}[$am_idx]{addr});
   $base = 0 unless defined $base;

   for ($idx=0; $idx<$maxidx; $idx++) {
    if ($maxidx > 1) { 
      $p = $s->{addrmap}[$idx]; 
    } else { 
      $p = $s; 
    }
    if ($DEBUG1) {
       printf "addr_map = %50s desc = %s addr = %s base = 0x%08x\n", $s->{addrmap}[$idx]{name}[0], $q->{addrmap}[$am_idx]{description}[0], $q->{addrmap}[$am_idx]{addr}, $base;
    }

    @t_am_keys = keys %{ $p };                       # Addr Map Keys : looking for regfile, reg
    @am_keys = ();
    @regfile_keys = ();

    foreach my $t_key (@t_am_keys) {
       if ($t_key =~ /reg/) {
  	push (@am_keys, $t_key);
       }
    }
 
    if ($DEBUG) {
      print "Addrmap Keys: @am_keys \n";
    }

    my $grp_num = 0;
    my $grp_incr = 0;
    my $grp_addr = 0;
    my $short_key = "";

    foreach my $t_key (@am_keys) {
     if ($t_key =~ /regfile/) {
       @regfile_keys = keys %{ $p->{regfile} }; 
     } else {
       @regfile_keys = ('NOREGFILE'); 
     }

     if ($DEBUG) {
      print "Index = $am_idx,$idx: Regfile Keys: @regfile_keys \n";
     }
     # go through each of the registers within the core regfiles
     foreach my $key (@regfile_keys) {
      if ($key =~ /NOREGFILE/) {
        $r = $p->{reg};
        $grp_num = 1;
        $grp_incr = 0x0;
        $grp_addr = 0x0;
        #$short_key = change_name($key, $filename);
        $short_key = change_name($s->{addrmap}[$idx]{name}[0], $filename);
      } else {
        $r = $p->{regfile}{$key}{reg};
        $grp_num = $p->{regfile}{$key}{num};
        $grp_incr = $p->{regfile}{$key}{incr};
        $grp_addr = $p->{regfile}{$key}{addr};
        #$short_key = change_name($key, $filename);
        $short_key = change_name($s->{addrmap}[$idx]{name}[0], $filename);
      }
      @regkeys = keys %{ $r };

      foreach my $regkey (@regkeys) {
        #calculate the real address : address found for register + base of the group + base of regfile
        $offset=eval($r->{$regkey}{addr}) + eval($grp_addr) + $base;

        $r->{$regkey}{addr} = sprintf("0x%08x", $offset);
        $r->{$regkey}{regfilename} = sprintf("%s", $short_key);
        # $new_key="$r->{$regkey}{regfilename}.$regkey";
	# make the entire entry lower case
        $new_key=lc("$r->{$regkey}{regfilename}.$regkey");

        # Generate a new hash with selected entries
        $hqm->{$new_key}{addr} = $r->{$regkey}{addr};
        $hqm->{$new_key}{reg_incr} = $r->{$regkey}{incr};
        $hqm->{$new_key}{desciption} = $r->{$regkey}{description};
        $hqm->{$new_key}{grp_num} = $grp_num;
        $hqm->{$new_key}{reg_num} = $r->{$regkey}{num};
        $hqm->{$new_key}{grp_incr} = $grp_incr;
        $hqm->{$new_key}{wo_access} = 0;
        $hqm->{$new_key}{sec_grp} = " ";
	$num_props = scalar @{$r->{$regkey}{property}};
        for ($j=0; $j<$num_props; $j++) {
          $prop_name = $r->{$regkey}{property}[$j]{name};
          if ($prop_name =~ "donttest") {
               $hqm->{$new_key}{donttest} = $r->{$regkey}{property}[$j]{value};
	       last;
          }
        }
        for ($j=0; $j<$num_props; $j++) {
          $prop_name = $r->{$regkey}{property}[$j]{name};
          if ($prop_name eq "Security_PolicyGroup") {
	     if ($hqm->{$new_key}{sec_grp} eq " " && $r->{$regkey}{property}[$j]{value} =~ /_/) {
               $hqm->{$new_key}{sec_grp} = $r->{$regkey}{property}[$j]{value};
	       last;
             }
          }
        }
        for ($j=0; $j<$num_props; $j++) {
          $prop_name = $r->{$regkey}{property}[$j]{name};
          if ($prop_name eq "HqmClassification") {
               $val =  $r->{$regkey}{property}[$j]{value};
               if ( $val eq "") { $val='0' ;}
               $hqm->{$new_key}{HqmClassification} = $val ;
               last;
          }
        }

        for ($j=0; $j<$num_props; $j++) {
          $prop_name = $r->{$regkey}{property}[$j]{name};
          if ($prop_name eq "HqmIsFeatureReg") {
               $val =  $r->{$regkey}{property}[$j]{value};
               if ( $val eq "") { $val='0' ;}
               $hqm->{$new_key}{HqmIsFeatureReg} = $val ;
               last;
          }
        }

        for ($j=0; $j<$num_props; $j++) {
          $prop_name = $r->{$regkey}{property}[$j]{name};
          if ($prop_name eq "IntelRsvd") {
               $val =  $r->{$regkey}{property}[$j]{value};
               if ( $val eq "") { $val='0' ;}
               $hqm->{$new_key}{IntelRsvd} = $val ;
               last;
          }
        }



        $num = scalar @{$r->{$regkey}{field}};

	if ($DEBUG) {
          printf "0x%08x %50s	$new_key \n", eval($hqm->{$new_key}{addr}), $regkey;
        }

        # Go through the full array
        for ($i=0; $i<$num; $i++) {
	  my $fieldkey = lc($r->{$regkey}{field}[$i]{fieldname});
	  my $msb = $r->{$regkey}{field}[$i]{msb}[0];
	  my $lsb = $r->{$regkey}{field}[$i]{lsb}[0];
          $hqm->{$new_key}{field}{$fieldkey}{msb} = $msb;
          $hqm->{$new_key}{field}{$fieldkey}{lsb} = $lsb;
#uncomment for field descirption in hash	        my $description = $r->{$regkey}{field}[$i]{description}[0];
#uncomment for field descirption in hash               $hqm->{$new_key}{field}{$fieldkey}{description} = $description;
	  $num_props = scalar @{$r->{$regkey}{field}[$i]{property}};
          for ($j=0; $j<$num_props; $j++) {
            $prop_name = $r->{$regkey}{field}[$i]{property}[$j]{name};
            if ($prop_name =~ "reset") {
               $hqm->{$new_key}{field}{$fieldkey}{default} = $r->{$regkey}{field}[$i]{property}[$j]{value};
            }
            if ($prop_name eq "AccessType") {
             $hqm->{$new_key}{field}{$fieldkey}{acc_type} = $r->{$regkey}{field}[$i]{property}[$j]{value};
	     if ($r->{$regkey}{field}[$i]{property}[$j]{value} eq "WO") {
               $hqm->{$new_key}{wo_access} = 1;
	     } 
            }


          }
        }
      }

    }
   } 
  }
 }
}

#foreach my $regkey (sort { eval($hqm->{$a}{addr}) <=> eval($hqm->{$b}{addr}) } keys %{ $hqm }) {
#foreach my $regkey (keys %{ $hqm }) {
#   $offset=eval(($hqm->{$regkey}{addr}));
#   $text = sprintf("%-80s \t 0x%0x \t %04d \n", lc($regkey), $offset, $hqm->{$regkey}{grp_num});
#   print $text;
#}
print Dumper($hqm);

sub change_name {
  my ($name, $filename) = @_;
  if ($filename =~ /pf_bar/) { $name = "hqm_system_func"; }
  if ($filename =~ /pf_cfg/) { $name = "hqm_pf_cfg_i"; return $name; }
  switch (lc($name)) {
     case /hqm_credit_hist_pipe/ { return 'hqm_credit_hist_pipe' }
     case /hqm_dqed_pipe/ { return 'hqm_dqed_pipe' }
     case /hqm_direct_pipe/ { return 'hqm_direct_pipe' }
     case /hqm_dir_pipe/ { return 'hqm_direct_pipe' }
     case /hqm_qed_pipe/ { return 'hqm_qed_pipe' }
     case /hqm_nalb_pipe/ { return 'hqm_nalb_pipe' }
     case /hqm_atomic_pipe/ { return 'hqm_atomic_pipe' }
     case /hqm_atm_pipe/ { return 'hqm_atomic_pipe' }
     case /hqm_qed_pipe/ { return 'hqm_qed_pipe' }
     case /hqm_aqed_pipe/ { return 'hqm_aqed_pipe' }
     case /hqm_reorder_pipe/ { return 'hqm_reorder_pipe' }
     case /hqm_list_sel_pipe/ { return 'hqm_list_sel_pipe' }
     case /hqm_config_master_bcast/ { return 'hqm_config_master_bcast' }
     case /hqm_config_master/ { return 'hqm_config_master' }
     case /hqm_pf_cfg/ { return 'hqm_pf_cfg_i' }
     case /alarm_pf_synd/ { return 'hqm_system_csr' }
     case /alarm_vf_synd/ { return 'hqm_system_csr' }
     case /hqm_system_func/ { return 'hqm_system_func' }
     case /hqm_system_vf_func/ { return 'hqm_system_vf_func' }
     case /hqm_system_vf/ { return 'hqm_system_vf' }
     case /hqm_system_csr/ { return 'hqm_system_csr' }
     case /hqm_system/ { return 'hqm_system_csr' }
     case /hqm_sif_csr/ { return 'hqm_sif_csr' }
     else             { return $name }
  }
}

