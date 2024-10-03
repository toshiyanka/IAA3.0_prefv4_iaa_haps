// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_LibIntegChk.rs.rca 1.2 Tue Apr 22 15:47:25 2014 kperrey Experimental $
//
// $Log: p1273dx_LibIntegChk.rs.rca $
// 
//  Revision: 1.2 Tue Apr 22 15:47:25 2014 kperrey
//  update drc_LibInteg genLibInteg
// 
//  Revision: 1.1 Wed Feb  8 19:44:30 2012 kperrey
//  create initial library integrity check flow ; using new Synopsys capability stuff
// 
// 


#ifndef _P1273DX_LIBINTEGCHK_RS_
#define _P1273DX_LIBINTEGCHK_RS_

layout_integrity_options(
   databases = {
      { db_name = search_include_path("integrity73.lidb") }
   }
);

Error_Template_Integrity @= {
   @ "Layout Integrity Check By Cell";
   layout_integrity_by_cell(
      cells = {"*"}
   );
   // this is primarily for Pcells (if marker_layer exists in cell then check library for match; not dependant on name)   
   @ "Layout Integrity Check By Marker";
   layout_integrity_by_marker_layer(
      marker_layer = { 50,50 }
   );
}

#endif //__P1273DX_LIBINTEGCHK_RS_
