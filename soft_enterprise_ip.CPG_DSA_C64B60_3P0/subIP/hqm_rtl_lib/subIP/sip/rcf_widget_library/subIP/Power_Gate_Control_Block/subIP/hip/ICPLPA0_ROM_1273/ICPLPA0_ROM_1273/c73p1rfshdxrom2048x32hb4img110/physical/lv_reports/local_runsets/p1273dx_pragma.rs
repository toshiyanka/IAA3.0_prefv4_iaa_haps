// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_pragma.rs.rca 1.3 Thu Jan 19 17:30:00 2012 dgthakur Experimental $

// $Log: p1273dx_pragma.rs.rca $
// 
//  Revision: 1.3 Thu Jan 19 17:30:00 2012 dgthakur
//  Setting default value of PROJECT to none hsd 1082.
// 
//  Revision: 1.2 Mon Jan  9 14:28:14 2012 kperrey
//  byproduct of hsd1098; change ENV variable usage to _dr format ; removed ENV vars from the pragma list DR_DISPLAY_PCT_LOOP/DR_NWELLTAP/DR_SUBTAP/DR_DC_WAIVE/DR_DIC_EXISTENCE_CHECK/DR_DIC_DEBUG
// 
//  Revision: 1.1 Mon Sep 19 22:02:02 2011 kperrey
//  derived from 1272
// 
//

#ifndef _P1273DX_PRAGMA_RS_
#define _P1273DX_PRAGMA_RS_

// from p12723_DC.rs
// #pragma envvar default DR_DC_WAIVE "YES"

// from p12723_DIC.rs
// #pragma envvar default DR_DIC_DEBUG "NO"
// #pragma envvar default DR_DIC_EXISTENCE_CHECK "YES"

// from p12723_NW.rs
// #pragma envvar default DR_NWELLTAP "YES"
// #pragma envvar default DR_SUBTAP "YES"

// from p12723_PL1.rs
// #pragma envvar default DR_DISPLAY_PCT_LOOP "NO"

// from p12723_UserDefines.rs
#pragma envvar default PROJECT "none"

// from boundaryDefinitions.rs
#pragma envvar default DR_PROJECT "none"

// from dr_cell_lists 
#pragma envvar default DR_TC_FULL_DIE "NO"

// from tapein_merge
#pragma envvar default PDSOASOUT "."
#pragma envvar default PDSSTMOUT "."

// from userOpenAccessOptions.rs
// #pragma envvar default DR_OALayerMappingFile "$ISSRUNSETS/PXL/p1273.oamap"

#endif   // ifndef _P1273DX_PRAGMA_RS_

