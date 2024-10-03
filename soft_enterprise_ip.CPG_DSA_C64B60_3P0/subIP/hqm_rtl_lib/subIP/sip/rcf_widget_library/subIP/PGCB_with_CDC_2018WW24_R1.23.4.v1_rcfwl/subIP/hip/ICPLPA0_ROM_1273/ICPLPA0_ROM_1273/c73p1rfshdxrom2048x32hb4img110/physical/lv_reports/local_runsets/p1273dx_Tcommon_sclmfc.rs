// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tcommon_sclmfc.rs.rca 1.2 Wed Sep 24 11:21:54 2014 kperrey Experimental $ 
// $Log: p1273dx_Tcommon_sclmfc.rs.rca $
// 
//  Revision: 1.2 Wed Sep 24 11:21:54 2014 kperrey
//  for mfc2port_m5/4/3 ; classify into typeI or typeII
// 
//  Revision: 1.1 Thu Jul 17 11:25:14 2014 kperrey
//  layer derivation for scaleable mfc 2/3/4/5 port
// 

#ifndef _P1273DX_TCOMMON_SCLMFC_RS_
#define _P1273DX_TCOMMON_SCLMFC_RS_


// derivations for scaleable mfc's
// SCLDEVID  ; id's a scaleable device
// MFCAPID   ; id's a mfc
// MFCID2    ; id's a 2 port mfc
// MFCID3    ; id's a 3 port mfc
// MFCID4    ; id's a 4 port mfc
//           ; if not 2 3 4 port mfc it must be a 5 port
// *;rcStop  ; id's the top layer in a mfc
//             will be termid4 in 5 port mfc
//             will be termid2 in 4 port mfc
//             will be termid2 in 3 port mfc
//             will be termid2 in 2 port mfc

// 2 port   
// CinstanceName   term1    term2   modelname w=<float> l=<float> mtop=<int> + mbot=<int> m=<int>

// Where:
// term1 == RCSTOP -1  (termid1)
// term2 == RCSTOP     (termid2)

// 3port 
// CinstanceName     term1    term2  <BULK>  modelname w=<float> l=<float> mtop=<int> mbot=<int> m=<int>

// Where:
// term1 == RCSTOP -1  (termid1)
// term2 == RCSTOP     (termid2)
// BULK == pwell_subiso

// 4port 
// CinstanceName     <lowershield>    term1    term2   <BULK>   modelname w=<float> l=<float> mtop=<int> mbot=<int> m=<int>

// Where:
// Lowershield = polycon (termid3)
// term1 == RCSTOP -1    (termid1)
// term2 == RCSTOP       (termid2)
// BULK == pwell_subiso


// 5port
// CinstanceName     <lowershield>    term1    term2   <uppershield>  <BULK>  modelname w=<float> l=<float> mtop=<int> + mbot=<int> m=<int>

// Where:
// Lowershield = polycon  (termid3)
// term1 == RCSTOP -1     (termid1)
// term2 == RCSTOP -1     (termid2)
// uppershield == RCSTOP  (termid4)
// BULK == pwell_subiso


// type of mfc is controlled by mfcapid and scldevid and mfcid[2-4]
mfcscldev = MFCAPID and SCLDEVID;;
mfc2port = mfcscldev interacting MFCID2;
mfc3port = mfcscldev interacting MFCID3;
mfc4port = mfcscldev interacting MFCID4;
mfc5port = mfcscldev not (mfc2port or mfc3port or mfc4port);

// classify 5port 
mfc5port_tm1 = mfc5port interacting TM1RCSTOP ;
mfc5port_m12 = mfc5port interacting MET12RCSTOP ;
mfc5port_m11 = mfc5port interacting MET11RCSTOP ;
mfc5port_m10 = mfc5port interacting MET10RCSTOP ;
mfc5port_m9  = mfc5port interacting MET9RCSTOP ;
mfc5port_m8  = mfc5port interacting MET8RCSTOP ;
mfc5port_m7  = mfc5port interacting MET7RCSTOP ;
mfc5port_m6  = mfc5port interacting MET6RCSTOP ;
mfc5port_m5  = mfc5port interacting MET5RCSTOP ;
mfc5port_m4  = mfc5port interacting MET4RCSTOP ;
mfc5port_m3  = mfc5port interacting MET3RCSTOP ;
mfc5port_m2  = mfc5port interacting MET2RCSTOP ;
mfc5port_m1  = mfc5port interacting MET1RCSTOP ;
                
// classify 4port 
mfc4port_tm1 = mfc4port interacting TM1RCSTOP ;
mfc4port_m12 = mfc4port interacting MET12RCSTOP ;
mfc4port_m11 = mfc4port interacting MET11RCSTOP ;
mfc4port_m10 = mfc4port interacting MET10RCSTOP ;
mfc4port_m9  = mfc4port interacting MET9RCSTOP ;
mfc4port_m8  = mfc4port interacting MET8RCSTOP ;
mfc4port_m7  = mfc4port interacting MET7RCSTOP ;
mfc4port_m6  = mfc4port interacting MET6RCSTOP ;
mfc4port_m5  = mfc4port interacting MET5RCSTOP ;
mfc4port_m4  = mfc4port interacting MET4RCSTOP ;
mfc4port_m3  = mfc4port interacting MET3RCSTOP ;
mfc4port_m2  = mfc4port interacting MET2RCSTOP ;
mfc4port_m1  = mfc4port interacting MET1RCSTOP ;
                
// classify 3port 
mfc3port_tm1 = mfc3port interacting TM1RCSTOP ;
mfc3port_m12 = mfc3port interacting MET12RCSTOP ;
mfc3port_m11 = mfc3port interacting MET11RCSTOP ;
mfc3port_m10 = mfc3port interacting MET10RCSTOP ;
mfc3port_m9  = mfc3port interacting MET9RCSTOP ;
mfc3port_m8  = mfc3port interacting MET8RCSTOP ;
mfc3port_m7  = mfc3port interacting MET7RCSTOP ;
mfc3port_m6  = mfc3port interacting MET6RCSTOP ;
mfc3port_m5  = mfc3port interacting MET5RCSTOP ;
mfc3port_m4  = mfc3port interacting MET4RCSTOP ;
mfc3port_m3  = mfc3port interacting MET3RCSTOP ;
mfc3port_m2  = mfc3port interacting MET2RCSTOP ;
mfc3port_m1  = mfc3port interacting MET1RCSTOP ;
 
