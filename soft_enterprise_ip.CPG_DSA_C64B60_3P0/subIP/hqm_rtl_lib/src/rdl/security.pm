package security;



  %agent_encoding = (
    "HOSTIA_POSTBOOT_SAI" => 0, 
    "HOSTIA_UCODE_SAI" => 1, 
    "HOSTIA_SMM_SAI" => 2, 
    "HOSTIA_SUNPASS_SAI" => 3, 
    "HOSTIA_BOOT_SAI" => 4, 
    "SAI_Reserved_5" => 5, 
    "SAI_Reserved_6" => 6,
    "SAI_Reserved_7" => 7,
    "GT_SAI" => 8, 
    "PM_PCS_SAI" => 9, 
    "HW_CPU_SAI" => 10, 
    "MEM_CPL_SAI" => 11, 
    "VTD_SAI" => 12, 
    "PM_DIE_TO_DIE_SAI" => 13, 
    "OOB_MSM_UNTRUSTED_SAI" => 14, 
    "HOSTCP_PMA_SAI" => 15, 
    "CSE_INTEL_SAI" => 16, 
    "CSE_OEM_SAI" => 17, 
    "FUSE_CTRL_SAI" => 18, 
    "FUSE_PULLER_SAI" => 19, 
    "PECI_MSM_SAI" => 20, 
    "PM_IOSS_SAI" => 21, 
    "CSE_DNX_SAI" => 22, 
    "FXR_INTERNAL_SAI" => 23, 
    "DFX_INTEL_MANUFACTURING_SAI" => 24, 
    "DFX_UNTRUSTED_SAI" => 25, 
    "SAI_Reserved_26" => 26, 
    "IRC_SAI" => 27, 
    "NPK_SAI" => 28, 
    "DISPLAY2_SAI" => 29, 
    "DISPLAY3_SAI" => 30, 
    "HW_PCH_SAI" => 31, 
    "SAI_Reserved_32" => 32, 
    "SAI_Reserved_33" => 33, 
    "SAI_Reserved_34" => 34, 
    "GT_PMA_SAI" => 35, 
    "HSP_SAI" => 36, 
    "SAI_Reserved_37" => 37, 
    "SAI_Reserved_38" => 38, 
    "SAI_Reserved_39" => 39, 
    "UNCORE_PMA_SAI" => 40, 
    "RC_MORPHED_SAI" => 41, 
    "DFX_INTEL_PRODUCTION_SAI" => 42,
    "DFX_THIRDPARTY_SAI" => 43,
    "DISPLAY_SAI" => 44, 
    "SAI_Reserved_45" => 45, 
    "SAI_Reserved_46" => 46, 
    "DISPLAY_KVM_SAI" => 47,
    "GT2_SAI" => 48, 
    "SAI_Reserved_49" => 49, 
    "DEVICE_UNTRUSTED_IAL_SAI" => 50, 
    "SAI_Reserved_51" => 51, 
    "CORE_EVENT_PROXY_SAI" => 52, 
    "DEVICE_ABORT_SAI" => 53, 
    "RCIOMMU_BYPASS_SAI" => 54, 
    "SAI_Reserved_55" => 55,
    "SAI_Reserved_56" => 56, 
    "IE_CSE_SAI" => 57, 
    "SAI_Reserved_58" => 58, 
    "SAI_Reserved_59" => 59, 
    "CPM_SAI" => 60, 
    "OOB_MSM_SAI" => 61, 
    "XGBE_SAI" => 62, 
    "DEVICE_UNTRUSTED_SAI" => 63,
  );
