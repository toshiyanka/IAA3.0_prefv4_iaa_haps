#To obtain SGCDC abstracts

source scripts/uniquifyme <prefix>
#Update the scripts/ip_override_sgcdc_params.txt to override the top level RTL parameters. If no override, leave it as it is
perl /p/hdk/rtl/cad/x86-64_linux30/dteg/ip_utils/2019ww03/sgcdc/gen_sgcdc_paramterized_opt.pl <prefix> , Then type in the corresponding IP name
source scripts/buildme
