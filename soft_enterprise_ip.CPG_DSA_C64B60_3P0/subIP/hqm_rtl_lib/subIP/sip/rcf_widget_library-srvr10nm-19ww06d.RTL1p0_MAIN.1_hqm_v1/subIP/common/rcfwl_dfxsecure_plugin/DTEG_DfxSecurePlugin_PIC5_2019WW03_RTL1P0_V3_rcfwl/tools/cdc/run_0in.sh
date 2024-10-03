cd $IP_ROOT
mkdir -p $IP_ROOT/pwa/cdc
cd $IP_ROOT/pwa/cdc
#0in -od reports_cdc -cmd cdc -report_clock -report_sdc -f dfxsecure_plugin.f -d dfxsecure_plugin -ctrl ctrl.v -sv -ignore_translate_off
# 0in_cdc -od reports_cdc -f dfxsecure_plugin.f -d dfxsecure_plugin -ctrl ctrl.v
### Source the license
source $IP_ROOT/tools/cdc/setup.sh
0in -od $IP_ROOT/pwa/cdc/reports_cdc -cmd cdc  -f $IP_ROOT/tools/cdc/dfxsecure_plugin.f -d dfxsecure_plugin -ctrl $IP_ROOT/tools/cdc/dfxsecure_plugin_ctrl.v -ctrl $IP_ROOT/tools/cdc/dfxsecure_plugin_waiver_ctrl.v
cd $IP_ROOT
