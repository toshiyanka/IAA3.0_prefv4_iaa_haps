`ifndef HQM_BACKGROUND_CFG_SEQ_SV
`define HQM_BACKGROUND_CFG_SEQ_SV

class hqm_background_cfg_seq extends hqm_base_seq;

  `ovm_sequence_utils(hqm_background_cfg_seq, sla_sequencer)

  pcie_seqlib_pkg::hqm_background_access_with_pasid_seq bg_acc_with_pasid;
  hqm_cfg       cfg;
  string        file_plusarg;
  bit           err_if_no_file;
  int           bg_cfg_num;
  int interested_id[$];
  process   p_process_file;
  process   p_pause_bg_cfg_req;
  int           sai6_val;


  ovm_event_pool		global_pool;
  ovm_event				iosf_mon_hcw_enq_event;

  typedef enum {
    BG_RD,
    BG_WR,
    BG_WR_RAND
  } bg_acc_type_t;

  typedef struct {
    string              file_name;
    string              reg_name;
    string              field_name;
    bg_acc_type_t       bg_acc_type;
    sla_ral_reg         ral_reg;
    sla_ral_field       ral_field;
    bit [31:0]          wdata;
    bit                 wdata_valid;
  } bg_acc_entry_t;

  bg_acc_entry_t        bg_acc_q[$];

  sla_ral_access_path_t         primary_id, access;

  int                   bg_cfg_delay_min;
  int                   bg_cfg_delay_max;

  function new(string name = "hqm_background_cfg_seq",
               string file_plusarg = "HQM_SEQ_BG_CFG",
               bit    err_if_no_file = 1'b0);
    super.new(name);

	global_pool = ovm_event_pool::get_global_pool();
	iosf_mon_hcw_enq_event = global_pool.get("iosf_mon_hcw_enq_event");

    this.file_plusarg           = file_plusarg;
    this.err_if_no_file         = err_if_no_file;
    primary_id                  = sla_iosf_pri_reg_lib_pkg::get_src_type();

    sai6_val=1;
    if($test$plusargs("SAI_WR_CHK_ENB")) begin
      $value$plusargs("SAI_INDEX=%0d", sai6_val);
    end
   `ovm_info(get_full_name(), $psprintf("setting of sai6_val=%0d",sai6_val),OVM_LOW)

  endfunction

  extern virtual task body();
  extern virtual task process_file();
  extern virtual task execute_bg_access();
  extern virtual task send_simultaneous_read(sla_ral_reg _reg_);
  extern virtual task send_simultaneous_write(sla_ral_reg _reg_, sla_ral_data_t _data_);
  extern function sla_ral_access_path_t select_bg_cfg_access_path(string selected_access);
  extern function bit check_process_state(process p, process::state e_state = process::FINISHED);

task gen_rand_cfg_read(sla_ral_file file);
  int idx;
  sla_status_t            status; 
  sla_ral_data_t			wr_val, rd_val;

  sla_ral_reg regs[$];
  file.get_regs(regs);
  idx = $urandom_range(0,(regs.size()-1 ));
  ovm_report_info(get_full_name(), $psprintf("Sent random read for reg (%s) from reg_file (%s)", regs[idx].get_name(), file.get_name()),OVM_LOW);
  regs[idx].read(status, rd_val, primary_id);
endtask

task gen_rand_cfg_write(sla_ral_file file, boolean_t rand_wr=SLA_FALSE, bit do_random=1);
  int idx, interested_idx=0;
  sla_status_t            status; 
  sla_ral_data_t			wr_val, rd_val;

  sla_ral_reg regs[$];
  sla_ral_data_t cur_rd_val;
  file.get_regs(regs);
  forever begin
	if(do_random)  idx = $urandom_range(0,(regs.size()-1 ));
	else if(interested_id.size()>0) begin
	  idx = interested_id[interested_idx]; interested_idx++;
	  interested_idx=interested_idx%interested_id.size();
	end  
	if(|regs[idx].get_attr_mask("RW")) begin 
	  wr_val = $urandom_range(0,(2**regs[idx].get_size()-1));
	  wr_val = wr_val & regs[idx].get_attr_mask("RW");	
	  if(rand_wr==SLA_FALSE) begin
		regs[idx].read(status, cur_rd_val, primary_id);
		wr_val = cur_rd_val;
	  end
	  ovm_report_info(get_full_name(), $psprintf("Sent random write for reg (%s) from reg_file (%s) val (0x%0x)", regs[idx].get_name(), file.get_name(), wr_val),OVM_LOW);
	  regs[idx].write(status, wr_val, primary_id);	
	  break; 
	end
  end
