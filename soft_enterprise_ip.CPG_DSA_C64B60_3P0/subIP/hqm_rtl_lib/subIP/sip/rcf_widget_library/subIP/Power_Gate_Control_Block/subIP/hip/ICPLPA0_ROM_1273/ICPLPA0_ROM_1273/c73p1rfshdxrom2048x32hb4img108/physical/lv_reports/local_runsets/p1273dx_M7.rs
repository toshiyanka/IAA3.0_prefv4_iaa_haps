// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_M7.rs.rca 1.3 Mon Aug 18 11:18:00 2014 ngeorge3 Experimental $
//
// $Log: p1273dx_M7.rs.rca $
// 
//  Revision: 1.3 Mon Aug 18 11:18:00 2014 ngeorge3
//  Added section level waivers for M7 and M8. Related to HSD 2521 (Donald Nguyen)
// 
//  Revision: 1.2 Wed Jun  6 17:37:38 2012 dgthakur
//  Updated M7 W_01/02 space checks (M7_21/22/26/27/37/38 rules).
// 
//  Revision: 1.1 Thu Aug 11 17:18:30 2011 dgthakur
//  First check in for 1273.
//


//*** p1273 M7 runset - Dipto Thakurta Started 02Jul11 *** 
//Generic code for 112 metal pitch.  Cannot be re-used for the
//space checks if rotated as we are still using pgd/ogd in metal 
//bin nomenclature (need little more work).

#ifndef _P1273DX_M7_RS_
#define _P1273DX_M7_RS_
#include <p12723_metal_via_common.rs>

//Set metal id and metal dl (for error output)
#define mid 7
#define mxdl 34


//SOME CUSTOM ERROR DEFINITIONS

drErrGDSHash[xc(MX(ER0))] = {mxdl,2000};
drHash[xc(MX(ER0))] = xc(Illegal metalx width or orientation);
drValHash[xc(MX(ER0))] = 0;

drErrGDSHash[xc(MX(ER1))] = {mxdl,2001};
drHash[xc(MX(ER1))] = xc(Global min metalx space);
drValHash[xc(MX(ER1))] = MX(21);

drErrGDSHash[xc(MX(21/22/26/27/37))] = {mxdl,1021};
drHash[xc(MX(21/22/26/27/37))] = xc(Illegal metalx width_01 or width_02 space);
drValHash[xc(MX(21/22/26/27/37))] = 0;



//Bad width/aspect/min width
drCopyToError_(xc(MX(ER0)), mx(Bad)); 
drMinWidthDir_(xc(MX(ER0)), METALX, MX(03), mx(para_dir));
drMinWidth_(xc(MX(ER0)), METALX, MX(01));


//Global space check
drMinSpaceAllround_(xc(MX(ER1)), METALX, MX(21));


//Get some drived layers used for space checks
mx(pgd_1to2ve) = drOrEdges({ mx(pgd01ve), mx(pgd02ve)} );
mx(pgd_3to7ve) = drOrEdges({ mx(pgd03ve), mx(pgd04ve), mx(pgd05ve), mx(pgd06ve), mx(pgd07ve)} );
mx(pgd_3to4ve) = drOrEdges({ mx(pgd03ve), mx(pgd04ve)} );
mx(pgd_5to7ve) = drOrEdges({ mx(pgd05ve), mx(pgd06ve), mx(pgd07ve)} );

//Used for blocking
mx(ete_37) = drSpace( metalx, <=MX(37), mx(para_dir)); //for MX(37/38) space waiver
mx(pgd_3to7) = drOrLayers({ mx(pgd03), mx(pgd04), mx(pgd05), mx(pgd06), mx(pgd07), } ); 

//Space between PGD wires

/** Old space rules
drMinSpaceDir2STCB_(xc(MX(21)),mx(pgd_1to2ve), mx(pgd_1to2ve), [0, MX(21)), mx(perp_dir)); 
drMinSpaceDir2STCB_(xc(MX(22)),mx(pgd_1to2ve), mx(pgd_1to2ve), (MX(22), MX(23)), mx(perp_dir)); 
drMinSpaceDir2STCB_(xc(MX(24)),mx(pgd_1to2ve), mx(pgd_1to2ve), (MX(24), MX(25)), mx(perp_dir), 
  block=mx(ete_37) or mx(pgd_3to7)); 
drMinSpaceDir2STCB_(xc(MX(26)),mx(pgd_1to2ve), mx(pgd_3to7ve), [0, MX(26)), mx(perp_dir)); 
drMinSpaceDir2STCB_(xc(MX(27)),mx(pgd_1to2ve), mx(pgd_3to7ve), (MX(27), MX(28)), mx(perp_dir));
**/


