// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_MIM.rs.rca 1.13 Wed Mar 12 17:30:47 2014 kperrey Experimental $
// $Log: p1273dx_MIM.rs.rca $
// 
//  Revision: 1.13 Wed Mar 12 17:30:47 2014 kperrey
//  hsd 2193; duplicate the CE2_hole_via for CE1 and mimvia_CE2 exclude the ones in the CE1hole
// 
//  Revision: 1.12 Wed Feb  5 10:50:53 2014 kperrey
//  change high_voltage_list -> high_voltage_list_gt1417 for source of ce1_ehvhv
// 
//  Revision: 1.11 Wed Jan 29 14:03:28 2014 kperrey
//  change MIM_82/MIM_83 checks gnd/float ratio instead of the float/grnd ratio which would allow the ground to be upto 20% bigger
// 
//  Revision: 1.10 Thu Oct 17 13:17:16 2013 nhkhan1
//  changed C4B references to C4BEMIB which is the old C4B + new smaller C4EMIB bumps
// 
//  Revision: 1.9 Fri Oct 11 13:06:36 2013 nhkhan1
//  changed the hardcoded vss to _dr_lvsLayoutGround (defined in UserDefines)
// 
//  Revision: 1.8 Thu Mar 28 15:04:42 2013 tmurata
//  updated the MIM related layers for P1273.6.
// 
//  Revision: 1.7 Wed Dec  5 11:10:36 2012 tmurata
//  updated for P1273.5.
// 
//  Revision: 1.6 Thu Oct 25 15:31:53 2012 oakin
//  fixed the MIM_05 check.
// 
//  Revision: 1.5 Wed Oct 17 12:04:31 2012 kperrey
//  add double/triple stack cap ; triple keys off uhv_signal ; double keys off ehv/hv_signal ; does not support ehv/hv to triple
// 
//  Revision: 1.4 Wed Aug 22 14:11:29 2012 dgthakur
//  Made updates for p1273.6.
// 
//  Revision: 1.3 Thu May  3 14:58:26 2012 oakin
//  added MIM_05/07 waiver for flloating CE1 etc (Moonsoo K).
//  waiver for chain cells.
// 
//  Revision: 1.2 Thu Apr 19 14:50:03 2012 dgthakur
//  Updating MIM rules similar to 1272 style but 2 plates; Main change in MIM_04/05/07/54/55 rules.
// 
//  Revision: 1.1 Tue Jul 19 18:29:59 2011 tmurata
//  p1273 MIM checks except the connectivity based ones.
//
// The following is the comments of the p1271 runset on which this is based.
// 
//  Revision: 1.6 Fri Jul  8 18:37:19 2011 sstalukd
//  Added hooks for .5/.6 new process technology
// 
//  Revision: 1.5 Thu Feb 24 07:35:07 2011 kperrey
//  fixed typo variable is _drPROCESS and not drPROCESS
// 
//  Revision: 1.4 Fri Jan 14 17:35:51 2011 dgthakur
//  Added dot9 hook (at places where dot2 branch is presnet).
// 
//  Revision: 1.3 Thu Feb 18 16:59:01 2010 tmurata
//  corrected the MIM_03 check that missed the line-on-line case.
// 
//  Revision: 1.2 Wed Aug 26 17:17:04 2009 sstalukd
//  Replaced ==0 w/ !=2 for drPROCESS
// 
//  Revision: 1.1 Fri Jul 10 11:56:01 2009 sstalukd
//  Initial checkin for 1271 Rev 0.0 release
// 

// p1273 MIM SDR checks

#ifndef _P1273DX_MIM_RS_
#define _P1273DX_MIM_RS_

mimRatioVal:double;

stackedMimMin : function( void ) returning void {
   plate1Area : double  = ns_net_area("plate1");
   plate2Area : double  = ns_net_area("plate2");
   plateRatio : double  = plate2Area / plate1Area ;
   note("p1a = " + plate1Area + " p2a = " + plate2Area + " pr = " + plateRatio + "\n");
   if (dbllt(plateRatio, mimRatioVal)) {
      ns_save_net({"plate1Area","plate2Area","plateRatio","MinRatio"}, {plate1Area,plate2Area,plateRatio,mimRatioVal}); 
   }
};

