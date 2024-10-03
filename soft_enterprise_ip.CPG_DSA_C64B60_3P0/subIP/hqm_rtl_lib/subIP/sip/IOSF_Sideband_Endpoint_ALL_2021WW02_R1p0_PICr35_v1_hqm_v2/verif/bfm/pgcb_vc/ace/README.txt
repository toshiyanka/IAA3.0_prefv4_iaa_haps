In your UDF file add the package as follows if ChassisPOwerGatingVIP is in the verif/lib/shared dir in your IP.

ChassisPowerGatingVIP => {
-hdl_spec => ['verif/lib/shared/ChassisPowerGatingVIP/ace/ChassisPowerGatingVIP.hdl],
-dependent_libs => [
'ovm_pkg',
'sla_pkg',
],         
      -tag => 'nonsynth'
},

