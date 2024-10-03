// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_NFM_reassign.rs.rca 1.5 Sat Nov  8 16:10:55 2014 qfan4 Experimental $
//
// $Log: p1273dx_NFM_reassign.rs.rca $
// 
//  Revision: 1.5 Sat Nov  8 16:10:55 2014 qfan4
//  change NFM reassign to make NFM work outside 1273.1
// 
//  Revision: 1.4 Fri Nov  7 10:15:33 2014 qfan4
//  ci the saved layer for NFM
// 
//  Revision: 1.3 Thu Oct  9 09:48:22 2014 qfan4
//  change the copy_by_cell to CELL_LEVEL
// 
//  Revision: 1.2 Wed Oct  8 14:45:46 2014 qfan4
//  remove the METAL TRACK within NFMEXCLUDE layer from merging
//  save the initial layer for NFM usage
// 
//  Revision: 1.1 Wed Oct  1 09:07:56 2014 qfan4
//  metal layer merge for NFM(1273/dot1)
// 

#ifndef _P1273DX_NFM_REASSIGN_RS_
#define _P1273DX_NFM_REASSIGN_RS_

// add filtering on FILLGUIDE by taking out the FILLGUIDE in x.46
MET1fg = not_inside(MET1FILLGUIDE, MET1NFMEXCLUDE);
MET2fg = not_inside(MET2FILLGUIDE, MET2NFMEXCLUDE);
MET3fg = not_inside(MET3FILLGUIDE, MET3NFMEXCLUDE);
MET4fg = not_inside(MET4FILLGUIDE, MET4NFMEXCLUDE);
MET5fg = not_inside(MET5FILLGUIDE, MET5NFMEXCLUDE);
MET6fg = not_inside(MET6FILLGUIDE, MET6NFMEXCLUDE);
MET7fg = not_inside(MET7FILLGUIDE, MET7NFMEXCLUDE);
MET8fg = not_inside(MET8FILLGUIDE, MET8NFMEXCLUDE);
MET9fg = not_inside(MET9FILLGUIDE, MET9NFMEXCLUDE);

// no metal c exclude layer, use metal NFM exclude layer
METC2fg = not_inside(METC2FILLGUIDE, MET2NFMEXCLUDE);
METC3fg = not_inside(METC3FILLGUIDE, MET3NFMEXCLUDE);
METC4fg = not_inside(METC4FILLGUIDE, MET4NFMEXCLUDE);
METC5fg = not_inside(METC5FILLGUIDE, MET5NFMEXCLUDE);
METC6fg = not_inside(METC6FILLGUIDE, MET6NFMEXCLUDE);
METC7fg = not_inside(METC7FILLGUIDE, MET7NFMEXCLUDE);
METC8fg = not_inside(METC8FILLGUIDE, MET8NFMEXCLUDE);
METC9fg = not_inside(METC9FILLGUIDE, MET9NFMEXCLUDE);

cb_std_cell = copy_by_cells(CELLBOUNDARY, cells = "d04*", depth = CELL_LEVEL);
MET1_fillguide  = MET1fg not cb_std_cell;

// info for fill marker
// MB0 fillmarker - 81 47 SLIE3
// MC0 fillmarker - 81 42 SLIA3
// M1  fillmarker - 81 49 SLIE4

METAL0   = METAL0   or SLIE3;
METALC0  = METALC0  or SLIA3;
METAL0BC = METAL0BC or (SLIE3 or SLIA3);

METAL1_nfm_fill  = SLIE4  or MET1_fillguide;

METAL1   = METAL1   or METAL1_nfm_fill;
METAL1BC = METAL1BC or METAL1_nfm_fill;

// M2-9
METAL2   = METAL2   or MET2fg;
METAL3   = METAL3   or MET3fg;
METAL4   = METAL4   or MET4fg;
METAL5   = METAL5   or MET5fg;
METAL6   = METAL6   or MET6fg;
METAL7   = METAL7   or MET7fg;
METAL8   = METAL8   or MET8fg;
METAL9   = METAL9   or MET9fg;

METALC2  = METALC2  or METC2fg;
METALC3  = METALC3  or METC3fg;
METALC4  = METALC4  or METC4fg;
METALC5  = METALC5  or METC5fg;
METALC6  = METALC6  or METC6fg;
METALC7  = METALC7  or METC7fg;
METALC8  = METALC8  or METC8fg;
METALC9  = METALC9  or METC9fg;

METAL2BC = METAL2BC or (MET2fg or METC2fg);
METAL3BC = METAL3BC or (MET3fg or METC3fg);
METAL4BC = METAL4BC or (MET4fg or METC4fg);
METAL5BC = METAL5BC or (MET5fg or METC5fg);
METAL6BC = METAL6BC or (MET6fg or METC6fg);
METAL7BC = METAL7BC or (MET7fg or METC7fg);
METAL8BC = METAL8BC or (MET8fg or METC8fg);
METAL9BC = METAL9BC or (MET9fg or METC9fg);

drPassthru(METAL0,             55, 0)
drPassthru(MET1_fillguide,      4, 98)
drPassthru(METAL1_nfm_fill,     4, 99)
drPassthru(METAL1,              4, 0)
drPassthru(METAL2,             14, 9000)
drPassthru(METALC2,            14, 9001)
drPassthru(METAL2BC,           14, 9002)

#endif
