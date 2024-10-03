// lintra -50514 " copyright statement violation"
//====================================================================================================================
//
// genram_bees_knees.sv
//
// Contacts            : Eric Finley, Shruti Sethi, Vinay Chippa
// Original Author(s)  : Eric Finley
// Original Date       : 11/2016
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================
// lintra +50514 " copyright statement violation"


`include "hqm_devtlb_genram_macros.vh"


// lintra -60037 " Parameter names should be upper case"
// lintra -0527  " unused inputs"
module hqm_devtlb_genram_bees_knees
#(
    parameter           width            = 32,
    parameter           depth            = 32,
    parameter           num_rd_ports     = 1,
    parameter           num_wr_ports     = 1,        //Any number of  wr and rd ports supported
    parameter		    one_hot_rd_ptrs  = 0,
    parameter		    one_hot_wr_ptrs  = 0,        //This is actually N_hot -for write side
    parameter           noflopin_opt     = 0,
    parameter           fifo_opt         = 0,      
    parameter           cam_width0       = 0,        //leave width = 0 if you don't want a cam port
    parameter	        cam_width1       = 0,
    parameter 	        cam_low_bit0     = 0,
    parameter	        cam_low_bit1     = 0,
    parameter           num_rd_ptr_split = 1,        //This is same as num of Rd muxes 
    parameter           svdump_en        = 0,
    parameter           MCP              = 1,
    parameter           clkname_wr       = "c2xclk",
    parameter           use_storage_data = 0, 
    parameter           flop_latch_based = 0,        //Put $fatal error on noflopin or fifo_opt set with this param
    parameter           xbuf_type        = 0,
    parameter           clkname_rd       = "c2xclk",
    parameter           psep             = 1,   
    parameter           fifo_or_ram      = 0, 
    parameter           async_reset_enable=0,
    parameter 		    ram_version      = 2,		//NEVER EDIT! This is the version tracking for backend to know that bees_knees file changed
    

    // All parameters above this line must be specified in this order for RP
    parameter type      T                           = logic[width-1:0],
    parameter           my_num_rd_ports             = (num_rd_ports > 0) ? num_rd_ports : 1,
    parameter           elements_per_MUX            = (depth/num_rd_ptr_split),
    parameter           clogb2_elements_per_MUX     = genram_clogb2(elements_per_MUX),
    parameter           rd_ptr_width                = one_hot_rd_ptrs ? elements_per_MUX : clogb2_elements_per_MUX,
    parameter           clogb2_depth                = genram_clogb2(depth),
    parameter           wr_ptr_width                = one_hot_wr_ptrs ? depth : clogb2_depth,
    parameter           mycam_width0                = (cam_width0 > 0) ? cam_width0 : 1,
    parameter           mycam_width1                = (cam_width1 > 0) ? cam_width1 : 1,
    parameter           storage_data_width          = (fifo_opt & ~flop_latch_based) ? (depth+1) : depth

)

(
    input  logic                                    gramclk,
    input  logic                                    reset_b,
    input  logic                                    async_reset_b,
    input  logic                                    dt_latchopen,
    input  logic                                    dt_latchclosed_b,

    //Inputs
    input  logic                                    wren1[num_wr_ports-1:0],        //Wren to the latch array
    input  logic                                    wren2[num_wr_ports-1:0],        //Wren to the input flop stage
    input  logic [wr_ptr_width-1:0]                 wraddr[num_wr_ports-1:0],
    input  T                                        wrdata[num_wr_ports-1:0],
    input  logic [rd_ptr_width-1:0]                 rdaddr[my_num_rd_ports-1:0],
    input  logic [mycam_width0-1:0]                 cam_data0,
    input  logic [mycam_width1-1:0]                 cam_data1,

    //Outputs
    output T                                        datain_q[num_wr_ports-1:0],     //remove later if UOs arn't using
    output T                                        rddataout[my_num_rd_ports-1:0],
    output logic [storage_data_width-1:0]           cam_hit0,
    output logic [storage_data_width-1:0]           cam_hit1,
    output logic [storage_data_width*$bits(T)-1:0]  storage_data,
    output logic [$bits(T)-1:0]                     storage_dataMDA [storage_data_width-1:0]
);
// lintra +60037 " Parameter names should be upper case"
// lintra +0527  " unused inputs"


    //-------------------------- Signals for latch en calculation ------------------------//
    logic [depth-1:0]                               wsel[num_wr_ports-1:0];
    logic [num_wr_ports-1:0]                        wsel_T[depth-1:0];
    logic [depth-1:0]                               wsel_final;
    logic [depth-1:0]                               wsel_final_masked;
    logic [depth-1:0]                               wsel_dec[num_wr_ports-1:0];
    logic[depth-1:0]                                wsel_clk;
    logic [wr_ptr_width-1:0]                        wraddr_lat[num_wr_ports-1:0];
    logic [wr_ptr_width-1:0]                        wraddr_dft[num_wr_ports-1:0];
    logic		                                    wren1_lat[num_wr_ports-1:0];
    logic                                           wren1_lat_masked_emul[num_wr_ports-1:0];   
    logic [num_wr_ports-1:0]                        wren2_flat; 

    //---------------------------- Signals for wrdata selection --------------------------//
    T                                               wrdata_in[num_wr_ports-1:0];
    T                                               wrdata_f[num_wr_ports-1:0];
    T                                               wrdata_selected[num_wr_ports-1:0];
    T             				    				wrdata_selected_masked_pre[depth-1:0];
    T             				    				wrdata_selected_masked[depth-1:0];
    T                                               wrdata_sent_to_store[depth-1:0];
    T                                               lat_data[depth-1:0];
    T                                               latched_data[depth-1:0];


    //---------------------------------- Signals for rd output ---------------------------//
    logic [rd_ptr_width-1:0]                        rdaddr_final[my_num_rd_ports-1:0];
    logic [rd_ptr_width-1:0]                        wrdata_f_pad;
    T                                               mux_out[my_num_rd_ports-1:0];
    logic [elements_per_MUX-1:0][$bits(T)-1:0]      data_per_mux[num_rd_ptr_split-1:0];




//---------------------------------------- Assertions -------------------------------------------//
`ifndef INTEL_SVA_OFF
logic scan_dump_input_flop;
logic num_wr_ports_2_fifo_opt;
logic num_rd_ptr_split_fifo_opt;
logic wraddr_conflict;

