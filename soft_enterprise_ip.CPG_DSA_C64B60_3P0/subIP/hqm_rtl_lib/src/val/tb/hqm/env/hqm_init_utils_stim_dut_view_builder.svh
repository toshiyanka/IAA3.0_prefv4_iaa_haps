class hqm_init_utils_stim_dut_view_builder extends init_utils_stim_dut_view_pkg::init_utils_stim_dut_view_builder;

    `ovm_object_utils(hqm_init_utils_stim_dut_view_builder)
    //---------------------------------------------------------------------------
    // Function: new
    // This constructor invokes all functions that discover configuration and
    // populate the contract dut_*_cfg objects used by <init_utils_stim_dut_view> to
    // populate data that sequence authors use in their constraints and behavior
    //---------------------------------------------------------------------------
    function new(string name = "hqm_init_utils_stim_dut_view_builder");

        super.new(name);

    endfunction


    //------------------------------------------------------------------------------
    // Function: build_security_config
    // Builds the config classes for security config
    //------------------------------------------------------------------------------
    protected virtual function void build_dut_security_cfg(init_utils_stim_dut_view_pkg::init_utils_stim_dut_security_config cfg);
        `ovm_info("stim_init_utils_dut_view", $sformatf("build_security_config()"), OVM_NONE)// `STIM_DEBUG(stim_debug_pkg::stim, OVM_FULL, DUT_VIEW));


        cfg.set_key_id_info(0, 0,0);//cfgMgr.get_mktme_key_id_lsb_bit() );

    endfunction

    protected virtual function void build_dut_cache_set_cfg(init_utils_stim_dut_view_pkg::init_utils_stim_dut_cache_set_config cfg);


        `ovm_info("stim_init_utils_dut_view", $sformatf("build_dut_cache_set_cfg()"), OVM_NONE)// `STIM_DEBUG(stim_debug_pkg::stim, OVM_FULL, DUT_VIEW));


        // Get a CHA config object - any will do, they will all be the same for these values
        begin
            int unsigned llc_set_size;
            int unsigned llc_set_msb;
            int unsigned llc_set_lsb;
            int unsigned sf_set_size;
            int unsigned sf_set_msb;
            int unsigned sf_set_lsb;
            int unsigned rsf_set_size;
            int unsigned rsf_set_msb;
            int unsigned rsf_set_lsb;

            llc_set_size = 2048;
            sf_set_size  = 2048;
            rsf_set_size = 2048;

            llc_set_msb = $clog2(llc_set_size) - 1 + 6; // - 1 to get MSB from log2
            sf_set_msb  = $clog2(sf_set_size)  - 1 + 6;
            rsf_set_msb = $clog2(rsf_set_size) - 1 + 6;

            llc_set_lsb = 6;
            sf_set_lsb  = 6;
            rsf_set_lsb = 6;

            cfg.set_cache_set_msb_lsb(CACHE_SET_TYPE_pkg::LLC_SET,llc_set_msb,llc_set_lsb); //set_llc_config(llc_set_msb, llc_set_lsb);
            cfg.set_cache_set_msb_lsb(CACHE_SET_TYPE_pkg::SF_SET,llc_set_msb,llc_set_lsb); //set_sf_config(sf_set_msb, sf_set_lsb);
            cfg.set_cache_set_msb_lsb(CACHE_SET_TYPE_pkg::RSF_SET,llc_set_msb,llc_set_lsb); //set_rsf_config(rsf_set_msb, rsf_set_lsb);

        end


        //NM set

        begin
            longint unsigned hash_mask;
            cfg.set_cache_set_msb_lsb(CACHE_SET_TYPE_pkg::NM_SET,16, 6);
        end


        begin
            cfg.set_cache_set_msb_lsb(CACHE_SET_TYPE_pkg::IAL_SET,16, 6);
            cfg.set_cache_set_msb_lsb(CACHE_SET_TYPE_pkg::MLC_SET,15, 6);   //current projcfg API is 15. not sure why it's not 16.


        end
        begin
            cfg.set_socket_type(0,0);  //BFM

        end


        //rsf -enable

        begin
            MEM_DEVICE_TYPE_pkg::MEM_DEVICE_TYPE mem_type;
            bit rsf_en_val;
            for (int ii=0;ii<mem_type.num();ii++)  begin
                if(ii==0) mem_type=mem_type.first();
                else mem_type=mem_type.next();
                //--08012022  cfg.set_rsf_mem_enable(mem_type,0);
            end //for
        end


        begin
            int    num_ways;

            num_ways = 1;//ConfigDB::getConfigValAndCheckUint64(configKey);

            //--08012022 cfg.set_cache_way_size(CACHE_WAY_TYPE_pkg::CACHE_WAY_MLC,num_ways);


            num_ways = 4;

            //--08012022 cfg.set_cache_way_size(CACHE_WAY_TYPE_pkg::CACHE_WAY_LLC,num_ways);

            num_ways =8;

            //--08012022 cfg.set_cache_way_size(CACHE_WAY_TYPE_pkg::CACHE_WAY_IAL,num_ways);

            //--08012022 cfg.set_cache_way_size(CACHE_WAY_TYPE_pkg::CACHE_WAY_NM_HBM,1);
            //--08012022 cfg.set_cache_way_size(CACHE_WAY_TYPE_pkg::CACHE_WAY_NM_DDR,1);


        end

    endfunction



    //------------------------------------------------------------------------------


endclass



class hqm_init_utils_stim_dut_view_builder_registrar;
    // Variable: registrar
    // Static data member constructed by new to invoke OVM factory override immediately without user intervention
    static hqm_init_utils_stim_dut_view_builder_registrar registrar = new;

    //------------------------------------------------------------------------------
    // Function: new
    // Constructor which executes OVM factory override
    //------------------------------------------------------------------------------
    function new();
        ovm_factory::get().set_type_override_by_type(init_utils_stim_dut_view_pkg::init_utils_stim_dut_view_builder::get_type(), hqm_init_utils_stim_dut_view_builder::get_type(), 1);
    endfunction : new
endclass : hqm_init_utils_stim_dut_view_builder_registrar
