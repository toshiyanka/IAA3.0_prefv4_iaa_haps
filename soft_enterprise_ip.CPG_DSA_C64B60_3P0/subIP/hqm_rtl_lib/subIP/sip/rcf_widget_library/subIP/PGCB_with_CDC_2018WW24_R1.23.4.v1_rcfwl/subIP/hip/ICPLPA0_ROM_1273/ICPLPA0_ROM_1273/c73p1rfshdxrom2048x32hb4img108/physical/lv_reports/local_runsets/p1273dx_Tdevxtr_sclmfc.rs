// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tdevxtr_sclmfc.rs.rca 1.7 Thu Jan  8 10:35:55 2015 kperrey Experimental $ 
// $Log: p1273dx_Tdevxtr_sclmfc.rs.rca $
// 
//  Revision: 1.7 Thu Jan  8 10:35:55 2015 kperrey
//  hsd 2997; updates from Mahesh
// 
//  Revision: 1.6 Fri Nov 28 18:53:14 2014 kperrey
//  as per ivan change BULK pin to be GND ; swap order or lower / uppershield
// 
//  Revision: 1.5 Wed Sep 24 11:23:30 2014 kperrey
//  build the dcomfc devices (typeII) from the mfc2portII_m5/m4/m3
// 
//  Revision: 1.4 Mon Aug  4 09:53:09 2014 kperrey
//  hsd 2631 ; add d87smfcnvm7d2 d87xmfcnvm7d2 to equivs for mfc4portm7
// 
//  Revision: 1.3 Fri Jul 25 16:47:53 2014 kperrey
//  hsd 2588, for scaleable mfc append 2 to the name for the d87 (24 of them) and then create a d8x version (24 of them)
// 
//  Revision: 1.2 Mon Jul 21 09:29:26 2014 kperrey
//  add the _drRCextract for the pwell/pwell_ext difference
// 
//  Revision: 1.1 Thu Jul 17 11:26:29 2014 kperrey
//  device creation for the scaleable mfc 2/3/4/5 port
// 

#ifndef _P1273DX_TDEVXTR_SCLMFC_RS_
#define _P1273DX_TDEVXTR_SCLMFC_RS_



