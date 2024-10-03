// synopsys translate_off
covergroup ROM_WRAP_RD_cover @(posedge FUNC_OR_BIST_CLK_ROM_IN);
//Bist RD signals
  coverpoint BIST_REN_ROM iff (BIST_ROM_ENABLE) {
    bins zero_one  =  (0=>1);
    bins one_zero  =  (1=>0);
  }
  coverpoint BIST_ADDR_ROM_IN iff (BIST_ROM_ENABLE) {
    bins add_space[]  =  {[0:ROM_ADDR-1]};
  }
//Func RD signals
  coverpoint FUNC_REN_ROM iff (!BIST_ROM_ENABLE) {
    bins zero_one  =  (0 => 1);
    bins one_zero  =  (1 => 0);
  }
  coverpoint FUNC_ADDR_ROM_IN iff (!BIST_ROM_ENABLE) {
    bins add_space[]  =  {[0:ROM_ADDR-1]};
  }
// Func & Bist RD signals
  coverpoint DATA_ROM_OUT iff (BIST_REN_ROM | FUNC_REN_ROM) {
    bins data_space_zero_one  =  (0 => {ROM_BITS{1'b1}});
    bins data_space_one_zero  =  ({ROM_BITS{1'b1}} => 0);

  }
endgroup

ROM_WRAP_RD_cover ROM_WRAP_RD_cover_i = new;
// synopsys translate_on

