// ---------------------------------------------------------------------------
// Copyright(C) 2010 Intel Corporation, Confidential Information
// ---------------------------------------------------------------------------
//
// Description: Generic Bus Transaction Class - to support IOSF and iCXL
//   This class will contain any/all
//   information needed by the TB for a particular bus protocol. Most of the
//   testbench should use this class rather than depend on BFM specific 
//   transaction classes as bus protocols may change from project to project
// ---------------------------------------------------------------------------

class HqmBusTxn extends ovm_object;

    HqmBusProtocol_t  bus_type;       // Bus Type for this transaction
    
    HqmTxnPhase_t    phase = HQM_TXN_UNSUPP_PHASE;  // Transaction Phase
    HqmTxnDir_t      direction = HQM_IP_RX;  // Direction the transaction is flowing
    int              data_bus_width = 0;     // Width of the data base (structures define a 'max' data bus)

   
    time             start_time = 0;         // Start time of the transaction
    logic [63:0]     address = 0;            // Address
    HqmPcieReqType_t req_type = HQM_POSTED;  // PCIE request type
    HqmGntType_t     gnt_type = HQM_GNT_TXN; // Grant Type
    HqmFmtType_t     cmd = 0;                // fmt[1:0] + type[1:0]
    HqmTxnID_t       txn_id = 0;       // tag + reqid
    HqmPasid_t       pasidtlp = 0;     // [22]=PasidEn, [21]=Priv Mode, [20]=Exe Mode, [19:0]=PASID
    logic [3:0]      chid = 0;         // Channel ID, note: it is variable width so just creating a 'max' number
    logic [3:0]      tc = 0;           // Traffic Class
    logic [9:0]      length = 0;       // Length of the access
    HqmATEnc_t       at = HQM_AT_UNTRANSLATED; // Address Translation encoding
    logic            ro = 0;           // Relaxed Ordering
    logic            ns = 0;           // No Snoop
    logic            ep = 0;           // Error Present
    logic            th = 0;           // Transaction hint
    logic            ido = 0;          // ID based ordering
    logic            rsvd_1_7 = 0;     // Tag[9] for 10-bit tag
    logic            rsvd_1_3 = 0;     // Tag[8] for 10-bit Tag
    logic            rsvd_1_1 = 0;
    logic            rsvd_0_7 = 0;
    logic            cdata = 0;        // Request contains data (req_cdata)
    logic [7:0]      sai = 0;          // SAI
    logic [31:0]     fbe = 0;          // First Byte Enable
    logic [31:0]     lbe = 0;          // Last Byte enable
    logic            cparity = 0;      // Command Parity
    logic            cparity_err = 0;  // Command Parity Error
    logic [511:0]    data[$];          // Data Bus   
    logic [1:0]      dparity[$];       // Data Parity
    logic [1:0]      dparity_err[$];   // Indicates where there is a data parity error 
    
    logic            is_ldb;
    logic [7:0]      cq_num;

    // -----------------------------------------------------------------------
    function new(string name = "HqmBusTxn");
        super.new();
    endfunction // new
    
    // -----------------------------------------------------------------------
    function HqmCmdType_t getCmdType();
        return HqmCmdType_t'(cmd);
    endfunction
    
    // -----------------------------------------------------------------------
    function HqmPcieCplStatus_t getCplStatus();
        return HqmPcieCplStatus_t'(fbe[2:0]);
    endfunction
    
    // -----------------------------------------------------------------------
    function bit [7:0] getMsgCode();
        return {lbe[3:0], fbe[3:0]};
    endfunction
    
    // -----------------------------------------------------------------------
    function string toString();
        HqmCmdType_t cmd_type = HqmCmdType_t'(cmd);
        
        toString = $sformatf("Time=%0t  Phase=%s  Direction=%s  ReqType=%s\n", start_time, phase.name(), direction.name(), req_type.name());
        toString = {toString, $sformatf("Cmd=%s  Addr=0x%016h  TxnId(ReqId/Tag)=0x%04h/0x%03h  ChID=%0d  PasidTlp=0x%06h\n", cmd_type.name(), address, txn_id.req_id, txn_id.tag, chid, pasidtlp)};
        toString = {toString, $sformatf("Length=%0d  TC=0x%01h  AT=0x%01h  RO=%0d  NS=%0d  EP=%0d  TH=%0d  IDO=%0d\n", length, tc, at, ro, ns, ep, th, ido)};
        toString = {toString, $sformatf("SAI=0x%02h  FBE=0x%08h  LBE=0x%08h  Rsvd_1_7=%0d  Rsvd_1_3=%0d  Rsvd_1_1=%0d  Rsvd_0_7=%0d\n", sai, fbe, lbe, rsvd_1_7, rsvd_1_3, rsvd_1_1, rsvd_0_7)};
        toString = {toString, $sformatf("CParity=%0d  CParityErr=%0d\n", cparity, cparity_err)};
        foreach ( data[i] ) begin
            toString = {toString, $sformatf("DParity[%0d]=0x%01h  ParityErr[%0d]=%0d\n", i, ( i < dparity.size() ? dparity[i] : 0), i, ( i < dparity_err.size() ? dparity_err[i] : 0))};
        end 
    endfunction
    
    // -----------------------------------------------------------------------
    function void do_copy (ovm_object rhs);
        HqmBusTxn txn;
        
        if ( !$cast(txn, rhs) ) begin
            return;
        end 
        
        bus_type  = txn.bus_type;   // Bus Type for this transaction
        phase     = txn.phase;      // Transaction Phase
        direction = txn.direction;  // Direction the transaction is flowing
        data_bus_width = txn.data_bus_width;     // Width of the data base (structures define a 'max' data bus)

   
        start_time  = txn.start_time;   // Start time of the transaction
        address     = txn.address;      // Address
        req_type    = txn.req_type;     // PCIE request type
        gnt_type    = txn.gnt_type;     // Grant Type
        cmd         = txn.cmd;          // fmt[1:0] + type[1:0]
        txn_id      = txn.txn_id;       // tag + reqid
        pasidtlp    = txn.pasidtlp;     // [22]=PasidEn, [21]=Priv Mode, [20]=Exe Mode, [19:0]=PASID
        chid        = txn.chid;         // Channel ID, note: it is variable width so just creating a 'max' number
        tc          = txn.tc;           // Traffic Class
        length      = txn.length;       // Length of the access
        at          = txn.at;           // Address Translation encoding
        ro          = txn.ro;           // Relaxed Ordering
        ns          = txn.ns;           // No Snoop
        ep          = txn.ep;           // Error Present
        th          = txn.th;           // Transaction hint
        ido         = txn.ido;          // ID based ordering
        rsvd_1_7    = txn.rsvd_1_7;     // Tag[9] for 10-bit tag
        rsvd_1_3    = txn.rsvd_1_3;     // Tag[8] for 10-bit Tag
        rsvd_1_1    = txn.rsvd_1_1;
        rsvd_0_7    = txn.rsvd_0_7;
        cdata       = txn.cdata;        // Request contains data (req_cdata)
        sai         = txn.sai;          // SAI
        fbe         = txn.fbe;          // First Byte Enable
        lbe         = txn.lbe;          // Last Byte enable
        cparity     = txn.cparity;      // Command Parity
        cparity_err = txn.cparity_err;  // Command Parity Error
        data        = txn.data;         // Data Bus   
        dparity     = txn.dparity;      // Data Parity
        dparity_err = txn.dparity_err;   // Indicates where there is a parity error (dependent on 'phase' could be command or data)
        is_ldb      = txn.is_ldb;        //
        cq_num      = txn.cq_num;        //
    endfunction
    
    // -------------------------------------------------------------------------
    // Helper routine to determine first enabled byte in byte enables.
    // Note: This routine only applies to memory reads, as it uses tth which
    //       only applies to memory reads
    // -------------------------------------------------------------------------
    virtual function bit[2:0] firstEnabledByte();
        // When TTH set on mem-reads, all bytes are considered enabled
        if (th) begin
            return 0;
        end

        for (int unsigned i = 0; i <= 3; i++) begin
            if (fbe[i]) begin
                return i;
            end
        end
        return 3'h4;
    endfunction

    // -------------------------------------------------------------------------
    virtual function int unsigned getRealLength();
        return (length == 0) ? 1024 : length;
    endfunction

    // -------------------------------------------------------------------------
    virtual function bit[6:0] calcFirstLowerAddr();
        HqmCmdType_t cmd = getCmdType();
        bit [3:0] fbe;
        bit [3:0] lbe;
        bit [1:0] be;
        
        calcTrueByteEnables(.trueFBE(fbe), .trueLBE(lbe));
        
        casex (fbe)
            4'b0000: be = 2'b00;
            4'bxxx1: be = 2'b00;
            4'bxx10: be = 2'b01;
            4'bx100: be = 2'b10;
            4'b1000: be = 2'b11;
        endcase

        if (cmd inside {HQM_CAS32, HQM_CAS64, HQM_Swap32, HQM_Swap64, HQM_FAdd32, HQM_FAdd64}) begin
            return 0; // PCIe 3.1, 2.2.9, Lower Address is reserved for atomic completions
        end else begin
            return {address[6:2], be};
        end 
    endfunction
    
    // -------------------------------------------------------------------------
    virtual function bit[11:0] calcByteCount();
        HqmCmdType_t cmd = getCmdType();
        bit [3:0]    trueFBE;
        bit [3:0]    trueLBE;
        bit[11:0]    byteCount;
        int unsigned trueLen = calcTrueLength();

        calcTrueByteEnables(.trueFBE(trueFBE), .trueLBE(trueLBE));
        
        if (cmd inside {
            HQM_NPMWr32, HQM_NPMWr64,
            HQM_IOWr,    HQM_IORd,
            HQM_CfgWr0,  HQM_CfgWr1,
            HQM_CfgRd0,  HQM_CfgRd1
        }) begin
            byteCount = 4;
        end else if (cmd inside {HQM_CAS32, HQM_CAS64, HQM_Swap32, HQM_Swap64, HQM_FAdd32, HQM_FAdd64}) begin
            // Byte-enables are treated as always enabled for atomic instructions
            byteCount = trueLen * 4;
        end else begin
            casex ({trueFBE, trueLBE})
                8'b1xx1_0000: byteCount = 4;
                8'b01x1_0000: byteCount = 3;
                8'b1x10_0000: byteCount = 3;
                8'b0011_0000: byteCount = 2;
                8'b0110_0000: byteCount = 2;
                8'b1100_0000: byteCount = 2;
                8'b0001_0000: byteCount = 1;
                8'b0010_0000: byteCount = 1;
                8'b0100_0000: byteCount = 1;
                8'b1000_0000: byteCount = 1;
                8'b0000_0000: byteCount = 1;
                8'bxxx1_1xxx: byteCount =  trueLen * 4;
                8'bxxx1_01xx: byteCount = (trueLen * 4) - 1;
                8'bxxx1_001x: byteCount = (trueLen * 4) - 2;
                8'bxxx1_0001: byteCount = (trueLen * 4) - 3;
                8'bxx10_1xxx: byteCount = (trueLen * 4) - 1;
                8'bxx10_01xx: byteCount = (trueLen * 4) - 2;
                8'bxx10_001x: byteCount = (trueLen * 4) - 3;
                8'bxx10_0001: byteCount = (trueLen * 4) - 4;
                8'bx100_1xxx: byteCount = (trueLen * 4) - 2;
                8'bx100_01xx: byteCount = (trueLen * 4) - 3;
                8'bx100_001x: byteCount = (trueLen * 4) - 4;
                8'bx100_0001: byteCount = (trueLen * 4) - 5;
                8'b1000_1xxx: byteCount = (trueLen * 4) - 3;
                8'b1000_01xx: byteCount = (trueLen * 4) - 4;
                8'b1000_001x: byteCount = (trueLen * 4) - 5;
                8'b1000_0001: byteCount = (trueLen * 4) - 6;
            endcase
        end

        return byteCount;
    endfunction
    
    // -------------------------------------------------------------------------
    virtual function int unsigned calcTrueLength();
        HqmCmdType_t cmd = getCmdType();
        int unsigned truelen;

        if (cmd inside {
            HQM_IOWr,   HQM_IORd,
            HQM_CfgWr0, HQM_CfgWr1,
            HQM_CfgRd0, HQM_CfgRd1
        }) begin
            truelen = 1;
        end else if (cmd inside {HQM_CAS32, HQM_CAS64}) begin
            truelen = getRealLength() >> 1;
        end else begin
            truelen = getRealLength();
        end

        return truelen;
    endfunction
    
    // Cloned functions from above (used for completion tracking)
    virtual function void calcTrueByteEnables(ref bit[3:0] trueFBE, ref bit[3:0] trueLBE);
        HqmCmdType_t cmd = getCmdType();
        
        // Atomics always treat all bytes as enabled.
        // When TH is set all bytes are enabled.
        // TODO: Does TTH work the same for NPMWr?
        if ((th == 1 && (cmd inside {HQM_MRd32, HQM_MRd64, HQM_MRdLk32, HQM_MRdLk64, HQM_NPMWr32, HQM_NPMWr64})) ||
            (cmd inside {HQM_CAS32, HQM_CAS64, HQM_Swap32, HQM_Swap64, HQM_FAdd32, HQM_FAdd64})) begin
            // Byte Enables are always all enabled for Memory Read when TH=1
            // expect for 1 dword case where LBE is implicitly disabled
            trueFBE = 4'b1111;
            if (calcTrueLength() == 1) begin
                trueLBE = 4'b0000;
            end else begin
                trueLBE = 4'b1111;
            end
        end else begin
            trueFBE = fbe;
            trueLBE = lbe;
        end

    endfunction
    
    `ovm_object_utils(HqmBusTxn);
      
endclass 
