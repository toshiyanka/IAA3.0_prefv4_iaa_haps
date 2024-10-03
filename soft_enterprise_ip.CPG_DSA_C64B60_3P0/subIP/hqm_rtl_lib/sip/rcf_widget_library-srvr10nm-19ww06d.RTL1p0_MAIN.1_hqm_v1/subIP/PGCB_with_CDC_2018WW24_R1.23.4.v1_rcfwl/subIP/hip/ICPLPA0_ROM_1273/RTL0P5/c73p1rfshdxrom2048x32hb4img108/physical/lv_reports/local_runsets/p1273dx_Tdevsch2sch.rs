// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tdevsch2sch.rs.rca 1.3 Wed Oct 30 08:37:31 2013 kperrey Experimental $

// $Log: p1273dx_Tdevsch2sch.rs.rca $
// 
//  Revision: 1.3 Wed Oct 30 08:37:31 2013 kperrey
//  hsd 1926; add device for mcr resistor
// 
//  Revision: 1.2 Fri Mar 29 15:12:46 2013 kperrey
//  update to handle m12 resistors
// 
//  Revision: 1.1 Fri Jan  4 15:06:08 2013 kperrey
//  file for more resistor flavors when doing sch2sch lvs
// 

// define resistor devices 
// tcn gcn resistors 
resistor (
   matrix = trace_devMtrx,
   device_name = "rgcnfm1", // carmel is different
   device_body = polycon_res_cl,
   terminal_a = polycon_nores,
   terminal_b = polycon_nores,
   reference_layer = POLYCONRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "rgcnfm1", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rtcnfm1", // carmel is different
   device_body = diffcon_res_cl,
   terminal_a = diffcon_nores,
   terminal_b = diffcon_nores,
   reference_layer = DIFFCONRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "rtcnfm1", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

// poly metal resistors
resistor (
   matrix = trace_devMtrx,
   device_name = "rp",
   device_body = poly_res_cl,
   terminal_a = poly_nores,
   terminal_b = poly_nores,
   reference_layer = PRES_ID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "rp", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "resdw",
   device_body = nwellesd_res_cl,
   terminal_a = nwellesd_nores,
   terminal_b = nwellesd_nores,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "resdw", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rnwell",
   device_body = nwell_res_cl,
   terminal_a = nwell_nores,
   terminal_b = nwell_nores,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "rnwell", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm0fm1", // carmel is different
   device_body = metal0res_cl,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm0fm1", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm0", // carmel is different
   device_body = metal0res_cl,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm0", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm1fm2", // carmel is different
   device_body = metal1res_cl,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm1fm2", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm1m0m2", // carmel is different
   device_body = metal1res_cl,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm1m0m2", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm1", // carmel is different
   device_body = metal1res_cl,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm1", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm2m1m3",
   device_body = metal2res_cl,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm2m1m3", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm2m1",
   device_body = metal2res_cl,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm2m1", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm2",
   device_body = metal2res_cl,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm2", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm3m2m4",
   device_body = metal3res_cl,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm3m2m4", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm3m2",
   device_body = metal3res_cl,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm3m2", terminal_a = "A", terminal_b = "B"}   // needed by x10
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm3",
   device_body = metal3res_cl,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm3", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm4m3m5",
   device_body = metal4res_cl,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm4m3m5", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm4m3",
   device_body = metal4res_cl,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm4m3", terminal_a = "A", terminal_b = "B"} // for x10
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm4",
   device_body = metal4res_cl,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm4", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm5m4m6",
   device_body = metal5res_cl,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm5m4m6", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm5m4",
   device_body = metal5res_cl,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm5m4", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm5",
   device_body = metal5res_cl,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm5", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm6m5m7",
   device_body = metal6res_cl,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm6m5m7", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm6m5",
   device_body = metal6res_cl,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm6m5", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm6",
   device_body = metal6res_cl,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm6", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm7m6m8",
   device_body = metal7res_cl,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
       {device_name = "rm7m6m8", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm7m6",
   device_body = metal7res_cl,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
       {device_name = "rm7m6", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm7",
   device_body = metal7res_cl,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
       {device_name = "rm7", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm8m7m9",
   device_body = metal8res_cl,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm8m7m9", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm8m7",
   device_body = metal8res_cl,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm8m7", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm8m7u",
   device_body = metal8res_cl,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm8m7u", terminal_a = "A", terminal_b = "B"} // used by x10
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rm8",
   device_body = metal8res_cl,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm8", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

#if _drPROCESS == 5
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8m10",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8m10", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10m9m11",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10m9m11", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10m9",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10m9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1m10",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1m10", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );
   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );

#elif _drPROCESS == 6
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8m10",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8m10", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10m9m11",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10m9m11", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10m9",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10m9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm11m10m12",
      device_body = metal11res_cl,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm11m10m12", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm11m10",
      device_body = metal11res_cl,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm11m10", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm11",
      device_body = metal11res_cl,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm11", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm12m11tm1",
      device_body = metal12res_cl,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm12m11tm1", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm12m11",
      device_body = metal12res_cl,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm12m11", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rm12",
      device_body = metal12res_cl,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm12", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1m12",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1m12", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );
   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );

#else
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8tm1",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8tm1", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1m9",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1m9", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );
   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );
#endif

resistor (
   matrix = trace_devMtrx,
   device_name = "rrdlm0",
   device_body = rdlres_cl,
   terminal_a = rdlnores,
   terminal_b = rdlnores,
   reference_layer = RDLRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rrdlm0", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rrdl",
   device_body = rdlres_cl,
   terminal_a = rdlnores,
   terminal_b = rdlnores,
   reference_layer = RDLRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rrdl", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rmcrm4m6",
   device_body = mcrres_cl,
   terminal_a = mcrnores,
   terminal_b = mcrnores,
   reference_layer = MCRRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rmcrm4m6", terminal_a = "A", terminal_b = "B"},
      {device_name = "rmcrm4", terminal_a = "A", terminal_b = "B"},
      {device_name = "rmcr", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// resistor (
//   matrix = trace_devMtrx,
//   device_name = "rmtj",
//   device_body = MTJ,
//   terminal_a = metal1nores,
//   terminal_b = VIA2,
//   reference_layer = MTJ, //optional
//   properties = {
//     {name = "w", type = DOUBLE, scale = MICRO},
//     {name = "l", type = DOUBLE, scale = MICRO}
//   }, 
//   property_function = genRes2TermProps, //optional
//   merge_parallel = false, //optional
//   schematic_devices = {
//      {device_name = "rmtjm1m3", terminal_a = "A", terminal_b = "B"},
//      {device_name = "rmtjm1", terminal_a = "A", terminal_b = "B"},
//      {device_name = "rmtj", terminal_a = "A", terminal_b = "B"}
//   },
//   resistor_value = 1.0 //optional
//);
