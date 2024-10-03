#!/usr/bin/perl 

##USAGE MEM_CFG_GEN.perl <module>

$module = shift;

for $file ("MEM_AW_MAP.hash.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

foreach $_module ( sort {$a cmp $b} keys %MEM_AW_HASH ) {

    foreach $_wrapper ( sort {$a cmp $b} keys %{$MEM_AW_HASH{$_module}} ) {

         $unique_wrapper  = $MEM_AW_HASH{$_module}{$_wrapper}[0];

         if ($_wrapper =~ /hqm_AW/) {

             system("sed -e 's/${_wrapper}/${unique_wrapper}/g' ../../../subIP/sip/AW/src/rtl/AWGEN_HQMV3/${_wrapper}.sv > ../../../src/rtl/mems/${unique_wrapper}.sv");
 
         }

    }

}

