//$Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273_HMtg_common.rs.rca 1.2 Wed May 30 09:25:43 2012 sstalukd Experimental $

//$Log: p1273_HMtg_common.rs.rca $
//
// Revision: 1.2 Wed May 30 09:25:43 2012 sstalukd
// Modified polyfd_area to correctly reflect large tg regions area of 30um2 instead of 200um2
//
// Revision: 1.1 Tue Feb 28 09:11:01 2012 sstalukd
// Initial checkin for 1273 module
//

//Common def - to be used by both HMtg and halfdrc modules

#ifndef _P1273_HMCOMM_RS_
#define _P1273_HMCOMM_RS_

//12723 now has two  TG poly id - V3pitchID and V1pitchID
//1273 HMtg is actually based on TGOXID, not the V1/V3 pitchID - so keeping existing infrastructure, use TGOXID for both v1pitch, v3pitch
polyfd_v1pitch  =  copy(TGOXID);
polyfd_v3pitch  =  copy(TGOXID);

polyfd_dsize: double = 6;
polyfd_area:  double = 30;

//Need to calculate separate tg, wtg regions since the transition region spacing is different
//and we will need to calculate min spacing from cell boundary and between large fd regions

//Need to subtract drgrid (=0.001) inorder for exact 6um polygons to be selected
large_polyfd_v1pitch_regions_size  = drUnderOver(polyfd_v1pitch,(polyfd_dsize-drgrid)/2);
large_polyfd_v3pitch_regions_size = drUnderOver(polyfd_v3pitch,(polyfd_dsize-drgrid)/2);

//This is new in 12723 to select polygons based on area >= 30um2
large_polyfd_v1pitch_regions_area  = area(layer1=polyfd_v1pitch,value >= polyfd_area); 
large_polyfd_v3pitch_regions_area = area(layer1=polyfd_v3pitch,value >= polyfd_area); 

large_polyfd_v1pitch_regions = large_polyfd_v1pitch_regions_size or large_polyfd_v1pitch_regions_area;
small_polyfd_v1pitch_regions = polyfd_v1pitch not large_polyfd_v1pitch_regions;

large_polyfd_v3pitch_regions = large_polyfd_v3pitch_regions_size or large_polyfd_v3pitch_regions_area;
small_polyfd_v3pitch_regions = polyfd_v3pitch not large_polyfd_v3pitch_regions;

large_polyfd_regions = or(large_polyfd_v1pitch_regions,large_polyfd_v3pitch_regions);
small_polyfd_regions = or(small_polyfd_v1pitch_regions,small_polyfd_v3pitch_regions);

#endif //#ifndef _P12723_HMCOMM_RS_