// classify 2port 
mfc2port_tm1 = mfc2port interacting TM1RCSTOP ;
mfc2port_m12 = mfc2port interacting MET12RCSTOP ;
mfc2port_m11 = mfc2port interacting MET11RCSTOP ;
mfc2port_m10 = mfc2port interacting MET10RCSTOP ;
mfc2port_m9  = mfc2port interacting MET9RCSTOP ;
mfc2port_m8  = mfc2port interacting MET8RCSTOP ;
mfc2port_m7  = mfc2port interacting MET7RCSTOP ;
mfc2port_m6  = mfc2port interacting MET6RCSTOP ;
mfc2port_m5  = mfc2port interacting MET5RCSTOP ;
mfc2port_m4  = mfc2port interacting MET4RCSTOP ;
mfc2port_m3  = mfc2port interacting MET3RCSTOP ;
mfc2port_m2  = mfc2port interacting MET2RCSTOP ;
mfc2port_m1  = mfc2port interacting MET1RCSTOP ;

// get the ports for the 5ported mfc
// lowershield term1 term2 uppershield bulk 
// term1 (5term)  rcstop - 1
#if _drPROCESS == _drdotSix
   mfc5port_tm1_t1m12 = mfc5port_tm1 and MET12TERMID1 and metal12nores;
   mfc5port_tm1_t1m9 = empty_layer();
#else
   mfc5port_tm1_t1m9 = mfc5port_tm1 and MET9TERMID1 and metal9nores;
   mfc5port_tm1_t1m12 = empty_layer();
#endif
mfc5port_m12_t1m11 = mfc5port_m12 and MET11TERMID1 and metal11nores; 
mfc5port_m11_t1m10 = mfc5port_m11 and MET10TERMID1 and metal10nores;
mfc5port_m10_t1m9  = mfc5port_m10 and MET9TERMID1  and metal9nores;
mfc5port_m9_t1m8   = mfc5port_m9  and MET8TERMID1  and metal8nores;
mfc5port_m8_t1m7   = mfc5port_m8  and MET7TERMID1  and metal7nores;
mfc5port_m7_t1m6   = mfc5port_m7  and MET6TERMID1  and metal6nores;
mfc5port_m6_t1m5   = mfc5port_m6  and MET5TERMID1  and metal5nores;
mfc5port_m5_t1m4   = mfc5port_m5  and MET4TERMID1  and metal4nores;
mfc5port_m4_t1m3   = mfc5port_m4  and MET3TERMID1  and metal3nores;
mfc5port_m3_t1m2   = mfc5port_m3  and MET2TERMID1  and metal2nores;
mfc5port_m2_t1m1   = mfc5port_m2  and MET1TERMID1  and metal1nores;
mfc5port_m1_t1m0   = mfc5port_m1  and MET0TERMID1  and metal0nores;

// term2 (5term)  rcstop - 1
#if _drPROCESS == _drdotSix
   mfc5port_tm1_t2m12 = mfc5port_tm1 and MET12TERMID2 and metal12nores;
   mfc5port_tm1_t2m9  = empty_layer();
#else
   mfc5port_tm1_t2m9  = mfc5port_tm1 and MET9TERMID2 and metal9nores;
   mfc5port_tm1_t2m12 = empty_layer();
#endif
mfc5port_m12_t2m11 = mfc5port_m12 and MET11TERMID2 and metal11nores;
mfc5port_m11_t2m10 = mfc5port_m11 and MET10TERMID2 and metal10nores;
mfc5port_m10_t2m9  = mfc5port_m10 and MET9TERMID2  and metal9nores;
mfc5port_m9_t2m8   = mfc5port_m9  and MET8TERMID2  and metal8nores;
mfc5port_m8_t2m7   = mfc5port_m8  and MET7TERMID2  and metal7nores;
mfc5port_m7_t2m6   = mfc5port_m7  and MET6TERMID2  and metal6nores;
mfc5port_m6_t2m5   = mfc5port_m6  and MET5TERMID2  and metal5nores;
mfc5port_m5_t2m4   = mfc5port_m5  and MET4TERMID2  and metal4nores;
mfc5port_m4_t2m3   = mfc5port_m4  and MET3TERMID2  and metal3nores;
mfc5port_m3_t2m2   = mfc5port_m3  and MET2TERMID2  and metal2nores;
mfc5port_m2_t2m1   = mfc5port_m2  and MET1TERMID2  and metal1nores;
mfc5port_m1_t2m0   = mfc5port_m1  and MET0TERMID2  and metal0nores;

// lower shield (5term) polycon  
mfc5port_lspc  = mfc5port  and PCTERMID3  and polycon_nores;

// upper shield (5term) rcstop 
mfc5port_ustm1  = mfc5port_tm1 and TM1TERMID4   and tm1nores;
mfc5port_usm12  = mfc5port_m12 and MET12TERMID4 and metal12nores;
mfc5port_usm11  = mfc5port_m11 and MET11TERMID4 and metal11nores;
mfc5port_usm10  = mfc5port_m10 and MET10TERMID4 and metal10nores;
mfc5port_usm9   = mfc5port_m9  and MET9TERMID4  and metal9nores;
mfc5port_usm8   = mfc5port_m8  and MET8TERMID4  and metal8nores;
mfc5port_usm7   = mfc5port_m7  and MET7TERMID4  and metal7nores;
mfc5port_usm6   = mfc5port_m6  and MET6TERMID4  and metal6nores;
mfc5port_usm5   = mfc5port_m5  and MET5TERMID4  and metal5nores;
mfc5port_usm4   = mfc5port_m4  and MET4TERMID4  and metal4nores;
mfc5port_usm3   = mfc5port_m3  and MET3TERMID4  and metal3nores;
mfc5port_usm2   = mfc5port_m2  and MET2TERMID4  and metal2nores;
mfc5port_usm1   = mfc5port_m1  and MET1TERMID4  and metal1nores;
 
// get the ports for the 4ported mfc
// lowershield term1 term2 bulk 
// term1 (4term)  rcstop - 1
#if _drPROCESS == _drdotSix
   mfc4port_tm1_t1m12 = mfc4port_tm1 and MET12TERMID1 and metal12nores;
   mfc4port_tm1_t1m9  = empty_layer();
#else
   mfc4port_tm1_t1m9  = mfc4port_tm1 and MET9TERMID1  and metal9nores;
   mfc4port_tm1_t1m12 = empty_layer();
