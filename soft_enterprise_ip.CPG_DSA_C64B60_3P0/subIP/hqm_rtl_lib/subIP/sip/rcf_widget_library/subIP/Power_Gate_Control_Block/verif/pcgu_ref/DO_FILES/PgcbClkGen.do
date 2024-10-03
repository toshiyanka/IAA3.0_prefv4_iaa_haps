gui_sim_run Ucli -exe simv -args {-ucligui  pcgu_clk_gen} -dir .
dump -add { pcgu_clk_gen } -depth 0 -scope "."
force pcgu_clk_gen.clock 1 0, 0 2 -repeat 5
force pcgu_clk_gen.reset_b 0
force pcgu_clk_gen.pgcb_clkreq 0
run 100ns
force pcgu_clk_gen.reset_b 1
run 100ns
force pcgu_clk_gen.pgcb_clkreq 1
run 105ns
force pcgu_clk_gen.pgcb_clkreq 0 
run 500ns
force pcgu_clk_gen.pgcb_clkreq 1
run 500ns
