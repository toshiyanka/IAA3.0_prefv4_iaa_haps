#module stap_ctrl;
#
#cdc preference reconvergence -depth 2
#cdc preference -detect_pure_latch_clock
cdc preference -filtered_report
#
netlist clock ftap_tck -period 10 -group grp_ftap_tck -module stap 
netlist clock tap_rtdr_tck -period 10 -group grp_ftap_tck -module stap 
netlist clock ftapsslv_tck -period 5 -group grp_ftapsslv_tck -module stap 
netlist clock sntapnw_ftap_tck -period 10 -group grp_ftap_tck -module stap 
netlist clock sntapnw_ftap_tck2 -period 5 -group grp_ftapsslv_tck -module stap 
netlist clock stap_fbscan_tck -period 10 -group grp_ftap_tck -module stap 
netlist clock fdfx_policy_update -period 10 -group grp_policy_update -module stap 
#netlist clock fdfx_earlyboot_exit -period 10 -group grp_policy_update -module stap 
netlist port domain ftap_trst_b -clock ftap_tck -module stap 
netlist port domain ftap_pwrdomain_rst_b -clock ftap_tck -module stap 
netlist port domain ftapsslv_trst_b -clock ftapsslv_tck -module stap 
netlist port domain fdfx_powergood -async -module stap 
netlist port domain sntapnw_ftap_trst_b -clock ftap_tck -module stap 
netlist port domain sn_fwtap_wrst_b -clock ftap_tck -module stap 
netlist port domain tap_rtdr_powergood -async -module stap 
cdc signal ftap_slvidcode* -stable -module stap 
cdc signal fdfx_secure_policy* -stable -module stap 
cdc signal dfxsecure_feature_en* -stable -module stap 
cdc signal visa_all_dis* -stable -module stap 
cdc signal visa_customer_dis* -stable -module stap 
netlist port domain ftap_tms -clock ftap_tck -module stap 
netlist port domain ftap_tdi -clock ftap_tck -module stap 
netlist port domain tdr_data_in* -clock ftap_tck -module stap 
netlist port domain sntapnw_atap_tdo -clock ftap_tck -module stap 
netlist port domain sntapnw_atap_tdo_en -clock ftap_tck -module stap 
netlist port domain ftapsslv_tms -clock ftapsslv_tck -module stap 
netlist port domain ftapsslv_tdi -clock ftapsslv_tck -module stap 
netlist port domain sntapnw_atap_tdo2 -clock ftapsslv_tck -module stap 
netlist port domain sntapnw_atap_tdo2_en* -clock ftapsslv_tck -module stap 
netlist port domain sn_awtap_wso* -clock ftap_tck -module stap 
netlist port domain stap_fbscan_tdo -clock ftap_tck -module stap 
netlist port domain rtdr_tap_tdo* -clock ftap_tck -module stap 
netlist port domain stap_abscan_tdo* -clock ftap_tck -module stap 
netlist port domain atap_tdo* -clock ftap_tck -module stap 
netlist port domain tdr_data_out* -clock ftap_tck -module stap 
netlist port domain sftapnw_ftap_secsel* -clock ftap_tck -module stap 
netlist port domain sftapnw_ftap_enabletdo* -clock ftap_tck -module stap 
netlist port domain sftapnw_ftap_enabletap* -clock ftap_tck -module stap 
netlist port domain sntapnw_ftap_tms -clock ftap_tck -module stap 
netlist port domain sntapnw_ftap_tdi -clock ftap_tck -module stap 
netlist port domain sn_fwtap_wrck -clock ftap_tck -module stap 
netlist port domain sn_fwtap_capturewr -clock ftap_tck -module stap 
netlist port domain sn_fwtap_shiftwr -clock ftap_tck -module stap 
netlist port domain sn_fwtap_updatewr -clock ftap_tck -module stap 
netlist port domain sn_fwtap_rti -clock ftap_tck -module stap 
netlist port domain sn_fwtap_selectwir -clock ftap_tck -module stap 
netlist port domain sn_fwtap_wsi* -clock ftap_tck -module stap 
netlist port domain stap_fbscan_capturedr -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_shiftdr -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_updatedr -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_updatedr_clk -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_runbist_en -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_highz -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_extogen -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_chainen -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_mode -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_extogsig_b -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_d6init -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_d6actestsig_b -clock stap_fbscan_tck -module stap 
netlist port domain stap_fbscan_d6select -clock stap_fbscan_tck -module stap 
netlist port domain tap_rtdr_tdi -clock ftap_tck -module stap 
netlist port domain tap_rtdr_capture -clock ftap_tck -module stap 
netlist port domain tap_rtdr_shift -clock ftap_tck -module stap 
netlist port domain tap_rtdr_update -clock ftap_tck -module stap 
netlist port domain {tap_rtdr_irdec[1]} -clock ftap_tck -module stap 
netlist port domain tap_rtdr_selectir -clock ftap_tck -module stap 
netlist port domain tap_rtdr_rti -clock ftap_tck -module stap
netlist constant fdfx_earlyboot_exit 1'b1 -module stap
netlist constant stap_isol_en_b 1'b1 -module stap