// 5 port mfc
// tm1
#if _drPROCESS == _drdotSix
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc5porttm1",
   device_body = mfc5port_tm1,
   terminal_a = mfc5port_tm1_t1m12,
   terminal_b = mfc5port_tm1_t2m12,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
	   {
#ifdef _drRCextract
  device_layer =mfc5port_ustm1,
#else
  device_layer =mfc5port_ustm1p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5porttm1", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
#else
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5porttm1",
	   device_body = mfc5port_tm1,
	   terminal_a = mfc5port_tm1_t1m9,
	   terminal_b = mfc5port_tm1_t2m9,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_ustm1,
#else
  device_layer =mfc5port_ustm1p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5porttm1", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
#endif
	// m12
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm12",
	   device_body = mfc5port_m12,
	   terminal_a = mfc5port_m12_t1m11,
	   terminal_b = mfc5port_m12_t2m11,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm12,
#else
  device_layer =mfc5port_usm12p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm12", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
	// m11
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm11",
	   device_body = mfc5port_m11,
	   terminal_a = mfc5port_m11_t1m10,
	   terminal_b = mfc5port_m11_t2m10,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm11,
#else
  device_layer =mfc5port_usm11p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm11", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
	// m10
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm10",
	   device_body = mfc5port_m10,
	   terminal_a = mfc5port_m10_t1m9,
	   terminal_b = mfc5port_m10_t2m9,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm10,
#else
  device_layer =mfc5port_usm10p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm10", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
	// m9
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm9",
	   device_body = mfc5port_m9,
	   terminal_a = mfc5port_m9_t1m8,
	   terminal_b = mfc5port_m9_t2m8,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm9,
#else
  device_layer =mfc5port_usm9p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm9", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
	// m8
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm8",
	   device_body = mfc5port_m8,
	   terminal_a = mfc5port_m8_t1m7,
	   terminal_b = mfc5port_m8_t2m7,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm8,
#else
  device_layer =mfc5port_usm8p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm8", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);

	// m7
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm7",
	   device_body = mfc5port_m7,
	   terminal_a = mfc5port_m7_t1m6,
	   terminal_b = mfc5port_m7_t2m6,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm7,
#else
  device_layer =mfc5port_usm7p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm7", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);

	// m6
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm6",
	   device_body = mfc5port_m6,
	   terminal_a = mfc5port_m6_t1m5,
	   terminal_b = mfc5port_m6_t2m5,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm6,
#else
  device_layer =mfc5port_usm6p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm6", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d87smfcnvm6a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d87xmfcnvm6a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d8xsmfcnvm6a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d8xxmfcnvm6a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);



	// m5
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm5",
	   device_body = mfc5port_m5,
	   terminal_a = mfc5port_m5_t1m4,
	   terminal_b = mfc5port_m5_t2m4,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm5,
#else
  device_layer =mfc5port_usm5p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm5", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);

	// m4
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm4",
	   device_body = mfc5port_m4,
	   terminal_a = mfc5port_m4_t1m3,
	   terminal_b = mfc5port_m4_t2m3,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   
{
#ifdef _drRCextract
  device_layer =mfc5port_usm4,
#else
  device_layer =mfc5port_usm4p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm4", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d87smfcevm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d87smfcnvm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d87smfctguvm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d87xmfcnvm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d8xsmfcevm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d8xsmfcnvm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d8xsmfctguvm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}},
		  {device_name = "d8xxmfcnvm4a2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);




	// m3
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm3",
	   device_body = mfc5port_m3,
	   terminal_a = mfc5port_m3_t1m2,
	   terminal_b = mfc5port_m3_t2m2,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm3,
#else
  device_layer =mfc5port_usm3p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm3", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);

	// m2
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm2",
	   device_body = mfc5port_m2,
	   terminal_a = mfc5port_m2_t1m1,
	   terminal_b = mfc5port_m2_t2m1,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm2,
#else
  device_layer =mfc5port_usm2p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm2", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);
	// m1
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc5portm1",
	   device_body = mfc5port_m1,
	   terminal_a = mfc5port_m1_t1m0,
	   terminal_b = mfc5port_m1_t2m0,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc5port_lspc,
#else
  device_layer =mfc5port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
#ifdef _drRCextract
  device_layer =mfc5port_usm1,
#else
  device_layer =mfc5port_usm1p,
#endif
			pin_name = "uppershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc5portm1", terminal_a = "A", terminal_b = "B", optional_pins = {"uppershield", "lowershield", "GND"}}
	   }
	);

	// 4 port mfc
	// tm1
#if _drPROCESS == _drdotSix
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4porttm1",
	   device_body = mfc4port_tm1,
	   terminal_a = mfc4port_tm1_t1m12,
	   terminal_b = mfc4port_tm1_t2tm1,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4porttm1", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
	   }
	);
#else
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4porttm1",
	   device_body = mfc4port_tm1,
	   terminal_a = mfc4port_tm1_t1m9,
	   terminal_b = mfc4port_tm1_t2tm1,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4porttm1", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
	   }
	);
