// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_dr_default.rs.rca 1.14 Sun Jan 25 21:44:48 2015 kperrey Experimental $
//
//  $Log: p1273dx_dr_default.rs.rca $
//  
//   Revision: 1.14 Sun Jan 25 21:44:48 2015 kperrey
//   create and add LVCmax for LDI_02 check BLDI_192max
//  
//   Revision: 1.13 Wed Jan 21 13:24:38 2015 kperrey
//   hsd 3020; add locally defined check values LD_131prjrom LD_131min LDI_02prjrf LDI_02max LD_234prjrom LD_234prjrf LD_334prjtg
//  
//   Revision: 1.12 Mon Oct 20 09:24:42 2014 kperrey
//   update CD_200tsvcc / LD_200tsvcc as per kalayn and email from Doug
//  
//   Revision: 1.11 Thu Aug  7 09:15:50 2014 dgthakur
//   Added 1273.3 hook.
//  
//   Revision: 1.10 Sun Jul 13 14:08:45 2014 kperrey
//   moved CD_200tsvcc LD_200tsvcc  outside of the if/else so always defined
//  
//   Revision: 1.9 Mon Jul  7 09:15:09 2014 kperrey
//   change LD_200tsvcc from 72.96 to 74 as per kalyan
//  
//   Revision: 1.8 Thu Jun 26 17:53:40 2014 kperrey
//   as per mail Kalyan forward from Nauman grant CD_200/LD_200 exception for tsvcc ; cells defined by tsv_cc_cells_subset from dr_cell_lists ; expect Nauman/Dipto to ensure proper document/hsd/waiver is supplied
//  
//   Revision: 1.7 Mon Mar 24 17:02:36 2014 kperrey
//   add _drPROCESS == 7 to force the M12 checks to 0/100
//  
//   Revision: 1.6 Wed Feb 12 17:05:34 2014 dgthakur
//   Added dot8 and dot0 hooks (only file that need the hooks for now).
//  
//   Revision: 1.5 Sun Feb  9 13:33:32 2014 kperrey
//   hsd 2105; add new value LD_131hpc for HPC cell for memory compiler
//  
//   Revision: 1.4 Tue Jan  7 08:25:14 2014 kperrey
//   hsd 1980 ; upon clarification the BLDI_102 = 10.8 for x73rficfb is not not project specific exception
//  
//   Revision: 1.3 Thu Dec  5 09:06:37 2013 kperrey
//   hsd 1980 ; if project == anafi change CLDI_102 value from 10.4 -> 10.8 ; which applies to the x73rficfb cell
//  
//   Revision: 1.2 Fri May 24 02:24:19 2013 dgthakur
//   added 1273.1 branching
//  
//   Revision: 1.1 Fri Mar 29 14:56:44 2013 kperrey
//   just include used rule info, but not valid for this process or dotprocess
//

// File is a place holder for dr definitions not valid for a given dot process

