// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_MC.rs.rca 1.4 Thu Jul  3 11:20:18 2014 jhannouc Experimental $
//
// $Log: p1273dx_MC.rs.rca $
// 
//  Revision: 1.4 Thu Jul  3 11:20:18 2014 jhannouc
//  Added waiver for FC_EDM checks for dot1 since the fill cells are the same as the dot4 cells.
// 
//  Revision: 1.3 Tue Jul  1 10:12:22 2014 jhannouc
//  Added 4 new checks that are enabled at fullchip. These checks would insure that the right ER, DIC, PRS and EDM collaterals are used based on specified process and dot process.
// 
//  Revision: 1.2 Thu Aug 16 11:43:10 2012 dgthakur
//  Added size checks for RMP layer.
// 
//  Revision: 1.1 Mon Aug  6 14:51:02 2012 dgthakur
//  Added 1273 specific RMP checks for CPR templates.
//


//1273 related misc checks


//RMPMG layer checks for 1273 CPR templates


RMP_01: double = 0.200;
drErrGDSHash[xc(RMP_01)] = {224,1001} ;
drHash[xc(RMP_01)] = "RMP min space (all dir)" ;
drValHash[xc(RMP_01)] = RMP_01;

RMP_02: double = 0.070;
drErrGDSHash[xc(RMP_02)] = {224,1002} ;
drHash[xc(RMP_02)] = "RMP to poly min space (PGD)" ;
drValHash[xc(RMP_02)] = RMP_02;

RMP_03: double = 0.025;
drErrGDSHash[xc(RMP_03)] = {224,1003} ;
drHash[xc(RMP_03)] = "RMP to poly min space (all dir)" ;
drValHash[xc(RMP_03)] = RMP_03;

RMP_04: double = 0.070;
drErrGDSHash[xc(RMP_04)] = {224,1004} ;
drHash[xc(RMP_04)] = "RMP to diffcon min space (all dir)" ;
drValHash[xc(RMP_04)] = RMP_04;

RMP_05: double = 0.030; //PGD enclosure poly by RMP
RMP_06: double = 0.025; //OGD enclosure poly by RMP
drErrGDSHash[xc(RMP_05/06)] = {224,1005} ;
drHash[xc(RMP_05/06)] = "Min poly enclosure by RMP 30 nm in PGD and 25 nm in OGD" ;
drValHash[xc(RMP_05/06)] = 0.0;

RMP_07: double = 0.420;
drErrGDSHash[xc(RMP_07)] = {224,1007} ;
drHash[xc(RMP_07)] = "RMP width exact (OGD)" ;
drValHash[xc(RMP_07)] = RMP_07;

RMP_08: double = 1.396;
RMP_09: double = 0.997;
drErrGDSHash[xc(RMP_08)] = {224,1008} ;
drHash[xc(RMP_08)] = "RMP width only allowed values 1.396 and 0.997 um (PGD)" ;
drValHash[xc(RMP_08)] = 0;


poly_not_inside_rmp = POLY not_inside RMPMG;
tcn_not_inside_rmp = DIFFCON not_inside RMPMG;

drMinSpace_(xc(RMP_01), RMPMG, RMP_01);

drMinSpaceDir2_(xc(RMP_02), RMPMG, poly_not_inside_rmp, <RMP_02, gate_dir);

drMinSpace2_(xc(RMP_03), RMPMG, poly_not_inside_rmp, RMP_03);

drMinSpace2_(xc(RMP_04), RMPMG, tcn_not_inside_rmp, RMP_04);

poly_rmp = POLY interacting RMPMG;
poly_rmp_os1 = drGrowDir( poly_rmp, RMP_05, gate_dir);
poly_rmp_os2 = drGrowDir( poly_rmp_os1, RMP_06, non_gate_dir);
drCopyToError_(xc(RMP_05/06), poly_rmp_os2 not RMPMG);

rmp_good_width_ogd = drWidth(RMPMG, RMP_07, non_gate_dir);
drCopyToError_(xc(RMP_07), RMPMG not rmp_good_width_ogd);

rmp_good_width_pgd1 = drWidth(rmp_good_width_ogd, RMP_08, gate_dir);
rmp_good_width_pgd2 = drWidth(rmp_good_width_ogd, RMP_09, gate_dir);
rmp_good_width_pgd = rmp_good_width_pgd1 or rmp_good_width_pgd2;
drCopyToError_(xc(RMP_08), RMPMG not rmp_good_width_pgd);



//Debug layers
drPassthru( POLY, 2, 0);
drPassthru( DIFFCON, 5, 0);
drPassthru( RMPMG, 224, 0);


// Fullchip collateral checks (DIC, ER, PRS and EDM)
// The following rules will check correct usage of collaterals in their corresponding dots.
drErrGDSHash[xc(FC_ER)] = {224,2001} ;
drHash[xc(FC_ER)] = "ER collaterals from wrong dot process being used";
drValHash[xc(FC_ER)] = 0;

