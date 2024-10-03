#To obtain SGCDC abstracts

source scripts/uniquifyme <prefix>
#Update the scripts/ip_override_sgcdc_params.txt to override the top level RTL parameters. If no override, leave it as it is
perl scripts/gen_sgcdc_paramterized_opt.pl <prefix>
source scripts/buildme
