class hqm_cfg_file_mode_seq extends slu_sequence_base;

    `uvm_object_utils(hqm_cfg_file_mode_seq) 

    `uvm_declare_p_sequencer(slu_sequencer)

    string      inst_suffix = "";

    string      file_plusarg;
    bit         err_if_no_file;

    function new(string name = "hqm_cfg_file_mode_seq",
                 string file_plusarg = "HQM_SEQ_CFG",
                 bit    err_if_no_file = 1'b1);
       super.new(name);

       this.file_plusarg        = file_plusarg;
       this.err_if_no_file      = err_if_no_file;
    endfunction

    function set_cfg(string file_plusarg = "HQM_SEQ_CFG", bit err_if_no_file = 1'b1);
       this.file_plusarg        = file_plusarg;
       this.err_if_no_file      = err_if_no_file;
    endfunction

    virtual task body();
       integer file_pointer;
       string  file_name = "";
       string  line;
       bit     file_mode_exists;
       
       if ($value$plusargs({file_plusarg,"=%s"}, file_name)) begin
          file_mode_exists = 1;  
       end else begin
          file_mode_exists = 0;  
          if (err_if_no_file) begin
            `uvm_error(get_full_name(),"file_name not set")
          end 
       end 

       if (file_mode_exists) begin  
         bit            do_cfg_seq;
         hqm_cfg        cfg;
         hqm_cfg_seq    cfg_seq;
         uvm_object o_tmp;

         //-----------------------------
         //-- get i_hqm_cfg
         //-----------------------------
         if (!p_sequencer.get_config_object({"i_hqm_cfg",inst_suffix}, o_tmp)) begin
           uvm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
         end 

         if (!$cast(cfg, o_tmp)) begin
           uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of cfg"));
         end    

         uvm_report_info(get_full_name(), $psprintf("CFG File Mode - %s",file_name), UVM_MEDIUM); 

         file_pointer = $fopen(file_name, "r");

         assert(file_pointer != 0) else                                                           
             uvm_report_fatal(get_full_name(), $psprintf("Failed to open %s", file_name));
      
         do_cfg_seq = 0;

         while($fgets(line, file_pointer)) begin
           if(line != "") begin
               uvm_report_info(get_full_name(), $psprintf("FILE COMMAND -> %s", line), UVM_DEBUG);
               cfg.set_cfg(line,do_cfg_seq); 
               line = "";
           end 

           if (do_cfg_seq) begin
             `uvm_create(cfg_seq)
             cfg_seq.pre_body();
             start_item(cfg_seq);	//[UVM MIGRATION][FIXME] Cannot use start_item() for uvm_sequences. Use start() method instead
             finish_item(cfg_seq);
             cfg_seq.post_body();
             do_cfg_seq = 0;
           end 
         end 
       end 
       else begin
         uvm_report_info(get_full_name(), $psprintf("To use File Mode specify file using +%s=<file_name>",file_plusarg), UVM_MEDIUM);
       end 

    endtask

endclass