#if _drPROCESS == 4 || _drPROCESS == 1 || _drPROCESS == 0 || _drPROCESS == 8 || _drPROCESS == 7 || _drPROCESS == 3
   M12_02:double = 0.001; // M12 space 
   M12_21:double = 100; // Maximum allowed M12 width 

   GD_112:double = 100; // Minimum Global Metal 12 Layer density (%)
   GD_212:double = 0; // Maximum Global Metal 12 Layer density (%)

   LD_112:double = 100; // Min required local Metal 12 density (%), within a 25um x 25um window size
   LDW_112:double = 25; // Window for LD_112
   LDW_112_X = LDW_112; // Window for LD_112 for x
   LDW_112_Y = LDW_112; // Window for LD_112 for y
   LDW_112_X_STEP = LDW_112; // Window for LD_112 for x-step
   LDW_112_Y_STEP = LDW_112; // Window for LD_112 for y-step

   LD_212:double = 0; // Max allowed local Metal 12 density (%), within a 9um x 9um window size
   LDW_212:double = 9; // Window for LD_212
   LDW_212_X = LDW_212; // Window for LD_212 for x
   LDW_212_Y = LDW_212; // Window for LD_212 for y
   LDW_212_X_STEP = LDW_212; // Window for LD_212 for x-step
   LDW_212_Y_STEP = LDW_212; // Window for LD_212 for y-step

   LD_512:double = 100; // Min required local Via12 density (%), within a 53um x 53um window size
   LDW_512:double = 53; // Window for LD_512
   LDW_512_X = LDW_512; // Window for LD_512 for x
   LDW_512_Y = LDW_512; // Window for LD_512 for y
   LDW_512_X_STEP = LDW_512; // Window for LD_512 for x-step
   LDW_512_Y_STEP = LDW_512; // Window for LD_512 for y-step

   LD_612:double = 0; // Max required local Via12 density (%), within a 53um x 53um window size
   LDW_612:double = 53; // Window for LD_612
   LDW_612_X = LDW_612; // Window for LD_612 for x
   LDW_612_Y = LDW_612; // Window for LD_612 for y
   LDW_612_X_STEP = LDW_612; // Window for LD_612 for x-step
   LDW_612_Y_STEP = LDW_612; // Window for LD_612 for y-step

   CM_09:double = 100; // Minimum cumulative density (M9+M10+M11+M12) (%), within a 7um x 7um window size
   CMW_09:double = 7; // Window for CM_09
   CMW_09_X = CMW_09; // Window for CM_09 for x
   CMW_09_Y = CMW_09; // Window for CM_09 for y
   CMW_09_X_STEP = CMW_09; // Window for CM_09 for x-step
   CMW_09_Y_STEP = CMW_09; // Window for CM_09 for y-step


   drValHash[xc(LD_112)] = LD_112;
   drHash[xc(LD_112)] = "Non-existant M12 check";
   Error_LD_112 = empty_violation();
   drErrHash[xc(LD_112)] = Error_LD_112;
   drErrGDSHash[xc(LD_112)] = { 250 , 1112 };

   drValHash[xc(LD_212)] = LD_212;
   drHash[xc(LD_212)] = "Non-existant M12 check";
   Error_LD_212 = empty_violation();
   drErrHash[xc(LD_212)] = Error_LD_212;
   drErrGDSHash[xc(LD_212)] = { 250 , 1212 };

   drValHash[xc(LD_512)] = LD_512;
   drHash[xc(LD_512)] = "Non-existant M12 check";
   Error_LD_512 = empty_violation();
   drErrHash[xc(LD_512)] = Error_LD_512;
   drErrGDSHash[xc(LD_512)] = { 250 , 1512 };

   drValHash[xc(LD_612)] = LD_612;
   drHash[xc(LD_612)] = "Non-existant M12 check";
   Error_LD_612 = empty_violation();
   drErrHash[xc(LD_612)] = Error_LD_612;
   drErrGDSHash[xc(LD_612)] = { 250 , 1612 };

   drValHash[xc(GD_112)] = GD_112;
   drHash[xc(GD_112)] = "Non-existant M12 check";
   Error_GD_112 = empty_violation();
   drErrHash[xc(GD_112)] = Error_GD_112;
   drErrGDSHash[xc(GD_112)] = { 150 , 1112 };

   drValHash[xc(GD_212)] = GD_212;
   drHash[xc(GD_212)] = "Non-existant M12 check";
   Error_GD_212 = empty_violation();
   drErrHash[xc(GD_212)] = Error_GD_212;
   drErrGDSHash[xc(GD_212)] = { 150 , 1212 };

   drValHash[xc(CM_09)] = CM_09;
   drHash[xc(CM_09)] = "Non-existant M12 check";
   Error_CM_09 = empty_violation();
   drErrHash[xc(CM_09)] = Error_CM_09;
   drErrGDSHash[xc(CM_09)] = { 51 , 1009 };