#endif
	// m12
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4portm12",
	   device_body = mfc4port_m12,
	   terminal_a = mfc4port_m12_t1m11,
	   terminal_b = mfc4port_m12_t2m12,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4portm12", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
	   }
	);
	// m11
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4portm11",
	   device_body = mfc4port_m11,
	   terminal_a = mfc4port_m11_t1m10,
	   terminal_b = mfc4port_m11_t2m11,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4portm11", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
	   }
	);
	// m10
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4portm10",
	   device_body = mfc4port_m10,
	   terminal_a = mfc4port_m10_t1m9,
	   terminal_b = mfc4port_m10_t2m10,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4portm10", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
	   }
	);
	// m9
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4portm9",
	   device_body = mfc4port_m9,
	   terminal_a = mfc4port_m9_t1m8,
	   terminal_b = mfc4port_m9_t2m9,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4portm9", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
	   }
	);
	// m8
	capacitor (
	   matrix = trace_devMtrx,
	   device_name = "mfc4portm8",
	   device_body = mfc4port_m8,
	   terminal_a = mfc4port_m8_t1m7,
	   terminal_b = mfc4port_m8_t2m8,
	   optional_pins = {
		   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
			pin_name = "lowershield",
			pin_type = TERMINAL,
			pin_compared = true
		   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
	   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
	   properties = {
		   #include <sclMFC_props>
	   },
	   property_function = sclMFCCalcProps, //optional
	   merge_parallel = false, //optional
	   x_card = true,
	   schematic_devices = {
		  {device_name = "mfc4portm8", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);

// m7
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm7",
   device_body = mfc4port_m7,
   terminal_a = mfc4port_m7_t1m6,
   terminal_b = mfc4port_m7_t2m7,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "d87smfcnvm7d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87xmfcnvm7d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "mfc4portm7", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);

// m6
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm6",
   device_body = mfc4port_m6,
   terminal_a = mfc4port_m6_t1m5,
   terminal_b = mfc4port_m6_t2m6,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc4portm6", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);


// m5
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm5",
   device_body = mfc4port_m5,
   terminal_a = mfc4port_m5_t1m4,
   terminal_b = mfc4port_m5_t2m5,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc4portm5", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87xmfcnvm5d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87smfcnvm5d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d8xxmfcnvm5d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d8xsmfcnvm5d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);


// m4
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm4",
   device_body = mfc4port_m4,
   terminal_a = mfc4port_m4_t1m3,
   terminal_b = mfc4port_m4_t2m4,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc4portm4", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);

// m3
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm3",
   device_body = mfc4port_m3,
   terminal_a = mfc4port_m3_t1m2,
   terminal_b = mfc4port_m3_t2m3,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc4portm3", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87smfcevm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87smfcnvm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87smfctguvm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d87xmfcnvm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d8xsmfcevm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d8xsmfcnvm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d8xsmfctguvm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}},
      {device_name = "d8xxmfcnvm3d2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);

// m2
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm2",
   device_body = mfc4port_m2,
   terminal_a = mfc4port_m2_t1m1,
   terminal_b = mfc4port_m2_t2m2,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc4portm2", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);

// m1
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc4portm1",
   device_body = mfc4port_m1,
   terminal_a = mfc4port_m1_t1m0,
   terminal_b = mfc4port_m1_t2m1,
   optional_pins = {
	   {
#ifdef _drRCextract
  device_layer =mfc4port_lspc,
#else
  device_layer =mfc4port_lspcp,
#endif
        pin_name = "lowershield",
        pin_type = TERMINAL,
        pin_compared = true
	   },
		   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
			pin_name = "GND",
			pin_type = BULK,
			pin_compared = true
		   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc4portm1", terminal_a = "A", terminal_b = "B", optional_pins = {"lowershield", "GND"}}
   }
);


// 3 port mfc
// tm1
#if _drPROCESS == _drdotSix
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3porttm1",
   device_body = mfc3port_tm1,
   terminal_a = mfc3port_tm1_t1m12,
   terminal_b = mfc3port_tm1_t2tm1,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3porttm1", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);
#else
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3porttm1",
   device_body = mfc3port_tm1,
   terminal_a = mfc3port_tm1_t1m9,
   terminal_b = mfc3port_tm1_t2tm1,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3porttm1", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);
#endif
// m12
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm12",
   device_body = mfc3port_m12,
   terminal_a = mfc3port_m12_t1m11,
   terminal_b = mfc3port_m12_t2m12,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm12", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);
// m11
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm11",
   device_body = mfc3port_m11,
   terminal_a = mfc3port_m11_t1m10,
   terminal_b = mfc3port_m11_t2m11,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm11", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// m10
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm10",
   device_body = mfc3port_m10,
   terminal_a = mfc3port_m10_t1m9,
   terminal_b = mfc3port_m10_t2m10,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm10", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// m9
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm9",
   device_body = mfc3port_m9,
   terminal_a = mfc3port_m9_t1m8,
   terminal_b = mfc3port_m9_t2m9,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm9", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// m8
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm8",
   device_body = mfc3port_m8,
   terminal_a = mfc3port_m8_t1m7,
   terminal_b = mfc3port_m8_t2m8,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm8", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// m7
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm7",
   device_body = mfc3port_m7,
   terminal_a = mfc3port_m7_t1m6,
   terminal_b = mfc3port_m7_t2m7,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm7", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// m6
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm6",
   device_body = mfc3port_m6,
   terminal_a = mfc3port_m6_t1m5,
   terminal_b = mfc3port_m6_t2m6,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm6", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d87xmfcnvm6b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d87smfcnvm6b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d8xxmfcnvm6b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d8xsmfcnvm6b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);


// m5
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm5",
   device_body = mfc3port_m5,
   terminal_a = mfc3port_m5_t1m4,
   terminal_b = mfc3port_m5_t2m5,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm5", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);



// m4
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm4",
   device_body = mfc3port_m4,
   terminal_a = mfc3port_m4_t1m3,
   terminal_b = mfc3port_m4_t2m4,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm4", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d87smfcevm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d87smfcnvm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d87smfctguvm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d87xmfcnvm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d8xsmfcevm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d8xsmfcnvm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d8xsmfctguvm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}},
      {device_name = "d8xxmfcnvm4b2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// m3
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm3",
   device_body = mfc3port_m3,
   terminal_a = mfc3port_m3_t1m2,
   terminal_b = mfc3port_m3_t2m3,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm3", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);
// m2
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm2",
   device_body = mfc3port_m2,
   terminal_a = mfc3port_m2_t1m1,
   terminal_b = mfc3port_m2_t2m2,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm2", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);
// m1
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc3portm1",
   device_body = mfc3port_m1,
   terminal_a = mfc3port_m1_t1m0,
   terminal_b = mfc3port_m1_t2m1,
   optional_pins = {
	   {
			#if _drALLOW_DNW
               #ifndef _drRCextract  
                  device_layer = pwell,
               #else
                  device_layer = pwell_ext,
               #endif
			#else 
			   device_layer = __drsubstrate,
			#endif 
        pin_name = "GND",
        pin_type = BULK,
        pin_compared = true
	   }
   },
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc3portm1", terminal_a = "A", terminal_b = "B", optional_pins = {"GND"}}
   }
);

// 2 port mfc
// tm1
#if _drPROCESS == _drdotSix
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2porttm1",
   device_body = mfc2port_tm1,
   terminal_a = mfc2port_tm1_t1m12,
   terminal_b = mfc2port_tm1_t2tm1,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2porttm1", terminal_a = "A", terminal_b = "B"}
   }
);
#else
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2porttm1",
   device_body = mfc2port_tm1,
   terminal_a = mfc2port_tm1_t1m9,
   terminal_b = mfc2port_tm1_t2tm1,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2porttm1", terminal_a = "A", terminal_b = "B"}
   }
);
#endif
// m12
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm12",
   device_body = mfc2port_m12,
   terminal_a = mfc2port_m12_t1m11,
   terminal_b = mfc2port_m12_t2m12,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm12", terminal_a = "A", terminal_b = "B"}
   }
);
// m11
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm11",
   device_body = mfc2port_m11,
   terminal_a = mfc2port_m11_t1m10,
   terminal_b = mfc2port_m11_t2m11,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm11", terminal_a = "A", terminal_b = "B"}
   }
);

