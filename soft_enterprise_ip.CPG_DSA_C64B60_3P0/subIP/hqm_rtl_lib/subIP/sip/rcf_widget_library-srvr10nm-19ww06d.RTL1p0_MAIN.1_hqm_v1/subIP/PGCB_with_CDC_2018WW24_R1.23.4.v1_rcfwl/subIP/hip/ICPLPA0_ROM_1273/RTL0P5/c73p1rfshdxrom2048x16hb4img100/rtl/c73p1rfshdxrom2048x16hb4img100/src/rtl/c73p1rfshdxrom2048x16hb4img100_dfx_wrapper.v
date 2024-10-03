// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature 93a774eb5fcf1b7d120a33a286f96d90f5676057 % Version r1.0.0_m1.18 % _View_Id v % Date_Time 20160303_050304 
`ifndef MEM_CTECH

	//LV_pragma translate_off
		`include "soc_clocks.sv"
	//LV_pragma translate_on
`endif

module c73p1rfshdxrom2048x16hb4img100_dfx_wrapper (
`ifndef NO_PWR_PINS
 vccd_1p0, 	// Power input
`endif

// power management and MISC pins  
 FUSE_MISC_ROM_IN,
 PWR_MGMT_MISC_ROM_IN,
 PWR_MGMT_MISC_ROM_OUT,

// functional inputs to ROM
 FUNC_CLK_ROM_IN,       // clock
 FUNC_ADDR_ROM_IN,  	// Read address
 FUNC_REN_ROM,          // Read enable
 DATA_ROM_OUT,          // Data outputs  

// Mbist ports

 BIST_ROM_ENABLE,       // Enable MBIST tests
 BIST_CLK_ROM_IN,       // Bist clock
 BIST_ADDR_ROM_IN,  	// Bist Read Address
 BIST_REN_ROM,          // Bist Read Enable

 DFX_MISC_ROM_IN ,
 DFX_MISC_ROM_OUT,

 FSCAN_RAM_BYPSEL,

 // ATPG_AWT Test related ports
 LBIST_TEST_MODE,
 FSCAN_RAM_AWT_MODE,
 FSCAN_RAM_AWT_REN,

 FSCAN_RAM_RDDIS_B,    // Ram sequential mode read enable
 FSCAN_RAM_ODIS_B      // Ram sequential mode output enable
);


   //  MSWT_MODE = 0 - Ram_sequential mode
   //  MSWT_MODE = 1 - Sync. bypass mode
   //  MSWT_MODE = 2 - ATPG AWT MODE (UMG)
   //  MSWT_MODE = 3 - MSWT mode (for LBIST) : THIS MODE HAS NOT BEEN CODED 


   parameter MSWT_MODE = 2;
   parameter NUM_DFX_MISC  = 5;
   parameter NUM_FUSE_MISC =5;
   parameter NUM_PM_MISC =4;

   parameter ROM_ADDR   = 11;	//Address Bus Size
   parameter ROM_WORDS  = 2048;	//Number of Words
   parameter ROM_BITS   = 16;	//Number of bits

   parameter BYPASS_RD_CLK_MUX = 0;

   // functional inputs to ROM
   input        logic                                FUNC_CLK_ROM_IN;   	// P0 clock 
   input        logic [ROM_ADDR-1:0]                  FUNC_ADDR_ROM_IN;  	// Read address
   input        logic                                FUNC_REN_ROM;          // Read enable
   output       logic [ROM_BITS-1:0]                         DATA_ROM_OUT;          // Data outputs  
    
   // Mbist ports

   input        logic                                BIST_CLK_ROM_IN;       // Bist clock
   input        logic [ROM_ADDR-1:0]                          BIST_ADDR_ROM_IN;      // Bist Read Address
   input        logic                                BIST_REN_ROM;          // Bist Read Enable

   input        logic                                BIST_ROM_ENABLE;
   
   input        logic [NUM_DFX_MISC-1:0]             DFX_MISC_ROM_IN ;  
   output       logic [NUM_DFX_MISC-1:0]             DFX_MISC_ROM_OUT ;
`ifndef NO_PWR_PINS
   input        logic                                vccd_1p0;
