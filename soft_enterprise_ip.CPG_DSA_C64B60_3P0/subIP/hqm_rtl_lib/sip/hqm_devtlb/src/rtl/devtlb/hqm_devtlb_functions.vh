//=====================================================================================================================
//
// iommu_functions.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================


//=====================================================================================================================
//=====================================================================================================================
//
// DO NOT ifndef this file...it should get included in all interface declarations that expect to use instance specific parameters
//
//=====================================================================================================================
//=====================================================================================================================
//`ifndef IOMMU_FUNCTIONS_VH
//`define IOMMU_FUNCTIONS_VH

//=====================================================================================================================
// CONSTANTS
//=====================================================================================================================

function automatic logic f_tlb_lookup_en;
   input [$bits(t_devtlb_opcode)-1:0]    opcode;
   input                                  overflow;

   f_tlb_lookup_en = '0;
   if (
        ( 
          // Untranslated Requests 
             (opcode == DEVTLB_OPCODE_UTRN_R)
          |  (opcode == DEVTLB_OPCODE_UTRN_W)
          |  (opcode == DEVTLB_OPCODE_UTRN_ZLREAD)
          |  (opcode == DEVTLB_OPCODE_UTRN_RW)
          |  (opcode == DEVTLB_OPCODE_FILL)
          |  (opcode == DEVTLB_OPCODE_DTLB_INV)
          |  (opcode == DEVTLB_OPCODE_UARCH_INV)
        ) & ~overflow
      )
         f_tlb_lookup_en = 1;

endfunction

function automatic logic f_tlb_LRUupdate_en;
   input [$bits(t_devtlb_opcode)-1:0]    opcode;
   input                                  overflow;

   f_tlb_LRUupdate_en = '0;
   if (
        ( 
          // Untranslated Requests 
             (opcode == DEVTLB_OPCODE_UTRN_R)
          |  (opcode == DEVTLB_OPCODE_UTRN_W)
          |  (opcode == DEVTLB_OPCODE_UTRN_ZLREAD)
          |  (opcode == DEVTLB_OPCODE_UTRN_RW)
          |  (opcode == DEVTLB_OPCODE_FILL)
        ) & ~overflow
      )
         f_tlb_LRUupdate_en = 1;

endfunction

function automatic logic f_tlb_fill_en;
   input [$bits(t_devtlb_opcode)-1:0]    opcode;
   input                                  overflow;

   f_tlb_fill_en = '0;
   if (
        ( 
             (opcode == DEVTLB_OPCODE_FILL)
        ) & ~overflow
      )
         f_tlb_fill_en = 1;

endfunction


// READ, ZLR, and WRITE functions are only for permission checks (non-recoverable faults), 
// so only care for untranslated requests
//
function automatic logic f_dma_read_req;
   input [$bits(t_devtlb_opcode)-1:0]     opcode;

   f_dma_read_req = '0;
   if (
    // Untranslated Requests
         (opcode == DEVTLB_OPCODE_UTRN_R)
      |  (opcode == DEVTLB_OPCODE_UTRN_ZLREAD)
      |  (opcode == DEVTLB_OPCODE_UTRN_RW)
      )
         f_dma_read_req = 1;

endfunction

function automatic logic f_dma_zlr_req;
   input [$bits(t_devtlb_opcode)-1:0]     opcode;

   f_dma_zlr_req = '0;
   if (
    // Untranslated Requests
         (opcode == DEVTLB_OPCODE_UTRN_ZLREAD)
      )
         f_dma_zlr_req = 1;

endfunction

function automatic logic f_dma_write_req;
   input [$bits(t_devtlb_opcode)-1:0]     opcode;

   f_dma_write_req = '0;
   if (
    // Untranslated Requests
         (opcode == DEVTLB_OPCODE_UTRN_W)
      |  (opcode == DEVTLB_OPCODE_UTRN_RW)
      )
         f_dma_write_req = 1;

endfunction

