//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
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
//  %header_collateral%
//
//  Source organization:
//  %header_organization%
//
//  Support Information:
//  %header_support%
//
//  Revision:
//  %header_tag%
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_Driver.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Driver to the DUT
//    DESCRIPTION : This Block Drives the DUT through the pin interface
//                  It decodes the Sequencer tasks and drives the DUT
//                  accordingly
//----------------------------------------------------------------------
`ifndef INC_DfxSecurePlugin_Driver
`define INC_DfxSecurePlugin_Driver

class DfxSecurePlugin_Driver #(`DSP_TB_PARAMS_DECL) extends uvm_driver;

   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
   protected virtual DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) pins;

   //--------------------------
   // Data Item from Sequencer
   //--------------------------
   DfxSecurePlugin_SeqDrvTxn i_DfxSecurePlugin_SeqDrvTxn;

   //---------------------------------
   // Register component with Factory
   //---------------------------------
   `uvm_component_param_utils (DfxSecurePlugin_Driver #(`DSP_TB_PARAMS_INST))

   localparam LOW = 1'b0;
   localparam HIGH = 1'b1;
   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_Driver",
                        uvm_component parent = null);
   extern function void connect_phase (uvm_phase phase);

   //-------------
   // Class Tasks
   //-------------
   extern task run_phase  (uvm_phase phase);
   extern local task fsm;
   extern local task drive_data (DfxSecurePlugin_SeqDrvTxn drvTxn);
   extern local task transaction_to_dut;
   extern local task default_mode;
   extern local task test_driver;
   extern local task drive_user_policy;
   extern local task powergood_reset;
   extern local task sideband_policy;
   extern local task drive_oem_secure_policy_strap;
   extern local task drive_fdfx_secure_policy;
   extern local task drive_sb_policy_ovr_value;
   extern local task drive_fdfx_policy_update;
   extern local task drive_fdfx_earlyboot_exit;
   
   reg [(TB_DFX_SECURE_WIDTH-1):0]                policy_val;
   reg [(TB_DFX_SECURE_WIDTH-1):0]                oem_secure_policy_strap_val;
   reg [(TB_DFX_SECURE_WIDTH-1):0]                oem_secure_policy_const_val;
   reg [(TB_DFX_SECURE_WIDTH-1):0]                fdfx_secure_policy_val;
   reg [(TB_DFX_NUM_OF_FEATURES_TO_SECURE + 1):0] sb_policy_ovr_val;
   reg                                            fdfx_policy_update_val;
   reg                                            fdfx_earlyboot_exit_val;

endclass : DfxSecurePlugin_Driver

/***************************************************************
 * Standard UVM new function creates a new object 
 *  @param name    : uvm name
 *  @param parent  : uvm parent component
***************************************************************/
function DfxSecurePlugin_Driver::new (string name = "DfxSecurePlugin_Driver",
                               uvm_component parent = null);
   super.new (name, parent);
endfunction : new
 
/***************************************************************
 * Standard UVM connect function 
***************************************************************/
function void DfxSecurePlugin_Driver::connect_phase (uvm_phase phase); 

   // Temp Object
   uvm_object temp;

   DfxSecurePlugin_VifContainer  #(`DSP_TB_PARAMS_INST) vif_container;

   super.connect_phase(phase);

   // Assigning virtual interface
   assert(uvm_config_object::get(this, "","V_DFXSECPLUGIN_VIF", temp));
   $cast(vif_container, temp);
   pins = vif_container.get_v_if();

endfunction : connect_phase


/***************************************************************
 * Standard UVM run task 
***************************************************************/
task DfxSecurePlugin_Driver::run_phase  (uvm_phase phase);
   fork
         transaction_to_dut;
         // fsm;
   join_any
endtask
 
/***************************************************************
 * Task to get and drive transactions
***************************************************************/
task DfxSecurePlugin_Driver::transaction_to_dut;
   forever
   begin
      // Get Item from the sequencer
      seq_item_port.get_next_item (req);
      $cast(i_DfxSecurePlugin_SeqDrvTxn, req);
      // Send the Txn to DUT
      drive_data (i_DfxSecurePlugin_SeqDrvTxn);
      // Call sequencer's item done
      seq_item_port.item_done (i_DfxSecurePlugin_SeqDrvTxn);
   end
endtask

