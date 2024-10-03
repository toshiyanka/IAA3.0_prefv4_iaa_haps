// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_V11.rs.rca 1.3 Thu Mar 28 17:01:11 2013 nhkhan1 Experimental $
//
// $Log: p1273d6_V11.rs.rca $
// 
//  Revision: 1.3 Thu Mar 28 17:01:11 2013 nhkhan1
//  p1273_MX1080pitchVia works for this via, so it is used instead
// 
//  Revision: 1.2 Thu Mar 28 16:42:29 2013 nhkhan1
//  now this code is self-contained, for WW 13 release of p1273.6
// 
//  Revision: 1.1 Tue Aug 21 01:23:53 2012 dgthakur
//  1273.6 via code wrappers.
//



#ifndef _P1273D6_V11_RS_
#define _P1273D6_V11_RS_


#include <p12723_metal_via_common.rs>


//Set via id and dl (for error output)
#define vid 11
#define vidp 12

#define vndl 57
#define mnpdl 62
#define mndl  58


#define vian     via11
#define VIAN     VIA11
#define METALN   METAL11
#define METALNP  METAL12

#include <p12723_MX1080pitch_via.rs>

//Undefine just to be safe
#undef vid 
#undef vndl

#undef vian   
#undef VIAN   
#undef METALN


#endif //_P1273D6_V11_RS_
