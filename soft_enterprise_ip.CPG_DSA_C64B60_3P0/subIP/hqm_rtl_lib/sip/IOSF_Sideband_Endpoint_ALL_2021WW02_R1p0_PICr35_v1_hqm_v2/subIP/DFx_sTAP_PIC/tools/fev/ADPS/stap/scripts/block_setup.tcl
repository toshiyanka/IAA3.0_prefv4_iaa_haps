set G_LIBRARY_TYPE d04
set G_FV_LP 1
vpx set flatten model -seq_constant
vpx set flatten model -SEQ_CONSTANT_X_TO 0
vpx set flatten model
setvar G_MAX_VOLTAGE_MAP(vss) 0
setvar G_MIN_VOLTAGE_MAP(vss) 0
unsetvar G_MAX_VOLTAGE_MAP(VSS)
unsetvar G_MIN_VOLTAGE_MAP(VSS)
