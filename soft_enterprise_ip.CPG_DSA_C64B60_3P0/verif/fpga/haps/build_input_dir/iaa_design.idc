device prepare_incremental 1
#iice new {IICE_0} -type regular -mode {none} -uc_groups {}
#iice controller -iice {IICE_0} none
#iice sampler -iice {IICE_0} -compression 1
#iice sampler -iice {IICE_0} -depth 2048
#iice clock -iice {IICE_0} -edge positive {uhfi_ref_top.dsab_ip.prim_clk}

iice new {IICE_0} -type regular
iice controller -iice {IICE_0} statemachine
iice controller -iice {IICE_0} -triggerstates 8
iice controller -iice {IICE_0} -triggerconditions 8
iice controller -iice {IICE_0} -counterwidth 12
iice sampler -iice {IICE_0} -always_armed 1
iice sampler -iice {IICE_0} -qualified_sampling 1
iice sampler -iice {IICE_0} -compression 1
iice sampler -iice {IICE_0} -depth 2048
iice sampler -iice {IICE_0} -pipe 4
iice clock -iice {IICE_0} -edge positive {uhfi_ref_top.iaab3p0s64b60_ip.prim_clk}
