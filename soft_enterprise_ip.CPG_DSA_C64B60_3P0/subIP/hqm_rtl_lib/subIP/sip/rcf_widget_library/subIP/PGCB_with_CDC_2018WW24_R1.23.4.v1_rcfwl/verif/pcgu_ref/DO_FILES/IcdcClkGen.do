dump -add { icdc_clk_gen } -depth 0 -scope "."
force icdc_clk_gen.clock 1 0, 0 2 -repeat 5
force icdc_clk_gen.reset_b 0
run 100ns
force icdc_clk_gen.reset_b 1
run 200ns
