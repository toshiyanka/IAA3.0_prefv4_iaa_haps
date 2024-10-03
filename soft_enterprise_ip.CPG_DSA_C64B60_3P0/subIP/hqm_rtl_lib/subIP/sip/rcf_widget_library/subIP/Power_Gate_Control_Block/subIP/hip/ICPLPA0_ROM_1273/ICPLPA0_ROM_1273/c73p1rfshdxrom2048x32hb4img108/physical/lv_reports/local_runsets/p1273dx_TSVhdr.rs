// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TSVhdr.rs.rca 1.1 Thu Nov  8 17:11:24 2012 sstalukd Experimental $
// $Log: p1273dx_TSVhdr.rs.rca $
// 
//  Revision: 1.1 Thu Nov  8 17:11:24 2012 sstalukd
//  Initial checkin for TSV/RDL/LMI checks
//  Remaining checks - TSV_08/LMI_13/14
// 

#ifndef _P1273_TSVHDR_RS_
#define _P1273_TSVHDR_RS_

//This is common file that can be used by other modules if necessary

//Need to keep this general definition here since it's used in multiple files,
//but the actual catch-cup checks are now in p1271_TSV.rs file
tsv_cc_bound = copy_by_cells(layer1=CELLBOUNDARY, cells=tsv_cc_cells);
tsv_gr_bound = copy_by_cells(layer1=CELLBOUNDARY, cells=catch_cup_guard_cells);


#endif //#ifndef _P1273_TSVHDR_RS_