stackedMimMax : function( void ) returning void {
   plate1Area : double  = ns_net_area("plate1");
   plate2Area : double  = ns_net_area("plate2");
   plateRatio : double  = plate2Area / plate1Area ;
   note("p1a = " + plate1Area + " p2a = " + plate2Area + " pr = " + plateRatio + "\n");
   if (dblgt(plateRatio, mimRatioVal)) {
      ns_save_net({"plate1Area","plate2Area","plateRatio","MaxRatio"}, {plate1Area,plate2Area,plateRatio,mimRatioVal}); 
   }
};

///////////////////////
//just for testing
//CE1 = copy(METAL1);
//CE2 = copy(METAL6);
///////////////////////


drErrGDSHash[xc(MIM_05/7)] = {90,2005} ;
drHash[xc(MIM_05/7)] = xc(CE2 must enclose CE1);
drValHash[xc(MIM_05/7)] = 0;

//set dotFour as the default (just in case) [also COPY is not strictly necessary; but keeping it]
#if (_drPROCESS == 5)
  MIMvia = copy(VIA10);
  MIMviabelow = VIA9;
  MIMtmn1       = METAL9BC;
  MIMtmn1_resid = MET9BCRESID;
  MIMtmn1_txt   = METAL9BC_txt;
  MIMtm0        = METAL10BC;
  MIMtm0_resid  = MET10BCRESID;
  MIMtm0_txt    = METAL10BC_txt;
#elif (_drPROCESS == 6)
  MIMvia = copy(VIA12);
  MIMviabelow = VIA11;
  MIMtmn1       = METAL11BC;
  MIMtmn1_resid = MET11BCRESID;
  MIMtmn1_txt   = METAL11BC_txt;
  MIMtm0        = METAL12BC;
  MIMtm0_resid  = MET12BCRESID;
  MIMtm0_txt    = METAL12BC_txt;
#else //including _drPROCESS == 4
  MIMvia = copy(VIA9);
  MIMviabelow = VIA8;
  MIMtmn1       = METAL8BC;
  MIMtmn1_resid = MET8BCRESID;
  MIMtmn1_txt   = METAL8BC_txt;
  MIMtm0        = METAL9BC;
  MIMtm0_resid  = MET9BCRESID;
  MIMtm0_txt    = METAL9BC_txt;
#endif

myMIMOverlap: polygon_layer = CE1 and CE2;
ce1_or_ce2: const polygon_layer = CE1 or CE2;
CE2_hole = donut_holes(CE2, INNER);
CE2_hole_via = MIMvia inside CE2_hole;
CE1_hole = donut_holes(CE1, INNER);
CE1_hole_via = MIMvia inside CE1_hole;

// some of these definition are taken from Tconn *****START
// find floating ce1/ce2


tmn1nores = MIMtmn1 not MIMtmn1_resid;
tm0nores  = MIMtm0  not MIMtm0_resid;
tm1nores  = TM1BC not TM1BCRESID;


