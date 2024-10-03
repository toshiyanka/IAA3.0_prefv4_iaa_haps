//$Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tcommon_mvsw.rs.rca 1.4 Thu Sep 25 22:12:40 2014 kperrey Experimental $

//$Log: p1273dx_Tcommon_mvsw.rs.rca $
//
// Revision: 1.4 Thu Sep 25 22:12:40 2014 kperrey
// moved the mvsw construction checks to p1273dx_Tchks_mvsw.rs
//
// Revision: 1.3 Fri Sep  5 16:00:21 2014 kperrey
// remove the scvx and the sovx devices (layer agnostic via switches
//
// Revision: 1.2 Fri Aug 22 14:48:13 2014 kperrey
// add simple construction checks for sc*/so*/aliasd devices
//
// Revision: 1.1 Sat Aug 16 12:26:25 2014 kperrey
// support for the som/scm/scv/sov/aliasd switch devices for icv
//

#ifndef _P1273DX_TCOMMON_MVSW_RS_
#define _P1273DX_TCOMMON_MVSW_RS_


//this should create opens if not drawn correctly 
m0scm = metal0nores and  MET0SWITCHID;
m0som = MET0SWITCHID not_interacting m0scm;
m0scmx = metal0nores and  MET0ALTSWITCHID;
m0somx = MET0ALTSWITCHID not_interacting m0scmx;
m0aliasd = m0scmx interacting MET0ALIASID;
m0scmx = m0scmx not m0aliasd;
metal0nores = metal0nores not (MET0SWITCHID or MET0ALTSWITCHID);

m1scm = metal1nores and  MET1SWITCHID;
m1som = MET1SWITCHID not_interacting m1scm;
m1scmx = metal1nores and  MET1ALTSWITCHID;
m1somx = MET1ALTSWITCHID not_interacting m1scmx;
m1aliasd = m1scmx interacting MET1ALIASID;
m1scmx = m1scmx not m1aliasd;
metal1nores = metal1nores not (MET1SWITCHID or MET1ALTSWITCHID);

m2scm = metal2nores and  MET2SWITCHID;
m2som = MET2SWITCHID not_interacting m2scm;
m2scmx = metal2nores and  MET2ALTSWITCHID;
m2somx = MET2ALTSWITCHID not_interacting m2scmx;
m2aliasd = m2scmx interacting MET2ALIASID;
m2scmx = m2scmx not m2aliasd;
metal2nores = metal2nores not (MET2SWITCHID or MET2ALTSWITCHID);

m3scm = metal3nores and  MET3SWITCHID;
m3som = MET3SWITCHID not_interacting m3scm;
m3scmx = metal3nores and  MET3ALTSWITCHID;
m3somx = MET3ALTSWITCHID not_interacting m3scmx;
m3aliasd = m3scmx interacting MET3ALIASID;
m3scmx = m3scmx not m3aliasd;
metal3nores = metal3nores not (MET3SWITCHID or MET3ALTSWITCHID);

m4scm = metal4nores and  MET4SWITCHID;
m4som = MET4SWITCHID not_interacting m4scm;
m4scmx = metal4nores and  MET4ALTSWITCHID;
m4somx = MET4ALTSWITCHID not_interacting m4scmx;
m4aliasd = m4scmx interacting MET4ALIASID;
m4scmx = m4scmx not m4aliasd;
metal4nores = metal4nores not (MET4SWITCHID or MET4ALTSWITCHID);

m5scm = metal5nores and  MET5SWITCHID;
m5som = MET5SWITCHID not_interacting m5scm;
m5scmx = metal5nores and  MET5ALTSWITCHID;
m5somx = MET5ALTSWITCHID not_interacting m5scmx;
m5aliasd = m5scmx interacting MET5ALIASID;
m5scmx = m5scmx not m5aliasd;
metal5nores = metal5nores not (MET5SWITCHID or MET5ALTSWITCHID);

m6scm = metal6nores and  MET6SWITCHID;
m6som = MET6SWITCHID not_interacting m6scm;
m6scmx = metal6nores and  MET6ALTSWITCHID;
m6somx = MET6ALTSWITCHID not_interacting m6scmx;
m6aliasd = m6scmx interacting MET6ALIASID;
m6scmx = m6scmx not m6aliasd;
metal6nores = metal6nores not (MET6SWITCHID or MET6ALTSWITCHID);

m7scm = metal7nores and  MET7SWITCHID;
m7som = MET7SWITCHID not_interacting m7scm;
m7scmx = metal7nores and  MET7ALTSWITCHID;
m7somx = MET7ALTSWITCHID not_interacting m7scmx;
m7aliasd = m7scmx interacting MET7ALIASID;
m7scmx = m7scmx not m7aliasd;
metal7nores = metal7nores not (MET7SWITCHID or MET7ALTSWITCHID);

