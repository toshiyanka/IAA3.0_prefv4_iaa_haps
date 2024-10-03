#!/bin/tcsh

goto INIT

INIT:
set thisToolName="$thisToolName(ephelper)"

set rtlcfg=""
set topdir=""
set ignore="NO"
set debug=0
set exitstatus=0

set gentool=""
set tooldir=""
set rtltop=""
set async_ep=0
set rp_en=0
set latch=0
set configfile=""
set process=""
set rtlparameterstring=""
set rtlparameterlist=""
set srctooldir=""
set dsttooldir=""

goto MAIN

ERROR:
set exitstatus=1

EXIT:
if( $debug == 1 ) echo "$thisToolName -D- Completed with status code (${exitstatus})"
set thisToolName=`echo "$thisToolName" | perl -pe 's/.*\((.*)\).*/$1/g'`
if( $debug == 1 ) echo "$thisToolName -D- Restored thisToolName to $thisToolName"
exit $exitstatus

HELP:
echo "usage: source $thisToolName"
echo "       -gentool <toolname>        Generate the colateral for the tool <toolname>"
echo "       -process <process>         When generating colateral for -tool keep the process in mind"
echo "       -rtlcfg  <rtlname_cfgname> Provides the RTLTOP name and the configuration to used"
echo "       -tooldir <tooldir>         Directory where the tool colateral lives if different from gentool"
echo "       -topdir  <sbe_dir>         Directory path to the RTLTOP"
echo "       -help                      Displays this help"
echo "       -debug                     Displays extra debug prints"
echo "generates:"
echo "       configfile                 Configuration file used"
echo "       rtlparameterlist           TCSH list object of parameters"
echo "       rtlparameterstring         Comma delimited string of parameters"
echo "       rtltop                     RTL top name from the configuration input"
echo "       async_ep                   0 = sync endpoint; 1 = async endpoint"
echo "       rp_en                      0 = legacy async fifo; 1 = relative placement ram;"
echo "       latch                      0 = legacy async fifo; 1 = latch based design;"
echo "       srctooldir                 Host configuration to copy"
echo "       dsttooldir                 Destination tool directory."

goto EXIT

MAIN:

foreach arg ($argv)
   if( $debug == 1 ) echo "$thisToolName -D- Parsing input argument $arg"

   if( $ignore == "rtlcfg" ) then
      set ignore="NO"
      set rtlcfg=$arg
   else if( $ignore == "topdir" ) then
      set ignore="NO"
      set topdir=$arg
   else if( $ignore == "gentool" ) then
      set ignore="NO"
      set gentool=$arg
   else if( $ignore == "tooldir" ) then
      set ignore="NO"
      set tooldir=$arg
   else if( $ignore == "process" ) then
      set ignore="NO"
      set process=$arg
   else if( "$arg" == '-gentool' ) then
      set ignore="gentool"
   else if( "$arg" == '-tooldir' ) then
      set ignore="tooldir"
   else if( "$arg" == '-rtlcfg' ) then
      set ignore="rtlcfg"
   else if( "$arg" == '-topdir' ) then
      set ignore="topdir"
   else if( "$arg" == '-process' ) then
      set ignore="process"
   else if( "$arg" == '-h' || "$arg" == '-help' ) then
      goto HELP
   else if( "$arg" == '-debug' ) then
      set debug=1
   else
      echo "$thisToolName -W- Ignoring argument $arg. ($thisToolName)"
   endif
end

if( $debug == 1 ) echo "$thisToolName -D- Checking Manditory Inputs"

if( $rtlcfg == "" ) then
   echo "$thisToolName -E- '-rtlcfg' switch is missing"
   set exitstatus=1
   goto HELP
else if( $topdir == "" ) then
   echo "$thisToolName -E- '-topdir' switch is missing"
   set exitstatus=1
   goto HELP
endif

if( $debug == 1 ) echo "$thisToolName -D- Parsing rtlcfg"

if( $debug == 1 ) echo "$thisToolName -D- Pulling configuration for RTL(${rtltop}) CFG(${rtlcfg})"

if( ${rtlcfg} == "" ) then
   echo "$thisToolName -E- '-rtlcfg' missing is or "
   goto ERROR
else
   set configfile="${topdir}/source/cfg/endpoint/csv/${rtlcfg}.csv"

   if( -r ${configfile} ) then
      set rtltop=""
      foreach line ( "`cat ${configfile}`" )
         set line = "$line:gas/,/ /"
         set argv = ( $line )

         if ($1 == "RTLTOP") then
            set rtltop=$2
         else if ($1 == "PARAM") then
            set rtlparameterstring="${rtlparameterstring}$2=$3,"
            set rtlparameterlist=("${rtlparameterlist}" "$2=$3")
            if ($2 == "ASYNCENDPT" && $3 == 1) then
               set async_ep = 1
            endif
            if ($2 == "RELATIVE_PLACEMENT_EN" && $3 == 1) then
               set rp_en = 1
            endif
            if ($2 == "LATCHQUEUES" && $3 == 1) then
                set latch = 1
            endif
            
         else if ($1 == "COMMENT") then
            shift
            set comment=""
            while ( $#argv > 0 )
               set comment="$comment $1"
               shift
            end
            echo "$thisToolName -I- $comment"
            unset comment
         endif
      end
      set rtlparameterstring="$rtlparameterstring "
      set rtlparameterstring="$rtlparameterstring:gas/, //"
      if ($rtltop == "") then
         echo "$thisToolName -E- config file $configfile does not define RTLTOP"
         goto ERROR
      endif
   else
      echo "$thisToolName -E- '-rtlcfg' (${rtlcfg}) does not infer an existing configuration ${configfile}"
      goto ERROR
   endif
endif

if( $debug == 1 ) echo "$thisToolName -D- Generate Tool File Area"

if( $gentool != "" ) then
   if( ${tooldir} == "" ) then
      echo "$thisToolName -E- '-tooldir' was not configured when gentool was defined"
      goto ERROR
   endif

   set srctooldir="${topdir}/tools/${tooldir}"
   if( ${process} != "" ) set srctooldir="${srctooldir}/${tooldir}_${process}"
   set dsttooldir="${srctooldir}/${rtlcfg}"
   set srctooldir="${srctooldir}/${rtltop}"

   if( ${rtlcfg} == ${rtltop} ) then
      echo "$thisToolName -I- Will not re-generate collateral for default configurations"
   else
      if( ! -d ${srctooldir} ) then
         echo "$thisToolName -E- Could not discover the tool directory ${srctooldir} for ${rtltop} configuration ${rtlcfg}"
         goto ERROR
      endif
      
      if( -d ${dsttooldir} ) then
         echo "$thisToolName -I- Tool files for ${gentool} already generated for ${rtltop} configuration ${rtlcfg}"
      else
         echo "$thisToolName -I- Generating ${dsttooldir}"
         cp ${srctooldir} ${dsttooldir} -r
      endif
   endif
endif

goto EXIT


