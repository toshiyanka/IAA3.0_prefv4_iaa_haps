// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_sigplot.rs.rca 1.8 Fri Sep  5 13:10:55 2014 kperrey Experimental $

// $Log: p1273dx_sigplot.rs.rca $
// 
//  Revision: 1.8 Fri Sep  5 13:10:55 2014 kperrey
//  change texted_at = TOP_OF_NET to HIGHEST_TEXT
// 
//  Revision: 1.7 Wed Mar  5 15:20:31 2014 kperrey
//  modify poly to handle gates now since poly_nores no longer has the gate in it
// 
//  Revision: 1.6 Wed Oct  2 10:00:25 2013 kperrey
//  change C4B references to C4BEMIB which is the old C4B + new smaller C4EMIB bumps
// 
//  Revision: 1.5 Mon Sep  9 12:03:11 2013 kperrey
//  add support for 1273.6 M12 / pwelltap
// 
//  Revision: 1.4 Thu May 23 14:12:10 2013 kperrey
//  for 1273.1 treat the same as 1273.4
// 
//  Revision: 1.3 Mon Dec 17 14:36:03 2012 kperrey
//  hsd 1459 ; add support for dot6/dot5 connect models
// 
//  Revision: 1.2 Fri Nov 16 11:11:25 2012 kperrey
//  removed newtype defs ; they are now in types
// 
//  Revision: 1.1 Wed Sep 28 11:14:21 2011 kperrey
//  updated for 1273 remove CE3/M10/V10/M11/V11
// 
//  Revision: 1.2 Wed Sep 28 11:08:28 2011 kperrey
//  change DIFFCON to diffcon_nores ; updated ifdef to reflect new name
// 
//  Revision: 1.1 Tue Jan 25 10:28:44 2011 kperrey
//  port of 1270 sigplot + 72 specific updates
// 
//  Originated from 1270 Rev 1.9 Fri Sep 24 13:15:17 2010 kperrey
// 

#ifndef _P1273DX_SIGPLOT_RS_
#define _P1273DX_SIGPLOT_RS_

#include <user_signal_list.rs>

// plotSignals: list of string = {
//   "ipad1_pinb", "ipad2_pinb", "ipad3_pinb", "ipad4_pinb", "ipad5_pinb",
//   "ipad6_pinb", "ipad7_pinb", "ipad8_pinb", "ipad9_pinb", "ipad10_pinb",
//   "ipad11_pinb", "ipad12_pinb", "ipad13_pinb", "ipad14_pinb", "ipad15_pinb",
//   "ipad16_pinb", "ipad17_pinb", "ipad18_pinb", "ipad19_pinb", "ipad20_pinb",
//   "ipad21_pinb", "ipad22_pinb", "ipad23_pinb", "ipad24_pinb", "ipad25_pinb",
//   "ipad26_pinb", "ipad27_pinb", "ipad28_pinb", "ipad29_pinb", "ipad30_pinb"
// };

//typeHashString2PolygonLayer: newtype hash of string to polygon_layer;

signalLayerHash:typeHashString2PolygonLayer = {
   "L25"  => C4BEMIB,
   "L24"  => tm1nores,
   "L23"  => CE2,
   "L22"  => CE1,
   #if (_drPROCESS == 6)  // m12 top
      "L21"  => metal12nores,
      "L20"  => metal11nores,
      "L19"  => metal10nores,
   #elif (_drPROCESS == 5)  // m10 top
      "L19"  => metal10nores,
   #endif
   "L18"  => metal9nores,
   "L17"  => metal8nores,
   "L16"  => metal7nores,
   "L15"  => metal6nores,
   "L14"  => metal5nores,
   "L13"  => metal4nores,
   "L12"  => metal3nores,
   "L11"  => metal2nores,
   "L10"  => metal1nores,
   "L09"  => metal0nores,
   "L08"  => polycon_nores,
   "L07"  => diffcon_nores,
   "L06"  => poly_nores,
   "L05"  => nsd,
   "L04"  => psd,
   "L03"  => npickup,
   "L02"  => ppickup,
   #if (_drPROCESS == 6)  // m12 top
      "L02.a"  => pwelltap,
   #endif
   "L01"  => nwell_nores,
   "L00"  => nwellesd_nores
};

signalLayerNameHash:typeHashString2String = {
   "L25"  => "C4BEMIB",
   "L24"  => "tm1nores",
   "L23"  => "CE2",
   "L22"  => "CE1",
   #if (_drPROCESS == 6)  // m12 top
      "L21"  => "metal12nores",
      "L20"  => "metal11nores",
      "L19"  => "metal10nores",
   #elif (_drPROCESS == 5)  // m10 top
      "L19"  => "metal10nores",
   #endif
   "L18"  => "metal9nores",
   "L17"  => "metal8nores",
   "L16"  => "metal7nores",
   "L15"  => "metal6nores",
   "L14"  => "metal5nores",
   "L13"  => "metal4nores",
   "L12"  => "metal3nores",
   "L11"  => "metal2nores",
   "L10"  => "metal1nores",
   "L09"  => "metal0nores",
   "L08"  => "polycon_nores",
   "L07"  => "diffcon_nores",
   "L06"  => "poly_nores",
   "L05"  => "nsd",
   "L04"  => "psd",
   "L03"  => "npickup",
   "L02"  => "ppickup",
   #if (_drPROCESS == 6)  
      "L02.a"  => "pwelltap",
   #endif
   "L01"  => "nwell_nores",
   "L00"  => "nwellesd_nores"
};

