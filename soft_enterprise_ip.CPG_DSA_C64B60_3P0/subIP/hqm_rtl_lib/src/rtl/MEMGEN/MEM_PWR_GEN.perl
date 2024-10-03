#!/usr/bin/perl 

##USAGE MEM_CFG_GEN.perl <file>

$ifile = shift;

open FET_FILE, "<${ifile}";
open FET_FILEN, "<${ifile}";
open COLLAGE_ISO, ">hqm_adhoc_mem_iso.txt";
open COLLAGE_FET, ">hqm_adhoc_mem_fet.txt";

$_next = <FET_FILEN>;

print COLLAGE_ISO "C i_hqm_sip\/pgcb_isol_en \{";

while (<FET_FILE>) {

      $_next = <FET_FILEN>;

      chomp;

      s/^\s+//;

      @line = split /\s+/, $_ ;

      $NUM = $line[0];
      $NAME = $line[1];
      $TYPE = $line[2];
      $MODULE = $line[3];

      $tmp = $_;
      $_ = $_next;

      @line = split /\s+/, $_ ;

      $NUMN = $line[0];
      $NAMEN = $line[1];
      $TYPEN = $line[2];
      $MODULEN = $line[3];

      if ($TYPE eq "sram_pg") {
        if ($NUMN eq "END") {
          print COLLAGE_ISO "i_${MODULE}\/sr_${NAME}_isol_en}\n";
        } else {
          print COLLAGE_ISO "i_${MODULE}\/sr_${NAME}_isol_en ";
        }
      } elsif (($TYPE eq "rf_pg") || ($TYPE eq "rf_dc_pg")) {
        if ($NUMN eq "END") {
          print COLLAGE_ISO "i_${MODULE}\/rf_${NAME}_isol_en}\n";
        } else {
          print COLLAGE_ISO "i_${MODULE}\/rf_${NAME}_isol_en ";
        }
      }

      if ($NUM eq "START") {
         $start = $NAME;
      } elsif ($TYPE eq "sram_pg") {
         $start = "i_${MODULE}\/sr_${NAME}_pwr_enable_b_out";
      } elsif (($TYPE eq "rf_pg") || ($TYPE eq "rf_dc_pg") ) {
         $start = "i_${MODULE}\/rf_${NAME}_pwr_enable_b_out";
      }

      if ($NUMN eq "END") {
         $end = $NAMEN;
      } elsif ($TYPEN eq "sram_pg") {
         $end = "i_${MODULEN}\/sr_${NAMEN}_pwr_enable_b_in";
      } elsif (($TYPEN eq "rf_pg") || ($TYPEN eq "rf_dc_pg")) {
         $end = "i_${MODULEN}\/rf_${NAMEN}_pwr_enable_b_in";
      }

      printf COLLAGE_FET "C %-75s %s\n", $start, $end;
      last if ($NUMN eq "END");

}

print COLLAGE_ISO "C i_hqm_sip\/pgcb_isol_en_b i_hqm_list_sel_mem/bcam_AW_bcam_2048x26_isol_en_b\n";

close FET_FILE;
close FET_FILEN;
close COLLAGE_ISO;
close COLLAGE_FET;

