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
    foreach $_bclk ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}} ) {
        foreach $_type ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}} ) {

            $begin_flag = 0;
            $print_port = "";

            open CONTAINER_FILE, ">${_module}_${_bclk}_${_type}_cont.sv";

            print CONTAINER_FILE "module ${_module}_${_bclk}_${_type}_cont \(\n\n";

            foreach $_name ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}{$_type}} ) {

               $addr  = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{addr_width}[0];
               $width = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{data_width}[0];

               if ($_type =~ /rf/) {

                    if ($begin_flag == 0) {
                     $print_port .= sprintf("     input  logic                        rf_${_name}_wclk\n");
                     $begin_flag = 1;
                     $first_rclk_name = "rf_${_name}_rclk";
                    } else {
                     $print_port .= sprintf("    ,input  logic                        rf_${_name}_wclk\n");
                    }

                    $print_port  .= sprintf("    ,input  logic                        rf_${_name}_wclk_rst_n\n");
                    $print_port  .= sprintf("    ,input  logic                        rf_${_name}_we\n");
                    $print_port  .= sprintf("    ,input  logic [ ( %3d ) -1 : 0 ]     rf_${_name}_waddr\n", $addr);
                    $print_port  .= sprintf("    ,input  logic [ ( %3d ) -1 : 0 ]     rf_${_name}_wdata\n", $width);
                    $print_port  .= sprintf("    ,input  logic                        rf_${_name}_rclk\n");
                    $print_port  .= sprintf("    ,input  logic                        rf_${_name}_rclk_rst_n\n");
                    $print_port  .= sprintf("    ,input  logic                        rf_${_name}_re\n");
                    $print_port  .= sprintf("    ,input  logic [ ( %3d ) -1 : 0 ]     rf_${_name}_raddr\n", $addr);
                    $print_port  .= sprintf("    ,output logic [ ( %3d ) -1 : 0 ]     rf_${_name}_rdata\n\n", $width);

                    if ($_type =~ /pg/) {
                     $print_port .= sprintf("    ,input  logic                        rf_${_name}_isol_en\n");
                     $print_port .= sprintf("    ,input  logic                        rf_${_name}_pwr_enable_b_in\n");
                     $print_port .= sprintf("    ,output logic                        rf_${_name}_pwr_enable_b_out\n\n");
                    }
               }

               if ($_type =~ /sram/) {

                    if ($begin_flag == 0) {
                     $print_port .= sprintf("     input  logic                        sr_${_name}_clk\n");
                     $begin_flag = 1;
                     $first_rclk_name = "sr_${_name}_clk";
                    } else {
                     $print_port .= sprintf("    ,input  logic                        sr_${_name}_clk\n");
                    }

                    $print_port  .= sprintf("    ,input  logic                        sr_${_name}_clk_rst_n\n");
                    $print_port  .= sprintf("    ,input  logic [ ( %3d ) -1 : 0 ]     sr_${_name}_addr\n", $addr);
                    $print_port  .= sprintf("    ,input  logic                        sr_${_name}_we\n");
                    $print_port  .= sprintf("    ,input  logic [ ( %3d ) -1 : 0 ]     sr_${_name}_wdata\n", $width);
                    $print_port  .= sprintf("    ,input  logic                        sr_${_name}_re\n");
                    $print_port  .= sprintf("    ,output logic [ ( %3d ) -1 : 0 ]     sr_${_name}_rdata\n\n", $width);
                    $print_port  .= sprintf("    ,input  logic                        sr_${_name}_isol_en\n");
                    $print_port  .= sprintf("    ,input  logic                        sr_${_name}_pwr_enable_b_in\n");
                    $print_port  .= sprintf("    ,output logic                        sr_${_name}_pwr_enable_b_out\n\n");

              }

               if ($_type =~ /bcam/) {

                    if ($begin_flag == 0) {
                     $print_port .= sprintf("     input  logic                        bcam_${_name}_wclk\n");
                     $begin_flag = 1;
                     $first_rclk_name = "bcam_${_name}_rclk";
                    } else {
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_wclk\n");
                    }

                     $print_port .= sprintf("    ,input  logic [ 64 -1 : 0 ]          bcam_${_name}_waddr\n");
                     $print_port .= sprintf("    ,input  logic [ 8  -1 : 0 ]          bcam_${_name}_we\n");
                     $print_port .= sprintf("    ,input  logic [ 208 -1 : 0 ]         bcam_${_name}_wdata\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_rclk\n");
                     $print_port .= sprintf("    ,input  logic [ 8-1 : 0 ]            bcam_${_name}_raddr\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_re\n");
                     $print_port .= sprintf("    ,output logic [ 208 -1 : 0 ]         bcam_${_name}_rdata\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_cclk\n");
                     $print_port .= sprintf("    ,input  logic [ 208 -1 : 0 ]         bcam_${_name}_cdata\n");
                     $print_port .= sprintf("    ,input  logic [ 8  -1 : 0 ]          bcam_${_name}_ce\n");
                     $print_port .= sprintf("    ,output logic [ 2048 -1 : 0 ]        bcam_${_name}_cmatch\n\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_isol_en_b\n\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_dfx_clk\n\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_fd\n");
                     $print_port .= sprintf("    ,input  logic                        bcam_${_name}_rd\n\n");

               }

            }

          print  CONTAINER_FILE "$print_port";

          print  CONTAINER_FILE "    ,input  logic                        powergood_rst_b\n\n";

          if (($_type eq "rf_pg") || ($_type eq "rf_dc_pg") || ($_type =~ /bcam/) || ($_type =~ /sram/ )) {
           print CONTAINER_FILE "    ,input  logic                        hqm_pwrgood_rst_b\n\n";
          }

          print  CONTAINER_FILE "    ,input  logic                        fscan_byprst_b\n";
          if ($_type !~ /bcam/) {
           print CONTAINER_FILE "    ,input  logic                        fscan_clkungate\n";
          }
          print  CONTAINER_FILE "    ,input  logic                        fscan_rstbypen\n";
          print  CONTAINER_FILE ");\n\n";
          print  CONTAINER_FILE "logic ip_reset_b;\n\n";

          if (($_type eq "rf_pg") || ($_type eq "rf_dc_pg") || ($_type =~ /bcam/) || ($_type =~ /sram/ )) {
           print CONTAINER_FILE "assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;\n\n";
          } else {
           print CONTAINER_FILE "assign ip_reset_b = powergood_rst_b;\n\n";
          }

          $print_inst = "";

          foreach $_name ( sort {$a cmp $b} keys %{$MEM_CFG_HASH{$_module}{$_bclk}{$_type}} ) {

               $addr  = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{addr_width}[0];
               $width = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{data_width}[0];
               $wrapper = $MEM_CFG_HASH{$_module}{$_bclk}{$_type}{$_name}{wrapper}[0];

               if ($_type =~ /rf/) {

                $print_inst  .= "$wrapper i_rf_${_name} (\n\n";
                $print_inst  .= "     .wclk                    (rf_${_name}_wclk)\n";
                $print_inst  .= "    ,.wclk_rst_n              (rf_${_name}_wclk_rst_n)\n";
                $print_inst  .= "    ,.we                      (rf_${_name}_we)\n";
                $print_inst  .= "    ,.waddr                   (rf_${_name}_waddr)\n";
                $print_inst  .= "    ,.wdata                   (rf_${_name}_wdata)\n";
                $print_inst  .= "    ,.rclk                    (rf_${_name}_rclk)\n";
                $print_inst  .= "    ,.rclk_rst_n              (rf_${_name}_rclk_rst_n)\n";
                $print_inst  .= "    ,.re                      (rf_${_name}_re)\n";
                $print_inst  .= "    ,.raddr                   (rf_${_name}_raddr)\n";
                $print_inst  .= "    ,.rdata                   (rf_${_name}_rdata)\n\n";

                if ($_type =~ /pg/) {
                 $print_inst .= "    ,.pgcb_isol_en            (rf_${_name}_isol_en)\n";
                 $print_inst .= "    ,.pwr_enable_b_in         (rf_${_name}_pwr_enable_b_in)\n";
                 $print_inst .= "    ,.pwr_enable_b_out        (rf_${_name}_pwr_enable_b_out)\n\n";
                }

                $print_inst  .= "    ,.ip_reset_b              (ip_reset_b)\n\n";
                $print_inst  .= "    ,.fscan_byprst_b          (fscan_byprst_b)\n";
                $print_inst  .= "    ,.fscan_clkungate         (fscan_clkungate)\n";
                $print_inst  .= "    ,.fscan_rstbypen          (fscan_rstbypen)\n";
                $print_inst  .= ");\n\n";

               }

               if ($_type =~ /sram/) {

                $print_inst  .= "$wrapper i_sr_${_name} (\n\n";
                $print_inst  .= "     .clk                     (sr_${_name}_clk)\n";
                $print_inst  .= "    ,.clk_rst_n               (sr_${_name}_clk_rst_n)\n";
                $print_inst  .= "    ,.we                      (sr_${_name}_we)\n";
                $print_inst  .= "    ,.addr                    (sr_${_name}_addr)\n";
                $print_inst  .= "    ,.wdata                   (sr_${_name}_wdata)\n";
                $print_inst  .= "    ,.re                      (sr_${_name}_re)\n";
                $print_inst  .= "    ,.rdata                   (sr_${_name}_rdata)\n\n";
                $print_inst  .= "    ,.pgcb_isol_en            (sr_${_name}_isol_en)\n";
                $print_inst  .= "    ,.pwr_enable_b_in         (sr_${_name}_pwr_enable_b_in)\n";
                $print_inst  .= "    ,.pwr_enable_b_out        (sr_${_name}_pwr_enable_b_out)\n\n";
                $print_inst  .= "    ,.ip_reset_b              (ip_reset_b)\n\n";
                $print_inst  .= "    ,.fscan_byprst_b          (fscan_byprst_b)\n";
                $print_inst  .= "    ,.fscan_clkungate         (fscan_clkungate)\n";
                $print_inst  .= "    ,.fscan_rstbypen          (fscan_rstbypen)\n";
                $print_inst  .= ");\n\n";

               }

               if ($_type =~ /bcam/) {

                $print_inst  .= "$wrapper i_${_name} (\n\n";
                $print_inst  .= "     .FUNC_WR_CLK_RF_IN_P0    (bcam_${_name}_wclk)\n";
                $print_inst  .= "    ,.FUNC_WEN_RF_IN_P0       (bcam_${_name}_we)\n";
                $print_inst  .= "    ,.FUNC_WR_ADDR_RF_IN_P0   (bcam_${_name}_waddr)\n";
                $print_inst  .= "    ,.FUNC_WR_DATA_RF_IN_P0   (bcam_${_name}_wdata)\n";
                $print_inst  .= "    ,.FUNC_CM_CLK_RF_IN_P0    (bcam_${_name}_cclk)\n";
                $print_inst  .= "    ,.FUNC_CEN_RF_IN_P0       (bcam_${_name}_ce)\n";
                $print_inst  .= "    ,.FUNC_CM_DATA_RF_IN_P0   (bcam_${_name}_cdata)\n";
                $print_inst  .= "    ,.CM_MATCH_RF_OUT_P0      (bcam_${_name}_cmatch)\n";
                $print_inst  .= "    ,.FUNC_RD_CLK_RF_IN_P0    (bcam_${_name}_rclk)\n";
                $print_inst  .= "    ,.FUNC_REN_RF_IN_P0       (bcam_${_name}_re)\n";
                $print_inst  .= "    ,.FUNC_RD_ADDR_RF_IN_P0   (bcam_${_name}_raddr)\n";
                $print_inst  .= "    ,.DATA_RF_OUT_P0          (bcam_${_name}_rdata)\n\n";
                $print_inst  .= "    ,.CLK_DFX_WRAPPER         (bcam_${_name}_dfx_clk)\n\n";
                $print_inst  .= "    ,.pgcb_isol_en_b          (bcam_${_name}_isol_en_b)\n\n";
                $print_inst  .= "    ,.fd                      (bcam_${_name}_fd)\n";
                $print_inst  .= "    ,.rd                      (bcam_${_name}_rd)\n\n";
                $print_inst  .= "    ,.ip_reset_b              (ip_reset_b)\n\n";
                $print_inst  .= "    ,.fscan_byprst_b          (fscan_byprst_b)\n";
                $print_inst  .= "    ,.fscan_rstbypen          (fscan_rstbypen)\n";
                $print_inst  .= ");\n\n";

               }

          }

          print CONTAINER_FILE "$print_inst";

          print CONTAINER_FILE "endmodule\n\n";

        }
    }
}

