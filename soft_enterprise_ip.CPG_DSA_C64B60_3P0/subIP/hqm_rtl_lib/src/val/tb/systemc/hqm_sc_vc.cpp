
#include "hqm_sc_vc.h"

namespace hqm_comp_pkg {

hqm_sc_vc::hqm_sc_vc(sc_core::sc_module_name name): sc_module(name), ip_agent_("sc_ml_agent")
{
    SC_REPORT_INFO(name, "HQM SystemC VC env enabled \n ");
}

}