endtask

task gen_rand_cfg_access(sla_ral_env ral_);
  int idx,cfg_count;
  sla_ral_file files[$];
  ral_.get_reg_files(files);

  if($test$plusargs("HQM_BACKGROUND_RAND_CFG_GEN_SEQ"))  begin
	if (!$value$plusargs("HQM_BG_CFG_NUM=%d",cfg_count)) begin
  	  cfg_count=100;
  	end

  	iosf_mon_hcw_enq_event.wait_trigger();
  	`ovm_info(get_full_name(), $psprintf("Starting hqm_background_cfg_seq for cfg_count(0x%0x)",cfg_count),OVM_LOW)

  	for(int i=0;i<cfg_count;i++)	begin
  	  if(cfg.test_done==1'b1) break;
  	  idx=$urandom_range(0,files.size()-1);
  	  gen_rand_cfg_read(files[idx]);
  	  gen_rand_cfg_write(files[idx]);
  	end
	`ovm_info(get_full_name(), $psprintf("Stopping hqm_background_cfg_seq as test_done (0x%0x) received!!",cfg.test_done),OVM_LOW)
  end 
  else	
	`ovm_info(get_full_name(),$psprintf("Avoiding random background_cfg_seq as HQM_BACKGROUND_RAND_CFG_GEN_SEQ=%0d",$test$plusargs("HQM_BACKGROUND_RAND_CFG_GEN_SEQ")),OVM_LOW)

endtask
endclass

task hqm_background_cfg_seq::body();
  ovm_object o;
  string      if_name;

  //get cfg object
  if (cfg == null) begin
    cfg = hqm_cfg::get();
    if (cfg == null) begin
      ovm_report_fatal(get_full_name(), $psprintf("Unable to get CFG object"));
    end
  end

  get_hqm_pp_cq_status();

  fork
    begin
       gen_rand_cfg_access(ral_env);
    end
  join_none
  
  fork 
    begin
      p_process_file = process::self();
      process_file();
      execute_bg_access();
    end
    begin // -- Background reg access with PASID prefixes -- //
      `ovm_do(bg_acc_with_pasid);
    end
    begin
      p_pause_bg_cfg_req = process::self();
      forever begin
        i_hqm_pp_cq_status.pause_bg_cfg_ack = 1'b0;
        wait (i_hqm_pp_cq_status.pause_bg_cfg_req == 1);
        ovm_report_info(get_full_name(), $psprintf("Received pause_bg_cfg_req; suspending the background_cfg_seq"), OVM_LOW);
        while ( !check_process_state(p_process_file, process::SUSPENDED) ) begin
          wait_for_clk();
        end
        i_hqm_pp_cq_status.pause_bg_cfg_ack = 1'b1;
        wait (i_hqm_pp_cq_status.pause_bg_cfg_req == 0);
        ovm_report_info(get_full_name(), $psprintf("Received pause_bg_cfg_req; resuming the background_cfg_seq"), OVM_LOW);
        p_process_file.resume();
      end
    end
    begin
      while( !check_process_state(p_process_file) ) begin
        wait_for_clk();
      end
      i_hqm_pp_cq_status.pause_bg_cfg_ack = 1'b1;
      ovm_report_info(get_full_name(), $psprintf("Killing the pause_bg_cfg thread"), OVM_LOW);
      p_pause_bg_cfg_req.kill();
    end
  join
endtask