drErrGDSHash[xc(FC_DIC)] = {224,2002} ;
drHash[xc(FC_DIC)] = "DIC collaterals from wrong dot process being used";
drValHash[xc(FC_DIC)] = 0;

drErrGDSHash[xc(FC_PRS)] = {224,2003} ;
drHash[xc(FC_PRS)] = "PRS collaterals from wrong dot process being used";
drValHash[xc(FC_PRS)] = 0;

drErrGDSHash[xc(FC_EDM)] = {224,2004} ;
drHash[xc(FC_EDM)] = "EDM collaterals from wrong dot process being used";
drValHash[xc(FC_EDM)] = 0;

#if (_drFULL_DIE == _drYES)

   #if (_drPROCESS == 6)
       etchring_error1 = copy_by_cells(CELLBOUNDARY, etchring_cells_73_1, CELL_LEVEL);
       etchring_error2 = copy_by_cells(CELLBOUNDARY, etchring_cells_73_4, CELL_LEVEL);

       // Nested DIC cells are the same for all dot process (1,4 and 6).
       dic_error1 = copy_by_cells(CELLBOUNDARY, diciso_cells_73_1, CELL_LEVEL);
       dic_error2 = copy_by_cells(CELLBOUNDARY, diciso_cells_73_4, CELL_LEVEL);

       prs_error1 = copy_by_cells(CELLBOUNDARY, iyprs_cells_73_1, CELL_LEVEL);
       prs_error2 = copy_by_cells(CELLBOUNDARY, iyprs_cells_73_4, CELL_LEVEL);

       edm_error1 = copy_by_cells(CELLBOUNDARY, edm_cells_73_1, CELL_LEVEL);
       edm_error2 = copy_by_cells(CELLBOUNDARY, edm_cells_73_4, CELL_LEVEL);
       
   #elif (_drPROCESS == 1)
       etchring_error1 = copy_by_cells(CELLBOUNDARY, etchring_cells_73_6, CELL_LEVEL);
       etchring_error2 = copy_by_cells(CELLBOUNDARY, etchring_cells_73_4, CELL_LEVEL);
       
       // Nested DIC cells are the same for all dot process (1,4 and 6).
       dic_error1 = copy_by_cells(CELLBOUNDARY, diciso_cells_73_6, CELL_LEVEL);
       dic_error2 = copy_by_cells(CELLBOUNDARY, diciso_cells_73_4, CELL_LEVEL);

       prs_error1 = copy_by_cells(CELLBOUNDARY, iyprs_cells_73_6, CELL_LEVEL);
       prs_error2 = copy_by_cells(CELLBOUNDARY, iyprs_cells_73_4, CELL_LEVEL);

       edm_error1 = copy_by_cells(CELLBOUNDARY, edm_cells_73_6, CELL_LEVEL);
       // The OGD and PGD fill cells in dot1 are the same cells of dot4.
       edm_error2_pre = copy_by_cells(CELLBOUNDARY, edm_cells_73_4, CELL_LEVEL);
       edm_error2_waive1 = copy_by_cells(CELLBOUNDARY, edm_ofill_cells_73_4, CELL_LEVEL);
       edm_error2_waive2 = copy_by_cells(CELLBOUNDARY, edm_pfill_cells_73_4, CELL_LEVEL);
       edm_error2 = edm_error2_pre not (edm_error2_waive1 or edm_error2_waive2);
       
   #else
       etchring_error1 = copy_by_cells(CELLBOUNDARY, etchring_cells_73_1, CELL_LEVEL);
       etchring_error2 = copy_by_cells(CELLBOUNDARY, etchring_cells_73_6, CELL_LEVEL);
      
       // Nested DIC cells are the same for all dot process (1,4 and 6).
       dic_error1 = copy_by_cells(CELLBOUNDARY, diciso_cells_73_1, CELL_LEVEL);
       dic_error2 = copy_by_cells(CELLBOUNDARY, diciso_cells_73_6, CELL_LEVEL);

       prs_error1 = copy_by_cells(CELLBOUNDARY, iyprs_cells_73_1, CELL_LEVEL);
       prs_error2 = copy_by_cells(CELLBOUNDARY, iyprs_cells_73_6, CELL_LEVEL);

       edm_error1 = copy_by_cells(CELLBOUNDARY, edm_cells_73_1, CELL_LEVEL);
       edm_error2 = copy_by_cells(CELLBOUNDARY, edm_cells_73_6, CELL_LEVEL);
   #endif

etchring_error = etchring_error1 or etchring_error2;
drCopyToError_(xc(FC_ER), etchring_error);

dic_error = dic_error1 or dic_error2;
drCopyToError_(xc(FC_DIC), dic_error);

prs_error = prs_error1 or prs_error2;
drCopyToError_(xc(FC_PRS), prs_error);

edm_error = edm_error1 or edm_error2;
drCopyToError_(xc(FC_EDM), edm_error);

#endif  // _drFULL_DIE check for Collaterals used in correct process.
