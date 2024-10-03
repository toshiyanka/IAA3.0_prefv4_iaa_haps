/* ==========================================================================
 *  *  Filename: cmp_two_vdb_tgl.cpp
 *  *  Description:
 *  *  Version:  1.0
 *  *  Created:  05/11/18 11:00 CST
 *  *  Author:   Willsky.Ling@synopsys.com
 *  *  Revision:  none
 *  *  Company:  Synopsys
 ========================================================================== */

// --------------------------------------------------------------- //
// C
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// C++
#include <fstream>
#include <string>
#include <queue>
#include <vector>
#include <set>
#include <map>
#include <algorithm>

// NPI
#include "npi.h"
#include "npi_util.h"
#include "npi_cov.h"
#include "npi_L1.h"

extern "C" {
  int cmp_two_vdb_tgl(int argc, char* argv[]);
}

using namespace std;
// --------------------------------------------------------------- //

// --------------------------------------------------------------- //
typedef map<string, set<string> > myMap;

void print_usage()
{
  printf("\n");
  printf("Usage:\n");
  printf("  cmp_two_vdb_tgl -vdb1 <the coverage database <dir>> -vdb2 <the coverage database <dir>> [-scope <scope name>] [-only_port] [-elfile <exclude_file>] [-elfile_list <file contains the exclude file names>] [-o <output file>]\n");
  printf("    Arguments:\n");
  printf("      -vdb1        <dir>                            the first coverage database in <dir>.\n");
  printf("      -vdb2        <dir>                            the second coverage database in <dir>.\n");
  printf("      -scope       <scope name>                     only check the scope and its sub scopes.\n");
  printf("      -only_port                                    when specify this option, only check ports.\n");
  printf("      -elfile      <exclusion file>                 Exclusion file to be loaded.\n");
  printf("      -elfile_list <file contains exclusion files>  Exclusion files to be loaded.\n");
  printf("      -o           <output file>                    If not specified, default is comp_result.log.\n\n");
  printf("  Ex: cmp_two_vdb_tgl -vdb1 simv1.vdb -vdb2 simv2.vdb -scope tb_top\n\n");
}


#define TC_RELEASE_DATE "2018/05/11"
void print_header()
{
  printf("\nToggle coverage report comparison App\n");
  printf("Release: %s\n\n", TC_RELEASE_DATE);
}

void print_tailer()
{
  printf("\nToggle coverage report comparison App- %s End\n\n", TC_RELEASE_DATE);
}

void retrieve_arg(npiArg arg, char* attr, string& arg_str/*O*/)
{
  if (npi_arg_has_attr(arg, attr)) {
    if (npi_arg_attr_number_value(arg, attr) > 0) {
      arg_str = npi_arg_attr_get_value(arg, attr, 1/*extract only 1 arg value*/);
    }
    npi_arg_remove_attr(arg, attr);
  }
}

string cstr_to_str(const char* str)
{
  string ret = str ? str: "";
  return ret;
}

void load_exclusion_files(const char* listName, npiHandle test)
{
  const int buffSize = 1024;
  char buff[buffSize];
  FILE* fp = fopen(listName,"r");
  if (!fp)
    return;
	printf("Reading exclusion file list: %s ... \n", listName);
  do {
    if (fgets(buff, buffSize, fp)) {
      string line = "";
      for (unsigned int i=0; i<strlen(buff); i++) {
        switch (buff[i]) {
          case ' ':
          case '\n':
            continue;
            //line += '\0';
            //break;
          default:
            line += buff[i];
            break;
        }
      }
      if (!line.empty()) {
	  		printf(" - Load exclusion file %s\n", line.c_str());
        if (!npi_cov_load_exclude_file(test, line.c_str())) {
          printf("[NPI COV] Failed to load the exclusion file %s from %s\n", line.c_str(), listName);
          break;
        }
      }
    }
  } while (!feof(fp));
  fclose(fp);
}

