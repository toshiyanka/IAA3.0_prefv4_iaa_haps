class goodbye_world_seq extends ovm_sequence;

    `ovm_sequence_utils(goodbye_world_seq, sla_sequencer)

    function new(string name = "goodbye_world_seq");
        super.new(name);
    endfunction : new

    task automatic body();
        `ovm_info(this.get_name(), "Goodbye world.", OVM_NONE)
    endtask : body

endclass : goodbye_world_seq
