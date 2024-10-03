// -----------------------------------------------------------------------------
// Copyright(C) 2017 - 2019 Intel Corporation, All Rights Reserved
// -----------------------------------------------------------------------------
//
// Description: Event container object for handling handshakes for 
//  ATS, PRS, and Invalidation related packets
//
// -----------------------------------------------------------------------------

class HqmAtsEventContainerObj extends uvm_object;

    // Ats Request and Completion
    protected HqmAtsReqRsp_t _atsReq;
    protected HqmAtsReqRsp_t _atsCpl;
    
    // Invalidation Request and Completion
    protected HqmAtsInvReqRsp_t _invReq;
    protected HqmAtsInvReqRsp_t _invRsp;
    
    // Page Request Group Response
    protected HqmPrgRsp_t    _pageGrpReqRsp;
    protected HqmPrsReq_t    _pageReq;
   
    // -------------------------------------------------------------------------
    function new (string name="HqmAtsEventContainerObj");
        super.new(name);
    endfunction

    // ---------------------------------------------------------------------------
    function void setAtsReq(HqmAtsReqRsp_t atsReq);
        _atsReq = atsReq;
    endfunction
    
    // ---------------------------------------------------------------------------
    function void setAtsCpl(HqmAtsReqRsp_t atsCpl);
        _atsCpl = atsCpl;
    endfunction
    
    // ---------------------------------------------------------------------------
    function void setInvReq(HqmAtsInvReqRsp_t invReq);
        _invReq = invReq;
    endfunction
    
    // ---------------------------------------------------------------------------
    function void setInvRsp(HqmAtsInvReqRsp_t invRsp);
        _invRsp = invRsp;
    endfunction
    
    // ---------------------------------------------------------------------------
    function void setPageGrpReqRsp(HqmPrgRsp_t pageGrpReqRsp);
        _pageGrpReqRsp = pageGrpReqRsp;
    endfunction
    
    // ---------------------------------------------------------------------------
    function void setPageReq(HqmPrsReq_t pageReq);
        _pageReq = pageReq;
    endfunction
    
    // ---------------------------------------------------------------------------
    function HqmAtsReqRsp_t getAtsReq();
        return _atsReq;
    endfunction
    
    // ---------------------------------------------------------------------------
    function HqmAtsReqRsp_t getAtsCpl();
        return _atsCpl;
    endfunction
    
    // ---------------------------------------------------------------------------
    function HqmAtsInvReqRsp_t getInvReq();
        return _invReq;
    endfunction
    
    // ---------------------------------------------------------------------------
    function HqmAtsInvReqRsp_t getInvRsp();
        return _invRsp;
    endfunction
    
    // ---------------------------------------------------------------------------
    function HqmPrgRsp_t getPageGrpReqRsp();
        return _pageGrpReqRsp;
    endfunction
    
    // ---------------------------------------------------------------------------
    function HqmPrsReq_t getPageReq();
        return _pageReq;
    endfunction
    
    
    `uvm_object_utils(HqmAtsEventContainerObj);
    
endclass 
