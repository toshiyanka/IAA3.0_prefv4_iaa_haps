`ifndef HQM_RESET_AGENT__SV
`define HQM_RESET_AGENT__SV

class hqm_reset_agent extends ovm_agent;

    hqm_reset_driver       driver;
    hqm_reset_monitor      monitor;
    hqm_reset_sequencer    sequencer;
    protected hqm_reset_config  cfg;

    `ovm_component_utils_begin(hqm_reset_agent)
    `ovm_component_utils_end

    extern                   function                new(string name = "hqm_reset_agent", ovm_component parent = null);
    extern virtual           function void           build();
    extern virtual           function void           connect();

endclass:hqm_reset_agent

function hqm_reset_agent::new (string name = "hqm_reset_agent", ovm_component parent = null);
    super.new(name, parent);
endfunction:new

function void hqm_reset_agent::build();
    super.build();
   
    cfg = hqm_reset_config::type_id::create("cfg",this);
    if (cfg.is_active == OVM_ACTIVE) begin
        driver    = hqm_reset_driver::type_id::create("driver",this);
        sequencer = hqm_reset_sequencer::type_id::create("sequencer",this);
    end

    monitor = hqm_reset_monitor::type_id::create("monitor",this);

endfunction:build

function void hqm_reset_agent::connect();
    super.connect();
    if (cfg.is_active == OVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
endfunction:connect

`endif