#endif
mfc4port_m12_t1m11 = mfc4port_m12 and MET11TERMID1 and metal11nores;
mfc4port_m11_t1m10 = mfc4port_m11 and MET10TERMID1 and metal10nores;
mfc4port_m10_t1m9  = mfc4port_m10 and MET9TERMID1  and metal9nores;
mfc4port_m9_t1m8   = mfc4port_m9  and MET8TERMID1  and metal8nores;
mfc4port_m8_t1m7   = mfc4port_m8  and MET7TERMID1  and metal7nores;
mfc4port_m7_t1m6   = mfc4port_m7  and MET6TERMID1  and metal6nores;
mfc4port_m6_t1m5   = mfc4port_m6  and MET5TERMID1  and metal5nores;
mfc4port_m5_t1m4   = mfc4port_m5  and MET4TERMID1  and metal4nores;
mfc4port_m4_t1m3   = mfc4port_m4  and MET3TERMID1  and metal3nores;
mfc4port_m3_t1m2   = mfc4port_m3  and MET2TERMID1  and metal2nores;
mfc4port_m2_t1m1   = mfc4port_m2  and MET1TERMID1  and metal1nores;
mfc4port_m1_t1m0   = mfc4port_m1  and MET0TERMID1  and metal0nores;

// term2 (4term)  rcstop 
mfc4port_tm1_t2tm1 = mfc4port_tm1 and TM1TERMID2   and tm1nores;
mfc4port_m12_t2m12 = mfc4port_m12 and MET12TERMID2 and metal12nores;
mfc4port_m11_t2m11 = mfc4port_m11 and MET11TERMID2 and metal11nores;
mfc4port_m10_t2m10 = mfc4port_m10 and MET10TERMID2 and metal10nores;
mfc4port_m9_t2m9   = mfc4port_m9  and MET9TERMID2  and metal9nores;
mfc4port_m8_t2m8   = mfc4port_m8  and MET8TERMID2  and metal8nores;
mfc4port_m7_t2m7   = mfc4port_m7  and MET7TERMID2  and metal7nores;
mfc4port_m6_t2m6   = mfc4port_m6  and MET6TERMID2  and metal6nores;
mfc4port_m5_t2m5   = mfc4port_m5  and MET5TERMID2  and metal5nores;
mfc4port_m4_t2m4   = mfc4port_m4  and MET4TERMID2  and metal4nores;
mfc4port_m3_t2m3   = mfc4port_m3  and MET3TERMID2  and metal3nores;
mfc4port_m2_t2m2   = mfc4port_m2  and MET2TERMID2  and metal2nores;
mfc4port_m1_t2m1   = mfc4port_m1  and MET1TERMID2  and metal1nores;


// lower shield (4term) polycon  
mfc4port_lspc  = mfc4port  and PCTERMID3 and polycon_nores;

// get the ports for the 3ported mfc
// term1 term2 bulk 
// term1 (3term)  rcstop - 1
#if _drPROCESS == _drdotSix
   mfc3port_tm1_t1m12 = mfc2port_tm1 and MET12TERMID1 and metal12nores;
   mfc3port_tm1_t1m9  = empty_layer();
#else
   mfc3port_tm1_t1m9  = mfc2port_m9  and MET9TERMID1  and metal9nores;
   mfc3port_tm1_t1m12 = empty_layer();
#endif
mfc3port_m12_t1m11 = mfc3port_m12 and MET11TERMID1 and metal11nores;
mfc3port_m11_t1m10 = mfc3port_m11 and MET10TERMID1 and metal10nores;
mfc3port_m10_t1m9  = mfc3port_m10 and MET9TERMID1  and metal9nores;
mfc3port_m9_t1m8   = mfc3port_m9  and MET8TERMID1  and metal8nores;
mfc3port_m8_t1m7   = mfc3port_m8  and MET7TERMID1  and metal7nores;
mfc3port_m7_t1m6   = mfc3port_m7  and MET6TERMID1  and metal6nores;
mfc3port_m6_t1m5   = mfc3port_m6  and MET5TERMID1  and metal5nores;
mfc3port_m5_t1m4   = mfc3port_m5  and MET4TERMID1  and metal4nores;
mfc3port_m4_t1m3   = mfc3port_m4  and MET3TERMID1  and metal3nores;
mfc3port_m3_t1m2   = mfc3port_m3  and MET2TERMID1  and metal2nores;
mfc3port_m2_t1m1   = mfc3port_m2  and MET1TERMID1  and metal1nores;
mfc3port_m1_t1m0   = mfc3port_m1  and MET0TERMID1  and metal0nores;

// term2 (3term)  rcstop 
mfc3port_tm1_t2tm1 = mfc3port_tm1 and TM1TERMID2   and tm1nores;
mfc3port_m12_t2m12 = mfc3port_m12 and MET12TERMID2 and metal12nores;
mfc3port_m11_t2m11 = mfc3port_m11 and MET11TERMID2 and metal11nores;
mfc3port_m10_t2m10 = mfc3port_m10 and MET10TERMID2 and metal10nores;
mfc3port_m9_t2m9   = mfc3port_m9  and MET9TERMID2  and metal9nores;
mfc3port_m8_t2m8   = mfc3port_m8  and MET8TERMID2  and metal8nores;
mfc3port_m7_t2m7   = mfc3port_m7  and MET7TERMID2  and metal7nores;
mfc3port_m6_t2m6   = mfc3port_m6  and MET6TERMID2  and metal6nores;
mfc3port_m5_t2m5   = mfc3port_m5  and MET5TERMID2  and metal5nores;
mfc3port_m4_t2m4   = mfc3port_m4  and MET4TERMID2  and metal4nores;
mfc3port_m3_t2m3   = mfc3port_m3  and MET3TERMID2  and metal3nores;
mfc3port_m2_t2m2   = mfc3port_m2  and MET2TERMID2  and metal2nores;
mfc3port_m1_t2m1   = mfc3port_m1  and MET1TERMID2  and metal1nores;

// get the ports for the 2ported mfc
// term1 term2 
// term1 (2term)  rcstop - 1
#if _drPROCESS == _drdotSix
   mfc2port_tm1_t1m12 = mfc2port_tm1 and MET12TERMID1 and metal12nores;
   mfc2port_tm1_t1m9  = empty_layer();
#else
   mfc2port_tm1_t1m9  = mfc2port_m9  and MET9TERMID1  and metal9nores;
   mfc2port_tm1_t1m12 = empty_layer();
