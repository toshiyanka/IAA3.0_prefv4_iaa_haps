#set_property MUXF_REMAP TRUE [get_cells -hier  -filter { NAME =~ *_bees_knees_* && REF_NAME == MUXF8 }]
#Old set_property CARRY_REMAP 3 [get_cells -hier  -filter { NAME =~ *_bees_knees_* && REF_NAME == CARRY8 }]
set_property CARRY_REMAP 6 [get_cells -hier  -filter { NAME =~ *_bees_knees_* && REF_NAME == CARRY8 }]
set_property MUXF_REMAP TRUE [get_cells -hier  -filter { NAME =~ *_bees_knees_* && PRIMITIVE_SUBGROUP == MUXF }] 
