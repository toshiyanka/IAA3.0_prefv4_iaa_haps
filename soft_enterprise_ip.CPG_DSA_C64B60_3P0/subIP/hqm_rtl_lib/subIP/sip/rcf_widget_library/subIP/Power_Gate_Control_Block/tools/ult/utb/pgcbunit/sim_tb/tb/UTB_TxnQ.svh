
`define UTB_TXNQ(inst_name, struct_t, clk, rst_b) \
    int   InsertId_``inst_name = 0;\
    logic valid_``inst_name = 1'b0; \
    logic validnext_``inst_name = 1'b0; \
    logic done_``inst_name; \
    logic donenext_``inst_name; \
    int   txnID_``inst_name; \
    int   txnIDnext_``inst_name; \
    int   txnIDQ_``inst_name[$]; \
    int   validdly_``inst_name[$]; \
    ``struct_t next_txn_``inst_name = ``struct_t``'(-1); \
    ``struct_t curr_txn_``inst_name = ``struct_t``'(-1); \
\
    ``struct_t txnQ_``inst_name``[$]; \
    ``struct_t RsptxnQ_``inst_name``[int]; \
\
function int ``inst_name``_ScheduleUTBTxn(``struct_t txn, valid_assert_delay = 0);\
   txnQ_``inst_name``.push_back(``txn); \
   InsertId_``inst_name = InsertId_``inst_name + 1; \
   txnIDQ_``inst_name``.push_back(InsertId_``inst_name); \
   validdly_``inst_name``.push_back(valid_assert_delay); \
   return InsertId_``inst_name; \
endfunction: ``inst_name``_ScheduleUTBTxn \
\
function void ``inst_name``_RspUTBTxn(int txnid, ``struct_t txn);\
   RsptxnQ_``inst_name``[txnid] = txn; \
   $display("%m Response transaction with ID : %5d is ready", txnid); \
endfunction: ``inst_name``_RspUTBTxn \
\
function ``struct_t ``inst_name``_GetUTBTxn();\
    return txnQ_``inst_name``.size() != 0 ? txnQ_``inst_name``[0] : ``struct_t``'(-1); \
endfunction : ``inst_name``_GetUTBTxn \
\
function ``struct_t ``inst_name``_GetUTBRspTxn(int txnid, bit remove = 1'b1);\
    ``struct_t ret_txn; \
    int ind; \
`ifdef RSPTXNQ_DEBUG \
    $display("Looking for RSP for REQ with txnID:%d", txnid); \
    if ( RsptxnQ_``inst_name``.num() > 0 ) begin \
        $display("Responses for the following txnIDs exist, returning the found one:"); \
        if (RsptxnQ_``inst_name``.first(ind) ) \
        do \
            $display("%d ", ind); \
        while ( RsptxnQ_``inst_name``.next(ind) ); \
    end \
    else begin \
        $display("There is no response available at this time"); \
    end \