#endif
mfc2port_m12_t1m11 = mfc2port_m12 and MET11TERMID1 and metal11nores;
mfc2port_m11_t1m10 = mfc2port_m11 and MET10TERMID1 and metal10nores;
mfc2port_m10_t1m9  = mfc2port_m10 and MET9TERMID1  and metal9nores;
mfc2port_m9_t1m8   = mfc2port_m9  and MET8TERMID1  and metal8nores;
mfc2port_m8_t1m7   = mfc2port_m8  and MET7TERMID1  and metal7nores;
mfc2port_m7_t1m6   = mfc2port_m7  and MET6TERMID1  and metal6nores;
mfc2port_m6_t1m5   = mfc2port_m6  and MET5TERMID1  and metal5nores;
mfc2port_m5_t1m4   = mfc2port_m5  and MET4TERMID1  and metal4nores;
mfc2port_m4_t1m3   = mfc2port_m4  and MET3TERMID1  and metal3nores;
mfc2port_m3_t1m2   = mfc2port_m3  and MET2TERMID1  and metal2nores;
mfc2port_m2_t1m1   = mfc2port_m2  and MET1TERMID1  and metal1nores;
mfc2port_m1_t1m0   = mfc2port_m1  and MET0TERMID1  and metal0nores;

// term2 (2term)  rcstop 
mfc2port_tm1_t2tm1 = mfc2port_tm1 and TM1TERMID2   and tm1nores;
mfc2port_m12_t2m12 = mfc2port_m12 and MET12TERMID2 and metal12nores;
mfc2port_m11_t2m11 = mfc2port_m11 and MET11TERMID2 and metal11nores;
mfc2port_m10_t2m10 = mfc2port_m10 and MET10TERMID2 and metal10nores;
mfc2port_m9_t2m9   = mfc2port_m9  and MET9TERMID2  and metal9nores;
mfc2port_m8_t2m8   = mfc2port_m8  and MET8TERMID2  and metal8nores;
mfc2port_m7_t2m7   = mfc2port_m7  and MET7TERMID2  and metal7nores;
mfc2port_m6_t2m6   = mfc2port_m6  and MET6TERMID2  and metal6nores;
mfc2port_m5_t2m5   = mfc2port_m5  and MET5TERMID2  and metal5nores;
mfc2port_m4_t2m4   = mfc2port_m4  and MET4TERMID2  and metal4nores;
mfc2port_m3_t2m3   = mfc2port_m3  and MET3TERMID2  and metal3nores;
mfc2port_m2_t2m2   = mfc2port_m2  and MET2TERMID2  and metal2nores;
mfc2port_m1_t2m1   = mfc2port_m1  and MET1TERMID2  and metal1nores;


// build the cap plates
// term2 (5term)
#if _drPROCESS == _drdotSix
   mfc5port_tm1_t2m12p = copy(mfc5port_tm1);
   mfc5port_tm1_t2m9p  = empty_layer();
#else
   mfc5port_tm1_t2m9p  = copy(mfc5port_tm1);
   mfc5port_tm1_t2m12p = empty_layer();
#endif
mfc5port_m12_t2m11p = copy(mfc5port_m12);
mfc5port_m11_t2m10p = copy(mfc5port_m11);
mfc5port_m10_t2m9p  = copy(mfc5port_m10);
mfc5port_m9_t2m8p   = copy(mfc5port_m9);
mfc5port_m8_t2m7p   = copy(mfc5port_m8);
mfc5port_m7_t2m6p   = copy(mfc5port_m7);
mfc5port_m6_t2m5p   = copy(mfc5port_m6);
mfc5port_m5_t2m4p   = copy(mfc5port_m5);
mfc5port_m4_t2m3p   = copy(mfc5port_m4);
mfc5port_m3_t2m2p   = copy(mfc5port_m3);
mfc5port_m2_t2m1p   = copy(mfc5port_m2);
mfc5port_m1_t2m0p   = copy(mfc5port_m1);

// term1 (5term) 
#if _drPROCESS == _drdotSix
   mfc5port_tm1_t1m12p = copy(mfc5port_tm1);
   mfc5port_tm1_t1m9p  = empty_layer();
#else
   mfc5port_tm1_t1m9p  = copy(mfc5port_tm1);
   mfc5port_tm1_t1m12p = empty_layer();
#endif
mfc5port_m12_t1m11p = copy(mfc5port_m12);
mfc5port_m11_t1m10p = copy(mfc5port_m11);
mfc5port_m10_t1m9p  = copy(mfc5port_m10);
mfc5port_m9_t1m8p   = copy(mfc5port_m9);
mfc5port_m8_t1m7p   = copy(mfc5port_m8);
mfc5port_m7_t1m6p   = copy(mfc5port_m7);
mfc5port_m6_t1m5p   = copy(mfc5port_m6);
mfc5port_m5_t1m4p   = copy(mfc5port_m5);
mfc5port_m4_t1m3p   = copy(mfc5port_m4);
mfc5port_m3_t1m2p   = copy(mfc5port_m3);
mfc5port_m2_t1m1p   = copy(mfc5port_m2);
mfc5port_m1_t1m0p   = copy(mfc5port_m1);

// term2 (4term) 
mfc4port_tm1_t2tm1p = copy(mfc4port_tm1);
mfc4port_m12_t2m12p = copy(mfc4port_m12);
mfc4port_m11_t2m11p = copy(mfc4port_m11);
mfc4port_m10_t2m10p = copy(mfc4port_m10);
mfc4port_m9_t2m9p   = copy(mfc4port_m9);
mfc4port_m8_t2m8p   = copy(mfc4port_m8);
mfc4port_m7_t2m7p   = copy(mfc4port_m7);
mfc4port_m6_t2m6p   = copy(mfc4port_m6);
mfc4port_m5_t2m5p   = copy(mfc4port_m5);
mfc4port_m4_t2m4p   = copy(mfc4port_m4);
mfc4port_m3_t2m3p   = copy(mfc4port_m3);
mfc4port_m2_t2m2p   = copy(mfc4port_m2);
mfc4port_m1_t2m1p   = copy(mfc4port_m1);

// term1 (4term)  
#if _drPROCESS == _drdotSix
   mfc4port_tm1_t1m12p = copy(mfc4port_tm1);
   mfc4port_tm1_t1m9p  = empty_layer();
#else
   mfc4port_tm1_t1m9p  = copy(mfc4port_tm1);
   mfc4port_tm1_t1m12p = empty_layer();
