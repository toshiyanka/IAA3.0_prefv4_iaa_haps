class hqm_iosf_sb_PCIE_cb extends iosfsbm_cm::opcode_cb;
  `ovm_component_utils(hqm_iosf_sb_PCIE_cb)

  bit           PCIE_received;
  bit [31:0]    hqm_fuse_values;
  int           PCIE_count;

  function new(string name, ovm_component parent);
    string      fuse_string;
    longint     lfuse_val;

    super.new(name, parent);

    PCIE_count = 0;

     endfunction :new
  
  function iosfsbm_cm::msgd_xaction execute_posted_msgd_cb(string name, iosfsbm_cm::ep_cfg m_ep_cfg, iosfsbm_cm::common_cfg m_common_cfg, bit[1:0] rsp_field, iosfsbm_cm::xaction rx_xaction);
    // Locals
    string msg;
    //iosfsbm_cm::comp_xaction tx_xaction;
    iosfsbm_cm::msgd_xaction tx_xaction;


    // Handle completions
    if ( rx_xaction.xaction_class == iosfsbm_cm::POSTED) begin
      if(!( $cast(tx_xaction, ovm_factory::create_object("iosfsbm_cm::msgd_xaction", "msgd_xaction"))))
        ovm_report_fatal("CASTING","Type mismatch");
    
      tx_xaction.set_cfg(m_ep_cfg, m_common_cfg);


    
      case (rx_xaction.opcode)
        'h49: begin //PCIE assertion
        PCIE_received = 1'b1;
        PCIE_count = PCIE_count+1;    
        
                  if($test$plusargs("PCIE_TXN"))begin

               ovm_report_info("PCIE_INFO", "OBSERVED PCIE  was EXPECTED and PCIE received ", OVM_HIGH);
               ovm_report_info("PCIE_INFO", $psprintf("OBSERVED PCIE was  EXPECTED and received PCIE "), OVM_LOW);
   //`ovm_info("PCIE_INFO",$psprintf("%s: opcode 0x%0x  read data (0x%08x) of PCIE_ERROR",rx_xaction.opcode,rx_xaction.msg[0]),OVM_LOW)

             end 

             else 
                  begin
                 ovm_report_error("PCIE_INFO", "NOT EXPECTED PCIE  OBSERVED ", OVM_HIGH);
                 ovm_report_error("PCIE_INFO", $psprintf("FINALLY NOT EXPECTED  PCIE OBSERVED"), OVM_LOW);

                          end //args end

                        
                 
                  return null;
                  end
       endcase

                 
    end

    
  endfunction :execute_posted_msgd_cb
endclass