/***************************************************************
 * Task to get and drive transactions
***************************************************************/
task DfxSecurePlugin_Driver::drive_data (input DfxSecurePlugin_SeqDrvTxn drvTxn);
   begin

      policy_val                  =  drvTxn.policy_value;
      oem_secure_policy_strap_val =  drvTxn.oem_secure_policy_strap_val_drv;
      fdfx_secure_policy_val      =  drvTxn.fdfx_secure_policy_val_drv;
      sb_policy_ovr_val           =  drvTxn.sb_policy_ovr_val_drv;
      fdfx_policy_update_val      =  drvTxn.fdfx_policy_update_val_drv;
      fdfx_earlyboot_exit_val     =  drvTxn.fdfx_earlyboot_exit_val_drv;
      oem_secure_policy_const_val =  drvTxn.oem_secure_policy_const_val;

      case (drvTxn.UsageMode)
         DEFAULT_MODE: 
            begin
               default_mode;
            end
         DRIVE_ALL_POLICIES: 
            begin
               test_driver;
            end
         DRIVE_USER_POLICY: 
            begin
               drive_user_policy;
            end
         POWERGOOD_RESET: 
            begin
               powergood_reset;
            end
         SIDEBAND_POLICY: 
            begin
               sideband_policy;
            end
         DRIVE_OEM_SECURE_POLICY_STRAP:
            begin
               drive_oem_secure_policy_strap;
            end
         DRIVE_FDFX_SECURE_POLICY:
            begin
               drive_fdfx_secure_policy;
            end
         DRIVE_SB_POLICY_OVR_VALUE:
            begin
               drive_sb_policy_ovr_value;
            end
         DRIVE_FDFX_POLICY_UPDATE:
            begin
               drive_fdfx_policy_update;
            end
         DRIVE_FDFX_EARLYBOOT_EXIT:
            begin
               drive_fdfx_earlyboot_exit;
            end
      endcase

   end
endtask

/***************************************************************
 * Task to get and drive transactions
***************************************************************/
task DfxSecurePlugin_Driver::fsm;
   forever
   begin

   end
endtask


/***************************************************************
 * Task to place the DUT in default mode. Drive the reset asynchrously.
***************************************************************/
task DfxSecurePlugin_Driver::default_mode;

   `uvm_info (get_type_name(), "In task default_mode ...", UVM_MEDIUM);

   pins.fdfx_powergood                 <= LOW;
   pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
   pins.drv_cb_neg.fdfx_policy_update  <= LOW;
   pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
   pins.drv_cb_neg.sb_policy_ovr_value <= '0;
   pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
   @(negedge pins.tb_clk);
   pins.fdfx_powergood                 <= HIGH;
   if (TB_DFX_USE_SB_OVR == 0) begin
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= LOW;
      pins.drv_cb_neg.sb_policy_ovr_value <= '0;
      pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      repeat (10) @(negedge pins.tb_clk);
   end
   else begin
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= LOW;
      pins.drv_cb_neg.sb_policy_ovr_value <= $random();
      pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      repeat (10) @(negedge pins.tb_clk);
   end


endtask : default_mode

/***************************************************************
 * Task to place the DUT in test_driver mode. Drive the reset asynchrously.
 * Drive all 16 policies in DFX_SECURE_POLICY_MATRIX
***************************************************************/
task DfxSecurePlugin_Driver::test_driver;

   `uvm_info (get_type_name(), "In task test_driver ...", UVM_MEDIUM);

   pins.fdfx_powergood                 <= LOW;
   pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
   pins.drv_cb_neg.fdfx_policy_update  <= LOW;
   pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
   pins.drv_cb_neg.sb_policy_ovr_value <= '0;
   pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
   @(negedge pins.tb_clk);
   pins.fdfx_powergood                 <= HIGH;
   

   repeat(16) begin
      // first 10
      repeat (1) @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      repeat (2) @(negedge pins.tb_clk);


      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_secure_policy  <= $random();
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= HIGH;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      repeat (5) @(negedge pins.tb_clk);

      // second 10
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      repeat (2) @(negedge pins.tb_clk);


      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b1111;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      repeat (5) @(negedge pins.tb_clk);

      // third 10
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= HIGH;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      repeat (2) @(negedge pins.tb_clk);


      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b1111;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;

      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_earlyboot_exit <= HIGH;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      if (TB_DFX_USE_SB_OVR == 0) begin
         pins.drv_cb_neg.sb_policy_ovr_value <= '0;
         pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      end
      else begin
         pins.drv_cb_neg.sb_policy_ovr_value <= $random();
         pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      end

      repeat (5) @(negedge pins.tb_clk);
   end

endtask : test_driver