always_comb scan_dump_input_flop = ((noflopin_opt == 1) || (num_rd_ports == 0)) && svdump_en ;
always_comb num_wr_ports_2_fifo_opt = (num_wr_ports > 1) & fifo_opt & ~flop_latch_based;
always_comb num_rd_ptr_split_fifo_opt = (num_rd_ptr_split > 1) & fifo_opt & ~flop_latch_based;
logic [num_wr_ports-1:0][num_wr_ports-1:0] wraddr_matches;
always_comb begin
  wraddr_matches = '0;
  for (int i = 0; i < num_wr_ports; i++) begin
    for (int j = i + 1; j < num_wr_ports; j++) begin                        //lintra s-0209 "Statements in loop will never execute"
      wraddr_matches[i][j] = wren2[i] & wren2[j] & (wraddr[i] == wraddr[j]) & ~(one_hot_wr_ptrs & ((wraddr[i] == 'h0) | (wraddr[j] == 'h0)) );   //lintra s-2050 "Reduction operation on a single-bit signal '{wraddr_matches}'"
    end
  end
end
always_comb wraddr_conflict = {|{wraddr_matches}};                          //lintra s-2050 "Reduction operation on a single-bit signal '{wraddr_matches}'"


scan_dump_input_flop_chk: `HQM_DEVTLB_GENRAM_ASSERT_NEVER (scan_dump_input_flop, gramclk, (~reset_b| $isunknown(reset_b))) else $error ("Aub_ware: Cannot set svdump_en to 1 if noflopin_opt is 1 or num_rd_ports is 0.  Setting svdump_en to 0");
//num_wr_ports_2_chk: `ASSERT_NEVER (num_wr_ports_2, gramclk, (~reset_b| $isunknown(reset_b))) else $error ("Aub_ware: num_wr_ports > 2 is not supported");
num_wr_ports_2_fifo_opt_chk: `HQM_DEVTLB_GENRAM_ASSERT_NEVER (num_wr_ports_2_fifo_opt, gramclk, (~reset_b| $isunknown(reset_b))) else $error ("Aub_ware: num_wr_ports of 2 or more is not supported when fifo_opt is on");
num_rd_ptr_split_fifo_opt_chk: `HQM_DEVTLB_GENRAM_ASSERT_NEVER (num_rd_ptr_split_fifo_opt, gramclk, (~reset_b| $isunknown(reset_b))) else $error ("Aub_ware: fifo_opt cannot be set when num_rd_ptr_split > 1");
wraddr_conflict_chk: `HQM_DEVTLB_GENRAM_ASSERT_NEVER (wraddr_conflict, gramclk, (~reset_b| $isunknown(reset_b))) else $error ("Aub_ware: more than 1 wr ptrs writing to same entry in RAM/FIFO");

//generate
//genvar i;
//for(i = 0; i < my_num_rd_ports; i++) begin : rdaddr_one_hot_assert
//    rdaddr_one_hot_chk: `ASSERT_AT_MOST_BITS_HIGH (rdaddr[i], 1, (~reset_b| $isunknown(reset_b | $isunknown(rdaddr[i])))) else $error ("Aub_ware: If one_hot_rd_ptrs is set, rdaddr should really be one_hot");
//end
//endgenerate
`endif


// ---------------------------------------- SCAN data -------------------------------------------//
//used for dfx - To enable, a 1 will be scanned into the below flop. This will drive the opt flop with the value thats in the latch.
//This value can then be scanned out.
generate
genvar bn, bn1;
    if ((svdump_en == 0) || (noflopin_opt == 1)) begin :if_no_svdump
		`HQM_DEVTLB_GENRAM_TIEOFF(wrdata_f_pad)
        always_comb wrdata_in = wrdata;
    end
    else begin : else_no_svdump
		//[Shruti]: scan_flop_out replaced by ~dt_latchclosed_b
        always_comb wrdata_in[0] = (~dt_latchclosed_b) ? rddataout[0] : wrdata[0];

        for (bn = 1; bn < num_wr_ports; bn++) begin : wrdata_no_svdump_loop
            always_comb wrdata_in[bn] = wrdata[bn];                                     //lintra s-0209 "loop will never execute if wrports less than 1"
        end

        if ((flop_latch_based == 0) & (one_hot_rd_ptrs == 0) & ($bits(T) < rd_ptr_width)) begin : if_pad_pre_flops
            for (bn1 = $bits(T); bn1 < rd_ptr_width; bn1++) begin : scan_wrdata_pad_loop
                `HQM_DEVTLB_GENRAM_MSFF(wrdata_f_pad[bn1], 1'b0, gramclk)                           
            end
            always_comb wrdata_f_pad[$bits(T)-1 : 0] =  wrdata_f[0][$bits(T)-1 : 0];
        end 
        else if ((flop_latch_based == 0) & (one_hot_rd_ptrs == 0) & ($bits(T) >= rd_ptr_width)) begin : else_pad_pre_flops
            always_comb wrdata_f_pad[rd_ptr_width-1 : 0] =  wrdata_f[0][rd_ptr_width-1 : 0];
        end
    end
endgenerate



// ----------------------------------- Latch based storage ---------------------------------------//

generate
if (flop_latch_based == 0) begin : if_latch_based1
// -------------------------------- Data to be written to RAM ------------------------------------//
genvar bp;
    if (noflopin_opt == 0) begin : if_preflop_stage
        for (bp = 0; bp < num_wr_ports; bp++) begin : wrdata_flopin_loop
            `HQM_DEVTLB_GENRAM_EN_MSFF(wrdata_f[bp], wrdata_in[bp], gramclk, wren2[bp])
     	end
     always_comb wrdata_selected = wrdata_f;
     always_comb datain_q = wrdata_f;          
    end
    else begin : else_preflop_stage
        always_comb wrdata_selected = wrdata_in;  
		`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_f, num_wr_ports)
		`HQM_DEVTLB_GENRAM_MDA_TIEOFF(datain_q, num_wr_ports)
    end 