#elif _drPROCESS == 5
   M12_02:double = 0.001; // M12 space 
   M12_21:double = 100; // Maximum allowed M12 width 

   GD_112:double = 100; // Minimum Global Metal 12 Layer density (%)
   GD_212:double = 0; // Maximum Global Metal 12 Layer density (%)

   LD_112:double = 100; // Min required local Metal 12 density (%), within a 25um x 25um window size
   LDW_112:double = 25; // Window for LD_112
   LDW_112_X = LDW_112; // Window for LD_112 for x
   LDW_112_Y = LDW_112; // Window for LD_112 for y
   LDW_112_X_STEP = LDW_112; // Window for LD_112 for x-step
   LDW_112_Y_STEP = LDW_112; // Window for LD_112 for y-step

   LD_212:double = 0; // Max allowed local Metal 12 density (%), within a 9um x 9um window size
   LDW_212:double = 9; // Window for LD_212
   LDW_212_X = LDW_212; // Window for LD_212 for x
   LDW_212_Y = LDW_212; // Window for LD_212 for y
   LDW_212_X_STEP = LDW_212; // Window for LD_212 for x-step
   LDW_212_Y_STEP = LDW_212; // Window for LD_212 for y-step

   LD_512:double = 100; // Min required local Via12 density (%), within a 53um x 53um window size
   LDW_512:double = 53; // Window for LD_512
   LDW_512_X = LDW_512; // Window for LD_512 for x
   LDW_512_Y = LDW_512; // Window for LD_512 for y
   LDW_512_X_STEP = LDW_512; // Window for LD_512 for x-step
   LDW_512_Y_STEP = LDW_512; // Window for LD_512 for y-step

   LD_612:double = 0; // Max required local Via12 density (%), within a 53um x 53um window size
   LDW_612:double = 53; // Window for LD_612
   LDW_612_X = LDW_612; // Window for LD_612 for x
   LDW_612_Y = LDW_612; // Window for LD_612 for y
   LDW_612_X_STEP = LDW_612; // Window for LD_612 for x-step
   LDW_612_Y_STEP = LDW_612; // Window for LD_612 for y-step

   CM_09:double = 100; // Minimum cumulative density (M9+M10+M11+M12) (%), within a 7um x 7um window size
   CMW_09:double = 7; // Window for CM_09
   CMW_09_X = CMW_09; // Window for CM_09 for x
   CMW_09_Y = CMW_09; // Window for CM_09 for y
   CMW_09_X_STEP = CMW_09; // Window for CM_09 for x-step
   CMW_09_Y_STEP = CMW_09; // Window for CM_09 for y-step

   drValHash[xc(LD_112)] = LD_112;
   drHash[xc(LD_112)] = "Non-existant M12 check";
   Error_LD_112 = empty_violation();
   drErrHash[xc(LD_112)] = Error_LD_112;
   drErrGDSHash[xc(LD_112)] = { 250 , 1112 };

   drValHash[xc(LD_212)] = LD_212;
   drHash[xc(LD_212)] = "Non-existant M12 check";
   Error_LD_212 = empty_violation();
   drErrHash[xc(LD_212)] = Error_LD_212;
   drErrGDSHash[xc(LD_212)] = { 250 , 1212 };

   drValHash[xc(LD_512)] = LD_512;
   drHash[xc(LD_512)] = "Non-existant M12 check";
   Error_LD_512 = empty_violation();
   drErrHash[xc(LD_512)] = Error_LD_512;
   drErrGDSHash[xc(LD_512)] = { 250 , 1512 };

   drValHash[xc(LD_612)] = LD_612;
   drHash[xc(LD_612)] = "Non-existant M12 check";
   Error_LD_612 = empty_violation();
   drErrHash[xc(LD_612)] = Error_LD_612;
   drErrGDSHash[xc(LD_612)] = { 250 , 1612 };

   drValHash[xc(GD_112)] = GD_112;
   drHash[xc(GD_112)] = "Non-existant M12 check";
   Error_GD_112 = empty_violation();
   drErrHash[xc(GD_112)] = Error_GD_112;
   drErrGDSHash[xc(GD_112)] = { 150 , 1112 };

   drValHash[xc(GD_212)] = GD_212;
   drHash[xc(GD_212)] = "Non-existant M12 check";
   Error_GD_212 = empty_violation();
   drErrHash[xc(GD_212)] = Error_GD_212;
   drErrGDSHash[xc(GD_212)] = { 150 , 1212 };

   drValHash[xc(CM_09)] = CM_09;
   drHash[xc(CM_09)] = "Non-existant M12 check";
   Error_CM_09 = empty_violation();
   drErrHash[xc(CM_09)] = Error_CM_09;
   drErrGDSHash[xc(CM_09)] = { 51 , 1009 };

#elif _drPROCESS == 6 || _drPROCESS == 2

#endif
BLDI_102 = 10.8;  
drValHash[xc(BLDI_102)] = BLDI_102;
LD_131hpc = 3.8;  
drValHash[xc(LD_131hpc)] = LD_131hpc;

//  expections for tsvcc structure
// as per kalyan with Dougs approval email
CD_200tsvcc = 82.0;  
LD_200tsvcc = 79.0;  

LD_131prjrom = 1.96; // 2.55; // 3.8
LD_131min = 3.2; // abs min allowed in a ld_131 window
LDI_02prjrf =  12.5; 
LDI_02max = 10.5; // abs max allowed in a ldi_02 window
BLDI_192max = 11.05; // abs max allowed in a ldi_02 LVC window
LD_234prjrom = 40.8; // 40.0;   chv
LD_234prjrf = 40.0;
LD_334prjtg = LD_334; // no waivers all defaults to normal tg layer id should be empty
