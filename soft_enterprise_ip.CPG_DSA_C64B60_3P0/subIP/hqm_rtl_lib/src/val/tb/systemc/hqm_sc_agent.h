#ifndef HQM_AGENT_H_
#define HQM_AGENT_H_

// standard systemc and tlm
#include "systemc.h"
#include "tlm.h"
#include "tlm_registry.hxx"

namespace hqm_comp_pkg {
class hqm_sc_agent : public uvm_component{

public:

  hqm_sc_agent(sc_core::sc_module_name name);
  UVM_COMPONENT_UTILS(hqm_sc_agent);

  // built-in systemc pre-run phase
  virtual void before_end_of_elaboration();
  virtual void start_of_simulation(void);
  virtual void run(void);
  virtual void run_phase(uvm_phase *phase);

  void register_tlm_entities(void);

private:
    sc_module_name                hqm_agent_name;
};

}

#endif
