echo $cwd
setenv IP_ROOT $cwd/../
setenv SFM_PATH $cwd
source setup
cd ${IP_ROOT}/scripts/qa
echo $cwd
\cp -r summary.rpt summary.rpt.old
\rm -rf summary.rpt
touch summary.rpt
alias tsetup  "source /p/com/env/psetup/prod/bin/setupTool"
echo "Running the regression .."
./runSim
echo "Running the Lintra .."
#./runLint
echo "Not present in this release"
echo "Running the CDC .."
#./runCdc
echo "Not present in this release"
echo "Running the Syn .."
#./runSynth
echo "Not present in this release"
echo "Running the GLS .."
#./runGLS
echo "Not present in this release"
echo "Running the Scan Coverage .."
#./runScanCov
echo "Not present in this release"
mutt -s "ip-jtag-bfm : SFM summary" pavan.n.m@intel.com puneetx.dubey@intel.com shivaprashant.bulusu@intel.com mohanx.k.gangadharappa@intel.com < ${SFM_PATH}/qa/summary.rpt 
echo "Done Please check your mail box ..."
