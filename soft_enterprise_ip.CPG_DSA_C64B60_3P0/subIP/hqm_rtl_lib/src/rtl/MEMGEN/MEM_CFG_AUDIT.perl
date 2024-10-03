#!/usr/bin/perl 

##USAGE MEM_CFG_GEN.perl <config> <mode>

$INPUT_FILE = shift;
$MEM_MODE = shift;

for $file ("../../../subIP/sip/AW/src/rtl/AWGEN_HQMV3/AW_SOLUTION.hash.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

open INPUT, "<$INPUT_FILE";
open OUTFILE, ">>MEM_SOLUTION_CFG.hash.txt";
open AW_OUTFILE, ">>MEM_AW_MAP.hash.txt";

($module_prefix=$INPUT_FILE)=~s/\.config//;

open FET_OUTFILE, ">${module_prefix}.fet.config.tmp";

while (<INPUT>) {

  chomp;
  $_ =~ s/^\s+//g;
  $_ =~ s/\s+$//g;
  $_ =~ s/\s+//g;
  $_ =~ s/^#.*//;

  @line = split /\,/, $_ ;
  $TYPE=$line[0];
  $DEPTH=$line[1];
  $WIDTH=$line[2];
  $NAME=$line[3];
  $BCLK=$line[4];
  $FET_NUM=$line[5];

  $WRAPPER = "hqm_AW_${TYPE}_${DEPTH}x${WIDTH}";

  $IS_PG_GATED = $AW_hash{$WRAPPER}{gated}[0];

  if ($IS_PG_GATED == 1) {
    print FET_OUTFILE "$FET_NUM $NAME $TYPE $module_prefix\n";
  }

  $UNIQUE_WRAPPER = $WRAPPER;
  $UNIQUE_WRAPPER =~s/hqm/${module_prefix}/g;

  print AW_OUTFILE "push(\@\{\$MEM_AW_HASH\{${module_prefix}\}{${WRAPPER}\}\},\"${UNIQUE_WRAPPER}\")\;\n";
  print AW_OUTFILE "push(\@\{\$MEM_AW_HASH\{${module_prefix}\}{${UNIQUE_WRAPPER}\}\},\"${WRAPPER}\")\;\n";

  $ADDR_WIDTH = $AW_hash{$WRAPPER}{addr_width}[0];

  print OUTFILE "push(\@\{\$MEM_CFG_HASH\{${module_prefix}\}\{${BCLK}\}\{${TYPE}\}\{${NAME}\}{wrapper\}\},\"${UNIQUE_WRAPPER}\")\;\n";
  print OUTFILE "push(\@\{\$MEM_CFG_HASH\{${module_prefix}\}\{${BCLK}\}\{${TYPE}\}\{${NAME}\}{base_wrapper\}\},\"${WRAPPER}\")\;\n";
  print OUTFILE "push(\@\{\$MEM_CFG_HASH\{${module_prefix}\}\{${BCLK}\}\{${TYPE}\}\{${NAME}\}{depth\}\},\"${DEPTH}\")\;\n";
  print OUTFILE "push(\@\{\$MEM_CFG_HASH\{${module_prefix}\}\{${BCLK}\}\{${TYPE}\}\{${NAME}\}{data_width\}\},\"${WIDTH}\")\;\n";
  print OUTFILE "push(\@\{\$MEM_CFG_HASH\{${module_prefix}\}\{${BCLK}\}\{${TYPE}\}\{${NAME}\}{addr_width\}\},\"${ADDR_WIDTH}\")\;\n";

}

close(OUTFILE);
close(FET_OUTFILE);

system("sort -n ${module_prefix}.fet.config.tmp > ${module_prefix}.fet.config");
system("rm -rf  ${module_prefix}.fet.config.tmp");

