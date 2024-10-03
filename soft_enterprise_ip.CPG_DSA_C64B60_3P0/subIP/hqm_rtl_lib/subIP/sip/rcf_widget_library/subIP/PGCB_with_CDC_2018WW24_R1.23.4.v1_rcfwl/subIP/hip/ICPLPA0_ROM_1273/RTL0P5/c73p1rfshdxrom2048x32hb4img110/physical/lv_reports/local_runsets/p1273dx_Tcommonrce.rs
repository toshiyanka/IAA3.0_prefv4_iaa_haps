// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tcommonrce.rs.rca 1.18 Thu Jan  8 10:35:55 2015 kperrey Experimental $

// $Log: p1273dx_Tcommonrce.rs.rca $
// 
//  Revision: 1.18 Thu Jan  8 10:35:55 2015 kperrey
//  hsd 2997; updates from Mahesh
// 
//  Revision: 1.17 Thu Oct 30 17:00:49 2014 kperrey
//  updates from srimathi ; vianores stomp on via update for rcextract
// 
//  Revision: 1.16 Sat Oct  4 17:51:01 2014 kperrey
//  updates from Srimathi
// 
//  Revision: 1.15 Thu Sep 25 21:19:12 2014 kperrey
//  change _drProcess to _drPROCESS
// 
//  Revision: 1.14 Tue Aug  5 22:23:40 2014 kperrey
//  removed reference to scm/som/scv/sov devices and via*nores since they were not program approved enhancements as per chia-hong
// 
//  Revision: 1.13 Thu Jul 31 19:58:11 2014 kperrey
//  now handle via*nores in the data manips
// 
//  Revision: 1.12 Thu Apr 10 12:53:09 2014 kperrey
//  update from srimathi ; handle some ICFMIM stuff
// 
//  Revision: 1.11 Mon Mar  3 13:45:31 2014 kperrey
//  hsd 2165 ; remove poly_nores_nogate referance now just all poly_nores and is done in p1273dx_Tcommon.rs
// 
//  Revision: 1.10 Thu Feb 20 19:56:31 2014 kperrey
//  hsd 2130 ; remove mos_[pn]gate_stk from poly_nores for poly_nores_nogate
// 
//  Revision: 1.9 Thu Feb 20 07:48:54 2014 kperrey
//  hsd 2128 ; use the updated gate names for rf devices to be removed from poly_nores_nogate
// 
//  Revision: 1.8 Sun Jan  5 16:01:11 2014 kperrey
//  add in the support for all the rf type gates
// 
//  Revision: 1.7 Thu Mar 28 18:12:26 2013 kperrey
//  add some pwell related layers for 1273.6
// 
//  Revision: 1.6 Fri Dec 28 12:00:07 2012 kperrey
//  added handling for NV3/PV3
// 
//  Revision: 1.5 Fri Aug 10 11:28:48 2012 kperrey
//  support for 73.6 add m10/m11
// 
//  Revision: 1.4 Mon May 14 16:54:13 2012 kperrey
//  remove _drsubstrate redef ; may have to go back to ndev_bulk
// 
//  Revision: 1.3 Mon May 14 09:42:38 2012 kperrey
//  replace ndev_bulk by redefinition of __drsubstrate
// 
//  Revision: 1.2 Thu Apr 26 15:52:05 2012 kperrey
//  add tcn_topMarker generation
// 
//  Revision: 1.1 Mon Apr  9 15:14:10 2012 kperrey
//  more scarlet/rce hooks
// 

#ifndef _P1273DX_TCOMMONRCE_RS_
#define _P1273DX_TCOMMONRCE_RS_

#ifdef _drRCextract_GCN_dummyCell
	polycon_nores_dummy = copy_by_cells(polycon_nores, RCextract_GCN_dummyCell);
	polycon_nores_logic = polycon_nores not polycon_nores_dummy;
	VIACONG = VIACON interacting polycon_nores_logic;
#else
	VIACONG = VIACON interacting polycon_nores;
