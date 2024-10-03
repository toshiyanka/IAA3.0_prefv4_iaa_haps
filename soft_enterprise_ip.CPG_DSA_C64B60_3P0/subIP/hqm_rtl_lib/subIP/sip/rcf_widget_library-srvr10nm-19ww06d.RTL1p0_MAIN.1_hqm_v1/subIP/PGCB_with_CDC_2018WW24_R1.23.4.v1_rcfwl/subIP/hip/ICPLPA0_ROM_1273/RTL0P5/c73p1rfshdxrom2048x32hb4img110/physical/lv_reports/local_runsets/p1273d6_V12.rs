// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V12.rs.rca 1.2 Thu Mar 28 23:22:44 2013 nhkhan1 Experimental $
//
// $Log: p1273d6_V12.rs.rca $
// 
//  Revision: 1.2 Thu Mar 28 23:22:44 2013 nhkhan1
//  first time check in
// 
//  Revision: 1.1 Tue Mar 26 14:23:32 2013 dgthakur
//  Placeholder for 1273.6 V12 code (or wrapper).
//



#ifndef _P1273D6_V12_RS_
#define _P1273D6_V12_RS_


#include <p12723_metal_via_common.rs>


//Set via id and dl (for error output)
#define vid 12
#define vndl 61

#define vian     VIA12
#define VIAN     VIA12
#define METALN   METAL12


//Include TM1 via common file
#include <p12723_TM1_via.rs>


//Undefine just to be safe
#undef vid 
#undef vndl

#undef vian   
#undef VIAN   
#undef METALN


// Push pass through layers for debug 
drPassthruStack.push_back({ METAL12, {62,0} });
drPassthruStack.push_back({ VIA12, {61,0} });
drPassthruStack.push_back({ TM1BC, {42,0} });
drPassthruStack.push_back({ v12typeRA, {61,21} });
drPassthruStack.push_back({ v12typeRB, {61,22} });
drPassthruStack.push_back({ v12typeRC, {61,23} });



#endif //_P1273D6_V12_RS_
