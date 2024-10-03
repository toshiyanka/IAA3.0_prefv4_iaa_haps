package dc_config;
use strict;
use warnings;


sub get_data {
  my %tsa_dc_config = (
                   vclp_build => {
                                       "-command" => "unsetenv SB_STDCELLS_HDL && ace -ccvclp -ASSIGN -mc=cdc_sbendpoint "
                                     },
                   vclp_test => {
                                    "-ace_args" => "",
                                    "-args" => "-ASSIGN -mc=cdc_sbendpoint",
                                    "-test_dir" => "vclp/",
                                    "-test_suffix" => ""
                                  }
                 );

  return \%tsa_dc_config
}
1;
