#!/usr/intel/bin/python3.7.4

import os, smtplib, sys, time, subprocess, fileinput, logging, re, getpass

logging.basicConfig(filename='regression_script_tracker.log', level=logging.DEBUG)

############ Function definitions and global lists declaration  ############

## mail function

sender    =  getpass.getuser() + '@intel.com'
receivers = ['amol.raghuwanshi@intel.com']

def mail_function(message):
    try:
        smtpObj = smtplib.SMTP('localhost')
        smtpObj.sendmail(sender, receivers, message)
        logging.info('Mail successfully send')
    except SMTPException:
        print("Error: unable to send email")
        logging.error("Error: Couldn't send mail")

## Function to check if a particular string is present in given file

def check_if_string_present(file_name, string_to_search):
    with open(file_name, 'r') as read_obj:
        for line in read_obj:
            if string_to_search in line:
                return True
    return False

## Function to initiate next regression only when the current regression tests
## are less then 200

def wait(regression_bucket, model_root):
    lsti_status = os.popen('lsti  {}{}/*.rpt' .format(regression_path, regression_bucket)).read()
    split_lsti_status = lsti_status.split()
    print(split_lsti_status[-3])
    while(int(split_lsti_status[-3]) > 200):
        lsti_status = os.popen('lsti {}{}/*.rpt' .format(regression_path, regression_bucket)).read()
        split_lsti_status = lsti_status.split()
        print(int(split_lsti_status[-3]))
        time.sleep(3600)

## Function to launch regressions present in regression list provided

def launch_regression(model_root, reglist_path, regression_list, exclude_regression):

    os.chdir(reglist_path)
    print(os.getcwd())

    for regr in regression_list:
        regr1    = ''
        regr_dir = ''

        if(re.search('.func.', regr)):
            regr1 = 'hqm_functional.list'

        for (root,dirs,files) in os.walk('.'):
                if regr1 != '':
                    if regr1 in files:
                        regr_dir = root + '/' + regr1
                elif regr in files:
                    regr_dir = root + '/' + regr

        if(regr_dir == ''):
            exclude_regression.append(regr)
            logging.error('launch_regression: {} not found in any directory. Skipping this regression' .format(regr))
            print('Error. Regression list {} not found' .format(regr))
            continue

        print(regr_dir)

    ### Initiate regression one by one for all the regression lists.
    ### Next regression is initiated only when current regression has less than
    ### 200 test cases left from finishing

        logging.info('launch_regression: Starting regression for {}' .format(regr))
        if(regr == 'hqm_functional_agi_test.list'):
            os.system('simregress -dut hqm -model hqm -save -notify -trex  -code_cov -hqm_agitate_rand_en -hqm_agitate_wdata 0x04000802  -ace_args -simv_args '"' +agitate_hcw_wr_rdy=1:40:1:10  +SLA_MAX_RUN_CLOCK=4000000 +SLA_USER_DATA_PHASE_TIMEOUT=4000000  +SLA_PRE_FLUSH_PHASE_TIMEOUT=400000 +SLA_RANDOM_DATA_PHASE_TIMEOUT=20000000 '"' -ace_args- -trex- -l {}{}' .format(reglist_path, regr_dir))
        elif(regr == 'hqm_functional_bg_test.list'):
            os.system('simregress -dut hqm -model hqm -save -notify -trex  -code_cov -hqm_bg_cfg_en -trex- -l {}{}') .format(reglist_path, regr_dir)
        elif(regr == 'hqm_functional_bg_agi_test.list'):
            os.system('simregress -model hqm -dut hqm -save -notify -trex  -code_cov -hqm_bg_cfg_en -hqm_agitate_rand_en -hqm_agitate_wdata 0x04000802  -ace_args -simv_args '"'+agitate_hcw_wr_rdy=1:40:1:10  +SLA_PRE_FLUSH_PHASE_TIMEOUT=400000 '"' -ace_args- -trex- -l {}{}' .format(reglist_path, regr_dir))
        else:
            os.system('simregress -dut hqm -model hqm -save -notify -trex  -code_cov -trex- -l {}{}' .format(reglist_path, regr_dir))

    ### Wait for some time before checking for lsti status to launch next regression
        time.sleep(3600)
        regression_bucket = regr
        wait(regression_bucket, model_root)

## Function to generate coverage.
## Register regressions are excluded from coverage generation