sub GetUnsupportedInfo() {
  # TODO should display, DNX SAIs be included as unsupported SAIs?
    %security = (
    'UNSUPPORTED_AGENTS' => '"SAI_Reserved_5 | SAI_Reserved_6 | SAI_Reserved_7 | PECI_MSM_SAI | SAI_Reserved_26 | SAI_Reserved_32 | SAI_Reserved_33 | SAI_Reserved_34 | SAI_Reserved_37 | SAI_Reserved_38 | SAI_Reserved_39 | SAI_Reserved_45 | SAI_Reserved_46 | SAI_Reserved_49 | SAI_Reserved_51 | SAI_Reserved_55 | SAI_Reserved_56 | IE_CSE_SAI | SAI_Reserved_58 | SAI_Reserved_59 "',
    );
    return (%security);
}
sub GetSecurityInfo() {
  
  %security = (

    'HQM_OS_W' => '"HQM_OS_W"',
    'HQM_OS_W_CP_AGENTS' => '"HOSTIA_BOOT_SAI | HOSTIA_SUNPASS_SAI | PM_PCS_SAI | DFX_INTEL_MANUFACTURING_SAI | DFX_INTEL_PRODUCTION_SAI"',
    'HQM_OS_W_RAC_AGENTS' => '"HOSTIA_POSTBOOT_SAI | HOSTIA_UCODE_SAI | HOSTIA_SMM_SAI | HOSTIA_SUNPASS_SAI | HOSTIA_BOOT_SAI | SAI_Reserved_5 | SAI_Reserved_6 | SAI_Reserved_7 | GT_SAI | PM_PCS_SAI | HW_CPU_SAI | MEM_CPL_SAI | VTD_SAI | PM_DIE_TO_DIE_SAI | OOB_MSM_UNTRUSTED_SAI | HOSTCP_PMA_SAI | CSE_INTEL_SAI | CSE_OEM_SAI | FUSE_CTRL_SAI | FUSE_PULLER_SAI | PECI_MSM_SAI | PM_IOSS_SAI | CSE_DNX_SAI | FXR_INTERNAL_SAI | DFX_INTEL_MANUFACTURING_SAI | DFX_UNTRUSTED_SAI | SAI_Reserved_26 | IRC_SAI | NPK_SAI | DISPLAY2_SAI | DISPLAY3_SAI | HW_PCH_SAI | SAI_Reserved_32 | SAI_Reserved_33 | SAI_Reserved_34 | GT_PMA_SAI | HSP_SAI | SAI_Reserved_37 | SAI_Reserved_38 | SAI_Reserved_39 | UNCORE_PMA_SAI | RC_MORPHED_SAI | DFX_INTEL_PRODUCTION_SAI | DFX_THIRDPARTY_SAI | DISPLAY_SAI | SAI_Reserved_45 | SAI_Reserved_46 | DISPLAY_KVM_SAI | GT2_SAI | SAI_Reserved_49 | DEVICE_UNTRUSTED_IAL_SAI | SAI_Reserved_51 | CORE_EVENT_PROXY_SAI | DEVICE_ABORT_SAI | RCIOMMU_BYPASS_SAI | SAI_Reserved_55 | SAI_Reserved_56 | IE_CSE_SAI | SAI_Reserved_58 | SAI_Reserved_59 | CPM_SAI | OOB_MSM_SAI | XGBE_SAI | DEVICE_UNTRUSTED_SAI"',
    'HQM_OS_W_WAC_AGENTS' => '"HOSTIA_POSTBOOT_SAI | HOSTIA_UCODE_SAI | HOSTIA_SMM_SAI | HOSTIA_SUNPASS_SAI | HOSTIA_BOOT_SAI | PM_PCS_SAI | DFX_INTEL_MANUFACTURING_SAI | DFX_INTEL_PRODUCTION_SAI | DFX_UNTRUSTED_SAI | OOB_MSM_SAI | DFX_THIRDPARTY_SAI"',

  );
  
  return (%security);
};
sub GetSecurityUnsupportedInfo() {
  %security = (
  );
  return (%security);
};

# MSS note: OneSource has a 32-bit version of this function.
sub str2hex {
  $instring = shift;
  $instring =~ s/\s+//g;
  $instring =~ s/\"//g;
  @agent_list = split(/\|/, $instring);
  $vector_val = 0;
  $shift = 0;
  foreach $a (@agent_list) {
    chomp($a);
    $shift = $agent_encoding{$a};
    $vector_val = $vector_val + (1<<$shift);
  }
  $vector_val_hex = sprintf "%llx", $vector_val;
  $vector_val_hex = "64'h".$vector_val_hex;
  return ($vector_val_hex);
}
sub str2hex_msb {
 $instring = shift;
 $instring =~ s/\s+//g;
 $instring =~ s/\"//g;
 @agent_list = split(/\|/, $instring);
 $vector_val = 0;
 foreach $a (@agent_list) {
  chomp($a);
   $shift = $agent_encoding{$a};
  if ($shift >= 32) {
   $shift -= 32;
   $vector_val = $vector_val + (1<< $shift);
  }
 }

 $vector_val_hex = sprintf "%lx", $vector_val;
 $vector_val_hex = "32'h" . $vector_val_hex;
 return ($vector_val_hex);
}
sub str2hex_lsb {
 $instring = shift;
 $instring =~ s/\s+//g;
 $instring =~ s/\"//g;
 @agent_list = split(/\|/, $instring);
 $vector_val = 0;
 foreach $a (@agent_list) {
  chomp($a);
   $shift = $agent_encoding{$a};
  if ($shift < 32) {
   $vector_val = $vector_val + (1<< $shift);
  }
 }

 $vector_val_hex = sprintf "%lx", $vector_val;
 $vector_val_hex = "32'h" . $vector_val_hex;
 return ($vector_val_hex);
}

