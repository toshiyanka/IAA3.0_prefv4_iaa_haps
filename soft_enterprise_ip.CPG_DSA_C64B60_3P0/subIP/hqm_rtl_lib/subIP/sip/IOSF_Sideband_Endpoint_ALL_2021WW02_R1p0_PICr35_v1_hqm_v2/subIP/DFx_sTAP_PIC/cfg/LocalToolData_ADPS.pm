# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
use warnings FATAL => 'all';
package ToolData;
 
my %LocalToolData = (

intelcdc => { VERSION => q(v20181212) },
ctech    => { VERSION => q(c2v16ww47e_hdk141_adps_v19ww02b) },


   tsa_dc_config => {
      DC => {
      -setenv => {
                     PROJECT_FLOW_PATH => q($PROJECT_RDT_COMMON_PATH/s14nm),
                 },
      },
   	   'SETUP' => {
		-be_tool_override => {
             rdt_sd_common_overrides => q(siphdk_mat14_19.02.01),
             sd_build => q(16.4.3.p12),
	    },
	   },
   },
 
   tsa_finalized => {
       finalized => {
       stap      => {
              -lib_variant     => "rvt,lvt",  
              -stdlib_type     => "&get_facet(STDLIB_TYPE)",
        },
      },
   },
);
 
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);
 
1;
