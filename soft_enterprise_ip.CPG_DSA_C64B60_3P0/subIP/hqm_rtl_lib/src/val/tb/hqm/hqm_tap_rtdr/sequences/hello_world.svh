class hello_world_seq extends ovm_sequence;

    `ovm_sequence_utils(hello_world_seq, sla_sequencer)

    function new(string name = "hello_world_seq");
        super.new(name);
    endfunction : new

    task automatic body();
        `ovm_info(this.get_name(), "Hello world.", OVM_NONE)
    endtask : body

endclass : hello_world_seq
