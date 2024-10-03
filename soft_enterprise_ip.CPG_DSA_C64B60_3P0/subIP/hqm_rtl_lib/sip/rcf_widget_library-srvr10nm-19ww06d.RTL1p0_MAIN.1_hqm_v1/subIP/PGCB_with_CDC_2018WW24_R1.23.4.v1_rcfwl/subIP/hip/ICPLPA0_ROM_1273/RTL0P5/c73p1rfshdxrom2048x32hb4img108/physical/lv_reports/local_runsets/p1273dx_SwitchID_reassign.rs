
#ifndef _P1273DX_SWITCHID_REASSIGN_RS_
#define _P1273DX_SWITCHID_REASSIGN_RS_

////////////////////
//DR_SWITCHID 
//0	ALL OPEN
//1	ALL CLOSED
//2	SWAP METAL
//3	SWAP VIA



//Define the switches
m0switch = ((MET0ALTSWITCHID or MET0SWITCHID) not MET0ALIASID);
m1switch = ((MET1ALTSWITCHID or MET1SWITCHID) not MET1ALIASID);
m2switch = ((MET2ALTSWITCHID or MET2SWITCHID) not MET2ALIASID);
m3switch = ((MET3ALTSWITCHID or MET3SWITCHID) not MET3ALIASID);
m4switch = ((MET4ALTSWITCHID or MET4SWITCHID) not MET4ALIASID);
m5switch = ((MET5ALTSWITCHID or MET5SWITCHID) not MET5ALIASID);
m6switch = ((MET6ALTSWITCHID or MET6SWITCHID) not MET6ALIASID);
m7switch = ((MET7ALTSWITCHID or MET7SWITCHID) not MET7ALIASID);
m8switch = ((MET8ALTSWITCHID or MET8SWITCHID) not MET8ALIASID);
m9switch = ((MET9ALTSWITCHID or MET9SWITCHID) not MET9ALIASID);
m10switch = ((MET10ALTSWITCHID or MET10SWITCHID) not MET10ALIASID);
m11switch = ((MET11ALTSWITCHID or MET11SWITCHID) not MET11ALIASID);
m12switch = ((MET12ALTSWITCHID or MET12SWITCHID) not MET12ALIASID);
//
vcswitch = (VIACONALTSWITCHID or VIACONSWITCHID);    
v0switch = (VIA0ALTSWITCHID or VIA0SWITCHID);
v1switch = (VIA1ALTSWITCHID or VIA1SWITCHID);
v2switch = (VIA2ALTSWITCHID or VIA2SWITCHID);
v3switch = (VIA3ALTSWITCHID or VIA3SWITCHID);
v4switch = (VIA4ALTSWITCHID or VIA4SWITCHID);
v5switch = (VIA5ALTSWITCHID or VIA5SWITCHID);
v6switch = (VIA6ALTSWITCHID or VIA6SWITCHID);
v7switch = (VIA7ALTSWITCHID or VIA7SWITCHID);
v8switch = (VIA8ALTSWITCHID or VIA8SWITCHID);
v9switch = (VIA9ALTSWITCHID or VIA9SWITCHID);
v10switch = (VIA10ALTSWITCHID or VIA10SWITCHID);
v11switch = (VIA11ALTSWITCHID or VIA11SWITCHID);
v12switch = (VIA12ALTSWITCHID or VIA12SWITCHID);



#define DR_FlipSwitch(bool) \
  METAL0  = METAL0 bool m0switch; METAL0BC = METAL0BC bool m0switch;\
  METAL1  = METAL1 bool m1switch; METAL1BC = METAL1BC bool m1switch;\
  METAL2  = METAL2 bool m2switch; METAL2BC = METAL2BC bool m2switch;\
  METAL3  = METAL3 bool m3switch; METAL3BC = METAL3BC bool m3switch;\
  METAL4  = METAL4 bool m4switch; METAL4BC = METAL4BC bool m4switch;\
  METAL5  = METAL5 bool m5switch; METAL5BC = METAL5BC bool m5switch;\
  METAL6  = METAL6 bool m6switch; METAL6BC = METAL6BC bool m6switch;\
  METAL7  = METAL7 bool m7switch; METAL7BC = METAL7BC bool m7switch;\
  METAL8  = METAL8 bool m8switch; METAL8BC = METAL8BC bool m8switch;\
  METAL9  = METAL9 bool m9switch; METAL9BC = METAL9BC bool m9switch;\
  METAL10  = METAL10 bool m10switch; METAL10BC = METAL10BC bool m10switch;\
  METAL11  = METAL11 bool m11switch; METAL11BC = METAL11BC bool m11switch;\
  METAL12  = METAL12 bool m12switch; METAL12BC = METAL12BC bool m12switch;\
  \
  VIA0  = VIA0 bool v0switch;\
  VIA1  = VIA1 bool v1switch;\
  VIA2  = VIA2 bool v2switch;\
  VIA3  = VIA3 bool v3switch;\
  VIA4  = VIA4 bool v4switch;\
  VIA5  = VIA5 bool v5switch;\
  VIA6  = VIA6 bool v6switch;\
  VIA7  = VIA7 bool v7switch;\
  VIA8  = VIA8 bool v8switch;\
  VIA9  = VIA9 bool v9switch;\
  VIA10  = VIA10 bool v10switch;\
  VIA11  = VIA11 bool v11switch;\
  VIA12  = VIA12 bool v12switch;\



//OPEN STATE
#if (_drSWITCHID == 0)
DR_FlipSwitch(not)



//CLOSED STATE
#elif (_drSWITCHID == 1)
DR_FlipSwitch(or)



//SWAP METAL
#elif (_drSWITCHID == 2)

