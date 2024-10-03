//$Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tchks_mvsw.rs.rca 1.3 Wed Oct  8 14:54:10 2014 kperrey Experimental $

//$Log: p1273dx_Tchks_mvsw.rs.rca $
//
// Revision: 1.3 Wed Oct  8 14:54:10 2014 kperrey
// inactivate the PCELL / libid checks
//
// Revision: 1.2 Sat Sep 27 23:32:26 2014 kperrey
// fix syntax
//
// Revision: 1.1 Thu Sep 25 22:13:43 2014 kperrey
// the construction checks that used to be in p1273dx_Tcommon_mvsw.rs
//

#ifndef _P1273DX_TCHKS_MVSW_RS_
#define _P1273DX_TCHKS_MVSW_RS_


switchID_altSwitchID_pcells: list of string = {
  "myTestSwitchAltSwitchPcells"
};

// construction checks
Error_Bad_Switch_Alias @=  {
	// switchid must not interact with the altswitchid
	@ "MET0SWITCHID must not interact with MET0ALTSWITCHID";
    MET0SWITCHID interacting MET0ALTSWITCHID; 

	@ "MET1SWITCHID must not interact with MET1ALTSWITCHID";
    MET1SWITCHID interacting MET1ALTSWITCHID; 

	@ "MET2SWITCHID must not interact with MET2ALTSWITCHID";
    MET2SWITCHID interacting MET2ALTSWITCHID; 

	@ "MET3SWITCHID must not interact with MET3ALTSWITCHID";
    MET3SWITCHID interacting MET3ALTSWITCHID; 

	@ "MET4SWITCHID must not interact with MET4ALTSWITCHID";
    MET4SWITCHID interacting MET4ALTSWITCHID; 

	@ "MET5SWITCHID must not interact with MET5ALTSWITCHID";
    MET5SWITCHID interacting MET5ALTSWITCHID; 

	@ "MET6SWITCHID must not interact with MET6ALTSWITCHID";
    MET6SWITCHID interacting MET6ALTSWITCHID; 

	@ "MET7SWITCHID must not interact with MET7ALTSWITCHID";
    MET7SWITCHID interacting MET7ALTSWITCHID; 

	@ "MET8SWITCHID must not interact with MET8ALTSWITCHID";
    MET8SWITCHID interacting MET8ALTSWITCHID; 

	@ "MET9SWITCHID must not interact with MET9ALTSWITCHID";
    MET9SWITCHID interacting MET9ALTSWITCHID; 

	@ "MET10SWITCHID must not interact with MET10ALTSWITCHID";
    MET10SWITCHID interacting MET10ALTSWITCHID; 

	@ "MET11SWITCHID must not interact with MET11ALTSWITCHID";
    MET11SWITCHID interacting MET11ALTSWITCHID; 

	@ "MET12SWITCHID must not interact with MET12ALTSWITCHID";
    MET12SWITCHID interacting MET12ALTSWITCHID; 

	@ "TM1SWITCHID must not interact with TM1ALTSWITCHID";
    TM1SWITCHID interacting TM1ALTSWITCHID; 

    // the metal switchid/altswitchid must not interact with the corresponding via switchid/altswitchid
    @ "MET0SWITCHID/MET0ALTSWITCHID must not interact with a VIA0SWITCHID/VIA0ALTSWITCHID";
    (MET0SWITCHID or MET0ALTSWITCHID) interacting (VIA0SWITCHID or VIA0ALTSWITCHID); 
    @ "MET1SWITCHID/MET1ALTSWITCHID must not interact with a VIA0SWITCHID/VIA0ALTSWITCHID";
    (MET1SWITCHID or MET1ALTSWITCHID) interacting (VIA0SWITCHID or VIA0ALTSWITCHID); 

    @ "MET1SWITCHID/MET1ALTSWITCHID must not interact with a VIA1SWITCHID/VIA1ALTSWITCHID";
    (MET1SWITCHID or MET1ALTSWITCHID) interacting (VIA1SWITCHID or VIA1ALTSWITCHID); 
    @ "MET2SWITCHID/MET2ALTSWITCHID must not interact with a VIA1SWITCHID/VIA1ALTSWITCHID";
    (MET2SWITCHID or MET2ALTSWITCHID) interacting (VIA1SWITCHID or VIA1ALTSWITCHID); 

    @ "MET2SWITCHID/MET2ALTSWITCHID must not interact with a VIA2SWITCHID/VIA2ALTSWITCHID";
    (MET2SWITCHID or MET2ALTSWITCHID) interacting (VIA2SWITCHID or VIA2ALTSWITCHID); 
    @ "MET3SWITCHID/MET3ALTSWITCHID must not interact with a VIA2SWITCHID/VIA2ALTSWITCHID";
    (MET3SWITCHID or MET3ALTSWITCHID) interacting (VIA2SWITCHID or VIA2ALTSWITCHID); 

    @ "MET3SWITCHID/MET3ALTSWITCHID must not interact with a VIA3SWITCHID/VIA3ALTSWITCHID";
    (MET3SWITCHID or MET3ALTSWITCHID) interacting (VIA3SWITCHID or VIA3ALTSWITCHID); 
    @ "MET4SWITCHID/MET4ALTSWITCHID must not interact with a VIA3SWITCHID/VIA3ALTSWITCHID";
    (MET4SWITCHID or MET4ALTSWITCHID) interacting (VIA3SWITCHID or VIA3ALTSWITCHID); 

    @ "MET4SWITCHID/MET4ALTSWITCHID must not interact with a VIA4SWITCHID/VIA4ALTSWITCHID";
    (MET4SWITCHID or MET4ALTSWITCHID) interacting (VIA4SWITCHID or VIA4ALTSWITCHID); 
    @ "MET5SWITCHID/MET5ALTSWITCHID must not interact with a VIA4SWITCHID/VIA4ALTSWITCHID";
    (MET5SWITCHID or MET5ALTSWITCHID) interacting (VIA4SWITCHID or VIA4ALTSWITCHID); 

    @ "MET5SWITCHID/MET5ALTSWITCHID must not interact with a VIA5SWITCHID/VIA5ALTSWITCHID";
    (MET5SWITCHID or MET5ALTSWITCHID) interacting (VIA5SWITCHID or VIA5ALTSWITCHID); 
    @ "MET6SWITCHID/MET6ALTSWITCHID must not interact with a VIA5SWITCHID/VIA5ALTSWITCHID";
    (MET6SWITCHID or MET6ALTSWITCHID) interacting (VIA5SWITCHID or VIA5ALTSWITCHID); 

    @ "MET6SWITCHID/MET6ALTSWITCHID must not interact with a VIA6SWITCHID/VIA6ALTSWITCHID";
    (MET6SWITCHID or MET6ALTSWITCHID) interacting (VIA6SWITCHID or VIA6ALTSWITCHID); 
    @ "MET7SWITCHID/MET7ALTSWITCHID must not interact with a VIA6SWITCHID/VIA6ALTSWITCHID";
    (MET7SWITCHID or MET7ALTSWITCHID) interacting (VIA6SWITCHID or VIA6ALTSWITCHID); 

    @ "MET7SWITCHID/MET7ALTSWITCHID must not interact with a VIA7SWITCHID/VIA7ALTSWITCHID";
    (MET7SWITCHID or MET7ALTSWITCHID) interacting (VIA7SWITCHID or VIA7ALTSWITCHID); 
    @ "MET8SWITCHID/MET8ALTSWITCHID must not interact with a VIA7SWITCHID/VIA7ALTSWITCHID";
    (MET8SWITCHID or MET8ALTSWITCHID) interacting (VIA7SWITCHID or VIA7ALTSWITCHID); 

    @ "MET8SWITCHID/MET8ALTSWITCHID must not interact with a VIA8SWITCHID/VIA8ALTSWITCHID";
    (MET8SWITCHID or MET8ALTSWITCHID) interacting (VIA8SWITCHID or VIA8ALTSWITCHID); 
    @ "MET9SWITCHID/MET9ALTSWITCHID must not interact with a VIA8SWITCHID/VIA8ALTSWITCHID";
    (MET9SWITCHID or MET9ALTSWITCHID) interacting (VIA8SWITCHID or VIA8ALTSWITCHID); 

    @ "MET9SWITCHID/MET9ALTSWITCHID must not interact with a VIA9SWITCHID/VIA9ALTSWITCHID";
    (MET9SWITCHID or MET9ALTSWITCHID) interacting (VIA9SWITCHID or VIA9ALTSWITCHID); 
    @ "MET10SWITCHID/MET10ALTSWITCHID must not interact with a VIA9SWITCHID/VIA9ALTSWITCHID";
    (MET10SWITCHID or MET10ALTSWITCHID) interacting (VIA9SWITCHID or VIA9ALTSWITCHID); 

    @ "MET10SWITCHID/MET10ALTSWITCHID must not interact with a VIA10SWITCHID/VIA10ALTSWITCHID";
    (MET10SWITCHID or MET10ALTSWITCHID) interacting (VIA10SWITCHID or VIA10ALTSWITCHID); 
    @ "MET11SWITCHID/MET11ALTSWITCHID must not interact with a VIA10SWITCHID/VIA10ALTSWITCHID";
    (MET11SWITCHID or MET11ALTSWITCHID) interacting (VIA10SWITCHID or VIA10ALTSWITCHID); 

    @ "MET11SWITCHID/MET11ALTSWITCHID must not interact with a VIA11SWITCHID/VIA11ALTSWITCHID";
    (MET11SWITCHID or MET11ALTSWITCHID) interacting (VIA11SWITCHID or VIA11ALTSWITCHID); 
    @ "MET12SWITCHID/MET12ALTSWITCHID must not interact with a VIA11SWITCHID/VIA11ALTSWITCHID";
    (MET12SWITCHID or MET12ALTSWITCHID) interacting (VIA11SWITCHID or VIA11ALTSWITCHID); 

    @ "MET12SWITCHID/MET12ALTSWITCHID must not interact with a VIA12SWITCHID/VIA12ALTSWITCHID";
    (MET12SWITCHID or MET12ALTSWITCHID) interacting (VIA12SWITCHID or VIA12ALTSWITCHID); 
    @ "TM1SWITCHID/TM1ALTSWITCHID must not interact with a VIA12SWITCHID/VIA12ALTSWITCHID";
    (TM1SWITCHID or TM1ALTSWITCHID) interacting (VIA12SWITCHID or VIA12ALTSWITCHID); 

	// aliasid must interact with (altswitchid and metal)
	@ "MET0ALIASID must interact with MET0ALTSWITCHID and METAL0";
    MET0ALIASID not_interacting (MET0ALTSWITCHID and METAL0);

	@ "MET1ALIASID must interact with MET1ALTSWITCHID and METAL1";
    MET1ALIASID not_interacting (MET1ALTSWITCHID and METAL1);

	@ "MET2ALIASID must interact with MET2ALTSWITCHID and METAL2";
    MET2ALIASID not_interacting (MET2ALTSWITCHID and METAL2);

	@ "MET3ALIASID must interact with MET3ALTSWITCHID and METAL3";
    MET3ALIASID not_interacting (MET3ALTSWITCHID and METAL3);

	@ "MET4ALIASID must interact with MET4ALTSWITCHID and METAL4";
    MET4ALIASID not_interacting (MET4ALTSWITCHID and METAL4);

	@ "MET5ALIASID must interact with MET5ALTSWITCHID and METAL5";
    MET5ALIASID not_interacting (MET5ALTSWITCHID and METAL5);

	@ "MET6ALIASID must interact with MET6ALTSWITCHID and METAL6";
    MET6ALIASID not_interacting (MET6ALTSWITCHID and METAL6);

	@ "MET7ALIASID must interact with MET7ALTSWITCHID and METAL7";
    MET7ALIASID not_interacting (MET7ALTSWITCHID and METAL7);

	@ "MET8ALIASID must interact with MET8ALTSWITCHID and METAL8";
    MET8ALIASID not_interacting (MET8ALTSWITCHID and METAL8);

	@ "MET9ALIASID must interact with MET9ALTSWITCHID and METAL9";
    MET9ALIASID not_interacting (MET9ALTSWITCHID and METAL9);

	@ "MET10ALIASID must interact with MET10ALTSWITCHID and METAL10";
    MET10ALIASID not_interacting (MET10ALTSWITCHID and METAL10);

	@ "MET11ALIASID must interact with MET11ALTSWITCHID and METAL11";
    MET11ALIASID not_interacting (MET11ALTSWITCHID and METAL11);

	@ "MET12ALIASID must interact with MET12ALTSWITCHID and METAL12";
    MET12ALIASID not_interacting (MET12ALTSWITCHID and METAL12);

	@ "TM1ALIASID must interact with TM1ALTSWITCHID and TM1";
    TM1ALIASID not_interacting (TM1ALTSWITCHID and TM1);


#if 0    // SKIP ALL THIS FOR NOW
  // switchID and altSwitchID can only occur in the PCELLS 
  //   and these PCELLS must have the TEMPLATEID1 50;50 nonchkboundary;id1
  //   would prefer TEMPLATEID1 == CELLBOUNDARY ; but this is not required
  //   TEMPLATEID1 triggers lib integrity checks
  switchLibID = copy_by_cells(TEMPLATEID1, switchID_altSwitchID_pcells, depth=CELL_LEVEL);
  switchCellBound = copy_by_cells(CELLBOUNDARY, switchID_altSwitchID_pcells, depth=CELL_LEVEL);
  switchCellBoundLibID = switchCellBound interacting [processing_mode = CELL_LEVEL] switchLibID; 

  @ "MET0SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET0SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET1SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET1SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET2SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET2SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET3SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET3SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET4SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET4SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET5SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET5SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET6SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET6SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET7SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET7SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET8SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET8SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET9SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET9SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET10SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET10SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET11SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET11SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET12SWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET12SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "TM1SWITCHID only allowed in known pcell that is subject to library integrity checks";
  TM1SWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;

  @ "MET0ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET0ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET1ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET1ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET2ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET2ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET3ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET3ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET4ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET4ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET5ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET5ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET6ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET6ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET7ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET7ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET8ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET8ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET9ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET9ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET10ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET10ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET11ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET11ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "MET12ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  MET12ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
  @ "TM1ALTSWITCHID only allowed in known pcell that is subject to library integrity checks";
  TM1ALTSWITCHID not [processing_mode = CELL_LEVEL] switchCellBoundLibID;
#endif

}

#endif  // end _P1273DX_TCHKS_MVSW_RS_
