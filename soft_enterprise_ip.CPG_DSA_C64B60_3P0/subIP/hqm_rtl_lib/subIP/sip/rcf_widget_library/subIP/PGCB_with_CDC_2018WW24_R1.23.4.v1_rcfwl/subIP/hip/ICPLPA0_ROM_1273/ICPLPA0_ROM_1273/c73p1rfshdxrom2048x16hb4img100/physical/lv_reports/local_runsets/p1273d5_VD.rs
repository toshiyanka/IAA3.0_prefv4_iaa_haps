// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d5_VD.rs.rca 1.1 Fri Dec 14 02:21:12 2012 dgthakur Experimental $
//
// $Log: p1273d5_VD.rs.rca $
// 
//  Revision: 1.1 Fri Dec 14 02:21:12 2012 dgthakur
//  VD code for 1273.5.
//


// merge closely spaced vias
via7_merge = drOverUnder(VIA7, (VD_07-drunit)/2);  
via8_merge = drOverUnder(VIA8, (VD_08-drunit)/2);  
via9_merge = drOverUnder(VIA9, (VD_09-drunit)/2);

// eliminate merged areas < given width 
via7_elim = drUnderOver(via7_merge, VD_17/2);
via8_elim = drUnderOver(via8_merge, VD_18/2);
via9_elim = drUnderOver(via9_merge, VD_19/2);

// check remain merged areas for compliance
drAreaError_(xc(VD_27), via7_elim, > VD_27);
drAreaError_(xc(VD_28), via8_elim, > VD_28);
drAreaError_(xc(VD_29), via9_elim, > VD_29);


// get only the merged via strips
via7_strips = not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(via7_merge,  
{V7_01,V7_02}),
{V7_03,V7_04}),
{V7_05,V7_06}),
{V7_11,V7_12}),
{V7_13,V7_14}),
{V7_16,V7_17});
via8_strips = not_rectangles(not_rectangles(via8_merge, {V8_01,V8_01}), {V8_31,V8_32});
via9_strips = not_rectangles(not_rectangles(via9_merge, {V9_01,V9_01}), {V9_31,V9_32});


// merge strips
via7_med_merge = drOverUnder(via7_strips, ((3*VD_07)-drunit)/2);
via8_med_merge = drOverUnder(via8_strips, ((3*VD_08)-drunit)/2);
via9_med_merge = drOverUnder(via9_strips, ((3*VD_09)-drunit)/2);

// check merged strips for compliance 
// assume it must fail in x/y for max_width simultaneously
drCopyToError_(xc(VD_57), drUnderOver(via7_med_merge, (VD_57-drunit)/2));
drCopyToError_(xc(VD_58), drUnderOver(via8_med_merge, (VD_58-drunit)/2));
drCopyToError_(xc(VD_59), drUnderOver(via9_med_merge, (VD_59-drunit)/2));
