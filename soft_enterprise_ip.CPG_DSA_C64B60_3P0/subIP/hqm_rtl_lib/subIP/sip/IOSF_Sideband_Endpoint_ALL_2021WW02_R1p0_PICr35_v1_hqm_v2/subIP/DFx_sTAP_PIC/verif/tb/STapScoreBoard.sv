//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapScoreBoard.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Score Board for the ENV
//    DESCRIPTION : This is the scoreboard for the ENV. It models the
//                  DUT and reports any mismatch in behaviour between
//                  the model and the RTL.
//                  The DUT is modelled as two set of configurable
//                  register, one is a shift register between the TDI and
//                  TDO and other one is the Shadow register.
//                  The Width of the register is configured by the parameters
//                  that is Number of registers, width of registers.
//                  Also some flops in the register load Pin(strap) values
//                  at Capture, for others respective shadow values are looped
//                  back. Also at update state the respective shift flops are
//                  copied to the shadow flops.
//                  This set is instantiated once for Instruction and once for data
//----------------------------------------------------------------------

`include "ovm_macros.svh"
// Following declarations are for variable "mode" to access different registers
localparam BYPASS    = 2'b01;
localparam SLVIDCODE = 2'b10;
localparam RW_REG    = 2'b11; // All the registers except BYPASS & SLVIDCODE
localparam NO_REG    = 2'b00;
// Following are type of resets
localparam RSTTYPE_PWRGD_00 = 2'b00;
localparam RSTTYPE_TRSTB_01 = 2'b01;
localparam RSTTYPE_SWCLR_10 = 2'b10;
localparam RSTTYPE_TRSTB_11 = 2'b11;

// Following declarations are for "mltapc_mode" to indicate the status of the current TAP on the Network
localparam NORMAL   = 2'b01;
localparam EXCLUDED = 2'b10;

// Following declarations are for indexing into "mltapc_mode" when used with WTAP
localparam BIT_ONE_FOR_WTAP_ZERO_FOR_MTAP_STAP = MULTIPLE_TAP;

// Following declarations are for general purpose
localparam DONTCARE = 1'b?;
localparam HIGH     = 1'b1;
localparam LOW      = 1'b0;

class STapScoreBoard #(`STAP_DSP_TB_PARAMS_DECL) extends ovm_scoreboard;

    // Packet Received from Monitors
    JtagBfmInMonSbrPkt  JtagInputPacket;
    JtagBfmOutMonSbrPkt JtagOutputPacket;

    STapInMonSbrPkt  STapInputPacket;
    STapOutMonSbrPkt STapOutputPacket;

    DfxSecurePlugin_OutMonTxn #(`STAP_DSP_TB_PARAMS_INST) DspOutputPacket;

    ovm_analysis_export #(JtagBfmInMonSbrPkt)  JtagInputMonExport;
    ovm_analysis_export #(JtagBfmOutMonSbrPkt) JtagOutputMonExport;

    ovm_analysis_export #(STapInMonSbrPkt)  InputMonExport;
    ovm_analysis_export #(STapOutMonSbrPkt) OutputMonExport;

    ovm_analysis_export #(DfxSecurePlugin_OutMonTxn #(`STAP_DSP_TB_PARAMS_INST)) DspOutputMonExport;

    // TLM fifo for input and output monitor
    tlm_analysis_fifo #(STapInMonSbrPkt)  InputMonFifo;
    tlm_analysis_fifo #(STapOutMonSbrPkt) OutputMonFifo;

    tlm_analysis_fifo #(JtagBfmOutMonSbrPkt) JtagOutputMonFifo;
    tlm_analysis_fifo #(JtagBfmInMonSbrPkt)  JtagInputMonFifo;

    tlm_analysis_fifo #(DfxSecurePlugin_OutMonTxn #(`STAP_DSP_TB_PARAMS_INST)) DspOutputMonFifo;

    //-------------------------------------------------------------------------
    // Local Variables
    //-------------------------------------------------------------------------
    // Concatenated Address as Supplied in Parameter
    bit [((NO_OF_RW_REG * SIZE_OF_IR_REG) - 1):0]                 con_rw_reg_addr;
    // Array of Register Address Sliced from Parameter
    bit [(NO_OF_RW_REG - 1):0][(SIZE_OF_IR_REG - 1):0]            rw_reg_addr;
    // Concatenated Number of Register in each TAP as supplied in Parameter
    reg [((16 * NO_OF_SLAVE_TAP) - 1):0]                          con_no_of_dr_reg_stap;
    // Array of Number of Register in each TAP
    int                                                           no_of_dr_reg[(NO_OF_RW_REG - 1):0];
    // Concatenated Width of all Register as supplied in Parameter
    bit [((16 * NO_OF_RW_REG) - 1):0]                             con_rw_reg_width;
    // Array of Register width for each Data Register
    bit [(NO_OF_RW_REG - 1):0][15:0]                              rw_reg_width;
    // Concatenated Reset Value of all Register as supplied in Parameter
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       con_rw_reg_reset_value;
    // Array of Reset Value for each register
    bit [(NO_OF_RW_REG - 1):0][(TOTAL_DATA_REGISTER_WIDTH - 1):0] rw_reg_reset_value;
    // Mask bit to slice the reset values
    bit [(NO_OF_RW_REG - 1):0][(TOTAL_DATA_REGISTER_WIDTH - 1):0] mask_reset_value;
    // Concatenated Flag for pin or loop back for each register
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       con_rw_reg_pin_not_loopback;
    // Expected data out after ST_SHDR state in ST_E1DR
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       expected_tdo_data;
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       actual_tdo_data;
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       actual_tdi_data;
    // Expected address out after ST_SHIR in ST_E1IR
    bit [((NO_OF_RW_REG * SIZE_OF_IR_REG) - 1):0]                 expected_parallel_addr;
    // Concatenated Address of all TAP as configured through tdi
    bit [((NO_OF_SLAVE_TAP * SIZE_OF_IR_REG) - 1):0]              con_tdi_addr;
    // Array of Register address as configured through tdi
    bit [(NO_OF_RW_REG - 1):0][(SIZE_OF_IR_REG - 1):0]            rw_reg_addr_tdi;
    // Array of Register mode each sTAP is in(SLVIDCODE,BYPASS,RW_REG)
    bit [(NO_OF_SLAVE_TAP - 1):0][1:0]                            mode;
    // Array of Mode each TAP is configured to(Exclude,Normal,Decoupled)
    reg [(NO_OF_SLAVE_TAP - 1):0][1:0]                            mltapc_mode = NORMAL;
    // Number of TAP in Normal or Excluded Mode (including CLTAPC)
    integer                                                       active_stap_ir = 0;
    // Number of shift during ST_SHIR
    integer                                                       no_of_ir_shift = 0;
    // Size of the IR register for all TAP togeather
    integer                                                       size_of_ir = 0;
    // Number of Shift during ST_SHDR
    integer                                                       no_of_dr_shift = 0;
    // Number of Shift during ST_SHDR
    integer                                                       no_of_data_shift;
    // State of FSM
    bit [3:0]                                                     state = 4'b0;
    reg [3:0]                                                     previous_state;
    // To flga error while compairing data bits
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       flag_serial_data_error = 0;
    // Concatenated shadow register
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       con_shadow_reg;
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       parallel_data_in;
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       expected_parallel_data_out;
    // MaskRegister to slice concatenated data
    bit [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       mask_bit_vector;
    // To check the input reg against each available reg addr for TAP
    bit [(NO_OF_RW_REG - 1):0]                                    flag_mode_chk;
    // Concatanation of all the Shift Registers for each TAP
    reg [(TOTAL_DATA_REGISTER_WIDTH - 1):0]                       con_data_shift_reg;
    // Array of LSB Position of each Register in the concatenated Shadow Register
    integer                                                       lsb_pos_shadow_reg[(NO_OF_SLAVE_TAP - 1):0][255:0];
    // Data Reg selected for the TAP
    integer                                                       sel_dr_no[(NO_OF_SLAVE_TAP - 1):0];
    integer                                                       dr_no;
    // The data Register selected for each TAP
    integer                                                       sel_dr_reg[(NO_OF_SLAVE_TAP - 1):0];
    integer                                                       dr_reg;
    integer                                                       dr_reg_no;
    // Pointer to Concatenated Shift Register
    integer                                                       tdo_tap = 1;
    // Pointer to concatenated Shadow Register
    integer                                                       updr_tap = 1;
    // Loop Variables
    integer                                                       i, j, k, l, m, n, r, s;
    // Length of Shadow Register
    integer                                                       shadow_reg_len;
    // Local signal for slvidcode input
    bit [31:0]                                                    slvidcode_int;
    // Local Signal for PowerGudReset
    bit                                                           power_gud_int;
    // Remove Bit
    bit                                                           rmv_bit;

    // Secondary Ports
    logic                                                         lcl_ftapsslv_tck;
    logic                                                         lcl_ftapsslv_tms;
    logic                                                         lcl_ftapsslv_trst_b;
    logic                                                         lcl_ftapsslv_tdi;
    logic                                                         lcl_sntapnw_atap_tdo2;
    logic [(STAP_NO_OF_TAPS_IN_TAP_NETWORK - 1):0]                lcl_sntapnw_atap_tdo2_en;
    logic                                                         lcl_atapsslv_tdo;
    logic                                                         lcl_atapsslv_tdoen;
    logic                                                         lcl_sntapnw_ftap_tck2;
    logic                                                         lcl_sntapnw_ftap_tms2;
    logic                                                         lcl_sntapnw_ftap_trst2_b;
    logic                                                         lcl_sntapnw_ftap_tdi2;
    logic                                                         lcl_sntapnw_atap_tdo2_en_or;
    // Local tapc_sel and wtap_sel signals
    logic [((STAP_NO_OF_TAPS_IN_TAP_NETWORK*2)-1):0]              tapc_sel_reg_temp;
    logic [(STAP_NO_OF_WTAPS_IN_WTAP_NETWORK-1):0]                tapc_wtap_sel_reg_temp;

    // Internal Signals
    int                                                           sec_pkt_cnt    = 0;
    bit                                                           sec_compare_en = 1;
    // locked_opcode will get the value from input monitor which is used to bypass the locked opcodes
    bit                                                           locked_opcode;
    // Temoprary signal used to store the Opcode address to be bypassed
    logic [(SIZE_OF_IR_REG - 1):0]                                locked_opcode_addr;
    // Internal signal holding Output of DfxSecurePlugin
    logic                                                         lcl_green;
    logic                                                         lcl_orange;
    logic                                                         lcl_red;
    logic                                                         lcl_visa_all_dis;
    logic                                                         lcl_visa_customer_dis;
    // Concatenated color of all Registers as supplied in Parameter
    bit [((2 * NO_OF_RW_REG) - 1):0]                              con_rw_reg_color;
    // Array of Register color for each Data Register
    bit [(NO_OF_RW_REG - 1):0][1:0]                               rw_reg_color;
    // Array of Register Address Sliced from Parameter based on color
    bit [(NO_OF_RW_REG - 1):0][(SIZE_OF_IR_REG - 1):0]            rw_reg_addr_color;
    // Variable to hold the value of type of reset
    logic [1 : 0]                                                 h15_reset_type = RSTTYPE_PWRGD_00;
    logic [1 : 0]                                                 suppress_capture_update_reg=2'b00;
    // Variable to define which tdr is programmable reset
    logic [(STAP_NUM_OF_ITDRS-1) : 0]                             h16_tdr_reset_en = '0;
    // Variable to define trst_b
    logic                                                         lcl_trst_b;
    // Temporary Variables taken for Resetting the selected tdr's
    integer                                                       total_width_tdr = 0;
    integer                                                       total_tdr_width = 0;
    integer                                                       sum_of_completed_reg_width = 0;
    // Variable to define reset operation
    logic                                                         flag_reset_operation = 1'b0;


    // Packet count
    int no_of_pkts_for_which_addr_compared = 0;
    int no_of_pkts_for_which_data_compared = 0;

    // Constructor
    function new(string name = "STapScoreBoard",
        ovm_component parent = null);
        super.new(name, parent);
        rmv_bit             = 1'b0;
        InputMonExport      = new("InputMonExport", this);
        JtagInputMonExport  = new("JtagInputMonExport", this);
        OutputMonExport     = new("OutputMonExport", this);
        JtagOutputMonExport = new("JtagOutputMonExport", this);
        DspOutputMonExport  = new("DspOutputMonExport", this);
        InputMonFifo        = new("InputMonFifo", this);
        JtagInputMonFifo    = new("JtagInputMonFifo", this);
        JtagOutputMonFifo   = new("JtagOutputMonFifo", this);
        DspOutputMonFifo    = new("DspOutputMonFifo", this);
        OutputMonFifo       = new("OutputMonFifo", this);
    endfunction : new

    // Register component with Factory
    `ovm_component_param_utils(STapScoreBoard#(`STAP_DSP_TB_PARAMS_INST))
    
	function void build;
	    STapInputPacket     = STapInMonSbrPkt::type_id::create("STapInputPacket",this);
        JtagInputPacket     = JtagBfmInMonSbrPkt::type_id::create("JtagInputPacket",this);
        STapOutputPacket    = STapOutMonSbrPkt::type_id::create("STapOutputPacket",this);
        JtagOutputPacket    = JtagBfmOutMonSbrPkt::type_id::create("JtagOutputPacket",this);
        DspOutputPacket     = DfxSecurePlugin_OutMonTxn #(`STAP_DSP_TB_PARAMS_INST)::type_id::create("DspOutputPacket",this);

	endfunction: build
    // assign the virtual interface
    function void connect;
        InputMonExport.connect(InputMonFifo.analysis_export);
        OutputMonExport.connect(OutputMonFifo.analysis_export);

        JtagInputMonExport.connect(JtagInputMonFifo.analysis_export);
        JtagOutputMonExport.connect(JtagOutputMonFifo.analysis_export);

        DspOutputMonExport.connect(DspOutputMonFifo.analysis_export);
    endfunction : connect

    // run phase
    virtual task run();
        fork
            forever begin
              fork
                begin
                  scoreboard_item();
                end
                begin
                  DspOutputMonFifo.get(DspOutputPacket);
                  //-------------------------------------------
                  // Function dfxsignal_capturing() used to capture feature enable and VISA values from
                  // Dfx Monitors to local variables
                  //-------------------------------------------
                  dfxsignal_capturing();
                end
              join_any 
            end

            begin
                //***************************************************
                //Mask Bit
                //***************************************************
                mask_bit_vector = 0;
                for(i = 0; i < SIZE_OF_IR_REG_STAP; i++)
                begin
                    mask_bit_vector[i] = 1'b1;
                end

                //************************************************
                // Slicing to GET:
                // Size of Each Register
                // Color of Each Register
                // Addr of Each Register
                // Reset value of Each Register
                // Loopback info for Each Register
                //************************************************
                con_rw_reg_addr             = RW_REG_ADDR;
                con_rw_reg_color            = RW_REG_COLOR;
                con_rw_reg_width            = RW_REG_WIDTH;
                con_rw_reg_reset_value      = TB_DATA_REGISTER_RESET_VALUES;
                con_rw_reg_pin_not_loopback = TB_LOAD_PIN_OR_NOT_LOOPBACK;

                // Reg Width and Addr
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    rw_reg_addr[i]  = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_STAP)) & mask_bit_vector);
                    rw_reg_width[i] = (((con_rw_reg_width) >> (i*16)) & 'hFFFF);
                    rw_reg_color[i] = (((con_rw_reg_color) >> (i*2)) & 'h3);
                end

                for(i=0;i<NO_OF_RW_REG;i++) begin
                    for(j = 0; j < rw_reg_width[i]; j++) begin
                        mask_reset_value[i][j] = 1'b1;
                    end
                end

                k = 0;
                for(i = 0; i < NO_OF_RW_REG; i++) begin
                    rw_reg_reset_value[i] = (((con_rw_reg_reset_value) >> (k)) & mask_reset_value[i]);
                    k = k + rw_reg_width[i];
                end

                //--------------------------------------------------
                // Load the IR Shadow register with 0C value at Reset
                //--------------------------------------------------
                k = 0;
                size_of_ir = 0;
                for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                    for(j = 0; j < SIZE_OF_IR_REG_STAP; j++) begin
                        if(j == 3 || j == 2 ) // if bits 2 & 3 are 1's and rest are 0's. Then address will be 0C
                            con_tdi_addr[size_of_ir] = 1'b1;
                        else
                            con_tdi_addr[size_of_ir] = 1'b0;
                        size_of_ir++;
                    end //for size of ir reg
                end
                con_data_shift_reg = 0;

                //-------------------------------------------
                // Reset at Power Good for Sticky Register
                //-------------------------------------------
                if(power_gud_int == 1'b0)begin
                    k = 0;
                    rmv_bit = 1'b0;
                    tapc_sel_reg_temp      = 0;
                    tapc_wtap_sel_reg_temp = 0;
                    for(i=0;i<NO_OF_RW_REG;i++) begin
                        for(j = 0; j < rw_reg_width[i]; j++) begin
                            con_shadow_reg[k] = rw_reg_reset_value[i][j];
                            k++;
                        end
                    end
                end
            end
        join
    endtask : run


    // Post Run Reporting
    function void report();
        super.report ();
        if (no_of_pkts_for_which_data_compared == 0 || no_of_pkts_for_which_addr_compared == 0)
            `ovm_error(get_type_name(), $psprintf("SlaveTap Scoreboard did not match any packets. SlaveTap Scoreboard matched %0d IR Opcodes & contents of %0d TDR's.\n", no_of_pkts_for_which_addr_compared, no_of_pkts_for_which_data_compared))
        else
            `ovm_info(get_type_name(), $psprintf("SlaveTap Scoreboard matched %0d IR Opcodes & contents of %0d TDR's.\n", no_of_pkts_for_which_addr_compared, no_of_pkts_for_which_data_compared), OVM_LOW)
    endfunction : report

    task scoreboard_item();
        string msg;
        forever
        begin
            InputMonFifo.get(STapInputPacket);
            JtagInputMonFifo.get(JtagInputPacket);

            OutputMonFifo.try_get(STapOutputPacket);

            //**************************************************************
            // Copy the Packet Information from Monitor to Local variable
            //**************************************************************
            if(rmv_bit == 0) begin
                state = JtagInputPacket.FsmState;
            end else begin
                state = ST_TLRS;
            end
            slvidcode_int = STapInputPacket.Idcode;
            power_gud_int = JtagInputPacket.Power_Gud_Reset;
            lcl_trst_b    = STapInputPacket.trst_b;

            //-------------------------------------------
            // Function secondary_passthru() used to capture secondary port values from
            // Monitors to local variables
            //-------------------------------------------
            secondary_passthru();

            //-------------------------------------------
            //Call compare_secondary_port function to check the values
            //-------------------------------------------
            if (sec_compare_en == HIGH) begin
                lcl_sntapnw_atap_tdo2_en_or = |(lcl_sntapnw_atap_tdo2_en);
                if (TB_DISABLE_MISC_DRIVE==LOW)
                    compare_secondary_ports();
            end

            //***************************************************
            // Slice the Mode in which each sTAP is.
            // CLTAPC is always in NORMAL MODE
            // Count number of TAP in Normal Mode
            // Count number of TAP in Excluded Mode
            // For this sTAP ENV it is fixed to 01
            //***************************************************
            if(MULTIPLE_TAP == 1) begin
                mltapc_mode[0] = NORMAL; //sTAP
                mltapc_mode[BIT_ONE_FOR_WTAP_ZERO_FOR_MTAP_STAP] = NORMAL; //WTAP
                active_stap_ir = 2;      //sTAP + WTAP
            end else begin //Only sTAP
                mltapc_mode[0] = NORMAL; //sTAP
                active_stap_ir = 1;      //Only sTAP
            end

            //***************************************************
            // Reset the Shift and Shadow Registers at ST_TLRS
            // Also slice the Parameters to know the charactersitc
            // of each of the register.
            //***************************************************
            if(state == ST_TLRS)
            begin
               //***************************************************
               //Mask Bit
               //***************************************************
               mask_bit_vector = 0;
               for(i  =0; i < SIZE_OF_IR_REG_STAP; i++)
               begin
                   mask_bit_vector[i] = 1'b1;
               end

               //************************************************
               // Slicing to GET:
               // Size of Each Register
               // Color of Each Register
               // Addr of Each Register
               // Reset value of Each Register
               // Loopback info for Each Register
               //************************************************
               con_rw_reg_addr             = RW_REG_ADDR;
               con_rw_reg_color            = RW_REG_COLOR;
               con_rw_reg_width            = RW_REG_WIDTH;
               con_rw_reg_reset_value      = TB_DATA_REGISTER_RESET_VALUES;
               con_rw_reg_pin_not_loopback = TB_LOAD_PIN_OR_NOT_LOOPBACK;

               // Reg Width and Addr
               for(i = 0; i < NO_OF_RW_REG; i++) begin
                   rw_reg_addr[i]  = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_STAP)) & mask_bit_vector);
                   rw_reg_width[i] = (((con_rw_reg_width) >> (i*16)) & 'hFFFF);
                   rw_reg_color[i] = (((con_rw_reg_color) >> (i*2)) & 'h3);
               end

               for(i=0;i<NO_OF_RW_REG;i++) begin
                   for(j = 0; j < rw_reg_width[i]; j++) begin
                       mask_reset_value[i][j] = 1'b1;
                   end
               end

               k = 0;
               for(i = 0; i < NO_OF_RW_REG; i++) begin
                   rw_reg_reset_value[i] = (((con_rw_reg_reset_value) >> (k)) & mask_reset_value[i]);
                   k = k + rw_reg_width[i];
               end

               //--------------------------------------------------
               // Load the IR Shadow register with 0C value at Reset
               //--------------------------------------------------
               k = 0;
               size_of_ir = 0;
               for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                   for(j = 0; j < SIZE_OF_IR_REG_STAP; j++) begin
                       if(j == 3 || j == 2 ) // if bits 2 & 3 are 1's and rest are 0's. Then address will be 0C
                           con_tdi_addr[size_of_ir] = 1'b1;
                       else
                           con_tdi_addr[size_of_ir] = 1'b0;
                       size_of_ir++;
                   end //for size of ir reg
               end
               con_data_shift_reg = 0;
            end

            //-------------------------------------------
            // Reset at Power Good for Sticky Register
            //-------------------------------------------
            if(power_gud_int == 1'b0)begin
                k = 0;
                rmv_bit                = 1'b0;
                tapc_sel_reg_temp      = 0;
                tapc_wtap_sel_reg_temp = 0;
                for(i=0;i<NO_OF_RW_REG;i++) begin
                    for(j = 0; j < rw_reg_width[i]; j++) begin
                        con_shadow_reg[k] = rw_reg_reset_value[i][j];
                        k++;
                    end
                end
            end

            //*****************************************************************
            // Load 01 to the IR Shift Register
            // Instruction Register would only be for Normal and Exclude Mode
            //*****************************************************************
            if(state == ST_CAIR) begin
                no_of_ir_shift         = 0;
                expected_parallel_addr = 0;
                size_of_ir             = 0;
                for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                    if(mltapc_mode[i] == NORMAL || mltapc_mode[i] == EXCLUDED) begin
                        for(j = 0; j < SIZE_OF_IR_REG_STAP; j++) begin
                            if(j == 0) // if bit 0 is 1 and rest are 0's. Then address will be 01
                                con_tdi_addr[size_of_ir] = 1'b1;
                            else
                                con_tdi_addr[size_of_ir] = 1'b0;
                            size_of_ir++;
                        end //for size of ir reg
                    end
                end //for no_rw_reg
            end //ST_CAIR

            //*****************************************************************
            // To account for Number of Shift for Instruction Register
            //*****************************************************************
            if(state == ST_SHIR) begin
                size_of_ir = 0;
                for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                    if(mltapc_mode[i] == NORMAL || mltapc_mode[i] == EXCLUDED) begin
                        for(j = 0; j < SIZE_OF_IR_REG_STAP; j++) begin
                            if(no_of_ir_shift>= size_of_ir)
                                expected_parallel_addr[size_of_ir] = con_tdi_addr[size_of_ir];
                            size_of_ir++;
                        end //for size of ir reg
                    end
                end //for no_rw_reg
                no_of_ir_shift ++;
            end

            //*****************************************************************
            // Getting the resultant IR after Shift IR state
            //*****************************************************************
            if(state == ST_E1IR) begin
                for(i = 0;i < no_of_ir_shift; i++) begin
                    for(j = 0; j < size_of_ir; j++) begin
                        if(j == size_of_ir-1) begin
                            con_tdi_addr[j] = JtagInputPacket.ShiftRegisterAddress[i]; // Get the IR address passed from the Sequences
                        end else begin
                            con_tdi_addr[j] = con_tdi_addr[j+1];
                        end
                    end
                end
                // To bypass the opcodes based on locked_opcode
                if (locked_opcode == 1'b1) begin
                    for(j = 0; j < size_of_ir; j++) begin
                       locked_opcode_addr[j] = con_tdi_addr[j];
                    end
                end
                no_of_ir_shift = 0;
            end

            //***************************************************
            // Address Check at ST_E1IR / ST_UPIR
            //***************************************************
            if(state == ST_E1IR ) begin
                JtagOutputMonFifo.get(JtagOutputPacket);
                if(JtagOutputPacket.ShiftRegisterAddress === expected_parallel_addr)
                      `ovm_info("**Address Matches !!!",
                                    $psprintf("\nActual   Addr: %0h\nExpected Addr: %0h ",
                                    JtagOutputPacket.ShiftRegisterAddress,
                                    expected_parallel_addr),
                                    OVM_LOW)
                else
                    `ovm_error("**Address Mis-Matches",
                                     $psprintf("\nActual   Addr: %0h\nExpected Addr: %0h",
                                     JtagOutputPacket.ShiftRegisterAddress,
                                     expected_parallel_addr))
                no_of_pkts_for_which_addr_compared++;
            end

            //***************************************************
            // Load the Parallel data to Cancatenated DR in ST_ST_CADR
            //***************************************************
            if(state == ST_CADR) begin
                 //***************************************************
                 // Mask Bit
                 //***************************************************
                 mask_bit_vector = 0;
                 for(i = 0; i < SIZE_OF_IR_REG_STAP; i++) begin
                     mask_bit_vector[i] = 1'b1;
                 end

                 //************************************************
                 // Slicing to GET:
                 // Size of Each Register
                 // Color of Each Register
                 // Addr of Each Register
                 //************************************************
                 con_rw_reg_addr        = RW_REG_ADDR;
                 con_rw_reg_color       = RW_REG_COLOR;
                 con_rw_reg_width       = RW_REG_WIDTH;
                 con_rw_reg_reset_value = TB_DATA_REGISTER_RESET_VALUES;
                 for(i = 0; i < NO_OF_RW_REG; i++) begin
                     rw_reg_addr[i]  = (((con_rw_reg_addr) >> (i*SIZE_OF_IR_REG_STAP)) & mask_bit_vector);
                     rw_reg_width[i] = (((con_rw_reg_width) >> (i*16)) & 'hFFFF);
                     rw_reg_color[i] = (((con_rw_reg_color) >> (i*2)) & 'h3);
                 end
                 for(i = 0; i < NO_OF_RW_REG; i++) begin
                     for(j = 0; j < rw_reg_width[i]; j++) begin
                         mask_reset_value[i][j] = 1'b1;
                     end
                 end

                 //************************************************
                 // Slicing to GET:
                 // Number of Registers in each sTAP
                 // SLVIDCODE of Each sTAP
                 // INSTR set for each sTAP
                 //************************************************
                 con_no_of_dr_reg_stap = CON_NO_OF_DR_REG_STAP;
                 k = 0;
                 for(i=0; i < NO_OF_SLAVE_TAP; i++) begin // NO_OF_SLAVE_TAP = 1
                     no_of_dr_reg[i]    = (((con_no_of_dr_reg_stap) >> (i*16)) & 16'hFFFF);
                     rw_reg_addr_tdi[i] = (((con_tdi_addr) >> (i*SIZE_OF_IR_REG_STAP)) & mask_bit_vector);
                 end

                 //***************************************************
                 // Update the Shadow Register LSB Position Array
                 // This variable tells the lsb position of each register
                 // in the Shadow register.
                 //***************************************************
                 dr_reg_no      = 0;
                 shadow_reg_len = 0;
                 for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin // NO_OF_SLAVE_TAP = 1
                     for(j = 0; j < no_of_dr_reg[i]; j++) begin
                         lsb_pos_shadow_reg[i][j] = shadow_reg_len;
                         shadow_reg_len           = shadow_reg_len + rw_reg_width[dr_reg_no];
                         dr_reg_no ++;
                     end
                 end

                 //************************************************************************************
                 // Access to each opcode is based on security levels (which inturn depends on color).
                 // When DfxSecure Feature for red is high, User can able to access all opcodes.
                 // When DfxSecure Feature for orange is high, User can able to access Orange and
                 // Green colored opcodes.
                 // When DfxSecure Feature for green is high, User can able to access only green opcodes.
                 // selected_bypass() function is used to bypass selected opcodes based on
                 // the array rw_reg_addr_color[]
                 //************************************************************************************
                 k = 0;
                 l = 0;
                 if (lcl_red == 1'b1) begin
                    for(i = 0; i < NO_OF_RW_REG; i++) begin
                        if ((rw_reg_color[i] == TB_STAP_SECURE_RED) || (rw_reg_color[i] == TB_STAP_SECURE_ORANGE) || (rw_reg_color[i] == TB_STAP_SECURE_GREEN)) begin
                           rw_reg_addr_color[i]  = '0;
                        end
                        else begin
                           rw_reg_addr_color[i]  = rw_reg_addr[i];
                        end
                    end
                 end else if (lcl_orange == 1'b1) begin
                    for(i = 0; i < NO_OF_RW_REG; i++) begin
                        if ((rw_reg_color[i] == TB_STAP_SECURE_ORANGE) || (rw_reg_color[i] == TB_STAP_SECURE_GREEN)) begin
                           rw_reg_addr_color[i]  = '0;
                        end
                        else begin
                           rw_reg_addr_color[i]  = rw_reg_addr[i];
                        end
                    end
                 end else if (lcl_green == 1'b1) begin
                    for(i = 0; i < NO_OF_RW_REG; i++) begin
                        if (rw_reg_color[i] == TB_STAP_SECURE_GREEN) begin
                           rw_reg_addr_color[i]  = '0;
                        end
                        else begin
                           rw_reg_addr_color[i]  = rw_reg_addr[i];
                        end
                    end
                 end else begin
                    for(i = 0; i < NO_OF_RW_REG; i++) begin
                       rw_reg_addr_color[i]  = rw_reg_addr[i];
                    end
                 end

                 //******************************************************************************
                 // Bypassing the Opcodes based on security levels
                 //******************************************************************************
                 selected_bypass();

                 //******************************************************************************
                 // To insert 0 for all the RO Registers as the are LoopBacked at ST_CADR and donot
                 // have a parallel in.
                 //******************************************************************************
                 i = 0;
                 k = 0;
                 for(i = 0; i <= (TOTAL_DATA_REGISTER_WIDTH - 1); i++) begin
                     if(i<RO_REGISTER_WIDTH) begin
                         parallel_data_in[i] = 1'b0;
                     end else begin
                         parallel_data_in[i] = STapInputPacket.Parallel_Data_in[k];
                         k++;
                     end
                 end

                 //******************************************************************************
                 // To  know the width of shift data register so as to insert the tdi at MSB
                 // Load all the RO register with their default value
                 //******************************************************************************
                 tdo_tap            = 0;
                 l                  = NO_OF_RW_REG-1;
                 m                  = 0;
                 if(suppress_capture_update_reg[1] === 1'b0) begin
                    con_data_shift_reg = 0;
                 end
                 for(i = (NO_OF_SLAVE_TAP - 1); i >= 0; i--) begin
                     if(mltapc_mode[i] == NORMAL) begin // if TAP is in Normal mode
                         if(mode[i] == BYPASS) begin
                             if(suppress_capture_update_reg[1] === 1'b0) begin
                                con_data_shift_reg[tdo_tap] = 1'b0;
                             end
                             tdo_tap++  ;
                             l = l - no_of_dr_reg[i];
                         end else if(mode[i] == SLVIDCODE) begin
                             for(j = 0; j < IDCODE_WIDTH; j++) begin
                                 //if(suppress_capture_update_reg[1] === 1'b0) begin
                                    if(j == 0) begin
                                        con_data_shift_reg[tdo_tap] = 1'b1; //The First Bit of SLVIDCODE is Tied to Logic 1
                                    end else begin
                                        con_data_shift_reg[tdo_tap] = slvidcode_int[j];
                                    end
                                 //end
                                 tdo_tap++;
                             end
                         end else if(mode[i] == RW_REG) begin
                             for(j = 0; j < no_of_dr_reg[i]; j++) begin
                                 if(rw_reg_addr[l] == rw_reg_addr_tdi[m]) begin
                                     for(k = lsb_pos_shadow_reg[i][no_of_dr_reg[i] - j - 1];
                                         k < (rw_reg_width[l] + lsb_pos_shadow_reg[i][no_of_dr_reg[i] - j - 1]);
                                         k++) begin
                                               if(con_rw_reg_pin_not_loopback[k] == 1'b1) begin
                                                   if(suppress_capture_update_reg[1] === 1'b0) begin
                                                      con_data_shift_reg[tdo_tap] = parallel_data_in[k];
                                                   end
                                                   else begin
                                                      con_data_shift_reg[tdo_tap] = con_shadow_reg[k];
                                                   end
                                               end else begin
                                                   //if((suppress_capture_update_reg[1] === 1'b0) && (suppress_capture_update_reg[0] === 1'b0)) begin
                                                      con_data_shift_reg[tdo_tap] = con_shadow_reg[k];
                                                   //end
                                               end
                                         tdo_tap++;
                                     end
                                     sel_dr_reg[i] = no_of_dr_reg[i] - j - 1;
                                     sel_dr_no[i]  = l;
                                 end
                                 l--;
                             end
                         end
                         m++;
                     end else if(mltapc_mode[i] == EXCLUDED) begin // if TAP is in Excluded mode
                         l = l - no_of_dr_reg[i];
                         m++;
                     end else
                         l = l - no_of_dr_reg[i];
                 end
                     no_of_dr_shift    = 0;
                     no_of_data_shift  = 0;
                     expected_tdo_data = 0;
             end //if ST_CADR

             //*****************************************************************
             // Update and shift the Shift Register
             //*****************************************************************
             if(state == ST_SHDR) begin
                 expected_tdo_data[no_of_data_shift] = con_data_shift_reg[0];
                 for(j = 0; j < tdo_tap; j++) begin
                     if(j == tdo_tap-1) begin
                         con_data_shift_reg[j] = JtagInputPacket.ShiftRegisterData[no_of_dr_shift];
                     end else begin
                         con_data_shift_reg[j] = con_data_shift_reg[j+1];
                     end
                 end
                 no_of_data_shift ++;
                 no_of_dr_shift ++;
             end //if ST_SHDR

             //*****************************************************************
             // Reset the count of data shift before entering to ST_SHDR
             //*****************************************************************
             if(state == ST_CADR || state == ST_E2DR) begin
                 no_of_data_shift  = 0;
                 expected_tdo_data = 0;
                 no_of_dr_shift    = 0;
             end

             //*****************************************************************
             // Compare the Serial shift data with actual tdo shift reg at ST_E1DR
             //*****************************************************************
             if(state == ST_E1DR) begin
                 JtagOutputMonFifo.get(JtagOutputPacket);
                 flag_serial_data_error = 0;
                 actual_tdo_data        = 0;
                 actual_tdi_data        = 0;
                 for(i = 0; i < no_of_data_shift; i++) begin
                     if(expected_tdo_data[i] === JtagOutputPacket.ShiftRegisterData[i]) begin
                         flag_serial_data_error[i] = 1'b0;
                         actual_tdo_data[i]        = JtagOutputPacket.ShiftRegisterData[i];
                         actual_tdi_data[i]        = JtagInputPacket.ShiftRegisterData[i];
                     end else begin
                         flag_serial_data_error[i] = 1'b1;
                         actual_tdo_data[i]        = JtagOutputPacket.ShiftRegisterData[i];
                         actual_tdi_data[i]        = JtagInputPacket.ShiftRegisterData[i];
                     end
                 end

                 if(flag_serial_data_error == 0)
                     `ovm_info("**Data Matches !!!",
                                     $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                     actual_tdo_data,
                                     expected_tdo_data),OVM_LOW)
                 else
                     `ovm_error("**Data Mis Match ",
                                      $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                      actual_tdo_data,
                                      expected_tdo_data))
             end

             //*****************************************************************
             // Load the local variable with the data inside h22 opcode
             //*****************************************************************
             if((JtagInputPacket.ShiftRegisterAddress == 'h22) && (state == ST_UPDR)&&(STAP_SUPPRESS_UPDATE_CAPTURE==1)) begin
                suppress_capture_update_reg = JtagInputPacket.ShiftRegisterData;
             end
             //*****************************************************************
             // Load the local variable with the data inside h15 opcode
             //*****************************************************************
             if((JtagInputPacket.ShiftRegisterAddress == 'h15) && (state == ST_UPDR)) begin
                h15_reset_type = JtagInputPacket.ShiftRegisterData;
             end

             //*****************************************************************
             // Load the local variable with the data inside h16 opcode
             //*****************************************************************
             if(flag_reset_operation == 1'b1) begin // Enters if the rw_reg_addr contains opcode 16
                if((JtagInputPacket.ShiftRegisterAddress == 'h16) && (state == ST_UPDR)) begin
                   h16_tdr_reset_en = JtagInputPacket.ShiftRegisterData;
                end
             end

             if(h16_tdr_reset_en != '0) begin
                fork
                   update_reset_values_trst_b();
                   update_reset_values_swclr();
                   update_con_shadow_reg();
                join_any
             end
             else begin
               update_con_shadow_reg();
             end
        end
    endtask : scoreboard_item

    //--------------------------------------------------------------------
    // Function to convert the FSM States to String
    //--------------------------------------------------------------------
    function string state_str;
	  `ifdef USE_CONVERGED_JTAGBFM
        input [3:0]  state;
	  `else
        input [STATE_BITS :0]  state;
      `endif
        begin
            string str;
            case (state)
                ST_TLRS: begin str = "ST_TLRS"; end
                ST_RUTI: begin str = "ST_RUTI"; end
                ST_SDRS: begin str = "ST_SDRS"; end
                ST_CADR: begin str = "ST_CADR"; end
                ST_SHDR: begin str = "ST_SHDR"; end
                ST_E1DR: begin str = "ST_E1DR"; end
                ST_PADR: begin str = "ST_PADR"; end
                ST_E2DR: begin str = "ST_E2DR"; end
                ST_UPDR: begin str = "ST_UPDR"; end
                ST_SIRS: begin str = "ST_SIRS"; end
                ST_CAIR: begin str = "ST_CAIR"; end
                ST_SHIR: begin str = "ST_SHIR"; end
                ST_E1IR: begin str = "ST_E1IR"; end
                ST_PAIR: begin str = "ST_PAIR"; end
                ST_E2IR: begin str = "ST_E2IR"; end
                ST_UPIR: begin str = "ST_UPIR"; end
            endcase // case(toState)
            return str;
        end
    endfunction

    //----------------------------------------------------
    //Function compare_secondary_ports() is used to compare driven secondary port input with actual returened output
    //----------------------------------------------------
    function compare_secondary_ports();
        bit    flag;
        string msg;
        begin
            $write(msg,"Given lcl_ftapsslv_tck = %b, Returned sntapnw_ftap_tck2 = %b\n", lcl_ftapsslv_tck, lcl_sntapnw_ftap_tck2);
            `ovm_info(get_type_name(), msg, OVM_LOW)
            $write(msg,"Given lcl_ftapsslv_tms = %b, Returned sntapnw_ftap_tms2 = %b\n", lcl_ftapsslv_tms, lcl_sntapnw_ftap_tms2);
            `ovm_info(get_type_name(), msg, OVM_LOW)
            $write(msg,"Given lcl_ftapsslv_trst_b = %b, Returned sntapnw_ftap_trst2_b = %b\n",lcl_ftapsslv_trst_b, lcl_sntapnw_ftap_trst2_b);
            `ovm_info(get_type_name(), msg, OVM_LOW)
            $write(msg,"Given lcl_ftapsslv_tdi = %b, Returned sntapnw_ftap_tdi2 = %b\n",lcl_ftapsslv_tdi, lcl_sntapnw_ftap_tdi2);
            `ovm_info(get_type_name(), msg, OVM_LOW)
            $write(msg,"Given lcl_sntapnw_atap_tdo2 = %b, Returned atapsslv_tdo = %b\n",lcl_sntapnw_atap_tdo2, lcl_atapsslv_tdo);
            `ovm_info(get_type_name(), msg, OVM_LOW)
            $write(msg,"Given or'ed value of lcl_sntapnw_atap_tdo2_en = %b, Returned atapsslv_tdoen = %b\n",lcl_sntapnw_atap_tdo2_en_or, lcl_atapsslv_tdoen);
            `ovm_info(get_type_name(), msg, OVM_LOW)

            flag = (
                     (lcl_ftapsslv_tck            == lcl_sntapnw_ftap_tck2) &
                     (lcl_ftapsslv_tms            == lcl_sntapnw_ftap_tms2) &
                     (lcl_ftapsslv_trst_b         == lcl_sntapnw_ftap_trst2_b) &
                     (lcl_ftapsslv_tdi            == lcl_sntapnw_ftap_tdi2) &
                     (lcl_sntapnw_atap_tdo2       == lcl_atapsslv_tdo) &
                     (lcl_sntapnw_atap_tdo2_en_or == lcl_atapsslv_tdoen)
                   );
            if (flag == HIGH) begin
                `ovm_info(get_type_name(), "Secondary Port data Matches !!!", OVM_LOW)
            end else begin
                `ovm_error(get_type_name(), "Secondary Port data MisMatches !!!")
            end

            if (sec_pkt_cnt == 10) begin
                sec_compare_en = 0;
            end else begin
                sec_pkt_cnt++;
                sec_compare_en = 1;
            end
        end
    endfunction

    //-----------------------------------------------------------------------------------------
    //Function selected_bypass() is used to BYPASS Selected opcodes (Partially blocked)
    //-----------------------------------------------------------------------------------------
    function selected_bypass();
        begin
           for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
               flag_mode_chk = 0;
               // To Check for each sTAP  if its BYPASS, SLVIDCODE or DR reg is selected
               // mode is 10 for idcode; 11 for Data Reg and 01 for Bypass
               if(mltapc_mode[i] == NORMAL) begin // if TAP is in Normal mode
                   if( rw_reg_addr_tdi[active_stap_ir-l-1] == 'h0C) begin
                       if ((lcl_red == 1'b0) && (lcl_orange == 1'b0) && (lcl_green == 1'b0)) begin
                          mode[i] = BYPASS;
                       end else begin
                          mode[i] = SLVIDCODE;
                       end
                       k = k + no_of_dr_reg[i];
                   end else begin
                       for(j = 0; j < no_of_dr_reg[i]; j++) begin
                           if( rw_reg_addr[k] == rw_reg_addr_color[k]) begin
                               flag_mode_chk[j] = 1'b0;
                           end else if( rw_reg_addr[k] == rw_reg_addr_tdi[active_stap_ir-l-1]) begin
                               flag_mode_chk[j] = 1'b1; // If the address from Sequences matches the j'th address listed in RW_REG_ADDR parameter of tb_param, set flag_mode_chk[j] to 1
                           end else begin
                               flag_mode_chk[j] = 1'b0; // If the address from Sequences doesn't match the j'th address listed in RW_REG_ADDR parameter of tb_param, set flag_mode_chk[j] to 0
                           end
                           if( rw_reg_addr[k] == 'h16) begin
                               flag_reset_operation = 1'b1;
                               $display("flag reset operation is %0d",flag_reset_operation);
                           end
                           k++;
                       end
                       if(flag_mode_chk == 0) // if none of the address match then Bypass
                           mode[i] = BYPASS;
                       else // if an address matches then Data Reg
                           mode[i] = RW_REG;
                       flag_mode_chk = 0;
                   end
                   l++;
               end else begin
                   k       = k + no_of_dr_reg[i];
                   mode[i] = NO_REG;
                   if(mltapc_mode[i] == EXCLUDED) // if TAP is in Excluded mode
                       l++;
               end
           end
        end
    endfunction

    //-----------------------------------------------------------------------------------------
    //Function update_con_shadow_reg() is used to get values during ST_UPDR
    //-----------------------------------------------------------------------------------------
    function update_con_shadow_reg();
        begin
             //********************************************************************
             // Update the Concatenated Shadow register with the Shift Reg value
             //********************************************************************
             if(state == ST_UPDR) begin
                 updr_tap = tdo_tap;
                 for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                     if(mode[i] == RW_REG) begin
                         dr_no  = sel_dr_no[i];
                         dr_reg = sel_dr_reg[i];
                         k      = lsb_pos_shadow_reg[i][dr_reg];
                         l      = updr_tap - rw_reg_width[dr_no];
                         for(j = 0; j < rw_reg_width[dr_no]; j++) begin
                             if((suppress_capture_update_reg[0] === 1'b0) || (JtagInputPacket.ShiftRegisterAddress == 'h22)) begin
                             //if(suppress_capture_update_reg[0] === 1'b0) begin
                                con_shadow_reg[k+j] = con_data_shift_reg[l+j];
                             end
                             //else begin
                             //   if(JtagInputPacket.ShiftRegisterAddress === 'h22) begin
                             //      con_shadow_reg[k+j] = con_data_shift_reg[l+j];
                             //   end
                             //end
                             if(rw_reg_addr[dr_no] == 'h14 && i == BIT_ONE_FOR_WTAP_ZERO_FOR_MTAP_STAP) begin
                                 rmv_bit = con_data_shift_reg[l];
                             end
                             updr_tap--;
                         end
                     end else if(mode[i] == BYPASS) begin
                         updr_tap--;
                     end else if(mode[i] == SLVIDCODE) begin
                         updr_tap = updr_tap - 32;
                     end
                     k = 0;
                     for(m = 0; m <= TOTAL_DATA_REGISTER_WIDTH; m++) begin
                         if(m >= NO_PARALLEL_OUT_BIT_WIDTH)  begin
                             expected_parallel_data_out[k] = con_shadow_reg[m];
                             k++;
                         end
                     end
                     if (MULTIPLE_TAP == 0) begin
                         if(STapOutputPacket.ParallelDataOut === (expected_parallel_data_out ))
                             `ovm_info("**Parallel Data Matches !!!",
                                             $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                             STapOutputPacket.ParallelDataOut,
                                             (expected_parallel_data_out)),OVM_LOW)
                         else
                             `ovm_error("**Parallel Data  Mis Matches !!!",
                                              $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                              STapOutputPacket.ParallelDataOut,
                                              (expected_parallel_data_out )))
                     end
                 end
                 no_of_pkts_for_which_data_compared++;
             end
        end
    endfunction

    //-----------------------------------------------------------------------------------------
    // Loading the reset values to con_shadow_reg when reset type is TRST_B
    //-----------------------------------------------------------------------------------------
    function update_reset_values_trst_b();
        begin
             // If condition to check whether trst_b has occured
             if ((lcl_trst_b == 1'b0) || (state == ST_TLRS)) begin
                 for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                     $display("entered for loop with trst_b is %0b", lcl_trst_b);
                     // If condition to determine whether the Data in Opcode 15 is trst_b
                     if ((h15_reset_type == RSTTYPE_TRSTB_01) || (h15_reset_type == RSTTYPE_TRSTB_11)) begin
                        total_tdr_width = 0;
                        sum_of_completed_reg_width = 0;

                        // For loop for the calculation of TDR width
                        n = (NO_OF_RW_REG - STAP_NUM_OF_ITDRS);
                        for (m =0 ; m < STAP_NUM_OF_ITDRS; m++) begin
                           total_tdr_width = total_tdr_width + rw_reg_width[n+m];
                        end

                        // For loop for assigning reset values to selected TDRs
                        for(k = 0; k < STAP_NUM_OF_ITDRS; k++) begin
                           i = (NO_OF_RW_REG - STAP_NUM_OF_ITDRS + k);
                           total_width_tdr = total_tdr_width - sum_of_completed_reg_width;

                           // Check the TDR register to be programmed with reset and load the reset values
                           if (h16_tdr_reset_en[k] == 1'b1) begin
                               if ((lcl_trst_b == 1'b0) || (state == ST_TLRS)) begin
                                  for (r = (TOTAL_DATA_REGISTER_WIDTH - 34 - total_width_tdr);
                                       r <(TOTAL_DATA_REGISTER_WIDTH - 34 - total_width_tdr + rw_reg_width[i]);
                                       r++) begin
                                     con_shadow_reg[r] = con_rw_reg_reset_value[r];
                                  end
                               end
                           end
                           // Local variable sum_of_completed_reg_width for the calculation of unequal TDR widths
                           sum_of_completed_reg_width = sum_of_completed_reg_width + rw_reg_width[i];
                           total_width_tdr = 0;
                        end
                     end
                     k = 0;
                     for(m = 0; m <= TOTAL_DATA_REGISTER_WIDTH; m++) begin
                         if(m >= NO_PARALLEL_OUT_BIT_WIDTH)  begin
                             expected_parallel_data_out[k] = con_shadow_reg[m];
                             k++;
                         end
                     end
                     if (MULTIPLE_TAP == 0) begin
                         if(STapOutputPacket.ParallelDataOut === (expected_parallel_data_out ))
                             `ovm_info("**Parallel Data Matches during TRST_B !!!",
                                             $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                             STapOutputPacket.ParallelDataOut,
                                             (expected_parallel_data_out)),OVM_LOW)
                         else
                             `ovm_error("**Parallel Data  Mis Matches during TRST_B !!!",
                                              $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                              STapOutputPacket.ParallelDataOut,
                                              (expected_parallel_data_out )))
                     end
                 end
                 no_of_pkts_for_which_data_compared++;
             end
          end
    endfunction

    //-----------------------------------------------------------------------------------------
    // Loading the reset values to con_shadow_reg when reset type is SWCLR
    //-----------------------------------------------------------------------------------------
    function update_reset_values_swclr();
        begin
             // If condition to check whether swclr has occured
             if ((h15_reset_type == RSTTYPE_SWCLR_10) && (h16_tdr_reset_en != '0)) begin
                 $display ("entered into swclr value is %0h",h15_reset_type);
                 for(i = 0; i < NO_OF_SLAVE_TAP; i++) begin
                    total_tdr_width = 0;
                    sum_of_completed_reg_width = 0;
                    n = (NO_OF_RW_REG - STAP_NUM_OF_ITDRS);
                    // For loop for the calculation of TDR width
                    for (m =0 ; m < STAP_NUM_OF_ITDRS; m++) begin
                       total_tdr_width = total_tdr_width + rw_reg_width[n+m];
                    end
                    // For loop for assigning reset values to selected TDRs
                    for(k = 0; k < STAP_NUM_OF_ITDRS; k++) begin
                       i = (NO_OF_RW_REG - STAP_NUM_OF_ITDRS + k);
                       total_width_tdr = total_tdr_width - sum_of_completed_reg_width;

                       if (h16_tdr_reset_en[k] == 1'b1) begin
                          for (r = (TOTAL_DATA_REGISTER_WIDTH - 34 - total_width_tdr);
                               r <(TOTAL_DATA_REGISTER_WIDTH - 34 - total_width_tdr + rw_reg_width[i]);
                               r++) begin
                             con_shadow_reg[r] = con_rw_reg_reset_value[r];
                          end
                       end
                      sum_of_completed_reg_width = sum_of_completed_reg_width +  rw_reg_width[i];
                      total_width_tdr = 0;
                    end
                    k = 0;
                    for(m = 0; m <= TOTAL_DATA_REGISTER_WIDTH; m++) begin
                        if(m >= NO_PARALLEL_OUT_BIT_WIDTH)  begin
                            expected_parallel_data_out[k] = con_shadow_reg[m];
                            k++;
                        end
                    end
                    if (MULTIPLE_TAP == 0) begin
                        if(STapOutputPacket.ParallelDataOut === (expected_parallel_data_out ))
                            `ovm_info("**Parallel Data Matches during SWCLR !!!",
                                            $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                            STapOutputPacket.ParallelDataOut,
                                            (expected_parallel_data_out)),OVM_LOW)
                        else
                            `ovm_error("**Parallel Data  Mis Matches during SWCLR !!!",
                                             $psprintf("\nActual   Data: %0h\nExpected Data: %0h",
                                             STapOutputPacket.ParallelDataOut,
                                             (expected_parallel_data_out )))
                    end
                 end
                 no_of_pkts_for_which_data_compared++;
             end
          end
    endfunction

    //-----------------------------------------------------------------------------------------
    //Function secondary_passthru() used to capture secondary port values from
    //Monitors to local variables
    //-----------------------------------------------------------------------------------------
    function secondary_passthru();
        begin
            //******************************************************************************************
            // Copy the Packet Information from Input packet to Local Variables
            //******************************************************************************************
            lcl_ftapsslv_tck         = STapInputPacket.ftapsslv_tck;
            lcl_ftapsslv_tms         = STapInputPacket.ftapsslv_tms;
            lcl_ftapsslv_trst_b      = STapInputPacket.ftapsslv_trst_b;
            lcl_ftapsslv_tdi         = STapInputPacket.ftapsslv_tdi;
            lcl_sntapnw_atap_tdo2    = STapInputPacket.sntapnw_atap_tdo2;
            lcl_sntapnw_atap_tdo2_en = STapInputPacket.sntapnw_atap_tdo2_en;
            locked_opcode            = STapInputPacket.locked_opcode;

            //******************************************************************************************
            // Copy the Packet Information from Output packet to Local Variables
            //******************************************************************************************
            lcl_atapsslv_tdo         = STapOutputPacket.atapsslv_tdo;
            lcl_atapsslv_tdoen       = STapOutputPacket.atapsslv_tdoen;
            lcl_sntapnw_ftap_tck2    = STapOutputPacket.sntapnw_ftap_tck2 ;
            lcl_sntapnw_ftap_tms2    = STapOutputPacket.sntapnw_ftap_tms2 ;
            lcl_sntapnw_ftap_trst2_b = STapOutputPacket.sntapnw_ftap_trst2_b ;
            lcl_sntapnw_ftap_tdi2    = STapOutputPacket.sntapnw_ftap_tdi2;
        end
    endfunction

    //-----------------------------------------------------------------------------------------
    //Function dfxsignal_capturing() used to capture feature enable and VISA values from
    //Dfx Monitors to local variables
    //-----------------------------------------------------------------------------------------
    function dfxsignal_capturing();
        begin
            //******************************************************************************************
            // Copy the Packet Information from DfxSecurePlugin Output packet to Local Variables
            //******************************************************************************************
            lcl_green                = DspOutputPacket.dfxsecure_feature_en[0];
            lcl_orange               = DspOutputPacket.dfxsecure_feature_en[1];
            lcl_red                  = DspOutputPacket.dfxsecure_feature_en[2];
            lcl_visa_all_dis         = DspOutputPacket.visa_all_dis;
            lcl_visa_customer_dis    = DspOutputPacket.visa_customer_dis;

        end
    endfunction

endclass : STapScoreBoard
