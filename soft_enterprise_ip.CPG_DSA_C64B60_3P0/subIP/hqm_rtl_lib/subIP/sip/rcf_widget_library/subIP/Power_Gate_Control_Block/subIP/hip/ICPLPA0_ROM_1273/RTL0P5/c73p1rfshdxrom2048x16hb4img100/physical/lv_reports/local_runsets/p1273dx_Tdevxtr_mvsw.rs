// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tdevxtr_mvsw.rs.rca 1.6 Fri Sep 26 14:43:23 2014 kperrey Experimental $

// $Log: p1273dx_Tdevxtr_mvsw.rs.rca $
// 
//  Revision: 1.6 Fri Sep 26 14:43:23 2014 kperrey
//  change simulation name for the aliasd devices; add metal info to name
// 
//  Revision: 1.5 Fri Sep  5 16:00:21 2014 kperrey
//  remove the scvx and the sovx devices (layer agnostic via switches
// 
//  Revision: 1.4 Fri Sep  5 13:31:02 2014 kperrey
//  added new function genSwtch2TermProps ; all the switches will get parsrc = 1 property
// 
//  Revision: 1.3 Fri Aug 22 14:50:08 2014 kperrey
//  add x_card = true for all sc*/so*/aliasd devices; change terms to PLUS and MINUS
// 
//  Revision: 1.2 Wed Aug 20 11:32:31 2014 kperrey
//  change schematic terminal names aliasd/aliasv to MINUS/PLUS and sov/scv/som/scm to PLUS/MINUS ; removed swappable_pins since a/b swappable by default ; for sc*/alias* devices make resistor_value .0001 and so* devices 10000 (this should be cosmetic only since nothing should be using these).
// 
//  Revision: 1.1 Sat Aug 16 12:26:25 2014 kperrey
//  support for the som/scm/scv/sov/aliasd switch devices for icv
// 

#ifndef _P1273DX_TDEVXTR_MVRES_RS_
#define _P1273DX_TDEVXTR_MVRES_RS_

genSwtch2TermProps:function (void) returning void {
    resWidth = (res_width_term_a() + res_width_term_b()) / 2.0 ;
    resLength =  (res_area()) / resWidth ;
    dev_save_double_properties({{"w", resWidth}});
    dev_save_double_properties({{"l", resLength}});
    dev_save_double_properties({{"parsrc", 1.0}});
};




