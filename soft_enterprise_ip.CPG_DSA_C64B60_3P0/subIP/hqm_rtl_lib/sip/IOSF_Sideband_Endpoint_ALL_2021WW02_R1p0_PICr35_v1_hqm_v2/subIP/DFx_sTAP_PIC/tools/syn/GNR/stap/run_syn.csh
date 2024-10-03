#!/usr/bin/csh
# comm file: /nfs/iind/disks/mg_disk1264/sharmavi/ip-stap/tools/syn/CNL/stap.rtl_files.comm

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

#SYN WARD: /nfs/iind/disks/mg_disk1264/sharmavi/ip-stap/tools/syn/CNL/stap

setenv UNIT stap
setenv KIT_PATH /p/kits/intel/10nm/10nm_14.2.1

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
	echo 'Running : /nfs/iind/proj/sip/syn/reggie/2.0.0/scripts/syn/syn_mkdir.pl.v6 -sfo "/nfs/iind/disks/mg_disk1264/sharmavi/ip-stap/tools/syn/CNL/stap.sfo" -comm /nfs/iind/disks/mg_disk1264/sharmavi/ip-stap/tools/syn/CNL/stap.rtl_files.comm' |& tee -a $plog
	/nfs/iind/proj/sip/syn/reggie/2.0.0/scripts/syn/syn_mkdir.pl.v6 -sfo "/nfs/iind/disks/mg_disk1264/sharmavi/ip-stap/tools/syn/CNL/stap.sfo" -comm /nfs/iind/disks/mg_disk1264/sharmavi/ip-stap/tools/syn/CNL/stap.rtl_files.comm |& tee -a $plog
	if ( $? != 0 ) set ERR=1
endif


if ( $SO == 0 ) then
if ( $ERR == 0 ) then
	# running synthesis
	echo 'Running : DC' |& tee -a $plog
	
	/p/com/env/psetup/prod/bin/jlaunch -tv designcompiler:G-2012.06-SP5 -com "dc_shell-t -topo -x 'source $RUNTCL;runRDT $RUNOPT'" |& tee -a $plog
endif
endif

exit
