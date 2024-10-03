// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright 2018 - 2019 Intel Corporation
//
// The  source  code  contained or described herein and all documents related to
// the source code ("Material") are  owned by Intel Corporation or its suppliers
// or  licensors. Title to  the  Material  remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets  and proprietary
// and confidential information of Intel or  its  suppliers  and  licensors. The
// Material is protected by worldwide copyright and trade secret laws and treaty
// provisions.  No  part  of  the  Material  may  be used,   copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No  license  under  any patent, copyright, trade secret or other intellectual
// property  right is granted to or conferred upon you by disclosure or delivery
// of  the  Materials, either  expressly,  by  implication, inducement, estoppel
// or  otherwise. Any  license  under  such intellectual property rights must be
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
//
// Owner:       Adil Shaaeldin
// Created On:  1/25/2017
// Description: HQM's IO Memory Management Unit API
//              -----------------------------------
//
//              This testbench component class represents the frontend access to
//              the IOMMU Address Translation Service.
//
//              This class provides an interface to:
//
//                  request_address_translation     from the IOMMU an address translation (AT) entry in vector format
//                                                  (invokes parent class' read_address_translation()
//                                                  and returns address in 64b vector format)
//
//                  request_address_translation_4k  returns 4k-aligned PA
//
// -----------------------------------------------------------------------------

//--AY_HQMV30_ATS--  

