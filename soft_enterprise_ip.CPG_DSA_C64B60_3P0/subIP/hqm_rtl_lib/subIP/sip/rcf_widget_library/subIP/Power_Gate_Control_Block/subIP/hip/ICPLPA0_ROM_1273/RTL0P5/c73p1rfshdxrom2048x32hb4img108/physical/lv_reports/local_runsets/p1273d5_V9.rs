// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d5_V9.rs.rca 1.1 Thu Dec  6 00:14:54 2012 dgthakur Experimental $
//
// $Log: p1273d5_V9.rs.rca $
// 
//  Revision: 1.1 Thu Dec  6 00:14:54 2012 dgthakur
//  New wrapper files for p1273.5.
//


#ifndef _P1273D5_V9_RS_
#define _P1273D5_V9_RS_


#include <p12723_metal_via_common.rs>


//Set via id and dl (for error output)
#define vid 9
#define vidp 10

#define vndl 45
#define mnpdl 54
#define mndl 46

#define METALNP  METAL10
#define vian     via9
#define VIAN     VIA9
#define METALN   METAL9


#include <p12723_MX1080pitch_via.rs>


//Undefine just to be safe
#undef vndl
#undef mnpdl
#undef mndl 

#undef METALNP 
#undef vian    
#undef VIAN    
#undef METALN  


#endif //_P1273D5_V9_RS_