void trv_bit_tgl(const string& inst_name, const npiCovHandle sigHdl, const npiCovHandle& mergedTest, const set<string>& excluded_sig_set, bool debug, myMap& uncovered_sig_map)
{
	npiCovHandle subSigItr = npi_cov_iter_start(npiCovChild, sigHdl);
  npiCovHandle subSigHdl;
	string subSig_name, bin_name;

	while (NULL != (subSigHdl = npi_cov_iter_next(subSigItr))) {
    subSig_name = inst_name + "." + npi_cov_get_str(npiCovName, subSigHdl);
    if (debug)
      printf("\t%s\n", subSig_name.c_str());
    
		if ( npi_cov_has_status(npiCovStatusExcludedAtReportTime, subSigHdl, mergedTest) == 1 ) {
			printf("  %s has been excluded\n", subSig_name.c_str());
			continue;
		}

    if ( npi_cov_has_status(npiCovStatusCovered, subSigHdl, mergedTest) == 0 ) {
			if (debug)
			  printf("\t  %s not covered\n", subSig_name.c_str());
	    if ( excluded_sig_set.find(subSig_name) == excluded_sig_set.end() ) {
			  npiCovHandle binItr = npi_cov_iter_start(npiCovChild, subSigHdl);
			  npiCovHandle binHdl;
			  while (NULL != (binHdl = npi_cov_iter_next(binItr))) {
				  if (npi_cov_get(npiCovCovered, binHdl, mergedTest) == 0) {
            bin_name = cstr_to_str(npi_cov_get_str(npiCovName, binHdl));
            if (! bin_name.empty())
              uncovered_sig_map[subSig_name].insert(bin_name);
				  }
        }
			  npi_cov_iter_stop(binItr);
	    }
			else {
				printf("  %s has been excluded\n", subSig_name.c_str());
			}
    }
  }
  npi_cov_iter_stop(subSigItr);
}

void check_sig(const npiCovHandle& toggleMetric, const npiCovHandle& mergedTest, const set<string>& excluded_sig_set, bool only_port, bool debug, myMap& uncovered_sig_map)
{
	string bin_name, sig_name, inst_name;
	inst_name = cstr_to_str(npi_cov_get_str(npiCovFullName, toggleMetric));
	NPI_INT32 sig_size;

	npiCovHandle sigItr = npi_cov_iter_start(npiCovChild, toggleMetric);
	npiCovHandle sigHdl;
  while (NULL != (sigHdl = npi_cov_iter_next(sigItr))) { 
    sig_name = inst_name + "." + npi_cov_get_str(npiCovName, sigHdl);
    sig_size = npi_cov_get(npiCovSize, sigHdl, mergedTest);
		if (debug)
		  printf("  %s(size:%d)\n", sig_name.c_str(), sig_size);

    if (only_port) {
      if ( !npi_cov_get(npiCovIsPort, sigHdl, mergedTest) )
        continue;
    }

    //NPI_INT32 covStatus = npi_cov_get(npiCovStatus, sigHdl, mergedTest);
    //if ( !(covStatus == npiCovStatusExcluded || covStatus == npiCovStatusCovered || covStatus == npiCovStatusExcludedAtReportTime ) ) { // not excluded or covered

    if ( (sig_size != 1) ) {
			if ( npi_cov_has_status(npiCovStatusCovered, sigHdl, mergedTest) == 0 ) {
        trv_bit_tgl(inst_name, sigHdl, mergedTest, excluded_sig_set, debug, uncovered_sig_map);
			  continue;
			}
	  }
    
		//if ( npi_cov_has_status(npiCovStatusExcluded, sigHdl, mergedTest) == 1 ) {
		if ( npi_cov_has_status(npiCovStatusExcludedAtReportTime, sigHdl, mergedTest) == 1 ) {
			printf("  %s has been excluded\n", sig_name.c_str());
			continue;
		}

		if ( npi_cov_has_status(npiCovStatusCovered, sigHdl, mergedTest) == 0 ) {
			if ( excluded_sig_set.find(sig_name) == excluded_sig_set.end() ) {
			  npiCovHandle binItr = npi_cov_iter_start(npiCovChild, sigHdl);
			  npiCovHandle binHdl;
			  while (NULL != (binHdl = npi_cov_iter_next(binItr))) {
				  if (npi_cov_get(npiCovCovered, binHdl, mergedTest) == 0) {
            bin_name = cstr_to_str(npi_cov_get_str(npiCovName, binHdl));
            if (! bin_name.empty())
              uncovered_sig_map[sig_name].insert(bin_name);
				  }
        }
			  npi_cov_iter_stop(binItr);
			}
			else
				printf("  %s has been excluded\n", sig_name.c_str());
		}
  }
  npi_cov_iter_stop(sigItr);
}

