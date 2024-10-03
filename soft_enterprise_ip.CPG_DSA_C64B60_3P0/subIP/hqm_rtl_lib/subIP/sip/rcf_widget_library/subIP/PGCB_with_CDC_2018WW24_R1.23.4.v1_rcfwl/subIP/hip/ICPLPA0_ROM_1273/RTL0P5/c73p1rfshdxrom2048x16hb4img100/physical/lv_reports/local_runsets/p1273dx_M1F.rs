// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_M1F.rs.rca 1.2 Sun Aug  4 17:42:53 2013 dgthakur Experimental $
//
// $Log: p1273dx_M1F.rs.rca $
// 
//  Revision: 1.2 Sun Aug  4 17:42:53 2013 dgthakur
//  Updated M1BCregionID transition checks so that M1_36 max space rule can be satisfied.  Updated M1F_43/44 and added M1F_46 check.
// 
//  Revision: 1.1 Thu Nov 29 23:34:36 2012 dgthakur
//  Moved from PXL to PXL/1273.
// 
//  Revision: 1.2 Fri Apr 27 17:26:00 2012 dgthakur
//  Updated M1F_21 check (made it more strict; C line at notch needs to extend out by M1F_21).
// 
//  Revision: 1.1 Thu Apr 26 18:04:45 2012 dgthakur
//  M1 fuse rules for the X73A project (not SDR as of now).
//

#ifndef _P12723_M1F_RS_
#define _P12723_M1F_RS_

//Only for testing with Dipto's test case 1273_m1fuse_test1.lnf
//MET1BCREGIONID = copy(NWELL);
//M1BID = copy(NDIFF);
//M1CID = copy(PDIFF);


//M1 fuse runset for X73A.  This code is included in the beginning of the
//standard metal1 rules. Started 25Apr12 - Dipto Thakurta

drErrGDSHash[xc(M1F_43/44)] = {234,1043};
drHash[xc(M1F_43/44)] = xc(Min V0/V1 keepaway space from M1 color region);
drValHash[xc(M1F_43/44)] = 0;

drErrGDSHash[xc(M1F_40/41/45)] = {234,1040};
drHash[xc(M1F_40/41/45)] = xc(M1 color region must have metal1b line at beginning and end);
drValHash[xc(M1F_40/41/45)] = 0;

//Can delete this when dr file is updated
drErrGDSHash[xc(M1F_46)] = {234,1046};
drHash[xc(M1F_46)] = xc(Min metal1 keepaway space from M1BCregionID in PGD and OGD);
drValHash[xc(M1F_46)] = 0.238;
M1F_46 = 0.238;


//Layers used
//MET1BCREGIONID  	82.71
//M1BID 	 		4.137
//M1CID   			111.137

//Use local copies for B/C and ID layers for checks below
m1fID = copy(MET1BCREGIONID);
m1f = m1fID and METAL1;           //Ensures M1F_31
m1fB = m1f interacting M1BID;     //Ensures M1F_01 
m1fC = m1f interacting M1CID;     //Ensures M1F_01 


drCopyToError_(xc(M1F_32), m1fB and m1fC); //BID and CID cannot be on same m1
drCopyToError_(xc(M1F_32), (m1f not_interacting M1BID) not_interacting M1CID); //must be B or C

drCopyToError_(xc(M1F_33), M1BID not_inside m1fID); 
drCopyToError_(xc(M1F_34), M1CID not_inside m1fID); 


//M1F_35 global grid (checked in drc_M1)
//M1F_36 all m1 design rules (checked in drc_M1)


//Space between B/C
drMinSpaceDir2_( xc(M1F_42), m1fB, m1fC, [0, M1_21), non_gate_dir);  	    //any B-C space 
drMinSpaceDir_( xc(M1F_42), m1fB, [0, M1_01+2*M1_21-M1F_12), non_gate_dir);	//any B-B space
drMinSpaceDir_( xc(M1F_42), m1fC, [0, M1_01+2*M1_21), non_gate_dir);	    //any C-C space 


//Transition keepaway
m1fID_os = drGrow( m1fID, N=M1F_44, S=M1F_44, E=M1F_43, W=M1F_43);
m1fID_ring = m1fID_os not m1fID;
drCopyToError_(xc(M1F_43/44), (VIA0 or VIA1) and m1fID_ring);  //No vias (only dummy wire for fill) 
drMinSpace_(xc(M1F_43/44), m1fID, M1F_44);
drMinSpaceDir_(xc(M1F_43/44), m1fID, <M1F_43, non_gate_dir);

m1fID_os1 = size( m1fID, M1F_46);
m1fID_ring1 = m1fID_os1 not m1fID;
drCopyToError_(xc(M1F_46), METAL1 and m1fID_ring1);  //No metal1 within 238 nm


//Transition edges must be B (also ensured by B pitch check)
m1fID_us = drShrink( m1fID, E=M1_01, W=M1_01);
m1fB_edge_synth = m1fID not m1fID_us;
drCopyToError_(xc(M1F_40/41/45), m1fB_edge_synth not_interacting m1fB); 
drCopyToError_(xc(M1F_40/41/45), m1fB_edge_synth interacting m1fC); 




