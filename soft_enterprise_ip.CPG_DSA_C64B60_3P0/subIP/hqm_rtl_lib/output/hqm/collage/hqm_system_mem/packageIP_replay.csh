#!/bin/csh
setenv WORKAREA /nfs/site/disks/ncsg_00170/users/jkerth/hqm-srvrgen4 
setenv LD_LIBRARY_PATH /p/dt/sde/tools/em64t_SLES12/syslibs/for_sles12 
setenv OUTPUT_DIR /nfs/site/disks/ncsg_00170/users/jkerth/hqm-srvrgen4/output/hqm/collage//hqm_system_mem 
setenv PASS  
setenv TOP_MODULE hqm_system_mem 
setenv DUT hqm 
setenv COLLAGE_ROOT /p/hdk/rtl/cad/x86-64_linux30/intel/collage/5.53 
setenv BUS_INTERFACE_DEF /p/hdk/rtl/cad/x86-64_linux30/intel/bus_interface_defs/0.15
setenv COLLAGE_INTF_DEF /p/hdk/rtl/cad/x86-64_linux30/intel/collage_intf_def/3.9.7 
setenv SDG_INTERFACE_DEFS /p/hdk/rtl/proj_tools/interface_defs/20.13.23 
setenv COLLAGE_PORT_WITH_COMPNAME 1 
setenv COLLAGE_BATCH_MODE_EXIT 1 
setenv SNPSLMD_LICENSE_FILE 26586@synopsys123p.elic.intel.com:26586@synopsys128p.elic.intel.com:26586@synopsys20p.elic.intel.com:26586@synopsys39p.elic.intel.com:26586@synopsys55p.elic.intel.com:26586@synopsys01b.elic.intel.com:26586@synopsys01p.elic.intel.com:26586@synopsys03p.elic.intel.com:26586@synopsys33p.elic.intel.com:26586@synopsys34p.elic.intel.com:26586@synopsys16p.elic.intel.com:26586@synopsys54p.elic.intel.com:26586@synopsys50p.elic.intel.com:26586@synopsys40p.elic.intel.com:26586@synopsys60p.elic.intel.com:26586@synopsys14p.elic.intel.com:26586@synopsys29p.elic.intel.com:26586@synopsys22p.elic.intel.com:26586@synopsys23p.elic.intel.com:26586@synopsys37p.elic.intel.com:26586@synopsys10p.elic.intel.com:26586@synopsys11p.elic.intel.com:26586@synopsys12p.elic.intel.com:26586@synopsys13p.elic.intel.com:26586@synopsys35p.elic.intel.com:26586@synopsys28p.elic.intel.com:26586@synopsys30p.elic.intel.com:26586@synopsys21p.elic.intel.com:26586@synopsys17p.elic.intel.com:26586@plxs0405.pdx.intel.com:26586@plxs0416.pdx.intel.com:26586@plxs0418.pdx.intel.com:26586@plxs0412.pdx.intel.com
setenv SNPSLMD_QUEUE true 
setenv CORE_TOOLS_DIR /p/hdk/rtl/cad/x86-64_linux30/synopsys/coretools/ 
setenv CORE_TOOLS_VER T-2022.06-SP2 
setenv COLLAGE_WORK $OUTPUT_DIR/work
setenv COLLAGE_IP_KITS $OUTPUT_DIR/gen/ip_kits
setenv COLLAGE_IP_REPORTS $OUTPUT_DIR/gen/reports
setenv COLLAGE_IPXACT $OUTPUT_DIR/gen/ipxact
/bin/mkdir -p $OUTPUT_DIR/
/bin/mkdir -p $OUTPUT_DIR/gen
/bin/mkdir -p $COLLAGE_WORK
/bin/rm -rf $COLLAGE_IP_KITS
/bin/mkdir $COLLAGE_IP_KITS
/bin/rm -rf $COLLAGE_IP_REPORTS
/bin/mkdir $COLLAGE_IP_REPORTS
/bin/rm -rf $OUTPUT_DIR/gen/ipxact
/bin/mkdir $OUTPUT_DIR/gen/ipxact
setenv CHASSIS_ROOT $COLLAGE_ROOT
setenv COLLAGE_CHASSIS_BOOTSTRAP $COLLAGE_ROOT/tools/collage/utils/chassis_bootstrap.tcl  
setenv CTH_QUIET_MODE True
setenv CTH_GK_MODE True
cd $COLLAGE_WORK; 
$CORE_TOOLS_DIR/$CORE_TOOLS_VER/bin/coreBuilder -timeout 10 -shell -no_home_init -x "source $COLLAGE_ROOT/core/common/tcl/collage_init.tcl" -f /nfs/site/disks/ncsg_00170/users/jkerth/hqm-srvrgen4/integration/collage/script/builder.hqm_system_mem.tcl
echo "TCL Script Exit Status - $status"
/bin/rm -rf $WORKAREA/integration/collage/output 
