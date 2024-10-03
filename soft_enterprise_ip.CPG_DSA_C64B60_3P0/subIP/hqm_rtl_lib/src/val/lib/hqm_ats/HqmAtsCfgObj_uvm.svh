// -----------------------------------------------------------------------------
// Copyright(C) 2017 - 2019 Intel Corporation, All Rights Reserved
// -----------------------------------------------------------------------------
//
// Owner:       Adil Shaaeldin
// Created On:  1/12/2017
// Description: IOMMU Environment's Configuration
//              ---------------------------------
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

typedef class HqmAtsEnv;


class HqmAtsCfgObj extends uvm_object;

    `uvm_object_utils(HqmAtsCfgObj)

    uvm_active_passive_enum is_active    = UVM_ACTIVE;

    protected bit disable_tb_report_severity_settings = 0;

    // IOMMU Device ID
    bit [15:0] iommu_bdf    = 'hCAFE;    // TODO: Adil: Capture iommu BDF somehow

    string agent_name;                  // IOSF PVC Agent Name

    HqmAtsEnv env;

    bit nowrite_mode_en     = 0;         // 0: NW field of Translation Request is active.

    string ENV_FILENAME     = "ats_env.out";

    string IOMMU_FILENAME   = "ats_iommu.out";

    bit    disable_tracker = 1'b0;       // Tracker Enable
    string TRACKER_FILENAME  = "ats_tracker.out";

    bit    disable_checker = 1'b0;       // Checker Enable
    string CHECKER_FILENAME  = "ats_checker.out";

    bit    disable_ats_inv_check = 1'b0;
    
    bit    is_bus_iCXL;

    sla_ral_reg     reg_ptr [string];

    // IOSF Primary IF bus width parameters
    // IOSF PIF consists of "m" and "t" interfaces
    typedef struct {
        int data_bitwidth;
    } iosfpif_params_t;

    // Local copy of IOSF Primary Interface Bus Parameters (i.e. Data bus width, etc.)
    iosfpif_params_t        iosfpif_m_params;
    iosfpif_params_t        iosfpif_t_params;

    // Run a Basic IOMMU Memory self-test
    bit     run_iommu_mem_selftest = 0;     // This self-test ensures that the IOMMU
                                            // memory model works correctly.

                                            // Tests including populating translation entries,
                                            // reading the translation entries,
                                            // deleting the translation entries,
                                            // and printing the existing address map

    bit     run_iommu_ats_selftest = 0;     // by default, we use the DUT.

    typedef struct {
        // CSR = PCIE-defined Control Status Registers
        // CTL = Control
        // STS = Status
        bit                         ats_ctl_atc_enable;             // ATS CSR
        HqmAtsPkg::PageSize_t       ats_ctl_ats_stu;                // ATS CSR
        bit                         pasid_ctl_pasid_enable;         // PASID CSR
        bit                         pri_ctl_page_request_enable;    // Page Request CSR
    } csr_t;        // This provides the IOMMU with HQM's CSR configuration state

    // Device CSR is indexed by BDF
    csr_t   device_list_csr [bit [15:0]];

    typedef bit [15:0] device_bdf_q_t [$];
    protected bit [15:0] device_bdf_q [$];

    bit    run_tracker_selftest= 0;
    bit    run_checker_selftest= 0;

    int  setPRSDelay = 0;

    int  atsMinDelay = $rtoi(100ns);
    int  atsMaxDelay = $rtoi(100ns);
    bit                     disable_legal_ats_check = 0;    // Disable the ATS check checking for all legal ATS reqs to be seen.

    bit                     disable_cg_sampling;           // If set, will disable sampling TB cover groups
    


    // -------------------------------------------------------------------------
    function new (string name="HqmAtsCfgObj");
        super.new(name);
    endfunction

    // -------------------------------------------------------------------------
    function void set_disable_tb_report_severity_settings(bit dis=1);
        disable_tb_report_severity_settings = dis;
    endfunction

    // -------------------------------------------------------------------------
    function bit get_disable_tb_report_severity_settings();
        return disable_tb_report_severity_settings;
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   set_iosfpif_params()
    // Description  :
    //
    function void set_iosfpif_params (string port_direction, int data_bitwidth);
        case (port_direction)
            "m" : iosfpif_m_params.data_bitwidth = data_bitwidth+1;
            "t" : iosfpif_t_params.data_bitwidth = data_bitwidth+1;
            default  : `uvm_fatal(get_type_name(), "set_iosfpif_params(): modport='%s'can only be set to string value of 'm' or 't'")
        endcase
    endfunction : set_iosfpif_params


    // -------------------------------------------------------------------------
    // Function     : push_device_ats_csr()
    // Description  : setup the iommu with information about
    //                the device associated with supplied bdf.
    //                The setup will reflect the environment's
    //                intent for ATS, PASID, and PRS services.
    //
    function void push_device_ats_csr ( bit [15:0]  device_bdf= 0 ,
                                        bit         ats_en    = 0 ,
                                        bit         pasid_en  = 0 ,
                                        bit         prs_en    = 0 ,
                                        PageSize_t  ats_stu   = PAGE_SIZE_4K );

       this.device_list_csr[device_bdf].ats_ctl_atc_enable           = ats_en;
       this.device_list_csr[device_bdf].ats_ctl_ats_stu              = ats_stu;
       this.device_list_csr[device_bdf].pasid_ctl_pasid_enable       = pasid_en;
       this.device_list_csr[device_bdf].pri_ctl_page_request_enable  = prs_en;

       device_bdf_q.push_back(device_bdf);

    endfunction : push_device_ats_csr



    // -------------------------------------------------------------------------
    // Function     : print_device_ats_csr()
    // Description  :
    //
    function void print_device_ats_csr ();

       foreach (device_list_csr[device_bdf]) begin
       `uvm_info(get_type_name(), $sformatf("print_device_ats_csr(): +-------------- IOMMU's copy of device CSRs -------------+"                                                            ), UVM_NONE);
       `uvm_info(get_type_name(), $sformatf("print_device_ats_csr(): |\tIOMMU [BDF = 0x%H]\tdevice [BDF = 0x%H].CSR.ATS_EN   = '%s',", iommu_bdf, device_bdf, (this.device_list_csr[device_bdf].ats_ctl_atc_enable         ? "YES": "NO" ) ), UVM_NONE);
       `uvm_info(get_type_name(), $sformatf("print_device_ats_csr(): |\tIOMMU [BDF = 0x%H]\tdevice [BDF = 0x%H].CSR.ATS_STU  = '%s',", iommu_bdf, device_bdf,  this.device_list_csr[device_bdf].ats_ctl_ats_stu.name()                     ), UVM_NONE);
       `uvm_info(get_type_name(), $sformatf("print_device_ats_csr(): |\tIOMMU [BDF = 0x%H]\tdevice [BDF = 0x%H].CSR.PASID_EN = '%s',", iommu_bdf, device_bdf, (this.device_list_csr[device_bdf].pasid_ctl_pasid_enable     ? "YES": "NO" ) ), UVM_NONE);
       `uvm_info(get_type_name(), $sformatf("print_device_ats_csr(): |\tIOMMU [BDF = 0x%H]\tdevice [BDF = 0x%H].CSR.PRS_EN   = '%s',", iommu_bdf, device_bdf, (this.device_list_csr[device_bdf].pri_ctl_page_request_enable? "YES": "NO" ) ), UVM_NONE);
       end 
       `uvm_info(get_type_name(), $sformatf("print_device_ats_csr(): +-------------------------------------------------------+"                                                            ), UVM_NONE);

    endfunction : print_device_ats_csr



    // -------------------------------------------------------------------------
    // Function     :   display_cfg
    // Description  :
    //
    function void display_cfg ();

        `uvm_info(get_type_name(), $sformatf("display_cfg(): +----------- IOMMU CFG Configuration ---------+"                        ), UVM_NONE);
        `uvm_info(get_type_name(), $sformatf("display_cfg(): |\tIOMMU BDF=0x%H is %s",  this.iommu_bdf, is_active.name()             ), UVM_NONE);
        `uvm_info(get_type_name(), $sformatf("display_cfg(): +---------------------------------------------+"                        ), UVM_NONE);
        // Tracker Info
        `uvm_info(get_type_name(), $sformatf("display_cfg(): |\t\tIOMMU Tracker Enabled?  '%s'" , ((disable_tracker) ? "NO"  : "YES")), UVM_NONE);
        if (! this.disable_tracker)
        `uvm_info(get_type_name(), $sformatf("display_cfg(): |\t\tIOMMU Tracker Filename: '%s'" , TRACKER_FILENAME                   ), UVM_NONE);

        // Checker Info
        `uvm_info(get_type_name(), $sformatf("display_cfg(): |\t\tIOMMU Checker Enabled?  '%s'" , ((disable_checker) ? "NO"  : "YES")), UVM_NONE);
        if (! this.disable_checker)
        `uvm_info(get_type_name(), $sformatf("display_cfg(): |\t\tIOMMU Checker Filename: '%s'" , CHECKER_FILENAME                   ), UVM_NONE);

        `uvm_info(get_type_name(), $sformatf("display_cfg(): +---------------------------------------------+"                        ), UVM_NONE);

    endfunction : display_cfg



    // -------------------------------------------------------------------------
    // Function     :   get_iommu_bdf()
    // Description  :
    //
    function bit [15:0] get_iommu_bdf ();
        return this.iommu_bdf;
    endfunction



    // -------------------------------------------------------------------------
    // Function     :   get_device_bdf_q()
    // Description  :
    //
    function device_bdf_q_t get_device_bdf_q();
        if (! device_bdf_q.size())begin
            `uvm_fatal(get_type_name(), "device_bdf_q(): device_bdf_q is empty! Cannot return.")
        end 

        return device_bdf_q;
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   is_device_ats_enabled()
    // Description  :   given a BDF of a device, return 1 if the device has ATS enabled.
    //                  return 0, otherwise.
    //
    function bit is_ats_en ( bit [15:0] device_bdf );

        `uvm_info (get_type_name(), $sformatf("is_ats_en(): Requestor ID: %0d", device_bdf), UVM_LOW);

        print_device_ats_csr();

        if ( this.is_active==UVM_ACTIVE && ! device_list_csr.exists(device_bdf) ) begin
            `uvm_error(get_type_name(), $sformatf("is_ats_en(): device_list_csr[%h] does not exist", device_bdf))
        end 

        return this.is_active==UVM_ACTIVE && device_list_csr.exists(device_bdf) && device_list_csr[device_bdf].ats_ctl_atc_enable;
    endfunction : is_ats_en


    // -------------------------------------------------------------------------
    // Function     :   get_range
    // Description  :   input is 64b invalidation logical address (range encoded in lower bits)
    //                  returns enum range size
    //
    function HqmAtsPkg::RangeSize_t   get_range (bit [63:0] address);

        case ( {address[63:12], address[11]} ) inside
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX, 1'b0}   : return HqmAtsPkg::RANGE_4K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX0, 1'b1}   : return HqmAtsPkg::RANGE_8K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX01, 1'b1}   : return HqmAtsPkg::RANGE_16K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X011, 1'b1}   : return HqmAtsPkg::RANGE_32K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_0111, 1'b1}   : return HqmAtsPkg::RANGE_64K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX0_1111, 1'b1}   : return HqmAtsPkg::RANGE_128K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX01_1111, 1'b1}   : return HqmAtsPkg::RANGE_256K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X011_1111, 1'b1}   : return HqmAtsPkg::RANGE_512K;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_0111_1111, 1'b1}   : return HqmAtsPkg::RANGE_1M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX0_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_2M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX01_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_4M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X011_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_8M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_0111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_16M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX0_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_32M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX01_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_64M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X011_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_128M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_0111_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_256M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX0_1111_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_512M;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX01_1111_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_1G;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X011_1111_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_2G;
            {53'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_0111_1111_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_4G;
            {53'b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111, 1'b1}   : return HqmAtsPkg::RANGE_ALL;
            default : `uvm_error(get_name(), $sformatf("^^^Unknown LSBs on bits 31:12 for address = 0x%h", address))
        endcase

    endfunction : get_range

    // Returns the physical address that is aligned with the range specified
    function bit [63:0] get_pa_range_aligned(bit [63:0] pa);
        HqmAtsPkg::RangeSize_t range_size = get_range(pa);
        bit [63:0]             mask       = get_mask(range_size);
        
        return (pa & mask);
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   get_pa_4k
    // Description  :   returns 4k-aligned LA's 4k-aligned PA
    //
    function bit [63:0] get_pa_4k (bit [63:0] la, bit [63:0] pa);

        HqmAtsPkg::RangeSize_t range_size = get_range(pa);
        bit [63:0] range = range_size;
        bit [63:0] mask  = get_mask(range);
        bit [63:0] la_base, pa_base;
        bit [63:0] offset;

        la_base = la & mask;
        pa_base = pa & mask;

        offset  = (la & -64'h1000) - la_base;

// $display("<><> la 0x%h\tpa 0x%h\tLA base 0x%h\tPA base 0x%h\trange %s\trange 0x%h\toffset 0x%h\tmask 0x%h\tpa_4k 0x%h", la, pa, la_base, pa_base, range_size.name(), range, offset, mask, pa_base+offset);

        return pa_base + offset;
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_baddr_and_num4k
    // Description  :   returns base addr and # of 4k slices
    //
    function void get_baddr_and_num4k (output bit [63:0] base_addr, int unsigned num_4k,
                                       input  bit [63:0] addr);

        bit [63:0] range = get_range(addr);
        bit [63:0] mask  = get_mask(range);


        base_addr = addr & mask;
        num_4k = 2**($clog2(range)-12);

        // `uvm_info (get_name(), $sformatf(""), UVM_LOW)
        // `uvm_info (get_name(), $sformatf("+ get_baddr_and_num4k(): addr = 0x%h\trange = %s\tbase_addr = 0x%h\tnum_4k = %0d\t", addr, get_range(addr).name(), base_addr, num_4k), UVM_LOW)
        // `uvm_info (get_name(), $sformatf(""), UVM_LOW)
    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_baddr_and_range
    // Description  :   returns base addr and # of 4k slices
    //
    function void get_baddr_and_range (output bit [63:0] base_addr, HqmAtsPkg::RangeSize_t range,
                                       input  bit [63:0] addr);

        bit [63:0] mask;

        range = get_range(addr);
        mask  = get_mask(range);

        base_addr = addr & mask;

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   get_baddr_and_range
    // Description  :   returns base addr and # of 4k slices
    //
    function bit [63:0] get_mask ( bit [63:0] range );
        int unsigned position = $clog2(range);
        bit [63:0] mask;

        // for ( int i=63; i>=position; i-- ) begin
        //     mask[i] = 1'b1;
        // end 

        mask[position+:63] = '1;

        return mask;
     endfunction


    // -------------------------------------------------------------------------
    // Function     :   reverse_dw
    // Description  :   reverses d-word's byte order
    //
     function bit [31:0] reverse_dw ( bit [31:0] dw );
        return { dw[7:0], dw[15:8], dw[23:16], dw[31:24] };
     endfunction


    // -------------------------------------------------------------------------
    // Function     :   reverse_qw
    // Description  :   reverses q-word's byte order
    //
     function bit [63:0] reverse_qw ( bit [63:0] qw );
        return { qw[7:0], qw[15:8], qw[23:16], qw[31:24], qw[39:32], qw[47:40], qw[55:48], qw[63:56] };
     endfunction

     // -------------------------------------------------------------------------
     // Common function to decode whether a given request is an ATS request
     function bit is_ats_request(HqmBusTxn x);
         HqmCmdType_t cmd = x.getCmdType();
         
         return ((x.direction == HQM_IP_TX) && (x.at == HQM_AT_TRANSLATION_REQ) && (cmd inside {HQM_MRd32, HQM_MRd64}));
     endfunction
     
     // -------------------------------------------------------------------------
     // Common function to decode whether a given completion is an ATS response
     function bit is_ats_response(HqmBusTxn x);
         HqmCmdType_t cmd = x.getCmdType();
         bit [15:0] completer_id = x.address[31:16];
         // Note: This check takes a short-cut by assuming any completion from the expected iommu BDF is an ATS completion. 
         return ( (completer_id == get_iommu_bdf()) && (x.direction == HQM_IP_RX) && (cmd inside {HQM_Cpl, HQM_CplD}) );
     endfunction
     
     // -------------------------------------------------------------------------
     // Common function to decode whether a given transaction is an Invalidation
     function bit is_invalidation_request(HqmBusTxn x);
         HqmCmdType_t cmd = x.getCmdType();
         bit [7:0] message_code = x.getMsgCode();
         
         return ( (message_code==8'b0000_0001) && (x.direction == HQM_IP_RX) && (cmd inside {HQM_MsgD2}) );
     endfunction
     
     // -------------------------------------------------------------------------
     // Common function to decode whether a given transaction is an Invalidation Response
     function bit is_invalidation_response(HqmBusTxn x);
         HqmCmdType_t cmd = x.getCmdType();
         bit [ 7:0] message_code = x.getMsgCode();
         
         return ( (message_code==8'b0000_0010) && (x.direction == HQM_IP_TX) && (cmd inside {HQM_Msg2}) );
     endfunction
     
     // -------------------------------------------------------------------------
     // Common function to decode whether a given transaction is an Page Request
     function bit is_page_request(HqmBusTxn x);
         HqmCmdType_t cmd = x.getCmdType();
         bit [7:0] message_code = x.getMsgCode();
         
         return ( (message_code==8'b0000_0100) && (x.direction == HQM_IP_TX) && (cmd inside {HQM_Msg0}) );
     endfunction
     
     // -------------------------------------------------------------------------
     // Common function to decode whether a given transaction is an Page Group Response
     function bit is_page_group_response(HqmBusTxn x);
         HqmCmdType_t cmd = x.getCmdType();
         bit [7:0] message_code = x.getMsgCode();
         
         return ( (message_code==8'b0000_0101) && (x.direction == HQM_IP_RX) && (cmd inside {HQM_Msg2}) );
     endfunction
     
endclass : HqmAtsCfgObj
