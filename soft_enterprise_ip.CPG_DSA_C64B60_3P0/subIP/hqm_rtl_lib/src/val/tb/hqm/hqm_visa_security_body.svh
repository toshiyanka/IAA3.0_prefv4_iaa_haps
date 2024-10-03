// Command line was tools/visa/visa_OVM.pl -all_disable visa_all_dis -cust_disable visa_customer_dis -type ip -visa_top hqm_tb_top.u_hqm -vrc hqm_tb_top -visa tools/visa/hqm.sig -od verif/tb/hqm -on hqm_visa_security_body.svh -security_test -no_dsp

    // Update the .svh file to remove the variable declarations and task body.  This is now included here.
    logic vrc_busy;
    longint unsigned error_seen;
    string dfxsecure_paths[$];
    string mux_paths[int];
    int num_input_lanes[int];
    int num_output_lanes[int];
    int mux_has_min_latch[int];
    int visa_gid[int];
    int reg_start_id[int];
    int num_clocks[int];
    int my_bit_read_val;
    int dummy_mux[int];
    int visa2_mux[int];
    int plm_mux[int];
    int repeater[int];
    int plm_mux_has_gasket[int];
    int isTakerMux[int];
    int isNotBlackBoxed[int];
    int behind_cri[int];
    int cust_vis_top_lane[int];
    int oem_vis_top_lane[int];
    int old_policy_mux[int];
    string rtl_path;
    string rtl_val;
    string error_message;
    int test_sequence_loc;
    int test_type;
    int read_loop;
    int data;
    int parent_mux_id[int];
    int parent_input_lane_offset[int];
    int lane_width[int];
    int lane_offset;
    int allcr_offset;
    int ignore_dfxsecure_error[int];
    int num_internal_tests;
    int num_m2m_tests;
    int test_survivability;
    int test_single_through_clk;
    bit eb_debug_ctl_network;
    int max_num_clks_to_check;
    int internal_test_values[int];
    int m2m_test_values[int];
    int ignore_path_found = 0;
    string ignore_paths[$];
    int temp = 0;
    int value = 0;  
    bit global_test = 0;  	
    int working_clock_num = 0;
    int start_mux_num = 0;
    int end_mux_num = 0;
    int start_mux_num_sec = 0;
    int end_mux_num_sec = 0;
    int test_repeaters = 0;

    task body();   
        `ovm_info (get_name(), "Using visa_OVM.pl revision 2019ww11.1 for test generation.", OVM_MEDIUM);
         
        num_internal_tests = 2;   //FIXME
        num_m2m_tests = 4;
        test_single_through_clk = 1;
        eb_debug_ctl_network = 0;
        test_survivability = 0;
        
        if ($test$plusargs("test_single_through_clk")) begin
            test_single_through_clk = 1;
        end
        
        if ($test$plusargs("reduced_internals")) begin
            num_internal_tests = 2;
        end
        
        if ($test$plusargs("no_internals")) begin
            num_internal_tests = 0;
        end
        
        if ($test$plusargs("reduced_m2m")) begin
            num_m2m_tests = 2;
        end
        
        if ($test$plusargs("test_survivability")) begin
            test_survivability = 1;
        end
        
        internal_test_values[0] = 170;  // AA
        internal_test_values[1] = 85;   // 55
        internal_test_values[2] = 0;    // 0
        internal_test_values[3] = 255;  // FF
        m2m_test_values[0] = 85;
        m2m_test_values[1] = 0;
        m2m_test_values[2] = 170;
        m2m_test_values[3] = 255;

        mux_paths[0]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux0.i_hqm_visa_repeater_vcfn";
        num_input_lanes[0]=1;
        num_output_lanes[0]=1;
        mux_has_min_latch[0]=0;
        visa_gid[0]=0;
        reg_start_id[0]=0;
        num_clocks[0]=1;
        dummy_mux[0]=0;
        visa2_mux[0]=1;
        plm_mux[0]=0;
        repeater[0]=1;
        plm_mux_has_gasket[0]=0;
        parent_mux_id[0]=-1;
        parent_input_lane_offset[0]=-1;
        ignore_dfxsecure_error[0]=0;
        isTakerMux[0]=0;
        isNotBlackBoxed[0]=0;
        lane_width[0]=8;
        behind_cri[0]=0;
        cust_vis_top_lane[0]=1;
        oem_vis_top_lane[0]=1;
        old_policy_mux[0]=0;

        mux_paths[1]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux0.i_hqm_visa_mux_top_vcfn";
        num_input_lanes[1]=47;
        num_output_lanes[1]=1;
        mux_has_min_latch[1]=0;
        visa_gid[1]=1;
        reg_start_id[1]=0;
        num_clocks[1]=1;
        dummy_mux[1]=0;
        visa2_mux[1]=1;
        plm_mux[1]=0;
        repeater[1]=0;
        plm_mux_has_gasket[1]=1;
        parent_mux_id[1]=0;
        parent_input_lane_offset[1]=0;
        ignore_dfxsecure_error[1]=0;
        isTakerMux[1]=0;
        isNotBlackBoxed[1]=0;
        lane_width[1]=8;
        behind_cri[1]=0;
        cust_vis_top_lane[1]=0;
        oem_vis_top_lane[1]=0;
        old_policy_mux[1]=0;

        mux_paths[2]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux1.i_hqm_visa_repeater_vcfn";
        num_input_lanes[2]=1;
        num_output_lanes[2]=1;
        mux_has_min_latch[2]=0;
        visa_gid[2]=0;
        reg_start_id[2]=0;
        num_clocks[2]=1;
        dummy_mux[2]=0;
        visa2_mux[2]=1;
        plm_mux[2]=0;
        repeater[2]=1;
        plm_mux_has_gasket[2]=0;
        parent_mux_id[2]=-1;
        parent_input_lane_offset[2]=-1;
        ignore_dfxsecure_error[2]=0;
        isTakerMux[2]=0;
        isNotBlackBoxed[2]=0;
        lane_width[2]=8;
        behind_cri[2]=0;
        cust_vis_top_lane[2]=1;
        oem_vis_top_lane[2]=1;
        old_policy_mux[2]=0;

        mux_paths[3]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux1.i_hqm_visa_mux_top_vcfn";
        num_input_lanes[3]=32;
        num_output_lanes[3]=1;
        mux_has_min_latch[3]=0;
        visa_gid[3]=2;
        reg_start_id[3]=0;
        num_clocks[3]=1;
        dummy_mux[3]=0;
        visa2_mux[3]=1;
        plm_mux[3]=0;
        repeater[3]=0;
        plm_mux_has_gasket[3]=1;
        parent_mux_id[3]=2;
        parent_input_lane_offset[3]=0;
        ignore_dfxsecure_error[3]=0;
        isTakerMux[3]=0;
        isNotBlackBoxed[3]=0;
        lane_width[3]=8;
        behind_cri[3]=0;
        cust_vis_top_lane[3]=0;
        oem_vis_top_lane[3]=0;
        old_policy_mux[3]=0;

        mux_paths[4]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux2.i_hqm_visa_repeater_vcfn";
        num_input_lanes[4]=1;
        num_output_lanes[4]=1;
        mux_has_min_latch[4]=0;
        visa_gid[4]=0;
        reg_start_id[4]=0;
        num_clocks[4]=1;
        dummy_mux[4]=0;
        visa2_mux[4]=1;
        plm_mux[4]=0;
        repeater[4]=1;
        plm_mux_has_gasket[4]=0;
        parent_mux_id[4]=-1;
        parent_input_lane_offset[4]=-1;
        ignore_dfxsecure_error[4]=0;
        isTakerMux[4]=0;
        isNotBlackBoxed[4]=0;
        lane_width[4]=8;
        behind_cri[4]=0;
        cust_vis_top_lane[4]=1;
        oem_vis_top_lane[4]=1;
        old_policy_mux[4]=0;

        mux_paths[5]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux2.i_hqm_visa_mux_top_vcfn";
        num_input_lanes[5]=4;
        num_output_lanes[5]=1;
        mux_has_min_latch[5]=0;
        visa_gid[5]=3;
        reg_start_id[5]=0;
        num_clocks[5]=1;
        dummy_mux[5]=0;
        visa2_mux[5]=1;
        plm_mux[5]=0;
        repeater[5]=0;
        plm_mux_has_gasket[5]=1;
        parent_mux_id[5]=4;
        parent_input_lane_offset[5]=0;
        ignore_dfxsecure_error[5]=0;
        isTakerMux[5]=0;
        isNotBlackBoxed[5]=0;
        lane_width[5]=8;
        behind_cri[5]=0;
        cust_vis_top_lane[5]=0;
        oem_vis_top_lane[5]=0;
        old_policy_mux[5]=0;

        mux_paths[6]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux3.i_hqm_visa_repeater_vcfn";
        num_input_lanes[6]=1;
        num_output_lanes[6]=1;
        mux_has_min_latch[6]=0;
        visa_gid[6]=0;
        reg_start_id[6]=0;
        num_clocks[6]=1;
        dummy_mux[6]=0;
        visa2_mux[6]=1;
        plm_mux[6]=0;
        repeater[6]=1;
        plm_mux_has_gasket[6]=0;
        parent_mux_id[6]=-1;
        parent_input_lane_offset[6]=-1;
        ignore_dfxsecure_error[6]=0;
        isTakerMux[6]=0;
        isNotBlackBoxed[6]=0;
        lane_width[6]=8;
        behind_cri[6]=0;
        cust_vis_top_lane[6]=1;
        oem_vis_top_lane[6]=1;
        old_policy_mux[6]=0;

        mux_paths[7]="hqm_tb_top.u_hqm.par_hqm_system.hqm_system_aon_wrap.i_hqm_visa.i_hqm_visa_mux3.i_hqm_visa_mux_top_vcfn";
        num_input_lanes[7]=5;
        num_output_lanes[7]=1;
        mux_has_min_latch[7]=0;
        visa_gid[7]=4;
        reg_start_id[7]=0;
        num_clocks[7]=1;
        dummy_mux[7]=0;
        visa2_mux[7]=1;
        plm_mux[7]=0;
        repeater[7]=0;
        plm_mux_has_gasket[7]=1;
        parent_mux_id[7]=6;
        parent_input_lane_offset[7]=0;
        ignore_dfxsecure_error[7]=0;
        isTakerMux[7]=0;
        isNotBlackBoxed[7]=0;
        lane_width[7]=8;
        behind_cri[7]=0;
        cust_vis_top_lane[7]=0;
        oem_vis_top_lane[7]=0;
        old_policy_mux[7]=0;

        error_seen = 0;
        
        // Override for mux range selection - start mux
        if ($value$plusargs("start_mux_num=%d", value) || global_test) begin
            if (global_test) begin
                start_mux_num = 0;
                start_mux_num_sec = 0;
            end
            else begin
                start_mux_num = value;
                start_mux_num_sec = value;
            end
        end
        else begin
            start_mux_num = mux_paths.size()-1;
            start_mux_num_sec = 0;
        end

        // Override for mux range selection - end mux
        if ($value$plusargs("end_mux_num=%d", value) || global_test) begin
            if (global_test) begin
                end_mux_num = 0;
                end_mux_num_sec = 0;
            end
            else begin
                end_mux_num = value;
                end_mux_num_sec = value;
            end
        end
        else begin
            end_mux_num = 0;
            end_mux_num_sec = mux_paths.size()-1;
        end

        if (start_mux_num < 0  || end_mux_num < 0) begin
            error_message = $psprintf("Value of start_mux_num and end_mux_num must be greater than 0. Start_mux_num: %d, end_mux_num: %d", start_mux_num, end_mux_num);
            `ovm_fatal(get_name(), error_message);
        end

        if (start_mux_num > mux_paths.size()-1  || end_mux_num > mux_paths.size()-1) begin
            error_message = $psprintf("Value of start_mux_num and end_mux_num must be less than maximum muxes in tree. Start_mux_num: %d, end_mux_num: %d", start_mux_num, end_mux_num);
            `ovm_fatal(get_name(), error_message);
        end
             
        if (start_mux_num < end_mux_num) begin
            temp = end_mux_num;
            end_mux_num = start_mux_num;
            start_mux_num = temp;
        end
        
        test_type = 0; // IP testing or SS global testing

        test_sequence_loc = 0;
        
        `ovm_info(get_name(), $psprintf("Testing muxes from %0d to %0d", start_mux_num, end_mux_num), OVM_MEDIUM);    

    
        // Test all_dis and cust_dis
        test_cust_and_all_disable();
        
        // Force (no VRC write) visa_en bit and each output lane to use src_clk[0]
        set_visa_en();
        
        // Check input lanes observability based on the security policies -- NEW POLICIES
        check_input_lanes_observability(0);
        
        // Check input lanes observability based on the security policies -- OLD POLICIES
        check_input_lanes_observability(1);
    
        if (error_seen > 0) begin
            error_message = $psprintf("Saw %d ERRORS during test.", error_seen);
            `ovm_fatal(get_name(), error_message);
        end
    endtask : body

    task test_cust_and_all_disable;
        `ovm_info (get_name(), "Test all_dis and cust_dis for all muxes", OVM_MEDIUM);
    

        dfxsecure_paths.push_back("hqm_tb_top");

       /* for (int i=0; i<dfxsecure_paths.size(); i++) begin:i_for_dfxsec
            sla_vpi_put_value_by_name($psprintf("%s.fdfx_earlyboot_exit", dfxsecure_paths[i]), 1'b1 );
        end // for dfxsecure_paths */
        
        // testing 1 to 0, so it ends with all_dis and cus_dis at zero
        for (int all_dis = 1; all_dis>=0; all_dis--) begin:ad_for
            for (int cust_dis = 1; cust_dis>=0; cust_dis--) begin:cd_for
                update_test_sequence_loc();
                for (int i=0; i<dfxsecure_paths.size(); i++) begin:i_for
                    sla_vpi_put_value_by_name($psprintf("%s.visa_all_dis", dfxsecure_paths[i]), all_dis );
                    sla_vpi_put_value_by_name($psprintf("%s.visa_customer_dis", dfxsecure_paths[i]), cust_dis );
                    
                   /* sla_vpi_put_value_by_name($psprintf("%s.dfxsecure_feature_int[1]", dfxsecure_paths[i]), all_dis );
                    sla_vpi_put_value_by_name($psprintf("%s.dfxsecure_feature_int[0]", dfxsecure_paths[i]), cust_dis ); */
                    
                end // for dfxsecure_paths.size
                // Delay to prevent reads before writes
                #1ps
                for (int i=0; i<mux_paths.size(); i++) begin:i2_for
                    if ((dummy_mux[i] == 0) && (repeater[i] == 0))  begin
                        if (plm_mux[i] == 0) begin
                            if(isTakerMux[i] == 0) begin
                                update_test_sequence_loc();
                                wait_for_read_and_compare(i, "all_disable",all_dis, 0,ignore_dfxsecure_error[i]);
                                wait_for_read_and_compare(i, "customer_disable",cust_dis,0,ignore_dfxsecure_error[i]);
                            end //isTakerMux
                        end // if plm_mux == 0
                    end // if dummy_mux == 0
                end // for mux_paths.size
            end // for cust_dis
        end // for all_dis
    endtask
    
    task check_input_lanes_observability;
        input bit old_policy;
        begin
        
        bit[1:0] GREEN, BLACK, RED, ORANGE;
            
        int policies[$];
        
        string policies_name[bit[1:0]];
            
        int out_lane = 0;
        int out_lane_value = 0;
        int clock_index = 0;
        
        string forced_security_policy = get_str_arg("visa_security_policy", "");
        
        
        GREEN  = 2'b01;
        BLACK  = 2'b11; 
        RED    = 2'b00; 
        ORANGE = 2'b10;
        policies.push_back(GREEN);
        policies.push_back(BLACK);
        policies.push_back(RED);
        policies.push_back(ORANGE);
        // In the case we want to break down the test per color        
        
        if (forced_security_policy != "") begin
            policies = {};
            case (forced_security_policy)
                "GREEN": begin
                    policies.push_back(GREEN);
                end
                "BLACK": begin
                    policies.push_back(BLACK);
                end
                "RED": begin
                    policies.push_back(RED);
                end
                "ORANGE": begin
                    policies.push_back(ORANGE);
                end
            endcase
        end
            
        foreach (policies[policy]) begin           
            update_test_sequence_loc();
            
            // Write each policy to each secure plugin
            for (int i=0; i<dfxsecure_paths.size(); i++) begin
                sla_vpi_put_value_by_name($psprintf("%s.visa_all_dis", dfxsecure_paths[i]), policies[policy][1]);
                sla_vpi_put_value_by_name($psprintf("%s.visa_customer_dis", dfxsecure_paths[i]), policies[policy][0]);
                #30ns;
            end
                
            
            // Delay to prevent reads before writes    
            #1ps;                                      
                                                       
            // Iterate through every single mux in     the sig file
            for (int curr_mux=start_mux_num; curr_mux>=end_mux_num; curr_mux--) begin
                if (!dummy_mux[curr_mux] && !repeater[curr_mux] && !plm_mux[curr_mux] && !isTakerMux[curr_mux]) begin
                    
                    // Check if we are supposed to test this mux right now
                    // Old policy and new policy muxes combination
                    if (old_policy && !old_policy_mux[curr_mux]) continue;
                    // New policy and old policy muxes combination
                    if (!old_policy && old_policy_mux[curr_mux]) continue;
                    
                    `ovm_info (get_name(), $psprintf("Currently testing mux[%0d] %s with policy %s=%0d", curr_mux, mux_paths[curr_mux], policies_name[policies[policy]], policies[policy]), OVM_MEDIUM);
                    
                    update_test_sequence_loc();
                    
                                                                                           
                    `ovm_info (get_name(), $psprintf("Selected output_lane = %0d", out_lane), OVM_MEDIUM);
                    
                    // For each mux, map each input lane to the output lane and check the value considering it's security access
                    // Only check it if the security for the mux is different than green            
                    if (num_input_lanes[curr_mux] != cust_vis_top_lane[curr_mux]) begin                    
                        update_test_sequence_loc();
                        
                        // Write each input lane with its index + 1
                        for (int input_lane=0; input_lane<num_input_lanes[curr_mux]; input_lane++) begin
                            bit skip = 0;                                                    
                            
                            // TODO add a plusargs to not do this - Add danger message :)
                            // Lite testing security
                            case (policies[policy])
                                GREEN : begin                                                                        
                                    if ((input_lane < (cust_vis_top_lane[curr_mux]-1)) || (input_lane > cust_vis_top_lane[curr_mux])) begin
                                        skip = 1;
                                    end
                                end
                                BLACK : begin
                                    if (input_lane != 0) begin
                                        skip = 1;
                                    end
                                end
                                RED : begin
                                    if (input_lane != (num_input_lanes[curr_mux]-1)) begin
                                        skip = 1;
                                    end
                                end
                                ORANGE : begin
                                    if ((input_lane < (oem_vis_top_lane[curr_mux]-1)) || (input_lane > oem_vis_top_lane[curr_mux])) begin
                                        skip = 1;
                                    end
                                    // Don't double test the same if we already checked this input lane in GREEN mode and both TOP_LANES are the same for CUST and OEM
                                    if (cust_vis_top_lane[curr_mux] == oem_vis_top_lane[curr_mux]) begin
                                        skip = 1;
                                    end
                                end
                            endcase                                                        
                            
                            if (skip) begin
                                `ovm_info(get_name(), $psprintf("Skipping lane %0d for security = %s", input_lane, policies_name[policies[policy]]), OVM_MEDIUM);
                                continue;                                
                            end
                            
                            // Drive lane in curr_mux current mux, in input_lane input lane with input_lane+1 value
                            drive_lane_in(curr_mux, input_lane, input_lane+1);
                            
                            // First get the first available mux (not in the ignore clocks list)
                            clock_index = (get_clock_index(curr_mux) << 8);
                            // Map each input lane to the selected output lane
                            my_csr_write(curr_mux, visa_gid[curr_mux], reg_start_id[curr_mux] + out_lane + 1, clock_index | (input_lane+1), 0, 0);

                            // Wait for serial_cfg_in[1] to drop to indicate completion
                            if(!isTakerMux[curr_mux] && !behind_cri[curr_mux]) begin
                                rtl_path = "serial_cfg_in[1]";
                                wait_for_clock_val(mux_paths[curr_mux], rtl_path, 0);
                            end
                            
                            // Do check                            
                            // Wait 60ns on each lane_in change - Seems to do the trick at the slowest possible VRC clock = 50 MHz
                            #60ns;
                            
                            out_lane_value = sla_vpi_get_value_by_name($psprintf("%s.lane_out[%0d]", mux_paths[curr_mux], out_lane));
                            `ovm_info (get_name(), $psprintf("lane_in[%0d]=%0d lane_out[%0d]=%0d CUST_VIS=%0d OEM_VIS=%0d POLICY=%s", input_lane, input_lane+1, out_lane, out_lane_value, cust_vis_top_lane[curr_mux], oem_vis_top_lane[curr_mux], policies_name[policies[policy]]), OVM_MEDIUM);
                            
                            case (policies[policy])
                                GREEN : begin
                                    if (input_lane < cust_vis_top_lane[curr_mux]) begin
                                        if ((input_lane + 1) != out_lane_value) begin
                                            error_seen++;
                                            `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", input_lane + 1, out_lane_value), OVM_MEDIUM);
                                        end
                                    end
                                    else begin
                                        if ((cust_vis_top_lane[curr_mux]) != out_lane_value) begin
                                            error_seen++;
                                            `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", cust_vis_top_lane[curr_mux], out_lane_value), OVM_MEDIUM);
                                        end
                                    end 
                                end
                                BLACK : begin
                                    // This is for the case we have tested green before black in a multiple policies test
                                    if (policies.size() > 1) begin
	                                    if (out_lane_value != cust_vis_top_lane[curr_mux]) begin
	                                        error_seen++;
	                                        `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", cust_vis_top_lane[curr_mux], out_lane_value), OVM_MEDIUM);
	                                    end
                                    end
                                    // Individual policy test
                                    else begin                                    
	                                    if (out_lane_value != 0) begin
	                                        error_seen++;
	                                        `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", 0, out_lane_value), OVM_MEDIUM);
	                                    end
                                    end
                                end
                                RED : begin
                                    if ((input_lane + 1) != out_lane_value) begin
                                        error_seen++;
                                        `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", input_lane + 1, out_lane_value), OVM_MEDIUM);
                                    end
                                end
                                ORANGE : begin
                                    if (input_lane < oem_vis_top_lane[curr_mux]) begin                                       
                                        if ((input_lane + 1) != out_lane_value) begin
                                            error_seen++;
                                            `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", input_lane + 1, out_lane_value), OVM_MEDIUM);
                                        end
                                    end
                                    else begin
                                        if ((oem_vis_top_lane[curr_mux]) != out_lane_value) begin
                                            error_seen++;
                                            `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Expected output lane value = %0d not seen, value seen = %0d", oem_vis_top_lane[curr_mux], out_lane_value), OVM_MEDIUM);
                                        end
                                    end
                                end
                            endcase
                            //Survivability test: If Policy is green, send the previous secure transaction again, and check that the lane is visible
                            if (test_survivability) begin
                                if (policies[policy] == GREEN) begin
                                    if (input_lane == cust_vis_top_lane[curr_mux]) begin
                                        `ovm_info(get_name(), "Testing survivability", OVM_MEDIUM);
                                        sla_vpi_force_value_by_name("hqm_tb_top.adl_reg_bank_0.adl_visa_secure_reg",32'h0000_0001);
                                        my_csr_write(curr_mux, visa_gid[curr_mux], reg_start_id[curr_mux] + out_lane + 1, clock_index | (input_lane+1), 0, 0);

                                        // Wait for serial_cfg_in[1] to drop to indicate completion
                                        if(!isTakerMux[curr_mux] && !behind_cri[curr_mux]) begin
                                            rtl_path = "serial_cfg_in[1]";
                                            wait_for_clock_val(mux_paths[curr_mux], rtl_path, 0);
                                        end
                            
                                        // Do check                            
                                        // Wait 60ns on each lane_in change - Seems to do the trick at the slowest possible VRC clock = 50 MHz
                                        #60ns;
                                        out_lane_value = sla_vpi_get_value_by_name($psprintf("%s.lane_out[%0d]", mux_paths[curr_mux], out_lane));
                                        `ovm_info (get_name(), $psprintf("lane_in[%0d]=%0d lane_out[%0d]=%0d CUST_VIS=%0d OEM_VIS=%0d POLICY=%s", input_lane, input_lane+1, out_lane, out_lane_value, cust_vis_top_lane[curr_mux], oem_vis_top_lane[curr_mux], policies_name[policies[policy]]), OVM_MEDIUM);
                                        if ((input_lane + 1) != out_lane_value) begin
                                            error_seen++;
                                            `ovm_info(get_name(), $psprintf("VISA_OVM_ERROR: Survivability test: Expected output lane value = %0d not seen, value seen = %0d", input_lane + 1, out_lane_value), OVM_MEDIUM);
                                        end
                                        my_csr_write(curr_mux, visa_gid[curr_mux], reg_start_id[curr_mux] + out_lane + 1, clock_index | (input_lane), 0, 0); // Since we are going to check black policy after this, reset the register value to the previous value that is expected for black policy testing
                                        sla_vpi_force_value_by_name("hqm_tb_top.adl_reg_bank_0.adl_visa_secure_reg",32'h0000_0000);
                                    end
                                end
                            end
                        end                   
                    end
                    else begin
                        `ovm_info (get_name(), $psprintf("num_input_lanes and cust_vis_top_lane are the same (value=%0d), not checking security", num_input_lanes[curr_mux]), OVM_MEDIUM);
                    end
                end 
            end                                
            end
        end                      
    endtask    
    
    function int get_clock_index(int mux_num);        
        int clock_index;
        
        for (clock_index = 0; clock_index < num_clocks[mux_num]; clock_index++) begin
            bit ignore_clock;
            string src_rtl_path;
            
            src_rtl_path = $psprintf("src_clk[%0d]", clock_index);
            check_if_valid_clock(mux_paths[mux_num], src_rtl_path, ignore_clock, mux_num);
            if (!ignore_clock) break;        
        end        
        
        `ovm_info(get_name(), $psprintf("Selected src_clk = %0d", clock_index), OVM_MEDIUM);
        
        return clock_index;    
    endfunction    
    
    task set_visa_en;
        bit skip = 0;
        
        `ovm_info (get_name(), "Test each mux programming.  Set visa_en bit and each output lane to use src_clk[0].  This allows all clocks to propagate through design so internal mux testing works.", OVM_MEDIUM);
        
        for (int mux_num=(mux_paths.size()-1); mux_num >= 0; mux_num--) begin:mux_num_for
        //for (int mux_num=start_mux_num; mux_num >= end_mux_num; mux_num--) begin:mux_num_for
            if ((dummy_mux[mux_num] == 0) && (repeater[mux_num] == 0)) begin
                update_test_sequence_loc();
                if((isTakerMux[mux_num] == 0) && (behind_cri[mux_num] == 0)) begin
                    wait_for_read_and_compare(mux_num,"visa_unit_id",visa_gid[mux_num],0,0);
                    update_test_sequence_loc();
                    wait_for_read_and_compare(mux_num,"reg_start_index",reg_start_id[mux_num],0,0);
                end 
                
                // Only program via VRC the muxes that we actually want to test
                if ((mux_num >= end_mux_num) && (mux_num<=start_mux_num)) begin
                    my_csr_write(mux_num,visa_gid[mux_num],reg_start_id[mux_num],1,0,0);
                    skip = 0;
                end
                // Force a visa_en write for all the other muxes, this is helpful when you want to propagate clocks all over the place
                else begin                
                    my_csr_write(mux_num,visa_gid[mux_num],reg_start_id[mux_num],1,1,0);
                    skip = 1;
                end
                
                update_test_sequence_loc();

                // wait for frame to drop meaning it is programmed.
                //`ovm_info (get_name(), "wait for frame to drop meaning it is programmed", OVM_MEDIUM);

                //if( (isTakerMux[mux_num] == 0) && (behind_cri[mux_num] == 0) && !skip) begin
                  //  rtl_path = "serial_cfg_in[1]";
                  //  wait_for_clock_val(mux_paths[mux_num], rtl_path, 0);
               // end

                // show programming worked
                `ovm_info (get_name(), "show programming worked", OVM_MEDIUM);
                update_test_sequence_loc();

                if((isTakerMux[mux_num]) && behind_cri[mux_num]) begin
                   if(isNotBlackBoxed[mux_num] == 0 ) begin
                      wait_for_read_and_compare(mux_num,"mux_body.control_cr[0]",1,1,0);
                   end 
                   else begin
                       wait_for_read_and_compare(mux_num,"not_blackboxed.mux_body.control_cr[0]",1,1,0);
                   end
                end
                else begin 
                   if(isNotBlackBoxed[mux_num] == 0 ) begin
                       wait_for_read_and_compare(mux_num,"mux_body.visa_en_cr",1,1,0);
                   end 
                   else begin
                       wait_for_read_and_compare(mux_num,"not_blackboxed.mux_body.visa_en_cr",1,1,0);
                   end
                end
                //        for (int num_output=0; num_output <num_output_lanes[mux_num]; num_output++) begin: for_num_output
                //    data = (l_src_clk<<8) | ((num_input+1) << 0);
                //    update_test_sequence_loc();
                //    `ovm_info(get_name(), $psprintf("Programming output port %0d to use clk 0.", num_output), OVM_MEDIUM);
                //    lane_offset = reg_start_id[mux_num] + num_output;
                //    allcr_offset = num_output + 1;
                //    my_csr_write(mux_num,visa_gid[mux_num],lane_offset,data,1,allcr_offset);
                //        end // for num_output
            end // if dummy_mux
        end // for mux_num
    endtask
    
    task update_test_sequence_loc;
        begin
        if (test_type == 0) begin
            sla_vpi_put_value_by_name("hqm_tb_top.visa_test_sequence_loc[31:0]", test_sequence_loc);
        end 
        else begin // test_type
            sla_vpi_put_value_by_name("hqm_tb_top.vrc_glue.test_sequence_loc[31:0]", test_sequence_loc);
            end // else test_type
            `ovm_info (get_name(), ($psprintf("test_sequence set to 32'h%h",test_sequence_loc)), OVM_MEDIUM);
            test_sequence_loc++;
        end
    endtask
    
    task wait_for_read_and_compare;
        input int mux_num;
        input string pin;
        input int val;
        input int wait_for_value;
        input int ignore_error;
        begin
            my_bit_read_val = sla_vpi_get_value_by_name($psprintf("%s.%s",mux_paths[mux_num], pin));
            `ovm_info (get_name(), $psprintf("checking %s.%s for value of %0d (0x%h).",mux_paths[mux_num], pin, val, val), OVM_MEDIUM);
            if (wait_for_value) begin
                read_loop = 0;
                while (my_bit_read_val !== val) begin
                    #10ns;
                    my_bit_read_val = sla_vpi_get_value_by_name($psprintf("%s.%s",mux_paths[mux_num],pin));
                    read_loop++;
                    `ovm_info(get_name(), $psprintf("-D- read_loop is %0d", read_loop ), OVM_MEDIUM);
                    if (read_loop > 100) begin
                        error_seen++;
                        error_message = $psprintf("VISA_OVM_ERROR: Value of %0d (0x%h) never seen at %s.%s!.",val, val, mux_paths[mux_num], pin);
                        `ovm_info(get_name(), error_message, OVM_MEDIUM);
                        break;
                    end // if read_loop
                end // while my_bit_read_val
            end 
            else begin
                if (ignore_error == 0) begin
                    if (my_bit_read_val !== val) begin
                        error_seen++;
                        `ovm_info (get_name(), ($psprintf("VISA_OVM_ERROR: Path %s.%s failed read of %0d (0x%h) and got %0d (0x%h) instead for a total of %0d errors.",mux_paths[mux_num],pin,val,val,my_bit_read_val,my_bit_read_val, error_seen)),OVM_MEDIUM);
                    end // if my_bit_read_val !==
                end
            end
        end
    endtask
    
    task my_csr_write;
        input int mux_num;
        input int visa_unit_id;
        input int reg_start_index;
        input int data;
        input int force_or_program;
        input int force_register_num;
        begin
            int val;
            string vrc_reg_path;
            string vrc_reg_field;
            update_test_sequence_loc();
        
            `ovm_info(get_name(), $psprintf("Driving mux %s with GID %0d RSI %0d with data = 0x%0h, force=%0d, force_reg_num=%0d", mux_paths[mux_num], visa_unit_id, reg_start_index, data, force_or_program, force_register_num), OVM_MEDIUM);
        
            if (force_or_program == 1) begin
                if ((isTakerMux[mux_num] == 0) && (behind_cri[mux_num] == 0)) begin
                    if (isNotBlackBoxed[mux_num]) begin
                        sla_vpi_put_value_by_name($psprintf("%s.not_blackboxed.mux_body.visa2_registers.deserializer.all_cr[%0d]", mux_paths[mux_num], force_register_num), data);
                    end
                    else begin
                        sla_vpi_put_value_by_name($psprintf("%s.mux_body.visa2_registers.deserializer.all_cr[%0d]", mux_paths[mux_num], force_register_num), data);
                    end
                end 
                else begin 
                    //sla_vpi_put_value_by_name($psprintf("%s.mux_body.lane_cr[%0d]", mux_paths[mux_num], force_register_num), data);
                    if (behind_cri[mux_num] == 1) begin
                        sla_vpi_put_value_by_name($psprintf("%s.control_cr[%0d]", mux_paths[mux_num], force_register_num), data);
                    end
                    else begin
                        sla_vpi_put_value_by_name($psprintf("%s.taken_cr[%0d]", mux_paths[mux_num], force_register_num), data);
                    end
                end 
            end 
            else begin
                if (test_type == 0) begin // IP or SS global testing
                    // use testbench vrc
                    sla_vpi_put_value_by_name("hqm_tb_top.ip_wr_data[31:0]", data);
                    sla_vpi_put_value_by_name("hqm_tb_top.ip_visa_reg_offset[4:0]", reg_start_index);
                    sla_vpi_put_value_by_name("hqm_tb_top.ip_visa_gid[8:0]", visa_unit_id);
                    sla_vpi_put_value_by_name("hqm_tb_top.ip_busy", 1'h1);
                    #10ns; 
                    my_bit_read_val = sla_vpi_get_value_by_name("hqm_tb_top.ip_busy");
                    val = 0;
                    `ovm_info (get_name(), $psprintf("checking hqm_tb_top.ip_busy for value of %0d (0x%h).", val, val), OVM_MEDIUM);
                    read_loop = 0;
                    while (my_bit_read_val !== val) begin
                        #10ns;
                        my_bit_read_val = sla_vpi_get_value_by_name("hqm_tb_top.ip_busy");
                        read_loop++;
                        `ovm_info(get_name(), $psprintf("-D- read_loop is %0d", read_loop ), OVM_MEDIUM);
                        if (read_loop > 50) begin
                            error_seen++;
                            error_message = $psprintf("VISA_OVM_ERROR: Value of %0d (0x%h) never seen at hqm_tb_top.ip_busy!.",val, val);
                            `ovm_info(get_name(), error_message, OVM_MEDIUM);                            
                            break;
                        end // if read_loop
                    end // while my_bit_read_val
                    // wait for frame to drop, meaning transaction is done.  Doing this because vrc stores current transaction
                    // and allows new one to be staged, throwing off alignment.  Fix this for real testing.

                    if((isTakerMux[mux_num] == 0) && (behind_cri[mux_num] == 0)) begin
                        wait_for_x_src_clk_edges(mux_paths[mux_num], "serial_cfg_in[0]", 20, mux_num);
                        wait_for_read_and_compare(mux_num,"serial_cfg_in[1]",0,1,0);
                    end
                end 
                else begin // SS or SOC
                    if(eb_debug_ctl_network == 1'b1) begin
                        vrc_reg_path = "hqm_tb_top.eb_debug_ctl_regs.registers.global_soc_vrc_visa_data_window_reg";
                    end
                    else begin
                        vrc_reg_path = "hqm_tb_top.adl_reg_bank_0.vrc_visa_data_window_reg";
                    end
                    vrc_reg_field = (eb_debug_ctl_network == 1'b1) ? $psprintf("%s.DATA[31:0]", vrc_reg_path) : $psprintf("%s.data[31:0]", vrc_reg_path);
                    sla_vpi_put_value_by_name(vrc_reg_field, data);

                    if(eb_debug_ctl_network == 1'b1) begin
                        vrc_reg_path = "hqm_tb_top.eb_debug_ctl_regs.registers.global_soc_vrc_visa_addr_window_reg";
                    end
                    else begin
                        vrc_reg_path = "hqm_tb_top.adl_reg_bank_0.vrc_visa_addr_window_reg";
                    end
                    vrc_reg_field = (eb_debug_ctl_network == 1'b1) ? $psprintf("%s.REGISTER_OFFSET[4:0]", vrc_reg_path) : $psprintf("%s.register_offset[4:0]", vrc_reg_path);
                    sla_vpi_put_value_by_name(vrc_reg_field, reg_start_index);

                    vrc_reg_field = (eb_debug_ctl_network == 1'b1) ? $psprintf("%s.GID[8:0]", vrc_reg_path) : $psprintf("%s.gid[8:0]", vrc_reg_path);
                    sla_vpi_put_value_by_name(vrc_reg_field,visa_unit_id);
                    vrc_reg_field = (eb_debug_ctl_network == 1'b1) ? $psprintf("%s.BUSY[0]", vrc_reg_path) : $psprintf("%s.busy[0]", vrc_reg_path);
                    sla_vpi_put_value_by_name(vrc_reg_field, 1'h1);
                    #10ns; 
                    my_bit_read_val = sla_vpi_get_value_by_name(vrc_reg_field);
                    val = 0;
                    `ovm_info (get_name(), $psprintf("checking hqm_tb_top.ip_busy for value of %0d (0x%h).", val, val), OVM_MEDIUM);
                    read_loop = 0;
                    while (my_bit_read_val !== val) begin
                        #10ns;
                        my_bit_read_val = sla_vpi_get_value_by_name(vrc_reg_field);
                        read_loop++;
                        `ovm_info(get_name(), $psprintf("-D- read_loop is %0d", read_loop ), OVM_MEDIUM);
                        if (read_loop > 50) begin
                            error_seen++;
                            error_message = $psprintf("VISA_OVM_ERROR: Value of %0d (0x%h) never seen at hqm_tb_top.ip_busy!.",val, val);                            
                            `ovm_info(get_name(), error_message, OVM_MEDIUM);
                            break;
                        end // if read_loop
                    end // while my_bit_read_val
                    // wait for frame to drop, meaning transaction is done.  Doing this because vrc stores current transaction
                    // and allows new one to be staged, throwing off alignment.  Fix this for real testing.

                    if((isTakerMux[mux_num] == 0) && (behind_cri[mux_num] == 0)) begin
                        wait_for_x_src_clk_edges(mux_paths[mux_num], "serial_cfg_in[0]", 20, mux_num);
                        wait_for_read_and_compare(mux_num,"serial_cfg_in[1]",0,1,0);
                    end
                end // SS or SOC
            end // force
        end
    endtask
    
    task check_if_valid_clock;
        input string mux_path;
        input string clock_port;
        output int ignore_path;
        input int mux_num;
        begin
            string full_signal_path;
            ignore_path = 0;
                
            if(isNotBlackBoxed[mux_num]) begin
                full_signal_path = $psprintf("%s.not_blackboxed.mux_body.%s",mux_path, clock_port);
            end
            else begin
                full_signal_path = $psprintf("%s.%s",mux_path, clock_port);
            end
            
            for (int mux_num=0; mux_num<ignore_paths.size(); mux_num++) begin:mux_num_for
                `ovm_info(get_name(), $psprintf("check_if_valid_clock: comparing ignore_paths: '%s'  to full_signal_path: '%s'",ignore_paths[mux_num], full_signal_path ), OVM_HIGH);
                if ((ignore_paths[mux_num] == full_signal_path) && (!ignore_path)) begin
                    ignore_path = 1;
                    `ovm_info(get_name(), "check_if_valid_clock: matched ignore path", OVM_HIGH);
                end
            end
        end
    endtask
    
    task wait_for_clock_val;
        input string mux_path;
        input string clock_port;
        input int clock_val;
        begin
            string full_signal_path;
            full_signal_path = $psprintf("%s.%s",mux_path, clock_port);
            
            if (ignore_path_found == 0) begin
                my_bit_read_val = sla_vpi_get_value_by_name(full_signal_path);
                `ovm_info (get_name(), ($psprintf("Checking %s for value of %0d",full_signal_path, clock_val)), OVM_MEDIUM);
                read_loop = 0;
                
                while (my_bit_read_val != clock_val) begin
                    #100ps;
                    `ovm_info(get_name(), $psprintf("-D- Read_loop is %0d", read_loop ), OVM_MEDIUM);
                    my_bit_read_val = sla_vpi_get_value_by_name(full_signal_path);
                    read_loop++;
                    
                    // Maximum wait time is 100ps * 250 = 25ns delay per edge.
                    // This should serve clocks faster than 20 MHz
                    if (read_loop > 250) begin
                        error_seen++;
                        error_message = $psprintf("VISA_OVM_ERROR: Clock value of %d was not seen at path: %s!", clock_val, full_signal_path);
                        `ovm_info(get_name(), error_message, OVM_MEDIUM);                        
                        break;
                    end // if read_loop
                end // while my_bit_read_val
            end 
            else begin // if ignore_path_found
                `ovm_info (get_name(), ($psprintf("Ignoring path %s due to entry in ignore file.",full_signal_path)), OVM_MEDIUM);
            end // if ignore_path_found
        end
    endtask
    
    task wait_for_x_src_clk_edges;
        input string mux_path;
        input string clock_port;
        input int num_clock_edges;
        input int mux_num;
        begin
            `ovm_info (get_name(), ($psprintf("Waiting for %0d clock edges of %s.%s",num_clock_edges, mux_path, clock_port)), OVM_MEDIUM);
            
            if(isNotBlackBoxed[mux_num]) begin
                my_bit_read_val = sla_vpi_get_value_by_name($psprintf("%s.not_blackboxed.mux_body.%s",mux_path, clock_port));
            end
            else begin
                my_bit_read_val = sla_vpi_get_value_by_name($psprintf("%s.%s",mux_path, clock_port));
            end
            
            for(int clk_count=0; clk_count<num_clock_edges; clk_count++) begin:clk_count_for
                if (my_bit_read_val > 0) begin
                    wait_for_clock_val(mux_path, clock_port, 0);
                    end else begin
                    wait_for_clock_val(mux_path, clock_port, 1);
                end;
            end // for clk_count
        end
    endtask
    
    task drive_lane_in;
        input int mux;
        input int lane;
        input [7:0] val;

        `ovm_info (get_name(), ($psprintf("Forcing %s.lane_in[%0d] to be 8'h%h",mux_paths[mux],lane,val)), OVM_MEDIUM);
        
        if(isNotBlackBoxed[mux]) begin
            sla_vpi_force_value_by_name($psprintf("%s.not_blackboxed.mux_body.lane_in[%0d]", mux_paths[mux],lane),val);
        end
        else begin
            sla_vpi_force_value_by_name($psprintf("%s.lane_in[%0d]", mux_paths[mux],lane),val);
        end
    endtask
    
    task release_lane_in;
        input int mux;
        input int lane;
        input [7:0] val;
        `ovm_info (get_name(), ($psprintf("releasing %s.lane_in[%0d]",mux_paths[mux],lane)), OVM_MEDIUM);
        if(isNotBlackBoxed[mux] == 0 ) begin
            sla_vpi_release_value_by_name($psprintf("%s.lane_in[%0d]", mux_paths[mux],lane),val);
        end
        else begin
            sla_vpi_release_value_by_name($psprintf("%s.not_blackboxed.mux_body.lane_in[%0d]", mux_paths[mux],lane),val);
        end
    endtask
    
    task drive_lane_out;
        input int mux;
        input int lane;
        input [7:0] val;

        `ovm_info (get_name(), ($psprintf("Forcing %s.lane_out[%0d] to be 8'h%h",mux_paths[mux],lane,val)), OVM_MEDIUM);
        
        if(isNotBlackBoxed[mux]) begin
            sla_vpi_force_value_by_name($psprintf("%s.not_blackboxed.mux_body.lane_out[%0d]", mux_paths[mux],lane),val);
        end
        else begin
            sla_vpi_force_value_by_name($psprintf("%s.lane_out[%0d]", mux_paths[mux],lane),val);
        end
    endtask
    
    task release_lane_out;
        input int mux;
        input int lane;
        input [7:0] val;
        `ovm_info (get_name(), ($psprintf("releasing %s.lane_out[%0d]",mux_paths[mux],lane)), OVM_MEDIUM);
        if(isNotBlackBoxed[mux] == 0 ) begin
            sla_vpi_release_value_by_name($psprintf("%s.lane_out[%0d]", mux_paths[mux],lane),val);
        end
        else begin
            sla_vpi_release_value_by_name($psprintf("%s.not_blackboxed.mux_body.lane_out[%0d]", mux_paths[mux],lane),val);
        end
    endtask
    
    function int get_int_arg(string arg_string, integer value);        
        if($value$plusargs({arg_string,"=%d"}, value)) begin
            `ovm_info(get_name(), $sformatf("Parsed int +args: value=%d", value), OVM_MEDIUM);
        end 
        return value;    
    endfunction    
    
    function string get_str_arg(string arg_string, string value);        
        if($value$plusargs({arg_string,"=%s"}, value)) begin            
            `ovm_info(get_name(), $sformatf("Parsed str +args: value=%s", value), OVM_MEDIUM);
        end 
        return value;    
    endfunction    
    
