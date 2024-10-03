#include "hqm_sc_agent.h"
#include "uvm_ml.h"
// XXX Faris does not compile without this header ... investigate this and
//     remove dependency
#include "ml_tlm2.h"
#include "tlm_registry.hxx"


namespace hqm_comp_pkg {

/*******************************************************************************
* hqm_sc_agent Class constructor
*******************************************************************************/
hqm_sc_agent::hqm_sc_agent(sc_core::sc_module_name name) : uvm_component(name),
               hqm_agent_name(name)
{
}

/*******************************************************************************
* before_end_of_elaboration()
*   built-in systemc pre-run phase
*******************************************************************************/
void hqm_sc_agent::before_end_of_elaboration(void)
{
    SC_REPORT_INFO(hqm_agent_name, "HQM SystemC Agent: before_end_of_elaboration \n ");
}

/*******************************************************************************
* start_of_simulation()
*   built-in systemc pre-run phase
*******************************************************************************/
void hqm_sc_agent::start_of_simulation(void)
{
    SC_REPORT_INFO(hqm_agent_name, "HQM SystemC Agent: start_of_simulation \n ");
}
/*******************************************************************************
* run()
*   built-in uvm run phase
*******************************************************************************/
void hqm_sc_agent::run(void)
{
    SC_REPORT_INFO(hqm_agent_name,  "HQM SystemC Agent: run() called\n"); 
}

/*******************************************************************************
* run()
*   built-in uvm run phase
*   Main loop that services TLM port communication from SV part of test bench
*******************************************************************************/
void hqm_sc_agent::run_phase(uvm_phase *phase)
{
    SC_REPORT_INFO(hqm_agent_name,  "HQM SystemC Agent: run_phase() called\n"); 
    SC_REPORT_INFO(hqm_agent_name,  phase->get_name().c_str()); 
}


/*******************************************************************************
* register_tlm_entities()
*   Set up TLM ports
*******************************************************************************/
void hqm_sc_agent::register_tlm_entities(void) 
{
}

UVM_COMPONENT_REGISTER(hqm_sc_agent)
}