// m10
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm10",
   device_body = mfc2port_m10,
   terminal_a = mfc2port_m10_t1m9,
   terminal_b = mfc2port_m10_t2m10,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm10", terminal_a = "A", terminal_b = "B"}
   }
);

// m9
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm9",
   device_body = mfc2port_m9,
   terminal_a = mfc2port_m9_t1m8,
   terminal_b = mfc2port_m9_t2m9,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm9", terminal_a = "A", terminal_b = "B"}
   }
);

// m8
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm8",
   device_body = mfc2port_m8,
   terminal_a = mfc2port_m8_t1m7,
   terminal_b = mfc2port_m8_t2m8,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm8", terminal_a = "A", terminal_b = "B"}
   }
);

// m7
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm7",
   device_body = mfc2port_m7,
   terminal_a = mfc2port_m7_t1m6,
   terminal_b = mfc2port_m7_t2m7,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm7", terminal_a = "A", terminal_b = "B"}
   }
);

// m6
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm6",
   device_body = mfc2port_m6,
   terminal_a = mfc2port_m6_t1m5,
   terminal_b = mfc2port_m6_t2m6,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm6", terminal_a = "A", terminal_b = "B"},
      {device_name = "d87smfcnvm6c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d87xmfcnvm6c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d8xsmfcnvm6c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d8xxmfcnvm6c2", terminal_a = "A", terminal_b = "B"}
   }
);