#endif
mfc4port_m12_t1m11p = copy(mfc4port_m12);
mfc4port_m11_t1m10p = copy(mfc4port_m11);
mfc4port_m10_t1m9p  = copy(mfc4port_m10);
mfc4port_m9_t1m8p   = copy(mfc4port_m9);
mfc4port_m8_t1m7p   = copy(mfc4port_m8);
mfc4port_m7_t1m6p   = copy(mfc4port_m7);
mfc4port_m6_t1m5p   = copy(mfc4port_m6);
mfc4port_m5_t1m4p   = copy(mfc4port_m5);
mfc4port_m4_t1m3p   = copy(mfc4port_m4);
mfc4port_m3_t1m2p   = copy(mfc4port_m3);
mfc4port_m2_t1m1p   = copy(mfc4port_m2);
mfc4port_m1_t1m0p   = copy(mfc4port_m1);


// term2 (3term) 
mfc3port_tm1_t2tm1p = copy(mfc3port_tm1);
mfc3port_m12_t2m12p = copy(mfc3port_m12);
mfc3port_m11_t2m11p = copy(mfc3port_m11);
mfc3port_m10_t2m10p = copy(mfc3port_m10);
mfc3port_m9_t2m9p   = copy(mfc3port_m9);
mfc3port_m8_t2m8p   = copy(mfc3port_m8);
mfc3port_m7_t2m7p   = copy(mfc3port_m7);
mfc3port_m6_t2m6p   = copy(mfc3port_m6);
mfc3port_m5_t2m5p   = copy(mfc3port_m5);
mfc3port_m4_t2m4p   = copy(mfc3port_m4);
mfc3port_m3_t2m3p   = copy(mfc3port_m3);
mfc3port_m2_t2m2p   = copy(mfc3port_m2);
mfc3port_m1_t2m1p   = copy(mfc3port_m1);

// term1 (2term)  
#if _drPROCESS == _drdotSix
   mfc3port_tm1_t1m12p = copy(mfc3port_tm1);
   mfc3port_tm1_t1m9p =  empty_layer();
#else
   mfc3port_tm1_t1m9p =  copy(mfc3port_tm1);
   mfc3port_tm1_t1m12p = empty_layer();
#endif
mfc3port_m12_t1m11p = copy(mfc3port_m12);
mfc3port_m11_t1m10p = copy(mfc3port_m11);
mfc3port_m10_t1m9p  = copy(mfc3port_m10);
mfc3port_m9_t1m8p   = copy(mfc3port_m9);
mfc3port_m8_t1m7p   = copy(mfc3port_m8);
mfc3port_m7_t1m6p   = copy(mfc3port_m7);
mfc3port_m6_t1m5p   = copy(mfc3port_m6);
mfc3port_m5_t1m4p   = copy(mfc3port_m5);
mfc3port_m4_t1m3p   = copy(mfc3port_m4);
mfc3port_m3_t1m2p   = copy(mfc3port_m3);
mfc3port_m2_t1m1p   = copy(mfc3port_m2);
mfc3port_m1_t1m0p   = copy(mfc3port_m1);
 
// term2 (2term) 
mfc2port_tm1_t2tm1p = copy(mfc2port_tm1);
mfc2port_m12_t2m12p = copy(mfc2port_m12);
mfc2port_m11_t2m11p = copy(mfc2port_m11);
mfc2port_m10_t2m10p = copy(mfc2port_m10);
mfc2port_m9_t2m9p   = copy(mfc2port_m9);
mfc2port_m8_t2m8p   = copy(mfc2port_m8);
mfc2port_m7_t2m7p   = copy(mfc2port_m7);
mfc2port_m6_t2m6p   = copy(mfc2port_m6);
mfc2port_m5_t2m5p   = copy(mfc2port_m5);
mfc2port_m4_t2m4p   = copy(mfc2port_m4);
mfc2port_m3_t2m3p   = copy(mfc2port_m3);
mfc2port_m2_t2m2p   = copy(mfc2port_m2);
mfc2port_m1_t2m1p   = copy(mfc2port_m1);

// term1 (2term)  
#if _drPROCESS == _drdotSix
   mfc2port_tm1_t1m12p = copy(mfc2port_tm1);
   mfc2port_tm1_t1m9p =  empty_layer();
#else
   mfc2port_tm1_t1m9p =  copy(mfc2port_tm1);
   mfc2port_tm1_t1m12p = empty_layer();
#endif
mfc2port_m12_t1m11p = copy(mfc2port_m12);
mfc2port_m11_t1m10p = copy(mfc2port_m11);
mfc2port_m10_t1m9p  = copy(mfc2port_m10);
mfc2port_m9_t1m8p   = copy(mfc2port_m9);
mfc2port_m8_t1m7p   = copy(mfc2port_m8);
mfc2port_m7_t1m6p   = copy(mfc2port_m7);
mfc2port_m6_t1m5p   = copy(mfc2port_m6);
mfc2port_m5_t1m4p   = copy(mfc2port_m5);
mfc2port_m4_t1m3p   = copy(mfc2port_m4);
mfc2port_m3_t1m2p   = copy(mfc2port_m3);
mfc2port_m2_t1m1p   = copy(mfc2port_m2);
mfc2port_m1_t1m0p   = copy(mfc2port_m1);
 
// upper shield (5term) 
mfc5port_ustm1p = copy(mfc5port_tm1);
mfc5port_usm12p = copy(mfc5port_m12);
mfc5port_usm11p = copy(mfc5port_m11);
mfc5port_usm10p = copy(mfc5port_m10);
mfc5port_usm9p   = copy(mfc5port_m9);
mfc5port_usm8p   = copy(mfc5port_m8);
mfc5port_usm7p   = copy(mfc5port_m7);
mfc5port_usm6p   = copy(mfc5port_m6);
mfc5port_usm5p   = copy(mfc5port_m5);
mfc5port_usm4p   = copy(mfc5port_m4);
mfc5port_usm3p   = copy(mfc5port_m3);
mfc5port_usm2p   = copy(mfc5port_m2);
mfc5port_usm1p   = copy(mfc5port_m1);

// lower shield (5term) 
mfc5port_lspcp   = copy(mfc5port);

// lower shield (4term) 
mfc4port_lspcp   = copy(mfc4port);

// differentiate the 2ports typeI from typeII
mfc2portII_m5 = mfc2port_m5 interacting (MET4RCSTART or MET3RCSTART or MET2RCSTART);
mfc2portII_m4 = mfc2port_m4 interacting (MET3RCSTART or MET2RCSTART);
mfc2portII_m3 = mfc2port_m3 interacting MET2RCSTART;
mfc2port_m5 = mfc2port_m5 not mfc2portII_m5;
mfc2port_m4 = mfc2port_m4 not mfc2portII_m4;
mfc2port_m3 = mfc2port_m3 not mfc2portII_m3;

