// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_M8.rs.rca 1.3 Tue May 21 00:57:32 2013 dgthakur Experimental $  
//
// $Log: p1273dx_M8.rs.rca $
// 
//  Revision: 1.3 Tue May 21 00:57:32 2013 dgthakur
//  Moved 1273.4 M8 and 1273.5 M8/M9 code to new 252 metal pitch code. 1273.6 M10 and M11 was already using new 252 pitch code.
// 
//  Revision: 1.2 Mon Apr  2 23:15:58 2012 tmurata
//  x73a etchring only flag suppression.
// 
//  Revision: 1.1 Thu Aug 11 17:18:30 2011 dgthakur
//  First check in for 1273.
//



#ifndef _P1273DX_M8_RS_
#define _P1273DX_M8_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 8
#define mxdl 38


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



#endif //_P1273DX_M8_RS_
