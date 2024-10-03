// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_M11.rs.rca 1.2 Tue Mar 26 14:24:20 2013 dgthakur Experimental $
//
// $Log: p1273d6_M11.rs.rca $
// 
//  Revision: 1.2 Tue Mar 26 14:24:20 2013 dgthakur
//  Updated M11 to 252 pitch (new) code.
// 
//  Revision: 1.1 Tue Aug 21 01:22:42 2012 dgthakur
//  1273.6 metal code wrappers.
//


#ifndef _P1273D6_M11_RS_
#define _P1273D6_M11_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 11
#define mxdl 58


//For now define empty
mx(etchring_ring_removed) = empty_layer();


mx(shield_list): list of polygon_layer = 
  {mx(para01), mx(para03), mx(para05), mx(para06), mx(para09), mx(para10)};


mx(shield_side_list): list of edge_layer = 
  {mx(para01side), mx(para03side), mx(para05side), mx(para06side), mx(para09side), mx(para10side)};


mx(non_shield_side_list): list of edge_layer = 
  {mx(para02side), mx(para04side), mx(para07side), mx(para08side)};


mx(121bin_side): edge_layer = mx(para06side);


#include <p12723_MX252pitchNew.rs>


//Undefine mid to be safe
#undef mid 
#undef mxdl



#endif //_P1273D6_M11_RS_
