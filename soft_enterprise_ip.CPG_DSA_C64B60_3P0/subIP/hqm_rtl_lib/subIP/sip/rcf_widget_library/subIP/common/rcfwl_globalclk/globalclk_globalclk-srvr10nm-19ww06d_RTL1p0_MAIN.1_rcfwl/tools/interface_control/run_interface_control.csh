scripts/port_parameter_checker.pl --interface_control_file
tools/interface_control/pccdu_ifccntl.txt --input_port_parameter_file target/collage/work/pccdu/reports/gclk_pccdu.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/pccdu_ifccntl.txt --input_port_parameter_file target/collage/work/pccdu/reports/gclk_pccdu.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/psyncdist_ifccntl.txt --input_port_parameter_file  target/collage/work/psyncdist/reports/gclk_pyncdist.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/psyncdist_ifccntl.txt --input_port_parameter_file target/collage/work/psyncdist/reports/gclk_pyncdist.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/pclkdist_ifccntl.txt --input_port_parameter_file target/collage/work/pclkdist/reports/gclk_pclkdist.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/pclkdist_ifccntl.txt --input_port_parameter_file target/collage/work/pclkdist/reports/gclk_pclkdist.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/divsync_gen_ifccntl.txt --input_port_parameter_file target/collage/work/divsync_gen/reports/gclk_divsync_gen.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/divsync_gen_ifccntl.txt --input_port_parameter_file target/collage/work/divsync_gen/reports/gclk_divsync_gen.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/clkdist_mux_ifccntl.txt --input_port_parameter_file target/collage/work/clkdist_mux/reports/gclk_clkdist_mux.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/clkdist_mux_ifccntl.txt --input_port_parameter_file target/collage/work/clkdist_mux/reports/gclk_clkdist_mux.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/clkdist_repeater_ifccntl.txt --input_port_parameter_file target/collage/work/clkdist_repeater/reports/gclk_clkdist_repeater.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/clkdist_repeater_ifccntl.txt --input_port_parameter_file target/collage/work/clkdist_repeater/reports/gclk_clkdist_repeater.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/clkreqaggr_ifccntl.txt --input_port_parameter_file target/collage/work/clkreqaggr/reports/gclk_clkreqaggr.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/clkreqaggr_ifccntl.txt --input_port_parameter_file target/collage/work/clkreqaggr/reports/gclk_clkreqaggr.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/mesh_clkdist_ifccntl.txt --input_port_parameter_file target/collage/work/mesh_clkdist/reports/gclk_mesh_clkdist.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/mesh_clkdist_ifccntl.txt --input_port_parameter_file target/collage/work/mesh_clkdist/reports/gclk_mesh_clkdist.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/refclkdist_ifccntl.txt --input_port_parameter_file target/collage/work/refclkdist/reports/gclk_refclkdist.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/refclkdist_ifccntl.txt --input_port_parameter_file target/collage/work/refclkdist/reports/gclk_refclkdist.build.summary >> target/interface_check.log

scripts/port_parameter_checker.pl --interface_control_file tools/interface_control/gclk_make_clk_rcb_lcb_ph1_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/make_clk_rcb_lcb_ph1.build.summary >> target/interface_check.log
scripts/interface_checker.pl --interface_control_file tools/interface_control/gclk_make_clk_rcb_lcb_ph1_ifccntl.txt --input_port_parameter_file target/collage/ip_kits/make_clk_rcb_lcb_ph1.build.summary >> target/interface_check.log