void check_inst_rec(const npiCovHandle& inst, const npiCovHandle& mergedTest, const set<string>& excluded_sig_set, bool only_port, bool debug, myMap& uncovered_sig_map)
{

  string inst_name;
	inst_name = cstr_to_str(npi_cov_get_str(npiCovFullName, inst));

  if (debug)
	  printf("Instance: %s\n", inst_name.c_str());

	npiCovHandle toggleMetric = npi_cov_handle(npiCovToggleMetric, inst);
	check_sig(toggleMetric, mergedTest, excluded_sig_set, only_port, debug, uncovered_sig_map);

  npiCovHandle itr = npi_cov_iter_start(npiCovInstance, inst);
  npiCovHandle inst_child;

  while (NULL != (inst_child = npi_cov_iter_next(itr))) {
    check_inst_rec(inst_child, mergedTest, excluded_sig_set, only_port, debug, uncovered_sig_map);
  }
  npi_cov_iter_stop(itr);

}

void cmp_map(const myMap& vdb1_sig_map, const myMap& vdb2_sig_map, FILE* out_fp, bool& testPass)
{
  set<string> bin_1_set, bin_2_set;
  map<string, set<string> >::const_iterator it, vdb2_it;
  for (it=vdb1_sig_map.begin(); it!=vdb1_sig_map.end(); ++it) {
		vdb2_it = vdb2_sig_map.find(((it->first))); 
		if (vdb2_it == vdb2_sig_map.end()) {
			fprintf(out_fp, "%s\n", ((it->first)).c_str());
			testPass = false;
		}
		else {
			bin_1_set = (it->second);
			bin_2_set = (vdb2_it->second);
			for (set<string>::iterator bin_it=bin_1_set.begin(); bin_it!=bin_1_set.end(); ++bin_it) {
				if (bin_2_set.find((*bin_it)) == bin_2_set.end() ) {
					fprintf(out_fp, "%s\t(toggle bin: %s)\n", ((it->first)).c_str(), (*bin_it).c_str());
					testPass = false;
				}
			}
		}
	}
}

