#!/usr/bin/perl 

##USAGE MEM_CFG_GEN.perl <module>

$module = shift;

for $file ("MEM_SOLUTION_CFG.hash.txt",)
                   {
                       unless ($return = do $file) {
                           warn "couldn't parse $file: $@" if $@;
                           warn "couldn't do $file: $!"    unless defined $return;
                           warn "couldn't run $file"       unless $return;
                       }
                   }

## Generating mbist container level

    foreach $_module ( sort {$a cmp $b} keys %MEM_CFG_HASH ) {

    open CONTAINER_FILE, ">${_module}.sv";
    print CONTAINER_FILE "module ${_module} (\n\n";

    $begin_flag = 0;
    $print_port = "";
    $has_sram = 0;
    $has_bcam = 0;
    $has_rf_pg = 0;
    $has_rf_aon = 0;

    foreach $_bclk ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}} ) {
        foreach $_type ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}} ) {
            foreach $_name ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}{$_type}} ) {

               $addr  = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{addr_width}[0];
               $width = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{data_width}[0];

               if ($_type =~ /rf/) {

                    if ($begin_flag == 0) {
                     $print_port .= sprintf("     input  logic                       rf_${_name}_wclk\n");
                     $begin_flag = 1;            
                    } else {                     
                     $print_port .= sprintf("    ,input  logic                       rf_${_name}_wclk\n");
                    }                            
                                                 
                    $print_port  .= sprintf("    ,input  logic                       rf_${_name}_wclk_rst_n\n");
                    $print_port  .= sprintf("    ,input  logic                       rf_${_name}_we\n");
                    $print_port  .= sprintf("    ,input  logic[ ( %3d ) -1 : 0 ]     rf_${_name}_waddr\n", $addr);
                    $print_port  .= sprintf("    ,input  logic[ ( %3d ) -1 : 0 ]     rf_${_name}_wdata\n", $width);
                    $print_port  .= sprintf("    ,input  logic                       rf_${_name}_rclk\n");
                    $print_port  .= sprintf("    ,input  logic                       rf_${_name}_rclk_rst_n\n");
                    $print_port  .= sprintf("    ,input  logic                       rf_${_name}_re\n");
                    $print_port  .= sprintf("    ,input  logic[ ( %3d ) -1 : 0 ]     rf_${_name}_raddr\n", $addr);
                    $print_port  .= sprintf("    ,output logic[ ( %3d ) -1 : 0 ]     rf_${_name}_rdata\n\n", $width);

                    if ($_type =~ /pg/) {        
                     $print_port .= sprintf("    ,input  logic                       rf_${_name}_isol_en\n");
                     $print_port .= sprintf("    ,input  logic                       rf_${_name}_pwr_enable_b_in\n");
                     $print_port .= sprintf("    ,output logic                       rf_${_name}_pwr_enable_b_out\n\n");
                     $has_rf_pg = 1;
                    } else {
                     $has_rf_aon = 1;
                    }
               } 

               if ($_type =~ /sram/) {

                    $has_sram = 1;

                    if ($begin_flag == 0) {
                     $print_port .= sprintf("     input  logic                       sr_${_name}_clk\n");
                     $begin_flag = 1;            
                    } else {                     
                     $print_port .= sprintf("    ,input  logic                       sr_${_name}_clk\n");
                    }                            
                                                 
                    $print_port  .= sprintf("    ,input  logic                       sr_${_name}_clk_rst_n\n");
                    $print_port  .= sprintf("    ,input  logic[ ( %3d ) -1 : 0 ]     sr_${_name}_addr\n", $addr);
                    $print_port  .= sprintf("    ,input  logic                       sr_${_name}_we\n");
                    $print_port  .= sprintf("    ,input  logic[ ( %3d ) -1 : 0 ]     sr_${_name}_wdata\n", $width);
                    $print_port  .= sprintf("    ,input  logic                       sr_${_name}_re\n");
                    $print_port  .= sprintf("    ,output logic[ ( %3d ) -1 : 0 ]     sr_${_name}_rdata\n\n", $width);
                    $print_port  .= sprintf("    ,input  logic                       sr_${_name}_isol_en\n");
                    $print_port  .= sprintf("    ,input  logic                       sr_${_name}_pwr_enable_b_in\n");
                    $print_port  .= sprintf("    ,output logic                       sr_${_name}_pwr_enable_b_out\n\n");

               }

               if ($_type =~ /bcam/) {
     
                    $has_bcam = 1;

                    if ($begin_flag == 0) {
                     $print_port .= sprintf("     input  logic                       bcam_${_name}_wclk\n");
                     $begin_flag = 1;            
                    } else {                     
                     $print_port .= sprintf("    ,input  logic                       bcam_${_name}_wclk\n");
                    }                            
                                                 
                    $print_port  .= sprintf("    ,input  logic[ 64 -1 : 0 ]          bcam_${_name}_waddr\n");
                    $print_port  .= sprintf("    ,input  logic[ 8  -1 : 0 ]          bcam_${_name}_we\n");
                    $print_port  .= sprintf("    ,input  logic[ 208 -1 : 0 ]         bcam_${_name}_wdata\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_rclk\n");
                    $print_port  .= sprintf("    ,input  logic[ 8-1 : 0 ]            bcam_${_name}_raddr\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_re\n");
                    $print_port  .= sprintf("    ,output logic[ 208 -1 : 0 ]         bcam_${_name}_rdata\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_cclk\n");
                    $print_port  .= sprintf("    ,input  logic[ 208 -1 : 0 ]         bcam_${_name}_cdata\n");
                    $print_port  .= sprintf("    ,input  logic[ 8  -1 : 0 ]          bcam_${_name}_ce\n");
                    $print_port  .= sprintf("    ,output logic[ 2048 -1 : 0 ]        bcam_${_name}_cmatch\n\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_isol_en_b\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_dfx_clk\n\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_fd\n");
                    $print_port  .= sprintf("    ,input  logic                       bcam_${_name}_rd\n\n");

               }

            }

        }

    }

    print  CONTAINER_FILE "$print_port";

    if (($has_sram == 1) || ($has_bcam == 1) || ($has_rf_pg == 1)) {
     print CONTAINER_FILE "    ,input  logic                       hqm_pwrgood_rst_b\n\n";
    }
    print  CONTAINER_FILE "    ,input  logic                       powergood_rst_b\n\n";
    print  CONTAINER_FILE "    ,input  logic                       fscan_byprst_b\n";
    if (($has_sram == 1) || ($has_rf_aon == 1) || ($has_rf_pg == 1)) {
     print CONTAINER_FILE "    ,input  logic                       fscan_clkungate\n";
    }
    print  CONTAINER_FILE "    ,input  logic                       fscan_rstbypen\n";
    print  CONTAINER_FILE ");\n\n";

    print CONTAINER_FILE "// collage-pragma translate_off\n\n";

    foreach $_bclk ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}} ) {
        foreach $_type ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}} ) {

            print CONTAINER_FILE "${_module}_${_bclk}_${_type}_cont i_${_module}_${_bclk}_${_type}_cont (\n\n";
            $begin = 0;
            $print_func_inst = "";

            $has_sram = 0;
            $has_bcam = 0;
            $has_rf_pg = 0;
            $has_rf_aon = 0;

            foreach $_name ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}{$_type}} ) {

               if ($_type =~ /rf/) {
                   if ($begin == 0 ) {
                    $print_func_inst .= sprintf("     .%-50s (%s\n", "rf_${_name}_wclk",             "rf_${_name}_wclk)");
                    $begin = 1;
                   } else {
                    $print_func_inst .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_wclk",             "rf_${_name}_wclk)");
                   }
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_wclk_rst_n",       "rf_${_name}_wclk_rst_n)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_we",               "rf_${_name}_we)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_waddr",            "rf_${_name}_waddr)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_wdata",            "rf_${_name}_wdata)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_rclk",             "rf_${_name}_rclk)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_rclk_rst_n",       "rf_${_name}_rclk_rst_n)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_re",               "rf_${_name}_re)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_raddr",            "rf_${_name}_raddr)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_rdata",            "rf_${_name}_rdata)\n");

                   if ($_type =~ /pg/) {
                    $print_func_inst .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_isol_en",          "rf_${_name}_isol_en)");
                    $print_func_inst .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_pwr_enable_b_in",  "rf_${_name}_pwr_enable_b_in)");
                    $print_func_inst .= sprintf("    ,.%-50s (%s\n", "rf_${_name}_pwr_enable_b_out", "rf_${_name}_pwr_enable_b_out)\n");
                    $has_rf_pg = 1;
                   } else {
                    $has_rf_aon = 1;
                   }

               }

               if ($_type =~ /sram/) {

                   $has_sram = 1;

                   if ($begin == 0 ) {
                    $print_func_inst .= sprintf("     .%-50s (%s\n", "sr_${_name}_clk",              "sr_${_name}_clk)");
                    $begin = 1;
                   } else {
                    $print_func_inst .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_clk",              "sr_${_name}_clk)");
                   }
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_clk_rst_n",        "sr_${_name}_clk_rst_n)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_we",               "sr_${_name}_we)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_addr",             "sr_${_name}_addr)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_wdata",            "sr_${_name}_wdata)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_re",               "sr_${_name}_re)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_rdata",            "sr_${_name}_rdata)\n");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_isol_en",          "sr_${_name}_isol_en)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_pwr_enable_b_in",  "sr_${_name}_pwr_enable_b_in)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "sr_${_name}_pwr_enable_b_out", "sr_${_name}_pwr_enable_b_out)\n");
               }

               if ($_type =~ /bcam/) {
     
                   $has_bcam = 1;

                   if ($begin == 0 ) {
                    $print_func_inst .= sprintf("     .%-50s (%s\n", "bcam_${_name}_wclk",           "bcam_${_name}_wclk)");
                    $begin = 1;
                   } else {
                    $print_func_inst .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_wclk",           "bcam_${_name}_wclk)");
                   }
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_rclk",           "bcam_${_name}_rclk)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_cclk",           "bcam_${_name}_cclk)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_we",             "bcam_${_name}_we)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_re",             "bcam_${_name}_re)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_ce",             "bcam_${_name}_ce)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_waddr",          "bcam_${_name}_waddr)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_raddr",          "bcam_${_name}_raddr)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_wdata",          "bcam_${_name}_wdata)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_rdata",          "bcam_${_name}_rdata)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_cdata",          "bcam_${_name}_cdata)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_cmatch",         "bcam_${_name}_cmatch)\n");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_isol_en_b",      "bcam_${_name}_isol_en_b)\n");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_dfx_clk",        "bcam_${_name}_dfx_clk)\n");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_fd",             "bcam_${_name}_fd)");
                   $print_func_inst  .= sprintf("    ,.%-50s (%s\n", "bcam_${_name}_rd",             "bcam_${_name}_rd)\n");

               }

            }

            printf  CONTAINER_FILE "$print_func_inst"; 

            if (($has_sram == 1) || ($has_bcam == 1) || ($has_rf_pg == 1)) {
             printf CONTAINER_FILE "    ,.%-50s (%s\n", "hqm_pwrgood_rst_b",            "hqm_pwrgood_rst_b)\n";
            }
            printf  CONTAINER_FILE "    ,.%-50s (%s\n", "powergood_rst_b",              "powergood_rst_b)\n";
            printf  CONTAINER_FILE "    ,.%-50s (%s\n", "fscan_byprst_b",               "fscan_byprst_b)";
            if (($has_sram == 1) || ($has_rf_aon == 1) || ($has_rf_pg == 1)) {
             printf CONTAINER_FILE "    ,.%-50s (%s\n", "fscan_clkungate",              "fscan_clkungate)";
            }
            printf  CONTAINER_FILE "    ,.%-50s (%s\n", "fscan_rstbypen",               "fscan_rstbypen)";
            printf  CONTAINER_FILE ");\n\n";

        }
    }

    print CONTAINER_FILE "// collage-pragma translate_on\n\n";

    print CONTAINER_FILE "endmodule\n\n";

}

