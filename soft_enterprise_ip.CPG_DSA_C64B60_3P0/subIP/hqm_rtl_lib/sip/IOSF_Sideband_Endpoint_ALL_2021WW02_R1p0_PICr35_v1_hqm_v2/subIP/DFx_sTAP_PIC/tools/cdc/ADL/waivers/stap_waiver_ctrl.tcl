#module stap_waiver_ctrl;
#//power good reset will not have any reset synchroniser
#
cdc report crossing -scheme no_sync -from fdfx_powergood -to tap_rtdr_powergood -module stap -severity waived 
cdc promote crossing -scheme no_sync -from fdfx_powergood -to tap_rtdr_powergood -module stap -promotion off 
#
cdc report crossing -scheme no_sync -from fdfx_powergood -to *dfxsecure_feature_lch*  -module stap  -severity waived 
cdc report crossing -scheme async_reset_no_sync -module stap -severity waived 
cdc promote crossing -scheme async_reset_no_sync -module stap -promotion off 
#endmodule