m0close_switch = METAL0BC and m0switch; 
m0open_switch  = m0switch not m0close_switch; 
METAL0=(METAL0 not m0close_switch) or m0open_switch;
METAL0BC=(METAL0BC not m0close_switch) or m0open_switch;

m1close_switch = METAL1BC and m1switch; 
m1open_switch  = m1switch not m1close_switch; 
METAL1=(METAL1 not m1close_switch) or m1open_switch;
METAL1BC=(METAL1BC not m1close_switch) or m1open_switch;

m2close_switch = METAL2BC and m2switch; 
m2open_switch  = m2switch not m2close_switch; 
METAL2=(METAL2 not m2close_switch) or m2open_switch;
METAL2BC=(METAL2BC not m2close_switch) or m2open_switch;

m3close_switch = METAL3BC and m3switch; 
m3open_switch  = m3switch not m3close_switch; 
METAL3=(METAL3 not m3close_switch) or m3open_switch;
METAL3BC=(METAL3BC not m3close_switch) or m3open_switch;

m4close_switch = METAL4BC and m4switch; 
m4open_switch  = m4switch not m4close_switch; 
METAL4=(METAL4 not m4close_switch) or m4open_switch;
METAL4BC=(METAL4BC not m4close_switch) or m4open_switch;

m5close_switch = METAL5BC and m5switch; 
m5open_switch  = m5switch not m5close_switch; 
METAL5=(METAL5 not m5close_switch) or m5open_switch;
METAL5BC=(METAL5BC not m5close_switch) or m5open_switch;

m6close_switch = METAL6BC and m6switch; 
m6open_switch  = m6switch not m6close_switch; 
METAL6=(METAL6 not m6close_switch) or m6open_switch;
METAL6BC=(METAL6BC not m6close_switch) or m6open_switch;

m7close_switch = METAL7BC and m7switch; 
m7open_switch  = m7switch not m7close_switch; 
METAL7=(METAL7 not m7close_switch) or m7open_switch;
METAL7BC=(METAL7BC not m7close_switch) or m7open_switch;

m8close_switch = METAL8BC and m8switch; 
m8open_switch  = m8switch not m8close_switch; 
METAL8=(METAL8 not m8close_switch) or m8open_switch;
METAL8BC=(METAL8BC not m8close_switch) or m8open_switch;

m9close_switch = METAL9BC and m9switch; 
m9open_switch  = m9switch not m9close_switch; 
METAL9=(METAL9 not m9close_switch) or m9open_switch;
METAL9BC=(METAL9BC not m9close_switch) or m9open_switch;

m10close_switch = METAL10 and m10switch; 
m10open_switch  = m10switch not m10close_switch; 
METAL10=(METAL10 not m10close_switch) or m10open_switch;
METAL10BC=(METAL10BC not m10close_switch) or m10open_switch;

m11close_switch = METAL11 and m11switch; 
m11open_switch  = m11switch not m11close_switch; 
METAL11=(METAL11 not m11close_switch) or m11open_switch;
METAL11BC=(METAL11BC not m11close_switch) or m11open_switch;

m12close_switch = METAL12 and m12switch; 
m12open_switch  = m12switch not m12close_switch; 
METAL12=(METAL12 not m12close_switch) or m12open_switch;
METAL12BC=(METAL12BC not m12close_switch) or m12open_switch;


//SWAP VIA
#elif (_drSWITCHID == 3)

vcclose_switch = VIACON and vcswitch;
vcopen_switch = vcswitch not vcclose_switch;
VIACON = (VIACON not vcclose_switch) or vcopen_switch;

v0close_switch = VIA0 and v0switch;
v0open_switch = v0switch not v0close_switch;
VIA0 = (VIA0 not v0close_switch) or v0open_switch;

v1close_switch = VIA1 and v1switch;
v1open_switch = v1switch not v1close_switch;
VIA1 = (VIA1 not v1close_switch) or v1open_switch;

v2close_switch = VIA2 and v2switch;
v2open_switch = v2switch not v2close_switch;
VIA2 = (VIA2 not v2close_switch) or v2open_switch;

v3close_switch = VIA3 and v3switch;
v3open_switch = v3switch not v3close_switch;
VIA3 = (VIA3 not v3close_switch) or v3open_switch;

v4close_switch = VIA4 and v4switch;
v4open_switch = v4switch not v4close_switch;
VIA4 = (VIA4 not v4close_switch) or v4open_switch;

v5close_switch = VIA5 and v5switch;
v5open_switch = v5switch not v5close_switch;
VIA5 = (VIA5 not v5close_switch) or v5open_switch;

v6close_switch = VIA6 and v6switch;
v6open_switch = v6switch not v6close_switch;
VIA6 = (VIA6 not v6close_switch) or v6open_switch;

v7close_switch = VIA7 and v7switch;
v7open_switch = v7switch not v7close_switch;
VIA7 = (VIA7 not v7close_switch) or v7open_switch;

v8close_switch = VIA8 and v8switch;
v8open_switch = v8switch not v8close_switch;
VIA8 = (VIA8 not v8close_switch) or v8open_switch;

v9close_switch = VIA9 and v9switch;
v9open_switch = v9switch not v9close_switch;
VIA9 = (VIA9 not v9close_switch) or v9open_switch;

v10close_switch = VIA10 and v10switch;
v10open_switch = v10switch not v10close_switch;
VIA10 = (VIA10 not v10close_switch) or v10open_switch;

v11close_switch = VIA11 and v11switch;
v11open_switch = v11switch not v11close_switch;
VIA11 = (VIA11 not v11close_switch) or v11open_switch;

v12close_switch = VIA12 and v12switch;
v12open_switch = v12switch not v12close_switch;
VIA12 = (VIA12 not v12close_switch) or v12open_switch;




#endif
#undef DR_FlipSwitch


#endif