`endif
   input        logic [NUM_FUSE_MISC-1:0]            FUSE_MISC_ROM_IN;
   input        logic [NUM_PM_MISC-1:0]		 PWR_MGMT_MISC_ROM_IN;
   output       logic [NUM_PM_MISC-1:0]		 PWR_MGMT_MISC_ROM_OUT;

   // SYNC bypass select
   input        logic                                FSCAN_RAM_BYPSEL;

   // LBIST Test related ports
   input        logic                                LBIST_TEST_MODE;

   // ATPG_AWT Test related ports
   input	logic				 FSCAN_RAM_AWT_MODE;
   input	logic				 FSCAN_RAM_AWT_REN;
   
   input	logic				 FSCAN_RAM_RDDIS_B;  // Ram sequential mode read enable
   input        logic 				 FSCAN_RAM_ODIS_B;   // Ram sequential mode output enable

//LV_pragma translate_off
	generate
		if (NUM_PM_MISC>1)
			begin:PWR_MGMT_PARAMETER
				assign PWR_MGMT_MISC_ROM_OUT[NUM_PM_MISC-1:1] = {NUM_PM_MISC-1{1'b0}}; 
	     		end:PWR_MGMT_PARAMETER
	endgenerate


	assign DFX_MISC_ROM_OUT[NUM_DFX_MISC-1:0] = {NUM_DFX_MISC{1'b0}}; 
	


reg [ROM_BITS-1:0] Mem_bypass0_reg;

wire FUNC_OR_BIST_CLK_ROM_IN;



generate

 `ifndef MEM_CTECH
	if (BYPASS_RD_CLK_MUX == 0)
			begin : genclkmux_rd
				dfx_sync_clock_mux  sync_clock_mux (.clk_in1(BIST_CLK_ROM_IN),.clk_in0(FUNC_CLK_ROM_IN),.clock_sel((BIST_ROM_ENABLE & ~FSCAN_RAM_AWT_MODE & ~LBIST_TEST_MODE)),.rst_b0(DFX_MISC_ROM_IN[0]),.rst_b1(DFX_MISC_ROM_IN[0]),.clk_out(FUNC_OR_BIST_CLK_ROM_IN));
			end : genclkmux_rd
	else //of if (BYPASS_RD_CLK_MUX == 0)
		begin : dont_genclkmux_rd
			`CLKBF(FUNC_OR_BIST_CLK_ROM_IN, FUNC_CLK_ROM_IN)
		end : dont_genclkmux_rd
 `else 
	if (BYPASS_RD_CLK_MUX == 0)
			begin : genclkmux_rd
				rfrom_ctech_clk_mux_2to1_glitchfree  sync_clock_mux (.clk_in1(BIST_CLK_ROM_IN),.clk_in0(FUNC_CLK_ROM_IN),.clock_sel((BIST_ROM_ENABLE & ~FSCAN_RAM_AWT_MODE & ~LBIST_TEST_MODE)),.rst_b0(DFX_MISC_ROM_IN[0]),.rst_b1(DFX_MISC_ROM_IN[0]),.clk_out(FUNC_OR_BIST_CLK_ROM_IN));
			end : genclkmux_rd
		else //of if (BYPASS_RD_CLK_MUX == 0)
			begin : dont_genclkmux_rd
				rfrom_ctech_clk_buf clk_buf (.clk(FUNC_CLK_ROM_IN), .clkout(FUNC_OR_BIST_CLK_ROM_IN));
			end : dont_genclkmux_rd
 `endif

if (MSWT_MODE == 2'b10)

begin : mode_atpg // start MSWT_MODE == 10 - UMG_ATPG_AWT
   

// Begin bypass muxes for UMG_ATPG_AWT 
 
wire FUNC_REN_ROM_toMem;
wire [ROM_ADDR-1:0] FUNC_ADDR_ROM_IN_toMem ;

wire [ROM_ADDR-1:0] FUNC_ADDR_ROM_IN_MUX ;
wire FUNC_REN_ROM_MUX ;

assign FUNC_ADDR_ROM_IN_toMem = FUNC_ADDR_ROM_IN & {11{~FSCAN_RAM_AWT_MODE}};

// DFT MUX on address signal //
assign FUNC_ADDR_ROM_IN_MUX = BIST_ROM_ENABLE ? BIST_ADDR_ROM_IN : FUNC_ADDR_ROM_IN_toMem ;

 assign FUNC_REN_ROM_toMem = FSCAN_RAM_AWT_MODE ? FSCAN_RAM_AWT_REN:FUNC_REN_ROM;

//DFT MUX on enable signal //
assign FUNC_REN_ROM_MUX = BIST_ROM_ENABLE ? BIST_REN_ROM : FUNC_REN_ROM_toMem ;



    c73p1rfshdxrom2048x16hb4img100
    c73p1rfshdxrom2048x16hb4img100
    (
       
       // functional plane
       .ickr(FUNC_OR_BIST_CLK_ROM_IN),
       	.iren(FUNC_REN_ROM_MUX),
	.iar(FUNC_ADDR_ROM_IN_MUX),  
	.odout(DATA_ROM_OUT[ROM_BITS-1:0]),

      
      //  From ckt_plane
        `ifndef NO_PWR_PINS
	  `ifndef DC
	    .vccd_1p0(vccd_1p0),
	  `endif
	`endif
        .ipwreninb(PWR_MGMT_MISC_ROM_IN[0]),
    	.opwrenoutb(PWR_MGMT_MISC_ROM_OUT[0])
);

end : mode_atpg // End MSWT_MODE == 10 - UMG_ATPG_AWT

else

if (MSWT_MODE == 2'b01)
begin : mode_sync // Start MSWT_MODE == 01 - Synchronous bypass for LBIST 

wire [ROM_BITS-1:0] DATA_ROM_OUT_fromMem;

// Begin bypass registers/muxes
  always_ff @(posedge FUNC_CLK_ROM_IN )
  begin
   Mem_bypass0_reg[ROM_BITS-1:0] <= {16{1'b0}};
  end

 assign DATA_ROM_OUT = FSCAN_RAM_BYPSEL ? Mem_bypass0_reg[ROM_BITS-1:0]:DATA_ROM_OUT_fromMem;


wire [ROM_ADDR-1:0] FUNC_ADDR_ROM_IN_MUX ;
wire FUNC_REN_ROM_MUX ;

 // DFT MUX on address signal //
 assign FUNC_ADDR_ROM_IN_MUX = BIST_ROM_ENABLE ? BIST_ADDR_ROM_IN : FUNC_ADDR_ROM_IN ;

 //DFT MUX on enable signal //
 assign FUNC_REN_ROM_MUX = BIST_ROM_ENABLE ? BIST_REN_ROM : FUNC_REN_ROM ;

   c73p1rfshdxrom2048x16hb4img100
   c73p1rfshdxrom2048x16hb4img100
   (
      // functional plane
      .ickr(FUNC_OR_BIST_CLK_ROM_IN),
      .iren(FUNC_REN_ROM_MUX),
      .iar(FUNC_ADDR_ROM_IN_MUX),  
      .odout(DATA_ROM_OUT_fromMem[ROM_BITS-1:0]),

      
      //  From ckt_plane
	`ifndef NO_PWR_PINS
	  `ifndef DC
      	    .vccd_1p0(vccd_1p0),
	  `endif
	`endif
      .ipwreninb(PWR_MGMT_MISC_ROM_IN[0]),
      .opwrenoutb(PWR_MGMT_MISC_ROM_OUT[0])
);
end : mode_sync // end MSWT_MODE == 01 - Synchronous Bypass

else

if (MSWT_MODE == 2'b00)
begin : mode_ramseq // Start MSWT_MODE == 00 - Ram Sequential mode
wire MUX_REN_ROM_toMem;
wire [ROM_BITS-1:0] DATA_ROM_OUT_fromMem;

wire [ROM_ADDR-1:0] FUNC_ADDR_ROM_IN_MUX ;
wire FUNC_REN_ROM_toMem_MUX ;
wire BIST_REN_ROM_toMem_MUX ;

// Ram sequential mode Array DFT



 assign FUNC_REN_ROM_toMem_MUX = FUNC_REN_ROM & FSCAN_RAM_RDDIS_B;
 assign BIST_REN_ROM_toMem_MUX = BIST_REN_ROM & FSCAN_RAM_RDDIS_B;

 // DFT MUX on enable signal
 assign MUX_REN_ROM_toMem = BIST_ROM_ENABLE ? BIST_REN_ROM_toMem_MUX : FUNC_REN_ROM_toMem_MUX ;

 // DFT MUX on address signal //
 assign FUNC_ADDR_ROM_IN_MUX = BIST_ROM_ENABLE ? BIST_ADDR_ROM_IN : FUNC_ADDR_ROM_IN ;


 assign DATA_ROM_OUT = DATA_ROM_OUT_fromMem[ROM_BITS-1:0] & {16{FSCAN_RAM_ODIS_B}};

    c73p1rfshdxrom2048x16hb4img100
    c73p1rfshdxrom2048x16hb4img100
   (
        // functional plane
	.ickr(FUNC_OR_BIST_CLK_ROM_IN),
	.iren(MUX_REN_ROM_toMem),
	.iar(FUNC_ADDR_ROM_IN_MUX),  
	.odout(DATA_ROM_OUT_fromMem[ROM_BITS-1:0]),

      
      //  From ckt_plane
	`ifndef NO_PWR_PINS
	  `ifndef DC
	    .vccd_1p0(vccd_1p0),
	  `endif
	`endif
  	.ipwreninb(PWR_MGMT_MISC_ROM_IN[0]),
      	.opwrenoutb(PWR_MGMT_MISC_ROM_OUT[0])

    );

end : mode_ramseq // end MSWT_MODE == 00 - Ram sequential mode

endgenerate

    `include "cov_points_rfshdmrom.inc"

//LV_pragma translate_on
endmodule

