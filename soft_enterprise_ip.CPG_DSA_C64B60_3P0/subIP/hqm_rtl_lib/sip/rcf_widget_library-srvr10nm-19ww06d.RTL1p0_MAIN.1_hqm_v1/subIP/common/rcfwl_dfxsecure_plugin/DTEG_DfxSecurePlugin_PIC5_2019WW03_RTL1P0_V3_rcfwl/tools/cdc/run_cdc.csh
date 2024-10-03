setenv IP_ROOT $cwd
cd tools/cdc
tsetup zeroin V10.0b_1
source /nfs/site/eda/group/cse/setups/mentor/mentor.dft
0in -od $IP_ROOT/pwa/cdc/reports_cdc -cmd cdc -f $IP_ROOT/tools/cdc/dfxsecure_plugin.f -d dfxsecure_plugin -ctrl $IP_ROOT/tools/cdc/dfxsecure_plugin_ctrl.v
cd $IP_ROOT
unsetenv IP_ROOT