def coverage_generation(regression_path, coverage_files_path, vdb_path, vdb_path_mpp, hier_file_path, excl_hvp, exclude_regression):

    coverage_regression_list = regression_list

    print(coverage_regression_list)

    if exclude_regression:
        for non_existing_reglist in exclude_regression:
            coverage_regression_list.remove(non_existing_reglist)

    logging.info('Coverage will be generated for: {}' .format(coverage_regression_list))
    num_of_reglists = len(coverage_regression_list)
    logging.debug('coverage_generation: Starting coverage generation')
    logging.debug('coverage_regression_list = {}' .format(coverage_regression_list))
    print(coverage_regression_list)

    while(num_of_reglists != 0):
        for regr in coverage_regression_list:
            logging.info('Initiating coverage generation for {}' .format(regr))
            os.chdir('{}{}' .format(regression_path, regr))

            time.sleep(360)

            lsti_status = os.popen('lsti *.rpt').read()
            split_lsti_status = lsti_status.split()

            if(int(split_lsti_status[-3]) == 0):
                num_of_reglists = num_of_reglists - 1
                print('Num of reglist = {}' .format(num_of_reglists))

                fail_list = os.popen('find `pwd` -name postsim.fail').read()
                print(fail_list)

                if(fail_list != ''):
                    with fileinput.FileInput('fail_list', inplace=True) as file:
                         for line in file:
                             sys.stdout.write('rm -rf ')
                             print(line.replace('postsim.fail', '*.vdb'), end='')
                             os.chmod('fail_list', stat.S_IRWXU)
                             os.system('./fail_list')

                #TODO: check gunzip on functional list
                os.system('gunzip -d -r */*.vdb/*' )
                findCMD = 'find `pwd`  -name "*vdb*"'

                out = subprocess.Popen(findCMD,shell=True,stdin=subprocess.PIPE,
                                    stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                (stdout, stderr) = out.communicate()
                v_d_b_files         = stdout.decode()
                print('v_d_b_files  is {}' .format(v_d_b_files))

                ## Create vdbfiles.list and copy all vdb
                ## directories in this file

                with open('vdbfiles.list', 'w+') as f:
                    f.writelines('{}' .format(v_d_b_files))
                    f.writelines('{}\n{} \n' .format(vdb_path, vdb_path_mpp))

                ### Initiate coverage generation

                os.system('urg -full64  -show tests -f vdbfiles.list -dir {} -hier {} -dbname {} -report {} -plan {}' .format(vdb_path, hier_file_path, regr[0:-5], regr[0:-5], excl_hvp));

                ## Copy vdb in coverage_directory
                os.system('cp -rf {}.vdb {}' .format(regr[0:-5] ,coverage_files_path))
                os.system('cp -rf {} {}' .format(regr[0:-5] ,coverage_files_path))

                ## Remove regression directory from which vdb and coverage files are copied
                os.system('rm -rf *')

## Function to merge coverage from all the individual coverages

def merging_coverage(coverage_files_path, vdb_path, vdb_path_mpp, hier_file_path, excl_hvp, database_name):
    os.chdir(coverage_files_path)
    print(os.getcwd())

    logging.debug('merging_coverage: Initiating merging of coverage')

    # Create vdbfiles.list and copy all vdbs copied from regression
    # directories in this file
    with open('vdbfiles.list', 'w+') as f:
        for file in os.listdir(os.getcwd()):
            if(file.endswith(".vdb")):
                print(file)
                f.writelines('{}\n' .format(file))

        f.writelines('{}\n{} \n' .format(vdb_path, vdb_path_mpp))

    with open('vdbfiles_group_ratio.list', 'w+') as f:
        for file in os.listdir(os.getcwd()):
            if(file.endswith(".vdb")):
                if(re.search('hqm_reg_test_.', file) or re.search('hqm_reg_reset_test_.', file)):
                    pass
                else:
                    f.writelines('{}\n' .format(file))

        f.writelines('{}\n{} \n' .format(vdb_path, vdb_path_mpp))


    # Merging the coverage

    os.system('urg -full64  -show tests -f vdbfiles.list -dir {}  -hier {} -dbname  merged_coverage -report merged_coverage  -plan {} -log urg_warning.log' .format(vdb_path, hier_file_path, excl_hvp));

    os.chdir('merged_coverage')
    lynx_cmd = 'lynx -width=150 -dump dashboard.html'

    out = subprocess.Popen(lynx_cmd,shell=True,stdin=subprocess.PIPE, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    (stdout, stderr) = out.communicate()
    coverage_report = stdout.decode()

    os.chdir(coverage_files_path)

    os.system('urg -full64 -show tests -f vdbfiles_group_ratio.list -group ratio -dir {} -hier {} -dbname merged_func_cov -report merged_func_cov -plan {} -log urg_warning.log' .format(vdb_path, hier_file_path, excl_hvp))

    os.chdir('merged_func_cov')

    lynx_cmd = 'lynx -width=150 -dump dashboard.html'

    out = subprocess.Popen(lynx_cmd,shell=True,stdin=subprocess.PIPE, stdout=subprocess.PIPE,stderr=subprocess.PIPE)

    (stdout, stderr) = out.communicate()

    group_ratio_coverage_report = stdout.decode()


    subject ="""Subject: Coverage report generated
    """
    mail_header_1 = '\nHi All, \n\nBelow is the coverage report with and without group ratio generated on database: {}' .format(database_name)

    mail_header_2 = '\nCOVERAGE REPORT WITHOUT GROUP RATIO OPTION'

    mail_header_3 = '\nCOVERAGE REPORT WITH GROUP RATIO OPTION'

    message = subject + mail_header_1 + '\n\n' + mail_header_2 + '\n\n' + coverage_report + '\n\n' + mail_header_3 + '\n\n' + group_ratio_coverage_report

    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message)

############ Beginning of script ############

# Check with user if he wishes to provide path for database generation ##
# If user doesn't wish to provide path, consider current path for database generation
database_path = input("Do you want to provide path for database generation or use default path: (y/n):")
if database_path[0].lower() == 'y':
    database_path = input("Please enter path where database is to be generated: ")
    print('Database path is {}'.format(database_path))
else:
    database_path = os.getcwd()
    print('Database path is {}'.format(database_path))

logging.info('Database path is {}' .format(database_path))

os.chdir(database_path)

## Get database name from user ##
database_name = input("Please enter name of database to be created: ")

## If database already exists with name provided by user,
## create <database_name.1>/.2/.3 version
## until database name doesn't exist
initial_db_version = 0
updated_db_version = 0

temp_name = database_name

while(os.path.isdir(temp_name)):
    initial_db_version = initial_db_version+1
    updated_db_version = initial_db_version
    temp_name = database_name + '.' + str(updated_db_version)

if(updated_db_version != 0):
    database_name = database_name + '.' + str(updated_db_version)

print('Database name is {}'.format(database_name))

logging.info('Database name is {}' .format(database_name))

user_defined_regression_list = input("Do you want to provide regression lists to run: (y/n):")
if user_defined_regression_list[0].lower() == 'y':
    while(True):
        print('Enter:\nhqm_iosf_test.list \t for iosf regression\nhqm_pwr_test.list \t for power regression\nhqm_reg_tests.list \t for register regression\nhqm_reg_reset_tests.list for register regression with resets enabled\nhqm_pcie_test.list \t for pcie regression\nhqm_functional_bg_test.list for functional regression with bg enabled\nhqm_functional_bg_agi_test.list for functional regression with bg and agi enabled\nhqm_functional_test.list for functional regression')
        regression_list = [item for item in input("Enter the regression lists : ").split()]
        print(regression_list)
        regression_list_is_correct = input("Is the regression list confirmed (y/n): ")
        if(regression_list_is_correct[0].lower() == 'y'):
            break


try:
    os.mkdir(database_name)
except:
    logging.error("Couldn't create database. Exiting")
    sys.exit()
os.chdir(database_name)

print('Current directory is {}'.format(os.getcwd()))

## Get database from git repo
os.system('git clone /p/hdk/rtl/git_repos/shdk74/ip/hqm-srvr10nm-wave4/ .') #TODO $git repo path.

#TODO: make it generic for V1/V2/V25

## Compilation
os.system('bman -dut hqm -mc hqm -nodelete_flow_data -code_cov -btb hqm:mpp -hqm_fcov')

target = ''

database_path = os.getcwd()

os.chdir('target')

# Check if compilation passed.
# If compilation has failed, exit the process and mail the user accordingly
#TODO: check what is bman log name in V1 and V2



#Mail should contain path database
if(check_if_string_present('hqm.bman.log', 'Flow bman PASSED')):
    print('Compilation passed')
    message ="""Subject: Compilation report
Compilation passed
    """
    mail_function(message)
else:
    message = """Subject: Compilation report
Compilation failed. Exiting the script
    """
    mail_function(message)
    print('Compilation failed. Exiting the script')
    sys.exit()

#TODO check disk space and mail. Command line argument for default regression/user defined

os.chdir(database_path)
model_root = os.getcwd()
print(model_root)

# Create a directory with below name which will include
## all the coverage related data collected from individual regression coverages

try:
    os.mkdir('coverage_database')
except:
    logging.error("Couldn't create directory. Exiting")
    sys.exit()


#TODO:make variables for all and declare at the top
coverage_files_path = model_root + '/coverage_database/'
vdb_path            = model_root + '/target/hqm/vcs_4value/hqm/hqm.simv.vdb'
vdb_path_mpp        = model_root + '/target/hqm/vcs_4value_mpp/hqm/hqm.simv.vdb'
excl_file_path      = model_root + '/verif/tb/hqm/cov_gen/excl/'
hier_file_path      = excl_file_path + 'mrb_hqm_cov_excl.hier'
excl_hvp            = excl_file_path + 'hqmv25_func_coverage.hvp'
regression_path     = model_root + '/regression/hqm/hqm/'
reglist_path        = model_root + '/verif/tb/hqm/reglist/'
reglist             = model_root + '/verif/tb/hqm/scripts/reglist.list'
######### Update exclusion file ########

if user_defined_regression_list[0].lower() != 'y':
    with open (reglist) as f:
        regression_list = f.read().splitlines()
        print(regression_list)

exclude_regression = []

launch_regression(model_root, reglist_path, regression_list, exclude_regression)

#To run only coverage
coverage_generation(regression_path, coverage_files_path, vdb_path, vdb_path_mpp, hier_file_path, excl_hvp, exclude_regression)

merging_coverage(coverage_files_path, vdb_path, vdb_path_mpp, hier_file_path, excl_hvp, database_name)

