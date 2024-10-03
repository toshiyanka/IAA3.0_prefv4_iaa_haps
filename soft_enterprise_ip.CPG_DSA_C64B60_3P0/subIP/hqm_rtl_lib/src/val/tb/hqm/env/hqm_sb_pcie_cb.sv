`ifndef HQM_SB_PCIE_CB
`define HQM_SB_PCIE_CB

class hqm_sb_pcie_cb extends iosfsbm_cm::opcode_cb;
  `ovm_component_utils(hqm_sb_pcie_cb)

  bit           pcie_err_msg_received=0;
  int           pcie_err_msg_count=0;
  bit [7:0] error_code='h_0;
  bit [7:0] func_num='h_0;
  bit [7:0] bus_num='h_0;
  bit        hqm_is_reg_ep_arg;
  hqm_pf_cfg_bridge_file                pf_cfg_regs;
  sla_ral_env           ral;
  ovm_event_pool glbl_pool;
  ovm_event      deassertinta_event;
  ovm_event      assertinta_event;
  ovm_event      fed_sb_event;
  ovm_event      nfed_sb_event;
  ovm_event      ced_sb_event;
  

  function new(string name, ovm_component parent);
    super.new(name, parent);
    glbl_pool      = ovm_event_pool::get_global_pool();
    deassertinta_event     = glbl_pool.get("deassertinta_event");
    assertinta_event     = glbl_pool.get("assertinta_event");
    fed_sb_event     = glbl_pool.get("fed_sb_event");
    nfed_sb_event     = glbl_pool.get("nfed_sb_event");
    ced_sb_event     = glbl_pool.get("ced_sb_event");
  endfunction :new
  
  function iosfsbm_cm::msgd_xaction execute_posted_msgd_cb(string name, iosfsbm_cm::ep_cfg m_ep_cfg, iosfsbm_cm::common_cfg m_common_cfg, bit[1:0] rsp_field, iosfsbm_cm::xaction rx_xaction);
    `ovm_info(get_full_name(),$psprintf("side band message received  = %s",rx_xaction.sprint_header()), OVM_DEBUG) 
    if ( rx_xaction.xaction_class == iosfsbm_cm::POSTED) begin

      case (rx_xaction.opcode)

        // -- PCIe error message opcode -- //

        'h49: begin 

              pcie_err_msg_received = 1'b1;
              pcie_err_msg_count    = pcie_err_msg_count+1;    
         	  if(!$value$plusargs("HQM_PCIE_ERROR_MSG_FUNC_NUM=%d",func_num)) func_num='h_0;
            `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
            if (ral == null)
                `ovm_info(get_full_name(),$psprintf("NULL handle to RAL"), OVM_LOW);
            `sla_assert($cast(pf_cfg_regs,          ral.find_file("hqm_pf_cfg_i")),     ("Unable to get handle to pf_cfg_regs."))
              if(func_num == 0)
                  bus_num = pf_cfg_regs.DEVICE_COMMAND.get_bus_num();
              if(!$value$plusargs("ERROR_CODE=%d", error_code)) error_code = 'h_0;

              if(!$value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg)) hqm_is_reg_ep_arg = 'h_0 ;
           
              if($test$plusargs("HQM_PCIE_TXN"))begin
                `ovm_info(get_full_name(),$psprintf("Received a PCIe error msg"), OVM_LOW);
                `ovm_info(get_full_name(),$psprintf("opcode 0x%0x  read data (0x%08x)  src_pid (0x%0x) dest_pid (0x%0x) tag (0x%0x) msgsizedw (0x%0x) )of PCIE_ERROR",rx_xaction.opcode,rx_xaction.msg[0], rx_xaction.src_pid, rx_xaction.dest_pid, rx_xaction.tag, rx_xaction.msg_size_dw),OVM_DEBUG)

                  foreach (rx_xaction.msg[i]) // -- Printing the msg contents -- //
                    `ovm_info(get_full_name(),$psprintf("IOSF SB MSG data[%0d]:(0x%08x) of PCIe error msg",i, rx_xaction.msg[i]),OVM_DEBUG)
                    case(rx_xaction.msg[10])
                        8'h30: begin 
                               ced_sb_event.trigger();
                               `ovm_info(get_full_name(),$psprintf("Triggered event, ced received"),OVM_LOW)
                               end
                        8'h31: begin 
                               nfed_sb_event.trigger();
                               `ovm_info(get_full_name(),$psprintf("Triggered event, nfed received"),OVM_LOW)
                               end
                        8'h33: begin 
                               fed_sb_event.trigger(); 
                               `ovm_info(get_full_name(),$psprintf("Triggered event, fed received"),OVM_LOW)
                               end
                    endcase    
                    if (rx_xaction.msg[10] != error_code) 
                       `ovm_error(get_name(), $psprintf("PCIe error code chk FAILED with: rx_xaction.error_code = %h, error_code = %h",rx_xaction.msg[10], error_code))
                    else   
                       `ovm_info(get_full_name(),$psprintf("PCIe error code chk PASSED with: rx_xaction.error_code = %h, error_code = %h",rx_xaction.msg[10], error_code),OVM_LOW)
                     if (rx_xaction.msg[8] != (func_num)) 
                        `ovm_error(get_name(), $psprintf("rx_xaction.func_num = %h,func_num  = %h",rx_xaction.msg[8], func_num))
                     else   
                        `ovm_info(get_full_name(),$psprintf("expected message func_num received rx_xaction.func_num = %h,func_num  = %h",rx_xaction.msg[8], func_num),OVM_LOW)
                     if (rx_xaction.msg[9] != (bus_num)) 
                        `ovm_error(get_name(), $psprintf("rx_xaction.bus_num = %h, bus_num  = %h",rx_xaction.msg[9], bus_num))
                     else   
                        `ovm_info(get_full_name(),$psprintf("expected message bus_num received rx_xaction.bus_num = %h,bus_num  = %h",rx_xaction.msg[9],bus_num),OVM_LOW)
                  end 

             else begin
                 ovm_report_error(get_full_name(), "NOT EXPECTED PCIE  OBSERVED ", OVM_HIGH);
                 ovm_report_error(get_full_name(), $psprintf("FINALLY NOT EXPECTED  PCIE OBSERVED"), OVM_LOW);

             end // -- if HQM_PCIE_TXN 

             return null;
         end
     'h80: begin
           assertinta_event.trigger();
           `ovm_info(get_full_name(),$psprintf("Triggered event, assert_INTA received"),OVM_LOW)
     end 
     'h84: begin
           deassertinta_event.trigger();
           `ovm_info(get_full_name(),$psprintf("Triggered event, Deassert_INTA received"),OVM_LOW)
     end 
       endcase

    end // -- if iosfsbm_cm::POSTED
    
  endfunction :execute_posted_msgd_cb

  virtual function void report();
      if($test$plusargs("HQM_PCIE_TXN")) begin
		  if(pcie_err_msg_received) `ovm_info(get_full_name(),$psprintf("Expected PCIe error message(s) received during test."),OVM_LOW)
          else                     `ovm_error(get_full_name(),$psprintf("Expected PCIe error message(s) not received during test."))
      end
  endfunction
endclass

`endif
