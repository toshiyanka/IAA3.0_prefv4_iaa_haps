
//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
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
//
//  Collateral Description:
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : JtagBfmEndebugTapLinkAccess.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     :  Used to send the transactions for TAPLINK through ENDEBUG 
//------------------------------------------------------------------------
   //-------------------------------------------------------------------------
   // Task is used for sending the transactions for TAPLINK through ENDEBUG
   //-------------------------------------------------------------------------
   protected task Endebug_TapLink_Access (
               input [1:0] ResetMode,
               input [API_SIZE_OF_IR_REG-1:0]     Address,
               input int   addr_len,
               input [WIDTH_OF_EACH_REGISTER-1:0] Data,
               input [WIDTH_OF_EACH_REGISTER-1:0] Expected_Data,
               input [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdoQualifier='0,
               input [WIDTH_OF_EACH_REGISTER-1:0] Mask_Data, 
               input int   data_len,
               output bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data,
               input  bit                               LongEndebugTAPFSMPath=1'b0,
               output bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_data_chopped);
   
   begin//{
      string msg;
      logic [127:0] original_tap_data; 
      logic [127:0] enc_tap_data; 
      logic [127:0] dec_tap_data; 
      logic [WIDTH_OF_EACH_REGISTER-1:0] ReturnTdo;
      logic [63:0]  expected_dec_tap_data[WIDTH_OF_EACH_REGISTER-1:0]; 
      byte          bytes_original_tap_data[15:0]; 
      byte          bytes_original_enc_tap_data[15:0]; 
      byte          bytes_enc_tap_data[15:0]; 
      byte          bytes_dec_tap_data[15:0]; 
      int           Opcode_loop;
      int           EndebugDrWidthFinal;
      int           EndebugDrWidthFinal_Last;
      int           Data_loop;
      int           addr_len_int=addr_len;
      int           ResetMode_int=ResetMode;
      bit  [WIDTH_OF_EACH_REGISTER-1:0] tdo_dataAndQualifier;
      int  Count;
      jtagbfm_encryption_reg JTAGBFM_ENCRYPTION_REG;
      //----------------------------------------------------------------------------------------------------//
      if(LongEndebugTAPFSMPath === 1'b1) begin
         JTAGBFM_ENCRYPTION_REG.REG_ACCESS_COUNTER = enc_reg_count;
         JTAGBFM_ENCRYPTION_REG.RSVD               = 3'b0;
         JTAGBFM_ENCRYPTION_REG.USE_DR_AS_IR       = 1'b0;
         JTAGBFM_ENCRYPTION_REG.IRDATA             = Address;
         JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE       = 2'b00;
         JTAGBFM_ENCRYPTION_REG.LONG_IR_MODE       = 2'b00;          
         JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER    = '0;
         JTAGBFM_ENCRYPTION_REG.DRDATA             = '0;
         JTAGBFM_ENCRYPTION_REG.FSM_MODE           = 2'b01;

         original_tap_data ={JTAGBFM_ENCRYPTION_REG.REG_ACCESS_COUNTER, 
                             JTAGBFM_ENCRYPTION_REG.RSVD,
                             JTAGBFM_ENCRYPTION_REG.USE_DR_AS_IR,
                             JTAGBFM_ENCRYPTION_REG.LONG_IR_MODE,
                             JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE,
                             JTAGBFM_ENCRYPTION_REG.FSM_MODE,
                             JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER,
                             JTAGBFM_ENCRYPTION_REG.IRDATA,
                             JTAGBFM_ENCRYPTION_REG.DRDATA};  
           
         if(ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_DEC_MACHINE === 1'b0) begin
            conv_128bit_to_16bytes(original_tap_data,bytes_original_tap_data);
            aes_c_enc_wrapper(bytes_original_tap_data,aes_key,bytes_enc_tap_data);
            previous_enc_data = {128{1'b0}};
            conv_16bytes_to_128bit(bytes_enc_tap_data,enc_tap_data);
         end
         else
         begin
            enc_tap_data = original_tap_data;
         end
         `uvm_do_with(Packet, {Packet.Address                 == CLTAP_ENDEBUG_RTDR_START_ADDRESS;
                               Packet.Expected_Address        == 'h01;
                               Packet.Mask_Address            == 'h00; 
                               Packet.ResetMode               == ResetMode_int;
                               Packet.FunctionSelect          == 3'b010;
                               Packet.addr_len                == addr_len_int;
                               Packet.Extended_FunctionSelect == 2'b00;
                               })
         get_response(rsp);                      

         `uvm_do_with(Packet, { Packet.Data                   == enc_tap_data;
                               Packet.Expected_Data           == previous_enc_data;
                               Packet.Mask_Data               == {128{1'b0}};
                               Packet.ResetMode               == 2'b00;
                               Packet.FunctionSelect          == 3'b001;
                               Packet.data_len                == 128;
                               Packet.Extended_FunctionSelect == 2'b10;
                               })
         get_response(rsp);                      
         $cast(Packet,rsp);
         ReturnTdo = Packet.actual_tdo_collected;
         previous_enc_data = enc_tap_data;
         enc_reg_count++;
         $display("ENCRYPTION_REG Counter = %d",enc_reg_count);
         //if(!((ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_ENC_MACHINE === 1'b1) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_DEC_MACHINE === 1'b1))) begin
         JtagBfmEnDebugStatusPoll(addr_len_int,0,0);//RUN_BUSY is polling for 0
         //end
      end

      EndebugDrWidthFinal = data_len;
      if(EndebugDrWidthFinal <=64)
      begin
        Data_loop = 1;
      end
      else begin
        Data_loop = EndebugDrWidthFinal/64;
        EndebugDrWidthFinal_Last = EndebugDrWidthFinal - ((EndebugDrWidthFinal/64)*64);
        if(EndebugDrWidthFinal_Last !== 0) begin
           Data_loop = Data_loop +1;
        end
      end  
      for(int i =0; i < Data_loop+3;i++)
      begin//{
         JTAGBFM_ENCRYPTION_REG.REG_ACCESS_COUNTER = enc_reg_count;
         JTAGBFM_ENCRYPTION_REG.RSVD               = 3'b0;
         JTAGBFM_ENCRYPTION_REG.USE_DR_AS_IR       = 1'b0;
         if(i>=Data_loop) begin
            JTAGBFM_ENCRYPTION_REG.IRDATA             = 16'hFFFF;
         end
         else
         begin
            JTAGBFM_ENCRYPTION_REG.IRDATA             = Address;
         end
         if (EndebugDrWidthFinal<=64) begin
            JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE    = 2'b00;
            JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER = EndebugDrWidthFinal-1;
            JTAGBFM_ENCRYPTION_REG.DRDATA          = Data[(i*64)+63 -: 64];
         end
         else
         begin
            if ( i == 0) begin
               JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE    = 2'b10;
               JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER = 6'h3F;
               JTAGBFM_ENCRYPTION_REG.DRDATA          = Data[(i*64)+63 -: 64];
            end
            else if (i >0) begin
               if(i ==  (Data_loop-1)) 
               begin
                 if(EndebugDrWidthFinal_Last == 0) 
                 begin
                   JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE    = 2'b01; 
                   JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER = 6'h3F;
                   JTAGBFM_ENCRYPTION_REG.DRDATA          = Data[(i*64)+63 -: 64];
                 end
                 else
                 begin
                   JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE    = 2'b01;
                   JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER = EndebugDrWidthFinal_Last-1;
                   JTAGBFM_ENCRYPTION_REG.DRDATA          = Data[(i*64)+63 -: 64];
                 end
               end
               else
               begin
                 JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE    = 2'b11;
                 JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER = 6'h3F;
                 JTAGBFM_ENCRYPTION_REG.DRDATA          = Data[(i*64)+63 -: 64];
               end
            end
         end 
         JTAGBFM_ENCRYPTION_REG.LONG_IR_MODE = 2'b00;          
         
         if(LongEndebugTAPFSMPath === 1'b1) begin
            if(i >= Data_loop) begin
               JTAGBFM_ENCRYPTION_REG.FSM_MODE     = 2'b11;
            end else begin
               JTAGBFM_ENCRYPTION_REG.FSM_MODE     = 2'b10;
            end
         end
         else
         begin
            if((i === 0) || (i >= Data_loop)) begin
               JTAGBFM_ENCRYPTION_REG.FSM_MODE     = 2'b11;
            end else begin
               JTAGBFM_ENCRYPTION_REG.FSM_MODE     = 2'b10;
            end
         end

         original_tap_data ={JTAGBFM_ENCRYPTION_REG.REG_ACCESS_COUNTER, 
                             JTAGBFM_ENCRYPTION_REG.RSVD,
                             JTAGBFM_ENCRYPTION_REG.USE_DR_AS_IR,
                             JTAGBFM_ENCRYPTION_REG.LONG_IR_MODE,
                             JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE,
                             JTAGBFM_ENCRYPTION_REG.FSM_MODE,
                             JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER,
                             JTAGBFM_ENCRYPTION_REG.IRDATA,
                             JTAGBFM_ENCRYPTION_REG.DRDATA};  
           
         if(ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_DEC_MACHINE === 1'b0) begin
            conv_128bit_to_16bytes(original_tap_data,bytes_original_tap_data);
            aes_c_enc_wrapper(bytes_original_tap_data,aes_key,bytes_enc_tap_data);
            if(LongEndebugTAPFSMPath === 1'b0) begin
               previous_enc_data = {128{1'b0}};
            end
            conv_16bytes_to_128bit(bytes_enc_tap_data,enc_tap_data);
         end
         else
         begin
            enc_tap_data = original_tap_data;
         end
         `uvm_do_with(Packet, {Packet.Address                 == CLTAP_ENDEBUG_RTDR_START_ADDRESS;
                               Packet.Expected_Address        == 'h01;
                               Packet.Mask_Address            == 'h00; 
                               Packet.ResetMode               == ResetMode_int;
                               Packet.FunctionSelect          == 3'b010;
                               Packet.addr_len                == addr_len_int;
                               Packet.Extended_FunctionSelect == 2'b00;
                               })
         get_response(rsp);                      

         `uvm_do_with(Packet, { Packet.Data                   == enc_tap_data;
                               Packet.Expected_Data           == previous_enc_data;
                               Packet.Mask_Data               == {128{1'b0}};
                               Packet.ResetMode               == 2'b00;
                               Packet.FunctionSelect          == 3'b001;
                               Packet.data_len                == 128;
                               Packet.Extended_FunctionSelect == 2'b10;
                               })
         get_response(rsp);                      
         $cast(Packet,rsp);
         ReturnTdo = Packet.actual_tdo_collected;
         if(i>=3) begin
            if(ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_ENC_MACHINE === 1'b0) begin
               conv_128bit_to_16bytes(ReturnTdo[127:0],bytes_original_enc_tap_data);
               aes_c_dec_wrapper(bytes_original_enc_tap_data,aes_key,bytes_dec_tap_data);
               conv_16bytes_to_128bit(bytes_dec_tap_data,dec_tap_data);
               expected_dec_tap_data[i-3] = dec_tap_data[63:0];
            end
            else
            begin
               expected_dec_tap_data[i-3] = ReturnTdo[63:0];
            end
         end
         previous_enc_data = enc_tap_data;
         enc_reg_count++;
         $display("ENCRYPTION_REG Counter = %d",enc_reg_count);
         if(EndebugDrWidthFinal > 64) begin
            if(TapResetTapAccess == 1'b1) begin
              if(i == 0) begin
                 ENDEBUG_ENCRYPTION_CFG.START_DEBUG_SESSION = 2'b00;
                 ENDEBUG_ENCRYPTION_CFG.TAP_RESET = 1'b1;
                 JtagBfmEnDebugCfgReg(ENDEBUG_ENCRYPTION_CFG,addr_len_int); 
              end
            end
         end
         //if(!((ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_ENC_MACHINE === 1'b1) && (ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_DEC_MACHINE === 1'b1))) begin
         JtagBfmEnDebugStatusPoll(addr_len_int,0,0);//RUN_BUSY is polling for 0
         //end

      end//}
 
      for(int i =0; i < Data_loop;i++)
      begin
         if (EndebugDrWidthFinal<64) begin
            tdo_data[(i*64)+63 -: 64] = expected_dec_tap_data[i] >> (64-EndebugDrWidthFinal);
         end
         else
         begin
            if((EndebugDrWidthFinal_Last !== 0) && (i ==  (Data_loop-1))) begin
               tdo_data[(i*64)+63 -: 64] = expected_dec_tap_data[i] >> (64-EndebugDrWidthFinal_Last);
            end
            else
            begin
               tdo_data[(i*64)+63 -: 64] = expected_dec_tap_data[i];
            end
         end
      end

          `dbg_display ("InternalTDOData = %0h", tdo_data);
          tdo_dataAndQualifier = tdo_data & ReturnTdoQualifier;
          `dbg_display ("tdo_dataAndQualifier = %0h", tdo_dataAndQualifier);

          Count = 0;
          while (ReturnTdoQualifier[0] == 0) begin
             tdo_dataAndQualifier = (tdo_dataAndQualifier >> 1);
             ReturnTdoQualifier = (ReturnTdoQualifier >> 1);
             `dbg_display ("while tdo_dataAndQualifier = %0h", tdo_dataAndQualifier);
             `dbg_display ("while ReturnTdoQualifier  = %0h", ReturnTdoQualifier);
             Count++;
          end
          tdo_data_chopped = tdo_dataAndQualifier;
      for(int i =0; i< data_len;i++) begin
         if(Mask_Data[i] == 1'b1) begin
             if(Expected_Data[i] !== tdo_data[i]) begin
                 $swrite (msg,"\nEXPECTED_ENDEBUG_TDO_ERROR: The Error at bit: %0d\nActual ENDEBUG_TAP_TDO: %b\nExpected ENDEBUG_TAP_TDO: %b",i,tdo_data[i],Expected_Data[i]);
                 `uvm_error(get_type_name(), msg);
             end else begin
                 $swrite (msg, "\nEXPECTED_ENDEBUG_TDO_MATCH: The Match at bit: %0d\nActual ENDEBUG_TAP_TDO: %b\nExpected ENDEBUG_TAP_TDO: %b",i,tdo_data[i],Expected_Data[i]);
                `uvm_info (get_type_name(), msg, UVM_MEDIUM);
             end
         end
      end
      $swrite (msg, "\nThe Actual ENDEBUG_TAP_TDO Collected: %0h\nThe Expected ENDEBUG_TAP_TDO        : %0h",tdo_data,Expected_Data);
      `uvm_info (get_type_name(), msg, UVM_MEDIUM);


      //----------------------------------------------------------------------------------------------------//
   end//}
   endtask
