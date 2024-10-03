// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d6_VD.rs.rca 1.3 Wed Jun 12 17:27:18 2013 jhannouc Experimental $
//
// $Log: p1273d6_VD.rs.rca $
// 
//  Revision: 1.3 Wed Jun 12 17:27:18 2013 jhannouc
//  Waive V9 and V11 found in Etchring.
// 
//  Revision: 1.2 Thu Mar 28 14:25:27 2013 dgthakur
//  Updated code for 1273.6
// 
//  Revision: 1.1 Fri Aug 24 13:42:05 2012 dgthakur
//  VD rules for 1273.6 (similar to 1272).
//


// merge closely spaced vias

// Waive VIA9 and VIA11 found in the etchring cells
vd_via9_to_filter = copy_by_cells(VIA9, cells = etchring_cells, depth = CELL_LEVEL);
vd_via9_cand = VIA9 not vd_via9_to_filter;

vd_via11_to_filter = copy_by_cells(VIA11, cells = etchring_cells, depth = CELL_LEVEL);
vd_via11_cand = VIA11 not vd_via11_to_filter;

//via9_merge = drOverUnder(VIA9, (VD_09-drunit)/2);
via9_merge = drOverUnder(vd_via9_cand, (VD_09-drunit)/2);
via10_merge = drOverUnder(VIA10, (VD_10-drunit)/2);
//via11_merge = drOverUnder(VIA11, (VD_11-drunit)/2);
via11_merge = drOverUnder(vd_via11_cand, (VD_11-drunit)/2);

// eliminate merged areas < given width 
via9_elim = drUnderOver(via9_merge, VD_19/2);
via10_elim = drUnderOver(via10_merge, VD_20/2);
via11_elim = drUnderOver(via11_merge, VD_21/2);

// check remain merged areas for compliance
drAreaError_(xc(VD_29), via9_elim, > VD_29);
drAreaError_(xc(VD_30), via10_elim, > VD_30);
drAreaError_(xc(VD_31), via11_elim, > VD_31);


// get only the merged via strips
via9_strips = not_rectangles(not_rectangles(not_rectangles(not_rectangles(via9_merge, {V9_01,V9_01}), {V9_101,V9_101}), {V9_31,V9_32}), {V9_131,V9_132});
via10_strips = not_rectangles(not_rectangles(via10_merge, {V10_01,V10_01}), {V10_31,V10_32});
via11_strips = not_rectangles(not_rectangles(via11_merge, {V11_01,V11_01}), {V11_31,V11_32});


// merge strips
via9_med_merge = drOverUnder(via9_strips, ((3*VD_09)-drunit)/2);
via10_med_merge = drOverUnder(via10_strips, ((3*VD_10)-drunit)/2);
via11_med_merge = drOverUnder(via11_strips, ((3*VD_11)-drunit)/2);

// check merged strips for compliance 
// assume it must fail in x/y for max_width simultaneously
drCopyToError_(xc(VD_59), drUnderOver(via9_med_merge, (VD_59-drunit)/2));
drCopyToError_(xc(VD_60), drUnderOver(via10_med_merge, (VD_60-drunit)/2));
drCopyToError_(xc(VD_61), drUnderOver(via11_med_merge, (VD_61-drunit)/2));
