// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature 5c5db19612fe3012f4fc029803963116e39a6b63 % Version r1.0.0_m1.18 % _View_Id v % Date_Time 20160216_100946 
//==============================================================
//  Copyright (c) 2008 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//==============================================================
//     File/Block                             : c73p1rfshdxrom2048x32hb4img108.v
//     Library (must be same as module name)  : c73p1rfshdxrom2048x32hb4img108
//     Bizgroup [LCP|SEG|ULMD]               : ULMD
//     Design Unit Owner                      : avijit.chakraborty@intel.com
//=============================================================================
// Description:
// Module c73p1rfshdxrom2048x32hb4img108 - 1R0W 2048 entries deep 32 bits wide
//=============================================================================


`ifndef __c73p1rfshdxrom2048x32hb4img108__v
`define __c73p1rfshdxrom2048x32hb4img108__v


module c73p1rfshdxrom2048x32hb4img108 (
	ickr,			// Clock
	iren,			// Enable
	iar,			// Address bus
`ifndef NO_PWR_PINS
	vccd_1p0,		// power pin
`endif



	ipwreninb,		// Incoming power enable
	opwrenoutb,		// Outgoing power enable
	odout			// Output
);




parameter ROM_BANK_ADDR_W = 11;
parameter ROM_BANK_DEPTH  = 2048;
parameter ROM_DATA_W	  = 32;


	input 				ickr;			// Clock
	input 				iren;			// Enable
	input	[ROM_BANK_ADDR_W-1:0] 	iar;			// Address bus
`ifndef NO_PWR_PINS
	input				vccd_1p0;	// power pin
`endif




	input				ipwreninb;		// Incoming power enable
	output				opwrenoutb;		// Outgoing power enable
	output	[ROM_DATA_W-1:0] 	odout;			// Output



logic ickr_gated, bank_iren_l;
logic [ROM_BANK_ADDR_W-1:0] bank_iar_l;
logic [ROM_DATA_W-1:0] read_data;
logic [ROM_DATA_W-1:0] read_data_sdl;




// ROM array
(* synthesis, rom_block *) logic [ROM_DATA_W-1:0] rom_bank[ROM_BANK_DEPTH-1:0];

`ifndef NO_PWR_PINS
	assign opwrenoutb = ipwreninb;
`endif

always_latch begin
   if (~ickr) begin
      bank_iren_l <= iren;
   end
end

assign ickr_gated = bank_iren_l & ickr;

always_latch begin
   if (~ickr_gated) begin
      bank_iar_l <= iar;
   end
end

// Read ROM array
assign read_data = rom_bank[bank_iar_l];

// Capture read data in SDL
always_latch begin
   if (ickr_gated) read_data_sdl <= read_data;
end

assign odout = read_data_sdl;


// Read rom programming
`define rom_image "c73p1rfshdxrom2048x32hb4img108.hex"
//`define rom_image "c73p1rfshdxrom2048x32hb4img108.hex"
`ifndef LINT
   `ifndef EMULATION
      initial begin
         $readmemh(`rom_image, rom_bank);
//         $readmemb(`rom_image, rom_bank);
      end
   `endif // `ifndef EMULATION
`endif // `ifndef LINT

// Assertion
//`ifndef SVA_OFF
//  `ifndef ERR_MSG
//     `ifndef ROM_FEV
//  	`define ERR_MSG(text) else $error("SVA FATAL ERROR: %s -- %m at %0t", text, $time)
//     `else
//     `define ERR_MSG(text)
//     `endif // ifndef ROM_FEV
//  `endif // ifndef ERR_MSG
//
//  `ifndef ROM_FEV
//    always_comb begin
//      if ($realtime != 0) begin
//        `ifndef NO_PWR_PINS
//           vcc_assertion: assert final(vccd_1p0) `ERR_MSG($psprintf("vccd_1p0 must be 1"));
//        `endif
//        addr_bound_chck: assert final((~bank_iren_l|ickr) || (iar < ROM_BANK_DEPTH)) `ERR_MSG($psprintf("Address %d is outside range of 0 to %d", iar, ROM_BANK_DEPTH-1));
//      end
//    end
//  `else
//    `ifndef NO_PWR_PINS
//       vcc_fev_assertion: assert final(vccd_1p0) `ERR_MSG($psprintf("vccd_1p0 must be 1"));
//    `endif
//    addr_bound_chck_fev: assert final(iar < ROM_BANK_DEPTH) `ERR_MSG($psprintf("Address %d is outside range of 0 to %d", iar, ROM_BANK_DEPTH-1));
//  `endif // ifndef ROM_FEV
//`endif // ifndef SVA_OFF

endmodule
`endif


