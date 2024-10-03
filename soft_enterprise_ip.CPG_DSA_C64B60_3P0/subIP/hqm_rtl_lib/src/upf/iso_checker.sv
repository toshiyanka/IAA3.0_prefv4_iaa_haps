(* snps_upf_component *)

module iso_checker(isolation_power,isolation_control,isolation_input,isolation_output);

    import UPF::*;
    import SNPS_LP_MSG::*;

    input supply_net_type isolation_power;
    input        logic    isolation_control;
    input        logic    isolation_input;
    input        logic    isolation_output;
    parameter    string   ISOLATION_STRATEGY_NAME = "";
    parameter    string   ISOLATION_POWER_NAME    = "";
    parameter    string   ISOLATION_CONTROL_NAME  = "";
    parameter    string   ISOLATION_INPUT_NAME    = "";
    parameter    string   ISOLATION_OUTPUT_NAME   = "";
    parameter    string   ISOLATION_SENSE         = "";
    parameter    string   ISOLATION_CLAMP         = "";
                 real     isolation_power_voltage;

    initial begin
        $display( $time,, "%m : isolation input '%s' CLAMP=%s to isolation output '%s' in isolation strategy '%s' powered by supply '%s' with isolation control '%s' SENSE=%s", ISOLATION_INPUT_NAME, ISOLATION_CLAMP, ISOLATION_OUTPUT_NAME, ISOLATION_STRATEGY_NAME, ISOLATION_POWER_NAME, ISOLATION_CONTROL_NAME, ISOLATION_SENSE );
    end // initial

    always @( isolation_control iff ($time !== 0) ) begin
        #1; // wait a timestep to avoid race in the event-queue
        if (isolation_power.state != OFF) begin // only check when isolation supply is active
            isolation_power_voltage = isolation_power.voltage/1.0e6;
            if ( (isolation_control !== 1'b1) && (isolation_control !== 1'b0) ) begin // isolation_control unknown or undriven
                lp_msg_print( "LP_ISO_CONTROL_CORRUPT_WHILE_SUPPLY_ON", $sformatf( lp_msg_get_format("LP_ISO_CONTROL_CORRUPT_WHILE_SUPPLY_ON"), isolation_control, ISOLATION_CONTROL_NAME, ISOLATION_STRATEGY_NAME, ISOLATION_POWER_NAME, isolation_power.state.name, isolation_power_voltage ) );
            end // ( (isolation_control !== 1'b1) && (isolation_control !== 1'b0) )
            else if ( isolation_control != (ISOLATION_SENSE == "1") ) begin // isolation_control is de-asserted
            //  $display( $time,, "%m : isolation supply '%s' is in active state '%s' with voltage=%fV and isolation control '%s' de-asserted to %b for isolation strategy '%s' with CLAMP=%b", ISOLATION_POWER_NAME, isolation_power.state.name, isolation_power_voltage, ISOLATION_CONTROL_NAME, isolation_control, ISOLATION_STRATEGY_NAME, ISOLATION_CLAMP );
                if ( (isolation_output !== 1'b1) && (isolation_output !== 1'b0) ) begin // isolation_output unknown or undriven
                    lp_msg_print( "LP_ISO_OUT_CORRUPT_ON_CONTROL_DEASSERT", $sformatf( lp_msg_get_format("LP_ISO_OUT_CORRUPT_ON_CONTROL_DEASSERT"),                 isolation_output, ISOLATION_OUTPUT_NAME, ISOLATION_CONTROL_NAME, isolation_control, ISOLATION_STRATEGY_NAME, ISOLATION_POWER_NAME, isolation_power.state.name, isolation_power_voltage ) );
                end // ( (isolation_output !== 1'b1) && (isolation_output !== 1'b0) )
                else if ( isolation_output != (ISOLATION_CLAMP == "1") ) begin // isolation_output is different than isolation clamp value
                    lp_msg_print( "LP_ISO_OUT_TOGGLE_ON_CONTROL_DEASSERT",  $sformatf( lp_msg_get_format("LP_ISO_OUT_TOGGLE_ON_CONTROL_DEASSERT"), ISOLATION_CLAMP, isolation_output, ISOLATION_OUTPUT_NAME, ISOLATION_CONTROL_NAME, isolation_control, ISOLATION_STRATEGY_NAME, ISOLATION_POWER_NAME, isolation_power.state.name, isolation_power_voltage ) );
                end // (isolation_output != ISOLATION_CLAMP)
            end // (isolation_control != ISOLATION_SENSE)
        end // if (isolation_power.state != OFF)
    end // always @( isolation_control iff ($time !== 0) )

endmodule : iso_checker