# MSS wondering if following function is used?
sub get_type {
  if ((($_[0] >> $_[1])%2) == 1) {
    return "RW";
  }
  else {
    return "RO";
  }
}

# MSS wondering if following function is used?
sub get_value {
  if ($_[0] eq "RW") {
    return (($_[1] >> $_[2])%2);
}  else {
    return 0;
  }
}

sub str2hex_upper32 {
 $instring = shift;
 $instring =~ s/\s+//g;
 $instring =~ s/\"//g;
 @agent_list = split(/\|/, $instring);
 $vector_val = 0;
 foreach $a (@agent_list) {
  chomp($a);
   $shift = $agent_encoding{$a};
  if ($shift >= 32) {
   $shift -= 32;
   $vector_val = $vector_val + (1<< $shift);
  }
 }

 $vector_val_hex = sprintf "%lx", $vector_val;
 $vector_val_hex = "32'h" . $vector_val_hex;
 return ($vector_val_hex);
}
sub str2hex_lower32 {
 $instring = shift;
 $instring =~ s/\s+//g;
 $instring =~ s/\"//g;
 @agent_list = split(/\|/, $instring);
 $vector_val = 0;
 foreach $a (@agent_list) {
  chomp($a);
   $shift = $agent_encoding{$a};
  if ($shift < 32) {
   $vector_val = $vector_val + (1<< $shift);
  }
 }

 $vector_val_hex = sprintf "%lx", $vector_val;
 $vector_val_hex = "32'h" . $vector_val_hex;
 return ($vector_val_hex);
}

# MSS modifying this to be like OneSource version that tolerates either
# a 32b or 64b number as the string.
sub policybit_get_type {
  $vector_val = shift;
  $bit_num = shift;
  $bit_num -= 32 if ( $bit_num > 31 && $vector_val =~ /32'h/ );
  $vector_val =~ s/(64|32)'h//g;
  $vector_val_dec = hex($vector_val);
  if ((($vector_val_dec >> $bit_num)%2) == 1) {
    return "RO";
  }
  else {
    return "RW";
  }
}

sub policybit_get_value {
  $vector_val = $_[1];
  $vector_val =~ s/64'h//g;
  $vector_val_dec = hex($vector_val);
  if ($_[0] eq "RW") {
    return (($vector_val_dec >> $_[2])%2);
  }
  else {
    return 0;
  }
}

#MSS adding a new function like the above but which does not take
#the type as input and just returns the value of the specified bit.
#10nm server will use this for the reset value of the CP registers that
#may be RO but will often still have a value of 1.
# MSS modifying this to be like OneSource version that tolerates either a 32b or 64b number as
# the string
sub bit_get_value {
  $vector_val = shift;
  $bit_num = shift;
  $bit_num -= 32 if ( $bit_num > 31  && $vector_val =~ /32'h/ );
  $vector_val =~ s/(64|32)'h//g;
  $vector_val_dec = hex($vector_val); 
  return (($vector_val_dec >> $bit_num)%2);
}

# SPI
sub str2hex64 {
   
   #$agent_list_hash = shift;
   $instring = shift;  
   $instring =~ s/\s+//g;    
   $instring =~ s/\"//g;     
   @agent_list = split(/\|/, $instring);   
   $vector_val = 0;
   foreach $a (@agent_list) {
     chomp($a);
     $shift = $agent_encoding{$a};
#     if ($shift > 31) { next; }
     
     $vector_val = $vector_val +  (1<< $shift);
   }
   $vector_val_hex = sprintf "%llx", $vector_val;
   $vector_val_hex = "64'h" . $vector_val_hex;
   return ($vector_val_hex);
}
