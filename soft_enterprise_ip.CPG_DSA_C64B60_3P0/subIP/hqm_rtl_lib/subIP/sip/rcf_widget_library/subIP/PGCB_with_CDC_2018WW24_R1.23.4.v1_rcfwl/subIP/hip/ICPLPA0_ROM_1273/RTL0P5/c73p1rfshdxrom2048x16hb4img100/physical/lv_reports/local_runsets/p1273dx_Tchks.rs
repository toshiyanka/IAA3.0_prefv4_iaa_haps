// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tchks.rs.rca 1.3 Sat Sep 27 23:32:00 2014 kperrey Experimental $

// $Log: p1273dx_Tchks.rs.rca $
// 
//  Revision: 1.3 Sat Sep 27 23:32:00 2014 kperrey
//  p1273dx_Tchks_mvsw.rs actually in 1273 subdir; fix include path
// 
//  Revision: 1.2 Thu Sep 25 22:11:24 2014 kperrey
//  include the mvsw specific checks and construction
// 
//  Revision: 1.1 Fri Sep  5 13:12:02 2014 kperrey
//  pulled out the trace based checks into their own module
// 

#ifndef _P1273DX_TCHKS_RS_
#define _P1273DX_TCHKS_RS_

// init some softcon error info
SoftConnWelltap:double = 0;
drValHash["SoftConnWelltap"] = SoftConnWelltap;
drHash["SoftConnWelltap"] = "Welltap is soft-connected to power";
drErrGDSHash[xc(SoftConnWelltap)] = { 8, 2001 };

SoftConnSubtap:double = 0;
drValHash["SoftConnSubtap"] = SoftConnSubtap;
drHash["SoftConnSubtap"] = "Subtap is soft-connected to ground";
drErrGDSHash[xc(SoftConnSubtap)] = { 1, 2001 };


// validate that all nwelltaps and subtaps connected to sd are of the same node
// want nsd psd that are interacting with gate (dummy nsd/psd are dont cares)
nsd_softcon_active = nsd interacting save_gate;
psd_softcon_active = psd interacting save_gate;
nsd_softconStamped = stamp(nsd_softcon_active, nsd, trace_soft_connect, stamped_trace_soft_connect_t1);
psd_softconStamped = stamp(psd_softcon_active, psd, stamped_trace_soft_connect_t1, stamped_trace_soft_connect_t2);
save_gate_softconStamped = stamp(save_gate, poly_nores, stamped_trace_soft_connect_t2, stamped_trace_soft_connect_t3);

// get welltaps connected to devices
softcheckWelltap = net_select(
      connect_sequence = stamped_trace_soft_connect_t3,
      layer_groups = { "layerSet1" => { npickup }}, 
      net_type = ALL,
      connected_to_any = {nsd_softconStamped, psd_softconStamped, save_gate_softconStamped,
                 vdsource, vddrain, vsdsrc,
                 anode, anode_nbjt, anode_nbjt_esd,
                 nac_cathode, nac_cathode_esd,
                 bjt_collector, bjt_emitter,
                 bjt_collector_2, bjt_emitter_2,
                 bjt_collector_1, bjt_emitter_1
      },
      output_from_layers = {npickup}
);
// add welltaps back into connectivity
softcheckWelltapStamped = stamp(softcheckWelltap, npickup, trace_soft_connect, stamped_trace_WellTapsoft_connect);
// do the check
#ifndef _drTapCheck
drSoftCheck_(xc(SoftConnWelltap), softcheckWelltapStamped, (NWELL or (NWELLESDDRAWN not WELLRES_ID)), stamped_trace_WellTapsoft_connect); 
#endif

// get subtaps connected to devices
softcheckSubtapNS = net_select(
      connect_sequence = stamped_trace_soft_connect_t3,
      layer_groups = { "layerSet1" => { ppickup }}, 
      net_type = ALL,
      connected_to_any = {nsd_softconStamped, psd_softconStamped, save_gate_softconStamped,
                 vdsource, vddrain, vsdsrc,
                 anode, anode_nbjt, anode_nbjt_esd,
                 nac_cathode, nac_cathode_esd,
                 bjt_collector, bjt_emitter,
                 bjt_collector_2, bjt_emitter_2,
                 bjt_collector_1, bjt_emitter_1
      },
      output_from_layers = {ppickup}
);
softcheckSubtapID = ppickup and DIODEID;
softcheckSubtap = softcheckSubtapNS or softcheckSubtapID;