// m5
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm5",
   device_body = mfc2port_m5,
   terminal_a = mfc2port_m5_t1m4,
   terminal_b = mfc2port_m5_t2m5,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm5", terminal_a = "A", terminal_b = "B"}
   }
);

// m4
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm4",
   device_body = mfc2port_m4,
   terminal_a = mfc2port_m4_t1m3,
   terminal_b = mfc2port_m4_t2m4,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm4", terminal_a = "A", terminal_b = "B"},
      {device_name = "d87smfcevm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d87smfcnvm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d87smfctguvm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d87xmfcnvm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d8xsmfcevm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d8xsmfcnvm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d8xsmfctguvm4c2", terminal_a = "A", terminal_b = "B"},
      {device_name = "d8xxmfcnvm4c2", terminal_a = "A", terminal_b = "B"}
   }
);
// m3
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm3",
   device_body = mfc2port_m3,
   terminal_a = mfc2port_m3_t1m2,
   terminal_b = mfc2port_m3_t2m3,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm3", terminal_a = "A", terminal_b = "B"}
   }
);
// m2
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm2",
   device_body = mfc2port_m2,
   terminal_a = mfc2port_m2_t1m1,
   terminal_b = mfc2port_m2_t2m2,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm2", terminal_a = "A", terminal_b = "B"}
   }
);
// m1
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portm1",
   device_body = mfc2port_m1,
   terminal_a = mfc2port_m1_t1m0,
   terminal_b = mfc2port_m1_t2m1,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "mfc2portm1", terminal_a = "A", terminal_b = "B"}
   }
);

// type II dcomfc devices (2port)
// m5
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portII_m5",
   device_body = mfc2portII_m5,
   terminal_a = mfc2port_m5_t1m4,
   terminal_b = mfc2port_m5_t2m5,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "dcomfc", terminal_a = "P", terminal_b = "M"}
   }
);

// m4
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portII_m4",
   device_body = mfc2portII_m4,
   terminal_a = mfc2port_m4_t1m3,
   terminal_b = mfc2port_m4_t2m4,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "dcomfc", terminal_a = "P", terminal_b = "M"}
   }
);
// m3
capacitor (
   matrix = trace_devMtrx,
   device_name = "mfc2portII_m3",
   device_body = mfc2portII_m3,
   terminal_a = mfc2port_m3_t1m2,
   terminal_b = mfc2port_m3_t2m3,
       processing_layer_hash = {
         "tm1start" => {TM1RCSTART},
         "m12start" => {MET12RCSTART},
         "m11start" => {MET11RCSTART},
         "m10start" => {MET10RCSTART},
         "m9start" => {MET9RCSTART},
         "m8start" => {MET8RCSTART},
         "m7start" => {MET7RCSTART},
         "m6start" => {MET6RCSTART},
         "m5start" => {MET5RCSTART},
         "m4start" => {MET4RCSTART},
         "m3start" => {MET3RCSTART},
         "m2start" => {MET2RCSTART},
         "m1start" => {MET1RCSTART},
         "m0start" => {MET0RCSTART},
         "tm1stop" => {TM1RCSTOP},
         "m12stop" => {MET12RCSTOP},
         "m11stop" => {MET11RCSTOP},
         "m10stop" => {MET10RCSTOP},
         "m9stop" => {MET9RCSTOP},
         "m8stop" => {MET8RCSTOP},
         "m7stop" => {MET7RCSTOP},
         "m6stop" => {MET6RCSTOP},
         "m5stop" => {MET5RCSTOP},
         "m4stop" => {MET4RCSTOP},
         "m3stop" => {MET3RCSTOP},
         "m2stop" => {MET2RCSTOP},
         "m1stop" => {MET1RCSTOP},
         "m0stop" => {MET0RCSTOP}
       },
   properties = {
		   #include <sclMFC_props>
   },
   property_function = sclMFCCalcProps, //optional
   merge_parallel = false, //optional
	   x_card = true,
   schematic_devices = {
      {device_name = "dcomfc", terminal_a = "P", terminal_b = "M"}
   }
);


