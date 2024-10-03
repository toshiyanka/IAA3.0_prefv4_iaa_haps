
`ifndef HQM_RESET_SEQUENCER__SV
`define HQM_RESET_SEQUENCER__SV

class hqm_reset_sequencer extends ovm_sequencer#(hqm_reset_transaction);

    `ovm_sequencer_utils_begin(hqm_reset_sequencer)
    `ovm_sequencer_utils_end

    ovm_analysis_port#(hqm_reset_transaction)             test_item_port; 

    extern                   function                new(string name = "hqm_reset_sequencer", ovm_component parent = null);
    extern virtual           function void           build();

endclass:hqm_reset_sequencer

function hqm_reset_sequencer::new (string name = "hqm_reset_sequencer", ovm_component parent = null);
    super.new(name, parent);
endfunction:new

function void hqm_reset_sequencer::build();
    super.build();
    test_item_port = new("test_item_port", this);
endfunction:build

`endif