// add welltaps back into connectivity
softcheckSubtapStamped = stamp(softcheckSubtap, ppickup, trace_soft_connect, stamped_SubTapsoft_connect);
// do the check
#ifndef _drTapCheck
drSoftCheck_(xc(SoftConnSubtap), softcheckSubtapStamped, __drsubstrate, stamped_SubTapsoft_connect); 
#endif

#ifdef _drDEBUG
drPassthruStack.push_back({softcheckSubtapStamped, {1008,200} }); // 
drPassthruStack.push_back({softcheckWelltapStamped, {1001,200} }); // 
#endif



// init error handling
Error_Std_Checks = empty_violation();
txt_std_checks:connect_database; 

#if (!defined(_drSigPlot) && !defined(_drLVSONLY))
// only do mim checks if mim ||tm1 exists
if (!layer_empty(CE1) ||  !layer_empty(CE2) || !layer_empty(TM1) ) {
#else
// force to skip mim checks when doing sigPlot or LVSONLY
if (false) {
#endif
    // init error codes
    drHash[xc(MIMCONST1)] = "CE2 can not be UHV/EHV/HV";
    drHash[xc(MIM1CONST1)] = "CE1 nomimal must interact with CE2 GND";
    drHash[xc(MIM2CONST1)] = "HV must interact with float CE2";
    drHash[xc(MIM2CONST2)] = "EHV must interact with float CE2";
    drHash[xc(MIM2CONST3)] = "Floating CE2 can not interact with both HV/EHV";
    drHash[xc(MIM2CONST4)] = "CE1GND must interact with float CE2";
    drHash[xc(MIM2CONST5)] = "float CE2 interacting with HV/EHV must interact with GND ";
    drHash[xc(MIM2CONST6)] = "floating CE2 interacting with EHV >";
    drHash[xc(MIM2CONST7)] = "floating CE2 interacting with HV >";
    drHash[xc(MIM3CONST1)] = "UHV must interact with float CE2";
    drHash[xc(MIM3CONST2)] = "floating CE2 interacting with UHV can not interact with EHV/HV";
    drHash[xc(MIM3CONST3)] = "floating CE2 interacting with UHV must interact with floating CE1"; 
    drHash[xc(MIM3CONST4)] = "floating CE1 interacting with floating CE2 must interact with CE1 GND"; 
    drHash[xc(MIM3CONST5)] = "floating CE2 interacting with UHV >";

    drErrGDSHash[xc(MIMCONST1)] = {90,1961} ;
    drErrGDSHash[xc(MIM1CONST1)] = {90,1971} ;
    drErrGDSHash[xc(MIM2CONST1)] = {90,1981} ;
    drErrGDSHash[xc(MIM2CONST2)] = {90,1982} ;
    drErrGDSHash[xc(MIM2CONST3)] = {90,1983} ;
    drErrGDSHash[xc(MIM2CONST4)] = {90,1984} ;
    drErrGDSHash[xc(MIM2CONST5)] = {90,1985} ;
    drErrGDSHash[xc(MIM2CONST6)] = {90,1986} ;
    drErrGDSHash[xc(MIM2CONST7)] = {90,1987} ;
    drErrGDSHash[xc(MIM3CONST1)] = {90,1991} ;
    drErrGDSHash[xc(MIM3CONST2)] = {90,1992} ;
    drErrGDSHash[xc(MIM3CONST3)] = {90,1993} ;
    drErrGDSHash[xc(MIM3CONST4)] = {90,1994} ;
    drErrGDSHash[xc(MIM3CONST5)] = {90,1995} ;

    drValHash[xc(MIMCONST1)] = 0;
    drValHash[xc(MIM1CONST1)] = 0;
    drValHash[xc(MIM2CONST1)] = 0;
    drValHash[xc(MIM2CONST2)] = 0;
    drValHash[xc(MIM2CONST3)] = 0;
    drValHash[xc(MIM2CONST4)] = 0;
    drValHash[xc(MIM2CONST5)] = 0;
    drValHash[xc(MIM2CONST6)] = 1;
    drValHash[xc(MIM2CONST7)] = 1;
    drValHash[xc(MIM3CONST1)] = 0;
    drValHash[xc(MIM3CONST2)] = 0;
    drValHash[xc(MIM3CONST3)] = 0;
    drValHash[xc(MIM3CONST4)] = 0;
    drValHash[xc(MIM3CONST5)] = 1;

    // edm/chn waivers from (Berni L.) 
    waiver_MIM1CONST1_ce1 = copy_by_cells(CE1, cells = {"d8xtochnce12ressmall", "d8xtochnce12reslarge", "d8xtochnv9m9"} , depth = CELL_LEVEL);
    waiver_mim61_via9 = copy_by_cells(VIA9, cells = {"d8xtochnce12ressmall", "d8xtochnce12reslarge"} , depth = CELL_LEVEL);


   // MIM_61 CE1/CE2/CE3 can not be used as res
   // this is a soft_check assume shunt in TM1 or M9
   ce1v9 = (VIA9 and CE1) not waiver_mim61_via9;
   ce1_soft_connect = connect(
      connect_items = {
         {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
         {layers = {tm1nores, metal9nores, ce1v9}, by_layer = VIA9 } }
   );
   drSoftCheck_(xc(MIM_61), ce1v9, CE1, ce1_soft_connect); 
   
   ce2v9 = (VIA9 and CE2) not waiver_mim61_via9;
   ce2_soft_connect = connect(
      connect_items = {
         {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
         {layers = {tm1nores, metal9nores, ce2v9}, by_layer = VIA9 } }
   );
   drSoftCheck_(xc(MIM_61), ce2v9, CE2, ce2_soft_connect); 
   

   //these 6 cells are all from the EDM structure; the first 4 cells above form the MIM resistor chain, and the waiver is approved by Doug Ingerly.
   //the last two cells, a80toedm1270pgdmimx0 and a80toedm1270ogdmimx0, are of the MIM capacitor chain and CE1 is not connected to VCC or XVCC; 
   // make guess as to cellname
   mim_waiver_cells:list of string = { "*", 
       //TODO: the list needs to be updated for p1273 once the names are available.
       "!c80toedm1272pgdm82x0", "!c80toedm1272pgdmbex0",
       "!c80toedm1272pgdm81x0", "!c80toedm1272pgdmtex0",
       "!c80toedm1272pgdmimx0", "!c80toedm1272ogdmimx0"
   };

   // get the ce123 geos to check 
   CE12Chk = copy_by_cells(layer1=CE1, cells= mim_waiver_cells);
   CE22Chk = copy_by_cells(layer1=CE2, cells= mim_waiver_cells);

  
   // connectivity for mim construction checks                        
   mim_construction_connect = connect(
      connect_items = {
         {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
         {layers = {tm1nores, metal9nores, CE12Chk, CE22Chk}, by_layer = VIA9 },
         {layers = {metal9nores, metal8nores}, by_layer = VIA8 } }
   );

   mim_construction_connect_txt = text_net (
      connect_sequence = mim_construction_connect,
      text_layer_items = {
         {layer = C4BEMIB, text_layer = C4BEMIB_txt},
         {layer = tm1nores, text_layer = TM1BC_txt},
         {layer = metal9nores, text_layer = METAL9BC_txt},
         {layer = metal8nores, text_layer = METAL8BC_txt}
      },
      opens = IGNORE,  
      report_errors = {}, 
      attach_text = ALL,
      rename_prefix = ""
   );

   // find floating ce1/ce2
   ce1FloatingAll = CE12Chk not_interacting VIA9;
   ce2FloatingAll = CE22Chk not_interacting VIA9;

   // get node based plates
   ce1UHV = drNetTextedWith({CE12Chk}, ultra_high_voltage_list, mim_construction_connect_txt); 
   ce1EHV = drNetTextedWith({CE12Chk}, extra_high_voltage_list, mim_construction_connect_txt); 
   ce1HV = drNetTextedWith({CE12Chk}, high_voltage_list_gt1417, mim_construction_connect_txt); 
   ce1GND = drNetTextedWith({CE12Chk}, allGround, mim_construction_connect_txt); 
   ce2GND = drNetTextedWith({CE22Chk}, allGround, mim_construction_connect_txt); 

   // get potentail 3 stack terms
   ce1UHVce2FLOAT3Stack = ce1UHV interacting ce2FloatingAll;
   ce2FLOATce1UHV3Stack = ce2FloatingAll interacting ce1UHV ;
   ce2GNDce1FLOAT3Stack = ce2GND interacting ce1FloatingAll;
   ce1FLOATce2GND3Stack = ce1FloatingAll interacting ce2GND ;
   ce1FLOATce2FLOAT3Stack = ce1FloatingAll interacting ce2FLOATce1UHV3Stack;

   // get potential 2 stack terms
   ce1HVce2FLOAT2Stack = ce1HV interacting ce2FloatingAll;
   ce2FLOATce1EHV2Stack = ce2FloatingAll interacting ce1EHV;
   ce1EHVce2FLOAT2Stack = ce1EHV interacting ce2FloatingAll;
   ce2FLOATce1HV2Stack = ce2FloatingAll interacting ce1HV;
   ce1GND2Stack = ce1GND interacting ce2FloatingAll;
   ce2FLOATce1GND2Stack = ce2FloatingAll interacting ce1GND;

   // get std cap ce2 ground ce1 non-floating and not hv/ehv/uhv 
   ce1NOM = CE12Chk not (ce1FloatingAll or ce1UHV or ce1EHV or ce1HV or ce1GND2Stack);
   ce1NOMce2GNDStd = ce1NOM interacting ce2GND;

   // basic constuction checks 2/3 stack
    // CE2 can not be UHV/EHV/HV
    drNetTextedWith_(xc(MIMCONST1), {CE22Chk}, 
        strcat(strcat(ultra_high_voltage_list,extra_high_voltage_list),high_voltage_list_gt1417), mim_construction_connect_txt); 

   // basic constuction checks 2 stack
   // HV must interact with float CE2
   drCopyToError_(xc(MIM2CONST1), (ce1HV not_interacting ce2FLOATce1HV2Stack));  
   // EHV must interact with float CE2
   drCopyToError_(xc(MIM2CONST2), (ce1EHV not_interacting ce2FLOATce1EHV2Stack)); 
   // floating ce2 cant interact with both EHV/HV
   drCopyToError_(xc(MIM2CONST3), (ce2FLOATce1EHV2Stack interacting ce1HV)); 
   drCopyToError_(xc(MIM2CONST3), (ce2FLOATce1HV2Stack interacting ce1EHV)); 
   // CE1GND must interact with float CE2
   drCopyToError_(xc(MIM2CONST4), (ce1GND not_interacting (ce2FLOATce1HV2Stack or ce2FLOATce1EHV2Stack))); 
   // float CE2 interacting with HV/EHV must interact with GND 
   drCopyToError_(xc(MIM2CONST5), ((ce2FLOATce1HV2Stack or ce2FLOATce1EHV2Stack) not_interacting ce1GND)); 
    
   // basic constuction checks 3 stack
    // UHV must interact with float CE2
    drCopyToError_(xc(MIM3CONST1), (ce1UHV interacting (CE22Chk not ce2FLOATce1UHV3Stack)));  
    // floating CE2 interacting with UHV can not interact with EHV/HV
    drCopyToError_(xc(MIM3CONST2), (ce2FLOATce1UHV3Stack interacting ce1EHV )); 
    drCopyToError_(xc(MIM3CONST2), (ce2FLOATce1UHV3Stack interacting ce1HV )); 
    // floating CE2 interacting with UHV must interact with floating CE1 
    drCopyToError_(xc(MIM3CONST3), (ce2FLOATce1UHV3Stack not_interacting ce1FLOATce2GND3Stack)); 
    // floating CE1 interacting with floating CE2 must interact with gnd CE2 
    drCopyToError_(xc(MIM3CONST4), (ce1FLOATce2FLOAT3Stack not_interacting ce2GNDce1FLOAT3Stack)); 

   // basic constuction checks std mimcap
   drCopyToError_(xc(MIM1CONST1), ((ce1NOM not_interacting ce2GND) not waiver_MIM1CONST1_ce1)); 
   

#ifdef _drDEBUG
   drPassthruStack.push_back({CE12Chk, {91,300} }); 
   drPassthruStack.push_back({CE22Chk, {90,300} }); 

   drPassthruStack.push_back({ce1FloatingAll, {91,301} }); 
   drPassthruStack.push_back({ce2FloatingAll, {90,301} }); 

   drPassthruStack.push_back({ce1UHV, {91,302} }); 
   drPassthruStack.push_back({ce1EHV, {91,303} }); 
   drPassthruStack.push_back({ce1HV, {91,304} }); 
   drPassthruStack.push_back({ce1NOM, {91,305} }); 
   drPassthruStack.push_back({ce1GND, {91,306} }); 
   drPassthruStack.push_back({ce2GND, {90,306} }); 

   drPassthruStack.push_back({ce1UHVce2FLOAT3Stack , {91,307} }); 
   drPassthruStack.push_back({ce2FLOATce1UHV3Stack , {90,308} }); 
   drPassthruStack.push_back({ce2GNDce1FLOAT3Stack , {90,309} }); 
   drPassthruStack.push_back({ce1FLOATce2GND3Stack , {91,310} }); 
   drPassthruStack.push_back({ce1FLOATce2FLOAT3Stack , {91,311} }); 

   drPassthruStack.push_back({ce1HVce2FLOAT2Stack , {91,312} }); 
   drPassthruStack.push_back({ce2FLOATce1EHV2Stack , {90,313} }); 
   drPassthruStack.push_back({ce1EHVce2FLOAT2Stack , {91,314} }); 
   drPassthruStack.push_back({ce2FLOATce1HV2Stack , {90,315} }); 
   drPassthruStack.push_back({ce1GND2Stack , {91,316} }); 
   drPassthruStack.push_back({ce2FLOATce1GND2Stack , {90,317} }); 


#endif

   // trim ce1 uhv/ehv/hv nodes their ce2 floating 
   ce1UHVtrim = ce1UHV and ce2FLOATce1UHV3Stack; 
   ce1EHVtrim = ce1EHV and ce2FLOATce1EHV2Stack;
   ce1HVtrim = ce1HV and ce2FLOATce1HV2Stack; 
   
   // connect the mim layers to their source layer
   mim_lay_connect = incremental_connect(
      connect_sequence = trace_netlist_connect,
      connect_items = {
         {layers = {ce1UHVtrim, ce1EHVtrim, ce1HVtrim}, by_layer = CE1}
      }
   );

   txt_mim_lay_connect = text_net (
   connect_sequence = mim_lay_connect,
   text_layer_items = {
      {layer = C4BEMIB, text_layer = C4BEMIB_txt},
      {layer = tm1nores, text_layer = TM1BC_txt},
      {layer = metal9nores, text_layer = METAL9BC_txt},
      {layer = metal8nores, text_layer = METAL8BC_txt}
    },
    opens = MERGE_CONNECTED,
   report_errors = {}, 
   attach_text = ALL,
   rename_prefix = "MIM_OPEN"
);

drSoftCheck_(xc(MIM2CONST6), ce1EHVtrim, ce2FLOATce1EHV2Stack, txt_mim_lay_connect); 
drSoftCheck_(xc(MIM2CONST7), ce1HVtrim, ce2FLOATce1HV2Stack, txt_mim_lay_connect); 
drSoftCheck_(xc(MIM3CONST5), ce1UHVtrim, ce2FLOATce1UHV3Stack, txt_mim_lay_connect); 


}  //if (!layer_empty(CE1) ||  !layer_empty(CE2) || !layer_empty(TM1) )

// This really needs it own text - since net_select/texted_with is dependent
// upon how opens are resolve - so this needs to be just ignore opens
// this connect just treats all opens as 1 net
txt_std_checks = text_net (
   connect_sequence = trace_netlist_connect_ported,
   text_layer_items = {
      {layer = C4BEMIB, text_layer = C4BEMIB_txt},
      {layer = tm1nores, text_layer = TM1BC_txt},
      {layer = metal9nores, text_layer = METAL9BC_txt},
      {layer = metal8nores, text_layer = METAL8BC_txt},
      {layer = metal7nores, text_layer = METAL7BC_txt},
      {layer = metal6nores, text_layer = METAL6BC_txt},
      {layer = metal5nores, text_layer = METAL5BC_txt},
      {layer = mcrnores, text_layer = MCR_txt},
      {layer = metal4nores, text_layer = METAL4BC_txt},
      {layer = metal3nores, text_layer = METAL3BC_txt},
      {layer = metal2nores, text_layer = METAL2BC_txt},
      {layer = metal1nores, text_layer = METAL1BC_txt},
      {layer = metal0nores, text_layer = METAL0BC_txt},
      {layer = polycon_nores, text_layer = POLYCON_txt},
      {layer = diffcon_nores, text_layer = DIFFCON_txt},
      {layer = psd, text_layer = PDIFF_txt},
      {layer = nsd, text_layer = NDIFF_txt},
      {layer = poly_nores, text_layer = POLY_txt},
      #ifdef _drRCextract
          {layer = gcn_tcn, text_layer = POLYCON_txt},
		  // {layer = poly_nores_nogate, text_layer = POLY_txt},
      	  {layer = p_dummy_gate_fbd, text_layer = POLY_txt},
      #endif
      {layer = nwellesd_nores, text_layer = NWELLESD_txt},
      {layer = nwell_nores, text_layer = NWELL_txt},
      {layer = cathode, text_layer = NWELL_txt}
      #if (defined(_drMSR) && (_drMSR !=0))
         , {layer = __drsubstrate, text_layer = PWELL_SUBISO_txt}
      #endif
	 #if (defined(_drRCextractUnimp)  && !defined(_drRCextractMetalFillGds) )
		,
		#include <rcext/unimp_net_text.rs>
	 #endif
      },
     #if  defined(_drRCextractUnimp) && defined(_drUnimpTxtCellLvl)
         processing_mode = CELL_LEVEL,
     #endif
      #if (!defined(_drMSR) || (_drMSR ==0))
         text_string_items = {
            #if (_drCaseSensitive == _drNO) // UPPERCASE
               {layer = __drsubstrate, text = "VSS" }
            #else
               {layer = __drsubstrate, text = "vss" }
            #endif
         },
      #endif
   opens = IGNORE,  
   report_errors = {}, 
   attach_text = ALL,
   rename_prefix = ""
);

#if _drSTDCHECKS == _dryes
osTSV = size(TSV, distance = p1272grid);
npickup_vx_98 = npickup not osTSV;
ppickup_vx_98 = ppickup not osTSV;
diffcon_nores_vx_98 = diffcon_nores not osTSV;
polycon_nores_vx_98 = polycon_nores not osTSV;
poly_nores_vx_98 = poly_nores not osTSV;
nsd_vx_98 = nsd not osTSV;
psd_vx_98 = psd not osTSV;

/*
drPassthruStack.push_back({osTSV, {217,905} });  
drPassthruStack.push_back({npickup_vx_98, {1,905} });  
drPassthruStack.push_back({ppickup_vx_98, {8,905} });  
drPassthruStack.push_back({nsd_vx_98, {1,906} });  
drPassthruStack.push_back({psd_vx_98, {8,906} });  
drPassthruStack.push_back({polycon_nores_vx_98, {6,905} });  
drPassthruStack.push_back({diffcon_nores_vx_98, {5,905} });  
drPassthruStack.push_back({poly_nores_vx_98, {2,905} });  
*/
 
trace_vx_98 = incremental_connect(
   connect_sequence = trace_soft_connect,
   connect_items = {
      {layers = {VIA0}, by_layer = metal0nores},
      {layers = {VIA1}, by_layer = metal1nores},
      {layers = {VIA2}, by_layer = metal2nores},
      {layers = {VIA3}, by_layer = metal3nores},
      // bulk __drsubstrate connections
      {layers = {npickup_vx_98}, by_layer = nwellesd_nores},
      {layers = {npickup_vx_98, djnw_cathode}, by_layer = nwell_nores },
      {layers = {ppickup, nac_anode, djnw_anode}, by_layer = __drsubstrate },
      // generic catchall for TSV - tsv will connect to any layer below M0
      {layers = {diffcon_nores_vx_98}, by_layer = diffcon_nores},
      {layers = {polycon_nores_vx_98}, by_layer = polycon_nores},
      {layers = {poly_nores_vx_98}, by_layer = poly_nores},
      {layers = {nsd_vx_98}, by_layer = nsd},
      {layers = {psd_vx_98}, by_layer = psd},
      {layers = {diffcon_nores_vx_98, polycon_nores_vx_98, poly_nores_vx_98, nsd_vx_98, psd_vx_98, npickup_vx_98, ppickup_vx_98},
            by_layer = TSV }
  }
); 

#include <p12723_metal_via_common.rs>
#include <p12723_brdgvia_on_pwr_common.rs>

nwellresistor = NWELL cutting WELLRES_ID;
esdresistor = NWELLESD cutting  WELLRES_ID;

vsspsd = net_texted_with(
  connect_sequence = txt_std_checks, 
  text = allGround, 
  output_from_layers = { psd }, 
  texted_at = HIGHEST_TEXT, 
  processing_mode = HIERARCHICAL
);


nonvsspsd = psd not vsspsd;

waive_varactor = copy_by_cells(CELLBOUNDARY, cells = varactorTemplates, depth = CELL_LEVEL);

nwell_esddiode_id =NWELL inside ESDDIODE_ID;
nwell_cut_esddiode_id = NWELL cutting ESDDIODE_ID;
nwell_all_esd_id = nwell_esddiode_id or nwell_cut_esddiode_id;

vssn = net_select(
      connect_sequence = txt_std_checks,
      layer_groups = { "layerSet1" => { nwell_nores, nwellesd_nores }}, 
      net_type = ALL,
      connected_to_all = {ppickup},
      output_from_layers = {nwell_nores, nwellesd_nores}
   );


psd_in_vssn = vssn and psd;

psd_w_ptap = net_select(
      connect_sequence = txt_std_checks,
      layer_groups = { "layerSet1" => { psd }}, 
      net_type = ALL,
      connected_to_all = {ppickup},
      output_from_layers = {psd}
   );

fo_bi = psd_in_vssn not psd_w_ptap;

fo_bi_stamp = stamp (
   layer1 = fo_bi,
   layer2 = psd,
   in_connect_sequence = txt_std_checks,
   out_connect_sequence = txt_fo_bi_connect,
   include_touch = NONE 
);

Error_Std_Checks @= {

   @ "fo_bi: Stamp assumption violation";
   fo_bi not fo_bi_stamp ; 

   @ "pinch: pinched nwell resistor has no model in process file";
   note(CheckingString("pinch"));
   psd and nwellresistor;

   @ "diode: integrated diode not tied to ground";
   note(CheckingString("diode"));
   (nonvsspsd and esdresistor) not waive_varactor;

   @ "err0: err0 - gate within esddiodewell";
   note(CheckingString("err0"));
   allgates inside nwell_all_esd_id;
   allgates cutting nwell_all_esd_id;

   @ "fbiasedcheck1: forward - biased diode shorting power and ground";
   note(CheckingString("fbiasedcheck"));
   net_texted_with(
     connect_sequence = txt_fo_bi_connect, 
     text = allPower,
     output_from_layers = { fo_bi_stamp }, 
     texted_at = HIGHEST_TEXT, 
     processing_mode = HIERARCHICAL
   );

}
// handle error definition and maintainence
drErrHash["Std_Checks"] = Error_Std_Checks;
drErrGDSHash["Std_Checks"] = {2, 2002};
drsaveGDSError(Error_Std_Checks, drErrGDSHash["Std_Checks"] );

// checks for STACKDEVTYPE usage
// all drawn gates within the STACKDEVTYPE must the be same electrical node
drHash[xc(SD_ERR)] = "All drawn gates within a STACKDEVTYPE must the be same electrical node";
drValHash[xc(SD_ERR)] = 0;
drErrGDSHash[xc(SD_ERR)] = {99,999} ;
{
   stdev_fld_poly = POLY not PRES_ID;
   stdev_fld_poly_soft_connect = connect(
   connect_items = {
	  {layers = {metal1nores, metal0nores}, by_layer = VIA0 },
	  {layers = {metal0nores, diffcon_nores}, by_layer = VIACON },
	  {layers = {metal0nores, polycon_nores}, by_layer = VIACON },
      {layers = {stdev_fld_poly,diffcon_nores}, by_layer = polycon_nores }
    }
   );
   drSoftCheck_(xc(SD_ERR), stdev_fld_poly, STACKDEVTYPE, stdev_fld_poly_soft_connect); 


}

#endif // end drSTDCHECK

// include the mvsw contstuction checks
#include <1273/p1273dx_Tchks_mvsw.rs>

#endif // _P1273DX_TCONN_RS_
