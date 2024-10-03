class hqm_iosf_mrd_cb extends IosfBaseCallBack;
  bit [63:0]    block_addr_min;
  bit [63:0]    block_addr_max;

  function new();
    string      addr_string;
    longint     addr_val;

    super.new();

    block_addr_min = '0;
    block_addr_max = '0;

    addr_string = "";

    $value$plusargs("HQM_TB_IOSF_BLOCK_ADDR_MIN=%s",addr_string);

    if (addr_string != "") begin
      if (lvm_common_pkg::token_to_longint(addr_string,addr_val) == 0) begin
        `ovm_error("HQM_IOSF_SB_CB",$psprintf("+HQM_TB_IOSF_BLOCK_ADDR_MIN=%s not a valid integer value",addr_string))
        return;
      end

      block_addr_min = addr_val;
    end

    addr_string = "";

    $value$plusargs("HQM_TB_IOSF_BLOCK_ADDR_MAX=%s",addr_string);

    if (addr_string != "") begin
      if (lvm_common_pkg::token_to_longint(addr_string,addr_val) == 0) begin
        `ovm_error("HQM_IOSF_SB_CB",$psprintf("+HQM_TB_IOSF_BLOCK_ADDR_MAX=%s not a valid integer value",addr_string))
        return;
      end

      block_addr_max = addr_val;
    end
  endfunction :new
  
 `ifdef HQM_IOSF_2019_BFM
  function void execute(IosfAgtSlvTlm slvHandle,IosfTgtTxn tgtTxn);
 `else
  function void execute(IosfAgtTgtTlm slvHandle,IosfTgtTxn tgtTxn);
 `endif
    if ((tgtTxn.address >= block_addr_min) && (tgtTxn.address <= block_addr_max) && (block_addr_max != 0)) begin
      `ovm_info("HQM_IOSF_MRD_CB",$psprintf("Not sending completion for MRD of address 0x%0x",tgtTxn.address),OVM_LOW)
    end else begin
      `ovm_info("HQM_IOSF_MRD_CB",$psprintf("sending completion for MRD of address 0x%0x",tgtTxn.address),OVM_LOW)
      slvHandle.sendCplD();
    end
  endfunction : execute

endclass
