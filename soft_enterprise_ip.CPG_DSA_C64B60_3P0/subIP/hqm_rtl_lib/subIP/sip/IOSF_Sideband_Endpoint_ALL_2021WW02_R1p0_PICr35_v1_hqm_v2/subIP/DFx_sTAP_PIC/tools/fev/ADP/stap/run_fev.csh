#!/usr/intel/bin/tcsh -f

cd $WARD/fev;



echo "WARD: $WARD"
echo "DBB: $DBB"
echo "FEV_PROJECT_FLOW_PATH: $FEV_PROJECT_FLOW_PATH"
echo "FEV_CONFORMAL: $FEV_CONFORMAL"
echo "FEV_FLOW_PATH: $FEV_FLOW_PATH"



$FEV_CONFORMAL/bin/lec_64 -nogui -xl -tclmode  -dofile $FEV_FLOW_PATH/bin/dofile/fev_run_all_exit.do

#cat $WARD/fev/reports/$DBB.summary.rpt