end    
else begin : else_latch_based1
    always_comb wrdata_selected = wrdata_in;        
end 
endgenerate



`ifndef INTEL_EMULATION
//---------------------------------------- latch enables -----------------------------------------//
//[SS] TODO: Add entire matrix example to show how this wraddr decode works
generate
genvar bq;
	`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wren1_lat_masked_emul, num_wr_ports)
    if (one_hot_wr_ptrs == 1) begin : if_one_hot_wr_ptrs1
        if (flop_latch_based == 0) begin : if_latch_based2
            always_comb wsel_dec = wraddr_lat;
        end 
        else begin : else_latch_based2
            always_comb wsel_dec = wraddr;
        end            
    end 
    else begin : else_one_hot_wr_ptrs1
        if (flop_latch_based == 0) begin : if_latch_based3
            for (bq = 0; bq < num_wr_ports; bq++) begin : no_one_hot_wr_loop1 
                always_comb wsel_dec[bq] = (1'b1 << wraddr_lat[bq]);            //lintra s-2056 "expression bit length is smaller than the bit length of the context " 
            end
        end
        else begin : else_latch_based3
            for (bq = 0; bq < num_wr_ports; bq++) begin : no_one_hot_wr_loop2
                always_comb wsel_dec[bq] = (1'b1 << wraddr[bq]);                //lintra s-2056 "expression bit length is smaller than the bit length of the context "
            end
        end
    end
endgenerate


//To Avoid writing at any addr when write = 0;
generate
genvar br;
    if (flop_latch_based == 0) begin : if_latch_based4   
        for (br = 0; br < num_wr_ports; br++) begin : wsel_loop
	        always_comb wraddr_dft[br] = wraddr[br] & {wr_ptr_width{dt_latchclosed_b}};
            `HQM_DEVTLB_GENRAM_LATCH_P(wraddr_lat[br], wraddr_dft[br], gramclk)
            `HQM_DEVTLB_GENRAM_LATCH_P(wren1_lat[br], wren1[br], gramclk)
            always_comb wsel[br] = {depth{wren1_lat[br]}} & wsel_dec[br];
        end
    end
    else begin : else_latch_based4
        for (br = 0; br < num_wr_ports; br++) begin : wsel_loop
            always_comb wsel[br] = {depth{wren2[br]}} & wsel_dec[br];
        end
    end
endgenerate


generate
genvar bs, bt;
    for (bs = 0; bs < num_wr_ports; bs++) begin : wsel_T_loop1
        for (bt = 0; bt < depth; bt++) begin : wsel_T_loop2
            always_comb wsel_T[bt][bs] = wsel[bs][bt];
        end
    end
endgenerate

generate
genvar bu;
    if (num_wr_ports == 1) begin : if_single_wr_port
        always_comb wsel_final = wsel[0];
    end
    else begin : else_single_wr_port
        for (bu = 0; bu < depth; bu++) begin : wsel_final_loop
            always_comb wsel_final[bu] = (|(wsel_T[bu]));
        end
    end
endgenerate


// 1 AND gate to the bit 0 for DFT close logic
generate
genvar bw, bm;
    if (flop_latch_based == 0) begin : if_latch_based5
        always_comb wsel_final_masked[0] = dt_latchopen | (dt_latchclosed_b & wsel_final[0]);
        for (bw = 1; bw < depth; bw++) begin : wsel_final_masked_loop              //lintra s-0209 "loop will never execute if wrports less than 1"
            always_comb wsel_final_masked[bw] = dt_latchopen | wsel_final[bw];
        end
        for (bm = 0; bm < depth; bm++) begin : wsel_clk_loop
            ctech_lib_clk_and_en gcl_clk_gate_and1(.clk(gramclk), .en(wsel_final_masked[bm]), .clkout(wsel_clk[bm]));            
        end        
    end
endgenerate



//--------------------------------- Writing to the Storage Latches ----------------------------//
generate
genvar bx, by, bz, bx1, by1, bz1, bx2, by2, bz2, by3;
    if (num_wr_ports == 1) begin : if_single_wr_port2
        for (bx = 0; bx < depth; bx++) begin : wrport_1_wrdata_loop 
            always_comb wrdata_sent_to_store[bx] = wrdata_selected[0];
        end
        `HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_selected_masked, depth)
		`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_selected_masked_pre, depth)
        `HQM_DEVTLB_GENRAM_TIEOFF(wren2_flat)
    end 
    else begin : else_single_wr_port2
        if (flop_latch_based == 1) begin : if_flop_based6
        	for (by = 0; by < depth; by++) begin : wrport_2_wrdata_loop
			always_comb begin
				wrdata_selected_masked[by] = '0;
				for (int bx2 = 0; bx2 < num_wr_ports; bx2++) begin: wrport_3_wrdata_loop
					wrdata_selected_masked[by] |= ( wrdata_selected[bx2] & {width{wsel_T[by][bx2]}} );
				end
			end
			always_comb wrdata_sent_to_store[by] = wrdata_selected_masked[by] ;
			end
			`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_selected_masked_pre, depth)
		    `HQM_DEVTLB_GENRAM_TIEOFF(wren2_flat)
		end 
		else begin : else_flop_based6
			//The col for last wr port is not flopped so that number of flops are reduced and 2 wr port RAMs dont see an 
			//increase in gates compared to old bees_knees implementation
        	logic [num_wr_ports-2:0]     wsel_T_F[depth-1:0];
		
        	for (bz1 = 0; bz1 < num_wr_ports; bz1++) begin : wrport_4_wrdata_loop		//Converting to packed array
				always_comb wren2_flat[bz1] = wren2[bz1] ;
			end
	
        	for (by1 = 0; by1 < depth; by1++) begin : wrport_5_wrdata_loop
        		for (by2 = 0; by2 < (num_wr_ports-1); by2++) begin : wrport_6_wrdata_loop
                		`HQM_DEVTLB_GENRAM_EN_MSFF(wsel_T_F[by1][by2], wsel_T[by1][by2], gramclk, (|(wren2_flat)) ) 
				end
			end 
        	for (by3 = 0; by3 < depth; by3++) begin : wrport_7_wrdata_loop
				always_comb begin
					wrdata_selected_masked_pre[by3] = '0;
					for (int bx2 = 0; bx2 < (num_wr_ports-1); bx2++) begin: wrport_8_wrdata_loop
						wrdata_selected_masked_pre[by3] |= ( wrdata_selected[bx2] & {width{wsel_T_F[by3][bx2]}} );
					end
				end
			always_comb wrdata_selected_masked[by3] = wrdata_selected_masked_pre[by3] | ( wrdata_selected[num_wr_ports-1] & {width{wsel_T[by3][num_wr_ports-1]}} );
            always_comb wrdata_sent_to_store[by3] = dt_latchopen ? wrdata_selected[0] : wrdata_selected_masked[by3] ;
			end
        end 
    end 


    if(flop_latch_based == 0) begin : if_latch_based6
        for (bz=0; bz<depth; bz++) begin : latches_loop
            if (async_reset_enable == 1) begin : if_async_reset1
                `HQM_DEVTLB_GENRAM_ASYNC_RSTB_LATCH(latched_data[bz], wrdata_sent_to_store[bz], wsel_clk[bz], async_reset_b)
            end
            else begin : else_async_reset1
                `HQM_DEVTLB_GENRAM_LATCH(latched_data[bz], wrdata_sent_to_store[bz], wsel_clk[bz])
            end
        end
    end
    else begin : else_latch_based6
        for (bz=0; bz<depth; bz++) begin : flops_loop
            if (async_reset_enable == 1) begin : if_async_reset2
                `HQM_DEVTLB_GENRAM_EN_ASYNC_RSTB_MSFF(latched_data[bz], wrdata_sent_to_store[bz], gramclk, wsel_final[bz], async_reset_b)
            end
            else begin : else_async_reset2
                `HQM_DEVTLB_GENRAM_EN_MSFF(latched_data[bz], wrdata_sent_to_store[bz], gramclk, wsel_final[bz])
            end
        end
    end
