// -*- mode: Verilog; verilog-indent-level: 3; -*-

//macros for declaring and building IP preloader proxies
`include "sys_level_preloader_macros.sv"

//macros for receiving requests from more than one domain for example
//`ovm_nonblocking_put_imp_decl(_coh_dom_req)
//-----------------------------------------------------------
`DECLARE_NONBLOCKING_PUT_IMP_PORT


  //-----------------------------------------------------------

  class hqm_ip_preloader_commit#(type COM=commit_packet_t) extends ovm_component;
     typedef hqm_ip_preloader_commit#(COM) PRELOADER_TYPE_C;
     `ovm_component_param_utils(PRELOADER_TYPE_C)
     ovm_nonblocking_put_imp#(COM,PRELOADER_TYPE_C) commit_nb_put_export;

     function new(string ip_preloader_name = "hqm_ip_preloader_commit", ovm_component parent = null);
        super.new(ip_preloader_name, parent);
        `ovm_info(get_name(), "Constructing...", OVM_LOW)
        if(getenv("INIT_UTILS_VALIDATE_COMMIT_EN")=="1") begin
           commit_nb_put_export = new("commit_nb_put_export", this);
           `ovm_info(get_name(), $psprintf("Constructing nonblocking put port %s...", commit_nb_put_export.get_full_name()), OVM_LOW)
        end
        //registering TLM ports with ML COMM
        register_tlm_entities();
     endfunction: new

     function void register_tlm_entities();
        if(getenv("INIT_UTILS_VALIDATE_COMMIT_EN")=="1") begin
           tlm_registry::nonblocking_put_export#(COM,PRELOADER_TYPE_C) nb_put_export_commit;
           nb_put_export_commit = new(commit_nb_put_export);
        end
     endfunction: register_tlm_entities

     virtual task put(input COM pkt);
        `ovm_info(get_name(), "Received the following TLM packet.", OVM_LOW)
        pkt.dbg_print();
     endtask: put
     /*If SLP Tells me to prelaod then go ahead and prelaod */
     virtual function bit try_put(input COM pkt);
         bit result = 1;
        `ovm_info(get_name(), "Received the following TLM packet.", OVM_LOW)
        pkt.dbg_print();
        return result;
     endfunction: try_put

     virtual function bit can_put();
        return 1;
     endfunction: can_put

  endclass: hqm_ip_preloader_commit


//------------------------------------------------------------------------------------------------------------------------------
class hqm_ip_preloader#(type COH_DOM_REQ = int, type COM=commit_packet_t, type RSP=rsp_packet_t) extends ovm_component;

   typedef hqm_ip_preloader#(COH_DOM_REQ) PRELOADER_TYPE;
   `ovm_component_param_utils(PRELOADER_TYPE)


   `DECLARE_IP_PRELOADER_PORTS

     hqm_ip_preloader_commit#(COM) commit_object;

   //declaring an IP preloader proxy
   `DECLARE_EXPORT_FOR_SYSYTEM_PRELOADER_COMM(COH_DOM_REQ)


   ip_preloader_topology_info preloader_info;
   //coh_dom_ip_preloader_topology_info preloader_info;
    int      skt_id;
    string   ip_name;
    int      ip_id;
    int      inst_id;


   function new(string ip_preloader_name = "hqm_ip_preloader", ovm_component parent = null);

      super.new(ip_preloader_name, parent);
      `ovm_info(get_name(), "Constructing...", OVM_LOW)

      commit_object = new("commit_object",this);

      `INIT_IP_PRELOADER_PORTS

        //registering TLM ports with ML COMM
        `INIT_FUNC_IP_LEVEL_RPELOAD_REGISTER_TLM_ENTITIES

          endfunction: new
   //---------------------------------------------------------------------------
   `DECLARE_FUNC_IP_LEVEL_RPELOAD_REGISTER_TLM_ENTITIES
     //---------------------------------------------------------------------------

     function void build();
         int unsigned off_pkg_mem_ids[$];

        super.build();
        `ovm_info(get_name(), "Building...", OVM_LOW)

        //building an IP preloader proxy
        skt_id = 1;
        preloader_info = new(get_name(), skt_id, ip_name, ip_id);
        off_pkg_mem_ids.push_back(inst_id);
        preloader_info.set_off_package_memory_ids(skt_id, off_pkg_mem_ids);


        `BUILD_EXPORT_FOR_SYSYTEM_PRELOADER_COMM(preloader_info, nb_put_export_coh_dom_req, COH_DOM_REQ)

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

   //required functions for nonblocking put export

   virtual task put_coh_dom_req(input COH_DOM_REQ pkt);
   endtask: put_coh_dom_req
   //---------------------------------------------------------------------------

   virtual function bit try_put_coh_dom_req(input COH_DOM_REQ pkt);

       bit result = 1;

      `ovm_info(get_name(), "hqm_ip_preloader's try_put_coh_dom_req Received the following TLM packet.", OVM_LOW)
      pkt.dbg_print();

      return result;

   endfunction: try_put_coh_dom_req
   //---------------------------------------------------------------------------

   virtual function bit can_put_coh_dom_req();
      return 1;
   endfunction: can_put_coh_dom_req
   //---------------------------------------------------------------------------

   function void set_ip_preloader_info(int iskt_id, string iip_name, int iip_id, int iinst_id);
      skt_id = iskt_id;
      ip_name = iip_name;
      ip_id = iip_id;
      inst_id = iinst_id;
   endfunction
endclass: hqm_ip_preloader