//W_01 space check
e1 = not_external1_edge(    mx(pgd01ve),    distance = [MX(21), MX(22)], ext_opt_ngd);  //1-1
e2 = not_external2_edge(e1, mx(pgd02ve),    distance = [MX(21), MX(22)], ext_opt_ngd);  //1-2 
e3 = not_external2_edge(e2, mx(pgd_3to7ve), distance = [MX(26), MX(27)], ext_opt_ngd);  //1-(3to7) 
e4 = not_length_edge(e3, distance <=MX(37));
ew01 = copy_edge(e3);   //check later
drCopyEdgeToError_(xc(MX(21/22/26/27/37)), e4 not_edge mx(sec_lev_wv_ring));

ew01short = ew01 not_coincident_edge e4;
drM4PPPSpecial_(xc(MX(21/22/26/27/37)), ew01short, mx(_line_end), metalx, <MX(38), mx(perp_dir));


//W_02 space check
e1 = not_external1_edge(    mx(pgd02ve),    distance = [MX(21), MX(22)], ext_opt_ngd);  //2-2
e2 = not_external2_edge(e1, mx(pgd01ve),    distance = [MX(21), MX(22)], ext_opt_ngd);  //2-1 
e3 = not_external2_edge(e2, mx(pgd_3to7ve), distance = [MX(26), MX(27)], ext_opt_ngd);  //2-(3to7) 
e4 = not_length_edge(e3, distance <=MX(37));
ew02 = copy_edge(e3);   //check later
drCopyEdgeToError_(xc(MX(21/22/26/27/37)), e4);

ew02short = ew02 not_coincident_edge e4;
drM4PPPSpecial_(xc(MX(21/22/26/27/37)), ew02short, mx(_line_end), metalx, <MX(38), mx(perp_dir));


//Need to check unfaced edge collectively (connect over jogs)
mx(_exp_edge) = ew01 or_edge ew02;
g_max_metal_exposed_edge_length = MX(37); //global variable
drUnfacedMetalEdge_( xc(MX(37)), metalx, mx(_exp_edge), mx(pgdallhe), mx(sec_lev_wv_ring));


drMinSpaceDir2STCB_(xc(MX(31)),mx(pgd_3to4ve), mx(pgd_3to4ve), [0, MX(31)), mx(perp_dir));
drMinSpaceDir2STCB_(xc(MX(32)),mx(pgd_3to7ve), mx(pgd_5to7ve), [0, MX(32)), mx(perp_dir));


//Space between OGD wire
drMinSpaceDir_(xc(MX(35)), mx(ogd03he), <MX(35), mx(para_dir));


//ETE space
drMinSpaceDir_(xc(MX(41)), mx(_line_end), <MX(41), mx(perp_dir));
drMinSpaceDir_(xc(MX(41)), mx(_line_end), <MX(41), mx(para_dir));


//Attacker rules
mx(para_edge_temp) = mx(para_edge) not_coincident_edge mx(_line_end);
drMinSpaceDir2_( xc(MX(51)), mx(_line_end), mx(para_edge_temp), <MX(51), mx(perp_dir));

mx(perp_edge_temp) = mx(perp_edge) not_coincident_edge mx(_line_end);
drMinSpaceDir2_( xc(MX(52)), mx(_line_end), mx(perp_edge_temp), <MX(52), mx(para_dir));


//OTHER CHECKS


//MX(74)
err @= {
  @ GetRuleString(xc(MX(74))); note(CheckingString(xc(MX(74))));
  mx(_short_edge) = length_edge( metalx, distance < MX(70));
  mx(_line_end_temp) = mx(_line_end) not_coincident_edge mx(_short_edge); 
  mx(_short_edge_os) = edge_size( mx(_short_edge), inside=drunit, outside=drunit);
  external2(mx(_short_edge_os), mx(_line_end_temp), distance <MX(74), extension = RADIAL, intersecting = {});
}
drPushErrorStack(err, xc(MX(74)));

drMinExtent_( xc(MX(60)), metalx, MX(60));
drMinSegLengthWithException_( xc(MX(70)), metalx, MX(70), MX(73));  //checks MX(70)/72/73
drMinSegLengthCorner_( xc(MX(71)), metalx, MX(71));
drMinHoleLength_( xc(MX(65)), metalx, MX(65));
drMinSpaceC2C_( xc(MX(80)), metalx, MX(80));
drMinwidthC2C_( xc(MX(81)), metalx, MX(81));
drM82check_( xc(MX(82)), metalx, MX(82), 0.056);
drMinNotch_( xc(MX(83)), metalx, MX(83), MX(84));  //checks MX(83)/84


//DEBUG LAYERS
drPassthru( METALX, mxdl, 0);


//Undefine mid to be safe
#undef mid 
#undef mxdl


#endif //_P1273DX_M7_RS_