#if 0
// connect the plate to the nores layer by term
// term2 (2term) 
   {layers = {mfc2port_tm1_t2tm1p, tm1nores},     by_layer = mfc2port_tm1_t2tm1},
   {layers = {mfc2port_m12_t2m12p, metal12nores}, by_layer = mfc2port_m12_t2m12},
   {layers = {mfc2port_m11_t2m11p, metal11nores}, by_layer = mfc2port_m11_t2m11},
   {layers = {mfc2port_m10_t2m10p, metal10nores}, by_layer = mfc2port_m10_t2m10},
   {layers = {mfc2port_m9_t2m9p,   metal9nores} , by_layer = mfc2port_m9_t2m9},
   {layers = {mfc2port_m8_t2m8p,   metal8nores} , by_layer = mfc2port_m8_t2m8},
   {layers = {mfc2port_m7_t2m7p,   metal7nores} , by_layer = mfc2port_m7_t2m7},
   {layers = {mfc2port_m6_t2m6p,   metal6nores} , by_layer = mfc2port_m6_t2m6},
   {layers = {mfc2port_m5_t2m5p,   metal5nores} , by_layer = mfc2port_m5_t2m5},
   {layers = {mfc2port_m4_t2m4p,   metal4nores} , by_layer = mfc2port_m4_t2m4},
   {layers = {mfc2port_m3_t2m3p,   metal3nores} , by_layer = mfc2port_m3_t2m3},
   {layers = {mfc2port_m2_t2m2p,   metal2nores} , by_layer = mfc2port_m2_t2m2},
   {layers = {mfc2port_m1_t2m1p,   metal1nores} , by_layer = mfc2port_m1_t2m1},

// term1 (2term)  
   {layers = {mfc2port_tm1_t1m12p, metal12nores}, by_layer = mfc2port_tm1_t1m12},
   {layers = {mfc2port_tm1_t1m9p,  metal9nores},  by_layer = mfc2port_tm1_t1m9},
   {layers = {mfc2port_m12_t1m11p, metal11nores}, by_layer = mfc2port_m12_t1m11},
   {layers = {mfc2port_m11_t1m10p, metal10nores}, by_layer = mfc2port_m11_t1m10},
   {layers = {mfc2port_m10_t1m9p,  metal9nores},  by_layer = mfc2port_m10_t1m9},
   {layers = {mfc2port_m9_t1m8p,   metal8nores} , by_layer = mfc2port_m9_t1m8},
   {layers = {mfc2port_m8_t1m7p,   metal7nores} , by_layer = mfc2port_m8_t1m7},
   {layers = {mfc2port_m7_t1m6p,   metal6nores} , by_layer = mfc2port_m7_t1m6},
   {layers = {mfc2port_m6_t1m5p,   metal5nores} , by_layer = mfc2port_m6_t1m5},
   {layers = {mfc2port_m5_t1m4p,   metal4nores} , by_layer = mfc2port_m5_t1m4},
   {layers = {mfc2port_m4_t1m3p,   metal3nores} , by_layer = mfc2port_m4_t1m3},
   {layers = {mfc2port_m3_t1m2p,   metal2nores} , by_layer = mfc2port_m3_t1m2},
   {layers = {mfc2port_m2_t1m1p,   metal1nores} , by_layer = mfc2port_m2_t1m1},
   {layers = {mfc2port_m1_t1m0p,   metal0nores} , by_layer = mfc2port_m1_t1m0},
   ,

   {layers = {mfc4port_tm1_t2m12p, metal12nores}, by_layer = mfc4port_tm1_t2m12},
   {layers = {mfc4port_tm1_t2m9p,  metal9nores} , by_layer = mfc4port_tm1_t2m9},
   {layers = {mfc4port_m12_t2m11p, metal11nores}, by_layer = mfc4port_m12_t2m11},
   {layers = {mfc4port_m11_t2m10p, metal10nores}, by_layer = mfc4port_m11_t2m10},
   {layers = {mfc4port_m10_t2m9p,  metal9nores} , by_layer = mfc4port_m10_t2m9},
   {layers = {mfc4port_m9_t2m8p,   metal8nores} , by_layer = mfc4port_m9_t2m8},
   {layers = {mfc4port_m8_t2m7p,   metal7nores} , by_layer = mfc4port_m8_t2m7},
   {layers = {mfc4port_m7_t2m6p,   metal6nores} , by_layer = mfc4port_m7_t2m6},
   {layers = {mfc4port_m6_t2m5p,   metal5nores} , by_layer = mfc4port_m6_t2m5},
   {layers = {mfc4port_m5_t2m4p,   metal4nores} , by_layer = mfc4port_m5_t2m4},
   {layers = {mfc4port_m4_t2m3p,   metal3nores} , by_layer = mfc4port_m4_t2m3},
   {layers = {mfc4port_m3_t2m2p,   metal2nores} , by_layer = mfc4port_m3_t2m2},
   {layers = {mfc4port_m2_t2m1p,   metal1nores} , by_layer = mfc4port_m2_t2m1},

