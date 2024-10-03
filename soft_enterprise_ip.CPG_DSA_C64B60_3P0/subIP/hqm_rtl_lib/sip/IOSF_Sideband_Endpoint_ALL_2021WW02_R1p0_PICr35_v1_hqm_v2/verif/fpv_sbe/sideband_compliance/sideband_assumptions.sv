//assumption added so that fabric will issue cups during credit_init state
property tnpcup_crd_init_value;
  @(posedge side_clk) ( side_ism_fabric == 5 ) |-> (mnpcup != 0);
endproperty
tnpcup_crd_init_value_assume: assume property (tnpcup_crd_init_value);

property tpccup_crd_init_value;
  @(posedge side_clk) ( side_ism_fabric == 5 ) |-> (mpccup != 0);
endproperty
tpccup_crd_init_value_assume: assume property (tpccup_crd_init_value);


