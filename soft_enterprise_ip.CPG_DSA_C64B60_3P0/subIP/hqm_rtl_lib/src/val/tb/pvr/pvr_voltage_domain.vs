//=======================================================================
//
// pvr_voltage_domain.vs
//
//
// These are the PVR base modules for instantiation.
//
// 
//=======================================================================


`ifndef LINT_ON

    //
    // Voltage Model
    //   This is a validation model of a voltage domain, with on/off modelling and
    //   hooks to bypass platform inputs and provide specific control.  It is
    //   assumed that external sources (VR BFMs, ResetSequenceDrv) will drive the
    //   voltage input and the TE will consume the 0/1 output.
    //
    //   VCS-NLP also consumes the run-time controllabale supply_on/supply_off calls
    //   based on the intput voltage and input thresholds.
    //
    module pvr_voltage_domain (

        output   logic  vcc_out,                 // ON/OFF Indication for domain
        output   logic  vcc_retention,           // RETENTION indication for domain
        input    real  vcc_in_real,             // Voltage input
        input    logic  power_enable_in,         // Domain Enable, used for gated domains
        input    real  vcc_on_voltage,          // ON voltage threshold (VMin)
        input    real  vcc_retention_voltage);  // RETENTION voltage threshold (VRet)

        // The name of the power domain
        // Used to direct VCS-NLP system tasks for turning power domain supplies on/off
        parameter voltage_domain_name = "NO_DOMAIN_NAME_PROVIDED";


        // This module will be swapped out in AMS simulations
        pvr_voltage_domain_internal #(voltage_domain_name) voltage_domain_internal (
            .vcc_out(vcc_out),
            .vcc_retention(vcc_retention), 
            .vcc_in_real(vcc_in_real),
            .vcc_on_voltage(vcc_on_voltage),
            .vcc_retention_voltage(vcc_retention_voltage),
            .power_enable_in(power_enable_in)
        );

    endmodule   // voltage_domain



    //
    // Voltage Model Internal Details
    //   This is a separate model because AMS will swap out the internals.  However
    //   AMS simulation still want some of the functionality inside 'voltage_domain()'.
    //
    

    module pvr_voltage_domain_internal (

        output   logic  vcc_out,
        output   logic  vcc_retention,
        input    real  vcc_in_real,
        input    logic  power_enable_in,
        input    real  vcc_on_voltage,
        input    real  vcc_retention_voltage);

        logic tmp_vcc_out;
        logic tmp_vcc_out_node;
        logic tmp_vcc_retention;
        logic tmp_vcc_retention_node;

        // The name of the power domain
        // Used to direct VCS-NLP system tasks for turning power domain supplies on/off
        parameter voltage_domain_name = "NO_DOMAIN_NAME_PROVIDED";


        // Output voltage decoding assignments (ON/OFF/RETENTION)
        // Note:  The ON voltage includes the ON and RETENTION domains, because we want the TE
        //        operating in these regions and 'qualified'.  Only when we get to OFF do we
        //        remove power from the TE (CRAs, etc.).
        assign tmp_vcc_out       = (power_enable_in) ? ((vcc_in_real >= vcc_on_voltage) || (vcc_in_real >= vcc_retention_voltage)) : 1'b0;
        assign tmp_vcc_retention = (power_enable_in) ? ((vcc_in_real >= vcc_retention_voltage) && (vcc_in_real < vcc_on_voltage)) : 1'b0;

        always_comb begin 
            tmp_vcc_out_node       <= #2 tmp_vcc_out;
            tmp_vcc_retention_node <= #2 tmp_vcc_retention;
        end
        assign vcc_out       = tmp_vcc_out_node;
        assign vcc_retention = tmp_vcc_retention_node;
    
    
        always @(posedge vcc_out or negedge vcc_out or posedge vcc_retention or negedge vcc_retention) begin
            if (vcc_out == 0) begin
                $display("[%10t] [PVR] [%s] Voltage Domain has reached the OFF Voltage",$time, voltage_domain_name);
            end else if (vcc_retention == 1) begin
                $display("[%10t] [PVR] [%s] Voltage Domain has reached the RETENTION Voltage",$time, voltage_domain_name);
            end else if (vcc_out == 1) begin
                $display("[%10t] [PVR] [%s] Voltage Domain has reached the ON Voltage",$time, voltage_domain_name);
            end
        end
    

        //
        // This section defines the Power-Loss State Corruption behavior for each
        // voltage domain.  This is done via supply_on()/supply_off() commands to
        // work around relative hierarchy issues in the UPF (using SWITCH statements)
        // and instead controlling the power-aware behavior here.
        //
        // NOTE:
        //     This code is only allowed when the '-upf' switch is on the command-line, which
        //     is only in the VCS compile stage.  So we use the MPP define to denote if the UPF
        //     is enabled, and a run-time VCS argument to actually disable corruption.
        //
        import UPF::*;
    
            // Importation used for supply_on/supply_off calls

            //
            // This is a run-time command-line switch to disable power-loss state corruption
            //
            bit corruption_disable;
    
            initial begin
                // If this is a gated voltage domain, then we will let the UPF connectivity manage
                // corruption (and the PGT model), not the PVR.  This is an exception since otherwise
                // the FE and BE connectivity would be different with the PGT output.
                //
                corruption_disable = ($test$plusargs("corruptDis"));
                if (corruption_disable == 1) begin
                    $display("[%10t] [PVR] [%s]... Run-time power-loss state corruption has been disabled via corruptDis VCS argument",$time, voltage_domain_name);
                end else begin
                    $display("[%10t] [PVR] [%s] Initial corruption and supply_off() call for this voltage domain",$time, voltage_domain_name);
                    supply_off (voltage_domain_name);
                end
            end
    

    
            // This gets tricky.
            // 1) We want to turn the voltage off *after*  we de-assert vcc_out
            // 2) We want to turn the voltage on  *before* we assert vcc_out
            always @(tmp_vcc_out or vcc_out or tmp_vcc_retention or vcc_retention) begin


                if (corruption_disable == 0) begin
                    if ((vcc_retention == 0) && (tmp_vcc_retention == 1) && (vcc_out == 0) && (tmp_vcc_out == 1)) begin
                        // OFF --> RETENTION
                        #4 $display("[%10t] [PVR] [%s] Begin corrupt-on-change for voltage domain",$time, voltage_domain_name);
                        supply_on (voltage_domain_name, vcc_in_real);  
                    end else if ((vcc_retention == 0) && (tmp_vcc_retention == 1) && (vcc_out == 1) && (tmp_vcc_out == 1)) begin
                        // ON --> RETENTION
                        #4 $display("[%10t] [PVR] [%s] Begin corrupt-on-change for voltage domain",$time, voltage_domain_name);
                        supply_on (voltage_domain_name, vcc_in_real);  
                    end else if ((vcc_retention == 0) && (tmp_vcc_retention == 0) && (vcc_out == 1) && (tmp_vcc_out == 0)) begin
                        // ON --> OFF
                        #4 $display("[%10t] [PVR] [%s] Begin corrupting voltage domain (Turning supply OFF in VCS)",$time, voltage_domain_name);
                        //10nm: No need for supply_on
                        //supply_on (voltage_domain_name, 0.0);
                        supply_off (voltage_domain_name);
                    end else if ((vcc_retention == 0) && (tmp_vcc_retention == 0) && (vcc_out == 0) && (tmp_vcc_out == 1)) begin
                        // OFF --> ON
                        $display("[%10t] [PVR] [%s] Stop corrupting voltage domain (Turning supply ON in VCS)",$time, voltage_domain_name);
                        supply_on (voltage_domain_name, vcc_in_real);  
                    end else if ((vcc_retention == 1) && (tmp_vcc_retention == 0) && (vcc_out == 1) && (tmp_vcc_out == 0)) begin
                        // RETENTION --> OFF
                        #4 $display("[%10t] [PVR] [%s] Begin corrupting voltage domain (Turning supply OFF in VCS)",$time, voltage_domain_name);
                        //10nm: No need for supply_on
                        supply_on (voltage_domain_name, 0.0);
                        supply_off (voltage_domain_name);
                    end else if ((vcc_retention == 1) && (tmp_vcc_retention == 0) && (vcc_out == 1) && (tmp_vcc_out == 1)) begin
                        // RETENTION --> ON
                        $display("[%10t] [PVR] [%s] Stop corrupting voltage domain (Turning supply ON in VCS)",$time, voltage_domain_name);
                        supply_on (voltage_domain_name, vcc_in_real);  
                    end
                end
            end
    
        //`endif

    endmodule   // pvr_voltage_domain

`endif