class HqmIommuAPI extends HqmIommu;

    `ovm_component_utils(HqmIommuAPI)

    const int NUM_SUPPORTED_ITAGS = 32;
    
    protected semaphore _itag_semaphores;
    protected int       _ireq_watchdog_timeout_us = 20;
    
    // --- PRS Interface ---
    ovm_event_pool      prs_epool;
    ovm_event           prsp_ev;
    PageResponseFields  prsp_fields;
    protected HqmAtsPkg::page_request_q_t   m_prg_table [bit [15:0]][bit [8:0]];


    // --- INV Request Interface ---
    static protected bit itag_available_list [$];



    // -------------------------------------------------------------------------
    function new (string name = "HqmIommuAPI", ovm_component parent = null);
        super.new(name, parent);

    endfunction


    // -------------------------------------------------------------------------
    function void build ();
        super.build();

        `ovm_info(get_name(), $sformatf("build() : Building ITAG table of '%0d' entries", NUM_SUPPORTED_ITAGS), OVM_LOW);

        for ( int idx=0 ; idx < NUM_SUPPORTED_ITAGS ; idx++ ) begin : ITAGV
            itag_available_list.push_back(1);
        end
        _itag_semaphores = new(NUM_SUPPORTED_ITAGS);

    endfunction


    // Run Phase ---------------------------------------------------------------
    virtual task run ();
    
    endtask


    // Address Translation Request Interface API -------------------------------

    virtual function void set_ireq_watchdog_timeout(int timeout);
        _ireq_watchdog_timeout_us = timeout;
    endfunction

    // -------------------------------------------------------------------------
    // Function     :   request_address_translation()
    // Description  :
    //
    virtual function bit [63:0] request_address_translation (input  bit [15:0]      bdf,
                                                                    HqmPasid_t      pasidtlp,
                                                                    bit [63:0]      logical_address);

        HqmIommuEntry   translation;
        string          pasid_str = get_pasid_str(pasidtlp);

        ovm_report_info (get_type_name(), $sformatf("request_address_translation(): BDF=0x%H\tPASID=%s\tLogical Address = 0x%H", bdf, pasid_str, logical_address), OVM_LOW);

        translation = read_address_translation(bdf, pasidtlp, logical_address);

        if (translation) begin
                bit [63:0]      packed_address = translation.get_packed();

                // If Priv Mode request is unset while entry has privileged, then return void translation (i.e. lowest 2 bits 2'b00)
                if ( ~pasidtlp.priv_mode_requested && translation.privileged_mode_access ) begin
                    packed_address[1:0] = 2'b00;
                end

                // If Exe request is unset while entry has Exe Permitted, then return void translation (i.e. lowest 2 bits 2'b00)
                if  ( ~pasidtlp.exe_requested && translation.execute_permitted ) begin
                    packed_address[1:0] = 2'b00;
                end

                // if NW=1 then randomize whether W is returned or not
                if ( (packed_address[1:0]!=2'b00) && (logical_address[0]==1) ) begin
                    packed_address[1] = $urandom_range(0, 1);
                    ovm_report_info (get_type_name(), $sformatf("request_address_translation(): requested NW = 1 ... actual entry's W = %b ... randomization will cause W = %b", translation.write_permission, packed_address[1]), OVM_LOW);
                end

                ovm_report_info (get_type_name(), $sformatf("request_address_translation(): BDF=0x%H\tPASID=%s\tLogical Address = 0x%H ... returning ... PA = 0x%h", bdf, pasid_str, logical_address, packed_address), OVM_LOW);
                
                packed_address[4] =  pasidtlp.priv_mode_requested;       // bit 4 = priv
                
                return packed_address;

        end else begin
            bit [63:0]      packed_address;
            packed_address[4] = pasidtlp.priv_mode_requested;       // bit 4 = priv
            ovm_report_info (get_type_name(), $sformatf("request_address_translation(): trans failure : BDF=0x%H\tPASID=%s\tLogical Address = 0x%H ... returning ... PA = 0x%h", bdf, pasid_str, logical_address, packed_address), OVM_LOW);
            return packed_address;
        //     `ovm_error(get_type_name(), $sformatf("request_address_translation(): XLT Table [BDF=0x%H] [PASID=%s] does not exist.", bdf, get_pasid_str(prefix)))
        end


    endfunction : request_address_translation


    // -------------------------------------------------------------------------
    // Function     :   request_address_translation_4k()
    // Description  :
    //
    virtual function bit [63:0] request_address_translation_4k (input   bit [15:0]      bdf,
                                                                        HqmPasid_t      pasidtlp,
                                                                        bit [63:0]      la_4k); // must be 4k aligned

        bit [63:0] pa_raw, pa_4k;

        if ( la_4k[11:0] ) begin
            `ovm_fatal(get_name(), $sformatf("request_address_translation_4k(): la_4k[11:0] = 0x%h is nonzero", la_4k[11:0]))
        end

        pa_raw = request_address_translation( bdf, pasidtlp, la_4k );

        pa_4k  = ats_cfg.get_pa_4k( la_4k, pa_raw );

        return pa_4k;

    endfunction : request_address_translation_4k


    // Page Request Interface API ----------------------------------------------

    //                                        Each device can transmit a message with PRG that
    //                                        groups page requests from that device's
    //                                        multi-address spaces.

    // -------------------------------------------------------------------------
    // Function     :   preq_is_last()
    // Description  :   This subroutine performs the following steps:
    //                      (1) form a Page Request data structure
    //                      (2) log the Page Request in a queue of PRG page requests
    //                      (3) if last PRG request, call the vmm to resolve entire PRG
    //                      (4) form PRG response code based on PRG resolution
    //                      (5) delete the PRG queue
    //
    virtual function preq_is_last (input    bit [15:0]                      bdf,
                                            HqmPasid_t                      pasidtlp,
                                            bit [63:0]                      logical_address,
                                   output   HqmAtsPkg::page_request_q_t     page_request_q);

        string    pasid_str = get_pasid_str(pasidtlp);
        // Decode incoming Page Request
        bit [8:0] prg_index                 = logical_address[11:3];    // Page Request Group Index
        bit       prg_is_last_page_request  = logical_address[2];       // last Page Request
        bit       wr_access_requested       = logical_address[1];
        bit       rd_access_requested       = logical_address[0];

        // Additional helper variables that track outstanding page requests
        page_request_t          page_request;
        int                     index_q [$];
        bit return_code = 0;

        //-------------------------------------
        // (1) Form Page Request data structure
        //-------------------------------------
        // Determine what state the page request is in (i.e. is the page's address translation in IOMMU?)
        page_request.prg_index          = prg_index;
        page_request.bdf                = bdf;
        page_request.pasidtlp           = pasidtlp;
        page_request.logical_address    = logical_address;

        if (tlb_exists(bdf, pasidtlp) && m_map[bdf][pasid_str].entry_exists(logical_address)) begin
        // If page entry exists but the attributes aren't desirable, populate
        //      oustanding page request as "page is needed".
        //
        // If page entry exists but the requested attributes are available, designate
        //      the outstanding page request as "page is not needed" (i.e. page_is_needed=0).
        //
            page_request.page_is_needed =     (wr_access_requested            ? ~(m_map[bdf][pasid_str].read_entry(logical_address).write_permission            ) : 'bX)
                                            ||(rd_access_requested            ? ~(m_map[bdf][pasid_str].read_entry(logical_address).read_permission             ) : 'bX)
                                            ||(pasidtlp.priv_mode_requested   ? ~(m_map[bdf][pasid_str].read_entry(logical_address).privileged_mode_access  ) : 'bX)
                                            ||(pasidtlp.exe_requested         ? ~(m_map[bdf][pasid_str].read_entry(logical_address).execute_permitted       ) : 'bX);

            page_request.resolved       = (page_request.page_is_needed)? 1'b0 : 1'b1;
        end else begin
        // If page map entry does not exist, designate the outstanding page entry as "needed".
            page_request.page_is_needed = 1'b1;
            page_request.resolved       = 1'b0;
        end
        
        if( this.m_prg_table[bdf].exists(prg_index))
          `ovm_error(get_type_name(), $sformatf("preq_is_last(): prg_index item = 0x%h", page_request.prg_index))
 
        //---------------------------------------------------
        // (2) Log Page Request in queue of PRG page requests
        //---------------------------------------------------
        `ovm_info(get_type_name(), $sformatf("before insert m_prg_table[bdf][prg_index].size() : %0d, prg_index %0d",m_prg_table[bdf][prg_index].size(), prg_index), OVM_LOW)
        this.m_prg_table[bdf][page_request.prg_index].push_back(page_request);

        //--------------------------------------------------------
        // (3) if last page request, form queue of requested pages and return
        // boolean True.
        //--------------------------------------------------------
        if (prg_is_last_page_request) begin : LAST_PAGE_REQUEST

            index_q = m_prg_table[bdf][prg_index].unique_index();
            // note that index_q is a queue of unique outstanding page requests

            index_q.sort();

            // construct a new temporary page request queue
            foreach (index_q[i]) page_request_q.push_back(m_prg_table[bdf][prg_index][index_q[i]]);
            
          //Delete of PRGI index should happen after sending PRSP , not at PRS Req
          //  m_prg_table[bdf].delete(prg_index);
            
          //  `ovm_info(get_type_name(), $sformatf("after delete m_prg_table[bdf][prg_index].size() : %0d, prg_index %0d",m_prg_table[bdf][prg_index].size(), prg_index), OVM_LOW)
            
            return_code = 1;

        end : LAST_PAGE_REQUEST
        
        return return_code;

    endfunction : preq_is_last



    // -------------------------------------------------------------------------
    // Function     :   get_prg_response_code
    // Description  :   Returns PRG Response Code
    //
    virtual function bit [3:0] get_prg_response_code (input HqmAtsPkg::page_request_q_t  page_request_q);

        if (page_request_q.and() with (item.resolved)) return 4'b0000;   // SUCCESS
        else                                           return 4'b0001;   // INVALID REQUEST

    endfunction


    // // -------------------------------------------------------------------------
    // // Function     :   print_prg_request()
    // // Description  :   print the entire translation table
    // //
    // function void print_prg_request ();
    //     ovm_report_info(get_type_name(),           "\t>--------------------------------------------------------------------------------------", OVM_FULL);
    //     ovm_report_info(get_type_name(), $sformatf("\t> Page Request Group        = %0d", prg_index), OVM_FULL);
    //     ovm_report_info(get_type_name(), $sformatf("\t> Shortest Translation Unit = %s", stu.name()), OVM_FULL);
    //     ovm_report_info(get_type_name(),           "\t>--------------------------------------------------------------------------------------", OVM_FULL);
    //     ovm_report_info(get_type_name(),           "\t> [   PASID   ] [   lookup_address   ] L | W | R", OVM_FULL);
    //     ovm_report_info(get_type_name(),           "\t>--------------------------------------------------------------------------------------", OVM_FULL);
    // endfunction


    // function void print_prg_table_header();
    // endfunction

    // -------------------------------------------------------------------------
    // Function     :   send_prsp
    // Description  :   trigger event that creates, populates, and sends
    //                  PRS sequence via IOSF BFM.
    //                  See PCIE 4p0 Address Translation Service
    //
    function void send_prsp (input bit [ 7:0] prsp_tag,
                                   bit [15:0] prsp_destination_id,
                                   PrsRspSts_t prsp_prg_response_code,
                                   HqmPasid_t  pasidtlp,
                                   bit [ 8:0] prsp_prg_index
                                );

        fork
            begin
            // forever begin
                HqmAtsPrspSeq              prsp_seq;

                int wait_time = $urandom_range(100, 400);

                PageResponseFields  prsp_fields;

                ovm_report_info(get_type_name(),"send_prsp(): ------- BEGIN -------",   OVM_NONE);

                prsp_fields = new("prsp_fields");

                prsp_fields.tag                 = prsp_tag;
                prsp_fields.destination_id      = prsp_destination_id;
                prsp_fields.prg_index           = prsp_prg_index;
                prsp_fields.pasidtlp            = pasidtlp;

                case (prsp_prg_response_code)
                    PRSRSP_SUCCESS          : prsp_fields.prg_response_code   = HqmPciePrgRspCode_t'(4'h0);
                    PRSRSP_INVALID_REQUEST  : prsp_fields.prg_response_code   = HqmPciePrgRspCode_t'(4'h1);
                    PRSRSP_RESPONSE_FAILURE : prsp_fields.prg_response_code   = HqmPciePrgRspCode_t'(4'hF);
                endcase

                case ( ats_cfg.setPRSDelay )
                    0 : begin
                        wait_time = 0;
                    end

                    1 : begin
                        wait_time = $urandom_range(100, 1000);
                    end

                    2 : begin
                        wait_time = $urandom_range(1000, 4000);
                    end
                    3 : begin
                        wait_time = $urandom_range(10, 40);
                    end
                    4 : begin
                        wait_time = $urandom_range(46000, 56000);
                    end
                    -1 : begin
                        wait_time = $urandom_range(10, 500);
                    end
                endcase
                
                if ($test$plusargs("PRS_DELAY")) begin
                    $value$plusargs("PRS_DELAY=%d", wait_time);
                end

                // prsp_ev.wait_on();

                prsp_seq = HqmAtsPrspSeq::type_id::create($sformatf("HqmAtsPrspSeq_PRGI_0x%H", prsp_fields.prg_index));
                prsp_seq.set_source(ats_cfg.agent_name);
                if (ats_cfg.is_bus_iCXL) begin
                    prsp_seq.is_icxl = 1;
                end
                // `sla_assert($cast(agt_sqr, prsp_seq.ifc_sqr), ("Could not cast 'ifc_sqr' to IosfAgtSeqr"));

                ovm_report_info(get_type_name(), $sformatf("send_prsp(): (PRG Index = 0x%h) \t detected PRS REQ ... sending PRS Response Message in %0d ns", prsp_fields.prg_index, wait_time), OVM_NONE);

                #(wait_time * 1ns);                

                ovm_report_info(get_type_name(), $sformatf("send_prsp(): (PRG Index = 0x%h) \t now sending PRS Response Message", prsp_fields.prg_index), OVM_NONE);

                prsp_seq.requestor_id   = get_bdf();
                prsp_seq.tag            = prsp_fields.tag;
                prsp_seq.destination_id = prsp_fields.destination_id;
                prsp_seq.response_code  = prsp_fields.prg_response_code;
                prsp_seq.prg_index      = prsp_fields.prg_index;
                prsp_seq.pasidtlp       = prsp_fields.pasidtlp;

                // prsp_ev.reset();

                prsp_seq.start(prsp_seq.ifc_sqr);
                this.m_prg_table[prsp_destination_id].delete(prsp_fields.prg_index);
                ovm_report_info(get_type_name(),"send_prsp(): ------- END   -------\n", OVM_NONE);
            end
        join_none

    endfunction


    // -------------------------------------------------------------------------
    // Function     :   send_ireq
    // Description  :   interface for ATS Invalidation Request Message
    //                  See PCIE 4p0 Address Translation Service
    //
    //                  Accepts invalidation address and range
    //                  and creates a valid invalidation address field
    //                  for the ATS IREQ TLP. Valid encodings equilvent to
    //                  ATS Address Translation Completion (see ATS spec for more)
    //
    task send_ireq (output  bit [4:0]    ireq_itag,  // task returns the itag with which the request was issued
                    input   bit [15:0]   ireq_requester_id,
                            bit [15:0]   ireq_destination_id,
                            // pasid_prefix_t    ireq_pasid,
                            bit          ireq_pasid_valid,
                            bit [19:0]   ireq_pasid,
                            bit [63:0]   ireq_la_address,                         // desired invalidation address
                            HqmAtsPkg::RangeSize_t  ireq_range = HqmAtsPkg::PAGE_SIZE_4K,    // desired invalidaiton range

                            bit          ireq_global_invalidate = 0,
                            // Custom switches to enable error scenarios, default is to have no error
                            bit          enable_dpe_err = 0,
                            bit          enable_ep_err = 0
                          );
        HqmAtsIreqSeq  ireq_seq;
        ovm_event      inv_req_full;
        ovm_event_pool inv_ev_pool  = ovm_event_pool::get_global_pool();
        int            idx_q[$];

        bit [63:0] inv_addr;
        bit [63:0] mask_lower;
        bit [63:0] mask_upper = HqmAtsPkg::MASK_4K;
        int num_ones;
        sla_status_t    reg_status;
        sla_ral_data_t  reg_data_vc0ctl [$];
        sla_ral_data_t  reg_data_vc1ctl [$];
        bit [7:0] vc0_tcvc_map, vc1_tcvc_map;
        string header = "send_ireq()";
        
        mask_lower  = -vector_t'(ireq_range);
        mask_lower  = ~mask_lower;
        num_ones    = $countones(mask_lower);
        mask_lower  = MASK_4K & mask_lower;

        mask_upper[num_ones-1]  = 0;
        mask_lower[num_ones-1]  = 0;

        if (&ireq_la_address[63:12]) begin
            inv_addr = ireq_la_address; // Invalidate all
            inv_addr[63] = 0;
        end else begin
            inv_addr = (ireq_la_address & mask_upper) | mask_lower;
        end
        inv_addr[11]= (ireq_range==HqmAtsPkg::RANGE_4K) ? 1'b0 : 1'b1;

       `ovm_info(get_name(), $sformatf("%s : DEBUG : Before  itag semaphore if condition : Start sending invalidation for addr = 0x%h", header,inv_addr), OVM_LOW); 
        if ( ! _itag_semaphores.try_get(1) ) begin
             inv_req_full = inv_ev_pool.get("inv_req_full");
             `ovm_info(get_name(), $sformatf("%s : ... trigger inv_req_full", header), OVM_HIGH);
             inv_req_full.trigger();
            
            fork
                begin
                    `ovm_info(get_name(), $sformatf("%s : Waiting for available itag", header), OVM_LOW);
                    _itag_semaphores.get(1);
                    `ovm_info(get_name(), $sformatf("%s : Waiting for available itag DONE", header), OVM_LOW);
                end 
                ireq_itag_watchdog(inv_addr);
            join_any
            disable fork;
        end
        
        idx_q = itag_available_list.find_index() with ( item == 1 );
        idx_q.shuffle();
        if ( idx_q.size() < 1 ) begin
            `ovm_fatal(get_name(), $sformatf("%s : No available itags, should not have reached here", header));
            return;
        end 
        ireq_itag = idx_q[0];
        itag_available_list[ireq_itag] = 0; // Tag it as invalid

        ireq_seq = HqmAtsIreqSeq::type_id::create($sformatf("HqmAtsIreqSeq_InvAddr_0x%H", inv_addr));
        ireq_seq.ats_cfg = ats_cfg;
        ireq_seq.set_source(ats_cfg.agent_name);

        // ats_cfg.reg_ptr["VC0CTL"].read_fields( reg_status, '{"VCEN"       }, reg_data_vc0ctl_vcen,       "backdoor" );
        // ats_cfg.reg_ptr["VC0CTL"].read_fields( reg_status, '{"TCVCMAP_0_0"}, reg_data_vc0ctl_tcvcmap_00, "backdoor" );
        // ats_cfg.reg_ptr["VC0CTL"].read_fields( reg_status, '{"TCVCMAP_7_1"}, reg_data_vc0ctl_tcvcmap_71, "backdoor" );

        // ats_cfg.reg_ptr["VC1CTL"].read_fields( reg_status, '{"VCEN"       }, reg_data_vc1ctl_vcen,       "backdoor" );
        // ats_cfg.reg_ptr["VC1CTL"].read_fields( reg_status, '{"TCVCMAP_0_0"}, reg_data_vc1ctl_tcvcmap_00, "backdoor" );
        // ats_cfg.reg_ptr["VC1CTL"].read_fields( reg_status, '{"TCVCMAP_7_1"}, reg_data_vc1ctl_tcvcmap_71, "backdoor" );

        // these handles will be null for IAX LNL
        //--AY_HQMV30_ATS_NO_USE??  if (ats_cfg.reg_ptr["VC0CTL"] != null && ats_cfg.reg_ptr["VC1CTL"] != null) begin
        //--AY_HQMV30_ATS_NO_USE??      ats_cfg.reg_ptr["VC0CTL"].read_fields( reg_status, '{"VCEN", "TCVCMAP_0_0", "TCVCMAP_7_1"}, reg_data_vc0ctl, "backdoor" );
        //--AY_HQMV30_ATS_NO_USE??      ats_cfg.reg_ptr["VC1CTL"].read_fields( reg_status, '{"VCEN", "TCVCMAP_0_0", "TCVCMAP_7_1"}, reg_data_vc1ctl, "backdoor" );
        //--AY_HQMV30_ATS_NO_USE??  end

        if ( ireq_global_invalidate ) begin
        // Global Invalidation requires PASID TLP prefix
            ireq_pasid_valid |= ireq_global_invalidate;     // valid PASID TLP prefix is needed

        // Globally invalidated address is indifferent to PASID, so we'll mask the PASID
            ireq_pasid  = 0;                                // zero out the PASID
        end

        if (ireq_pasid_valid == 0) begin
            ireq_pasid = 0; 
        end 
        
        
        ireq_seq.requester_id   = ireq_requester_id; //get_bdf();
        ireq_seq.itag           = ireq_itag;
        ireq_seq.destination_id = ireq_destination_id;
        ireq_seq.inv_pasid      = {ireq_pasid_valid, 1'b0, 1'b0, ireq_pasid};
        ireq_seq.inv_addr       = inv_addr;
        ireq_seq.inv_addr[0]    = ireq_global_invalidate & ireq_pasid_valid;
        ireq_seq.range_str      = ats_cfg.get_range(inv_addr).name();
        
        ireq_seq.enable_dpe_err = enable_dpe_err;
        ireq_seq.enable_ep_err = enable_ep_err;

        `ovm_info(get_name(), $sformatf("%s : Sending IREQ to Addr=0x%016h requester_id=0x%0x ITAG= %0d (0x%02h)  Global Invalidate=%0b  ireq_global_invalidate=%0b  ireq_pasid_valid=%0b  ireq_pasid=0x%05h",
                                         header, ireq_seq.inv_addr, ireq_seq.requester_id, ireq_seq.itag, ireq_seq.itag, ireq_seq.inv_addr[0], ireq_global_invalidate, ireq_pasid_valid, ireq_pasid), OVM_NONE);
                            
        // VC#CTL
        // these handles will be null for IAX LNL
        //--AY_HQMV30_ATS_NO_USE??  if (ats_cfg.reg_ptr["VC0CTL"] != null && ats_cfg.reg_ptr["VC1CTL"] != null) begin
        //--AY_HQMV30_ATS_NO_USE??      vc0_tcvc_map = {reg_data_vc0ctl[2][6:0], reg_data_vc0ctl[1][0]};
        //--AY_HQMV30_ATS_NO_USE??      vc1_tcvc_map = {reg_data_vc1ctl[2][6:0], reg_data_vc1ctl[1][0]};

        //--AY_HQMV30_ATS_NO_USE??      `ovm_info(get_name(), $sformatf("%s : VC0CTL - TC[7:0] = 0x%h | VC1CTL - TC[7:0] = 0x%h", header, vc0_tcvc_map, vc1_tcvc_map ), OVM_NONE);

        //--AY_HQMV30_ATS_NO_USE??      ireq_seq.set_vc_en(reg_data_vc0ctl[0], reg_data_vc1ctl[0]);
        //--AY_HQMV30_ATS_NO_USE??      ireq_seq.set_tcvc_map(vc0_tcvc_map, vc1_tcvc_map);
        //--AY_HQMV30_ATS_NO_USE??  end

        ireq_seq.start(ireq_seq.ifc_sqr);

        `ovm_info(get_name(), $sformatf("%s : Sending IREQ to Addr=0x%016h  ITAG= %0d (0x%02h)  Global Invalidate=%0b  ireq_global_invalidate=%0b  ireq_pasid_valid=%0b  ireq_pasid=0x%05h DONE",
                                         header, ireq_seq.inv_addr, ireq_seq.itag, ireq_seq.itag, ireq_seq.inv_addr[0], ireq_global_invalidate, ireq_pasid_valid, ireq_pasid), OVM_NONE);
        
        #1ns;

      //if($test$plusargs("HQMV30_ATS_INV_RESP_WAIT")) begin 
        fork wait_irsp(ireq_itag, OVM_PASSIVE, .recycle(1)); join_none
      //end//if($test$plusargs("HQMV30_ATS_INV_RESP_WAIT"))  

    endtask : send_ireq
    

    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    task wait_irsp (input bit [4:0] itag, ovm_active_passive_enum blocking_type=OVM_ACTIVE, bit recycle=0);
        ovm_event_pool ev_pool  = ovm_event_pool::get_global_pool();
        string         ev_name  = $sformatf("%s__itag_%0d", HqmAtsPkg::HQM_ATS_IRSP_E, itag);
        ovm_event      ats_irsp_ev = ev_pool.get(ev_name);
        realtime       start_time, finish_time, elapsed_time;

        start_time = $realtime;

        if ( itag_available_list[itag] == 1 ) begin
            `ovm_error(get_name(), $sformatf("wait_irsp(): IREQ itag = %0d (0x%h) should not be available\t(blocking type = %s)", itag, itag, blocking_type.name() ))
            return;
        end

        `ovm_info(get_name(), $sformatf("wait_irsp(): Waiting for IRSP where itagv[%0d (0x%0h)] = 1 wait_on event ats_irsp_ev with ev_name=%0s \t(blocking type = %s)", itag, itag, ev_name, blocking_type.name() ), OVM_LOW)

        ats_irsp_ev.wait_on();
        finish_time = $realtime;
        elapsed_time = (finish_time - start_time)/1000;

        `ovm_info(get_name(), $sformatf("wait_irsp(): Detected IRSP where itagv[%0d (0x%h)] = 1 \tafter %.2f ns (blocking type = %s)", itag, itag, elapsed_time, blocking_type.name() ), OVM_LOW)

        ats_irsp_ev.reset();

        if ( recycle ) begin
            itag_available_list[itag] = 1;
            _itag_semaphores.put(1);
        end 
    endtask


    task ireq_itag_watchdog (bit [63:0] address);
        #(_ireq_watchdog_timeout_us * 1us);
        `ovm_error(get_name(), $sformatf("ireq_itag_watchdog(): TIMEOUT waiting '%0d'us for ITAG to get recycled to send IREQ to Addr=0x%016h", _ireq_watchdog_timeout_us, address));
    endtask


endclass : HqmIommuAPI
