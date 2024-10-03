// ===========================================================================================================
// Author:      Hemang V. Patel (hemang.v.patel@intel.com
// File:        dfx_iosfsb_sequence.sv
// Description: This file has 3 sequences
//                1. SBMSGGO    0x16
//                2. SBMSGRSP   0x17
//                3. SBMGNOGO   0x18
// ===========================================================================================================



// ===========================================================================================================
// Sequence: MSGBUSGO
// Description : This sequence is used ONLY for Register Writes/Reads using the IOSFSB using TAP instructions

// Notes:
// - User passes the tap he wants to run the sequence on as an argument in his test.
// - User enables the tap in the test (this sequence does not enable the TAP)
// - Port/Destination ID is present in the VLV Sideband fabric 1.0 HAS
// ===========================================================================================================

`ifndef DFX_IOSF_SB_MESSAGE_SEQUENCE_SV
`define DFX_IOSF_SB_MESSAGE_SEQUENCE_SV

class dfx_sbmsggo_sequence extends ovm_sequence #(dfx_tap_single_tap_transaction);

      dfx_node_t   [31:0] data;                 //95:64
      dfx_node_t   [15:0] address;              //63:48
      dfx_node_t   [7:0]  fid;                  //47:40
      dfx_node_t   [3:0]  fbe;                  //35:32
      dfx_node_t   [2:0]  tag;                  //26:24
      dfx_node_t   [2:0]  bar;                  //29:27
      dfx_node_t   [7:0]  opcode;               //23:16
      dfx_node_t   [7:0]  destination;          //15:9
      dfx_node_t   [1:0]  sb_msg_trigger_sel;   //7:6
      dfx_node_t          np_write;             //3:3
      dfx_node_t          broadcast_en;         //2:2
      //dfx_node_t          expanded_header;
      dfx_node_t          EH;                   //31:31
      dfx_tap_unit_e      tap_u;

  `ovm_object_utils(dfx_sbmsggo_sequence)
  `ovm_declare_p_sequencer(dfx_tap_sequencer)

  function new(string name = "dfx_sbmsggo_sequence");
    super.new(name);

      //As per the VLV NCTAP HAS the IOSF reg has a default value = 96'h0
      //=================================================================
      data               = 32'h0;
      address            = 16'h0;
      opcode             = 8'h0;
      destination        = 8'h0;
      sb_msg_trigger_sel = 2'h0;
      fid                = 8'h0;
      fbe                = 4'h0;
      tag                = 3'h0;
      bar                = 3'h0;
      np_write           = 0;
      broadcast_en       = 0;
      //expanded_header    = 0;
      EH                 = 0;
  endfunction : new


  task body();

      //dfx_tap_enable_sequence    tap_enb_seq;
      dfx_node_ary_t             ary;
      dfx_node_t      [23:0]     data_lower_half;
      dfx_node_t      [63:0]     ary_print;
      dfx_node_t      [95:0]     data_in;

      data_in   = 96'h0;


      // `ovm_info(get_type_name(), $psprintf("SBMSGGO Opcode = 8'h%0h\n", opcode), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("SBMSGGO Opcode = 8'h%0h\n", opcode), OVM_NONE)

      //Concataning the fields for the lower 24 bits of the Register
      //============================================================
      data_lower_half = {opcode, destination, sb_msg_trigger_sel, 2'b0, np_write, broadcast_en, 2'b0};/*24-bits*/

      //DEBUG
      // `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0h\n",data_lower_half), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0h\n",data_lower_half), OVM_NONE)
      // `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0b\n",data_lower_half), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0b\n",data_lower_half), OVM_NONE)


      //Concataning the lower 24 bits and the remaining fields to form a 96 bit registser value
      //=======================================================================================
      data_in = {data, address, fid, 4'h0, fbe, EH, 1'b0, bar, tag, data_lower_half};/*96-bits*/

      //DEBUG
      // `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0h\n",data_in), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0h\n",data_in), OVM_NONE)
      // `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0b\n",data_in), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0b\n",data_in), OVM_NONE)


     //Load the TAPC_SBMSGGO instruction & the IOSFSB DR
     //=================================================
     `ovm_create(req)
      req.tap_u = tap_u;
//      req.ir_in = 2'h16;
      req.ir_in = 8'h16; //zdror : tap2iosf didn't get correct instruction.
     //req.ir_in = dfx_tap_nctap::TAPC_SBMSGGO;
      ary = {<<{data_in}};
      req.dr_in = ary;
     // `ovm_info(get_type_name(), "Shifting TAPC_SBMSGGO Instruction into the CLTAP0 IR\n", OVM_FULL)
     `ovm_info(get_type_name(), "Shifting TAPC_SBMSGGO Instruction into the CLTAP0 IR\n", OVM_NONE)
     // `ovm_info(get_type_name(), "Shifting Data into the IOSFSB Register\n", OVM_FULL)
     `ovm_info(get_type_name(), "Shifting Data into the IOSFSB Register\n", OVM_NONE)
     `ovm_send(req)

     // `ovm_info(get_type_name(), "TAPC_SBMSGGO IR and DR transaction complete\n", OVM_FULL)
     `ovm_info(get_type_name(), "TAPC_SBMSGGO IR and DR transaction complete\n", OVM_NONE)
     // `ovm_info(get_type_name(), ">>>>> SBMSGGO Sequence complete\n", OVM_HIGH)
     `ovm_info(get_type_name(), ">>>>> SBMSGGO Sequence complete\n", OVM_NONE)
  endtask : body

endclass : dfx_sbmsggo_sequence


// ===========================================================================================================
// Sequence: MSGBUSNOGO
// Description : This sequence is used ONLY for Register Writes/Reads using the IOSFSB using TAP instructions

// Notes:   ADD TRIGGER STATUS!
// - User passes the tap he wants to run the sequence on as an argument in his test.
// - User enables the tap in the test (this sequence does not enable the TAP)
// - Port/Destination ID is present in the VLV Sideband fabric 1.0 HAS
// ===========================================================================================================

//================================================
class dfx_sbmsgnogo_sequence extends ovm_sequence #(dfx_tap_single_tap_transaction);


      dfx_node_t   [31:0] data;                 //95:64
      dfx_node_t   [15:0] address;              //63:48
      dfx_node_t   [7:0]  fid;                  //47:40
      dfx_node_t   [3:0]  fbe;                  //35:32
      dfx_node_t   [2:0]  bar;                  //29:27
      dfx_node_t   [2:0]  tag;                  //26:24
      dfx_node_t   [7:0]  opcode;               //23:16
      dfx_node_t   [7:0]  destination;          //15:9
      dfx_node_t   [1:0]  sb_msg_trigger_sel;   //7:6
      dfx_node_t          np_write;             //3:3
      dfx_node_t          broadcast_en;         //2:2
      dfx_node_t          EH;                   //31:31
      dfx_tap_unit_e      tap_u;

  `ovm_object_utils(dfx_sbmsgnogo_sequence)
  `ovm_declare_p_sequencer(dfx_tap_sequencer)


  function new(string name = "dfx_sbmsgnogo_sequence");
    super.new(name);

      //As per the VLV NCTAP HAS the IOSF reg has a default value = 96'h0
      //=================================================================
      data               = 32'h0;
      address            = 16'h0;
      opcode             = 8'h0;
      destination        = 8'h0;
      sb_msg_trigger_sel = 2'h0;
      fid                = 8'h0;
      fbe                = 4'h0;
      tag                = 3'h0;
      bar                = 3'h0;
      np_write           = 0;
      broadcast_en       = 0;
      EH                 = 0;
      //tap_u            = CLTAP0;
  endfunction : new


  task body();

      //dfx_tap_enable_sequence    tap_enb_seq;
      dfx_node_ary_t             ary;
      dfx_node_t      [23:0]     data_lower_half;
      dfx_node_t      [63:0]     ary_print;
      dfx_node_t      [95:0]     data_in;

      data_in   = 96'h0;


      // `ovm_info(get_type_name(), $psprintf("Opcode = 8'h%0h\n", opcode), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("Opcode = 8'h%0h\n", opcode), OVM_NONE)

      //Concataning the fields for the lower 24 bits of the Register
      //============================================================
      data_lower_half = {opcode, destination, sb_msg_trigger_sel, 2'b0, np_write, broadcast_en, 2'b0};/*24-bits*/

      //DEBUG
      // `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0h\n",data_lower_half), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0h\n",data_lower_half), OVM_NONE)
      // `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0b\n",data_lower_half), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA lower half = 96'h%0b\n",data_lower_half), OVM_NONE)


      //Concataning the lower 24 bits and the remaining fields to form a 96 bit registser value
      //=======================================================================================
      data_in = {data, address, fid, 4'h0, fbe, EH, 1'b0, bar, tag, data_lower_half};/*96-bits*/

      //DEBUG
      // `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0h\n",data_in), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0h\n",data_in), OVM_NONE)
      // `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0b\n",data_in), OVM_FULL)
      `ovm_info(get_type_name(), $psprintf("DATA IN = 96'h%0b\n",data_in), OVM_NONE)


     //Load the TAPC_SBMSGNOGO instruction & the IOSFSB DR
     //=================================================
     `ovm_create(req)
      req.tap_u = tap_u;
      req.ir_in = 8'h18;
      //req.ir_in = dfx_tap_nctap::TAPC_SBMSGNOGO; //FIX ME!! NOT DEFINED -> NCTAP
      ary = {<<{data_in}};
      req.dr_in = ary;
     // `ovm_info(get_type_name(), "Shifting TAPC_SBMSGNOGO Instruction into the CLTAP0 IR\n", OVM_FULL)
     `ovm_info(get_type_name(), "Shifting TAPC_SBMSGNOGO Instruction into the CLTAP0 IR\n", OVM_NONE)
     // `ovm_info(get_type_name(), "Shifting Data into the IOSFSB Register\n", OVM_FULL)
     `ovm_info(get_type_name(), "Shifting Data into the IOSFSB Register\n", OVM_NONE)
     `ovm_send(req)

     // `ovm_info(get_type_name(), "TAPC_SBMSGNOGO IR and DR transaction complete\n", OVM_FULL)
     `ovm_info(get_type_name(), "TAPC_SBMSGNOGO IR and DR transaction complete\n", OVM_NONE)
     // `ovm_info(get_type_name(), "SBMSGNOGO Sequence complete\n", OVM_HIGH)
     `ovm_info(get_type_name(), "SBMSGNOGO Sequence complete\n", OVM_NONE)
  endtask : body

endclass : dfx_sbmsgnogo_sequence


//============================================================================================
//Sequence:    SBMSGRSP
//Description: This function serially shifts out the Response data
//             and the response available bit on TDO after shifting in the TAPC_SBMSGRSP
//             and stores the values in response_data and response_avail variables
//             respectively.
// NOTE: The user needs to check in his test if the response avail bit is set to a 1 and only
//       then the Response Data variable will have the correct Data
//============================================================================================


class dfx_sbmsgrsp_sequence extends ovm_sequence #(dfx_tap_single_tap_transaction);

   dfx_node_t   [31:0]  response_data;   //Response Data
   dfx_node_t           response_avail;  //Response avail bit
   dfx_tap_unit_e       tap_u;
   dfx_node_ary_t       ary;


   `ovm_object_utils(dfx_sbmsgrsp_sequence)
   `ovm_declare_p_sequencer(dfx_tap_sequencer)
    function new(string name = "dfx_sbmsgrsp_sequence");
      super.new(name);
      response_data   = 32'h0;
      response_avail  = 1'b0;
    endfunction : new

  task body();

      //dfx_tap_enable_sequence                       tap_enb_seq;
      dfx_tap_single_tap_no_instruction_transaction data_req;
      dfx_node_t                          [95:0]    all_ones;
      dfx_node_t                          [63:0]    observed_iosfsbreg;
      dfx_node_t                          [31:0]    rsp_data;
      int                                           poll_avail;
      int                                           j;

      poll_avail = 0;
      all_ones   = 64'hffff_ffff_ffff_ffff; //in NCTAP cntrl need to shift lower 64 bits for rsp bit and read(MSGD) data
      observed_iosfsbreg = 64'h0;


      //RUN IR SHIFT
      //============

     `ovm_create(req)
      req.tap_u = tap_u;