endgenerate



`else
//------------------------------ Emulation writes to store - map to RAM -------------------------//
generate
genvar er, ei, ej, ep, eq, et, en, em, ez, ey, el;
    if(flop_latch_based == 0) begin : if_latch_based7
        for (er = 0; er < num_wr_ports; er++) begin : wsel_emul_loop1
            `HQM_DEVTLB_GENRAM_LATCH_P(wraddr_lat[er], wraddr[er], gramclk)
            `HQM_DEVTLB_GENRAM_LATCH_P(wren1_lat[er], wren1[er], gramclk)
            always_comb wren1_lat_masked_emul[er] = wren1_lat[er] & {wr_ptr_width{gramclk}} ;
        end

        always_comb begin
            for(int ei =0; ei<num_wr_ports; ei++) begin : wsel_emul_loop2
                if (wren1_lat_masked_emul[ei] == 1'b1) begin : if_masked_bit_1
                    if (one_hot_wr_ptrs == 1) begin : if_one_hot_wr_ptrs2
                        for (int ej =0; ej<wr_ptr_width; ej++) begin : wsel_emul_loop3
                            if(wraddr_lat[ei][ej] == 1'b1) begin : if_addr_lat_1
                                lat_data[ej] = (wren1_lat_masked_emul[0] & wraddr_lat[0][ej]) ? wrdata_selected[0] : wrdata_selected[ei];
                            end
                        end
                    end
                    else begin : else_one_hot_wr_ptrs2
                        lat_data[wraddr_lat[ei]] = ( wren1_lat_masked_emul[0] & (wraddr_lat[0] == wraddr_lat[ei]) ) ? wrdata_selected[0] : wrdata_selected[ei];
                    end
                end
            end
        end
    end
    else begin : else_latch_based7
        `HQM_DEVTLB_GENRAM_MDA_TIEOFF(wren1_lat_masked_emul, num_wr_ports)
        if (one_hot_wr_ptrs == 1) begin : if_one_hot_wr_ptrs3
            always_comb wsel_dec = wraddr;
        end
        else begin : else_one_hot_wr_ptrs3
            for (ep = 0; ep < num_wr_ports; ep++) begin : wsel_emul_loop4
                always_comb wsel_dec[ep] = (1'b1 << wraddr[ep]);
            end
        end

        for (et = 0; et < num_wr_ports; et++) begin : wsel_emul_loop5
            always_comb wsel[et] = {depth{wren2[et]}} & wsel_dec[et];
            for (eq = 0; eq < depth; eq++) begin : wsel_emul_loop6
                always_comb wsel_T[eq][et] = wsel[et][eq];
            end
        end
        for (ey = 0; ey < depth; ey++) begin : wsel_emul_loop7
            always_comb wsel_final[ey] = (|(wsel_T[ey]));
        end

        if (num_wr_ports == 1) begin : if_single_wr_port3
            for (en = 0; en < depth; en++) begin :  wsel_emul_loop7
                always_comb wrdata_sent_to_store[en] = wrdata_selected[0];
            end
        	`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_selected_masked, depth)
			`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_selected_masked_pre, depth)
        end 
        else begin : else_single_wr_port3
        	for (em = 0; em < depth; em++) begin : wsel_emul_loop8
			always_comb begin
				wrdata_selected_masked[em] = '0;
				for (int el = 0; el < num_wr_ports; el++) begin: wsel_emul_loop9
					wrdata_selected_masked[em] |= ( wrdata_selected[el] & {width{wsel_T[em][el]}} );
				end
			end
			always_comb wrdata_sent_to_store[em] = wrdata_selected_masked[em] ;
            end
			`HQM_DEVTLB_GENRAM_MDA_TIEOFF(wrdata_selected_masked_pre, depth)
        end

        for (ez=0; ez<depth; ez++) begin : flops_loop
            if (async_reset_enable == 1) begin : if_async_reset3
                `HQM_DEVTLB_GENRAM_EN_ASYNC_RSTB_MSFF(lat_data[ez], wrdata_sent_to_store[ez], gramclk, wsel_final[ez], async_reset_b)
            end
            else begin : else_async_reset3
                `HQM_DEVTLB_GENRAM_EN_MSFF(lat_data[ez], wrdata_sent_to_store[ez], gramclk, wsel_final[ez])
            end
        end
    end
endgenerate
`endif