function sla_ral_access_path_t hqm_background_cfg_seq::select_bg_cfg_access_path(string selected_access);
  case(selected_access)
    "primary" : select_bg_cfg_access_path=sla_iosf_pri_reg_lib_pkg::get_src_type();
    "sideband": select_bg_cfg_access_path=iosf_sb_sla_pkg::get_src_type();
    default   : select_bg_cfg_access_path=($urandom_range(0,1) ? sla_iosf_pri_reg_lib_pkg::get_src_type():iosf_sb_sla_pkg::get_src_type());
//	default	  : select_bg_cfg_access_path=sla_iosf_pri_reg_lib_pkg::get_src_type();
  endcase
endfunction

task hqm_background_cfg_seq::send_simultaneous_write(sla_ral_reg _reg_, sla_ral_data_t _data_);
  sla_status_t      p_status,s_status;
  fork
    begin _reg_.write(p_status,_data_,sla_iosf_pri_reg_lib_pkg::get_src_type(),this,.sai(sai6_val));  end 
    begin _reg_.write(s_status,_data_,iosf_sb_sla_pkg::get_src_type(),this,.sai(sai6_val)); end 
  join
endtask

task hqm_background_cfg_seq::send_simultaneous_read(sla_ral_reg _reg_);
  sla_status_t      p_status,s_status;
  sla_ral_data_t    p_rdata, s_rdata;
  fork
    begin _reg_.read(p_status,p_rdata,sla_iosf_pri_reg_lib_pkg::get_src_type(),this,.sai(sai6_val));  end 
    begin _reg_.read(s_status,s_rdata,iosf_sb_sla_pkg::get_src_type(),this,.sai(sai6_val)); end 
  join
endtask

