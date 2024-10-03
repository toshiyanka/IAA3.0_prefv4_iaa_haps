#ifndef HQM_VC_H_
#define HQM_VC_H_


#include "systemc.h"
#include "tlm.h"
#include "hqm_sc_agent.h"


namespace hqm_comp_pkg {

class hqm_sc_vc : public sc_core::sc_module 
{

protected:

  hqm_sc_agent ip_agent_;

public:

  hqm_sc_vc(sc_core::sc_module_name name);

};

}

#endif
