#ifndef HQM_ENV_H_
#define HQM_ENV_H_

#include <stdlib.h>
// standard systemc and tlm
#include "systemc.h"
#include "tlm.h"
#include "tlm_registry.hxx"
#include "uvm_ml.h"
#include "ml_tlm2.h"
#define USE_COMET_UNSUPPORTED

#include "hqm_sc_vc.h"

//Fatal error file not found #include "DefaultSLPEnvironment_ip.cxx"
#include "DefaultSLPEnvironment_ip.cxx"

// MDF_BFM
//APM bringup #include "mdf_bfm_sc_env.hxx"

namespace hqm_comp_pkg {
class sctop: public sc_core::sc_module {

public:
  typedef sc_module PARENT;

  sctop(sc_core::sc_module_name name);

  // built-in systemc pre-run phase
  virtual void before_end_of_elaboration(void);
  virtual void start_of_simulation(void);

private:
    hqm_sc_vc                     hqm_val_component;
//Manti<FIXME>    
//    mdf_bfm_sc_env                mdf_bfm_env;
    string                        hqm_env_name;
    DefaultSLPEnvironment         DfltSLPEnv;
};

}

#endif