// M0 
// scm0
resistor (
   matrix = trace_devMtrx,
   device_name = "scm0", 
   simulation_model_name = "scm0", 
   device_body = m0scm,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm0", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-0
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx0", 
   simulation_model_name = "scmx0", 
   device_body = m0scmx,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som0
resistor (
   matrix = trace_devMtrx,
   device_name = "som0", 
   simulation_model_name = "som0", 
   device_body = m0som,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som0", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-0
resistor (
   matrix = trace_devMtrx,
   device_name = "somx0", 
   simulation_model_name = "somx0", 
   device_body = m0somx,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-0
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm0", 
   device_body = m0aliasd,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);

// M1 
// scm1
resistor (
   matrix = trace_devMtrx,
   device_name = "scm1",
   simulation_model_name = "scm1",
   device_body = m1scm,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm1", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-1
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx1", 
   simulation_model_name = "scmx1", 
   device_body = m1scmx,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som1
resistor (
   matrix = trace_devMtrx,
   device_name = "som1", 
   simulation_model_name = "som1", 
   device_body = m1som,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som1", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-1
resistor (
   matrix = trace_devMtrx,
   device_name = "somx1", 
   simulation_model_name = "somx1", 
   device_body = m1somx,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-1
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm1", 
   device_body = m1aliasd,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);


// M2 
// scm2
resistor (
   matrix = trace_devMtrx,
   device_name = "scm2",
   simulation_model_name = "scm2",
   device_body = m2scm,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm2", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-2
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx2", 
   simulation_model_name = "scmx2", 
   device_body = m2scmx,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som2
resistor (
   matrix = trace_devMtrx,
   device_name = "som2", 
   simulation_model_name = "som2", 
   device_body = m2som,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som2", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-2
resistor (
   matrix = trace_devMtrx,
   device_name = "somx2", 
   simulation_model_name = "somx2", 
   device_body = m2somx,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-2
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm2", 
   device_body = m2aliasd,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);



// M3 
// scm3
resistor (
   matrix = trace_devMtrx,
   device_name = "scm3",
   simulation_model_name = "scm3",
   device_body = m3scm,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm3", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-3
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx3", 
   simulation_model_name = "scmx3", 
   device_body = m3scmx,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som3
resistor (
   matrix = trace_devMtrx,
   device_name = "som3", 
   simulation_model_name = "som3", 
   device_body = m3som,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som3", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-3
resistor (
   matrix = trace_devMtrx,
   device_name = "somx3", 
   simulation_model_name = "somx3", 
   device_body = m3somx,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-3
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm3", 
   device_body = m3aliasd,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);


// M4 
// scm4
resistor (
   matrix = trace_devMtrx,
   device_name = "scm4",
   simulation_model_name = "scm4",
   device_body = m4scm,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm4", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-4
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx4", 
   simulation_model_name = "scmx4", 
   device_body = m4scmx,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som4
resistor (
   matrix = trace_devMtrx,
   device_name = "som4", 
   simulation_model_name = "som4", 
   device_body = m4som,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som4", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-4
resistor (
   matrix = trace_devMtrx,
   device_name = "somx4", 
   simulation_model_name = "somx4", 
   device_body = m4somx,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-4
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm4", 
   device_body = m4aliasd,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);


// M5 
// scm5
resistor (
   matrix = trace_devMtrx,
   device_name = "scm5",
   simulation_model_name = "scm5",
   device_body = m5scm,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm5", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-5
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx5", 
   simulation_model_name = "scmx5", 
   device_body = m5scmx,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som5
resistor (
   matrix = trace_devMtrx,
   device_name = "som5", 
   simulation_model_name = "som5", 
   device_body = m5som,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som5", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-5
resistor (
   matrix = trace_devMtrx,
   device_name = "somx5", 
   simulation_model_name = "somx5", 
   device_body = m5somx,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-5
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm5", 
   device_body = m5aliasd,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);


// M6 
// scm6
resistor (
   matrix = trace_devMtrx,
   device_name = "scm6",
   simulation_model_name = "scm6",
   device_body = m6scm,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm6", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-6
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx6", 
   simulation_model_name = "scmx6", 
   device_body = m6scmx,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som6
resistor (
   matrix = trace_devMtrx,
   device_name = "som6", 
   simulation_model_name = "som6", 
   device_body = m6som,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som6", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-6
resistor (
   matrix = trace_devMtrx,
   device_name = "somx6", 
   simulation_model_name = "somx6", 
   device_body = m6somx,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-6
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm6", 
   device_body = m6aliasd,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);


// M7 
// scm7
resistor (
   matrix = trace_devMtrx,
   device_name = "scm7",
   simulation_model_name = "scm7",
   device_body = m7scm,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
       {device_name = "scm7", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-7
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx7", 
   simulation_model_name = "scmx7", 
   device_body = m7scmx,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som7
resistor (
   matrix = trace_devMtrx,
   device_name = "som7", 
   simulation_model_name = "som7", 
   device_body = m7som,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som7", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-7
resistor (
   matrix = trace_devMtrx,
   device_name = "somx7", 
   simulation_model_name = "somx7", 
   device_body = m7somx,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-7
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm7", 
   device_body = m7aliasd,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);


// M8 
// scm8
resistor (
   matrix = trace_devMtrx,
   device_name = "scm8",
   simulation_model_name = "scm8",
   device_body = m8scm,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scm8", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// scmx-8
resistor (
   matrix = trace_devMtrx,
   device_name = "scmx8", 
   simulation_model_name = "scmx8", 
   device_body = m8scmx,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);
// som8
resistor (
   matrix = trace_devMtrx,
   device_name = "som8", 
   simulation_model_name = "som8", 
   device_body = m8som,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "som8", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// somx-8
resistor (
   matrix = trace_devMtrx,
   device_name = "somx8", 
   simulation_model_name = "somx8", 
   device_body = m8somx,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// aliasmx-8
resistor (
   matrix = trace_devMtrx,
   device_name = "aliasd", 
   simulation_model_name = "aliasdm8", 
   device_body = m8aliasd,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8ALTSWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
      {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 0.0001 //optional
);




#if _drPROCESS == 6
   // M9 
   // scm9
   resistor (
      matrix = trace_devMtrx,
      device_name = "scm9",
      simulation_model_name = "scm9",
      device_body = m9scm,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scm9", terminal_a = "PLUS", terminal_b = "MINUS"}
         },
      resistor_value = 0.0001 //optional
   );
  // scmx-9
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmx9", 
      simulation_model_name = "scmx9", 
      device_body = m9scmx,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // som9
   resistor (
      matrix = trace_devMtrx,
      device_name = "som9", 
      simulation_model_name = "som9", 
      device_body = m9som,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "som9", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-9
   resistor (
      matrix = trace_devMtrx,
      device_name = "somx9", 
      simulation_model_name = "somx9", 
      device_body = m9somx,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );

   // aliasmx-9
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdm9", 
      device_body = m9aliasd,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


   // M10 
   // scm10
   resistor (
      matrix = trace_devMtrx,
      device_name = "scm10",
      simulation_model_name = "scm10",
      device_body = m10scm,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scm10", terminal_a = "PLUS", terminal_b = "MINUS"}
         },
      resistor_value = 0.0001 //optional
   );
   // scmx-10
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmx10", 
      simulation_model_name = "scmx10", 
      device_body = m10scmx,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // som10
   resistor (
      matrix = trace_devMtrx,
      device_name = "som10", 
      simulation_model_name = "som10", 
      device_body = m10som,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "som10", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-10
   resistor (
      matrix = trace_devMtrx,
      device_name = "somx10", 
      simulation_model_name = "somx10", 
      device_body = m10somx,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // aliasmx-10
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdm10", 
      device_body = m10aliasd,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


   // M11 
   // scm11
   resistor (
      matrix = trace_devMtrx,
      device_name = "scm11",
      simulation_model_name = "scm11",
      device_body = m11scm,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scm11", terminal_a = "PLUS", terminal_b = "MINUS"}
         },
      resistor_value = 0.0001 //optional
   );
   // scmx-11
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmx11", 
      simulation_model_name = "scmx11", 
      device_body = m11scmx,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // som11
   resistor (
      matrix = trace_devMtrx,
      device_name = "som11", 
      simulation_model_name = "som11", 
      device_body = m11som,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "som11", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-11
   resistor (
      matrix = trace_devMtrx,
      device_name = "somx11", 
      simulation_model_name = "somx11", 
      device_body = m11somx,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // aliasmx-11
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdm11", 
      device_body = m11aliasd,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


   // M12 
   // scm12
   resistor (
      matrix = trace_devMtrx,
      device_name = "scm12",
      simulation_model_name = "scm12",
      device_body = m12scm,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scm12", terminal_a = "PLUS", terminal_b = "MINUS"}
         },
      resistor_value = 0.0001 //optional
   );
   // scmx-12
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmx12", 
      simulation_model_name = "scmx12", 
      device_body = m12scmx,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // som12
   resistor (
      matrix = trace_devMtrx,
      device_name = "som12", 
      simulation_model_name = "som12", 
      device_body = m12som,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "som12", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-12
   resistor (
      matrix = trace_devMtrx,
      device_name = "somx12", 
      simulation_model_name = "somx12", 
      device_body = m12somx,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // aliasmx-12
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdm12", 
      device_body = m12aliasd,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


   // TM1 
   // scmtm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmtm1",
      simulation_model_name = "scmtm1",
      device_body = tm1scm,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmtm1", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // scmx-tm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmxtm1", 
      simulation_model_name = "scmxtm1", 
      device_body = tm1scmx,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // somtm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "somtm1", 
      simulation_model_name = "somtm1", 
      device_body = tm1som,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somtm1", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-tm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "somxtm1", 
      simulation_model_name = "somxtm1", 
      device_body = tm1somx,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // aliasmx-tm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdtm1", 
      device_body = tm1aliasd,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


#else  // dot1
   // M9 
   // scm9
   resistor (
      matrix = trace_devMtrx,
      device_name = "scm9",
      simulation_model_name = "scm9",
      device_body = m9scm,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scm9", terminal_a = "PLUS", terminal_b = "MINUS"}
         },
      resistor_value = 0.0001 //optional
   );
   // scmx-9
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmx9", 
      simulation_model_name = "scmx9", 
      device_body = m9scmx,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // som9
   resistor (
      matrix = trace_devMtrx,
      device_name = "som9", 
      simulation_model_name = "som9", 
      device_body = m9som,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "som9", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-9
   resistor (
      matrix = trace_devMtrx,
      device_name = "somx9", 
      simulation_model_name = "somx9", 
      device_body = m9somx,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // aliasmx-9
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdm9", 
      device_body = m9aliasd,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


   // TM1 
   // scmtm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmtm1",
      simulation_model_name = "scmtm1",
      device_body = tm1scm,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmtm1", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // scmx-tm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "scmxtm1", 
      simulation_model_name = "scmxtm1", 
      device_body = tm1scmx,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "scmx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );
   // somtm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "somtm1", 
      simulation_model_name = "somtm1", 
      device_body = tm1som,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1SWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somtm1", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // somx-tm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "somxtm1", 
      simulation_model_name = "somxtm1", 
      device_body = tm1somx,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "somx", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 10000.0 //optional
   );
   // aliasmx-tm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "aliasd", 
      simulation_model_name = "aliasdtm1", 
      device_body = tm1aliasd,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1ALTSWITCHID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO},
        {name = "parsrc", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genSwtch2TermProps, //optional
      merge_parallel = false, //optional
      // swappable_pins = {{"A", "B"}},
	  x_card = true,
      schematic_devices = {
         {device_name = "aliasd", terminal_a = "PLUS", terminal_b = "MINUS"},
         {device_name = "aliasv", terminal_a = "PLUS", terminal_b = "MINUS"}
      },
      resistor_value = 0.0001 //optional
   );


#endif

// do the scv/sov  via resistors
// V0 
// scv0
resistor (
   matrix = trace_devMtrx,
   device_name = "scv0", 
   simulation_model_name = "scv0", 
   device_body = v0scv,
   terminal_a = metal0nores,
   terminal_b = metal1nores,
   reference_layer = VIA0SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv0", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-0
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx0", 
   //simulation_model_name = "scvx0", 
   //device_body = v0scvx,
   //terminal_a = metal0nores,
   //terminal_b = metal1nores,
   //reference_layer = VIA0ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov0
resistor (
   matrix = trace_devMtrx,
   device_name = "sov0", 
   simulation_model_name = "sov0", 
   device_body = v0sov,
   terminal_a = metal0nores,
   terminal_b = metal1nores,
   reference_layer = VIA0SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov0", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-0
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx0", 
   //simulation_model_name = "sovx0", 
   //device_body = v0sovx,
   //terminal_a = metal0nores,
   //terminal_b = metal1nores,
   //reference_layer = VIA0ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V1 
// scv1
resistor (
   matrix = trace_devMtrx,
   device_name = "scv1", 
   simulation_model_name = "scv1", 
   device_body = v1scv,
   terminal_a = metal1nores,
   terminal_b = metal2nores,
   reference_layer = VIA1SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv1", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-1
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx1", 
   //simulation_model_name = "scvx1", 
   //device_body = v1scvx,
   //terminal_a = metal1nores,
   //terminal_b = metal2nores,
   //reference_layer = VIA1ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov1
resistor (
   matrix = trace_devMtrx,
   device_name = "sov1", 
   simulation_model_name = "sov1", 
   device_body = v1sov,
   terminal_a = metal1nores,
   terminal_b = metal2nores,
   reference_layer = VIA1SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov1", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-1
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx1", 
   //simulation_model_name = "sovx1", 
   //device_body = v1sovx,
   //terminal_a = metal1nores,
   //terminal_b = metal2nores,
   //reference_layer = VIA1ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V2 
// scv2
resistor (
   matrix = trace_devMtrx,
   device_name = "scv2", 
   simulation_model_name = "scv2", 
   device_body = v2scv,
   terminal_a = metal2nores,
   terminal_b = metal3nores,
   reference_layer = VIA2SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv2", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-2
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx2", 
   //simulation_model_name = "scvx2", 
   //device_body = v2scvx,
   //terminal_a = metal2nores,
   //terminal_b = metal3nores,
   //reference_layer = VIA2ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov2
resistor (
   matrix = trace_devMtrx,
   device_name = "sov2", 
   simulation_model_name = "sov2", 
   device_body = v2sov,
   terminal_a = metal2nores,
   terminal_b = metal3nores,
   reference_layer = VIA2SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov2", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
//// sovx-2
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx2", 
   //simulation_model_name = "sovx2", 
   //device_body = v2sovx,
   //terminal_a = metal2nores,
   //terminal_b = metal3nores,
   //reference_layer = VIA2ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V3 
// scv3
resistor (
   matrix = trace_devMtrx,
   device_name = "scv3", 
   simulation_model_name = "scv3", 
   device_body = v3scv,
   terminal_a = metal3nores,
   terminal_b = metal4nores,
   reference_layer = VIA3SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv3", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-3
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx3", 
   //simulation_model_name = "scvx3", 
   //device_body = v3scvx,
   //terminal_a = metal3nores,
   //terminal_b = metal4nores,
   //reference_layer = VIA3ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov3
resistor (
   matrix = trace_devMtrx,
   device_name = "sov3", 
   simulation_model_name = "sov3", 
   device_body = v3sov,
   terminal_a = metal3nores,
   terminal_b = metal4nores,
   reference_layer = VIA3SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov3", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-3
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx3", 
   //simulation_model_name = "sovx3", 
   //device_body = v3sovx,
   //terminal_a = metal3nores,
   //terminal_b = metal4nores,
   //reference_layer = VIA3ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V4 
// scv4
resistor (
   matrix = trace_devMtrx,
   device_name = "scv4", 
   simulation_model_name = "scv4", 
   device_body = v4scv,
   terminal_a = metal4nores,
   terminal_b = metal5nores,
   reference_layer = VIA4SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv4", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-4
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx4", 
   //simulation_model_name = "scvx4", 
   //device_body = v4scvx,
   //terminal_a = metal4nores,
   //terminal_b = metal5nores,
   //reference_layer = VIA4ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov4
resistor (
   matrix = trace_devMtrx,
   device_name = "sov4", 
   simulation_model_name = "sov4", 
   device_body = v4sov,
   terminal_a = metal4nores,
   terminal_b = metal5nores,
   reference_layer = VIA4SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov4", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-4
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx4", 
   //simulation_model_name = "sovx4", 
   //device_body = v4sovx,
   //terminal_a = metal4nores,
   //terminal_b = metal5nores,
   //reference_layer = VIA4ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V5 
// scv5
resistor (
   matrix = trace_devMtrx,
   device_name = "scv5", 
   simulation_model_name = "scv5", 
   device_body = v5scv,
   terminal_a = metal5nores,
   terminal_b = metal6nores,
   reference_layer = VIA5SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv5", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-5
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx5", 
   //simulation_model_name = "scvx5", 
   //device_body = v5scvx,
   //terminal_a = metal5nores,
   //terminal_b = metal6nores,
   //reference_layer = VIA5ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov5
resistor (
   matrix = trace_devMtrx,
   device_name = "sov5", 
   simulation_model_name = "sov5", 
   device_body = v5sov,
   terminal_a = metal5nores,
   terminal_b = metal6nores,
   reference_layer = VIA5SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov5", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-5
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx5", 
   //simulation_model_name = "sovx5", 
   //device_body = v5sovx,
   //terminal_a = metal5nores,
   //terminal_b = metal6nores,
   //reference_layer = VIA5ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V6 
// scv6
resistor (
   matrix = trace_devMtrx,
   device_name = "scv6", 
   simulation_model_name = "scv6", 
   device_body = v6scv,
   terminal_a = metal6nores,
   terminal_b = metal7nores,
   reference_layer = VIA6SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv6", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-6
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx6", 
   //simulation_model_name = "scvx6", 
   //device_body = v6scvx,
   //terminal_a = metal6nores,
   //terminal_b = metal7nores,
   //reference_layer = VIA6ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   //// swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov6
resistor (
   matrix = trace_devMtrx,
   device_name = "sov6", 
   simulation_model_name = "sov6", 
   device_body = v6sov,
   terminal_a = metal6nores,
   terminal_b = metal7nores,
   reference_layer = VIA6SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov6", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-6
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx6", 
   //simulation_model_name = "sovx6", 
   //device_body = v6sovx,
   //terminal_a = metal6nores,
   //terminal_b = metal7nores,
   //reference_layer = VIA6ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V7 
// scv7
resistor (
   matrix = trace_devMtrx,
   device_name = "scv7", 
   simulation_model_name = "scv7", 
   device_body = v7scv,
   terminal_a = metal7nores,
   terminal_b = metal8nores,
   reference_layer = VIA7SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv7", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-7
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx7", 
   //simulation_model_name = "scvx7", 
   //device_body = v7scvx,
   //terminal_a = metal7nores,
   //terminal_b = metal8nores,
   //reference_layer = VIA7ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   //// swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov7
resistor (
   matrix = trace_devMtrx,
   device_name = "sov7", 
   simulation_model_name = "sov7", 
   device_body = v7sov,
   terminal_a = metal7nores,
   terminal_b = metal8nores,
   reference_layer = VIA7SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov7", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-7
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx7", 
   //simulation_model_name = "sovx7", 
   //device_body = v7sovx,
   //terminal_a = metal7nores,
   //terminal_b = metal8nores,
   //reference_layer = VIA7ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V8 
// scv8
resistor (
   matrix = trace_devMtrx,
   device_name = "scv8", 
   simulation_model_name = "scv8", 
   device_body = v8scv,
   terminal_a = metal8nores,
   terminal_b = metal9nores,
   reference_layer = VIA8SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv8", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-8
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx8", 
   //simulation_model_name = "scvx8", 
   //device_body = v8scvx,
   //terminal_a = metal8nores,
   //terminal_b = metal9nores,
   //reference_layer = VIA8ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov8
resistor (
   matrix = trace_devMtrx,
   device_name = "sov8", 
   simulation_model_name = "sov8", 
   device_body = v8sov,
   terminal_a = metal8nores,
   terminal_b = metal9nores,
   reference_layer = VIA8SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov8", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-8
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx8", 
   //simulation_model_name = "sovx8", 
   //device_body = v8sovx,
   //terminal_a = metal8nores,
   //terminal_b = metal9nores,
   //reference_layer = VIA8ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);

#if (_drPROCESS == 6)
// V9 
// scv9
resistor (
   matrix = trace_devMtrx,
   device_name = "scv9", 
   simulation_model_name = "scv9", 
   device_body = v9scv,
   terminal_a = metal9nores,
   terminal_b = metal10nores,
   reference_layer = VIA9SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv9", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-9
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx9", 
   //simulation_model_name = "scvx9", 
   //device_body = v9scvx,
   //terminal_a = metal9nores,
   //terminal_b = metal10nores,
   //reference_layer = VIA9ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov9
resistor (
   matrix = trace_devMtrx,
   device_name = "sov9", 
   simulation_model_name = "sov9", 
   device_body = v9sov,
   terminal_a = metal9nores,
   terminal_b = metal10nores,
   reference_layer = VIA9SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov9", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-9
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx9", 
   //simulation_model_name = "sovx9", 
   //device_body = v9sovx,
   //terminal_a = metal9nores,
   //terminal_b = metal10nores,
   //reference_layer = VIA9ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V10 
// scv10
resistor (
   matrix = trace_devMtrx,
   device_name = "scv10", 
   simulation_model_name = "scv10", 
   device_body = v10scv,
   terminal_a = metal10nores,
   terminal_b = metal11nores,
   reference_layer = VIA0SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv10", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-10
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx10", 
   //simulation_model_name = "scvx10", 
   //device_body = v10scvx,
   //terminal_a = metal10nores,
   //terminal_b = metal11nores,
   //reference_layer = VIA10ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov10
resistor (
   matrix = trace_devMtrx,
   device_name = "sov10", 
   simulation_model_name = "sov10", 
   device_body = v10sov,
   terminal_a = metal10nores,
   terminal_b = metal11nores,
   reference_layer = VIA10SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov10", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-10
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx10", 
   //simulation_model_name = "sovx10", 
   //device_body = v10sovx,
   //terminal_a = metal10nores,
   //terminal_b = metal11nores,
   //reference_layer = VIA10ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V11 
// scv11
resistor (
   matrix = trace_devMtrx,
   device_name = "scv11", 
   simulation_model_name = "scv11", 
   device_body = v11scv,
   terminal_a = metal11nores,
   terminal_b = metal12nores,
   reference_layer = VIA11SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv11", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-11
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx11", 
   //simulation_model_name = "scvx11", 
   //device_body = v11scvx,
   //terminal_a = metal11nores,
   //terminal_b = metal12nores,
   //reference_layer = VIA11ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov11
resistor (
   matrix = trace_devMtrx,
   device_name = "sov11", 
   simulation_model_name = "sov11", 
   device_body = v11sov,
   terminal_a = metal11nores,
   terminal_b = metal12nores,
   reference_layer = VIA11SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov11", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-11
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx11", 
   //simulation_model_name = "sovx11", 
   //device_body = v11sovx,
   //terminal_a = metal11nores,
   //terminal_b = metal12nores,
   //reference_layer = VIA11ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
// V12 
// scv12
resistor (
   matrix = trace_devMtrx,
   device_name = "scv12", 
   simulation_model_name = "scv12", 
   device_body = v12scv,
   terminal_a = metal12nores,
   terminal_b = tm1nores,
   reference_layer = VIA12SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv12", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-12
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx12", 
   //simulation_model_name = "scvx12", 
   //device_body = v12scvx,
   //terminal_a = metal12nores,
   //terminal_b = tm1nores,
   //reference_layer = VIA12ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov12
resistor (
   matrix = trace_devMtrx,
   device_name = "sov12", 
   simulation_model_name = "sov12", 
   device_body = v12sov,
   terminal_a = metal12nores,
   terminal_b = tm1nores,
   reference_layer = VIA12SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov12", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-12
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx12", 
   //simulation_model_name = "sovx12", 
   //device_body = v12sovx,
   //terminal_a = metal12nores,
   //terminal_b = tm1nores,
   //reference_layer = VIA12ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
#else
// V9 
// scv9
resistor (
   matrix = trace_devMtrx,
   device_name = "scv9", 
   simulation_model_name = "scv9", 
   device_body = v9scv,
   terminal_a = metal9nores,
   terminal_b = tm1nores,
   reference_layer = VIA9SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "scv9", terminal_a = "PLUS", terminal_b = "MINUS"},
   },
   resistor_value = 0.0001 //optional
);
// scvx-9
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "scvx9", 
   //simulation_model_name = "scvx9", 
   //device_body = v9scvx,
   //terminal_a = metal9nores,
   //terminal_b = tm1nores,
   //reference_layer = VIA9ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   //merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //schematic_devices = {
      //{device_name = "scvx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 0.0001 //optional
//);
// sov9
resistor (
   matrix = trace_devMtrx,
   device_name = "sov9", 
   simulation_model_name = "sov9", 
   device_body = v9sov,
   terminal_a = metal9nores,
   terminal_b = tm1nores,
   reference_layer = VIA9SWITCHID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO},
     {name = "parsrc", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genSwtch2TermProps, //optional
   merge_parallel = false, //optional
   // swappable_pins = {{"A", "B"}},
   x_card = true,
   schematic_devices = {
      {device_name = "sov9", terminal_a = "PLUS", terminal_b = "MINUS"}
   },
   resistor_value = 10000.0 //optional
);
// sovx-9
//resistor (
   //matrix = trace_devMtrx,
   //device_name = "sovx9", 
   //simulation_model_name = "sovx9", 
   //device_body = v9sovx,
   //terminal_a = metal9nores,
   //terminal_b = tm1nores,
   //reference_layer = VIA9ALTSWITCHID, //optional
   //properties = {
     //{name = "w", type = DOUBLE, scale = MICRO},
     //{name = "l", type = DOUBLE, scale = MICRO},
     //{name = "parsrc", type = DOUBLE, scale = MICRO}
   //}, 
   //property_function = genSwtch2TermProps, //optional
   // swappable_pins = {{"A", "B"}},
   //x_card = true,
   //merge_parallel = false, //optional
   //schematic_devices = {
      //{device_name = "sovx", terminal_a = "PLUS", terminal_b = "MINUS"}
   //},
   //resistor_value = 10000.0 //optional
//);
#endif


#endif

