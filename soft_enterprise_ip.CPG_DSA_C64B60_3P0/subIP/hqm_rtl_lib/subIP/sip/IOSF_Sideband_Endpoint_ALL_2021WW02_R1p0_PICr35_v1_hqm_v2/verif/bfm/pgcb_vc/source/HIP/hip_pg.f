# Cadence IES irun file
-makelib mphytb_hip_pg_lib

$TB_ROOT/verif/bfm/hip_pg/src/hip_pg_if.sv
$TB_ROOT/verif/bfm/hip_pg/src/hip_pg_pkg.sv

-incdir $OVM_HOME/src
-incdir $OVM_HOME/src/macros
-incdir $TB_ROOT/verif/lib/mphy_utils
-incdir $TB_ROOT/verif/bfm/hip_pg/src

-endlib
