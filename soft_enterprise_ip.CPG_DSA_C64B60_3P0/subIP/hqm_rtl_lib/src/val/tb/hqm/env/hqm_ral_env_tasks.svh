
  virtual function bit gen_unimp_addresses(string file_name, int num_rand_addr, ref sla_ral_addr_t addr_q[$], ref int reg_width_q[$]);
    string              orig_file_name;
    string              file_prefix;
    string              file_space;
    bit [63:0]          file_size;
    sla_ral_addr_t      low_addr[$], high_addr[$];
    string              rand_cases;
    string              indices[$];
    int                 sel_mode;
    int                 wt_incr_min;
    int                 wt_incr_max;

    sel_mode=0;
    $value$plusargs("UNIMP_SEL_MODE=%0d", sel_mode);
    wt_incr_min=4;
    $value$plusargs("UNIMP_WT_INCR_MIN=%0d", wt_incr_min);
    wt_incr_max=wt_incr_min;
    $value$plusargs("UNIMP_WT_INCR_MAX=%0d", wt_incr_max);
 

    gen_unimp_addresses = 0;

    low_addr.delete();
    high_addr.delete();
    addr_q.delete();
    reg_width_q.delete();

    orig_file_name = file_name;
    file_prefix = lvm_common_pkg::parse_array_indices(file_name,indices);

    `ovm_info(get_name(), $sformatf("gen_unimp_addresses-- file_name %s  num_rand_addr %d ",file_name, num_rand_addr),OVM_MEDIUM);
    case (file_prefix)
      "hqm_pf_cfg_i": begin
        file_space      = "CFG";
        file_size       = 'h00001000;
      end
      "hqm_msix_mem": begin
        file_space      = "MEM";
        file_size       = 'h02000000;
      end
      "hqm_sif_csr": begin
        file_space      = "MEM";
        file_size       = 'h10000000;
      end
      "hqm_system_csr": begin
        file_space      = "MEM";
        file_size       = 'h20000000;
      end
      "aqed_pipe": begin
        file_space      = "MEM";
        file_size       = 'h30000000;
      end
      "atm_pipe": begin
        file_space      = "MEM";
        file_size       = 'h40000000;
      end
      "credit_hist_pipe": begin
        file_space      = "MEM";
        file_size       = 'h50000000;
      end
      "direct_pipe": begin
        file_space      = "MEM";
        file_size       = 'h60000000;
      end
      "qed_pipe": begin
        file_space      = "MEM";
        file_size       = 'h70000000;
      end
      "nalb_pipe": begin
        file_space      = "MEM";
        file_size       = 'h80000000;
      end
      "reorder_pipe": begin
        file_space      = "MEM";
        file_size       = 'h90000000;
      end
      "list_sel_pipe": begin
        file_space      = "MEM";
        file_size       = 'ha0000000;
      end
      "config_master": begin
        file_space      = "MEM";
        file_size       = 'h1_00000000; // capture remaining unit IDs
      end
      default: begin
        `ovm_error(get_full_name(),{orig_file_name," is an unexpected RAL file name "})
        gen_unimp_addresses = 1;
        return(1);
      end
    endcase

    this.find_gaps_in_file_by_space(orig_file_name, file_size, file_space, low_addr, high_addr);

    foreach (low_addr[i]) begin
      gen_unimp_addresses |= gen_unimp_addr_cases(orig_file_name,file_space,low_addr[i],high_addr[i],sel_mode,wt_incr_min,wt_incr_max,addr_q,reg_width_q);
    end

    if (file_space == "MEM") begin
      rand_cases = $psprintf("\n%s Random Test Addresses (%0d addresses)\n",file_name,num_rand_addr);

      for (int i = 0 ; i < num_rand_addr ; i++) begin
        bit               rand_addr_generated;
        sla_ral_addr_t    rand_addr;
        int               gap_index;
        int               unimp_addresses[$];

        rand_addr_generated = 0;

        while (rand_addr_generated == 0) begin
          gap_index = $urandom_range(low_addr.size() - 1, 0);

          if ((low_addr[gap_index] + 7) < high_addr[gap_index]) begin
            rand_addr = $urandom_range(high_addr[gap_index] - 3, low_addr[gap_index] + 4);
            rand_addr[1:0] = 2'b00;

            unimp_addresses = addr_q.find_index with ( item == rand_addr );

            if (unimp_addresses.size() == 0) begin
              addr_q.push_back(rand_addr);
              reg_width_q.push_back(32);
              rand_cases = {rand_cases,$psprintf("pickup_unimp_addr 0x%08x REG_WIDTH=%0d\n",rand_addr,32)};
              rand_addr_generated = 1;
            end
          end
        end
      end

      `ovm_info(get_full_name(),rand_cases,OVM_HIGH)
    end

  endfunction

  function bit gen_unimp_addr_cases(string file_name, string file_space, sla_ral_addr_t low_unimp, sla_ral_addr_t high_unimp, int sel_mode, int incr_min, int incr_max, ref sla_ral_addr_t addr_q[$], ref int reg_width_q[$]);
    sla_ral_addr_t      low_imp, high_imp;
    sla_ral_addr_t      curr_addr;
    sla_ral_addr_t      test_addr;
    bit                 reg_address[sla_ral_addr_t];
    int                 reg_width[sla_ral_addr_t];
    int                 curr_reg_width;
    int                 incr_val, sel_num;
    string              reg_cases;

    gen_unimp_addr_cases = 0;

    reg_address.delete();
    reg_width.delete();

    `ovm_info(get_name(), $sformatf("gen_unimp_addr_cases-- file_name %s ",file_name),OVM_LOW);
    if (file_space == "MEM") begin
      if(sel_mode==0) begin    
	 low_unimp[1:0]  = 2'b00;
	 high_unimp[1:0] = 2'b00;

	 if (low_unimp == high_unimp) begin
           reg_address[low_unimp] = 1;
	 end else if ((low_unimp + 4) == high_unimp) begin
           reg_address[low_unimp] = 1;
           reg_address[high_unimp] = 1;
	 end else begin
           reg_address[low_unimp] = 1;

           if (low_unimp != 0) begin
             low_imp = low_unimp - 4;
           end else begin
             low_imp = 0;
           end

           high_imp = high_unimp + 4;

           curr_addr = low_unimp + 4;

           for (int i = 2 ; i < 32 ; i++) begin
             test_addr = low_imp ^ (1 << i);

             if ((test_addr > low_unimp) && (test_addr < high_unimp)) begin
               if (!reg_address.exists(test_addr)) begin
        	 reg_address[test_addr] = 1;
               end
             end

             test_addr = high_imp ^ (1 << i);

             if ((test_addr > low_unimp) && (test_addr < high_unimp)) begin
               if (!reg_address.exists(test_addr)) begin
        	 reg_address[test_addr] = 1;
               end
             end
           end

           reg_address[high_unimp] = 1;
	 end

	 reg_cases = $psprintf("\n%s Test Addresses (0x%03x-0x%03x : %0d addresses)\n",file_name,low_unimp,high_unimp,reg_address.size());

	 foreach (reg_address[test_addr]) begin
           reg_cases = {reg_cases,$psprintf("  0x%08x\n",test_addr)};
           addr_q.push_back(test_addr);
           reg_width_q.push_back(32);
	 end

	 `ovm_info(get_full_name(),reg_cases,OVM_HIGH)
	 
      end else if(sel_mode==1) begin    
	 low_unimp[1:0]  = 2'b00;
	 high_unimp[1:0] = 2'b00;
         incr_val=$urandom_range(incr_min, incr_max);	 
         sel_num=(high_unimp-low_unimp)/incr_val;
         test_addr=0;         
         test_addr=low_unimp;

         for(int i=0;i<sel_num; i++) begin
             incr_val=$urandom_range(incr_min, incr_max);	 
             test_addr=test_addr+incr_val; 
             if((test_addr > low_unimp) && (test_addr < high_unimp)) begin
               reg_cases = {reg_cases,$psprintf("  0x%08x\n",test_addr)};
               addr_q.push_back(test_addr);
               reg_width_q.push_back(32);	     
             end	     	     	 
         end	 

	 reg_cases = $psprintf("\n%s Test Addresses With sel_mode=1 (0x%03x-0x%03x : %0d addresses)\n",file_name,low_unimp,high_unimp,addr_q.size());  

	 `ovm_info(get_full_name(),reg_cases,OVM_HIGH)	 
      end //--sel_mode	 
    end else begin
      curr_addr = low_unimp;

      while (curr_addr <= high_unimp) begin
        if (curr_addr[63:2] == high_unimp[63:2]) begin
          curr_reg_width  = 8 * ((high_unimp[1:0] - curr_addr[1:0]) + 32'd1);
        end else begin
          curr_reg_width  = 8 * ((2'b11 - curr_addr[1:0]) + 32'd1);
        end

        reg_address[curr_addr]  = 1;
        reg_width[curr_addr]    = curr_reg_width;

        curr_addr += 4;
        curr_addr[1:0] = 2'b00;
      end

      reg_cases = $psprintf("\n%s Test Addresses (0x%03x-0x%03x : %0d addresses)\n",file_name,low_unimp,high_unimp,reg_address.size());

      foreach (reg_address[test_addr]) begin
        reg_cases = {reg_cases,$psprintf("  0x%08x REG_WIDTH=%0d\n",test_addr,reg_width[test_addr])};
        addr_q.push_back(test_addr);
        reg_width_q.push_back(reg_width[test_addr]);
      end

      `ovm_info(get_full_name(),reg_cases,OVM_HIGH)
    end

  endfunction
