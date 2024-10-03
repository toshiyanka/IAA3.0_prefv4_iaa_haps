// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DFM_set2.rs.rca 1.1 Thu Oct 23 11:32:15 2014 gmonroy Experimental $
//
// $Log: p1273dx_DFM_set2.rs.rca $
// 
//  Revision: 1.1 Thu Oct 23 11:32:15 2014 gmonroy
//  Add second set of DFM rules (i.e. rules defined after lead vehicle introduction)
//  for p1272 and p1273dx
// 

#ifndef _P1273DX_DFM_SET2_RS_
#define _P1273DX_DFM_SET2_RS_

#include <p12723_dfm_set2_functions.rs>

DFM_M4_ETE_transitions = drMx_ETE_transitions(
    metal	      = METAL4BC, 
    short_transition  < 0.300, 
    width_start	      = 38, 
    width_end         = 56, 
    width_step        = 2, 
    metal_space	      = M4_21,
    unaligned_ete     = M4_42,
    max_unaligned_ete = M4BB_37,  // probably overkill but just in case
    metal_dir	      = non_gate_dir
);
// Metal4 B/C Metal ETE transitions
dfm_register(DFM_M4_ETE_transitions);


#if (_drPROCESS != 6)

  DFM_M5_ETE_transitions = drMx_ETE_transitions(
      metal	        = METAL5BC, 
      short_transition  < 0.300, 
      width_start	= 38, 
      width_end         = 56, 
      width_step        = 2, 
      metal_space	= M5_21,
      unaligned_ete     = M5_42,
      max_unaligned_ete = M5BB_37,  // probably overkill but just in case
      metal_dir		= gate_dir
  );
  // Metal5 B/C Metal ETE transitions
  dfm_register(DFM_M5_ETE_transitions);

#endif // (_drPROCESS != 6)


#endif // _P1273DX_DFM_SET2_RS_