hier parameter STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS             -range    0 1024
hier parameter STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ          -range    0 1024
hier parameter STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS               -range    0 1024048576
hier parameter STAP_NUMBER_OF_TOTAL_REGISTERS                        -range    0 1024
hier parameter STAP_NUMBER_OF_TEST_DATA_REGISTERS                    -range    0 1024
hier parameter STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK                    -range    0 1024
hier parameter STAP_NUMBER_OF_WTAPS_IN_NETWORK                       -range    0 1024
hier parameter STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS                -range    0 1
hier parameter STAP_SWCOMP_ACTIVE                                    -range    0 1
hier parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS                       -range    0 1000
hier parameter STAP_ENABLE_TDO_POS_EDGE                              -range    0 1
hier parameter STAP_ENABLE_BSCAN                                     -range    0 1
hier parameter STAP_ENABLE_TAPC_REMOVE                               -range    0 1
hier parameter STAP_RTDR_IS_BUSSED                                   -range    0 1
hier parameter STAP_ENABLE_ITDR_PROG_RST                             -range    0 1
hier parameter STAP_ENABLE_RTDR_PROG_RST                             -range    0 1
hier parameter STAP_ENABLE_WTAP_CTRL_POS_EDGE                        -range    0 1
hier parameter STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL    -range    0 1



hier parameter STAP_SIZE_OF_EACH_TEST_DATA_REGISTER          -range    0 'hFFFFFFFFFFFFFFFF
hier parameter STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS        -range    0 'hFFFFFFFFFFFFFFFF
hier parameter STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS        -range    0 'hFFFFFFFFFFFFFFFF
hier parameter STAP_NUMBER_OF_BITS_FOR_SLICE                 -range    1  256

hier parameter STAP_SECURE_GREEN                             -ignore    
hier parameter STAP_SECURE_ORANGE                            -ignore    
hier parameter STAP_SECURE_RED                               -ignore    
hier parameter STAP_DFX_SECURE_POLICY_SELECTREG              -ignore    
hier parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS           -ignore   
hier parameter STAP_DFX_EARLYBOOT_FEATURE_ENABLE             -ignore   
hier parameter STAP_DFX_SECURE_POLICY_MATRIX                 -ignore   
hier parameter STAP_SIZE_OF_EACH_INSTRUCTION                 -ignore   
hier parameter STAP_SUPPRESS_UPDATE_CAPTURE                  -ignore
hier parameter STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS      -ignore
hier parameter STAP_NUMBER_OF_MANDATORY_REGISTERS            -ignore
hier parameter STAP_WTAPCTRL_RESET_VALUE                     -ignore


