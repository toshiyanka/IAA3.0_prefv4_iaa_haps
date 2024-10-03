CNL:
#To run lintra compile
simbuild -dut dfxsecure_plugin -ace_args ace -ccolt -ASSIGN -mc=dfxsecure_plugin_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -nf -1c -CUST CNL -1c-

#To run lintra elab
simbuild -dut dfxsecure_plugin -ace_args ace -sc -t lintra/dfxsecure_plugin -pwa pwa_lint -lintra_exe_opts '-r 50514 -r 60088 -r 68094' -ace_args- -nf -1c -CUST CNL -1c-

echo "INFO: Copying the required lint log files to tools/lint folder Zircon and SoC required file delivery."
\cp -f ../../target/dfxsecure_plugin/CNL/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/lintra.filelist . 
\cp -f ../../target/dfxsecure_plugin/CNL/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/dfxsecure_plugin.lintra.violations .
\cp -f ../../target/dfxsecure_plugin/CNL/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/dfxsecure_plugin_violations.xml . 
\cp -f ../../target/dfxsecure_plugin/CNL/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/lintra_dfxsecure_plugin_Ace_TestMan_RTLSim_*.log run_lintra.log

CDF:
#To run lintra compile

simbuild -dut dfxsecure_plugin -ace_args ace -ccolt -ASSIGN -mc=dfxsecure_plugin_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -nf -1c -CUST CDF -1c-
#To run lintra elab
simbuild -dut dfxsecure_plugin -ace_args ace -sc -t lintra/dfxsecure_plugin -pwa pwa_lint -lintra_exe_opts '-r 50514 -r 60088 -r 68094' -ace_args- -nf -1c -CUST CDF -1c-
echo "INFO: Copying the required lint log files to tools/lint folder Zircon and SoC required file delivery."
\cp -f ../../target/dfxsecure_plugin/CDF/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/lintra.filelist . 
\cp -f ../../target/dfxsecure_plugin/CDF/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/dfxsecure_plugin.lintra.violations .
\cp -f ../../target/dfxsecure_plugin/CDF/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/dfxsecure_plugin_violations.xml . 
\cp -f ../../target/dfxsecure_plugin/CNL/aceroot/pwa_lint/results/tests/lintra_dfxsecure_plugin/lintra_dfxsecure_plugin_Ace_TestMan_RTLSim_*.log run_lintra.log