m8scm = metal8nores and  MET8SWITCHID;
m8som = MET8SWITCHID not_interacting m8scm;
m8scmx = metal8nores and  MET8ALTSWITCHID;
m8somx = MET8ALTSWITCHID not_interacting m8scmx;
m8aliasd = m8scmx interacting MET8ALIASID;
m8scmx = m8scmx not m8aliasd;
metal8nores = metal8nores not (MET8SWITCHID or MET8ALTSWITCHID);

m9scm = metal9nores and  MET9SWITCHID;
m9som = MET9SWITCHID not_interacting m9scm;
m9scmx = metal9nores and  MET9ALTSWITCHID;
m9somx = MET9ALTSWITCHID not_interacting m9scmx;
m9aliasd = m9scmx interacting MET9ALIASID;
m9scmx = m9scmx not m9aliasd;
metal9nores = metal9nores not (MET9SWITCHID or MET9ALTSWITCHID);

m10scm = metal10nores and  MET10SWITCHID;
m10som = MET10SWITCHID not_interacting m10scm;
m10scmx = metal10nores and  MET10ALTSWITCHID;
m10somx = MET10ALTSWITCHID not_interacting m10scmx;
m10aliasd = m10scmx interacting MET10ALIASID;
m10scmx = m10scmx not m10aliasd;
metal10nores = metal10nores not (MET10SWITCHID or MET10ALTSWITCHID);

m11scm = metal11nores and  MET11SWITCHID;
m11som = MET11SWITCHID not_interacting m11scm;
m11scmx = metal11nores and  MET11ALTSWITCHID;
m11somx = MET11ALTSWITCHID not_interacting m11scmx;
m11aliasd = m11scmx interacting MET11ALIASID;
m11scmx = m11scmx not m11aliasd;
metal11nores = metal11nores not (MET11SWITCHID or MET11ALTSWITCHID);

m12scm = metal12nores and  MET12SWITCHID;
m12som = MET12SWITCHID not_interacting m12scm;
m12scmx = metal12nores and  MET12ALTSWITCHID;
m12somx = MET12ALTSWITCHID not_interacting m12scmx;
m12aliasd = m12scmx interacting MET12ALIASID;
m12scmx = m12scmx not m12aliasd;
metal12nores = metal12nores not (MET12SWITCHID or MET12ALTSWITCHID);

tm1scm = tm1nores and  TM1SWITCHID;
tm1som = TM1SWITCHID not_interacting tm1scm;
tm1scmx = tm1nores and  TM1ALTSWITCHID;
tm1somx = TM1ALTSWITCHID not_interacting tm1scmx;
tm1aliasd = tm1scmx interacting TM1ALIASID;
tm1scmx = tm1scmx not tm1aliasd;
tm1nores = tm1nores not (TM1SWITCHID or TM1ALTSWITCHID);

//via resistors
//v0
v0scv = VIA0 interacting VIA0SWITCHID;
v0sov = VIA0SWITCHID not_interacting v0scv;
//v0scvx = VIA0 interacting VIA0ALTSWITCHID;
//v0sovx = VIA0ALTSWITCHID not_interacting v0scvx;
via0nores = VIA0 not (VIA0SWITCHID or VIA0ALTSWITCHID);

//v1
v1scv = VIA1 interacting VIA1SWITCHID;
v1sov = VIA1SWITCHID not_interacting v1scv;
//v1scvx = VIA1 interacting VIA1ALTSWITCHID;
//v1sovx = VIA1ALTSWITCHID not_interacting v1scvx;
via1nores = VIA1 not (VIA1SWITCHID or VIA1ALTSWITCHID);

//v2
v2scv = VIA2 interacting VIA2SWITCHID;
v2sov = VIA2SWITCHID not_interacting v2scv;
//v2scvx = VIA2 interacting VIA2ALTSWITCHID;
//v2sovx = VIA2ALTSWITCHID not_interacting v2scvx;
via2nores = VIA2 not (VIA2SWITCHID or VIA2ALTSWITCHID); 

//v3
v3scv = VIA3 interacting VIA3SWITCHID;
v3sov = VIA3SWITCHID not_interacting v3scv;
//v3scvx = VIA3 interacting VIA3ALTSWITCHID;
//v3sovx = VIA3ALTSWITCHID not_interacting v3scvx;
via3nores = VIA3 not (VIA3SWITCHID or VIA3ALTSWITCHID);

//v4
v4scv = VIA4 interacting VIA4SWITCHID;
v4sov = VIA4SWITCHID not_interacting v4scv;
//v4scvx = VIA4 interacting VIA4ALTSWITCHID;
//v4sovx = VIA4ALTSWITCHID not_interacting v4scvx;
via4nores = VIA4 not (VIA4SWITCHID or VIA4ALTSWITCHID);