// term1 (4term) 
   {layers = {mfc4port_tm1_t1m11p, metal11nores}, by_layer = mfc4port_tm1_t1m11},
   {layers = {mfc4port_tm1_t1m8p,  metal8nores} , by_layer = mfc4port_tm1_t1m8},
   {layers = {mfc4port_m12_t1m10p, metal10nores}, by_layer = mfc4port_m12_t1m10},
   {layers = {mfc4port_m11_t1m9p,  metal9nores} , by_layer = mfc4port_m11_t1m9},
   {layers = {mfc4port_m10_t1m8p,  metal8nores} , by_layer = mfc4port_m10_t1m8},
   {layers = {mfc4port_m9_t1m7p,   metal7nores} , by_layer = mfc4port_m9_t1m7},
   {layers = {mfc4port_m8_t1m6p,   metal6nores} , by_layer = mfc4port_m8_t1m6},
   {layers = {mfc4port_m7_t1m5p,   metal5nores} , by_layer = mfc4port_m7_t1m5},
   {layers = {mfc4port_m6_t1m4p,   metal4nores} , by_layer = mfc4port_m6_t1m4},
   {layers = {mfc4port_m5_t1m3p,   metal3nores} , by_layer = mfc4port_m5_t1m3},
   {layers = {mfc4port_m4_t1m2p,   metal2nores} , by_layer = mfc4port_m4_t1m2},
   {layers = {mfc4port_m3_t1m1p,   metal1nores} , by_layer = mfc4port_m3_t1m1},
   {layers = {mfc4port_m2_t1m0p,   metal0nores} , by_layer = mfc4port_m2_t1m0},

// term2 (3term) 
   {layers = {mfc3port_tm1_t2tm1p, tm1nores}    , by_layer = mfc3port_tm1_t2tm1},
   {layers = {mfc3port_m12_t2m12p, metal12nores}, by_layer = mfc3port_m12_t2m12},
   {layers = {mfc3port_m11_t2m11p, metal11nores}, by_layer = mfc3port_m11_t2m11},
   {layers = {mfc3port_m10_t2m10p, metal10nores}, by_layer = mfc3port_m10_t2m10},
   {layers = {mfc3port_m9_t2m9p,   metal9nores} , by_layer = mfc3port_m9_t2m9},
   {layers = {mfc3port_m8_t2m8p,   metal8nores} , by_layer = mfc3port_m8_t2m8},
   {layers = {mfc3port_m7_t2m7p,   metal7nores} , by_layer = mfc3port_m7_t2m7},
   {layers = {mfc3port_m6_t2m6p,   metal6nores} , by_layer = mfc3port_m6_t2m6},
   {layers = {mfc3port_m5_t2m5p,   metal5nores} , by_layer = mfc3port_m5_t2m5},
   {layers = {mfc3port_m4_t2m4p,   metal4nores} , by_layer = mfc3port_m4_t2m4},
   {layers = {mfc3port_m3_t2m3p,   metal3nores} , by_layer = mfc3port_m3_t2m3},
   {layers = {mfc3port_m2_t2m2p,   metal2nores} , by_layer = mfc3port_m2_t2m2},
   {layers = {mfc3port_m1_t2m1p,   metal1nores} , by_layer = mfc3port_m1_t2m1},

