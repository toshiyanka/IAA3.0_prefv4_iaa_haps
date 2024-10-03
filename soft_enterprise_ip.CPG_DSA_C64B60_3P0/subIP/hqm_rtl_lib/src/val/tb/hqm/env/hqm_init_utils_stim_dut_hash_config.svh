
//import "DPI-C" function longint unsigned dpi_socketFromPA(input longint unsigned addr);
//SystemBaseCfg.svh already import  the dunciton , then don' need do it again.
//-----------------------------------------------------------------
//import "DPI-C" function longint unsigned projcfg_getNMChanIdFromPA (uint64_t addr)

//-----------------------------------------------------------------

class hqm_init_utils_stim_dut_hash_config extends init_utils_stim_dut_view_pkg::init_utils_stim_dut_hash_config;

    `ovm_object_utils(hqm_init_utils_stim_dut_hash_config)



    function new(string name = "hqm_init_utils_stim_dut_hash_config");
        super.new(name);
    endfunction



    //override function

    //------------------------------------------------------------------------------

/*-- 08012022 
    virtual function int unsigned get_socket_id_from_pa(longint unsigned addr,MEM_REGION_TYPES_pkg::MEM_REGION_TYPES mem_type=MEM);

        int socket_id;
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_socket_id_from_pa() for addr=%h", addr), OVM_NONE)

        //socket_id= dpi_socketFromPA(addr);
        socket_id=0;
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf("YZ: socket_id=%h", socket_id), OVM_NONE)

        //offsocket_mem
        if(addr=='h8855_6640) socket_id =1; // off socket is ABStract BFM
        if(addr=='ha0aa_bb40) socket_id =1; // off socket is ABStract BFM
        return socket_id;

    endfunction

08012022-- */

    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------


    virtual function int unsigned get_nm_id_from_pa(longint unsigned addr);
        int nm_id;
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_nm_id_from_pa() for addr=%h", addr), OVM_NONE)
        nm_id=0;
        //dpi_getNMIdFromPA(addr,nm_id);

        return nm_id;
    endfunction

    //------------------------------------------------------------------------------

    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    virtual function int unsigned get_fm_id_from_pa(longint unsigned addr);

        int fm_id;
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_fm_id_from_pa() for addr=%h", addr), OVM_NONE)
        fm_id=160;

        if(addr=='ha000_0040)   fm_id=160; //DDR
        if(addr=='hbb11_2240)   fm_id=161; //HBM
        if(addr=='hcc33_4440)   fm_id=162; //DDRT
        if(addr=='hdd55_6640)   fm_id=192; //IAL_MEM

        if(addr=='h8855_6640)   fm_id=-1; //DDR   --off-socket-MEM , to make it pass to MeshBFM.
        if(addr=='ha0aa_bb40)   fm_id=-1;    // off-socket cache


        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_fm_id_from_pa() for addr=%h fm_id=%0d", addr,fm_id), OVM_NONE)


        return fm_id;

    endfunction
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    virtual function int unsigned get_cha_id_from_pa(int socket,longint unsigned addr);

        int cha_id;
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_cha_id_from_pa for addr=0x%h ", addr), OVM_NONE)


        cha_id=-1;

        cha_id=0;//
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_cha_id_from_pa for addr=0x%h  cha_id=%0d", addr,cha_id), OVM_NONE)
        if(addr=='ha0aa_bb40)cha_id     =-1;    //socket 1
        if(addr=='ha0778840) cha_id=1;//  CHA0 is RTL

        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_cha_id_from_pa for addr=0x%h  cha_id=%0d", addr,cha_id), OVM_NONE)

        return cha_id;

    endfunction
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    /*   virtual function MEM_DEVICE_TYPE getFMTypeFromPA(unsigned long long addr)

   endfunction
     */
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------



    virtual function int unsigned get_nm_type_from_pa(longint unsigned addr);
        return -1;//INVD_MEM

    endfunction

    virtual function int unsigned get_fm_type_from_pa(longint unsigned addr);
        int fm_type=1;
        if(addr=='ha000_0040)   fm_type=1; //DDR
        if(addr=='hbb11_2240)   fm_type=0; //HBM
        if(addr=='hcc33_4440)   fm_type=2; //DDRT
        if(addr=='hdd55_6640)   fm_type=7; //IAL_MEM

        if(addr=='h8855_6640)   fm_type=1; //DDR

        return fm_type;
    endfunction
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------

    /*
     extern "C" int dpi_integ_portal_get_nmcache_preferred_way_from_pa(int sktid, long long unsigned int pa, int chaid);
     int Portal_integ::getNMCachePreferredWayFromPA(int sktid, long long unsigned int pa, int chaid)
     {
     dpi_integ_set_scope();
     return dpi_integ_portal_get_nmcache_preferred_way_from_pa(sktid, pa, chaid);
     };

     ./tb/integ/system_base/src/SystemBaseEnv.svh:export "DPI-C" function dpi_integ_portal_get_nmcache_preferred_way_from_pa;
     ./tb/integ/system_base/src/SystemBaseEnv.svh:function automatic int dpi_integ_portal_get_nmcache_preferred_way_from_pa(input int sktid, input longint unsigned pa, input int chaid =
     0);

     */

    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------


    virtual function int unsigned get_nm_cache_preferred_way_from_pa(input int sktid, input longint unsigned addr, input int chaid = 0);
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_nm_cache_preferred_way_from_pa for addr=0x%h ", addr), OVM_NONE)

        return 0;//    dpi_integ_portal_get_nmcache_preferred_way_from_pa(sktid, addr, chaid);

    endfunction

    //------------------------------------------------------------------------------

    virtual function bit is_coherent_pa(longint unsigned addr);
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" is_coherent_pa() for addr=%h  ", addr), OVM_NONE)

        return 1;//dpi_isCoherent(addr);
    endfunction


    //------------------------------------------------------------------------------

    /*

     function tdif_iosf_target_info_t get_iospace_target(longint unsigned addr);
     return (systemBaseCfg.get_iospace_target(addr));
    endfunction : get_iospace_target

     function tdif_iosf_target_info_t get_sysspace_target(longint unsigned addr);
     return (systemBaseCfg.get_sysspace_target(addr));
    endfunction : get_sysspace_target

     function void dpi_integ_addrdec_get_iospace_target(input longint unsigned addr, output chandle tdifInfo);
     IntegEnv topEnv;
     IntegEnv sysEnvQ[$];
     SystemBaseEnv sysEnv;
     tdif_iosf_target_info_t result;

     assert($cast(topEnv, sla_tb_env::get_top_tb_env()));
     sysEnvQ = topEnv.getIntegEnvDescendants("SYSTEM");
     assert(sysEnvQ.size() == 1);
     assert($cast(sysEnv, sysEnvQ[0]));

     result = sysEnv.get_iospace_target(addr);
     tdifInfo = result.copy_to_sc();
endfunction : dpi_integ_addrdec_get_iospace_target

     function void dpi_integ_addrdec_get_sysspace_target(input longint unsigned addr, output chandle tdifInfo);
     IntegEnv topEnv;
     IntegEnv sysEnvQ[$];
     SystemBaseEnv sysEnv;
     tdif_iosf_target_info_t result;

     assert($cast(topEnv, sla_tb_env::get_top_tb_env()));
     sysEnvQ = topEnv.getIntegEnvDescendants("SYSTEM");
     assert(sysEnvQ.size() == 1);
     assert($cast(sysEnv, sysEnvQ[0]));

     result = sysEnv.get_sysspace_target(addr);
     tdifInfo = result.copy_to_sc();
endfunction : dpi_integ_addrdec_get_sysspace_target

     */

    //---------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------------------
    virtual function void get_iosf_target_info_space_from_pa(longint unsigned addr, int unsigned space  , output int unsigned socket, output int unsigned nodeid, output int unsigned iosf_fabric, output int unsigned iosf_port, output int unsigned iosf_channel, output int unsigned iosf_address_space);
        `ovm_info("hash_cfg", $sformatf("get_iosf_target_info_space_from_pa() space=%0d", space), OVM_NONE)


        socket=0;
        nodeid=1;
        iosf_fabric=0;
        iosf_port=1;
        iosf_channel=1;
        iosf_address_space=0; //0-MEM.//1-CFG/2-IO

        /*
         IntegEnv topEnv;
         IntegEnv sysEnvQ[$];
         SystemBaseEnv sysEnv;
         tdif_iosf_target_info_t_pkg::tdif_iosf_target_info_t result;

         assert($cast(topEnv, sla_tb_env::get_top_tb_env()));
         sysEnvQ = topEnv.getIntegEnvDescendants("SYSTEM");
         assert(sysEnvQ.size() == 1);
         assert($cast(sysEnv, sysEnvQ[0]));


         if(space=="IO") begin
         result = sysEnv.get_iospace_target(addr);
        end
         else if(space=="SYS") begin
         result = sysEnv.get_sysspace_target(addr);

        end

         socket=result.socket;
         nodeid=result.nodeid;
         iosf_fabric=result.iosf_fabric;
         iosf_port=result.iosf_port;
         iosf_channel=result.iosf_channel;
         iosf_address_space= int'(result.iosf_address_space); //need onvertor the enum type

         */
    endfunction
    //------------------------------------------------------------------------------

    //------------------------------------------------------------------------------
    //./tb/integ/system_base/src/SystemBaseEnv.svh:export "DPI-C" function dpi_integ_get_meshstop_id_core_inst_id_by_socket_id;
    //later will not used on GEN3
    //./tb/integ/system_base/src/SystemBaseEnv.svh:function bit dpi_integ_get_meshstop_id_core_inst_id_by_socket_id(input int unsigned core_id, output int unsigned meshstop_id, output int unsigned core_inst_id);
    virtual function bit get_meshstop_id_core_inst_id(input int unsigned core_id, output int unsigned meshstop_id, output int unsigned core_inst_id);

        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" get_meshstop_id_core_inst_id for core_id=%0d", core_id), OVM_NONE)
        //return dpi_integ_get_meshstop_id_core_inst_id_by_socket_id(core_id, meshstop_id, core_inst_id);
        core_id=0;
        meshstop_id=0;
        core_inst_id=0;
    endfunction


    //------------------------------------------------------------------------------
    //will remove later  when mesh_stop_id is not need anymore
    /*function void dpi_integ_get_ial_meshid_from_logid_by_socket_id(input longint sktid, input longint iallogid, output longint ialmeshid);
     ialmeshid =  ialMasterInterfaceCfgObj::getIALMeshIdFromLogId(sktid, iallogid);
endfunction : dpi_integ_get_ial_meshid_from_logid_by_socket_id
     */

    virtual function void init_dpi_integ_get_ial_meshid_from_logid_by_socket_id(input longint sktid, input longint iallogid, output longint ialmeshid);
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" init_dpi_integ_get_ial_meshid_from_logid_by_socket_id for iallogid=%0d", iallogid), OVM_NONE)
        ialmeshid = 0;// ial_base_pkg::ialMasterInterfaceCfgObj::getIALMeshIdFromLogId(sktid, iallogid);

    endfunction


    //------------------------------------------------------------------------------


    virtual function void init_dpi_integ_get_ial_meshinstid_from_logid_by_socket_id(input longint sktid, input longint iallogid, output longint ialmeshinstid);
        ialmeshinstid =  0;//ial_base_pkg::ialMasterInterfaceCfgObj::getIALMeshInstIdFromLogId(sktid, iallogid);

    endfunction


endclass

//------------------------------------------------------------------------------
// Class: hqm_init_utils_req_hash_config_registrar
// Registers a factory override for <hqm_init_utils_req_hash_config>
//------------------------------------------------------------------------------

class hqm_init_utils_req_hash_config_registrar;
    // Variable: registrar
    // Static data member constructed by new to invoke OVM factory override immediately without user intervention
    static hqm_init_utils_req_hash_config_registrar registrar = new;

    //------------------------------------------------------------------------------
    // Function: new
    // Constructor which executes OVM factory override
    //------------------------------------------------------------------------------
    function new();
        ovm_factory::get().set_type_override_by_type(init_utils_stim_dut_view_pkg::init_utils_stim_dut_hash_config::get_type(), hqm_init_utils_stim_dut_hash_config::get_type(), 1);
        `ovm_info("init_utils_stim_dut_hash_cfg", $sformatf(" override with new type :hqm_init_utils_stim_dut_hash_config"), OVM_NONE)


    endfunction : new
endclass : hqm_init_utils_req_hash_config_registrar
