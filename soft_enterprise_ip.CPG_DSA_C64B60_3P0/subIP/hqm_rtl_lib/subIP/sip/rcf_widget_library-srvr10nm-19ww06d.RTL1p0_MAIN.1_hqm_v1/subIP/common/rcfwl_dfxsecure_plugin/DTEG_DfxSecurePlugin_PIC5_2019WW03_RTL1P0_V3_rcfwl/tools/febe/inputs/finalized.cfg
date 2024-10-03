# -*-cperl-*-
BEGIN {
  unshift @INC, ("$ENV{REPO_ROOT}/tools/febe/inputs/finalized","$ENV{REPO_ROOT}/tools/febe/inputs");
}

package finalized;

use dfxsecure_plugin_final_cfg;

sub get_data() {

     return {
	dfxsecure_plugin => $dfxsecure_plugin_final_cfg::dc_cfg ,

	COMMON_CFG => {
		-lib_variant => 'ln,nn,wn',
		-stdlib_type => 'd04',
		-defines=> [],
	},

	 'CTECH' => {
      -path => '$env(CTECH_LIBRARY)/source/$env(PROCESS)/',
         },

  }
}

1;
