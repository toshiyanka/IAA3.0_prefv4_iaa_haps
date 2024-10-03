#!/usr/bin/csh
# comm file: /nfs/iind/disks/mg_disk0866/vsavitrx/ip-stap_cnplp/tools/syn/CNPLP/stap.rtl_files.comm

set SO=0
set XSETUP=0
set RUNOPT="-init -stop syn_final;exit"
foreach i ($argv)
  if ($#argv > 0) then
     switch($i)
           case "-so" :
              set SO=1
              breaksw
           case "-xsetup" :
              set XSETUP=1
              breaksw
		   case "-runopt" :
		      shift
		      set RUNOPT="$1"
		      breaksw
     endsw
	 shift
endif
end

if ( "$RUNOPT" =~ "-load "* && $SO != 1 ) then
	set XSETUP=1
endif

#SYN WARD: /nfs/iind/disks/mg_disk0866/vsavitrx/ip-stap_cnplp/tools/syn/CNPLP/stap

setenv UNIT stap
setenv KIT_PATH /p/kits/intel/p1273/p1273_1.7.0

source /nfs/iind/proj/sip/syn/reggie/2.0.0/scripts/syn/syn_setup.csh.v6

if ( $? != 0 ) then
   exit 1
endif

# process log
set plog = syn.`date +%F'_'%T`.log 
touch $plog

# creating directory
set ERR=0
if ( $XSETUP == 0 ) then
	echo 'Running : /nfs/iind/proj/sip/syn/reggie/2.0.0/scripts/syn/syn_mkdir.pl.v6 -sfo "/p/sip/syn/scripts/CNPLP/sd0p8/override.tcl;/nfs/iind/disks/mg_disk0866/vsavitrx/ip-stap_cnplp/tools/syn/CNPLP/stap.sfo" -comm /nfs/iind/disks/mg_disk0866/vsavitrx/ip-stap_cnplp/tools/syn/CNPLP/stap.rtl_files.comm' |& tee -a $plog
	/nfs/iind/proj/sip/syn/reggie/2.0.0/scripts/syn/syn_mkdir.pl.v6 -sfo "/p/sip/syn/scripts/CNPLP/sd0p8/override.tcl;/nfs/iind/disks/mg_disk0866/vsavitrx/ip-stap_cnplp/tools/syn/CNPLP/stap.sfo" -comm /nfs/iind/disks/mg_disk0866/vsavitrx/ip-stap_cnplp/tools/syn/CNPLP/stap.rtl_files.comm |& tee -a $plog
	if ( $? != 0 ) set ERR=1
endif


if ( $SO == 0 ) then
if ( $ERR == 0 ) then
	# running synthesis
	echo 'Running : DC' |& tee -a $plog
	
	source /p/com/env/psetup/prod/bin/setupTool designcompiler I-2013.12-SP2 
	setenv SNPSLMD_DISABLE_DEBUG_LICENSE_CHECKS 1
	dc_shell-t -topo -x "source $RUNTCL;runRDT $RUNOPT" |& tee -a $plog
endif
endif

exit
