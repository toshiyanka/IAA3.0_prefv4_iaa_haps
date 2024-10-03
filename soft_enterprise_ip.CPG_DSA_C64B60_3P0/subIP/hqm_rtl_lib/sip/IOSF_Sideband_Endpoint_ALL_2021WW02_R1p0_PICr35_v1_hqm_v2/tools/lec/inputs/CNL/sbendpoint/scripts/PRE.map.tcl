vpx read setup information $env(WARD)/syn/logs/${G_DESIGN_NAME}_compile_incr.log -type dclog
vpx read setup information $env(WARD)/syn/outputs/${G_DESIGN_NAME}.vsdc -type vsdc

#vpx add mapping model e05fyy003* e05fyw043* e05fkw040* e05fmw203* e05fvw003* e05fmw20c* -inverted -library -both
#vpx add mapping model ctech_lib_clk_gate_te -inverted -design -golden
#vpx add mapping model ctech_lib_clk_div2_reset -inverted -design -golden
#vpx add mapping model ctech_lib_clk_gate_te_rst_ss -inverted -design -golden
#vpx set mapping method -phasemapmodel -name first -BBOX_NAME_MATCH -nounreach