function automatic t_devtlb_page_type f_IOMMU_Int_2_PS(int ps);
   if      (ps == `HQM_DEVTLB_PS_4K) f_IOMMU_Int_2_PS = SIZE_4K;
   else if (ps == `HQM_DEVTLB_PS_2M) f_IOMMU_Int_2_PS = SIZE_2M;
   else if (ps == `HQM_DEVTLB_PS_1G) f_IOMMU_Int_2_PS = SIZE_1G;
   else if (ps == `HQM_DEVTLB_PS_5T) f_IOMMU_Int_2_PS = SIZE_5T;
   else if (ps == `HQM_DEVTLB_PS_QP) f_IOMMU_Int_2_PS = SIZE_QP;
   else                         f_IOMMU_Int_2_PS = SIZE_4K;
endfunction

function automatic t_devtlb_page_type f_tlb_fill_pagesize(logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]   Address, logic [2:0] pagesize);
    if      (pagesize == '0)                                                                            f_tlb_fill_pagesize = SIZE_4K;
    else if ((pagesize == 3'b001) & (Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_2M)] == 9'h0FF))        f_tlb_fill_pagesize = SIZE_2M;   
    else if ((pagesize == 3'b001) & (Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_1G)] == 18'h1FFFF))     f_tlb_fill_pagesize = SIZE_1G;   
    else if ((pagesize == 3'b001) & (Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_5T)] == 27'h3FFFFFF))   f_tlb_fill_pagesize = SIZE_5T;
    else                                                                                                f_tlb_fill_pagesize = SIZE_4K;        
endfunction


function automatic logic f_IOMMU_Opcode_can_read(logic [$bits(t_devtlb_opcode)-1:0] Opcode);

   f_IOMMU_Opcode_can_read = (Opcode == DEVTLB_OPCODE_UTRN_R)       
                         | (Opcode == DEVTLB_OPCODE_UTRN_W)      
                         | (Opcode == DEVTLB_OPCODE_UTRN_ZLREAD)     
                         | (Opcode == DEVTLB_OPCODE_UTRN_RW)     
                         | (Opcode == DEVTLB_OPCODE_FILL)     
                         ;

endfunction

function automatic logic f_IOMMU_Opcode_is_DMA(logic [$bits(t_devtlb_opcode)-1:0] Opcode);

   f_IOMMU_Opcode_is_DMA = (Opcode == DEVTLB_OPCODE_UTRN_R)       
                         | (Opcode == DEVTLB_OPCODE_UTRN_W)      
                         | (Opcode == DEVTLB_OPCODE_UTRN_ZLREAD)     
                         | (Opcode == DEVTLB_OPCODE_UTRN_RW)     
                         ;

endfunction

function automatic logic f_IOMMU_Opcode_is_FILL(logic [$bits(t_devtlb_opcode)-1:0] Opcode);

   f_IOMMU_Opcode_is_FILL = (Opcode == DEVTLB_OPCODE_FILL);

endfunction

function automatic logic f_IOMMU_Opcode_is_Untranslated(logic [$bits(t_devtlb_opcode)-1:0] Opcode);

   f_IOMMU_Opcode_is_Untranslated = (Opcode == DEVTLB_OPCODE_UTRN_R)       
                                  | (Opcode == DEVTLB_OPCODE_UTRN_W)      
                                  | (Opcode == DEVTLB_OPCODE_UTRN_ZLREAD)     
                                  | (Opcode == DEVTLB_OPCODE_UTRN_RW)     
                                  ;

endfunction


function automatic logic f_IOMMU_Opcode_is_Invalidation(logic [$bits(t_devtlb_opcode)-1:0] Opcode);

   f_IOMMU_Opcode_is_Invalidation = (Opcode == DEVTLB_OPCODE_DTLB_INV)       
                                  | (Opcode == DEVTLB_OPCODE_UARCH_INV)
                                  ;

endfunction

function automatic logic f_IOMMU_Opcode_is_AnyInvalidation(logic [$bits(t_devtlb_opcode)-1:0] Opcode);

   f_IOMMU_Opcode_is_AnyInvalidation = (Opcode == DEVTLB_OPCODE_DTLB_INV)       
                                  | (Opcode == DEVTLB_OPCODE_UARCH_INV)
                                  | (Opcode == DEVTLB_OPCODE_GLB_INV)
                                  ;

endfunction

//Function to find first zero (available) in address
//
//function automatic logic [`DEVTLB_LOG2(DEVTLB_MAX_GUEST_ADDRESS_WIDTH-12)-1:0] f_FindLastEntID (logic [(2**(`DEVTLB_LOG2(DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1-12)))-1:0] A);

   // Find position of most significant 1
   //f_FindLastEntID = '1;
   //for (int i=0;i<(2**(`DEVTLB_LOG2(DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1-12)))/*DEVTLB_MAX_GUEST_ADDRESS_WIDTH-12*/;i++) begin
   //      if (A[i]) f_FindLastEntID = (~i[$bits(f_FindLastEntID)-1:0]);
   //   end
//endfunction

/*function automatic logic [`HQM_DEVTLB_LOG2(DEVTLB_MAX_GUEST_ADDRESS_WIDTH-12)-1:0] f_DEVTLB_FindFirstZero (logic [DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1:12] Address);

   logic [DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1:12]                           flipvec;
   logic [(2**(`HQM_DEVTLB_LOG2(DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1-12)))-1:0]  flipvecshift;

   // Flip input vector to allow LZD
   for (int i=12; i<DEVTLB_MAX_GUEST_ADDRESS_WIDTH; i++) flipvec[i] = Address[DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1-i+12];

   // Right pad flipvec before doing LZD to account for non power of two sizes
   flipvecshift = {flipvec,{($bits(flipvecshift)-(DEVTLB_MAX_GUEST_ADDRESS_WIDTH-12)){1'b0}}};

   // Find position of most significant 1 (of reversed select vector)
   f_DEVTLB_FindFirstZero = f_FindLastEntID(flipvecshift);

endfunction*/

// Functions to check FPD Qualified Faults for DMA and IR Requests
//
function automatic logic f_IOMMU_DMA_qualified_fault;
   input [7:0]       FaultReason;

   // Qualified Fault Reasons -  05, 06
   f_IOMMU_DMA_qualified_fault = (FaultReason == DEVTLB_FAULT_RSN_DMA_PAGE_W)                    
                               | (FaultReason == DEVTLB_FAULT_RSN_DMA_PAGE_R);         

   // SVM Qualified Faults - 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 1A, 1C
   f_IOMMU_DMA_qualified_fault |= (FaultReason == DEVTLB_FAULT_RSN_DMA_PASID_X);

endfunction

//Function to check if Register Access is 32 bit 
//
//function automatic logic f_IOMMU_IS_bit_set(t_devtlb_ccbnames_dw RegEn);
//   logic [47:0]   bitvalue;
//   f_IOMMU_IS_bit_set   = 1'b0;
//   bitvalue =  {>>{RegEn}};
//   for (int i=0; i<48; i++)   begin
//      //bitvalue =  RegEn[i];
//      if (bitvalue[i])
//         f_IOMMU_IS_bit_set   = 1'b1;
//   end
//endfunction


//Function to calculate effective GAW
//
function automatic int f_IOMMU_Effective_GAW(logic [1:0] gaw_ctl);
   unique casez(1'b1)
        (gaw_ctl == 2'b00):    f_IOMMU_Effective_GAW = DEVTLB_MAX_GUEST_ADDRESS_WIDTH-12;
        (gaw_ctl == 2'b01):    f_IOMMU_Effective_GAW = 39-12;
        (gaw_ctl == 2'b10):    f_IOMMU_Effective_GAW = 48-12;
        (gaw_ctl == 2'b11):    f_IOMMU_Effective_GAW = 57-12;
        default:               f_IOMMU_Effective_GAW = DEVTLB_MAX_GUEST_ADDRESS_WIDTH-12;
   endcase
endfunction

//Function to calculate effective HAW
//
function automatic int f_IOMMU_Effective_HAW(logic [2:0] haw_ctl);
   unique casez(1'b1)
        (haw_ctl == 3'b000):   f_IOMMU_Effective_HAW = DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
        (haw_ctl == 3'b001):   f_IOMMU_Effective_HAW = 39-12;
        (haw_ctl == 3'b010):   f_IOMMU_Effective_HAW = 42-12;
        (haw_ctl == 3'b011):   f_IOMMU_Effective_HAW = DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
        (haw_ctl == 3'b100):   f_IOMMU_Effective_HAW = 46-12;
        (haw_ctl == 3'b101):   f_IOMMU_Effective_HAW = DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
        (haw_ctl == 3'b110):   f_IOMMU_Effective_HAW = 52-12;
        (haw_ctl == 3'b111):   f_IOMMU_Effective_HAW = DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
        default:               f_IOMMU_Effective_HAW = DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
   endcase
endfunction

//Function to calculate effective Overflow condition
//
function automatic logic f_IOMMU_Effective_Overflow(logic [2:0] haw_ctl, logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB] Address);
   f_IOMMU_Effective_Overflow = |(Address >> f_IOMMU_Effective_HAW(haw_ctl));
endfunction

//Function to find ID from one-hot vector
//3F - Indicates invalida ITAG
//
function automatic logic [5:0] f_IOMMU_onehot32_to_6b_encode (logic [31:0] ItagVec);

   unique casez (ItagVec)
      32'h0000_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h3F;
      32'h0000_0001:   f_IOMMU_onehot32_to_6b_encode   =  6'h0;
      32'h0000_0002:   f_IOMMU_onehot32_to_6b_encode   =  6'h1;
      32'h0000_0004:   f_IOMMU_onehot32_to_6b_encode   =  6'h2;
      32'h0000_0008:   f_IOMMU_onehot32_to_6b_encode   =  6'h3;
      32'h0000_0010:   f_IOMMU_onehot32_to_6b_encode   =  6'h4;
      32'h0000_0020:   f_IOMMU_onehot32_to_6b_encode   =  6'h5;
      32'h0000_0040:   f_IOMMU_onehot32_to_6b_encode   =  6'h6;
      32'h0000_0080:   f_IOMMU_onehot32_to_6b_encode   =  6'h7;
      32'h0000_0100:   f_IOMMU_onehot32_to_6b_encode   =  6'h8;
      32'h0000_0200:   f_IOMMU_onehot32_to_6b_encode   =  6'h9;
      32'h0000_0400:   f_IOMMU_onehot32_to_6b_encode   =  6'hA;
      32'h0000_0800:   f_IOMMU_onehot32_to_6b_encode   =  6'hB;
      32'h0000_1000:   f_IOMMU_onehot32_to_6b_encode   =  6'hC;
      32'h0000_2000:   f_IOMMU_onehot32_to_6b_encode   =  6'hD;
      32'h0000_4000:   f_IOMMU_onehot32_to_6b_encode   =  6'hE;
      32'h0000_8000:   f_IOMMU_onehot32_to_6b_encode   =  6'hF;
      32'h0001_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h10;
      32'h0002_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h11;
      32'h0004_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h12;
      32'h0008_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h13;
      32'h0010_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h14;
      32'h0020_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h15;
      32'h0040_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h16;
      32'h0080_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h17;
      32'h0100_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h18;
      32'h0200_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h19;
      32'h0400_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h1A;
      32'h0800_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h1B;
      32'h1000_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h1C;
      32'h2000_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h1D;
      32'h4000_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h1E;
      32'h8000_0000:   f_IOMMU_onehot32_to_6b_encode   =  6'h1F;
      default:         f_IOMMU_onehot32_to_6b_encode   =  6'h3F;
   endcase

endfunction


// Function to detect legal address width in context entry
//
// Inputs: AW:    Address width from context entry
//         SAGAW: Supported Adjusted Guest Address Width from capability register (CAP_REG)
//
// Output: 1 if AW in context entry is supported
//
function automatic logic f_IOMMU_Legal_Ctx_AW(logic [2:0] AW, logic [4:0] SAGAW);

   f_IOMMU_Legal_Ctx_AW = ((AW == 3'b000) && (SAGAW[0])) ||  // 2-level walk
                          ((AW == 3'b001) && (SAGAW[1])) ||  // 3-level walk
                          ((AW == 3'b010) && (SAGAW[2])) ||  // 4-level walk
                          ((AW == 3'b011) && (SAGAW[3])) ||  // 5-level walk
                          ((AW == 3'b100) && (SAGAW[4]));    // 6-level walk

endfunction

///=====================================================================================================================
/// FIND FIRST FUNCTIONS: All take a vector as the input and return a one-hot vector of the same width with the
///                       location of the first '1 in the given vector.  If no '1 is found, a vector of all
///                       all zeroes is returned.
///=====================================================================================================================

// Find first function - High to Low search for first '1 in 64-bit vector
function automatic logic [63:0] f_IOMMU_FINDFIRST1_HL_64(logic [63:0] A);
   f_IOMMU_FINDFIRST1_HL_64 = '0;
   for (int i=0;i<=63;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_64    = '0;
         f_IOMMU_FINDFIRST1_HL_64[i] = 1'b1;
      end
   end
endfunction

// Find first function - High to Low search for first '1 in 32-bit vector
function automatic logic [31:0] f_IOMMU_FINDFIRST1_HL_32(logic [31:0] A);
   f_IOMMU_FINDFIRST1_HL_32 = '0;
   for (int i=0;i<=31;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_32    = '0;
         f_IOMMU_FINDFIRST1_HL_32[i] = 1'b1;
      end
   end
endfunction

// Find first function - High to Low search for first '1 in 16-bit vector
function automatic logic [15:0] f_IOMMU_FINDFIRST1_HL_16(logic [15:0] A);
   f_IOMMU_FINDFIRST1_HL_16 = '0;
   for (int i=0;i<=15;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_16    = '0;
         f_IOMMU_FINDFIRST1_HL_16[i] = 1'b1;
      end
   end
endfunction

// Find first function - High to Low search for first '1 in 12-bit vector
/*function automatic logic [11:0] f_IOMMU_FINDFIRST1_HL_12(logic [11:0] A);
   // synopsys return_port_name  Z
   f_IOMMU_FINDFIRST1_HL_12 = '0;
   for (int i=0;i<=11;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_12    = '0;
         f_IOMMU_FINDFIRST1_HL_12[i] = 1'b1;
      end
   end
endfunction*/

// Find first function - High to Low search for first '1 in 8-bit vector
function automatic logic [7:0] f_IOMMU_FINDFIRST1_HL_8(logic [7:0] A);
   f_IOMMU_FINDFIRST1_HL_8 = '0;
   for (int i=0;i<=7;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_8    = '0;
         f_IOMMU_FINDFIRST1_HL_8[i] = 1'b1;
      end
   end
endfunction

// Find first function - High to Low search for first '1 in 6-bit vector
function automatic logic [5:0] f_IOMMU_FINDFIRST1_HL_6(logic [5:0] A);
   f_IOMMU_FINDFIRST1_HL_6 = '0;
   for (int i=0;i<=5;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_6    = '0;
         f_IOMMU_FINDFIRST1_HL_6[i] = 1'b1;
      end
   end
endfunction

// Find first function - High to Low search for first '1 in 4-bit vector
function automatic logic [3:0] f_IOMMU_FINDFIRST1_HL_4(logic [3:0] A);
   f_IOMMU_FINDFIRST1_HL_4 = '0;
   for (int i=0;i<=3;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_4    = '0;
         f_IOMMU_FINDFIRST1_HL_4[i] = 1'b1;
      end
   end
endfunction

// Find first function - High to Low search for first '1 in 3-bit vector
function automatic logic [2:0] f_IOMMU_FINDFIRST1_HL_3(logic [2:0] A);
   f_IOMMU_FINDFIRST1_HL_3 = '0;
   for (int i=0;i<=2;i++) begin
      if (A[i]) begin
         f_IOMMU_FINDFIRST1_HL_3    = '0;
         f_IOMMU_FINDFIRST1_HL_3[i] = 1'b1;
      end
   end
endfunction

///=====================================================================================================================
/// FIND FIRST FUNCTIONS: All take a vector as the input and return a one-hot vector of the same width with the
///                       location of the first '1 in the given vector.  If no '1 is found, a vector of all
///                       all zeroes is returned.
///                       These functions are all based on the analogous FINDFIRST1_HL functions, since the only
///                       difference is the input & output bit ordering.
///=====================================================================================================================

// Find first function - Low to High search for first '1 in 64-bit vector
function automatic logic [63:0] f_IOMMU_FINDFIRST1_LH_64(logic [63:0] A);
   logic [63:0] flipvec, outvec, flipout;
   for (int i=0; i<=63; i++) flipvec[i] = A[63-i];
   outvec = f_IOMMU_FINDFIRST1_HL_64(flipvec);
   for (int i=0; i<=63; i++) flipout[i] = outvec[63-i];
   f_IOMMU_FINDFIRST1_LH_64 = flipout;
endfunction

// Find first function - Low to High search for first '1 in 32-bit vector
function automatic logic [31:0] f_IOMMU_FINDFIRST1_LH_32(logic [31:0] A);
   logic [31:0] flipvec, outvec, flipout;
   for (int i=0; i<=31; i++) flipvec[i] = A[31-i];
   outvec = f_IOMMU_FINDFIRST1_HL_32(flipvec);
   for (int i=0; i<=31; i++) flipout[i] = outvec[31-i];
   f_IOMMU_FINDFIRST1_LH_32 = flipout;
endfunction

// Find first function - Low to High search for first '1 in 16-bit vector
function automatic logic [15:0] f_IOMMU_FINDFIRST1_LH_16(logic [15:0] A);
   logic [15:0] flipvec, outvec, flipout;
   for (int i=0; i<=15; i++) flipvec[i] = A[15-i];
   outvec = f_IOMMU_FINDFIRST1_HL_16(flipvec);
   for (int i=0; i<=15; i++) flipout[i] = outvec[15-i];
   f_IOMMU_FINDFIRST1_LH_16 = flipout;
endfunction

// Find first function - Low to High search for first '1 in 12-bit vector
/*function automatic logic [11:0] f_IOMMU_FINDFIRST1_LH_12(logic [11:0] A);
   logic [11:0] flipvec, outvec, flipout;
   for (int i=0; i<=11; i++) flipvec[i] = A[11-i];
   outvec = f_IOMMU_FINDFIRST1_HL_12(flipvec);
   for (int i=0; i<=11; i++) flipout[i] = outvec[11-i];
   f_IOMMU_FINDFIRST1_LH_12 = flipout;
endfunction*/

// Find first function - Low to High search for first '1 in 8-bit vector
function automatic logic [7:0] f_IOMMU_FINDFIRST1_LH_8(logic [7:0] A);
   logic [7:0] flipvec, outvec, flipout;
   for (int i=0; i<=7; i++) flipvec[i] = A[7-i];
   outvec = f_IOMMU_FINDFIRST1_HL_8(flipvec);
   for (int i=0; i<=7; i++) flipout[i] = outvec[7-i];
   f_IOMMU_FINDFIRST1_LH_8 = flipout;
endfunction

// Find first function - Low to High search for first '1 in 6-bit vector
function automatic logic [5:0] f_IOMMU_FINDFIRST1_LH_6(logic [5:0] A);
   logic [5:0] flipvec, outvec, flipout;
   for (int i=0; i<=5; i++) flipvec[i] = A[5-i];
   outvec = f_IOMMU_FINDFIRST1_HL_6(flipvec);
   for (int i=0; i<=5; i++) flipout[i] = outvec[5-i];
   f_IOMMU_FINDFIRST1_LH_6 = flipout;
endfunction

// Find first function - Low to High search for first '1 in 4-bit vector
function automatic logic [3:0] f_IOMMU_FINDFIRST1_LH_4(logic [3:0] A);
   logic [3:0] flipvec, outvec, flipout;
   for (int i=0; i<=3; i++) flipvec[i] = A[3-i];
   outvec = f_IOMMU_FINDFIRST1_HL_4(flipvec);
   for (int i=0; i<=3; i++) flipout[i] = outvec[3-i];
   f_IOMMU_FINDFIRST1_LH_4 = flipout;
endfunction

// Find first function - Low to High search for first '1 in 3-bit vector
function automatic logic [2:0] f_IOMMU_FINDFIRST1_LH_3(logic [2:0] A);
   logic [2:0] flipvec, outvec, flipout;
   for (int i=0; i<=2; i++) flipvec[i] = A[2-i];
   outvec = f_IOMMU_FINDFIRST1_HL_3(flipvec);
   for (int i=0; i<=2; i++) flipout[i] = outvec[2-i];
   f_IOMMU_FINDFIRST1_LH_3 = flipout;
endfunction

function automatic logic [31:0] f_DECODE_5_TO_32(logic [4:0] enc);
   unique casez (enc)
      5'b00000:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
      5'b00001:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
      5'b00010:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
      5'b00011:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
      5'b00100:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
      5'b00101:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0010_0000;
      5'b00110:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
      5'b00111:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_1000_0000;
      5'b01000:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0001_0000_0000;
      5'b01001:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0010_0000_0000;
      5'b01010:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0100_0000_0000;
      5'b01011:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_1000_0000_0000;
      5'b01100:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
      5'b01101:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0010_0000_0000_0000;
      5'b01110:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0100_0000_0000_0000;
      5'b01111:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
      5'b10000:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0001_0000_0000_0000_0000;
      5'b10001:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0010_0000_0000_0000_0000;
      5'b10010:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_0100_0000_0000_0000_0000;
      5'b10011:  f_DECODE_5_TO_32 = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
      5'b10100:  f_DECODE_5_TO_32 = 32'b0000_0000_0001_0000_0000_0000_0000_0000;
      5'b10101:  f_DECODE_5_TO_32 = 32'b0000_0000_0010_0000_0000_0000_0000_0000;
      5'b10110:  f_DECODE_5_TO_32 = 32'b0000_0000_0100_0000_0000_0000_0000_0000;
      5'b10111:  f_DECODE_5_TO_32 = 32'b0000_0000_1000_0000_0000_0000_0000_0000;
      5'b11000:  f_DECODE_5_TO_32 = 32'b0000_0001_0000_0000_0000_0000_0000_0000;
      5'b11001:  f_DECODE_5_TO_32 = 32'b0000_0010_0000_0000_0000_0000_0000_0000;
      5'b11010:  f_DECODE_5_TO_32 = 32'b0000_0100_0000_0000_0000_0000_0000_0000;
      5'b11011:  f_DECODE_5_TO_32 = 32'b0000_1000_0000_0000_0000_0000_0000_0000;
      5'b11100:  f_DECODE_5_TO_32 = 32'b0001_0000_0000_0000_0000_0000_0000_0000;
      5'b11101:  f_DECODE_5_TO_32 = 32'b0010_0000_0000_0000_0000_0000_0000_0000;
      5'b11110:  f_DECODE_5_TO_32 = 32'b0100_0000_0000_0000_0000_0000_0000_0000;
      5'b11111:  f_DECODE_5_TO_32 = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
      default:   f_DECODE_5_TO_32 = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
   endcase
endfunction

//======================================================================================================================
//                                               FPV Functions 
//======================================================================================================================
//
function automatic int f_DEVTLB_get_max_num_sets_across_all_ps_fv();
   
   int max_num_sets = 0;
   
   for(int ps = 0; ps <= 5; ps++) begin
      if(DEVTLB_TLB_NUM_PS_SETS[ps] > max_num_sets) begin
         max_num_sets = DEVTLB_TLB_NUM_PS_SETS[ps];
      end
   end
   
   return max_num_sets;
endfunction


//`endif // IOMMU_FUNCTIONS_VH
