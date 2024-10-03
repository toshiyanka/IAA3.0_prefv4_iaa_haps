//##############################################
//# Copyright (C) 2013 Intel Corporation       #
//# Author(s): Reno Massarini                  #
//#            Faris Khundakjie                #
//# Massachusetts Microprocessor Design Center #
//##############################################


#include "uvm_ml.h"
#include "ml_tlm2.h"
#include "systemc.h"
#include "hqm_sc_env.h"
#include <sstream>

using namespace hqm_comp_pkg;

// Create a class called ip_env
// This gets instantiated automatically from "ml_default_run_test.svh"
sctop::sctop(sc_module_name name) : PARENT(name),
                                              hqm_val_component("sc_vc"), 
//				    mdf_bfm_env("mdf_sc_vc"),
                                              DfltSLPEnv("sc_slp_env")
{
    SC_REPORT_INFO(name, "HQM SystemC Env top level env enabled \n ");
    hqm_env_name        = this->name();

}

// built-in systemc pre-run phase
void sctop::before_end_of_elaboration(void) 
{
    SC_REPORT_INFO(hqm_env_name.c_str(),  "HQM SystemC Env before_end_of_elaboration called"); 
}

void sctop::start_of_simulation(void)
{
    SC_REPORT_INFO(hqm_env_name.c_str(),  "HQM SystemC Env start_of_simulation called"); 
}

// register systemc top type with ML system so it can instantiate at 
// proper time
int sc_main(int argc, char** argv) {
  return 0;
}
UVM_ML_MODULE_EXPORT(sctop)
