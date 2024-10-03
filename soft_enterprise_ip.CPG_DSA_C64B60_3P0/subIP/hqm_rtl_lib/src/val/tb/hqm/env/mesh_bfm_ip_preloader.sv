// -*- mode: Verilog; verilog-indent-level: 3; -*-

//macros for declaring and building IP preloader proxies
`include "/p/hdk/rtl/proj_tools/init_utils-srvrvip/init_utils-srvrvip-20ww36d/init_utils/src/sys_level_preloader/ovmsv/sys_level_preloader_macros.sv"
//`include "sys_level_preloader_macros.sv"

//-----------------------------------------------------------
`DECLARE_NONBLOCKING_PUT_IMP_PORT

class mesh_bfm_ip_preloader_commit#(type COM=commit_packet_t) extends ovm_component;
   typedef mesh_bfm_ip_preloader_commit#(COM) PRELOADER_TYPE_C;
   `ovm_component_param_utils(PRELOADER_TYPE_C)

   ovm_nonblocking_put_imp#(COM,PRELOADER_TYPE_C) commit_nb_put_export;

   //==================================================================

   function new(string ip_preloader_name = "mesh_bfm_ip_preloader_commit", ovm_component parent = null);
      super.new(ip_preloader_name, parent);
      `ovm_info(get_name(), "Constructing...", OVM_LOW)

      if(getenv("INIT_UTILS_VALIDATE_COMMIT_EN")=="1") begin
         commit_nb_put_export = new("commit_nb_put_export", this);
         `ovm_info(get_name(), $psprintf("Constructing nonblocking put port %s...", commit_nb_put_export.get_full_name()), OVM_LOW)
      end

      //registering TLM ports with ML COMM
      register_tlm_entities();

   endfunction: new

   //==================================================================
   function void register_tlm_entities();
      if(getenv("INIT_UTILS_VALIDATE_COMMIT_EN")=="1") begin
         tlm_registry::nonblocking_put_export#(COM,PRELOADER_TYPE_C) nb_put_export_commit;
         nb_put_export_commit = new(commit_nb_put_export);
         `ovm_info(get_name(), "INIT_UTILS_VALIDATE_COMMIT_EN=1  register_tlm_entities() add .nb_put_export_commit..", OVM_LOW)
      end
   endfunction: register_tlm_entities

   //==================================================================
   virtual task put(input COM pkt);
      `ovm_info(get_name(), "Received the following TLM packet.", OVM_LOW)
       pkt.dbg_print();
       try_put( pkt );
   endtask: put

   //==================================================================
   //If SLP Tells me to prelaod then go ahead and prelaod
   virtual function bit try_put(input COM pkt);
       bit result = 1;
      `ovm_info(get_name(), "Received the following TLM packet.", OVM_LOW)
       pkt.dbg_print();
       return result;
   endfunction: try_put

   //==================================================================
   virtual function bit can_put();
      return 1;
   endfunction: can_put

endclass: mesh_bfm_ip_preloader_commit



//==================================================================

class mesh_bfm_ip_preloader#(type COH_DOM_REQ = int,type COM=commit_packet_t,type RSP=rsp_packet_t) extends ovm_component;

   typedef mesh_bfm_ip_preloader#(COH_DOM_REQ) PRELOADER_TYPE;
   `ovm_component_param_utils(PRELOADER_TYPE)

   `DECLARE_IP_PRELOADER_PORTS
   //ovm_nonblocking_put_imp_coh_dom_req#(COH_DOM_REQ, PRELOADER_TYPE) nb_put_export_coh_dom_req;
   //ovm_nonblocking_put_port#(RSP) feedback_nb_put_port;

   mesh_bfm_ip_preloader_commit#(COM) commit_object;

   //declaring an IP preloader proxy
   `DECLARE_EXPORT_FOR_SYSYTEM_PRELOADER_COMM(COH_DOM_REQ)


   ip_preloader_topology_info preloader_info;
   //coh_dom_ip_preloader_topology_info preloader_info;


   //==================================================================

   function new(string ip_preloader_name = "mesh_bfm_ip_preloader", ovm_component parent = null);

      super.new(ip_preloader_name, parent);
      `ovm_info(get_name(), "Constructing...", OVM_LOW)

      `INIT_IP_PRELOADER_PORTS
      // nb_put_export_coh_dom_req = new("nb_put_export_coh_dom_req", this);
      //`ovm_info(get_name(), $psprintf("Constructing nonblocking put export %s...", nb_put_export_coh_dom_req.get_full_name()), OVM_LOW)


      //registering TLM ports with ML COMM
      `INIT_FUNC_IP_LEVEL_RPELOAD_REGISTER_TLM_ENTITIES
      // commit_object = new("commit_object",this,this);
      // feedback_nb_put_port = new("feedback_nb_put_port",this);
      //`ovm_info(get_name(), $psprintf("Constructing nonblocking put port %s...", feedback_nb_put_port.get_full_name()), OVM_LOW)

       //register_tlm_entities();
   endfunction: new

   //---------------------------------------------------------------------------
   `DECLARE_FUNC_IP_LEVEL_RPELOAD_REGISTER_TLM_ENTITIES

   //function void register_tlm_entities();
   //   tlm_registry::nonblocking_put_export#(COH_DOM_REQ) nb_put_export_coh_dom_req_entry;
   //   nb_put_export_coh_dom_req_entry = new(nb_put_export_coh_dom_req);
   //   if(this.val_and_com_enable) begin  
   //      tlm_registry::nonblocking_put_port#(RSP) nb_put_port_coh_dom_req_entry_feedback;
   //      nb_put_port_coh_dom_req_entry_feedback = new(feedback_nb_put_port);
   //   end  
   //endfunction: register_tlm_entities

   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------
     function void build();

         int unsigned fabric_first_level_cache_ids[$];
         int unsigned fabric_snoop_filter_ids[$];
         int unsigned off_pkg_mem_ids[$];
         int unsigned non_coherent_ids[$];

        super.build();
        `ovm_info(get_name(), "Building...", OVM_NONE)

        //building an IP preloader proxy
        preloader_info = new(get_name(),0,"mesh_bfm",100);


        off_pkg_mem_ids.push_back(0);
        non_coherent_ids.push_back(0);


        preloader_info.set_off_package_memory_ids(0, off_pkg_mem_ids);
        preloader_info.set_non_coherent_ids(0, non_coherent_ids);


        `BUILD_EXPORT_FOR_SYSYTEM_PRELOADER_COMM(preloader_info, nb_put_export_coh_dom_req, COH_DOM_REQ)

        `ovm_info(get_name(), "Building..  Done.", OVM_NONE)
     endfunction: build


   //---------------------------------------------------------------------------
   /*
   virtual task put(input COH_DOM_REQ pkt);
   endtask: put

   //---------------------------------------------------------------------------
   virtual function bit try_put(input COH_DOM_REQ pkt);

      bit result = 1;

      `ovm_info(get_name(), "Received the following TLM packet.", OVM_LOW)
       pkt.dbg_print();

       return result;
   endfunction: try_put
   //---------------------------------------------------------------------------
   virtual function bit can_put();
      return 1;
   endfunction: can_put
   //---------------------------------------------------------------------------
   */



   //---------------------------------------------------------------------------
   //required functions for nonblocking put export
   virtual task put_coh_dom_req(input COH_DOM_REQ pkt);
      try_put_coh_dom_req(pkt);
   endtask: put_coh_dom_req


   //---------------------------------------------------------------------------
   virtual function bit try_put_coh_dom_req(input COH_DOM_REQ pkt);
       bit result = 1;

      `ovm_info(get_name(), "mesh_bfm_ip_preloader's try_put_coh_dom_req Received the following TLM packet.", OVM_LOW)
      pkt.dbg_print();

      return result;

   endfunction: try_put_coh_dom_req

   //---------------------------------------------------------------------------
   virtual function bit can_put_coh_dom_req();
      return 1;
   endfunction: can_put_coh_dom_req
   //---------------------------------------------------------------------------

endclass: mesh_bfm_ip_preloader


/*
 function void connect();
 super.connect();
 `ovm_info(get_name(), "Connecting...", OVM_LOW)
   endfunction

 function void end_of_elaboration();
 super.end_of_elaboration();
   endfunction: end_of_elaboration

 function void start_of_simulation();
 super.start_of_simulation();
   endfunction: start_of_simulation

 task run();
 `ovm_info($psprintf("%s ON BEHALF OF base", get_name()), "Running...", OVM_LOW)
   endtask: run

 function void extract();
 super.extract();
   endfunction: extract

 function void check();
 super.check();
   endfunction: check

 function void report();
 super.report();
   endfunction: report
 */
