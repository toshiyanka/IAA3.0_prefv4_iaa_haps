 1. find . -name "*vdb" > vdbs.list
 2. gunzip -r hqm_ss/hqm_ss/level0_upf.list.1/hqm_ss_*_test*/my_simv.vdb/
 3. casa urg -f vdbs.list -dbname output1.vdb  -noreport +urg+lic+wait -full64 -parallel 
