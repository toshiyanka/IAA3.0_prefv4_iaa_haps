CNL:
#To run lintra compile
simbuild -dut stap -ace_args ace -ccolt -ASSIGN -mc=stap_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -nf -1c -CUST CNL -1c-

#To run lintra elab
simbuild -dut stap -ace_args ace -sc -t lintra/stap -pwa pwa_lint -lintra_exe_opts '-r 50514 -r 60088 -r 68094' -ace_args- -nf -1c -CUST CNL -1c-

echo "INFO: Copying the required lint log files to tools/lint folder Zircon and SoC required file delivery."
\cp -f ../../target/stap/CNL/aceroot/pwa_lint/results/tests/lintra_stap/lintra.filelist . 
\cp -f ../../target/stap/CNL/aceroot/pwa_lint/results/tests/lintra_stap/stap.lintra.violations .
\cp -f ../../target/stap/CNL/aceroot/pwa_lint/results/tests/lintra_stap/stap_violations.xml . 
\cp -f ../../target/stap/CNL/aceroot/pwa_lint/results/tests/lintra_stap/lintra_stap_Ace_TestMan_RTLSim_*.log run_lintra.log

CDF:
#To run lintra compile

simbuild -dut stap -ace_args ace -ccolt -ASSIGN -mc=stap_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -nf -1c -CUST CDF -1c-
#To run lintra elab
simbuild -dut stap -ace_args ace -sc -t lintra/stap -pwa pwa_lint -lintra_exe_opts '-r 50514 -r 60088 -r 68094' -ace_args- -nf -1c -CUST CDF -1c-
echo "INFO: Copying the required lint log files to tools/lint folder Zircon and SoC required file delivery."
\cp -f ../../target/stap/CDF/aceroot/pwa_lint/results/tests/lintra_stap/lintra.filelist . 
\cp -f ../../target/stap/CDF/aceroot/pwa_lint/results/tests/lintra_stap/stap.lintra.violations .
\cp -f ../../target/stap/CDF/aceroot/pwa_lint/results/tests/lintra_stap/stap_violations.xml . 
\cp -f ../../target/stap/CNL/aceroot/pwa_lint/results/tests/lintra_stap/lintra_stap_Ace_TestMan_RTLSim_*.log run_lintra.log