//------------------------------------------- Xbuf ---------------------------------------------//
`ifndef INTEL_EMULATION
generate
    genvar bj;
        if ((xbuf_type ==0) & (MCP > 1)) begin : xbuf_type0_loop
            for (bj=0; bj<depth; bj++) begin : xbuf_instances0
                xbuf_mcp_clkcross
                #(
                    .width($bits(T)),       
                    .MCP(MCP),      
                    .clkname(clkname_wr),     
                    .start_end("start")
                )
                xbuf_inst 
                (
                    .a(latched_data[bj]), 
                    .a_x(lat_data[bj])   
                );
            end
        end
        else if ((xbuf_type ==1) & (MCP > 1)) begin : xbuf_type1_loop
            for (bj=0; bj<depth; bj++) begin : xbuf_instances1
                xbuf_mcp
                #(
                    .width($bits(T)),      
                    .MCP(MCP),  
                    .clkname(clkname_wr)     
                )
                xbuf_inst 
                (
                    .a(latched_data[bj]),       
                    .a_x(lat_data[bj])   
                );
            end
        end 
        else if ((xbuf_type ==2) & (MCP == 1)) begin : xbuf_type2_loop
            for (bj=0; bj<depth; bj++) begin : xbuf_instances2
                xbuf_async_clkcross
                #(
                    .width($bits(T)),       
                    .MCP(MCP),    
                    .clkname(clkname_rd)     
                )
                xbuf_inst 
                (
                    .a(latched_data[bj]),       
                    .a_x(lat_data[bj])   
                );
            end 
        end 
        else if ((xbuf_type ==2) & (MCP > 1)) begin : xbuf_type2_loop_spl
            for (bj=0; bj<depth; bj++) begin : xbuf_instances2
                xbuf_async_clkcross
                #(
                    .width($bits(T)),       
                    .MCP(MCP),    
                    .clkname(clkname_wr)     
                )
                xbuf_inst 
                (
                    .a(latched_data[bj]),       
                    .a_x(lat_data[bj])   
                );
            end 
        end         
        else if (xbuf_type ==3) begin : xbuf_type3_loop
             for (bj=0; bj<depth; bj++) begin : xbuf_instances3
                xbuf_bgf_clkcross
                #(
                    .width($bits(T)),
                    .psep(psep),  
                    .clkname1(clkname_wr),
                    .clkname2(clkname_rd)    
                )
                xbuf_inst 
                (
                    .a(latched_data[bj]),        
                    .a_x(lat_data[bj])   
                );
             end
        end
        else if (xbuf_type == 4) begin :xbuf_type4_loop
             for (bj=0; bj<depth; bj++) begin :xbuf_instances4
                xbuf_slice_bgf_clkcross
                #(
                    .width($bits(T)),
                    .psep(psep),
                    .clkname1(clkname_wr),
                    .clkname2(clkname_rd)    
                )
                xbuf_inst 
                (
                    .a(latched_data[bj]),        
                    .a_x(lat_data[bj])   
                );
             end : xbuf_instances4
        end
        else begin : else_xbuf_type
            always_comb lat_data = latched_data;
        end 
endgenerate
`endif




