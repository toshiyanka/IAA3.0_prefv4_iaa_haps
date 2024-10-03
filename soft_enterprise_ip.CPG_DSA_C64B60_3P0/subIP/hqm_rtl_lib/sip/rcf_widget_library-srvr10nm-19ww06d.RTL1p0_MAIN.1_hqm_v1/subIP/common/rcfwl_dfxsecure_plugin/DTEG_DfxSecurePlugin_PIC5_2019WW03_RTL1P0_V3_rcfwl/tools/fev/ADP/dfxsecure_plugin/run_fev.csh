#!/usr/bin/csh
set SO=0
set SETUP=0
set DEBUG=0
set RUNOPT="-init -stop report"
foreach i ($argv)
  if ($#argv > 0) then
     switch($i)
           case "-so" :
              set SO=1
              breaksw
           case "-setup" :
              set SETUP=1
              breaksw
		   case "-runopt" :
		      shift
		      set RUNOPT="$1"
		      breaksw
           case "-debug" :
              set DEBUG=1
              breaksw
     endsw
	 shift
endif
end

# turn on setup if -so chosen
if ( $SO == 1 ) then
    set SETUP=1
endif

# do not run setup if loading design
if ( "$RUNOPT" =~ "-load "* && $SO != 1 ) then
	set XSETUP=1
endif

if ( "$RUNOPT" =~ *";"*"exit"*) then
   echo "Command 'exit' is not allowed in RDTFev, renmove it from run option"
   set RUNOPT=`echo "$RUNOPT" | perl -ne '$_=~ /(.*)\;\s*exit\s*/; print "$1\n"'`
endif

setenv UNIT cltapc
source /p/sip/syn/reggie/latest/scripts/fev/fev_setup.csh.v1

if ( $? != 0 ) then
   exit 1
endif

# process log
set plog = fev.`date +%F'_'%T`.log 
touch $plog

# creating directory
set ERR=0
if ( $SETUP == 1 && $DEBUG == 0) then
	echo "Running : /p/sip/syn/reggie/latest/scripts/fev/fev_mkdir.pl.v4  -comm /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/tools/syn/CNPLP/cltapc.rtl_files.comm -syn_dir /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/tools/syn/CNPLP/cltapc " |& tee -a $plog
	/p/sip/syn/reggie/latest/scripts/fev/fev_mkdir.pl.v4  -comm /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/tools/syn/CNPLP/cltapc.rtl_files.comm -syn_dir /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/tools/syn/CNPLP/cltapc |& tee -a $plog
    if ( $? != 0 ) set ERR=1
endif

if ( $SO == 0 ) then
   if ( $ERR == 0 ) then
   if ( $DEBUG == 0 ) then
	  # running FEV
	  echo "Running : FEV (runRDT $RUNOPT)" |& tee -a $plog
	  setenv SIP_FEV_RUNOPT "$RUNOPT"
	  /p/com/env/psetup/prod/bin/jlaunch -tv conformal:12.10.420 -com "lec -64 -nogui -tclmode -xl -lp -1801 -do /p/sip/syn/reggie/latest/scripts/fev/run_fev.do" |& tee -a $plog
	  unsetenv SIP_FEV_RUNOPT
   else
	  # debug FEV
	  /p/com/env/psetup/prod/bin/jlaunch -tv conformal:12.10.420 -com "lec -64 -tclmode -xl -lp -1801 -do /p/sip/syn/reggie/latest/scripts/fev/debug_fev.do" |& tee -a $plog
   endif
   endif
endif

exit
