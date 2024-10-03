git/ip-iosf-sideband-rtl
`-- verif/sim - run rtr tests
    |-- Makefile
    |-- log -- Stores log files after the simulation
    `-- README.txt -- This file

Instructions to run tests

A). directories
    ===========
    `-- ip-iosf-sideband-rtl
        |-- gen  <- perl script and C program source located here
        |-- bfm <- sideband VC source code is located here
        |   `-- sideband_vc
        |       `-- tb <- contains source code for sideband vc
        |       |-- tests <- contains tests for back2back(agent-fabric) tb
        |       |-- ovmlib <- contains ovm package
        |       |-- svlib <- contains sv lib package
        |       |-- scripts <- Scripts to run fabric Vc tests 
        |       `-- doc <- Release notes, Userguide located here
        |-- source/rtl <- RTL source code 
        |   |-- ctech
        |   |   `-- verilog
        |   `-- iosfsbc
        |       `-- rtl
        |           |-- common
        |           |-- router
        |           `-- endpoint
        |-- verif/sim <- directory in which simulations are to be executed
        |   `-- misc <- startup.do files for modelsim
        |   `-- log - when test is run in batch mode .log, .wlf, .ucdb files get stored here
        |-- verif/tb <- testbench source code
        |   |-- top_tb <- Top level testbench + top level rtl code
        |   |-- env <- holds generated compile time network cfg
        |   `-- ep_tb <- Top level 
        `-- verif/tests <- Router tests
            `-- networks <- network xml files,
B). Run scripts
   =============        
   - verif/sim/../../unsupported/scripts/run_mini_regression_vcs <RUNTIME_XMLPARSER> <echo_to_regress_results_log>
     runs mini regression of RTL,TLM networks on netbatch using vcs 
     with compile time xmlparser

   - verif/sim/../../unsupported/scripts/run_full_regression_vcs <RUNTIME_XMLPARSER> <echo_to_regress_results_log>
      runs full regression of RTL networks on netbatch using VCS 
      with compile time xmlparser

   - verif/sim/../../unsupported/scripts/run_cov_regression_vcs <RUNTIME_XMLPARSER> 
      runs coverage regression of RTL netwokrs on netbatch using VCS 
      with compile time xmlparser

   - verif/sim/../../unsupported/scripts/run_rtr_release_regression <network> <RUNTIME_XMLPARSER> <echo_to_regress_results_log>
      runs full regression for a given network on netbatch using VCS 
      with compile time xmlparser

if <RUNTIME_XMLPARSER> is set to 1 then regression scripts will use run time parser
if <echo_to_regress_results_log> is set to 1 then regression log will be printed to regress_results.log file
# usage 
# cd sim
# ../../unsupported/scripts/run_full_regression_vcs <RUNTIME_XMLPARSER> <echo_to_regress_results_log>
# ../../unsupported/scripts/run_full_regression_vcs 1 //run time parser
# ../../unsupported/scripts/run_full_regression_vcs //compile time parser



C). How to run test using Modelsim
    ==============================
    %cd scripts
    %source setup
    %cd ../verif/sim
    $source ../../unsupported/scripts/get_vc.csh

    To clean files
     %make clean
     %make cleanall

    To run with GUI (by default test runs with GUI, no coverage)
     Please set env variable before using questa sim
     setenv LM_PROJECT ASDG_SHARED_MSIM
     %make questa NETWORK=lv0_sbr_cfg_1  - runs 8-port sync router test
     %make questa NETWORK=lv1_sbr_async_cfg_1  - runs 8-port async router test
     %make questa NETWORK=lv0_sbn_cfg_1 - runs 3 router network test

    To run in batch mode
     %make questa-batch NETWORK=<>

    Defaul parameters for Makefile (look at the makefile for more information)
     OPTIONS          = +IOSF_PC (protocol checkers ON/OFF)
     TEST             = rtr_rnd_test (test to run)
     NETWORK          = lv0_sbr_cfg_1 (xml file name )
     SEED             = random (seed)
     VERBOSITY        = VERBOSE_PROGRESS (detailed options look at Makefile)
     TXLIMIT          = 500 ( how many transactions to run)
     MSIM_CM          = 0 (if 1 dump coveage, by default no coverage)
    
    Example - running test with coverage
     %make questa-batch NETWORK=<> TEST=<> MSIM_CM=1
    
    Example using more options to fine control test running
     %make questa-batch NETWORK=<> TEST=<> SEED=1 TXLIMIT=50 VERBOSITY=VERBOSE_PATH(print xaction path)
     %make questa-batch NETWORK=<> TEST=<> SEED=1 TXLIMIT=5 VERBOSITY=VERBOSE_ALL(print all debug msgs)

     NOTE: Once done with questa sim usage, please set env variable back to SIP.
     setenv LM_PROJECT ASDG_SEG_All_SIP

D). How to run test using VCS
    ==============================

    1). How to run tests using Makefile
        ===============================
    %cd scripts
    %source setup
    %cd ../verif/sim
    %source ../../unsupported/scripts/get_vc.csh

    To clean files
     %make clean
     %make cleanall

    To run in batch mode
     %make vcs INT=0 NETWORK=<>

    To run in batch mode with compile time parser
     %make vcs INT=0 NETWORK=<> USE_CMPLTIME_XMLPARSER=1

    Defaul parameters for Makefile (look at the makefile for more information)
     OPTIONS          = +IOSF_PC (protocol checkers ON/OFF)
     TEST             = rtr_rnd_test (test to run)
     NETWORK          = lv0_sbr_cfg_1 (xml file name )
     SEED             = random (seed)
     VERBOSITY        = VERBOSE_PROGRESS (detailed options look at Makefile)
     TXLIMIT          = 500 ( how many transactions to run)
     MSIM_CM          = 0 (if 1 dump coveage, by default no coverage)
     INT              = 0 (if 1 opens gui)

    Example - running test with coverage
     ---%make vcs INT=0 NETWORK=<> TEST=<> MSIM_CM=1
    
    Example - running test with fsdb dump
     ---%make vcs INT=0 NETWORK=<> TEST=<> FSDB=1

    Example - running test with all eps as ep_rtl (EP_TYPE=1 means all eps as EP_RTL)
            - update xml2csv.pl script to change sbendpoint parameters (right now it is using defauts params)
     ---%make vcs INT=0 EP_TYPE=1 TEST=rtr_rnd_ep_rtl_test

    Example - running rtr_blaze_creek_bandwidth_test test for lv2_sbn_cfg_stmt network
     ---%make vcs INT=0 TEST=rtr_blaze_creek_bandwidth_test_P NETWORK=lv2_sbn_cfg_stmt EP_TYPE=1
     ---%make vcs INT=0 TEST=rtr_blaze_creek_bandwidth_test_NP NETWORK=lv2_sbn_cfg_stmt EP_TYPE=1 

    Example - running test with some eps as ep_rtl 
              (it will only work for lv0_sbr_cfg_1_ep_rtl) network, 
              but user can update any network to add support for ep_rtl for some specific eps
              the test will send xactions only from the eps with ep_rtl
              user can refer to lv0_sbr_cfg_1_ep_rtl network for setup
    ---%make vcs INT=0 MIXED_EP_TYPE=1 TEST=rtr_rnd_test NETWORK=lv0_sbr_cfg_1_ep_rtl
             NOTE: tb_lv0_sbr_cfg_1_ep_rtl.sbr.sbcport1.sbcgcgu.sbcism0.agent_active_trans assertion will fire for all 
             since Router is 0.9 compatible and endpoint is 1.0 compatible.

    Example - running test with all eps as ep_rtl with eps using different spec versions
              user can update any network and add epSpecRevision xml field and specify 
              spec version to be 0.9 for some eps, rest all will use spec version as 1.0 by default
              testbench will instantiate sideband endpoint release 2010ww46 for eps with 0.9 spec version
              and will use latest ep for 1.0 spec version
    ---%make vcs-mixed-spec INT=0 NETWORK=sbr_mixed_ep_spec MIXED_EP_SPEC=1 TEST=rtr_rnd_ep_rtl_test    
             NOTE: Agent had to move to IDLE assertions are expectable whenever 
             ep_rtl(only for 0.9 eps) is used becasue 
             there are messages in progress at agent side on master bus so ip_vc(agent) asserts agent_clkreq 
             and so endpoint has to assert side_clkreq and so agent is not moving to IDLE_REQ state 
             Also, Also tb_sbr_mixed_ep_spec.sbr.sbcport7.sbcgcgu.sbcism0.agent_active_trans assertion 
             will also fire (if SKIP_ACTIVEREQ is set for the EP)
             from SBR module since, SBR module is 0.9 compliant and it will not expect agent to transition
             from IDLE to active_req. (Need to confirm this with RTL team and see there is a way to turn off this
             assertion for this test setup)

Following tests will work for all networks
          - rtr_directed_test 
          - rtr_rnd_test
          - rtr_rnd_nonglobal_opcode_test
          - rtr_rnd_sparse_xactions_test 
          - rtr_async_reset_test
          - rtr_directed_reset_test
          - rtr_rnd_performance_test
          - rtr_rnd_clock_gating_test
          - rtr_rnd_pwr_reset_test
          - rtr_rnd_pm_messages_test
          - rtr_coverage_test : caution, this test will end only when coverage hits 100%

-- For multi-router powerdown testing -> make pwrtest INT=0 TEST=rtr_directed_pwr_test 

-- For config testing --> make cfgtest INT=0 TEST=rtr_directed_cfg_test0

-- for pwr down and reset testing -> make vcs INT=0 TEST=rtr_rnd_pwr_reset_test

-- for pmu test -> make vcs INT=0 TEST=rtr_directed_pmu_test(not supported now, since sbr doen't have pmu now)

-- rtr_directed_latency_test will only work with lv0_sbr_cfg_1 network with EP_TYPE=1

-- rtr_blaze_creek__bandwidth_test will only work for lv2_sbn_cfg_stmt network

-- rtr_rnd_ep_rtl_test will only work when EP_TYPE=1 is used

-- lncbfm_directed_test will only work for section F here

-- rtr_chv_test will only work with chv network(right now vlv2 network)

-- rtr_idle_power_virus_test is to generate fsdb dumps for idle and power virus test for VLV
   make vcs INT=0 NETWORK=<> TEST=rtr_idle_power_virus_test<idx><test_type>
   here idx is based on index of the router defined in the xml
   and test_type is IDLE or VIRUS
   for example rtr_idle_power_virus_test0 for lv0_sbn_cfg_1 network, will run 
   idle power test for sbn0 network
   right now it supports networks with maximum 8 routers

   2). How to run tests using perl script(NOT Supported)
        =================================
    %cd scripts
    %source setup
    %cd ../verif/sim
    %source ../../unsupported/scripts/get_vc.csh

    To clean files
     %../../unsupported/scripts/runrtr_test.pl --clean

    To run in batch mode
     %../../unsupported/scripts/runrtr_test.pl --ipxact_file=lv0_sbr_cfg_1

    Defaul parameters for Makefile (look at the makefile for more information)
     --test             = rtr_rnd_test (test to run)
     --ipxact_file      = lv0_sbr_cfg_1 (xml file name )
     --seed             = random (seed)
     --verb             = VERBOSE_PROGRESS (detailed options look at Makefile)
     --txlimit          = 500 ( how many transactions to run)
     --gui              = 0 (if 1 opens gui)


Steps on how to run different tests
1. make vcs INT=0 TEST=<> NETWORK=<> 


E). To run ENDPOINT test
    ====================

    Parameters are listed in the verif/tests/ep_tests/default.svh file
    User will need to edit this file to run endpoint tests for different parameters

    %cd scripts
    %source setup
    %cd ../verif/sim
    %source ../../unsupported/scripts/get_vc.csh

    To clean files
    %make cleanall

    When individual tests are run, the make tb will use the default parameter file specified 
    under verif/tests/ep_test, for regressions this file will be overwritten and a new random set of 
    params will be generated
    parameters are generated based on the seed value passed to the make target

    To run using vcs, batch mode
    %cd verif/sim
    %make iptest INT=0 TEST=<testname> SEED=<seed> // for vcs
    %make iptest-questa-batch TEST=<testname> SEED=<seed> // for questasim

    To run the test in gui mode 
    %cd sim
    %make iptest TEST=<testname> // for VCS
    %make iptest-questa TEST=<testname> // for questasim

    To run test05 with independent resets for IP and Endpoint
    %make iptest TEST=test05 SEED=<seed> ASYNC_RESET=1 INT=0  //test05

    To run test18 with independent resets for IP and Endpoint
    %make iptest TEST=test18 SEED=<seed> ASYNC_RESET=1 RESET_TEST=1 INT=0  

    To run test05 with independent resets for IP and Endpoint
    %make iptest TEST=test05 SEED=<seed> ASYNC_RESET=1 RESET_TEST=1 INT=0 

    To run test with coverage database
    %make iptest INT=0 SEED=<seed> IPTEST_CM=1 TEST=<testname>

    To run test22 with independent resets for IP and Endpoint
    %make iptest TEST=test22 SEED=<seed> ASYNC_RESET=1 RESET_TEST=1 INT=0  

    To launch miniregression -- random seed, single seed, single param for all tests
    % cd verif/sim
    %../../unsupported/scripts/run_ipminiregression <seed> <IPTEST_CM> <echo_to_regress_results_log> 

    set IPTEST_CM=1 to get coverage database
    set <echo_to_regress_results_log>=1 to dump regression result into regress_results.log file

    To launch fullregression -- random seed, random params, multiple seeds for all tests
    % cd verif/sim
    %../../unsupported/scripts/run_ipfullregression <IPTEST_CM> <echo_to_regress_results_log>
    set IPTEST_CM=1 to get coverage database, generates random seed for regression
    set <echo_to_regress_results_log>=1 to dump regression result into regress_results.log file

    To merge vdbs
    %urg -noreport -parallel -dbname <db_name> -dir <list of dirs>

    To generate coverage report
    %urg -dir <db_name> -report <report_name>

    To open coverage report
    %firefox <report_name>/dashboard.html

    To run test with different parameters
    %make cleanall    
    %../../unsupported/scripts/run_ipminiregression //runs all tests for one set of params
    %../../unsupported/scripts/run_ipfullregression //runs all tests for 10 sets of params

    The script will generate the parameter file under 
    verif/tests/ep_tests based on the defined constraints and 
    then kick of regressions based on these params


F). To integrate AVM BFM into OVM testbench as one of the EP and run directed test
    ==============================================================================
    #NOT used anymore
    %cd scripts
    %source setup
    %cd ../verif/sim
    %cd lib
    % cp -r /p/sip/proj/sbfabric/users/ddaftary/lnc_sbc_bfm ../lnc_sbc_bfm

    To clean files
     %make clean
     %make cleanall

    Example - running test using VCS
     %make lnc_bfm_vcs INT=0 TEST=lncbfm_directed_test MSIM_CM=1

    To run with GUI using vcs (by default test runs with GUI, no coverage, works only with lv0_sbr_cfg_1 network)    
    %cd sim
    %source ../../unsupported/scripts/sourceme.csh

     %make lnc_bfm_vcs TEST=lncbfm_directed_test

    Defaul parameters for Makefile (look at the makefile for more information)
     OPTIONS          = +IOSF_PC (protocol checkers ON/OFF)
     TEST             = lncbfm_directed_test (test to run)
     NETWORK          = 8port_async (xml file name )
     SEED             = random (seed)
     VERBOSITY        = VERBOSE_PROGRESS (detailed options look at Makefile)
     TXLIMIT          = 500 ( how many transactions to run)
     MSIM_CM          = 0 (if 1 dump coveage, by default no coverage)
    
    Example - running test with coverage
     %make lnc_bfm_vcs TEST=lncbfm_directed_test MSIM_CM=1

G). To run back 2 back ENDPOINT test
    ================================
    NOTE: This is not supported anymore

    %cd scripts
    %source setup
    %cd ../verif/sim
    %source ../../unsupported/scripts/get_vc.csh     
    %source ../../unsupported/scripts/sip_lic_setup


    To clean files
     %make clean
     %make cleanall

    To run with GUI using modelsim (by default test runs with GUI, no coverage
     %make eptest

    Example - running test with coverage
     %make eptest-batch MSIM_CM=1


    To run the test in batch mode 
    %cd sim
    %source ../../unsupported/scripts/sourceme.csh

    %make eptest-batch

    Defaul parameters for Makefile (look at the makefile for more information)
     OPTIONS          = +IOSF_PC (protocol checkers ON/OFF)
     TEST             = pbg_rnd_test (test to run)
     NETWORK          = 8port_async (xml file name )
     SEED             = random (seed)
     VERBOSITY        = VERBOSE_PROGRESS (detailed options look at Makefile)
     TXLIMIT          = 500 ( how many transactions to run)
     MSIM_CM          = 0 (if 1 dump coveage, by default no coverage)