//      req.ir_in = 2'h17;
      req.ir_in = 8'h17; //zdror : wrong IR length
      //req.ir_in = dfx_tap_nctap::TAPC_SBMSGRSP;
     // `ovm_info(get_type_name(), "Shifting TAPC_SBMSGRSP Instruction into the CLTAP0 IR\n", OVM_FULL)
     `ovm_info(get_type_name(), "Shifting TAPC_SBMSGRSP Instruction into the CLTAP0 IR\n", OVM_NONE)
     `ovm_send(req)

     // `ovm_info(get_type_name(), "Shifting TAPC_SBMSGRSP Instruction is complete\n", OVM_FULL)
     `ovm_info(get_type_name(), "Shifting TAPC_SBMSGRSP Instruction is complete\n", OVM_NONE)


   //   while (poll_avail < 100) // zdror : takes too much time .
        while (poll_avail < 6)
        begin

      //RUN DR SHIFT
      //============
           // `ovm_info(get_type_name(), "Shifting Response Data & Response_avail bit on TDO\n", OVM_FULL)
           `ovm_info(get_type_name(), "Shifting Response Data & Response_avail bit on TDO\n", OVM_NONE)

           `ovm_create(data_req)
            ary = {<< {64'hffffffffffffffff}};
            data_req.tap_u = tap_u;
            data_req.dr_in =  ary;
           `ovm_send(data_req)

           // `ovm_info(get_type_name(), "Response Data & Response Available bit is shifted out on TDO\n", OVM_FULL)
           `ovm_info(get_type_name(), "Response Data & Response Available bit is shifted out on TDO\n", OVM_NONE)

           observed_iosfsbreg = {<<{data_req.ttd_out}};

           //DEBUG
           //=====
           // `ovm_info(get_type_name(), $psprintf("TDO = 64'h%0h\n", observed_iosfsbreg), OVM_FULL)
           `ovm_info(get_type_name(), $psprintf("TDO = 64'h%0h\n", observed_iosfsbreg), OVM_NONE)
           // `ovm_info(get_type_name(), $psprintf("TDO = 64'b%0b\n", observed_iosfsbreg), OVM_FULL)
           `ovm_info(get_type_name(), $psprintf("TDO = 64'b%0b\n", observed_iosfsbreg), OVM_NONE)

           //Checking the response available bits
           //====================================
           if((observed_iosfsbreg[0] == 1'b1) && (observed_iosfsbreg[1] == 1'b1))
             begin
                // `ovm_info(get_type_name(), "SUCCESS: Response available bit is set in the IOSFSB Reg\n", OVM_FULL)
                `ovm_info(get_type_name(), "SUCCESS: Response available bit is set in the IOSFSB Reg\n", OVM_NONE)
                response_avail = 1'b1;
                break;       //If the response avail bit is set then we don't need to Poll again.
             end
           else
             begin
                poll_avail++;
                // `ovm_info(get_type_name(), $psprintf("Response bit is not set, Poll_avail = %d\n", poll_avail), OVM_FULL)
                `ovm_info(get_type_name(), $psprintf("Response bit is not set, Poll_avail = %d\n", poll_avail), OVM_NONE)
             end
       end

      //The poll happens only 5 times, if it exceeds this limit, the test error's out
      if(poll_avail >= 5)
        begin
        `ovm_error(get_type_name(), "ERROR: Response Available bit is not set in the IOSFSB Reg after polling 5 times\n")
        // `ovm_info(get_type_name(), $psprintf("Poll_avail = %d\n", poll_avail), OVM_FULL)
        `ovm_info(get_type_name(), $psprintf("Poll_avail = %d\n", poll_avail), OVM_NONE)
        end

      //Writes the TDO data into the 32 bit rsp_data variable
      //=====================================================
      for (j = 0; j<32; j++)
        begin
           rsp_data[j] = observed_iosfsbreg[j+32];
        end


      response_data  = rsp_data;


  endtask : body
endclass : dfx_sbmsgrsp_sequence

//============================================================================================

`endif// `ifndef DFX_SBMSGRSP_SEQUENCE_SV