sigPlotNode:function (dr_textedDB:connect_database, dr_signal:string, gds_type:integer) returning void {
   
   // foreach layer extract the requested node
   foreach (layerkey in signalLayerHash.keys()) {
      note("\n\tINFO:  Processing Layer: " + signalLayerNameHash[layerkey] + " for signal " + dr_signal + "\n"); 
      vSignal = empty_layer();
      signal_polygon = net_select( 
         connect_sequence = dr_textedDB, 
         texted_with = { dr_signal }, 
         output_from_layers   = { signalLayerHash[layerkey] },
         texted_at = HIGHEST_TEXT,
         net_type = TEXTED
      );

      // need to get via for routing layer
      // C4BEMIB and TV1 
      if (layerkey == "L25") {
         vSignal = signal_polygon and TV1; 
         drPassthruStack.push_back({signal_polygon, {92,gds_type}});
         drPassthruStack.push_back({vSignal, {80,gds_type}});
      }
      #if (_drPROCESS == 4 || _drPROCESS == 1)  // m9 top
         // TM1 and VIA9 
         elseif (layerkey == "L24") {
            vSignal = signal_polygon and VIA9; 
            drPassthruStack.push_back({signal_polygon, {42,gds_type}});
            drPassthruStack.push_back({vSignal, {45,gds_type}});
         }
         // CE2 and VIA9 
         elseif (layerkey == "L23") {
            vSignal = signal_polygon and VIA9; 
            drPassthruStack.push_back({signal_polygon, {90,gds_type}});
            drPassthruStack.push_back({vSignal, {45,gds_type}});
         }
         // CE1 and VIA9 
         elseif (layerkey == "L22") {
            vSignal = signal_polygon and VIA9; 
            drPassthruStack.push_back({signal_polygon, {91,gds_type}});
            drPassthruStack.push_back({vSignal, {45,gds_type}});
         }
      #elif (_drPROCESS == 5) // m10 top
         // TM1 and VIA10 
         elseif (layerkey == "L24") {
            vSignal = signal_polygon and VIA10; 
            drPassthruStack.push_back({signal_polygon, {42,gds_type}});
            drPassthruStack.push_back({vSignal, {53,gds_type}});
         }
         // CE2 and VIA10 
         elseif (layerkey == "L23") {
            vSignal = signal_polygon and VIA10; 
            drPassthruStack.push_back({signal_polygon, {90,gds_type}});
            drPassthruStack.push_back({vSignal, {53,gds_type}});
         }
         // CE1 and VIA10 
         elseif (layerkey == "L22") {
            vSignal = signal_polygon and VIA10; 
            drPassthruStack.push_back({signal_polygon, {91,gds_type}});
            drPassthruStack.push_back({vSignal, {53,gds_type}});
         }
         // METAL10 and VIA9 
         elseif (layerkey == "L19") {
            vSignal = signal_polygon and VIA9; 
            drPassthruStack.push_back({signal_polygon, {46,gds_type}});
            drPassthruStack.push_back({vSignal, {45,gds_type}});
         }
      #else  // m12 top
         // TM1 and VIA12 
         elseif (layerkey == "L24") {
            vSignal = signal_polygon and VIA12; 
            drPassthruStack.push_back({signal_polygon, {42,gds_type}});
            drPassthruStack.push_back({vSignal, {61,gds_type}});
         }
         // CE2 and VIA12 
         elseif (layerkey == "L23") {
            vSignal = signal_polygon and VIA12; 
            drPassthruStack.push_back({signal_polygon, {90,gds_type}});
            drPassthruStack.push_back({vSignal, {61,gds_type}});
         }
         // CE1 and VIA12 
         elseif (layerkey == "L22") {
            vSignal = signal_polygon and VIA12; 
            drPassthruStack.push_back({signal_polygon, {91,gds_type}});
            drPassthruStack.push_back({vSignal, {61,gds_type}});
         }
         // METAL12 and VIA11 
         elseif (layerkey == "L21") {
            vSignal = signal_polygon and VIA11; 
            drPassthruStack.push_back({signal_polygon, {62,gds_type}});
            drPassthruStack.push_back({vSignal, {57,gds_type}});
         }
         // METAL11 and VIA10 
         elseif (layerkey == "L20") {
            vSignal = signal_polygon and VIA10; 
            drPassthruStack.push_back({signal_polygon, {58,gds_type}});
            drPassthruStack.push_back({vSignal, {53,gds_type}});
         }
         // METAL10 and VIA9 
         elseif (layerkey == "L19") {
            vSignal = signal_polygon and VIA9; 
            drPassthruStack.push_back({signal_polygon, {46,gds_type}});
            drPassthruStack.push_back({vSignal, {45,gds_type}});
         }
      #endif
      // METAL9 and VIA8 
      elseif (layerkey == "L18") {
         vSignal = signal_polygon and VIA8; 
         drPassthruStack.push_back({signal_polygon, {46,gds_type}});
         drPassthruStack.push_back({vSignal, {41,gds_type}});
      }
      // METAL8 and VIA7 
      elseif (layerkey == "L17") {
         vSignal = signal_polygon and VIA7; 
         drPassthruStack.push_back({signal_polygon, {38,gds_type}});
         drPassthruStack.push_back({vSignal, {37,gds_type}});
      }
      // METAL7 and VIA6 
      elseif (layerkey == "L16") {
         vSignal = signal_polygon and VIA6; 
         drPassthruStack.push_back({signal_polygon, {34,gds_type}});
         drPassthruStack.push_back({vSignal, {33,gds_type}});
      }
      // METAL6 and VIA5 
      elseif (layerkey == "L15") {
         vSignal = signal_polygon and VIA5; 
         drPassthruStack.push_back({signal_polygon, {30,gds_type}});
         drPassthruStack.push_back({vSignal, {29,gds_type}});
      }
      // METAL5 and VIA4 
      elseif (layerkey == "L14") {
         vSignal = signal_polygon and VIA4; 
         drPassthruStack.push_back({signal_polygon, {26,gds_type}});
         drPassthruStack.push_back({vSignal, {25,gds_type}});
      }
      // METAL4 and VIA3 
      elseif (layerkey == "L13") {
         vSignal = signal_polygon and VIA3; 
         drPassthruStack.push_back({signal_polygon, {22,gds_type}});
         drPassthruStack.push_back({vSignal, {21,gds_type}});
      }
      // METAL3 and VIA2 
      elseif (layerkey == "L12") {
         vSignal = signal_polygon and VIA2; 
         drPassthruStack.push_back({signal_polygon, {18,gds_type}});
         drPassthruStack.push_back({vSignal, {17,gds_type}});
      }
      // METAL2 and VIA1 
      elseif (layerkey == "L11") {
         vSignal = signal_polygon and VIA1; 
         drPassthruStack.push_back({signal_polygon, {14,gds_type}});
         drPassthruStack.push_back({vSignal, {13,gds_type}});
      }
      // METAL1 and VIA0 
      elseif (layerkey == "L10") {
         vSignal = signal_polygon and VIA0; 
         drPassthruStack.push_back({signal_polygon, {4,gds_type}});
         drPassthruStack.push_back({vSignal, {56,gds_type}});
      }
      // METAL0 and VIACON 
      elseif (layerkey == "L09") {
         vSignal = signal_polygon and VIACON; 
         drPassthruStack.push_back({signal_polygon, {55,gds_type}});
         drPassthruStack.push_back({vSignal, {3,gds_type}});
      }
      // POLYCON
      elseif (layerkey == "L08") {
         drPassthruStack.push_back({signal_polygon, {6,gds_type}});
      }
      // DIFFCON
      elseif (layerkey == "L07") {
         drPassthruStack.push_back({signal_polygon, {5,gds_type}});
      }
      // POLY
      elseif (layerkey == "L06") {
         // get the gate poly since poly_nores no longer has the gates
         gSignal = all_gate interacting signal_polygon;  
         drPassthruStack.push_back({signal_polygon, {2,gds_type}});
         drPassthruStack.push_back({gSignal, {2,gds_type}});
      }
      // NDIFF(nsd)
      elseif (layerkey == "L05") {
         drPassthruStack.push_back({signal_polygon, {1,gds_type}});
      }
      // PDIFF(psd)
      elseif (layerkey == "L04") {
         drPassthruStack.push_back({signal_polygon, {8,gds_type}});
      }
      // NDIFF(npickup)
      elseif (layerkey == "L03") {
         drPassthruStack.push_back({signal_polygon, {1,gds_type}});
      }
      // PDIFF(ppickup)
      elseif (layerkey == "L02") {
         drPassthruStack.push_back({signal_polygon, {8,gds_type}});
      }
      #if (_drPROCESS == 6)  
         // PDIFF(pwelltap)
         elseif (layerkey == "L02.a") {
            drPassthruStack.push_back({signal_polygon, {8,gds_type}});
         }
      #endif
      // NWELL
      elseif (layerkey == "L01") {
         drPassthruStack.push_back({signal_polygon, {11,gds_type}});
      }
      // NWELLESD
      elseif (layerkey == "L00") {
         drPassthruStack.push_back({signal_polygon, {19,gds_type}});
      }
   }
};

gdsOutType = 1;
foreach (signal2plot in plotSignals) {
   note("\nINFO:  Extracting signal: " + signal2plot + " on gdsType: " + gdsOutType + ".\n"); 
   sigPlotNode(txt_trace_netlist_connect, signal2plot, gdsOutType);
   gdsOutType = gdsOutType+1; 
};


#endif

