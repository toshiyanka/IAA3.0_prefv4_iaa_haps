`ifndef HQM_FUNC_COV_COLLECTOR__SV
`define HQM_FUNC_COV_COLLECTOR__SV

class hqm_func_cov_collector extends ovm_component;

    bit         cfg_done;

    string      inst_suffix = "";

    hqm_iosf_func_cov i_hqm_iosf_func_cov;

    ovm_analysis_export #(iosf_trans_type_st)                      iosf_trans_type_export;
    ovm_analysis_imp    #(hcw_transaction, hqm_func_cov_collector) hcw_trans_analysis_imp;

    `ovm_component_utils(hqm_func_cov_collector)

    extern function      new     (string name = "hqm_func_cov_collector", ovm_component parent = null);
    extern function void build   ();
    extern function void connect ();
    extern function void write   (hcw_transaction t);
    extern function void set_inst_suffix(string new_inst_suffix);

endclass : hqm_func_cov_collector

function hqm_func_cov_collector::new(string name = "hqm_func_cov_collector", ovm_component parent = null);
    super.new(name, parent);
    cfg_done = 1'b0;
endfunction : new

function void hqm_func_cov_collector::build();

    `START_TEMPL($psprintf("build"));
    i_hqm_iosf_func_cov = hqm_iosf_func_cov::type_id::create("i_hqm_iosf_func_cov", this);
    iosf_trans_type_export = new("iosf_trans_type_export", this);
    hcw_trans_analysis_imp = new("hcw_trans_analysis_imp", this);
    `END_TEMPL($psprintf("build"));

endfunction : build

function void hqm_func_cov_collector::connect();

    `START_TEMPL($psprintf("connect"))
    iosf_trans_type_export.connect(i_hqm_iosf_func_cov.analysis_imp);
    `END_TEMPL($psprintf("connect"))

endfunction : connect

function void hqm_func_cov_collector::write(hcw_transaction t);

    `START_TEMPL($psprintf("write"))
    if (~cfg_done) begin

        i_hqm_iosf_func_cov.get_ral_cfg();
        cfg_done = 1'b1;
        
    end
    `END_TEMPL($psprintf("write"))

endfunction : write

function void hqm_func_cov_collector::set_inst_suffix (string new_inst_suffix);
  inst_suffix = new_inst_suffix;
  if (i_hqm_iosf_func_cov != null) begin
    i_hqm_iosf_func_cov.inst_suffix = new_inst_suffix;
  end
endfunction : set_inst_suffix

`endif //HQM_FUNC_COV_COLLECTOR__SV
