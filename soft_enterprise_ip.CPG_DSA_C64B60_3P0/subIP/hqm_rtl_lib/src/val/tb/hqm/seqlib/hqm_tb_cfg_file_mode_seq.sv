
class hqm_tb_cfg_file_mode_seq extends sla_sequence_base;

    `ovm_sequence_utils(hqm_tb_cfg_file_mode_seq, sla_sequencer)

    string      file_plusarg;
    bit         err_if_no_file;
    sla_tb_env  loc_tb_env;
    sla_phase_name_t curr_phase;

    function new(string name = "hqm_tb_cfg_file_mode_seq");
       super.new(name);
       loc_tb_env           = sla_tb_env::get_top_tb_env();
       curr_phase           = loc_tb_env.get_current_test_phase();
       this.err_if_no_file  = 1'b1;
       this.file_plusarg    =   (curr_phase == "CONFIG_PHASE")  ? "HQM_SEQ_CFG" :
                                (curr_phase == "DATA_PHASE")    ? "HQM_SEQ_CFG_USER_DATA" :
                                (curr_phase == "FLUSH_PHASE")   ? "HQM_SEQ_CFG_EOT" : "HQM_SEQ_CFG_OPT"; 
       ovm_report_info("FILE CFG SEQ", $psprintf("hqm_tb_cfg_file_mode_seq: new file_plusarg=%s curr_phase=%s", file_plusarg, curr_phase), OVM_MEDIUM);   
    endfunction

    function set_cfg(string file_plusarg = "HQM_SEQ_CFG", bit err_if_no_file = 1'b1);
       this.file_plusarg        = file_plusarg;
       this.err_if_no_file      = err_if_no_file;
       ovm_report_info("FILE CFG SEQ", $psprintf("hqm_tb_cfg_file_mode_seq: set_cfg file_plusarg=%s err_if_no_file=%0d", file_plusarg, err_if_no_file), OVM_MEDIUM);   
    endfunction

 virtual task body();
    integer          file_pointer;
    string           file_name = "";
    string           line;
    bit              file_mode_exists;
    int              post_delay;

    if ($value$plusargs({file_plusarg,"=%s"}, file_name)) begin
       file_mode_exists = 1;  
       ovm_report_info("FILE CFG SEQ", $psprintf("hqm_tb_cfg_file_mode_seq: body file_plusarg=%s file_name=%s", file_plusarg, file_name), OVM_MEDIUM);   
    end else begin
       file_mode_exists = 0;  
       if (err_if_no_file) begin
         `ovm_error("FILE CFG SEQ","file_name not set")
       end
    end

    if (file_mode_exists) begin  
        bit                    do_cfg_seq;
        hqm_tb_cfg_seq          cfg_seq;
        hqm_tb_cfg              cfg;
        //hqm_rndcfg_tgen_seq     tgen;
        //hqm_sys_rndcfg          i_rndcfg;
        //if(!$cast(i_rndcfg, hqm_sys_rndcfg::get()))
        //    `ovm_error(get_name(), "Failed to get rndcfg handle");

        $cast(cfg,hqm_tb_cfg::get());

        ovm_report_info("FILE CFG SEQ", $psprintf("hqm_tb_cfg_file_mode_seq: CFG File Mode - %s",file_name), OVM_MEDIUM); 


        file_pointer = $fopen(file_name, "r");
        assert(file_pointer != 0) else                                                           
            ovm_report_fatal(get_full_name(), $psprintf("Failed to open %s", file_name));
   
        //while((i_rndcfg.is_active()) || $fgets(line, file_pointer)) begin
        while($fgets(line, file_pointer)) begin
            if(line != "") begin
                ovm_report_info("FILE CFG SEQ", $psprintf("hqm_tb_cfg_file_mode_seq: FILE COMMAND -> %s", line), OVM_MEDIUM);
                cfg.set_cfg(line,do_cfg_seq); 
                line = "";
            end
            //if((do_cfg_seq == 0) && i_rndcfg.is_active())begin
                //@(posedge cfg.pins.aon_clk);
            //    @ (sla_tb_env::sys_clk_r);
            //    if(cfg.ready_to_send()) begin
            //        `ovm_create(tgen)
            //        `ovm_send(tgen);
            //        do_cfg_seq = 1;
            //    end
            //end
            if (do_cfg_seq) begin
                `ovm_create(cfg_seq)
                cfg_seq.pre_body();
                start_item(cfg_seq);
                finish_item(cfg_seq);
                cfg_seq.post_body();
                do_cfg_seq = 0;
            end
        end 

       if ($value$plusargs({file_plusarg,"_POST_DELAY=%d"}, post_delay)) begin
         for(int i = 0; i < post_delay; i++)begin         // wait for 10k cycles post simulation so that packets can be dequeued
           //@(posedge cfg.pins.aon_clk);
            @ (sla_tb_env::sys_clk_r);
         end
       end

    end else begin
      ovm_report_info("FILE CFG SEQ", $psprintf("To use File Mode specify file using +%s=<file_name>",file_plusarg), OVM_MEDIUM);
    end

 endtask

//   task pre_body();
//     ovm_test_done.raise_objection(this);
//   endtask
// 
//   task post_body();
//     ovm_test_done.drop_objection(this);
//   endtask

endclass