// connectivity for mim construction checks
mim_construction_connect = connect (
   connect_items = {
     {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
     {layers = {tm1nores, tm0nores, CE1, CE2}, by_layer = MIMvia },
     {layers = {tm0nores, tmn1nores}, by_layer = MIMviabelow } }
   );

mim_construction_connect_txt = text_net (
      connect_sequence = mim_construction_connect,
      text_layer_items = {
         {layer = C4BEMIB, text_layer = C4BEMIB_txt},
         {layer = tm1nores, text_layer = TM1BC_txt},
         {layer = tm0nores, text_layer = MIMtm0_txt},
         {layer = tmn1nores, text_layer = MIMtmn1_txt}
      },
      opens = IGNORE,  
      report_errors = {}, 
      attach_text = ALL,
      rename_prefix = ""
   );

  

ce1Floating = CE1 not_interacting MIMvia;
ce2Floating = CE2 not_interacting MIMvia;

ce2_vss = net_select(
		connect_sequence = mim_construction_connect_txt,  
		net_type = TEXTED,
		texted_with = _dr_lvsLayoutGround,
		output_from_layers = {CE2});

ce2_vssORfloat = ce2_vss or ce2Floating;
ce2_connected2nonvss = CE2 not ce2_vssORfloat;

ce1tocheck = (CE1 interacting ce2_connected2nonvss) or (CE1 interacting MIMvia);

// extract double stacked mim structures
ce1_vss = net_select(
		connect_sequence = mim_construction_connect_txt,  
		net_type = TEXTED,
		texted_with = _dr_lvsLayoutGround,
		output_from_layers = {CE1});
ce1_ehvhv = net_select(
		connect_sequence = mim_construction_connect_txt,  
		net_type = TEXTED,
		texted_with = strcat(extra_high_voltage_list,high_voltage_list_gt1417),
		output_from_layers = {CE1});
ce2FloatEHVHV = ce2Floating interacting ce1_ehvhv;
ce1vssEHVHV = ce1_vss interacting ce2FloatEHVHV;
ce1ce2Plate2a = ce1_ehvhv and ce2FloatEHVHV;
ce2ce1Plate2b = ce2FloatEHVHV and ce1_vss;

// extract triple stacked mim structures
// triple stack
ce1_uhv = net_select(
		connect_sequence = mim_construction_connect_txt,  
		net_type = TEXTED,
		texted_with = ultra_high_voltage_list,
		output_from_layers = {CE1});
ce2FloatUHV = ce2Floating interacting ce1_uhv;
ce1FloatUHV = ce1Floating interacting ce2FloatUHV;
ce2vssUHV = ce2_vss interacting ce1FloatUHV;
ce1ce2Plate3a = ce1_uhv and ce2FloatUHV;
ce2ce1Plate3b = ce2FloatUHV and ce1FloatUHV;
ce1ce2Plate3c = ce1FloatUHV and ce2vssUHV;



#ifdef _drDEBUG
  drPassthruStack.push_back({ ce2_vss, {987,1} });
  drPassthruStack.push_back({ ce1Floating, {987,2} });
  drPassthruStack.push_back({ ce2Floating, {987,3} });
  drPassthruStack.push_back({ ce1tocheck, {987,4} });
#endif
// some of these definition are taken from Tconn *****END




//Min width
drMinWidth_("MIM_01", CE1, MIM_01);
drMinWidth_("MIM_01", CE2, MIM_01);


//Min space
drMinSpace_("MIM_02", CE1, MIM_02);
drMinSpace_("MIM_02", CE2, MIM_02);


//Min offset of edges
err @= {
  @ GetRuleString("MIM_03");  note(CheckingString("MIM_03"));
  enclose(CE1, CE2, distance<MIM_03, extension=RADIAL, intersecting={TOUCH});
  enclose(CE2, CE1, distance<MIM_03, extension=RADIAL, intersecting={TOUCH});  
}
drPushErrorStack(err, "MIM_03");


//Min overlap width of plates
drMinWidth_(xc(MIM_04), myMIMOverlap, MIM_04);


//MIM_05/7: CE1 must be inside CE2
err @= {
  @ GetRuleString(xc(MIM_05/7)); note(CheckingString(xc(MIM_05/7)));
  CE2_hole_via_os = size(CE2_hole_via, MIM_54); //Fill CE2 hole which has MIMvia
  ce1tocheck not (CE2 or CE2_hole_via_os) not (waiver_mim0507_ce1 or ce1_uhv);
  CE1 not_interacting CE2;
  CE2 not_interacting CE1;
}
drPushErrorStack(err, xc(MIM_05/7));


//MIM_05: edge crossing between CE1/2
err @= {
  @ GetRuleString(xc(MIM_05));  note(CheckingString(xc(MIM_05)));
//   ce1_conc_edges = adjacent_edge(CE1, length>0.0, angle1=270.0);
//   ce2_conc_edges = adjacent_edge(CE2, length>0.0, angle1=270.0);
     ce1toCheck_or_ce2 =  ce1tocheck or CE2;
//   (adjacent_edge(ce1toCheck_or_ce2, length>0.0, angle1=270.0) not_coincident_edge ce1_conc_edges)
//     not_coincident_edge ce2_conc_edges;

  corner_270_ce1 = vertex(ce1tocheck, angles = 270, shape_size = drunit);
  corner_270_ce2 = vertex(CE2, angles = 270, shape_size = drunit);
  
  vertex(ce1toCheck_or_ce2, angles = 270, shape_size = drunit) not (corner_270_ce1 or corner_270_ce2);


//  (adjacent_edge(ce1_or_ce2, length>0.0, angle1=270.0) not_coincident_edge ce1_conc_edges) 
//    not_coincident_edge ce2_conc_edges;
}
drPushErrorStack(err, xc(MIM_05));


err @= {
  @ GetRuleString("MIM_51");  note(CheckingString("MIM_51"));
  drEncloseAllDir(MIMvia, CE1, MIM_51);
  drEncloseAllDir(MIMvia, CE2, MIM_51);
}
drErrorStack.push_back({ err, drErrGDSHash["MIM_51"], "" });


err @= {
  @ GetRuleString("MIM_52");  note(CheckingString("MIM_52"));
  drViaViaSpaceConnectedAllround(CE1, MIMvia, MIMvia, MIM_52);
  drViaViaSpaceConnectedAllround(CE2, MIMvia, MIMvia, MIM_52);
}
drErrorStack.push_back({ err, drErrGDSHash["MIM_52"], "" });


// [case a] Via9 connected with no capacitor plates.
MIMvia_no_mim = not_interacting(not_interacting(MIMvia, CE1), CE2);
drExternal2AllDir_(xc(MIM_54), CE1, MIMvia_no_mim, MIM_54);
drExternal2AllDir_(xc(MIM_55), CE2, MIMvia_no_mim, MIM_55);


// [case b] Via9 connected to exactly 1 capacitor plate.
mimvia_CE1 = ((MIMvia interacting CE1) not_interacting CE2) not CE2_hole_via;
mimvia_CE2 = ((MIMvia interacting CE2) not_interacting CE1) not CE1_hole_via;
drExternal2AllDir_(xc(MIM_54), CE1, mimvia_CE2, MIM_54);
drExternal2AllDir_(xc(MIM_55), CE2, mimvia_CE1, MIM_55);


//No via in overlap region
err @= {
  @ GetRuleString("MIM_53");  note(CheckingString("MIM_53"));
  interacting(MIMvia, myMIMOverlap, include_touch=ALL) not waiver_mim53;
}
drErrorStack.push_back({ err, drErrGDSHash["MIM_53"], "" });


//Min hole area
drMinHole_(xc(MIM_22), CE1, MIM_22);
drMinHole_(xc(MIM_22), CE2, MIM_22);


//Min jog length
err @= {
  @ GetRuleString("MIM_23");  note(CheckingString("MIM_23"));
  adjacent_edge(CE1, length < MIM_23, angle1 = 90, angle2 = 270);
  adjacent_edge(CE2, length < MIM_23, angle1 = 90, angle2 = 270);
}
drErrorStack.push_back({ err, drErrGDSHash["MIM_23"], "" });


//Min area
err @= {
  @ GetRuleString("MIM_25");  note(CheckingString("MIM_25"));
  drMinAreaWaive(CE1, waiver_mim25_ce1, MIM_25);
  drMinAreaWaive(CE2, waiver_mim25_ce2, MIM_25);
}
drErrorStack.push_back({ err, drErrGDSHash["MIM_25"], "" });


//Max extent
err @= {
  @ GetRuleString("MIM_26");  note(CheckingString("MIM_26"));
  extent(CE1, sides={ > MIM_26, > 0});
  extent(CE2, sides={ > MIM_26, > 0});
}
drErrorStack.push_back({err, drErrGDSHash["MIM_26"], ""});

// double stack construction checks
err @= {
  @ GetRuleString("MIM_71");  note(CheckingString("MIM_71"));
  ce1_ehvhv not_interacting ce2Floating;  
  ce2FloatEHVHV not_interacting ce1vssEHVHV;
}
drErrorStack.push_back({err, drErrGDSHash["MIM_71"], ""});

mim72_construction_connect = connect( 
   connect_items = { {layers = {ce1ce2Plate2a, ce2ce1Plate2b}, by_layer = ce2FloatEHVHV}});

mimRatioVal = MIM_72;
err @= {
  @ GetRuleString("MIM_72");  note(CheckingString("MIM_72"));
  net_select( connect_sequence = mim72_construction_connect,
    layer_groups = { "plate1" => ce1ce2Plate2a, "plate2" => ce2ce1Plate2b},
    net_function = stackedMimMax);
};
drErrorStack.push_back({err, drErrGDSHash["MIM_72"], ""});

mimRatioVal = MIM_73;
err @= {
  @ GetRuleString("MIM_73");  note(CheckingString("MIM_73"));
  net_select( connect_sequence = mim72_construction_connect,
    layer_groups = { "plate1" => ce1ce2Plate2a, "plate2" => ce2ce1Plate2b},
    net_function = stackedMimMin);
};
drErrorStack.push_back({err, drErrGDSHash["MIM_73"], ""});



// triple stack construction checks
err @= {
  @ GetRuleString("MIM_81");  note(CheckingString("MIM_81"));
  ce1_uhv not_interacting ce2Floating;  
  ce2FloatUHV not_interacting ce1FloatUHV;
  ce1FloatUHV not_interacting ce2vssUHV;
}
drErrorStack.push_back({err, drErrGDSHash["MIM_81"], ""});

mim82p1_construction_connect = connect( 
   connect_items = {{ layers = {ce1ce2Plate3a, ce2ce1Plate3b}, by_layer = ce2FloatUHV}});
mim82p2_construction_connect = connect( 
   connect_items = {{ layers = {ce2ce1Plate3b, ce1ce2Plate3c}, by_layer = ce1FloatUHV}});

mimRatioVal = MIM_82;
err @= {
  @ GetRuleString("MIM_82");  note(CheckingString("MIM_82"));
  net_select( connect_sequence = mim82p1_construction_connect,
    layer_groups = { "plate1" => ce1ce2Plate3a, "plate2" => ce2ce1Plate3b},
    net_function = stackedMimMax);
  net_select( connect_sequence = mim82p2_construction_connect,
    layer_groups = { "plate1" => ce1ce2Plate3c,"plate2" => ce2ce1Plate3b}, 
    net_function = stackedMimMax);
};
drErrorStack.push_back({err, drErrGDSHash["MIM_82"], ""});

mimRatioVal = MIM_83;
err @= {
  @ GetRuleString("MIM_83");  note(CheckingString("MIM_83"));
  net_select( connect_sequence = mim82p1_construction_connect,
    layer_groups = { "plate1" => ce1ce2Plate3a, "plate2" => ce2ce1Plate3b},
    net_function = stackedMimMin);
  net_select( connect_sequence = mim82p2_construction_connect,
    layer_groups = { "plate1" => ce1ce2Plate3c, "plate2" => ce2ce1Plate3b}, 
    net_function = stackedMimMin);
};
drErrorStack.push_back({err, drErrGDSHash["MIM_83"], ""});

#ifdef _drDEBUG
drPassthruStack.push_back({ VIA9, {45, 0} });
drPassthruStack.push_back({ VIA11, {57, 0} });
drPassthruStack.push_back({ TM1, {42, 0} });
drPassthruStack.push_back({ METAL9, {46, 0} });
drPassthruStack.push_back({ METAL11, {58, 0} });
drPassthruStack.push_back({ CE1,  {91, 0} });
drPassthruStack.push_back({ CE2,  {90, 0} });
#endif //_drDEBUG

#endif //_P1273DX_MIM_RS_
