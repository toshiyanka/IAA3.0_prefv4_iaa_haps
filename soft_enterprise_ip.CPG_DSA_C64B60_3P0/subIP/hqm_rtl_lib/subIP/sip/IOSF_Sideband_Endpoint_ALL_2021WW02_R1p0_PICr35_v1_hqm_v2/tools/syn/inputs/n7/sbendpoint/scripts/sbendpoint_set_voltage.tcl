set SOC_SUPPLY_PORT "vccprim_core"
set SOC_GROUND_PORT "vss"
set SOC_SUPPLY_NOM   "0.675"
set GND_SUPPLY_NOM        "0.0"

set_voltage -object_list "$SOC_GROUND_PORT" $GND_SUPPLY_NOM
set_voltage -object_list "$SOC_SUPPLY_PORT"            -min $SOC_SUPPLY_NOM $SOC_SUPPLY_NOM