// --------------------------------------------------------------- //
// MAIN
//   npiDlSym -func cmp_two_vdb_tgl -vdb1 <the coverage database> -vdb2 <the coverage database> -scope <scope name> [-o <output file>]
// --------------------------------------------------------------- //
int cmp_two_vdb_tgl(int argc, char* argv[])
{
  print_header();
  // argument parsing
  npiArg arg = npi_arg_construct(argc, argv);

  if ((argc == 1) || npi_arg_has_attr(arg, (char*)"-h") ) {
    print_usage();
    npi_arg_remove_attr(arg, (char*)"-h");
    return 0;
  }

  string  scope_str = "";
  string  sigfile_str = "";
  string  elfile_str = "";
  string  elfile_list_str = "";
  string  vdb1_str = "";
  string  vdb2_str = "";
  string  outputFile = "comp_result.log";

  retrieve_arg(arg, (char*)"-scope", scope_str);
  retrieve_arg(arg, (char*)"-sig_file", sigfile_str);
  retrieve_arg(arg, (char*)"-elfile", elfile_str);
  retrieve_arg(arg, (char*)"-elfile_list", elfile_list_str);
  retrieve_arg(arg, (char*)"-vdb1", vdb1_str);
  retrieve_arg(arg, (char*)"-vdb2", vdb2_str);
  retrieve_arg(arg, (char*)"-o", outputFile/*O*/);
  if ( vdb1_str.empty() || vdb2_str.empty() ) {
    return 0;
  }

  if (outputFile.empty())
		outputFile = "comp_result.log";

  bool only_port = false;
  if ( npi_arg_has_attr(arg, (char*)"-only_port") ) {
    npi_arg_remove_attr(arg, (char*)"-only_port");
    only_port = true;
  }

  bool debug = false;
	if ( npi_arg_has_attr(arg, (char*)"-debug") ) {
	  npi_arg_remove_attr(arg, (char*)"-debug");
	  debug = true;
	}

  // begin NPI
  char** new_argv = npi_arg_get_argv(arg);
  //int    new_argc = npi_arg_get_argc(arg);
  //npi_init(new_argc, new_argv);
  printf("\n==== Program Init ====\n");
  printf("Info-[%s] VDB1 = %s\n", new_argv[0], vdb1_str.c_str());
  printf("Info-[%s] VDB2 = %s\n", new_argv[0], vdb2_str.c_str());
  printf("Info-[%s] Scope = %s\n", new_argv[0], scope_str.c_str());
  printf("Info-[%s] Only Port = %d\n", new_argv[0], only_port? 1:0);
  printf("Info-[%s] Excluded Signal file = %s\n", new_argv[0], sigfile_str.c_str());
  if (!elfile_str.empty())
    printf("Info-[%s] Exclusion file = %s\n", new_argv[0], elfile_str.c_str());
  if (!elfile_list_str.empty())
    printf("Info-[%s] List of Exclusion files = %s\n", new_argv[0], elfile_list_str.c_str());
  printf("Info-[%s] Output File Name = %s\n\n", new_argv[0], outputFile.c_str());


  set<string> excluded_sig_set;
	if ( !sigfile_str.empty() ) {
    string sig_line;
    ifstream sig_ifs(sigfile_str.c_str(), ifstream::in);
    if (!sig_ifs.is_open()) {
      printf("Error-[%s] Failed to open signal file \"%s\"\n", new_argv[0], sigfile_str.c_str());
      return 1;
    }

    while (getline(sig_ifs , sig_line/*O*/)) {
			if (debug)
        printf("\nSignal: %s\n", sig_line.c_str());
      if (sig_line[sig_line.size()-1] =='\r')
				sig_line.erase(sig_line.end()-1);
      if ( sig_line.empty() || sig_line[0] == '#' || sig_line[0] == '-') {
				continue;
			}
			else {
				excluded_sig_set.insert(sig_line);
      }
    }
    sig_ifs.close();
  }
  
  if (debug)
    printf("excluded_sig_set size: %lu\n", excluded_sig_set.size());
  
  myMap vdb1_sig_map, vdb2_sig_map;

  //get uncovered siangls in vdb2
  npiCovHandle cov_db = NULL;
  cov_db = npi_cov_open(vdb1_str.c_str());
  if (!cov_db) {
    printf("[NPI COV] Failed to open the VDB...\n");
    return 1;
  }
  // get test, and merge
  npiCovHandle test = NULL;
  npiCovHandle mergedTest = NULL;
  npiCovHandle testItr = npi_cov_iter_start(npiCovTest, cov_db);
  while (NULL != (test=npi_cov_iter_next(testItr))) {
    if (!mergedTest) {
      mergedTest = test;
      continue;
    }
    mergedTest = npi_cov_merge_test(mergedTest, test);
    if (!mergedTest) {
      printf("Failed to merger test %s\n", npi_cov_get_str(npiCovName, test));
      return 1;
    }
  }
  npi_cov_iter_stop(testItr);
  printf("Test name: %s\n", npi_cov_get_str(npiCovName, mergedTest));
  
	if (!elfile_str.empty()) {
		if ( !npi_cov_load_exclude_file(mergedTest, elfile_str.c_str()) ) {
			printf("[NPI COV] Failed to load the exclusion file...\n");
			return 1;
		}
	}

  if (!elfile_list_str.empty())
    load_exclusion_files(elfile_list_str.c_str(), mergedTest);

	if ( scope_str.empty() ) {
    npiCovHandle instItr = npi_cov_iter_start(npiCovInstance, cov_db);
    npiCovHandle top_inst_hdl;
    while (NULL != (top_inst_hdl = npi_cov_iter_next(instItr))) {
			check_inst_rec(top_inst_hdl, mergedTest, excluded_sig_set, only_port, debug, vdb1_sig_map);
    }
    npi_cov_iter_stop(instItr);
	}
	else {
		npiCovHandle scope_hdl = npi_cov_handle_by_name(scope_str.c_str(), cov_db);
		if ( !scope_hdl ) {
			printf("[NPI COV] Error. Failed to get %s the coverage scope handle.\n", scope_str.c_str());
			return 1;
		}
		else {
			check_inst_rec(scope_hdl, mergedTest, excluded_sig_set, only_port, debug, vdb1_sig_map);
		}
	}
  npi_cov_unload_test(mergedTest);
  npi_cov_close(cov_db);

  //////////////////////////////////////////////
	//get uncovered siangls in vdb2
  cov_db = npi_cov_open(vdb2_str.c_str());
  if (!cov_db) {
    printf("[NPI COV] Failed to open the VDB...\n");
    return 1;
  }

  // get test, and merge
  test = NULL;
  mergedTest = NULL;
  testItr = npi_cov_iter_start(npiCovTest, cov_db);
  while (NULL != (test=npi_cov_iter_next(testItr))) {
    if (!mergedTest) {
      mergedTest = test;
      continue;
    }
    mergedTest = npi_cov_merge_test(mergedTest, test);
    if (!mergedTest) {
      printf("Failed to merger test %s\n", npi_cov_get_str(npiCovName, test));
      return 1;
    }
  }
  npi_cov_iter_stop(testItr);
  printf("Test name: %s\n", npi_cov_get_str(npiCovName, mergedTest));

  
	if (!elfile_str.empty()) {
		if ( !npi_cov_load_exclude_file(mergedTest, elfile_str.c_str()) ) {
			printf("[NPI COV] Failed to load the exclusion file...\n");
			return 1;
		}
	}

  if (!elfile_list_str.empty())
    load_exclusion_files(elfile_list_str.c_str(), mergedTest);

	if ( scope_str.empty() ) {
    npiCovHandle instItr = npi_cov_iter_start(npiCovInstance, cov_db);
    npiCovHandle top_inst_hdl;
    while (NULL != (top_inst_hdl = npi_cov_iter_next(instItr))) {
			check_inst_rec(top_inst_hdl, mergedTest, excluded_sig_set, only_port, debug, vdb2_sig_map);
    }
    npi_cov_iter_stop(instItr);
	}
	else {
		npiCovHandle scope_hdl = npi_cov_handle_by_name(scope_str.c_str(), cov_db);
		if ( !scope_hdl ) {
			printf("[NPI COV] Error. Failed to get %s the coverage scope handle.\n", scope_str.c_str());
			return 1;
		}
		else {
			check_inst_rec(scope_hdl, mergedTest, excluded_sig_set, only_port, debug, vdb2_sig_map);
		}
	}
  npi_cov_unload_test(mergedTest);
  npi_cov_close(cov_db);


  // open output log
  FILE* out_fp = fopen(outputFile.c_str(), "w");
  if (!out_fp) {
    printf("Error-[%s] Failed to write output file \"%s\".\n", new_argv[0], outputFile.c_str());
    return 1;
  }

  struct tm *localtime(const time_t * timep);
  time_t timep;
  struct tm *p;
  time(&timep);
  p = localtime(&timep); /*get local time*/
  fprintf(out_fp, "##  %d/%d/%d  %d:%d:%d\n", (1900+p->tm_year), (1+p->tm_mon), p->tm_mday, p->tm_hour, p->tm_min, p->tm_sec);
  fprintf(out_fp, "##  Info-[%s] VDB1 = %s\n", new_argv[0], vdb1_str.c_str());
  fprintf(out_fp, "##  Info-[%s] VDB2 = %s\n", new_argv[0], vdb2_str.c_str());
  fprintf(out_fp, "##  Info-[%s] Scope = %s\n", new_argv[0], scope_str.c_str());
  fprintf(out_fp, "##  Info-[%s] Only Port = %d\n", new_argv[0], only_port? 1:0);
	fprintf(out_fp, "##  Info-[%s] Excluded Signal file = %s\n", new_argv[0], sigfile_str.c_str());
  if (!elfile_str.empty())
    fprintf(out_fp, "##  Info-[%s] Exclusion file = %s\n", new_argv[0], elfile_str.c_str());
  if (!elfile_list_str.empty())
    fprintf(out_fp, "##  Info-[%s] List of Exclusion files = %s\n", new_argv[0], elfile_list_str.c_str());
	fprintf(out_fp, "##  Info-[%s] Output File Name = %s\n", new_argv[0], outputFile.c_str());
	fprintf(out_fp, "----------------------------------------------------------------------\n");
  // signals uncovered in vdb1 but covered in vdb2
	bool testPass = true;
  fprintf(out_fp, "#### signals uncovered in %s but covered in %s\n", vdb1_str.c_str(), vdb2_str.c_str());
  cmp_map(vdb1_sig_map, vdb2_sig_map, out_fp, testPass);

  // signals uncoverd in vdb2 but covered in vdb1
  fprintf(out_fp, "\n\n\n\n#### signals uncovered in %s but covered in %s\n",  vdb2_str.c_str(), vdb1_str.c_str());
  cmp_map(vdb2_sig_map, vdb1_sig_map, out_fp, testPass);

  if (testPass) {
		printf("\n\tCongratulations, testing Pass! *^_^*\n");
		fprintf(out_fp, "Congratulations, testing Pass! *^_^*\n");
	}
	else
		printf("\n\tSorry, testing Fail! Please check %s (*_*)\n", outputFile.c_str());


	fprintf(out_fp, "----------------------------------------------------------------------\n");

  // end NPI
  printf("\n==== Program End ====\n\n");
  print_tailer();

  fclose(out_fp);
  npi_arg_destroy(arg);
  //npi_end();
  return 1;
}

// --------------------------------------------------------------- //
