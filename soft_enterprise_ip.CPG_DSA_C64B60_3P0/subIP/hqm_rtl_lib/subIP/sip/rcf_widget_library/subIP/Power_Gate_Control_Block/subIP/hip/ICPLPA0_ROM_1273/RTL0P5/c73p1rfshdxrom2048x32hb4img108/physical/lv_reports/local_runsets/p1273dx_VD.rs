// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_VD.rs.rca 1.4 Wed Oct 23 16:47:50 2013 dgthakur Experimental $
//
// $Log: p1273dx_VD.rs.rca $
// 
//  Revision: 1.4 Wed Oct 23 16:47:50 2013 dgthakur
//  Adding the correct v8 sizes for dot1.  Email from Vincent 23Oct13 false flag for VD_58.
// 
//  Revision: 1.3 Tue Oct  8 22:09:23 2013 kperrey
//  hsd 1905; need specific via7 sets for dot1 / dot4
// 
//  Revision: 1.2 Thu Apr  5 10:10:08 2012 tmurata
//  excluded the etchring VIA8 from the check per design.
// 
//  Revision: 1.1 Fri Aug 12 14:23:00 2011 dgthakur
//  Coded VD module for 1273 - copy same algo from 1272.
//


// merge closely spaced vias
via7_merge = drOverUnder(VIA7, (VD_07-drunit)/2);
via8_merge = drOverUnder(via8, (VD_08-drunit)/2);  //note the "lowercase" via8 to remove the ethcirng VIA8 from the check.

// eliminate merged areas < given width 
via7_elim = drUnderOver(via7_merge, VD_17/2);
via8_elim = drUnderOver(via8_merge, VD_19/2);

// check remain merged areas for compliance
drAreaError_(xc(VD_27), via7_elim, > VD_27);
drAreaError_(xc(VD_28), via8_elim, > VD_28);

// get only the merged via strips
// an alternate method that does not need to know the valid sizes 
//        viax_merge interacting [count = >= 2] VIAX
#if _drPROCESS ==  4
   via7_strips = not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(via7_merge,  
   {V7_01,V7_02}),
   {V7_03,V7_04}),
   {V7_05,V7_06}),
   {V7_11,V7_12}),
   {V7_13,V7_14}),
   {V7_16,V7_17});
#else
   via7_strips = not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(not_rectangles(via7_merge,  
   {V7_01,V7_02}), 
   {V7_01,V7_03}),
   {V7_01,V7_04}),
   {V7_01,V7_05}),
   {V7_01,V7_06}),
   {V7_01,V7_07}),
   {V7_01,V7_08}),
   {V7_01,V7_09}),
   {V7_01,V7_10}),
   {V7_101,V7_102}),
   {V7_103,V7_104}),
   {V7_105,V7_106}),
   {V7_107,V7_108}),
   {V7_109,V7_110}),
   {V7_111,V7_112}),
   {V7_121,V7_122}),
   {V7_131,V7_132});
#endif

#if _drPROCESS ==  4
via8_strips = not_rectangles(not_rectangles(via8_merge, {V8_01,V8_01}), {V8_31,V8_32});
#else
via8_strips = not_rectangles(not_rectangles(via8_merge, {V8_00,V8_01}), {V8_31,V8_32});
#endif


// merge strips
via7_med_merge = drOverUnder(via7_strips, ((3*VD_07)-drunit)/2);
via8_med_merge = drOverUnder(via8_strips, ((3*VD_08)-drunit)/2);

// check merged strips for compliance 
// assume it must fail in x/y for max_width simultaneously
drCopyToError_(xc(VD_57), drUnderOver(via7_med_merge, (VD_57-drunit)/2));
drCopyToError_(xc(VD_58), drUnderOver(via8_med_merge, (VD_58-drunit)/2));