//v5
v5scv = VIA5 interacting VIA5SWITCHID;
v5sov = VIA5SWITCHID not_interacting v5scv;
//v5scvx = VIA5 interacting VIA5ALTSWITCHID;
//v5sovx = VIA5ALTSWITCHID not_interacting v5scvx;
via5nores = VIA5 not (VIA5SWITCHID or VIA5ALTSWITCHID);

//v6
v6scv = VIA6 interacting VIA6SWITCHID;
v6sov = VIA6SWITCHID not_interacting v6scv;
//v6scvx = VIA6 interacting VIA6ALTSWITCHID;
//v6sovx = VIA6ALTSWITCHID not_interacting v6scvx;
via6nores = VIA6 not (VIA6SWITCHID or VIA6ALTSWITCHID);

//v7
v7scv = VIA7 interacting VIA7SWITCHID;
v7sov = VIA7SWITCHID not_interacting v7scv;
//v7scvx = VIA7 interacting VIA7ALTSWITCHID;
//v7sovx = VIA7ALTSWITCHID not_interacting v7scvx;
via7nores = VIA7 not (VIA7SWITCHID or VIA7ALTSWITCHID);

//v8
v8scv = VIA8 interacting VIA8SWITCHID;
v8sov = VIA8SWITCHID not_interacting v8scv;
//v8scvx = VIA8 interacting VIA8ALTSWITCHID;
//v8sovx = VIA8ALTSWITCHID not_interacting v8scvx;
via8nores = VIA8 not (VIA8SWITCHID or VIA8ALTSWITCHID);

//v9
v9scv = VIA9 interacting VIA9SWITCHID;
v9sov = VIA9SWITCHID not_interacting v9scv;
//v9scvx = VIA9 interacting VIA9ALTSWITCHID;
//v9sovx = VIA9ALTSWITCHID not_interacting v9scvx;
via9nores = VIA9 not (VIA9SWITCHID or VIA9ALTSWITCHID);

//v10
v10scv = VIA10 interacting VIA10SWITCHID;
v10sov = VIA10SWITCHID not_interacting v10scv;
//v10scvx = VIA10 interacting VIA10ALTSWITCHID;
//v10sovx = VIA10ALTSWITCHID not_interacting v10scvx;
via10nores = VIA10 not (VIA10SWITCHID or VIA10ALTSWITCHID);

//v11
v11scv = VIA11 interacting VIA11SWITCHID;
v11sov = VIA11SWITCHID not_interacting v11scv;
//v11scvx = VIA11 interacting VIA11ALTSWITCHID;
//v11sovx = VIA11ALTSWITCHID not_interacting v11scvx;
via11nores = VIA11 not (VIA11SWITCHID or VIA11ALTSWITCHID);

//v12
v12scv = VIA12 interacting VIA12SWITCHID;
v12sov = VIA12SWITCHID not_interacting v12scv;
//v12scvx = VIA12 interacting VIA12ALTSWITCHID;
//v12sovx = VIA12ALTSWITCHID not_interacting v12scvx;
via12nores = VIA12 not (VIA12SWITCHID or VIA12ALTSWITCHID);

#ifdef _drDEBUG
  drPassthruStack.push_back({metal0nores, {355,0} });  
  drPassthruStack.push_back({metal1nores, {304,0} });  
  drPassthruStack.push_back({metal2nores, {314,0} });  
  drPassthruStack.push_back({metal3nores, {318,0} });  
  drPassthruStack.push_back({metal4nores, {322,0} });  
  drPassthruStack.push_back({metal5nores, {326,0} });  
  drPassthruStack.push_back({metal6nores, {330,0} });  
  drPassthruStack.push_back({metal7nores, {334,0} });  
  drPassthruStack.push_back({metal8nores, {338,0} });  
  drPassthruStack.push_back({metal9nores, {346,0} });  
  drPassthruStack.push_back({metal10nores, {354,0} });  
  drPassthruStack.push_back({metal11nores, {358,0} });  
  drPassthruStack.push_back({tm1nores,    {342,0} });  
  drPassthruStack.push_back({via0nores, {355,0} });
  drPassthruStack.push_back({via1nores, {313,0} });
  drPassthruStack.push_back({via2nores, {317,0} });
  drPassthruStack.push_back({via3nores, {321,0} });
  drPassthruStack.push_back({via4nores, {325,0} });
  drPassthruStack.push_back({via5nores, {329,0} });
  drPassthruStack.push_back({via6nores, {333,0} });
  drPassthruStack.push_back({via7nores, {337,0} });
  drPassthruStack.push_back({via8nores, {341,0} });
  drPassthruStack.push_back({via9nores, {345,0} });
  drPassthruStack.push_back({via10nores, {353,0} });
  drPassthruStack.push_back({via11nores, {357,0} });
  drPassthruStack.push_back({via12nores, {361,0} });
#endif


#endif  // end _P1273DX_TCOMMON_MVSW_RS_