#ifdef _drDEBUG
   // mfc us 5port
   drPassthruStack.push_back({mfc5port_ustm1, {442,503} });  
   drPassthruStack.push_back({mfc5port_usm12, {462,504} });  
   drPassthruStack.push_back({mfc5port_usm11, {458,504} });  
   drPassthruStack.push_back({mfc5port_usm10, {454,504} });  
   drPassthruStack.push_back({mfc5port_usm9, {446,504} });  
   drPassthruStack.push_back({mfc5port_usm8, {438,504} });  
   drPassthruStack.push_back({mfc5port_usm7, {434,504} });  
   drPassthruStack.push_back({mfc5port_usm6, {430,504} });  
   drPassthruStack.push_back({mfc5port_usm5, {426,504} });  
   drPassthruStack.push_back({mfc5port_usm4, {422,504} });  
   drPassthruStack.push_back({mfc5port_usm3, {418,504} });  
   drPassthruStack.push_back({mfc5port_usm2, {414,504} });  
   drPassthruStack.push_back({mfc5port_usm1, {404,504} });  

   // mfc t2 5port
   #if _drPROCESS == _drdotSix
      drPassthruStack.push_back({mfc5port_tm1_t2m12, {462,502} });  
   #else
      drPassthruStack.push_back({mfc5port_tm1_t2m9, {446,502} });  
   #endif
   drPassthruStack.push_back({mfc5port_m12_t2m11, {458,502} });  
   drPassthruStack.push_back({mfc5port_m11_t2m10, {454,502} });  
   drPassthruStack.push_back({mfc5port_m10_t2m9, {446,502} });  
   drPassthruStack.push_back({mfc5port_m9_t2m8, {438,502} });  
   drPassthruStack.push_back({mfc5port_m8_t2m7, {434,502} });  
   drPassthruStack.push_back({mfc5port_m7_t2m6, {430,502} });  
   drPassthruStack.push_back({mfc5port_m6_t2m5, {426,502} });  
   drPassthruStack.push_back({mfc5port_m5_t2m4, {422,502} });  
   drPassthruStack.push_back({mfc5port_m4_t2m3, {418,502} });  
   drPassthruStack.push_back({mfc5port_m3_t2m2, {414,502} });  
   drPassthruStack.push_back({mfc5port_m2_t2m1, {404,502} });  
   drPassthruStack.push_back({mfc5port_m1_t2m0, {455,502} });  
   // mfc t2 4port
   drPassthruStack.push_back({mfc4port_tm1_t2tm1, {442,402} });  
   drPassthruStack.push_back({mfc4port_m12_t2m12, {464,402} });  
   drPassthruStack.push_back({mfc4port_m11_t2m11, {458,402} });  
   drPassthruStack.push_back({mfc4port_m10_t2m10, {454,402} });  
   drPassthruStack.push_back({mfc4port_m9_t2m9, {446,402} });  
   drPassthruStack.push_back({mfc4port_m8_t2m8, {438,402} });  
   drPassthruStack.push_back({mfc4port_m7_t2m7, {434,402} });  
   drPassthruStack.push_back({mfc4port_m6_t2m6, {430,402} });  
   drPassthruStack.push_back({mfc4port_m5_t2m5, {426,402} });  
   drPassthruStack.push_back({mfc4port_m4_t2m4, {422,402} });  
   drPassthruStack.push_back({mfc4port_m3_t2m3, {418,402} });  
   drPassthruStack.push_back({mfc4port_m2_t2m2, {414,402} });  
   drPassthruStack.push_back({mfc4port_m1_t2m1, {455,402} });  
   // mfc t2 3port
   drPassthruStack.push_back({mfc3port_tm1_t2tm1, {442,302} });  
   drPassthruStack.push_back({mfc3port_m12_t2m12, {464,302} });  
   drPassthruStack.push_back({mfc3port_m11_t2m11, {458,302} });  
   drPassthruStack.push_back({mfc3port_m10_t2m10, {454,302} });  
   drPassthruStack.push_back({mfc3port_m9_t2m9, {446,302} });  
   drPassthruStack.push_back({mfc3port_m8_t2m8, {438,302} });  
   drPassthruStack.push_back({mfc3port_m7_t2m7, {434,302} });  
   drPassthruStack.push_back({mfc3port_m6_t2m6, {430,302} });  
   drPassthruStack.push_back({mfc3port_m5_t2m5, {426,302} });  
   drPassthruStack.push_back({mfc3port_m4_t2m4, {422,302} });  
   drPassthruStack.push_back({mfc3port_m3_t2m3, {418,302} });  
   drPassthruStack.push_back({mfc3port_m2_t2m2, {414,302} });  
   drPassthruStack.push_back({mfc3port_m1_t2m1, {455,302} });  
   // mfc t2 2port
   drPassthruStack.push_back({mfc2port_tm1_t2tm1, {442,202} });  
   drPassthruStack.push_back({mfc2port_m12_t2m12, {462,202} });  
   drPassthruStack.push_back({mfc2port_m11_t2m11, {458,202} });  
   drPassthruStack.push_back({mfc2port_m10_t2m10, {454,202} });  
   drPassthruStack.push_back({mfc2port_m9_t2m9, {446,202} });  
   drPassthruStack.push_back({mfc2port_m8_t2m8, {438,202} });  
   drPassthruStack.push_back({mfc2port_m7_t2m7, {434,202} });  
   drPassthruStack.push_back({mfc2port_m6_t2m6, {430,202} });  
   drPassthruStack.push_back({mfc2port_m5_t2m5, {426,202} });  
   drPassthruStack.push_back({mfc2port_m4_t2m4, {422,202} });  
   drPassthruStack.push_back({mfc2port_m3_t2m3, {418,202} });  
   drPassthruStack.push_back({mfc2port_m2_t2m2, {414,202} });  
   drPassthruStack.push_back({mfc2port_m1_t2m1, {404,202} });  

   // mfc t1 5port
   #if _drPROCESS == _drdotSix
      drPassthruStack.push_back({mfc5port_tm1_t1m12, {462,502} });  
   #else
      drPassthruStack.push_back({mfc5port_tm1_t1m9, {446,502} });  
   #endif
   drPassthruStack.push_back({mfc5port_m12_t1m11, {458,501} });  
   drPassthruStack.push_back({mfc5port_m11_t1m10, {454,501} });  
   drPassthruStack.push_back({mfc5port_m10_t1m9, {446,501} });  
   drPassthruStack.push_back({mfc5port_m9_t1m8, {438,501} });  
   drPassthruStack.push_back({mfc5port_m8_t1m7, {434,501} });  
   drPassthruStack.push_back({mfc5port_m7_t1m6, {430,501} });  
   drPassthruStack.push_back({mfc5port_m6_t1m5, {426,501} });  
   drPassthruStack.push_back({mfc5port_m5_t1m4, {422,501} });  
   drPassthruStack.push_back({mfc5port_m4_t1m3, {418,501} });  
   drPassthruStack.push_back({mfc5port_m3_t1m2, {414,501} });  
   drPassthruStack.push_back({mfc5port_m2_t1m1, {404,501} });  
   drPassthruStack.push_back({mfc5port_m1_t1m0, {455,501} });  

   // mfc t1 4port
   drPassthruStack.push_back({mfc4port_tm1_t1m12, {462,401} });  
   drPassthruStack.push_back({mfc4port_tm1_t1m9, {446,401} });  
   drPassthruStack.push_back({mfc4port_m12_t1m11, {458,401} });  
   drPassthruStack.push_back({mfc4port_m11_t1m10, {454,401} });  
   drPassthruStack.push_back({mfc4port_m10_t1m9, {446,401} });  
   drPassthruStack.push_back({mfc4port_m9_t1m8, {438,401} });  
   drPassthruStack.push_back({mfc4port_m8_t1m7, {434,401} });  
   drPassthruStack.push_back({mfc4port_m7_t1m6, {430,401} });  
   drPassthruStack.push_back({mfc4port_m6_t1m5, {426,401} });  
   drPassthruStack.push_back({mfc4port_m5_t1m4, {422,401} });  
   drPassthruStack.push_back({mfc4port_m4_t1m3, {418,401} });  
   drPassthruStack.push_back({mfc4port_m3_t1m2, {414,401} });  
   drPassthruStack.push_back({mfc4port_m2_t1m1, {404,401} });  
   drPassthruStack.push_back({mfc4port_m1_t1m0, {455,401} });  
   // mfc t1 3port
   drPassthruStack.push_back({mfc3port_tm1_t1m12, {462,301} });  
   drPassthruStack.push_back({mfc3port_tm1_t1m9, {446,301} });  
   drPassthruStack.push_back({mfc3port_m12_t1m11, {458,301} });  
   drPassthruStack.push_back({mfc3port_m11_t1m10, {454,301} });  
   drPassthruStack.push_back({mfc3port_m10_t1m9, {446,301} });  
   drPassthruStack.push_back({mfc3port_m9_t1m8, {438,301} });  
   drPassthruStack.push_back({mfc3port_m8_t1m7, {434,301} });  
   drPassthruStack.push_back({mfc3port_m7_t1m6, {430,301} });  
   drPassthruStack.push_back({mfc3port_m6_t1m5, {426,301} });  
   drPassthruStack.push_back({mfc3port_m5_t1m4, {422,301} });  
   drPassthruStack.push_back({mfc3port_m4_t1m3, {418,301} });  
   drPassthruStack.push_back({mfc3port_m3_t1m2, {414,301} });  
   drPassthruStack.push_back({mfc3port_m2_t1m1, {404,301} });  
   drPassthruStack.push_back({mfc3port_m1_t1m0, {455,301} });  
   // mfc t1 2port
   drPassthruStack.push_back({mfc2port_tm1_t1m12, {462,201} });  
   drPassthruStack.push_back({mfc2port_tm1_t1m9, {446,201} });  
   drPassthruStack.push_back({mfc2port_m12_t1m11, {458,201} });  
   drPassthruStack.push_back({mfc2port_m11_t1m10, {454,201} });  
   drPassthruStack.push_back({mfc2port_m10_t1m9, {446,201} });  
   drPassthruStack.push_back({mfc2port_m9_t1m8, {438,201} });  
   drPassthruStack.push_back({mfc2port_m8_t1m7, {434,201} });  
   drPassthruStack.push_back({mfc2port_m7_t1m6, {430,201} });  
   drPassthruStack.push_back({mfc2port_m6_t1m5, {426,201} });  
   drPassthruStack.push_back({mfc2port_m5_t1m4, {422,201} });  
   drPassthruStack.push_back({mfc2port_m4_t1m3, {418,201} });  
   drPassthruStack.push_back({mfc2port_m3_t1m2, {414,201} });  
   drPassthruStack.push_back({mfc2port_m2_t1m1, {404,201} });  
   drPassthruStack.push_back({mfc2port_m1_t1m0, {455,201} });  

   // mfc lower shield
   drPassthruStack.push_back({mfc5port_lspc, {406,503} });  
   drPassthruStack.push_back({mfc4port_lspc, {406,403} });  
   
   // mfc 2port
   drPassthruStack.push_back({mfc2port_tm1,  {442,200} });  
   drPassthruStack.push_back({mfc2port_m12,  {462,200} });  
   drPassthruStack.push_back({mfc2port_m11,  {458,200} });  
   drPassthruStack.push_back({mfc2port_m10,  {454,200} });  
   drPassthruStack.push_back({mfc2port_m9,   {446,200} });  
   drPassthruStack.push_back({mfc2port_m8,   {438,200} });  
   drPassthruStack.push_back({mfc2port_m7,   {434,200} });  
   drPassthruStack.push_back({mfc2port_m6,   {430,200} });  
   drPassthruStack.push_back({mfc2port_m5,   {426,200} });  
   drPassthruStack.push_back({mfc2port_m4,   {422,200} });  
   drPassthruStack.push_back({mfc2port_m3,   {418,200} });  
   drPassthruStack.push_back({mfc2port_m2,   {414,200} });  
   drPassthruStack.push_back({mfc2port_m1,   {404,200} });  
   drPassthruStack.push_back({mfc2portII_m5, {426,1200} });  
   drPassthruStack.push_back({mfc2portII_m4, {422,1200} });  
   drPassthruStack.push_back({mfc2portII_m3, {418,1200} });  

   // mfc 3port
   drPassthruStack.push_back({mfc3port_tm1, {442,300} });  
   drPassthruStack.push_back({mfc3port_m12, {462,300} });  
   drPassthruStack.push_back({mfc3port_m11, {458,300} });  
   drPassthruStack.push_back({mfc3port_m10, {454,300} });  
   drPassthruStack.push_back({mfc3port_m9, {446,300} });  
   drPassthruStack.push_back({mfc3port_m8, {438,300} });  
   drPassthruStack.push_back({mfc3port_m7, {434,300} });  
   drPassthruStack.push_back({mfc3port_m6, {430,300} });  
   drPassthruStack.push_back({mfc3port_m5, {426,300} });  
   drPassthruStack.push_back({mfc3port_m4, {422,300} });  
   drPassthruStack.push_back({mfc3port_m3, {418,300} });  
   drPassthruStack.push_back({mfc3port_m2, {414,300} });  
   drPassthruStack.push_back({mfc3port_m1, {404,300} });  
   
   // mfc 4port
   drPassthruStack.push_back({mfc4port_tm1, {442,400} });  
   drPassthruStack.push_back({mfc4port_m12, {462,400} });  
   drPassthruStack.push_back({mfc4port_m11, {458,400} });  
   drPassthruStack.push_back({mfc4port_m10, {454,400} });  
   drPassthruStack.push_back({mfc4port_m9, {446,400} });  
   drPassthruStack.push_back({mfc4port_m8, {438,400} });  
   drPassthruStack.push_back({mfc4port_m7, {434,400} });  
   drPassthruStack.push_back({mfc4port_m6, {430,400} });  
   drPassthruStack.push_back({mfc4port_m5, {426,400} });  
   drPassthruStack.push_back({mfc4port_m4, {422,400} });  
   drPassthruStack.push_back({mfc4port_m3, {418,400} });  
   drPassthruStack.push_back({mfc4port_m2, {414,400} });  

   // mfc 5port
   drPassthruStack.push_back({mfc5port_tm1, {442,500} });  
   drPassthruStack.push_back({mfc5port_m12, {462,500} });  
   drPassthruStack.push_back({mfc5port_m11, {458,500} });  
   drPassthruStack.push_back({mfc5port_m10, {454,500} });  
   drPassthruStack.push_back({mfc5port_m9, {446,500} });  
   drPassthruStack.push_back({mfc5port_m8, {438,500} });  
   drPassthruStack.push_back({mfc5port_m7, {434,500} });  
   drPassthruStack.push_back({mfc5port_m6, {430,500} });  
   drPassthruStack.push_back({mfc5port_m5, {426,500} });  
   drPassthruStack.push_back({mfc5port_m4, {422,500} });  
   drPassthruStack.push_back({mfc5port_m3, {418,500} });  
   drPassthruStack.push_back({mfc5port_m2, {414,500} });  

   // base layers for ID
   drPassthruStack.push_back({MFCAPID, {81,137} });  
   drPassthruStack.push_back({SCLDEVID, {81,230} });  
   drPassthruStack.push_back({MFCID4, {81,161} });  
   drPassthruStack.push_back({MFCID3, {81,156} });  
   drPassthruStack.push_back({MFCID2, {81,155} });  
   drPassthruStack.push_back({MET0RCSTOP, {55,239} });  
   drPassthruStack.push_back({MET1RCSTOP, {4,239} });  
   drPassthruStack.push_back({MET2RCSTOP, {14,239} });  
   drPassthruStack.push_back({MET3RCSTOP, {18,239} });  
   drPassthruStack.push_back({MET4RCSTOP, {22,239} });  
   drPassthruStack.push_back({MET5RCSTOP, {26,239} });  
   drPassthruStack.push_back({MET6RCSTOP, {30,239} });  
   drPassthruStack.push_back({MET7RCSTOP, {34,239} });  
   drPassthruStack.push_back({MET8RCSTOP, {38,239} });  
   drPassthruStack.push_back({MET9RCSTOP, {46,239} });  
   drPassthruStack.push_back({MET10RCSTOP, {54,239} });  
   drPassthruStack.push_back({MET11RCSTOP, {58,239} });  
   drPassthruStack.push_back({MET12RCSTOP, {62,239} });  
   drPassthruStack.push_back({TM1RCSTOP, {42,239} });  

   // termid
   drPassthruStack.push_back({MET0TERMID1, {55,110} });  
   drPassthruStack.push_back({MET0TERMID2, {55,121} });  
   drPassthruStack.push_back({MET0TERMID3, {55,122} });  
   drPassthruStack.push_back({MET0TERMID4, {55,123} });  
   drPassthruStack.push_back({MET1TERMID1, {4,110} });  
   drPassthruStack.push_back({MET1TERMID2, {4,121} });  
   drPassthruStack.push_back({MET1TERMID3, {4,122} });  
   drPassthruStack.push_back({MET1TERMID4, {4,123} });  
   drPassthruStack.push_back({MET2TERMID1, {14,110} });  
   drPassthruStack.push_back({MET2TERMID2, {14,121} });  
   drPassthruStack.push_back({MET2TERMID3, {14,122} });  
   drPassthruStack.push_back({MET2TERMID4, {14,123} });  
   drPassthruStack.push_back({MET3TERMID1, {18,110} });  
   drPassthruStack.push_back({MET3TERMID2, {18,121} });  
   drPassthruStack.push_back({MET3TERMID3, {18,122} });  
   drPassthruStack.push_back({MET3TERMID4, {18,123} });  
   drPassthruStack.push_back({MET4TERMID1, {22,110} });  
   drPassthruStack.push_back({MET4TERMID2, {22,121} });  
   drPassthruStack.push_back({MET4TERMID3, {22,122} });  
   drPassthruStack.push_back({MET4TERMID4, {22,123} });  
   drPassthruStack.push_back({MET5TERMID1, {26,110} });  
   drPassthruStack.push_back({MET5TERMID2, {26,121} });  
   drPassthruStack.push_back({MET5TERMID3, {26,122} });  
   drPassthruStack.push_back({MET5TERMID4, {26,123} });  
   drPassthruStack.push_back({MET6TERMID1, {30,110} });  
   drPassthruStack.push_back({MET6TERMID2, {30,121} });  
   drPassthruStack.push_back({MET6TERMID3, {30,122} });  
   drPassthruStack.push_back({MET6TERMID4, {30,123} });  
   drPassthruStack.push_back({MET7TERMID1, {34,110} });  
   drPassthruStack.push_back({MET7TERMID2, {34,121} });  
   drPassthruStack.push_back({MET7TERMID3, {34,122} });  
   drPassthruStack.push_back({MET7TERMID4, {34,123} });  

#endif  // end _drDEBUG

#endif  // end _P1273DX_TCOMMON_SCLMFC_RS_
