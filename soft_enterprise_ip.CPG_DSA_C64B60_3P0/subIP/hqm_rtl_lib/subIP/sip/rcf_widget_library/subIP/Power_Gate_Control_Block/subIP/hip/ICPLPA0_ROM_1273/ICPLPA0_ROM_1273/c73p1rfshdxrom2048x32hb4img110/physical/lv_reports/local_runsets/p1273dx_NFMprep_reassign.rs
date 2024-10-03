// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_NFMprep_reassign.rs.rca 1.1 Thu Oct 16 19:45:17 2014 kperrey Experimental $
//
// $Log: p1273dx_NFMprep_reassign.rs.rca $
// 
//  Revision: 1.1 Wed Oct  1 09:07:56 2014 qfan4
//  metal layer merge for NFM(1273/dot1)
// 

#ifndef _P1273DX_NFMPREP_REASSIGN_RS_
#define _P1273DX_NFMPREP_REASSIGN_RS_

// add filtering on FILLGUIDE by taking out the FILLGUIDE in x.46
MET1fg = not_inside(metal1_fillGuide, metal1_nfmExclude);
MET2fg = not_inside(metal2_fillGuide, metal2_nfmExclude);
MET3fg = not_inside(metal3_fillGuide, metal3_nfmExclude);
MET4fg = not_inside(metal4_fillGuide, metal4_nfmExclude);
MET5fg = not_inside(metal5_fillGuide, metal5_nfmExclude);
MET6fg = not_inside(metal6_fillGuide, metal6_nfmExclude);
MET7fg = not_inside(metal7_fillGuide, metal7_nfmExclude);
MET8fg = not_inside(metal8_fillGuide, metal8_nfmExclude);
MET9fg = not_inside(metal9_fillGuide, metal9_nfmExclude);

// no metal c exclude layer, use metal NFM exclude layer
METC2fg = not_inside(metalc2_fillGuide, metal2_nfmExclude);
METC3fg = not_inside(metalc3_fillGuide, metal3_nfmExclude);
METC4fg = not_inside(metalc4_fillGuide, metal4_nfmExclude);
METC5fg = not_inside(metalc5_fillGuide, metal5_nfmExclude);
METC6fg = not_inside(metalc6_fillGuide, metal6_nfmExclude);
METC7fg = not_inside(metalc7_fillGuide, metal7_nfmExclude);
METC8fg = not_inside(metalc8_fillGuide, metal8_nfmExclude);
METC9fg = not_inside(metalc9_fillGuide, metal9_nfmExclude);


cb_std_cell = copy_by_cells(CELLBOUNDARY, cells = "d04*", depth = CELL_LEVEL);
MET1_fillguide  = metal1_fillGuide not cb_std_cell;

// info for fill marker
// MB0 fillmarker - 81 47 sliE3_APRannotation
// MC0 fillmarker - 81 42 sliA3_APRannotation
// M1  fillmarker - 81 49 sliE4_APRannotation

METAL0   = METAL0   or sliE3_APRannotation;
METALC0  = METALC0  or sliA3_APRannotation;

METAL1_nfm_fill  = sliE4_APRannotation  or MET1_fillguide;

METAL1   = METAL1   or METAL1_nfm_fill;

// M2-9
METAL2   = METAL2   or metal2_fillGuide;
METAL3   = METAL3   or metal3_fillGuide;
METAL4   = METAL4   or metal4_fillGuide;
METAL5   = METAL5   or metal5_fillGuide;
METAL6   = METAL6   or metal6_fillGuide;
METAL7   = METAL7   or metal7_fillGuide;
METAL8   = METAL8   or metal8_fillGuide;
METAL9   = METAL9   or metal9_fillGuide;

METALC2  = METALC2  or metalc2_fillGuide;
METALC3  = METALC3  or metalc3_fillGuide;
METALC4  = METALC4  or metalc4_fillGuide;
METALC5  = METALC5  or metalc5_fillGuide;
METALC6  = METALC6  or metalc6_fillGuide;
METALC7  = METALC7  or metalc7_fillGuide;
METALC8  = METALC8  or metalc8_fillGuide;
METALC9  = METALC9  or metalc9_fillGuide;

#if 0
   METAL0BC = METAL0BC or (sliE3_APRannotation or sliA3_APRannotation);
   METAL1BC = METAL1BC or METAL1_nfm_fill;
   // dont need these since we have the component parts (and these are not "real" mask layer)
   METAL2BC = METAL2BC or (metal2_fillGuide or metalc2_fillGuide);
   METAL3BC = METAL3BC or (metal3_fillGuide or metalc3_fillGuide);
   METAL4BC = METAL4BC or (metal4_fillGuide or metalc4_fillGuide);
   METAL5BC = METAL5BC or (metal5_fillGuide or metalc5_fillGuide);
   METAL6BC = METAL6BC or (metal6_fillGuide or metalc6_fillGuide);
   METAL7BC = METAL7BC or (metal7_fillGuide or metalc7_fillGuide);
   METAL8BC = METAL8BC or (metal8_fillGuide or metalc8_fillGuide);
   METAL9BC = METAL9BC or (metal9_fillGuide or metalc9_fillGuide);
#endif

#endif