#endif

   VIACONT = VIACON not VIACONG;
   VIACONG_nq = internal1(VIACONG, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIACONG = VIACONG not VIACONG_nq;
   VIACONT_nq = internal1(VIACONT, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIACONT = VIACONT not VIACONT_nq;
   VIA0_nq = internal1(VIA0, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA0 = VIA0 not VIA0_nq;
   VIA1_nq = internal1(VIA1, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA1 = VIA1 not VIA1_nq;
   VIA2_nq = internal1(VIA2, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA2 = VIA2 not VIA2_nq;
   VIA3_nq = internal1(VIA3, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA3 = VIA3 not VIA3_nq;
   VIA4_nq = internal1(VIA4, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA4 = VIA4 not VIA4_nq;
   VIA5_nq = internal1(VIA5, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA5 = VIA5 not VIA5_nq;
   VIA6_nq = internal1(VIA6, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA6 = VIA6 not VIA6_nq;
   VIA7_nq = internal1(VIA7, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA7 = VIA7 not VIA7_nq;
   VIA8_nq = internal1(VIA8, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA8 = VIA8 not VIA8_nq;
   VIA9_nq = internal1(VIA9, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
   VIA9 = VIA9 not VIA9_nq;
   #if _drPROCESS == 6
      VIA10_nq = internal1(VIA10, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
      VIA10 = VIA10 not VIA10_nq;
      VIA11_nq = internal1(VIA11, distance <= 0.001, extension = NONE, orientation = {PARALLEL}, direction = HORIZONTAL, processing_mode = CELL_LEVEL);
      VIA11 = VIA11 not VIA11_nq;
   #endif

#ifdef _drBridgeViaWA
      //Via0, 1 and 2 shunt via runset WA for extraction
      
   VIA0_metal0 = VIA0 and metal0nores;
   VIA0_SHUNTS = interacting (VIA0, VIA0_metal0, count=2); 
   VIA0_SHUNTS_BREAK = VIA0_SHUNTS and VIA0_metal0;
   VIA0_SHUNTS_SMALL = polygon_centers ( layer1 = VIA0_SHUNTS_BREAK, shape_size = 0.01 );	       

   VIA0 = VIA0 not VIA0_SHUNTS;
   VIA0 = VIA0 or VIA0_SHUNTS_SMALL;

   VIA1_metal1 = VIA1 and metal1nores;
   VIA1_SHUNTS = interacting (VIA1, VIA1_metal1, count=2); 
   VIA1_SHUNTS_BREAK = VIA1_SHUNTS and VIA1_metal1;
   VIA1_SHUNTS_SMALL = polygon_centers ( layer1 = VIA1_SHUNTS_BREAK, shape_size = 0.01 );            

   VIA2_metal2 = VIA2 and metal2nores;
   VIA2_SHUNTS = interacting (VIA2, VIA2_metal2, count=2); 
   VIA2_SHUNTS_BREAK = VIA2_SHUNTS and VIA2_metal2;
   VIA2_SHUNTS_SMALL = polygon_centers ( layer1 = VIA2_SHUNTS_BREAK, shape_size = 0.01 );            
#endif

   cont_sub2npickup = copy(npickup);
   cont_sub2ppickup = copy(ppickup);
   cont_pwell2pwelltap = copy(pwelltap);
   cont_sub2nac_anode = copy(nac_anode);
   cont_pwell2dnpdnw_anode = copy(dnpdnw_anode);
   cont_pwell2dpndnw_anode = copy(dpndnw_anode);
   cont_ndiff2tcn = diffcon_nores and nnogate;
   cont_pdiff2tcn = diffcon_nores and pnogate;

   // this creates a lot of opens - may have to go back to original style
//   __drsubstrate = __drsubstrate and [processing_mode = CELL_LEVEL] NDIFF;

   // grow tcn by 1 grid top and then remove original tcn
   tcn_topMarker = grow(DIFFCON, north = drgrid) not DIFFCON;


#if( defined(_drICFMIM) )
   #if _drPROCESS == 6
      viace2      = and(via12nores,mim_scl_top_plate);
      viace1      = and(via12nores,mim_scl_bottem_plate);
      via12nores  = not(via12nores,or(viace1,viace2));
   #else
      viace2      = and(via9nores,mim_scl_top_plate);
      viace1      = and(via9nores,mim_scl_bottem_plate);
	  via9nores   = not(via9nores,or(viace1,viace2));
   #endif

   mimcap_cell_extent = cell_extent(cell_list = {"mimcap_scl*","mimcap_stk_scl*"});
#endif

#endif  // end _P1273DX_TCOMMONRCE_RS_