/////FORM THE NUB AND NOTCH ////////////////////////////////////////////////////////////////////

//Add/substract fuse cut/nub to metal1 definitions for standard rules checking
m1fC_cut = drSpace(m1fC, M1F_13, gate_dir); //automatically enforces M1F_01, M1F_02, M1F_13
m1fB_nub = drWidth(m1fB, M1F_11, gate_dir); //automatically enforces M1F_01, M1F_03, M1F_11
metal1 = (metal1 or m1fC_cut) not m1fB_nub; //redefines metal1


//Nub/notch centering; checks M1F_04 and M1F_15
m1fB_nub_os = drGrow(m1fB_nub, N=M1_21, S=M1_21);
m1fB_neck = drSpace2(m1fB_nub_os, m1fC_cut, <M1_21, non_gate_dir);
m1fB_join = m1fB_nub_os or m1fC_cut or m1fB_nub_os;
drCopyEdgeToError_(xc(M1F_15), adjacent_edge(m1fB_join,length>0,angle1=270,angle2=90)); 
drCopyToError_(xc(M1F_04), m1fB_nub_os not_interacting m1fB_neck); 
drCopyToError_(xc(M1F_04), m1fC_cut not_interacting m1fB_neck); 


//M1F_22
m1f_neck = internal2(m1fC, m1fC_cut, distance=M1_01, extension=NONE, 
  orientation=PARALLEL, direction=non_gate_dir, look_thru=ALL);
m1f_neck_os1 = drGrow( m1f_neck, E=M1_21, W=M1_21); 
m1f_neck_os2 = drGrow( m1f_neck, E=M1_21+M1_01, W=M1_21+M1_01); 
m1f_neck_B = m1f_neck_os2 not m1f_neck_os1;
m1f_neck_B_os = drGrow( m1f_neck_B, N=M1F_22, S=M1F_22);
drCopyToError_(xc(M1F_22), m1f_neck_B_os not m1fB); 

//Also check for the C line (similar to M1F_22 check, but with M1F_21 value)
m1f_neck_C_os1 = drGrow( m1f_neck, N=M1F_21, S=M1F_21);
m1f_neck_C_os2 = m1f_neck_C_os1 not m1f_neck;
drCopyToError_(xc(M1F_21), m1f_neck_C_os2 not m1fC); 

/*
drPassthru(m1fB_nub_os    ,200, 1950)
drPassthru(m1fB_neck	  ,200, 1951)
drPassthru(m1fB_join	  ,200, 1952)
drPassthru(m1f_neck  		,200, 1953)
drPassthru(m1f_neck_B  	,200, 1954)
drPassthru(m1f_neck_C_os2  	,200, 1955)
*/

//Notch space to v0/v1
m1fC_cut_os = drGrow(m1fC_cut, E=M1_01/2, W=M1_01/2);
drMinSpaceDir2_(xc(M1F_21), m1fC_cut_os, VIA1, <M1F_21, gate_dir);
drMinSpaceDir2_(xc(M1F_21), m1fC_cut_os, VIA0, <M1F_21, gate_dir);


//Notch/Nub min space
drMinSpace_(xc(M1F_23), m1fC_cut, M1F_23);
drMinSpace_(xc(M1F_24), m1fB_nub, M1F_24);


//Min notch width
m1fC_cut_good = drWidth(m1fC_cut, <=M1F_12, non_gate_dir);
drCopyToError_(xc(M1F_14), m1fC_cut not m1fC_cut_good); 


//Max nub width
m1fB_nub_good = drWidth(m1fB_nub, <=M1F_12, non_gate_dir);
drCopyToError_(xc(M1F_12), m1fB_nub not m1fB_nub_good); 


//Check B/C pitch
m1fB_rec = metal1 interacting m1fB; //rectangular m1fB
m1fC_rec = metal1 interacting m1fC; //rectangular m1fC
m1f_pitch = M1_01+M1_21;
drFixedPitch_(xc(M1F_35), m1fB_rec, m1fID, M1_01, 2*m1f_pitch, 0.0, M1_01, non_gate_dir);
drFixedPitch_(xc(M1F_35), m1fC_rec, m1fID, M1_01, 2*m1f_pitch, m1f_pitch, M1_01, non_gate_dir);



//Debug layers
drPassthru(METAL1GRATING  	,4,   70)
drPassthru(METALC1DRAWN   	,111,  0)
drPassthru(MET1BCREGIONID  	,82,  71)

drPassthru(M1CID  			,111, 137)
drPassthru(M1BID  			,4, 135)

drPassthru(metal1  			,4,  1950)
drPassthru(m1fB  			,4, 1951)
drPassthru(m1fC  			,4, 1952)
drPassthru(m1fC_cut  		,4, 1953)
drPassthru(m1fB_nub  		,4, 1954)


#endif
