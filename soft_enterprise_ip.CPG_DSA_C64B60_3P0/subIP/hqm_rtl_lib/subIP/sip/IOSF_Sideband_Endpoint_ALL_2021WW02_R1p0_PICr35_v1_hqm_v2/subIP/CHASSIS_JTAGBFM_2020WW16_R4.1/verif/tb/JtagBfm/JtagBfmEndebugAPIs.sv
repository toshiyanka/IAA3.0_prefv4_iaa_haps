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
//    FILENAME    : JtagBfmEndebugAPIs.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//
//
//    PURPOSE     : ENDEBUG APIs for the JTAGBFM
//------------------------------------------------------------------------
    
  `ifndef JTAG_BFM_AES_256
    byte          dec_fuse_key_byte1[15:0];
    logic [127:0] dec_fuse_key_bit;
    //logic [127:0] dec_fuse_key_bit1;
    byte fuse_key_byte[15:0];
    byte dec_fuse_key_byte[15:0];
    byte bytes_hw_data[15:0];//FIXME
    byte aes_key[15:0];
    logic [135:0] EndebugFuseKey;
    logic [127:0] EndebugFuseKeyDecd;
    logic [255:0] ReturnTdo;
  `else
    byte          dec_fuse_key_byte1[31:0];
    logic [255:0] dec_fuse_key_bit;
    //logic [127:0] dec_fuse_key_bit1;
    byte fuse_key_byte[31:0];
    byte dec_fuse_key_byte[31:0];
    byte bytes_hw_data[31:0];//FIXME
    byte aes_key[31:0];
    logic [263:0] EndebugFuseKey;
    logic [255:0] EndebugFuseKeyDecd;
    logic [512:0] ReturnTdo;
  `endif
    byte bytes_data[15:0];
    byte dec_data3[15:0];
    byte dec_data2[15:0];
    byte dec_data1[15:0];
    byte dec_data[15:0];
    logic [127:0] dec_bit_data3;
    logic [127:0] dec_bit_data2;
    logic [127:0] dec_bit_data1;
    logic [127:0] dec_bit_data;
    byte enc_data[15:0];
    logic [127:0] enc_data_signal;
    logic [127:0] previous_enc_data = 128'h0;
    static int enc_reg_count=0;
    static logic  FuseDisable;
    integer file,c;
    string filename;
    logic  EndebugStatusRegStatusValue;
    logic  Debug_En = 1'b0;
    logic  [API_TOTAL_DATA_REGISTER_WIDTH-1:0] TDO_DATA;

    task JtagBfmEnDebugRTDRBaseAddressSetup(
                                        input [API_SIZE_OF_IR_REG-1:0] EnDebugOpcodeBaseAddress=16'h40
                                       );
    begin
       CLTAP_ENDEBUG_RTDR_START_ADDRESS = EnDebugOpcodeBaseAddress;
    end
    endtask:JtagBfmEnDebugRTDRBaseAddressSetup
    
    //------------------------------------------------------------------------------------
    // Task is used for poll the Endebug Status Register based on Bit number and bit value 
    //------------------------------------------------------------------------------------
    task JtagBfmEnDebugStatusPoll(
                     input int                      CltapIrLength = 16,
                     input int                      StatusBit,
                     input                          StatusBitValue);

      begin//{
          if(StatusBit === 0) begin
             randomize() with {EndebugTrasactionIdleTime <= 500; EndebugTrasactionIdleTime >= 0; } ;
             `ovm_info(get_type_name(),$psprintf("Values of EndebugTrasactionIdleTime = %d",EndebugTrasactionIdleTime),OVM_LOW);
             //Idle(EndebugTrasactionIdleTime);
          end
          `ovm_do_with(Packet, {Packet.Address                 == CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h2;
                                Packet.Expected_Address        == 'h01;
                                Packet.Mask_Address            == 'h00; 
                                Packet.ResetMode               == NO_RST;
                                Packet.FunctionSelect          == LOAD_IR;
                                Packet.addr_len                == CltapIrLength;
                                Packet.Extended_FunctionSelect == 2'b00;
                                })
          get_response(rsp);                      
          Goto(UPIR,1);
          forever// DRNG Puller done polling
          begin
            `ovm_do_with(Packet, { Packet.Data                   == 'h0;
                                  Packet.Expected_Data           == 'h0;
                                  Packet.Mask_Data               == 'h0;
                                  Packet.ResetMode               == NO_RST;
                                  Packet.FunctionSelect          == LOAD_DR;
                                  Packet.data_len                == StatusBit+1;
                                  Packet.Extended_FunctionSelect == 2'b00;
                                  })
            get_response(rsp);                      
            $cast(Packet,rsp);
            ReturnTdo = Packet.actual_tdo_collected;
            Goto(UPDR,1);
            if(ReturnTdo[StatusBit] === StatusBitValue) begin
               Goto(RUTI,1);
               break;
            end
          end
      end//}
    endtask:JtagBfmEnDebugStatusPoll
     
    //------------------------------------------------------------------------------------
    // Task is used for poll the Endebug Status Register based on Bit number and bit value 
    //------------------------------------------------------------------------------------
    task JtagBfmEnDebugStatusReg(
                     input int                      CltapIrLength = 16,
                     input int                      StatusBit,
                     output logic                   StatusBitValue);

      begin//{
          if(StatusBit === 0) begin
             randomize() with {EndebugTrasactionIdleTime <= 500; EndebugTrasactionIdleTime >= 0; } ;
             `ovm_info(get_type_name(),$psprintf("Values of EndebugTrasactionIdleTime = %d",EndebugTrasactionIdleTime),OVM_LOW);
             //Idle(EndebugTrasactionIdleTime);
          end
          `ovm_do_with(Packet, {Packet.Address                 == CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h2;
                                Packet.Expected_Address        == 'h01;
                                Packet.Mask_Address            == 'h00; 
                                Packet.ResetMode               == NO_RST;
                                Packet.FunctionSelect          == LOAD_IR;
                                Packet.addr_len                == CltapIrLength;
                                Packet.Extended_FunctionSelect == 2'b00;
                                })
          get_response(rsp);                      
          Goto(UPIR,1);
          `ovm_do_with(Packet, { Packet.Data                   == 'h0;
                                Packet.Expected_Data           == 'h0;
                                Packet.Mask_Data               == 'h0;
                                Packet.ResetMode               == NO_RST;
                                Packet.FunctionSelect          == LOAD_DR;
                                Packet.data_len                == StatusBit+1;
                                Packet.Extended_FunctionSelect == 2'b00;
                                })
          get_response(rsp);                      
          $cast(Packet,rsp);
          ReturnTdo = Packet.actual_tdo_collected;
          Goto(UPDR,1);
          StatusBitValue = ReturnTdo[StatusBit];
          Goto(RUTI,1);
      end//}
    endtask:JtagBfmEnDebugStatusReg

    //--------------------------------------------------------------------
    // Task is used for setup the Endebug 
    //--------------------------------------------------------------------
    task JtagBfmEnDebugSetup(
                     input jtagbfm_encryption_cfg   EndebugEncryptionCfg,
                     input bit                      ENDEBUG_SCAN_MODE = 1'b0,
                     input bit                      SESSION_TERMINATE_WITH_FIRSTPKT0S = 1'b0,
                     input bit                      SESSION_TERMINATE_WITH_SECONDPKT = 1'b0,
                     input bit                      SESSION_TERMINATE_WITH_CNTOVRFLOW = 1'b0,
                     input bit                      SESSION_TERMINATE_WITH_DATAOVRFLOW = 1'b0,
                     input int                      CltapIrLength = 16,
                `ifndef JTAG_BFM_AES_256 
                     input [127:0]                  endbg_fuse_decrypt_key=0);
                `else
                     input [255:0]                  endbg_fuse_decrypt_key=0);
                `endif

      begin//{
          ENDEBUG_ENCRYPTION_CFG = EndebugEncryptionCfg;
          `ovm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_CFG = %p",ENDEBUG_ENCRYPTION_CFG),OVM_NONE);
          JtagBfmEnDebugStatusReg(CltapIrLength,16,EndebugStatusRegStatusValue);
          if(EndebugStatusRegStatusValue === 1'b0) begin
             JtagBfmEnDebugStatusPoll(CltapIrLength,20,1);// DRNG Puller done polling
          end

          if(ENDEBUG_ENCRYPTION_DEBUG_CFG.FUSEKEY_OVRD === 1'b0) begin
             //Reading Fuse Data from the file
             filename =  "endebug_fuse_data.txt";
             file = $fopen(filename, "r");
             if (!file) `ovm_fatal(get_type_name(), {"couldn't open file ", filename});
             $display("%d",file);
             while (!$feof(file)) begin
                 c = $fscanf(file,"%h",EndebugFuseKey);
             end
             $fclose(file);
        //16010670341 - AES 256-bit engine PCR
        `ifndef JTAG_BFM_AES_256
             if(EndebugFuseKey[129]===1)begin
                 //1607214003 - Fuse encryption PCR
                 `ovm_info(get_type_name(),$psprintf("enDebug fuse decryption enable = 1, Started fuse decryption"),OVM_NONE);
                 conv_128bit_to_16bytes(endbg_fuse_decrypt_key[127:0],bytes_hw_data);//Metal key
                 conv_128bit_to_16bytes(EndebugFuseKey[127:0],fuse_key_byte); //Fuse key
                 aes_c_dec_wrapper(fuse_key_byte,bytes_hw_data,dec_fuse_key_byte);
                 conv_16bytes_to_128bit(dec_fuse_key_byte,dec_fuse_key_bit);
                 `ovm_info(get_type_name(),$psprintf("Completed the fuse decryption"),OVM_NONE);
                 EndebugFuseKey[127:0]=dec_fuse_key_bit;
             end
          end
          else if(ENDEBUG_ENCRYPTION_DEBUG_CFG.FUSEKEY_OVRD === 1'b1) begin //HSD:1604314177
             EndebugFuseKey = 136'h00112233445566778899aabbccddeeff;
          end
          FuseDisable = EndebugFuseKey[128];
        `else
             if(EndebugFuseKey[257]===1)begin
                 //1607214003 - Fuse encryption PCR
                 `ovm_info(get_type_name(),$psprintf("enDebug fuse decryption enable = 1, Started fuse decryption"),OVM_NONE);
                 conv_256bit_to_32bytes(endbg_fuse_decrypt_key[255:0],bytes_hw_data);//Metal key
                 conv_256bit_to_32bytes(EndebugFuseKey[255:0],fuse_key_byte); //Fuse key
                 //FUSE dec pass1
                 aes_c_dec_wrapper(fuse_key_byte[15:0],bytes_hw_data,dec_fuse_key_byte[15:0]);
                 //FUSE dec pass2
                 aes_c_dec_wrapper(fuse_key_byte[31:16],bytes_hw_data,dec_fuse_key_byte[31:16]);
                 conv_32bytes_to_256bit(dec_fuse_key_byte,dec_fuse_key_bit);
                 `ovm_info(get_type_name(),$psprintf("Completed the fuse decryption, "),OVM_NONE);
                 EndebugFuseKey[255:0]=dec_fuse_key_bit;
             end
          end
          else if(ENDEBUG_ENCRYPTION_DEBUG_CFG.FUSEKEY_OVRD === 1'b1) begin //HSD:1604314177
            `ifndef JTAG_BFM_AES_256
                EndebugFuseKey = 136'h00112233445566778899aabbccddeeff;
            `else
                EndebugFuseKey = 263'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;//FIXME 
            `endif
          end
          `ifndef JTAG_BFM_AES_256
              FuseDisable = EndebugFuseKey[128];
          `else
              FuseDisable = EndebugFuseKey[256];
          `endif
        `endif
        
          if(FuseDisable === 1'b0) begin//{
              MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CltapIrLength, ENDEBUG_CFG_REG_LENGTH);// Start session
              if(ENDEBUG_ENCRYPTION_DEBUG_CFG.SESSIONKEY_OVRD === 1'b0) begin
                 JtagBfmEnDebugStatusPoll(CltapIrLength,4,1);// Key Ready polling
                 
                 ReturnTDO_ExpData_MultipleTapRegisterAccessRuti(
                     .ResetMode        (NO_RST),
                     .Address          (CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h3),    
                     .addr_len         (CltapIrLength),
                 `ifndef JTAG_BFM_AES_256
                     .data_len         (256),
                     .Data             (256'h0),
                     .Expected_Data    (256'h0),
                     .Mask_Data        (256'h0),
                 `else
                     .data_len         (512),
                     .Data             (512'h0),
                     .Expected_Data    (512'h0),
                     .Mask_Data        (512'h0),
                 `endif
                     .tdo_data         (ReturnTdo));
              `ifdef JTAG_BFM_AES_256
                 //Getting Session Key from RTL
                 conv_256bit_to_32bytes(EndebugFuseKey[255:0],fuse_key);
                 //SessionKeyDec Pass1
                 conv_128bit_to_16bytes(ReturnTdo[127:0],bytes_data);
                 aes_c_dec_wrapper(bytes_data,fuse_key,dec_data);
                 conv_16bytes_to_128bit(dec_data,dec_bit_data);
                 //SessionKeyDec Pass2
                 conv_128bit_to_16bytes(ReturnTdo[255:128],bytes_data);
                 aes_c_dec_wrapper(bytes_data,fuse_key,dec_data1);
                 conv_16bytes_to_128bit(dec_data1,dec_bit_data1);
                 //SessionKeyDec Pass3
                 conv_128bit_to_16bytes(ReturnTdo[383:256],bytes_data);
                 aes_c_dec_wrapper(bytes_data,fuse_key,dec_data2);
                 conv_16bytes_to_128bit(dec_data2,dec_bit_data2);
                 //SessionKeyDec Pass4
                 conv_128bit_to_16bytes(ReturnTdo[511:384],bytes_data);
                 aes_c_dec_wrapper(bytes_data,fuse_key,dec_data3);
                 conv_16bytes_to_128bit(dec_data3,dec_bit_data3);

                 for (int i =0;i<32;i++) begin
                    if(i<32 && i>=24) aes_key[i] = dec_data3[i-16];
                    else if(i<24 && i>=16) aes_key[i] = dec_data2[i-8];
                    else if(i<16 && i>=8) aes_key[i] = dec_data1[i];
                    else    aes_key[i] = dec_data[i+8];
                 end
                 
                 if((dec_bit_data[63:0] !== 64'h0) || (dec_bit_data1[63:0] !== 64'h01)|| (dec_bit_data2[63:0] !== 64'h02)|| (dec_bit_data3[63:0] !== 64'h03))begin
                    `ovm_fatal(get_type_name(),">>>> Mismatch on decrypted Key RTDR read value , Expected key0[63:0] =0 ,key1[63:0]=1 ,key2[63:0]=2,key3[63:0]=3>>>>> ");
                 end
              `else
                 //Getting Session Key from RTL
                 conv_128bit_to_16bytes(ReturnTdo[127:0],bytes_data);
                 conv_128bit_to_16bytes(EndebugFuseKey[127:0],fuse_key);
                 //SessionKeyDec Pass1
                 aes_c_dec_wrapper(bytes_data,fuse_key,dec_data);
                 conv_16bytes_to_128bit(dec_data,dec_bit_data);
                 conv_128bit_to_16bytes(ReturnTdo[255:128],bytes_data);
                 //SessionKeyDec Pass2
                 aes_c_dec_wrapper(bytes_data,fuse_key,dec_data1);
                 conv_16bytes_to_128bit(dec_data1,dec_bit_data1);

                 for (int i =0;i<16;i++) begin
                    if(i<8) aes_key[i] = dec_data[8+i];
                    else    aes_key[i] = dec_data1[i];
                 end
                 
                 if((dec_bit_data[63:0] !== 64'h0) || (dec_bit_data1[63:0] !== 64'h01))begin
                    `ovm_fatal(get_type_name(),">>>> Mismatch on decrypted Key RTDR read value , Expected key0[63:0] =0 ,key1[63:0]=1 >>>>> ");
                 end
              `endif
              end
              else
              begin
                 `ifndef JTAG_BFM_AES_256
                    for (int i =0;i<16;i++) begin
                       aes_key[i] = 15-i;
                    end
                 `else
                    for (int i =0;i<32;i++) begin
                       aes_key[i] = 31-i;//FIXME
                    end
                 `endif
              end
              if(SESSION_TERMINATE_WITH_FIRSTPKT0S === 1'b0) begin
                  conv_128bit_to_16bytes(128'h0,bytes_data);
              end
              else
              begin
                  conv_128bit_to_16bytes({32'h1,96'h0},bytes_data);
              end
              `ifndef JTAG_BFM_AES_256
                aes_c_enc_wrapper(bytes_data,aes_key,enc_data);
              `else
                aes_c_enc_wrapper(bytes_data,aes_key,enc_data);
              `endif
              conv_16bytes_to_128bit(enc_data,enc_data_signal);

              if(ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_DEC_MACHINE === 1'b0) begin
                 MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS, enc_data_signal,CltapIrLength, 128);
              end
              else
              begin
                 MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS, 128'h0, CltapIrLength,128);
              end
              Goto(RUTI,1);
              if(SESSION_TERMINATE_WITH_SECONDPKT === 1'b0) begin
                 enc_reg_count++;
              end
              else
              begin
                 enc_reg_count++;
                 enc_reg_count++;
              end
              if(SESSION_TERMINATE_WITH_CNTOVRFLOW === 1'b1) begin
                 enc_reg_count = 32'h7FFF_FFFF;     
              end
              if(SESSION_TERMINATE_WITH_DATAOVRFLOW === 1'b1) begin
                 MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS, enc_data_signal,CltapIrLength,128);
              end
              JtagBfmEnDebugStatusPoll(CltapIrLength,0,0);//RUN_BUSY is polling for 0
              $display("ENCRYPTION_REG Counter = %d",enc_reg_count);
              //#10000ns;
              if(ENDEBUG_ENCRYPTION_DEBUG_CFG.BYPASS_DEC_MACHINE === 1'b0) begin
                 JtagBfmEnDebugStatusPoll(CltapIrLength,9,1);//ENDEBUG_READY is polling
              end
              JtagBfmEnDebugStatusPoll(CltapIrLength,8,1);//ENDEBUG_OWN is polling
              if(ENDEBUG_SCAN_MODE === 1'b0) begin
                 ENDEBUG_OWN= 1'b1;
              end
              else
              begin
                 ENDEBUG_OWN= 1'b0;
              end
              //if(Endebug_Enable_Tapnw_0_Tlink_1 === 1'b0) begin
              ENDEBUG_ENCRYPTION_CFG.START_DEBUG_SESSION = 2'b00;
              ENDEBUG_ENCRYPTION_CFG.TAP_RESET = 1'b1;
              JtagBfmEnDebugCfgReg(ENDEBUG_ENCRYPTION_CFG,CltapIrLength); 
              ArcTapEnDbgCount = 0;
              PhyTapEnDbgCount = 0;
              //end
          end//}
          else begin
            `ovm_warning(get_type_name(),">>>> Fuse Data is disabled >>>>> ");
          end
       end//}
    endtask:JtagBfmEnDebugSetup

    //--------------------------------------------------------------------
    // Task is used for setting End Address and Enable Taplink for Endebug
    //--------------------------------------------------------------------
    task JtagBfmEndebugTapLinkCfg(
                     input [API_SIZE_OF_IR_REG-1:0] CltapEndAddress=16'hFF,
                     input                          EndebugEnableTlink = 1'b0 );
    begin
        Endebug_Cltap_End_Address = CltapEndAddress;
        Endebug_Enable_Tapnw_0_Tlink_1 = EndebugEnableTlink;
    end
    endtask:JtagBfmEndebugTapLinkCfg

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug CFG Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebugCfgReg(
                              input jtagbfm_encryption_cfg   EndebugEncryptionCfg,
                              input int                      CltapIrLength = 16);
    begin
    
       ENDEBUG_ENCRYPTION_CFG = EndebugEncryptionCfg;
       //ENDEBUG_ENCRYPTION_CFG.START_DEBUG_SESSION = 2'b00;
       `ovm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_CFG = %p",ENDEBUG_ENCRYPTION_CFG),OVM_NONE);
       `ifndef JTAGBFM_ENDEBUG_110REV
       if(EndebugEncryptionCfg.END_DEBUG_SESSION === 1'b1) begin
          //---------------------------TGP----------------
          JtagBfmEnDebugStatusReg(CltapIrLength,7,EndebugStatusRegStatusValue);
          if(EndebugStatusRegStatusValue === 1'b1) begin
             ENDEBUG_OWN   = 1'b0;
          end
          //---------------------------TGP----------------
       end
       `endif
       MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h1, ENDEBUG_ENCRYPTION_CFG, CltapIrLength, ENDEBUG_CFG_REG_LENGTH);
       if(ENDEBUG_ENCRYPTION_CFG.END_DEBUG_SESSION === 1'b1) begin
          enc_reg_count = 0;
       end
    end
    endtask:JtagBfmEnDebugCfgReg

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug DEBUG CFG Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebug_DebugCfgReg(
                              input jtagbfm_encryption_debug_cfg   EndebugEncryptionDebugCfg,
                              input bit                            Policy_2_4  = 1'b0,
                              input int                            CltapIrLength = 16);
    begin
       `ifndef JTAGBFM_ENDEBUG_110REV
       if(Policy_2_4 === 1'b1) begin
          Debug_En = ENDEBUG_ENCRYPTION_DEBUG_CFG.DEBUGEN;
       end
       `endif
       ENDEBUG_ENCRYPTION_DEBUG_CFG = EndebugEncryptionDebugCfg;
       `ovm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_DEBUG_CFG = %p",ENDEBUG_ENCRYPTION_DEBUG_CFG),OVM_NONE);
       MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h4, ENDEBUG_ENCRYPTION_DEBUG_CFG, CltapIrLength, ENDEBUG_DEBUG_CFG_REG_LENGTH);
    end
    endtask:JtagBfmEnDebug_DebugCfgReg

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug DEBUG CFG GREEN Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebug_DebugCfgRegGrn(
                              input jtagbfm_encryption_debug_cfg   EndebugEncryptionDebugCfg,
                              input int                            CltapIrLength  = 16);
    begin
       if(Debug_En === 1'b1) begin
          ENDEBUG_ENCRYPTION_DEBUG_CFG = EndebugEncryptionDebugCfg;
          `ovm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_DEBUG_CFG = %p",ENDEBUG_ENCRYPTION_DEBUG_CFG),OVM_NONE);
          MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h8, ENDEBUG_ENCRYPTION_DEBUG_CFG, CltapIrLength, ENDEBUG_DEBUG_CFG_REG_LENGTH);
       end
    end
    endtask:JtagBfmEnDebug_DebugCfgRegGrn

    //--------------------------------------------------------------------
    // Task is used to Program the Endebug DEBUG SESSION KEY OVERRIDE Register
    //--------------------------------------------------------------------
    task JtagBfmEnDebug_DebugSessionKeyOvr(
                              input jtagbfm_encryption_debug_sessionkeyovr   EndebugEncryptionSessionKeyOvr,
                              input int                                      CltapIrLength  = 16);
    begin
       ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR = EndebugEncryptionSessionKeyOvr;
       `ovm_info(get_type_name(),$psprintf("Values of Register ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR = %p",ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR),OVM_NONE);
       MultipleTapRegisterAccess_RUTI(NO_RST, CLTAP_ENDEBUG_RTDR_START_ADDRESS+'h7, ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR, CltapIrLength, ENDEBUG_ENCRYPTION_DEBUG_SESSIONKEYOVR_LENGTH);
    end
    endtask:JtagBfmEnDebug_DebugSessionKeyOvr

    //--------------------------------------------------------------------
    // Task is used to Reset values when Endebug is off 
    //--------------------------------------------------------------------
    task JtagBfmEnDebugResetPowerGood;
    begin
       enc_reg_count = 0;
       ENDEBUG_OWN   = 1'b0;
       FuseDisable   = 1'b0;
       ENDEBUG_ENCRYPTION_CFG = '0;
       ENDEBUG_ENCRYPTION_DEBUG_CFG = '0;
       ArcTapEnDbgCount = 0;
       PhyTapEnDbgCount = 0;
    end
    endtask:JtagBfmEnDebugResetPowerGood

    //-------------------------------------------------------------------------------------
    // Task is used to Enable IR and DR paths seperately for TAPLINK access through ENDEBUG 
    //-------------------------------------------------------------------------------------
    task JtagBfmEnDebugEnableLongTAPFSMPath(bit EnableLongEndebugTAPFSMPath = 1'b0);
    begin
       LongEndebugTAPFSMPath = EnableLongEndebugTAPFSMPath;
    end
    endtask:JtagBfmEnDebugEnableLongTAPFSMPath

    task JtagBfmEndebugTapResetTapAccess (bit EnableTapResetTapAccess = 1'b0);
    begin
       TapResetTapAccess = EnableTapResetTapAccess;
    end
    endtask:JtagBfmEndebugTapResetTapAccess

    //--------------------------------------------------------------------
    // Task is used for converting 128bit to 16bytes 
    //--------------------------------------------------------------------
    protected task conv_128bit_to_16bytes (logic [127:0] data, output byte bytes_data[15:0]);
       for(int i=0;i<16;i++) begin
         bytes_data[i] = data[(i*8)+7 -: 8];
       end

    endtask:conv_128bit_to_16bytes

    //--------------------------------------------------------------------
    // Task is used for converting 16bytes to 128bit
    //--------------------------------------------------------------------
    protected task conv_16bytes_to_128bit (byte bytes_data[15:0],output logic [127:0] data);
       for(int i=0;i<16;i++) begin
         data[(i*8)+7 -: 8] = bytes_data[i];
       end

    endtask:conv_16bytes_to_128bit

    //--------------------------------------------------------------------
    // Task is used for converting 256bit to 32bytes 
    //--------------------------------------------------------------------
    protected task conv_256bit_to_32bytes (logic [255:0] data, output byte bytes_data[31:0]);
       for(int i=0;i<32;i++) begin
         bytes_data[i] = data[(i*8)+7 -: 8];
       end

    endtask:conv_256bit_to_32bytes

    //--------------------------------------------------------------------
    // Task is used for converting 32bytes to 256bit
    //--------------------------------------------------------------------
    protected task conv_32bytes_to_256bit (byte bytes_data[31:0],output logic [255:0] data);
       for(int i=0;i<32;i++) begin
         data[(i*8)+7 -: 8] = bytes_data[i];
       end

    endtask:conv_32bytes_to_256bit

    task JtagBfmEnDebug_FSMMODE00_RUTI_TO_TLRS (input int CLTAPIrWidth = 16);
 
    begin//{
 
       logic [127:0] original_tap_data; 
       logic [127:0] enc_tap_data; 
       byte          bytes_original_tap_data[15:0]; 
       byte          bytes_enc_tap_data[15:0]; 
       jtagbfm_encryption_reg JTAGBFM_ENCRYPTION_REG;
 
       JTAGBFM_ENCRYPTION_REG.REG_ACCESS_COUNTER = enc_reg_count;
       JTAGBFM_ENCRYPTION_REG.RSVD               = 3'b0;
       JTAGBFM_ENCRYPTION_REG.USE_DR_AS_IR       = 1'b1;
       JTAGBFM_ENCRYPTION_REG.IRDATA             = 16'h0;
       JTAGBFM_ENCRYPTION_REG.LONG_IR_MODE    = 2'b00;
       JTAGBFM_ENCRYPTION_REG.DRSHIFT_COUNTER = '0;
       JTAGBFM_ENCRYPTION_REG.DRDATA          = '0;
       JTAGBFM_ENCRYPTION_REG.LONG_DR_MODE = 2'b00; 
       JTAGBFM_ENCRYPTION_REG.FSM_MODE     = 2'b00;
 
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
          conv_16bytes_to_128bit(bytes_enc_tap_data,enc_tap_data);
       end
       else begin
          enc_tap_data = original_tap_data;
       end
       LoadIR(NO_RST,CLTAP_ENDEBUG_RTDR_START_ADDRESS,'h01,'h00,CLTAPIrWidth);
       previous_enc_data = enc_data_signal;
       LoadDR_idle(NO_RST,enc_tap_data,previous_enc_data,{128{1'b0}},128);
       previous_enc_data = enc_tap_data;
       enc_reg_count++;
       $display("ENCRYPTION_REG Counter = %d",enc_reg_count);
       JtagBfmEnDebugStatusPoll(CLTAPIrWidth,0,0);//RUN_BUSY is polling for 0
 
    end//}
    endtask:JtagBfmEnDebug_FSMMODE00_RUTI_TO_TLRS

    //------------------------------------------
    // Multiple TAP Register Access
    //------------------------------------------
    protected task MultipleTapRegisterAccess_RUTI(
        input [1:0] ResetMode,
        input [API_SIZE_OF_IR_REG-1:0] Address,
        input [API_TOTAL_DATA_REGISTER_WIDTH-1:0] Data,
        input int addr_len,
        input int data_len);
        begin
         LoadIR_E1IR(NO_RST,Address,addr_len);
         LoadDrWithReturnTdoShortPath(NO_RST,Data,{API_TOTAL_DATA_REGISTER_WIDTH{1'b0}},{API_TOTAL_DATA_REGISTER_WIDTH{1'b0}},data_len,TDO_DATA);
        end
    endtask : MultipleTapRegisterAccess_RUTI


