set dirName = $argv[1]
set cust = $argv[2]
set cust_up = ` echo $cust | tr "[a-z]" "[A-Z]" `

mkdir -p $dirName

cd $dirName
dteg_clone -ip_name stap
cd dteg-stap
git pull
source /p/hdk/rtl/hdk.rc -cfg sip
setenv VCS_VERSION `ToolConfig.pl get_tool_version vcsmx`
setenv VCS_HOME /p/hdk/rtl/cad/x86-64_linux26/synopsys/vcsmx/$VCS_VERSION
source /nfs/site/eda/group/cse/setups/synopsys/synopsys.lic
setenv IP_ROOT $cwd
setenv MODEL_ROOT $IP_ROOT
cd $IP_ROOT
simbuild -dut stap -ace_args source scripts/run_all_configs -ace_args- -1c -CUST ADL -1c-
cd $IP_ROOT