task hqm_background_cfg_seq::execute_bg_access();
  integer             file_pointer;
  string              file_name = "";
  string              line;
  bit                 file_mode_exists;
  bg_acc_entry_t      bg_acc_entry;
  string              token;
  string              bg_cfg_access_path="";
  string              explode_q[$];

  bg_cfg_num = 0;

  if(!$value$plusargs("HQM_BG_CFG_SEQ_ACCESS=%s",bg_cfg_access_path)) bg_cfg_access_path="random";

  if (bg_acc_q.size() > 0) begin
    if (!$value$plusargs({"HQM_BG_CFG_NUM","=%s"}, token)) token="500";
      if (!lvm_common_pkg::token_to_longint(token, bg_cfg_num)) begin
        bg_cfg_num = 0;
      end
  end

  while (bg_cfg_num > 0) begin
    sla_status_t      status;
    int               entry_num;
    int               bg_cfg_delay;
    sla_ral_data_t    rdata;
    sla_ral_reg       reg_h;

    primary_id=select_bg_cfg_access_path(bg_cfg_access_path);

    entry_num = $urandom_range(bg_acc_q.size()-1,0);
    reg_h = ral_env.find_reg_by_file_name("csr_bar_u", "hqm_pf_cfg_i");

    if (i_hqm_pp_cq_status.pause_bg_cfg_req == 1'b1) begin
        ovm_report_info(get_full_name(), $psprintf("Received pause_bg_cfg_req; suspending the background_cfg_seq"), OVM_LOW);
        p_process_file.suspend();
    end

    if (bg_acc_q[entry_num].bg_acc_type == BG_RD) begin
      ovm_report_info("BG CFG SEQ", $psprintf("Background CFG read of register %s.%s",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name), OVM_LOW);

      if(!$test$plusargs("HQM_BACKGROUND_CFG_SIMULTANEOUS")) begin bg_acc_q[entry_num].ral_reg.read(status,rdata,primary_id,this,.sai(sai6_val)); end
      else                                                 begin send_simultaneous_read(bg_acc_q[entry_num].ral_reg);                    end
    end else if (bg_acc_q[entry_num].bg_acc_type == BG_WR) begin
      if (bg_acc_q[entry_num].wdata_valid) begin
		  if(|bg_acc_q[entry_num].ral_reg.get_attr_mask("RW")) begin 
	  	    bg_acc_q[entry_num].wdata = bg_acc_q[entry_num].wdata & bg_acc_q[entry_num].ral_reg.get_attr_mask("RW");
      	    ovm_report_info("BG CFG SEQ", $psprintf("Background CFG write of register %s.%s - wdata = 0x%0x",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name,bg_acc_q[entry_num].wdata), OVM_LOW);
      	 if(!$test$plusargs("HQM_BACKGROUND_CFG_SIMULTANEOUS")) begin bg_acc_q[entry_num].ral_reg.write(status,bg_acc_q[entry_num].wdata,primary_id,this,.sai(sai6_val)); end
         else                                                 begin send_simultaneous_write(bg_acc_q[entry_num].ral_reg, bg_acc_q[entry_num].wdata);             end
	  	  end else begin
      	    ovm_report_info("BG CFG SEQ", $psprintf("Skipping Background CFG write of register %s.%s - wdata = 0x%0x",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name,bg_acc_q[entry_num].wdata), OVM_LOW);
	  	  end
      end else begin
        ovm_report_info("BG CFG SEQ", $psprintf("Background CFG read of register %s.%s",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name), OVM_LOW);

        bg_acc_q[entry_num].ral_reg.read(status,rdata,primary_id,this,.sai(sai6_val));
        bg_acc_q[entry_num].wdata       = rdata;
        bg_acc_q[entry_num].wdata_valid = 1'b1;
      end
    end else if (bg_acc_q[entry_num].bg_acc_type == BG_WR_RAND) begin
      std::randomize(bg_acc_q[entry_num].wdata);

      ovm_report_info("BG CFG SEQ", $psprintf("Background CFG write of register %s.%s - wdata = 0x%0x",bg_acc_q[entry_num].file_name,bg_acc_q[entry_num].reg_name,bg_acc_q[entry_num].wdata), OVM_LOW);

      if(!$test$plusargs("HQM_BACKGROUND_CFG_SIMULTANEOUS")) begin bg_acc_q[entry_num].ral_reg.write(status,bg_acc_q[entry_num].wdata,primary_id,this,.sai(sai6_val)); end
      else                                                 begin send_simultaneous_write(bg_acc_q[entry_num].ral_reg, bg_acc_q[entry_num].wdata);             end 
    end

    bg_cfg_delay = $urandom_range(bg_cfg_delay_max,bg_cfg_delay_min);

    while (bg_cfg_delay > 0) begin
      #1ns;
      bg_cfg_delay--;
    end

    //if (cfg.test_done==1'b1) begin
	// `ovm_info(get_full_name(), $psprintf("Stopping hqm_background_cfg_seq as test_done (0x%0x) received!!",cfg.test_done),OVM_LOW)
    //  bg_cfg_num = 0;
    //end else begin
      bg_cfg_num--;
    //end
  end
endtask

task hqm_background_cfg_seq::process_file();
  integer             file_pointer;
  string              file_name = "";
  string              line;
  bit                 file_mode_exists;
  bg_acc_entry_t      bg_acc_entry;
  string              token;
  string              explode_q[$];

  if (!$value$plusargs({file_plusarg,"=%s"}, file_name))  begin
     if($test$plusargs("HQM_BACKGROUND_CFG_RD_ONLY"))  
        file_name="$WORKAREA/src/val/tb/hqm/tests/hqm_bg_rd.cft";
     else 
        file_name="$WORKAREA/src/val/tb/hqm/tests/hqm_bg_rd_wr.cft";
  end
  file_mode_exists = 1;  

  if (file_mode_exists) begin  
    if (ral_env.get_config_string("primary_id",access)) begin
      primary_id = access;
    end

    bg_cfg_delay_min  = 10;

    if ($value$plusargs({"HQM_BG_CFG_DELAY_MIN","=%s"}, token)) begin
      if (!lvm_common_pkg::token_to_longint(token, bg_cfg_delay_min)) begin
        bg_cfg_delay_min = 0;
      end
    end

    bg_cfg_delay_max  = bg_cfg_delay_min;

    if ($value$plusargs({"HQM_BG_CFG_DELAY_MAX","=%s"}, token)) begin
      if (!lvm_common_pkg::token_to_longint(token, bg_cfg_delay_max)) begin
        bg_cfg_delay_max = 0;
      end
    end

    if ((bg_cfg_delay_min < 0) || (bg_cfg_delay_max < 0)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Illegal values - bg_cfg_delay_min=%d bg_cfg_delay_max=%d", bg_cfg_delay_min,bg_cfg_delay_max));
    end

    ovm_report_info("BG CFG SEQ", $psprintf("CFG File Mode - %s",file_name), OVM_LOW); 

    file_pointer = $fopen(file_name, "r");
    assert(file_pointer != 0) else                                                           
      ovm_report_fatal(get_full_name(), $psprintf("Failed to open %s", file_name));
    
    while($fgets(line, file_pointer)) begin
      ovm_report_info("BG CFG SEQ", $psprintf("FILE COMMAND -> %s", line), OVM_DEBUG);

      token = lvm_common_pkg::parse_token(line);

      token.tolower();

      bg_acc_entry.file_name          = "";
      bg_acc_entry.reg_name           = "";
      bg_acc_entry.field_name         = "";
      bg_acc_entry.bg_acc_type        = BG_RD;
      bg_acc_entry.ral_reg            = null;
      bg_acc_entry.ral_field          = null;
      bg_acc_entry.wdata              = 32'h0;
      bg_acc_entry.wdata_valid        = 1'b0;

      case (token)
        "bgrd": begin
          bg_acc_entry.bg_acc_type    = BG_RD;
        end
        "bgwr": begin
          bg_acc_entry.bg_acc_type    = BG_WR;
        end
        "bgwr_rand": begin
          bg_acc_entry.bg_acc_type    = BG_WR_RAND;
        end
        default: begin
          `ovm_error("BG CFG SEQ",$psprintf("Command %s not recognized (bgrd | bgwr)",token))
          return;
        end
      endcase

      token = lvm_common_pkg::parse_token(line);

      token.tolower();

      explode_q.delete();
      lvm_common_pkg::explode(".",token,explode_q,3);

      if (explode_q.size() == 2) begin        // file.reg
        bg_acc_entry.file_name        = explode_q[0];
        bg_acc_entry.reg_name         = explode_q[1];
      end else if (explode_q.size() == 3) begin
        bg_acc_entry.file_name        = explode_q[0];
        bg_acc_entry.reg_name         = explode_q[1];
        bg_acc_entry.field_name       = explode_q[1];
      end else begin
        `ovm_error("BG CFG SEQ",$psprintf("register/field specifier %s not legal)",token))
        return;
      end

      bg_acc_entry.ral_reg = ral_env.find_reg_by_file_name(bg_acc_entry.reg_name, bg_acc_entry.file_name);

      if (bg_acc_entry.ral_reg == null) begin
        `ovm_error("BG CFG SEQ",$psprintf("Unable to find register %s.%s)",bg_acc_entry.file_name,bg_acc_entry.reg_name))
      end else begin
        if (bg_acc_entry.field_name == "") begin
          bg_acc_q.push_back(bg_acc_entry);
        end else begin
          bg_acc_entry.ral_field = bg_acc_entry.ral_reg.find_field(bg_acc_entry.field_name);
          if (bg_acc_entry.ral_field == null) begin
            `ovm_error("BG CFG SEQ",$psprintf("Unable to find field %s.%s.%s)",bg_acc_entry.file_name,bg_acc_entry.reg_name,bg_acc_entry.field_name))
          end else begin
            bg_acc_q.push_back(bg_acc_entry);
          end
        end
      end
    end 
  end else begin
    ovm_report_info("BG CFG SEQ", $psprintf("To use File Mode specify file using +%s=<file_name>",file_plusarg), OVM_LOW);
  end

endtask

function bit hqm_background_cfg_seq::check_process_state(process p, process::state e_state = process::FINISHED);

    ovm_report_info(get_full_name(), $psprintf("check_process_state(e_state=%p) -- Start", e_state), OVM_DEBUG);
    check_process_state = 1'b0;
    if ( (p.status() == process::FINISHED) || (p.status() == e_state) ) begin
      check_process_state = 1'b1;
    end
    ovm_report_info(get_full_name(), $psprintf("check_process_state(e_state=%p, check_process_state=%0b) -- End", e_state, check_process_state), OVM_DEBUG);

endfunction : check_process_state

`endif //HQM_BACKGROUND_CFG_SEQ_SV