// term1 (3term)  
   {layers = {mfc3port_tm1_t1m12p, metal12nores}, by_layer = mfc3port_tm1_t1m12},
   {layers = {mfc3port_tm1_t1m9p , metal9nores},  by_layer = mfc3port_tm1_t1m9},
   {layers = {mfc3port_m12_t1m11p, metal11nores}, by_layer = mfc3port_m12_t1m11},
   {layers = {mfc3port_m11_t1m10p, metal10nores}, by_layer = mfc3port_m11_t1m10},
   {layers = {mfc3port_m10_t1m9p,  metal9nores} , by_layer = mfc3port_m10_t1m9},
   {layers = {mfc3port_m9_t1m8p,   metal8nores} , by_layer = mfc3port_m9_t1m8},
   {layers = {mfc3port_m8_t1m7p,   metal7nores} , by_layer = mfc3port_m8_t1m7},
   {layers = {mfc3port_m7_t1m6p,   metal6nores} , by_layer = mfc3port_m7_t1m6},
   {layers = {mfc3port_m6_t1m5p,   metal5nores} , by_layer = mfc3port_m6_t1m5},
   {layers = {mfc3port_m5_t1m4p,   metal4nores} , by_layer = mfc3port_m5_t1m4},
   {layers = {mfc3port_m4_t1m3p,   metal3nores} , by_layer = mfc3port_m4_t1m3},
   {layers = {mfc3port_m3_t1m2p,   metal2nores} , by_layer = mfc3port_m3_t1m2},
   {layers = {mfc3port_m2_t1m1p,   metal1nores} , by_layer = mfc3port_m2_t1m1},
   {layers = {mfc3port_m1_t1m0p,   metal0nores} , by_layer = mfc3port_m1_t1m0},



// us (4term) 
   {layers = {mfc4port_tm1_ustm1p, tm1nores}    , by_layer = mfc4port_tm1_ustm1},
   {layers = {mfc4port_m12_usm12p, metal12nores}, by_layer = mfc4port_m12_usm12},
   {layers = {mfc4port_m11_usm11p, metal11nores}, by_layer = mfc4port_m11_usm11},
   {layers = {mfc4port_m10_usm10p, metal10nores}, by_layer = mfc4port_m10_usm10},
   {layers = {mfc4port_m9_usm9p,   metal9nores} , by_layer = mfc4port_m9_usm9},
   {layers = {mfc4port_m8_usm8p,   metal8nores} , by_layer = mfc4port_m8_usm8},
   {layers = {mfc4port_m7_usm7p,   metal7nores} , by_layer = mfc4port_m7_usm7},
   {layers = {mfc4port_m6_usm6p,   metal6nores} , by_layer = mfc4port_m6_usm6},
   {layers = {mfc4port_m5_usm5p,   metal5nores} , by_layer = mfc4port_m5_usm5},
   {layers = {mfc4port_m4_usm4p,   metal4nores} , by_layer = mfc4port_m4_usm4},
   {layers = {mfc4port_m3_usm3p,   metal3nores} , by_layer = mfc4port_m3_usm3},
   {layers = {mfc4port_m2_usm2p,   metal2nores} , by_layer = mfc4port_m2_usm2},

// ls (4term) 
   {layers = {mfc4port_lspcp, polycon_nores}    , by_layer = mfc4port_lspc},

// ls (3term) 
   {layers = {mfc3port_lspcp, polycon_nores}    , by_layer = mfc3port_lspc}
#endif

#endif  // end _P1273DX_TDEVXTR_SCLMFC_RS_
