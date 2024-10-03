// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_M5.rs.rca 1.3 Tue May  7 18:55:11 2013 dgthakur Experimental $
//
// $Log: p1273dx_M5.rs.rca $
// 
//  Revision: 1.3 Tue May  7 18:55:11 2013 dgthakur
//  Added new DRC for flagging large open areas in metals.  Previously this rule was 4$  DFM; now it is moved to standard DRC.
// 
//  Revision: 1.1 Wed Jul 20 17:00:41 2011 dgthakur
//  First check in for 1273 files
//


//*** p1273 M5 runset - Dipto Thakurta Started 27Jun11 *** 
#ifndef _P1273DX_M5_RS_
#define _P1273DX_M5_RS_
#include <p12723_metal_via_common.rs>


//Set metal id and metal dl (for error output)
#define mid 5
#define mxdl 26
#define VIAN VIA5
#define VIANM VIA4


//Check Widths
mx(ListOfWidths): list of double = {
MXS(01),MXS(02),MXS(03),MXS(04),
MXM(02),MXM(03),
MXL(01),MXL(02),MXL(09),MXL(03),MXL(07),MXL(05),MXL(06)
};


//Include the layer derivation and global space and ETE checks
#include <p12723_MXBC_common.rs>


drWidthList_(xc(MX(ER0)), mx(b_all), mx(ListOfWidths), mx(perp_dir)); 
//drWidthList_(xc(MX(ER0)), mx(c_all), mx(ListOfWidths), mx(perp_dir)); 
drWidthList_(xc(MX(ER0)), mx(c),       mx(ListOfWidths), mx(perp_dir)); 
drWidthList_(xc(MX(ER0)), mx(c_synth), mx(ListOfWidths), mx(perp_dir), mx(c_synth_00_waive)); 


//Generate the template waiver regions
#include <1273/p1273dx_MXBC_template.rs>
mx(TW) = mx(wvA) or mx(wvB);


//Not allowed B-C-B pairs (waivers will be needed for templates)
drInvalidBCB_( xc(MX(136)), mx(b_all), mx(c_all), [0.028, 0.036], [0.056, 0.084], [0.028, 0.036], <=MX(21), mx(perp_dir));
drInvalidBCB_( xc(MX(137)), mx(b_all), mx(c_all), [0.028, 0.046], [0.060, 0.084], [0.038, 0.046], <=MX(21), mx(perp_dir));
drInvalidBCB_( xc(MX(138)), mx(b_all), mx(c_all), [0.028, 0.036], [0.028, 0.036], [0.056, 0.084], <=MX(21), mx(perp_dir), mx(TW));
drInvalidBCB_( xc(MX(138)), mx(b_all), mx(c_all), [0.028, 0.036], [0.060, 0.084], [0.056, 0.084], <=MX(21), mx(perp_dir));
drInvalidBCB_( xc(MX(139)), mx(b_all), mx(c_all), [0.040, 0.046], [0.028, 0.036], [0.056, 0.084], <=MX(21), mx(perp_dir));
drInvalidBCB_( xc(MX(139)), mx(b_all), mx(c_all), [0.040, 0.046], [0.084, 0.084], [0.056, 0.084], <=MX(21), mx(perp_dir));
drInvalidBCB_( xc(MX(140)), mx(b_all), mx(c_all), [0.056, 0.084], [0.028, 0.036], [0.056, 0.084], <=MX(21), mx(perp_dir));
drInvalidBCB_( xc(MX(141)), mx(b_all), mx(c_all), [0.028, 0.028], [0.056, 0.056], [0.076, 0.076], <=MX(21), mx(perp_dir));


//Not allowed B-C pairs (waivers will be needed for templates)
drInvalidBC_( xc(MX(126)), mx(b_all), [0.028,0.036], mx(c_all), [0.060, 0.084], <=MX(21), mx(perp_dir));
drInvalidBC_( xc(MX(127)), mx(b_all), [0.040,0.046], mx(c_all), [0.084, 0.084], <=MX(21), mx(perp_dir));
drInvalidBC_( xc(MX(128)), mx(b_all), [0.056,0.084], mx(c_all), [0.028, 0.036], <=MX(21), mx(perp_dir), mx(TW));



//PRINT DEBUG LAYERS
//////////////////////////////////////////////////////////////////////////////////////

drPassthruStack.push_front({ mx(b), {26,0} });
drPassthruStack.push_front({ mx(c), {115,0} });
drPassthruStack.push_front({ mx(b_synth), {26,1} });
drPassthruStack.push_front({ mx(c_synth), {115,1} });
drPassthruStack.push_front({ CELLBOUNDARY, {50,0} });


//Undefine mid to be safe
#undef mid 
#undef mxdl 
#undef VIAN
#undef VIANM 


#endif //_P1273DX_M5_RS_