/***************************************************************
 * Task to place the DUT in powergood_reset mode.
***************************************************************/
task DfxSecurePlugin_Driver::powergood_reset;

   `uvm_info (get_type_name(), "In task powergood_reset ...", UVM_MEDIUM);

   pins.fdfx_powergood                 <= HIGH;
   pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
   pins.drv_cb_neg.fdfx_policy_update  <= LOW;
   pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
   pins.drv_cb_neg.sb_policy_ovr_value <= '0;
   pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
   @(negedge pins.tb_clk);
   
   pins.fdfx_powergood                 <= LOW;
   repeat (2) @(negedge pins.tb_clk);
  
   pins.fdfx_powergood                 <= HIGH;

endtask : powergood_reset

/***************************************************************
 * Task to place the DUT in drive_user_policy mode. Drive the reset asynchrously.
 * Drive the user defined policies on DFX_SECURE_POLICY_MATRIX
***************************************************************/
task DfxSecurePlugin_Driver::drive_user_policy;
   string msg;

   `uvm_info (get_type_name(), "In task drive_user_policy ...", UVM_MEDIUM);
   $swrite (msg, "%0b Policy_driven_on fdfx_secure_policy", policy_val); `uvm_info (get_type_name(), msg, UVM_MEDIUM);

   if (TB_DFX_USE_SB_OVR == 0) begin
      //@(negedge pins.tb_clk);
      pins.drv_cb_neg.sb_policy_ovr_value <= '0;
      pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      pins.drv_cb_neg.fdfx_earlyboot_exit <= HIGH;
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= policy_val;
      @(negedge pins.tb_clk);

      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;

      //pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      //@(negedge pins.tb_clk);
   end
   else begin
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.sb_policy_ovr_value <= $random();
      pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      pins.drv_cb_neg.fdfx_earlyboot_exit <= HIGH;
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= policy_val;
      @(negedge pins.tb_clk);

      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;
      @(negedge pins.tb_clk);
      pins.drv_cb_neg.fdfx_policy_update  <= HIGH;

      //pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      //@(negedge pins.tb_clk);
   end

endtask : drive_user_policy

/***************************************************************
 * Task to place the DUT in sideband_policy mode. Drive the reset asynchrously.
 * Drive the sb_policy_ovr_value & oem_secure_policy inputs to the 0x0 & 0x0
 * respectively
***************************************************************/
task DfxSecurePlugin_Driver::sideband_policy;

   `uvm_info (get_type_name(), "In task sideband_policy ...", UVM_MEDIUM);

   if (TB_DFX_USE_SB_OVR == 0) begin
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      pins.drv_cb_neg.sb_policy_ovr_value <= '0;
      pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      repeat (10) @(negedge pins.tb_clk);
   end
   else begin
      pins.drv_cb_neg.fdfx_earlyboot_exit <= LOW;
      pins.drv_cb_neg.fdfx_policy_update  <= LOW;
      pins.drv_cb_neg.fdfx_secure_policy  <= 4'b0000;
      pins.drv_cb_neg.sb_policy_ovr_value <= $random();
      pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_const_val;
      repeat (10) @(negedge pins.tb_clk);
   end

endtask : sideband_policy

/***************************************************************
 * Drive User defined oem_secure_policy
***************************************************************/
task DfxSecurePlugin_Driver::drive_oem_secure_policy_strap;

   `uvm_info (get_type_name(), "In task drive_oem_secure_policy_strap ...", UVM_MEDIUM);

   if (TB_DFX_USE_SB_OVR == 0) begin
      pins.drv_cb_neg.oem_secure_policy   <= 4'b0000; // Security locked
      repeat (1) @(negedge pins.tb_clk);
   end
   else begin
      pins.drv_cb_neg.oem_secure_policy   <= oem_secure_policy_strap_val;
      repeat (1) @(negedge pins.tb_clk);
   end

endtask : drive_oem_secure_policy_strap

/***************************************************************
 * Drive User defined fdfx_secure_policy
***************************************************************/
task DfxSecurePlugin_Driver::drive_fdfx_secure_policy;

   `uvm_info (get_type_name(), "In task drive_fdfx_secure_policy ...", UVM_MEDIUM);

   pins.drv_cb_neg.fdfx_secure_policy  <= fdfx_secure_policy_val;
   repeat (1) @(negedge pins.tb_clk);

endtask : drive_fdfx_secure_policy

/***************************************************************
 * Drive User defined sb_policy_ovr_value
***************************************************************/
task DfxSecurePlugin_Driver::drive_sb_policy_ovr_value;

   `uvm_info (get_type_name(), "In task drive_sb_policy_ovr_value ...", UVM_MEDIUM);

   if (TB_DFX_USE_SB_OVR == 0) begin
      pins.drv_cb_neg.sb_policy_ovr_value <= '0;
      repeat (1) @(negedge pins.tb_clk);
   end
   else begin
      pins.drv_cb_neg.sb_policy_ovr_value <= sb_policy_ovr_val;
      repeat (1) @(negedge pins.tb_clk);
   end

endtask : drive_sb_policy_ovr_value

/***************************************************************
 * Drive User defined fdfx_policy_update
***************************************************************/
task DfxSecurePlugin_Driver::drive_fdfx_policy_update;

   `uvm_info (get_type_name(), "In task drive_fdfx_policy_update ...", UVM_MEDIUM);

   pins.drv_cb_neg.fdfx_policy_update  <= fdfx_policy_update_val;
   repeat (1) @(negedge pins.tb_clk);

endtask : drive_fdfx_policy_update

/***************************************************************
 * Drive User defined fdfx_policy_update
***************************************************************/
task DfxSecurePlugin_Driver::drive_fdfx_earlyboot_exit;

   `uvm_info (get_type_name(), "In task drive_fdfx_earlyboot_exit ...", UVM_MEDIUM);

   pins.drv_cb_neg.fdfx_earlyboot_exit <= fdfx_earlyboot_exit_val;
   repeat (1) @(negedge pins.tb_clk);

endtask : drive_fdfx_earlyboot_exit

`endif // INC_DfxSecurePlugin_Driver   
