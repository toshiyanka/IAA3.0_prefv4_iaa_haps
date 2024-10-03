// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_TV1_resize_reassign.rs.rca 1.1 Sat Nov  8 17:43:12 2014 dgthakur Experimental $
//
// $Log: p1273dx_TV1_resize_reassign.rs.rca $
// 
//  Revision: 1.1 Sat Nov  8 17:43:12 2014 dgthakur
//  HSD 2864; Enable 1273.2 TV1 resizing.
//

#ifndef _P1273DX_TV1_RESIZE_REASSIGN_RS_
#define _P1273DX_TV1_RESIZE_REASSIGN_RS_


//Passthru original TV1 for debug
drPassthru( TV1,    80, 100)
drPassthru( TV1SIZEID,    80, 97)



//Size only inside TV!SIZEID and only those which are 6x30
TV1_size_cand0 = TV1 inside TV1SIZEID;
TV1_size_cand1 =  rectangles(TV1_size_cand0, {TV1_31, TV1_32}); 


//Size the TV1 candidates
sf = (TV1_32 - TV1_432)/2.0;

TV1_size_cand1_pgd = internal1(TV1_size_cand1, TV1_32, NONE, orientation=PARALLEL, direction=gate_dir); 
TV1_size_cand1_ogd = internal1(TV1_size_cand1, TV1_32, NONE, orientation=PARALLEL, direction=non_gate_dir); 


#ifdef GATEDIR_VERT
  TV1_resized_cand1_pgd = shrink(TV1_size_cand1_pgd, north = sf, south = sf);
  TV1_resized_cand1_ogd = shrink(TV1_size_cand1_ogd, east = sf, west = sf);
#else
  TV1_resized_cand1_pgd = shrink(TV1_size_cand1_pgd, east = sf, west = sf);
  TV1_resized_cand1_ogd = shrink(TV1_size_cand1_ogd, north = sf, south = sf);
#endif


TV1_resized = TV1_resized_cand1_pgd  or TV1_resized_cand1_ogd; 


//Change back original layer
TV1 = (TV1 not TV1_size_cand1) or TV1_resized;


//end of ifndef _P1273DX_TV1_RESIZE_REASSIGN_RS_
#endif
