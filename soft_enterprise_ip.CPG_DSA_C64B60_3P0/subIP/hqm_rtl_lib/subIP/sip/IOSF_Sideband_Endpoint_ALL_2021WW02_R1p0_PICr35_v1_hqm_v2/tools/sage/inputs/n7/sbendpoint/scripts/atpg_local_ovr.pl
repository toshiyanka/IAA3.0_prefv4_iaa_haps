$ENV{LM_PROJECT}="EIG_FABRIC";

#$ENV{ATPG_VIEW_STEP_EXECUTION} = "1";
$ENV{ATPG_VIEW_STEP_EXECUTION} = "0";

$ENV{MGLS_LICENSE_FILE} = "1717\@mentor15p.elic.intel.com:1717\@mentor06p.elic.intel.com";
$ENV{ATPG_STOP} = "ATPG_PATTERN_GEN";
$ENV{ATPG_BOUNDARY_MASK} = "nomask";
$ENV{ATPG_PROJECT} = "p1274";

$ENV{ATPG_ARRAY_MODE} = "noram";

#$ENV{ATPG_DIST_COMP} = "on";
#$ENV{ATPG_DIST_COMP_DOFILE} = "$ENV{MODEL_ROOT}/tools/sage/inputs/$ENV{ATPG_PROJECT}/sage_dist_comp.do";
#$ENV{POST_RUN_DOFILE} = "$ENV{MODEL_ROOT}/tools/sage/inputs/$ENV{ATPG_PROJECT}/sbendpoint/scripts/sbendpoint.post.do";

#$ENV{ATPG_INTERACTIVE_MODE} = "on";
$ENV{ATPG_INTERACTIVE_MODE} = "off";
$ENV{ATPG_FAULT_DISPOSITION} = "on";

$ENV{ATPG_FAULT_MODE} = "atspeed";
$ENV{ATPG_FAULT_MODE} = "stuckat";

