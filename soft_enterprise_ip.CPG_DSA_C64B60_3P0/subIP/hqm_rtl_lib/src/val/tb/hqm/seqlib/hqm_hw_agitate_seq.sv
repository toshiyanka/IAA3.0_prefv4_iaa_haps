import hqm_tb_cfg_pkg::*;

class hqm_hw_agitate_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_hw_agitate_seq, sla_sequencer)

    typedef enum {
        START = 0,
        STOP  = 1
    } start_stop_t;

    typedef enum {
      TI_PHDR_AFULL             = 0,
      TI_PDATA_AFULL            = 1,
      TI_CMPL_AFULL             = 2,
      SIG_NUM_AFULL             = 3,
      PEND_SIG_AFULL            = 4,
      CSR_DATA_AFULL            = 5,
      WB_SCH_OUT_AFULL          = 6,
      IG_HCW_ENQ_AFULL          = 7,
      IG_HCW_ENQ_W_DB           = 8,
      EG_HCW_SCHED_DB           = 9,
      AL_MSI_MSIX_DB            = 10,
      AL_CWD_ALARM_DB           = 11,
      AL_HQM_ALARM_DB           = 12, 
      AL_SIF_ALARM_AFULL        = 13              //-- Not sure why this was not present in v1
      //TI_NPHDR_AFULL            = 2,            //-- Register Not present in v2 (Review)
      //WB_DMV_HCW_AFULL          = 5,            //-- DMV not present in v2
      //WB_DMV_WDATA_AFULL        = 6,            //-- DMV not present in v2
      //IG_CMPL_DATA_AFULL        = 7,            //-- Register Not present in v2 (Review)
      //IG_CMPL_HDR_AFULL         = 8,            //-- Register Not present in v2 (Review)
      //PPTR_AFULL                = 10,           //-- Register Not present in v2 (Review)
      //IG_HCW_ENQ_AW_DB          = 14,           //-- Register Not present in v2 (Review)
      //IG_DMV_R_DB               = 16,           //-- DMV not present in v2
      //EG_PUSH_PTR_AW_DB         = 17,           //-- Push pointer Not present in v2
      //EG_DMV_ENQ_W_DB           = 19,           //-- DMV Not present in v2
      //AL_DMV_ALARM_DB           = 22,           //-- DMV Not present in v2
    } agitate_en_sel_t;
      
    rand start_stop_t start_stop;

    function new(string name = "hqm_hw_agitate_seq");
       super.new(name);
    endfunction

    virtual task body();
      string            agitate_en_str;
      bit [31:0]        agitate_en;
      string            agitate_wdata_str;
      bit [31:0]        agitate_wdata;
      bit [31:0]        agitate_wdata_rs;
      bit [31:0]        agitate_wdata_ind[agitate_en_sel_t];
      agitate_en_sel_t  agitate_en_sel;


      if ($test$plusargs("HQM_SKIP_AGITATE_SEQ")) begin
        `ovm_info("HQM_HW_AGITATE_SEQ", $psprintf("Skipping agitate sequence, as plusargs HQM_SKIP_AGITATE_SEQ has been provided"), OVM_NONE);
        return;
      end

      if ($value$plusargs({"HQM_HW_AGITATE_EN","=%s"}, agitate_en_str)) begin
        if (!lvm_common_pkg::token_to_int(agitate_en_str, agitate_en)) begin
          `ovm_error(get_full_name(),$psprintf("Illegal +HQM_HW_AGITATE_EN=%s argument",agitate_en_str))
          agitate_en = 0;
        end
      end else begin
        agitate_en = 0;
      end

      if ($test$plusargs({"HQM_HW_AGITATE_RAND_EN"})) begin
        agitate_en = $urandom_range(32'hffffffff,32'h1);
      end

      // Return if agitation is not enabled
      if (agitate_en == 0) begin
        return;
      end

      if ($value$plusargs({"HQM_HW_AGITATE_WDATA","=%s"}, agitate_wdata_str)) begin
        if (!lvm_common_pkg::token_to_int(agitate_wdata_str, agitate_wdata)) begin
          `ovm_error(get_full_name(),$psprintf("Illegal +HQM_HW_AGITATE_WDATA=%s argument",agitate_wdata_str))
          agitate_wdata = 0;
        end
      end else begin
        agitate_wdata = 0;
      end

      // Make sure memory operations are enabled and the DISABLE bit is cleared before proceeding
      cfg_cmds.push_back("poll hqm_pf_cfg_i.device_command 6 2 1000");
      cfg_cmds.push_back("poll config_master.cfg_pm_pmcsr_disable 0 0xffffffff 1000");

      agitate_en_sel = agitate_en_sel.first();
      
      for (int i = 0 ; i < agitate_en_sel.num() ; i++) begin
        if ($test$plusargs({"HQM_HW_AGITATE_",agitate_en_sel.name(),"_EN"})) begin
          agitate_en[agitate_en_sel] = 1'b1;
        end

        if (agitate_en[agitate_en_sel]) begin
          agitate_wdata_ind[agitate_en_sel] = agitate_wdata;
        end

        if ($value$plusargs({"HQM_HW_AGITATE_",agitate_en_sel.name(),"_WDATA","=%s"}, agitate_wdata_str)) begin
          if (lvm_common_pkg::token_to_int(agitate_wdata_str, agitate_wdata_rs)) begin
            agitate_wdata_ind[agitate_en_sel] = agitate_wdata_rs;
          end else begin
            `ovm_error(get_full_name(),$psprintf("Illegal +HQM_HW_AGITATE_%s_EN=%s argument",agitate_en_sel.name(),agitate_wdata_str))
          end
        end

        agitate_en_sel = agitate_en_sel.next();
      end


      if (start_stop == START) begin
        foreach (agitate_wdata_ind[agitate_en_sel]) begin
          string  agitate_en_name;

          `ovm_info(get_full_name(),$psprintf("Agitate enabled - %s wdata=0x%08x",agitate_en_sel.name(),agitate_wdata_ind[agitate_en_sel]),OVM_LOW)

          agitate_en_name = agitate_en_sel.name();
          agitate_en_name = agitate_en_name.tolower();

          //--abbiswal-- Need to fix this. --//
          if (agitate_en_sel <= 5) begin
              cfg_cmds.push_back($psprintf("wr hqm_sif_csr.%s_agitate_control 0x%08x",agitate_en_name,agitate_wdata_ind[agitate_en_sel]));
          end
          else begin
              cfg_cmds.push_back($psprintf("wr hqm_system_csr.%s_agitate_control 0x%08x",agitate_en_name,agitate_wdata_ind[agitate_en_sel]));
          end
        end
      end
      else if (start_stop == STOP) begin
        if (agitate_en != 0) begin
          agitate_en_sel = agitate_en_sel.first();

          for (int i = 0 ; i < agitate_en_sel.num() ; i++) begin
            string  agitate_en_name;

            `ovm_info("HQM_HW_AGITATE_SEQ", $psprintf("Agitate disabled - %s wdata=0x0000_0000",agitate_en_sel.name()), OVM_LOW)

            agitate_en_name = agitate_en_sel.name();
            agitate_en_name = agitate_en_name.tolower();

            //--abbiswal-- Need to fix this. --//
            if (agitate_en_sel <= 5) begin
                cfg_cmds.push_back($psprintf("wr hqm_sif_csr.%s_agitate_control 0x00000000", agitate_en_name));
            end
            else begin
                cfg_cmds.push_back($psprintf("wr hqm_system_csr.%s_agitate_control 0x00000000", agitate_en_name));
            end

            agitate_en_sel = agitate_en_sel.next();
          end

          //-- iosf read txn --//
          cfg_cmds.push_back($psprintf("rd hqm_pf_cfg_i.vendor_id"));

          //-- Wait for 1000 clocks after hw agitators are switched off --//
          cfg_cmds.push_back($psprintf("idle 1000"));
        end
      end

      super.body();
    endtask

endclass
