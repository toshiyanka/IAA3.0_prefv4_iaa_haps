`ifndef HQM_RESET_TRANSACTION__SV
`define HQM_RESET_TRANSACTION__SV

class hqm_reset_transaction extends ovm_sequence_item;

    rand reset_flow_t reset_flow_type;
    rand bit[(`LCP_DEPTH - 1):0]    LcpDatIn;
    rand bit[15:0]                  EarlyFuseIn;

    `ovm_object_utils_begin(hqm_reset_transaction)
      `ovm_field_enum(reset_flow_t, reset_flow_type,  OVM_ALL_ON)
    `ovm_object_utils_end

    extern                   function                new(string name = "hqm_reset_transaction");
    extern                   function   void         post_randomize();

endclass:hqm_reset_transaction

function hqm_reset_transaction::new (string name = "hqm_reset_transaction");
    super.new(name);
endfunction:new

function void hqm_reset_transaction::post_randomize();
    super.post_randomize();
endfunction:post_randomize

`endif