`endif \
    if ( RsptxnQ_``inst_name``.exists(txnid) ) begin \
        ret_txn = RsptxnQ_``inst_name``[txnid]; \
        if ( remove == 1'b1 ) RsptxnQ_``inst_name``.delete(txnid); \
    end \
    else begin \
        ret_txn = ``struct_t``'(-1); \
    end \
    return ret_txn; \
endfunction : ``inst_name``_GetUTBRspTxn \
\
always @(posedge ``clk or negedge ``rst_b) begin \
    bit done, donenext; \
    if ( ``rst_b == 1'b0 ) begin \
        valid_``inst_name <= 1'b0; \
        validnext_``inst_name <= 1'b0; \
        curr_txn_``inst_name <= ``struct_t``'(-1); \
        next_txn_``inst_name <= ``struct_t``'(-1); \
    end  \
    else begin \
        done = done_``inst_name; \
        donenext = donenext_``inst_name; \
        case ( { done, donenext } ) \
        2'b11 : begin \
                if ( txnQ_``inst_name``.size() > 0 ) begin \
                    txnQ_``inst_name``.pop_front(); \
                    txnIDQ_``inst_name``.pop_front(); \
                    validdly_``inst_name.pop_front(); \
                end \
                if ( txnQ_``inst_name``.size() > 0 ) begin \
                    txnQ_``inst_name``.pop_front(); \
                    txnIDQ_``inst_name``.pop_front(); \
                    validdly_``inst_name.pop_front(); \
                end \
                end \
        2'b10 : begin \
                if ( txnQ_``inst_name``.size() > 0 ) begin \
                    txnQ_``inst_name``.pop_front(); \
                    txnIDQ_``inst_name``.pop_front(); \
                    validdly_``inst_name.pop_front(); \
                end \
                end \
        2'b01 : begin \
                if ( txnQ_``inst_name``.size() > 1 ) begin \
                    txnQ_``inst_name``.delete(1); \
                    txnIDQ_``inst_name``.delete(1); \
                    validdly_``inst_name.delete(1); \
                end \
                end \
        endcase \
        valid_``inst_name <= (txnQ_``inst_name``.size() !=0) ? (validdly_``inst_name[0] == 0) : 1'b0; \
        validnext_``inst_name <= (txnQ_``inst_name``.size() >1) ? 1'b1 : 1'b0; \
        if (txnQ_``inst_name``.size() !=0) validdly_``inst_name``[0] <= validdly_``inst_name``[0] - (validdly_``inst_name``[0]>0); \
        curr_txn_``inst_name <= txnQ_``inst_name``.size() !=0 ? txnQ_``inst_name``[0] : ``struct_t``'(-1); \
        txnID_``inst_name <= txnQ_``inst_name``.size() != 0 ? txnIDQ_``inst_name``[0] : 0; \
        next_txn_``inst_name <= txnQ_``inst_name``.size() > 1 ? txnQ_``inst_name``[1] : ``struct_t``'(-1); \
        txnIDnext_``inst_name <= txnQ_``inst_name``.size() > 1 ? txnIDQ_``inst_name``[1] : 0; \
    end \
end \

`define UTB_MEM(mem_name, ADDR_WIDTH=64, DATA_WIDTH=32) \
logic[DATA_WIDTH-1:0] ``mem_name``[logic[ADDR_WIDTH-1:0]]; \
\
function void Write_``mem_name``(logic[ADDR_WIDTH-1:0] addr, logic[DATA_WIDTH-1:0] data, logic[(DATA_WIDTH>>3)-1:0] be, logic[ADDR_WIDTH-1:0] data_phase); \
    logic[DATA_WIDTH-1:0] curr_val; \
    logic[DATA_WIDTH-1:0] mask, mask_in; \
    logic[ADDR_WIDTH-1:0] addr_offset; \
 \
    addr_offset = data_phase * (DATA_WIDTH>>3);\
 \
    if ( !$isunknown(addr + addr_offset) ) begin \
        if ( ``mem_name``.exists(addr + addr_offset) ) begin \
            curr_val = ``mem_name``[addr + addr_offset]; \
            foreach(be[i]) mask[i*8 +: 8] = {8{~be[i]}}; \
            foreach(be[i]) mask_in[i*8 +: 8] = {8{be[i]}}; \
        end \
        else begin \
            curr_val = '0; \
            foreach (mask[i]) mask[i] = 1'b0; \
            foreach (mask_in[i]) mask_in[i*8 +: 8] = {8{be[i]}}; \
        end \
        ``mem_name``[addr + addr_offset] = (curr_val & mask) | (data & mask_in); \
        `ifdef UTB_MEM_DEBUG_ON \
            $display("%m\n%10.1t : Addr = %x Be = %x inData = %x curData = %x data=%x mask=%b", $time, addr+addr_offset, be, data, curr_val, ``mem_name``[addr + addr_offset], mask_in); \
        `endif \
    end \
    else begin \
        `ASSERT_EQ(0, $psprintf("Address is illegal : %x offset: %x be:%b", addr, data_phase, be), MemWrAddrX); \
    end \
endfunction : Write_``mem_name`` \
 \
function logic[DATA_WIDTH-1:0] Read_``mem_name``(logic[ADDR_WIDTH-1:0] addr, logic[ADDR_WIDTH-1:0] data_phase); \
    logic[DATA_WIDTH-1:0] curr_val; \
    logic[ADDR_WIDTH-1:0] addr_offset; \
\
    addr_offset = data_phase * (DATA_WIDTH>>3);\
\
    if ( !$isunknown(addr + addr_offset) ) begin \
        if ( ``mem_name``.exists(addr + addr_offset) ) begin \
            curr_val = ``mem_name``[addr + addr_offset]; \
        end \
        else begin \
            curr_val = $random; \
        end \
        `ifdef UTB_MEM_DEBUG_ON \
            $display("%m\n%10.1t : Addr = %x Data = %x", $time, addr+addr_offset, curr_val); \
        `endif \
    end \
    else begin \
         curr_val = 'x; \
        `ASSERT_EQ(0, $psprintf("Address is illegal : %x offset: %x", addr, data_phase), MemRdAddrX); \
    end \
    return curr_val; \
endfunction : Read_``mem_name``

