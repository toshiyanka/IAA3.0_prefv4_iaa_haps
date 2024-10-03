vpx read setup information $env(WARD)/syn/logs/${G_DESIGN_NAME}_compile_incr.log -type dclog
#vpx read setup information $env(WARD)/syn/outputs/${G_DESIGN_NAME}.vsdc -type vsdc


###below settings to create phase map model on inverted equivalent cells to reduce runtime

#vpx add mapping model e05fkn003* e05fkn00c* e05fkn00f* e05fkn043* e05fkw00c* e05fkw00f* e05fkw043* e05fkw08f* e05fyy003* e05fyw043* e05fkw040* e05fmw203* e05fvw003* e05fmw20c* e05fynr03* e05fynr43* e05fywr03* e05fywr43* -inverted -library -both

#vpx add mapping model e05fkw043* e05fkw003* e05fynr43* e05fywr03* e05fywr43* e05fsw010* -inverted -library -both
vpx add mapping model e05fywr03al* e05fywr43al* -inverted -library -both
#vpx add mapping model *ctech_lib_clk_gate_te* -inverted -design -golden
vpx add mapping model *ctech_lib_clk_div2_reset* -inverted -design -golden
vpx add mapping model *ctech_lib_clk_gate_te_rst_ss* -inverted -design -golden
vpx set mapping method -phasemapmodel -name first -BBOX_NAME_MATCH -nounreach