//------------------------------------ storage_data ------------------------------------//
// Need to cat the input flop stage if fifo_opt is on
generate
genvar bk, bv;
if(use_storage_data == 1) begin : if_use_storage_data
    for (bv=0; bv< storage_data_width; bv++) begin : storage_data_loop
        always_comb storage_data[(bv*$bits(T)) +: $bits(T)] = storage_dataMDA[bv];
    end

    //create storage_data from storage_dataMDA
    if ((fifo_opt == 1) & (flop_latch_based == 0)) begin : if_fifo_opt1
        for (bk=0; bk< storage_data_width-1; bk++) begin : storage_dataMDA_loop
            always_comb storage_dataMDA[bk] = lat_data[bk];
        end
        always_comb storage_dataMDA[storage_data_width-1] = wrdata_selected[0];
    end
    else begin : else_fifo_opt1
        always_comb storage_dataMDA = lat_data;
    end
end
else begin : else_use_storage_data
	`HQM_DEVTLB_GENRAM_TIEOFF(storage_data)
	`HQM_DEVTLB_GENRAM_MDA_TIEOFF(storage_dataMDA, storage_data_width)
end
endgenerate



//-------------------------------------------- Read Muxes -------------------------------------------//
// Spliting the flattened data into separate data elements, each is input data meant to go to corresponding MUX.
generate
genvar ba, ba1;
genvar bb;
    if(num_rd_ptr_split > 1) begin : if_rd_ptr_split1
        for (ba=0; ba< elements_per_MUX; ba++) begin : num_elements_per_MUX_loop
            for (bb=0; bb< (num_rd_ptr_split); bb++) begin : MUX_instances_loop
                always_comb data_per_mux[bb][ba] = lat_data[(num_rd_ptr_split*ba)+bb] ;
                initial begin
                    if (((num_rd_ptr_split*ba)+bb) > depth) begin
                        $display("  ERROR : out of bounds: num_rd_ptr_split: %d,  bb=%d, ba = %d, depth=%d\n", num_rd_ptr_split , bb, ba, depth);
                    end
                end    
            end 
        end 
    end
	else begin : else_rd_ptr_split1
        for (ba1=0; ba1< num_rd_ptr_split; ba1++) begin : data_per_MUX_tieoff_loop
		    `HQM_DEVTLB_GENRAM_MDA_TIEOFF(data_per_mux[ba1], elements_per_MUX)
        end
	end
endgenerate


//Converting rdaddr to binary if its in one_hot
generate
genvar bf, bo;
if(depth > 1) begin : if_depth_not_1
    if(one_hot_rd_ptrs == 0) begin : if_one_hot_rd_ptrs1
    //Muxing rdaddr for SV dump and regular cases - In SVdump case, initial input flop becomes the rdaddr
        if ((svdump_en == 0) || (noflopin_opt == 1)) begin :if_no_svdump2
            for(bo = 0; bo < num_rd_ports; bo++) begin: scan_rdmux_loop1
                always_comb rdaddr_final[bo] = (~dt_latchclosed_b) ? wrdata_f_pad : rdaddr[bo] ;   
            end
        end 
        else begin: else_no_svdump2
            always_comb rdaddr_final = rdaddr ;              
        end

    	if(num_rd_ptr_split >1) begin : if_num_rd_ptr_split2  
            for(bf = 0; bf < num_rd_ptr_split; bf++) begin: mux_multcopy_loop1
                always_comb mux_out[bf][$bits(T)-1:0] =  data_per_mux[bf][rdaddr_final[bf]] ;   //lintra s-0241 "part select might be out of bounds"
            end
        end
        else begin : else_rd_ptr_split2
            for(bf = 0; bf < num_rd_ports; bf++) begin: mux_loop1
                always_comb mux_out[bf][$bits(T)-1:0] =  lat_data[rdaddr_final[bf]] ;           //lintra s-0241 "part select might be out of bounds"
            end
        end
	end
    else begin : else_one_hot_rd_ptrs1
		genvar bv1, bv2; 
        for(bo = 0; bo < num_rd_ports; bo++) begin: scan_rdmux_loop2
            always_comb rdaddr_final[bo] = rdaddr[bo] ;
        end   
        if(num_rd_ptr_split >1) begin : if_rd_ptr_split3
            for(bv1 = 0; bv1 < num_rd_ptr_split; bv1++) begin: rd_loop1
                always_comb begin
                    mux_out[bv1] = '0;
                    for(int bv2 = 0; bv2 < elements_per_MUX; bv2++) begin: andor_mux_loop1
                        mux_out[bv1] |= ( data_per_mux[bv1][bv2] & {width{rdaddr_final[bv1][bv2]}} ) ;
                    end
                end
            end
    	end
        else begin : else_rd_ptr_split3
        	for(bv1 = 0; bv1 < num_rd_ports; bv1++) begin: rd_loop2  
                always_comb begin
                    mux_out[bv1] = '0;
                    for(int bv2 = 0; bv2 < depth; bv2++) begin: andor_mux_loop2
                        mux_out[bv1] |= ( lat_data[bv2] & {width{rdaddr_final[bv1][bv2]}} ) ;
                    end
                end
        	end
    	end
	end 
end // if depth>1
else begin : else_depth_not_1
	`HQM_DEVTLB_GENRAM_MDA_TIEOFF(rdaddr_final, num_rd_ports)
	`HQM_DEVTLB_GENRAM_MDA_TIEOFF(mux_out, num_rd_ports)
end
endgenerate


generate
genvar bl;
    if (num_rd_ports == 0) begin : if_num_rd_ports_0
        always_comb rddataout[0] = {$bits(T){1'bx}};        //lintra s-50002, 60145 "No x assignments outside of casex statement. " "x assigments outside INST_ON "
    end
    else begin : else_num_rd_ports_0
       if (depth > 1) begin : if_depth_not_1
            always_comb rddataout = mux_out;
        end
        else begin : else_depth_not_1
            for(bl = 0; bl < num_rd_ports; bl++) begin: depth1_rd_ports
                always_comb rddataout[bl] = lat_data[0];
            end
        end
    end
endgenerate

// add assert - if num_rd_ptr_split > 1 and depth !> 1
// check CAM in some unit's test
//------------------------------------------- CAM -------------------------------------//
generate
genvar bh, bi;
    if (cam_width0 >0) begin : if_cam_0
        for (bh=0; bh<storage_data_width-1; bh++) begin: cam0_loop
            always_comb cam_hit0[bh] = ( cam_data0[cam_width0-1:0] == lat_data[bh][cam_low_bit0+cam_width0-1 -: cam_width0] );
        end
        if((fifo_opt == 1) & (flop_latch_based == 0)) begin : if_fifo_opt2
            always_comb cam_hit0[storage_data_width-1] = ( cam_data0[cam_width0-1:0] == wrdata_selected[0][cam_low_bit0+cam_width0-1 -: cam_width0] );
        end
        else begin : else_fifo_opt2
            always_comb cam_hit0[storage_data_width-1] = ( cam_data0[cam_width0-1:0] == lat_data[storage_data_width-1][cam_low_bit0+cam_width0-1 -: cam_width0] );
        end
    end
	else begin : else_cam_0
		`HQM_DEVTLB_GENRAM_TIEOFF(cam_hit0)
	end


    if (cam_width1 >0) begin : if_cam_1
        for (bi=0; bi<storage_data_width-1; bi++) begin: cam1_loop
            always_comb cam_hit1[bi] = ( cam_data1[cam_width1-1:0] == lat_data[bi][cam_low_bit1+cam_width1-1 -: cam_width1] );
        end
        if((fifo_opt == 1) & (flop_latch_based == 0)) begin: if_fifo_opt3
            always_comb cam_hit1[storage_data_width-1] = ( cam_data1[cam_width1-1:0] == wrdata_selected[0][cam_low_bit1+cam_width1-1 -: cam_width1] );
        end
        else begin : else_fifo_opt3
            always_comb cam_hit1[storage_data_width-1] = ( cam_data1[cam_width1-1:0] == lat_data[storage_data_width-1][cam_low_bit1+cam_width1-1 -: cam_width1] );
        end
    end 
	else begin : else_cam_1
        `HQM_DEVTLB_GENRAM_TIEOFF(cam_hit1)
    end
endgenerate


endmodule // gt_ram_bees_knees

