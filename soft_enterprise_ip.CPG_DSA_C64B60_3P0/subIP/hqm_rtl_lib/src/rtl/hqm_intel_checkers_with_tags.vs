`ifndef INTEL_SVA_OFF

// Enforcing the hirarchical tags methodology: (highest) SDG_SVA_SILICON->SDG_SVA_FPGA->SDG_SVA_EMULATION->SDG_SVA_SOC_SIM->SDG_SVA_NON_LEAF_IP->SDG_SVA_LEAF (lowest)
`ifdef SDG_SVA_LEAF
    `define SDG_SVA_SILICON
    `define SDG_SVA_FPGA
    `define SDG_SVA_EMULATION
    `define SDG_SVA_SOC_SIM
    `define SDG_SVA_NON_LEAF_IP
`endif

`ifdef SDG_SVA_NON_LEAF_IP
    `define SDG_SVA_SILICON
    `define SDG_SVA_FPGA
    `define SDG_SVA_EMULATION
    `define SDG_SVA_SOC_SIM
`endif

`ifdef SDG_SVA_SOC_SIM
    `define SDG_SVA_SILICON
    `define SDG_SVA_FPGA
    `define SDG_SVA_EMULATION
`endif

`ifdef SDG_SVA_EMULATION
    `define SDG_SVA_SILICON
    `define SDG_SVA_FPGA
`endif

`ifdef SDG_SVA_FPGA
    `define SDG_SVA_SILICON
`endif


`define HQM_SDG_ASSERTC_MUTEXED(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_MUTEXED (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_MUTEXED(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_MUTEXED (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_MUTEXED(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_MUTEXED (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_MUTEXED(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_MUTEXED (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_MUTEXED(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_MUTEXED (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_MUTEXED(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_MUTEXED (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_MUTEXED_COVERC(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_MUTEXED_COVERC (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_MUTEXED_COVERS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_MUTEXED_COVERS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_ONE_HOT(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_ONE_HOT (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_ONE_HOT(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_ONE_HOT (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_ONE_HOT(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_ONE_HOT (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_ONE_HOT(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_ONE_HOT (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_ONE_HOT(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_ONE_HOT (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_ONE_HOT(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_ONE_HOT (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_ONE_HOT_COVERC(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_ONE_HOT_COVERC (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_ONE_HOT_COVERS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_ONE_HOT_COVERS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_SAME_BITS(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_SAME_BITS (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_SAME_BITS(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_SAME_BITS (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_SAME_BITS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_SAME_BITS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_SAME_BITS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_SAME_BITS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_SAME_BITS(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_SAME_BITS (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_SAME_BITS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_SAME_BITS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_SAME_BITS_COVERS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_SAME_BITS_COVERS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_SAME_BITS_COVERC(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_SAME_BITS_COVERC (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_RANGE(name, sig, low, high, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_RANGE (name, sig, low, high, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_RANGE(name, sig, low, high, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_RANGE (name, sig, low, high, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_RANGE(name, sig, low, high, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_RANGE (name, sig, low, high, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_RANGE(name, sig, low, high, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_RANGE (name, sig, low, high, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_RANGE(name, sig, low, high, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_RANGE (name, sig, low, high, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_RANGE(name, sig, low, high, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_RANGE (name, sig, low, high, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_RANGE_COVERS(name, sig, low, high, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_RANGE_COVERS (name, sig, low, high, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_RANGE_COVERC(name, sig, low, high, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_RANGE_COVERC (name, sig, low, high, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_AT_MOST_BITS_HIGH (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_AT_MOST_BITS_HIGH (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_AT_MOST_BITS_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_AT_MOST_BITS_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_AT_MOST_BITS_HIGH(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_AT_MOST_BITS_HIGH (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_AT_MOST_BITS_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_AT_MOST_BITS_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_AT_MOST_BITS_HIGH_COVERS(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_AT_MOST_BITS_HIGH_COVERS (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_AT_MOST_BITS_HIGH_COVERC(name ,sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_AT_MOST_BITS_HIGH_COVERC (name ,sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_BITS_HIGH(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_BITS_HIGH (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_BITS_HIGH(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_BITS_HIGH (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_BITS_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_BITS_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_BITS_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_BITS_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_BITS_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_BITS_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_BITS_HIGH(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_BITS_HIGH (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_BITS_HIGH_COVERS(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_BITS_HIGH_COVERS (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_BITS_HIGH_COVERC(name ,sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_BITS_HIGH_COVERC (name ,sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_ONE_OF(name, sig, set, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_ONE_OF (name, sig, set, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_ONE_OF(name, sig, set, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_ONE_OF (name, sig, set, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_ONE_OF(name, sig, set, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_ONE_OF (name, sig, set, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_ONE_OF_COVERC(name ,sig, set, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_ONE_OF_COVERC (name ,sig, set, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_KNOWN_DRIVEN(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_KNOWN_DRIVEN (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_KNOWN_DRIVEN(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_KNOWN_DRIVEN (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_KNOWN_DRIVEN (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_KNOWN_DRIVEN(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_KNOWN_DRIVEN (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_KNOWN_DRIVEN(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_KNOWN_DRIVEN (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_KNOWN_DRIVEN(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_KNOWN_DRIVEN (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_KNOWN_DRIVEN_COVERS(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_KNOWN_DRIVEN_COVERS (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_KNOWN_DRIVEN_COVERC(name, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_KNOWN_DRIVEN_COVERC (name, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_SAME(name, siga, sigb, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_SAME (name, siga, sigb, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_SAME(name, siga, sigb, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_SAME (name, siga, sigb, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_SAME(name, siga, sigb, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_SAME (name, siga, sigb, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_SAME(name, siga, sigb, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_SAME (name, siga, sigb, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_SAME(name, siga, sigb, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_SAME (name, siga, sigb, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_SAME(name, siga, sigb, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_SAME (name, siga, sigb, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_SAME_COVERC(name, siga, sigb, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_SAME_COVERC (name, siga, sigb, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_SAME_COVERS(name, siga, sigb, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_SAME_COVERS (name, siga, sigb, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_MUST(name, prop, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_MUST (name, prop, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_MUST(name, prop, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_MUST (name, prop, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_MUST(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_MUST (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_MUST(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_MUST (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_FORBIDDEN(name, cond, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_FORBIDDEN (name, cond, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_FORBIDDEN(name, cond, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_FORBIDDEN (name, cond, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_FORBIDDEN(name, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_FORBIDDEN (name, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_FORBIDDEN (name, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_MIN(name, sig, min_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_MIN (name, sig, min_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_MIN(name, sig, min_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_MIN (name, sig, min_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_MIN(name, sig, min_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_MIN (name, sig, min_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_MIN(name, sig, min_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_MIN (name, sig, min_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_MIN(name, sig, min_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_MIN (name, sig, min_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_MIN(name, sig, min_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_MIN (name, sig, min_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_MIN_COVERS(name ,sig, min_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_MIN_COVERS (name ,sig, min_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_MIN_COVERC(name, sig, min_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_MIN_COVERC (name, sig, min_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_MAX(name, sig, max_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_MAX (name, sig, max_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_MAX(name, sig, max_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_MAX (name, sig, max_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_MAX(name, sig, max_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_MAX (name, sig, max_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_MAX(name, sig, max_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_MAX (name, sig, max_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_MAX(name, sig, max_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_MAX (name, sig, max_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_MAX(name, sig, max_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_MAX (name, sig, max_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_MAX_COVERS(name ,sig, max_val, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_MAX_COVERS (name ,sig, max_val, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_MAX_COVERC(name, sig, max_val, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_MAX_COVERC (name, sig, max_val, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_AT_MOST_BITS_LOW (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_AT_MOST_BITS_LOW (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_AT_MOST_BITS_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_AT_MOST_BITS_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_AT_MOST_BITS_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_AT_MOST_BITS_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_AT_MOST_BITS_LOW(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_AT_MOST_BITS_LOW (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_AT_MOST_BITS_LOW_COVERS(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_AT_MOST_BITS_LOW_COVERS (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_AT_MOST_BITS_LOW_COVERC(name ,sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_AT_MOST_BITS_LOW_COVERC (name ,sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_BITS_LOW(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_BITS_LOW (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_BITS_LOW(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_BITS_LOW (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_BITS_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_BITS_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_BITS_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_BITS_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_BITS_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_BITS_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERC_BITS_LOW(name, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERC_BITS_LOW (name, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_BITS_LOW_COVERS(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_BITS_LOW_COVERS (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_NOT_BITS_LOW_COVERC(name ,sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_NOT_BITS_LOW_COVERC (name ,sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_COVERS_ENABLE(name, en, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_COVERS_ENABLE (name, en, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_FIRE(name, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_FIRE (name, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTC_TRIGGER(name, trig, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTC_TRIGGER (name, trig, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_TRIGGER(name, trig, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_TRIGGER (name, trig, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMEC_TRIGGER(name, trig, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMEC_TRIGGER (name, trig, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_TRIGGER(name, trig, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_TRIGGER (name, trig, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_DELAYED_TRIGGER (name, trig, delay, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_DELAYED_TRIGGER(name, trig, delay, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_DELAYED_TRIGGER (name, trig, delay, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_NEVER(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_NEVER (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_NEVER(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_NEVER (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_EVENTUALLY_HOLDS(name, en, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_EVENTUALLY_HOLDS (name, en, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_EVENTUALLY_HOLDS(name, en, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_EVENTUALLY_HOLDS (name, en, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_BETWEEN(name, start_ev, end_ev, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_BETWEEN (name, start_ev, end_ev, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_BETWEEN(name, start_ev, end_ev, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_BETWEEN (name, start_ev, end_ev, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_BETWEEN_TIME(name, trig, start_time, end_time, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_BETWEEN_TIME (name, trig, start_time, end_time, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_BETWEEN_TIME(name, trig, start_time, end_time, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_BETWEEN_TIME (name, trig, start_time, end_time, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_NEXT_EVENT(name, en, ev, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_NEXT_EVENT (name, en, ev, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_NEXT_EVENT(name, en, ev, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_NEXT_EVENT (name, en, ev, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_BEFORE_EVENT(name, en, first, second, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_BEFORE_EVENT (name, en, first, second, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_BEFORE_EVENT(name, en, first, second, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_BEFORE_EVENT (name, en, first, second, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_REMAIN_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_REMAIN_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_REMAIN_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_REMAIN_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GREMAIN_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GREMAIN_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GREMAIN_HIGH(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GREMAIN_HIGH (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_REMAIN_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_REMAIN_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_REMAIN_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_REMAIN_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GREMAIN_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GREMAIN_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GREMAIN_LOW(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GREMAIN_LOW (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GREMAIN_HIGH_AT_MOST(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GREMAIN_HIGH_AT_MOST (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GREMAIN_HIGH_AT_MOST(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GREMAIN_HIGH_AT_MOST (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_VERIFY(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_VERIFY (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_VERIFY(name, prop, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_VERIFY (name, prop, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_REQ_GRANTED(name, req, gnt, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_REQ_GRANTED (name, req, gnt, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_REQ_GRANTED(name, req, gnt, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_REQ_GRANTED (name, req, gnt, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_CONT_REQ_GRANTED(name, req, gnt, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_CONT_REQ_GRANTED (name, req, gnt, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_CONT_REQ_GRANTED(name, req, gnt, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_CONT_REQ_GRANTED (name, req, gnt, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_REQ_GRANTED_WITHIN(name, req, min, max, gnt, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_REQ_GRANTED_WITHIN (name, req, min, max, gnt, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_REQ_GRANTED_WITHIN(name, req, min, max, gnt, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_REQ_GRANTED_WITHIN (name, req, min, max, gnt, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_UNTIL_STRONG(name, start_ev, cond, end_ev, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_UNTIL_STRONG (name, start_ev, cond, end_ev, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_UNTIL_STRONG(name, start_ev, cond, end_ev, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_UNTIL_STRONG (name, start_ev, cond, end_ev, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_UNTIL_WEAK(name, start_ev, cond, end_ev, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_UNTIL_WEAK (name, start_ev, cond, end_ev, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_UNTIL_WEAK(name, start_ev, cond, end_ev, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_UNTIL_WEAK (name, start_ev, cond, end_ev, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_RECUR_TRIGGERS(name, trig, n, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_RECUR_TRIGGERS (name, trig, n, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_RECUR_TRIGGERS(name, trig, n, cond, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_RECUR_TRIGGERS (name, trig, n, cond, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_DATA_TRANSFER(name, start_ev, start_data, end_ev, end_data, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_DATA_TRANSFER (name, start_ev, start_data, end_ev, end_data, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_DATA_TRANSFER(name, start_ev, start_data, end_ev, end_data, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_DATA_TRANSFER (name, start_ev, start_data, end_ev, end_data, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GRAY_CODE(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GRAY_CODE (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GRAY_CODE(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GRAY_CODE (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_CLOCK_TICKING(name, clk, gclk, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_CLOCK_TICKING (name, clk, gclk, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_CLOCK_TICKING(name, clk, gclk, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_CLOCK_TICKING (name, clk, gclk, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_RIGID(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_RIGID (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_RIGID(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_RIGID (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_STABLE(name, sig, start_ev, end_ev, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_STABLE (name, sig, start_ev, end_ev, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_STABLE(name, sig, start_ev, end_ev, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_STABLE (name, sig, start_ev, end_ev, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GSTABLE(name, sig, start_ev, end_ev, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GSTABLE (name, sig, start_ev, end_ev, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GSTABLE(name, sig, start_ev, end_ev, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GSTABLE (name, sig, start_ev, end_ev, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERT_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst, TAG) \
  `ifdef TAG \
    `HQM_ASSERT_STABLE_POSEDGE (sig, start_ev, end_ev, clk, rst); \
  `endif //TAG

`define HQM_SDG_ASSUME_STABLE_POSEDGE(sig, start_ev, end_ev, clk, rst, TAG) \
  `ifdef TAG \
    `HQM_ASSUME_STABLE_POSEDGE (sig, start_ev, end_ev, clk, rst); \
  `endif //TAG

`define HQM_SDG_ASSERT_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst, TAG) \
  `ifdef TAG \
    `HQM_ASSERT_STABLE_NEGEDGE (sig, start_ev, end_ev, clk, rst); \
  `endif //TAG

`define HQM_SDG_ASSUME_STABLE_NEGEDGE(sig, start_ev, end_ev, clk, rst, TAG) \
  `ifdef TAG \
    `HQM_ASSUME_STABLE_NEGEDGE (sig, start_ev, end_ev, clk, rst); \
  `endif //TAG

`define HQM_SDG_ASSERT_STABLE_EDGE(sig, start_ev, end_ev, clk, rst, TAG) \
  `ifdef TAG \
    `HQM_ASSERT_STABLE_EDGE (sig, start_ev, end_ev, clk, rst); \
  `endif //TAG

`define HQM_SDG_ASSUME_STABLE_EDGE(sig, start_ev, end_ev, clk, rst, TAG) \
  `ifdef TAG \
    `HQM_ASSUME_STABLE_EDGE (sig, start_ev, end_ev, clk, rst); \
  `endif //TAG

`define HQM_SDG_ASSERTS_STABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_STABLE_WINDOW (name, sample, sig, clks_before, clks_after, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_STABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_STABLE_WINDOW (name, sample, sig, clks_before, clks_after, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GSTABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GSTABLE_WINDOW (name, sample, sig, clks_before, clks_after, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GSTABLE_WINDOW(name, sample, sig, clks_before, clks_after, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GSTABLE_WINDOW (name, sample, sig, clks_before, clks_after, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_STABLE_FOR(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_STABLE_FOR (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_STABLE_FOR(name, sig, n, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_STABLE_FOR (name, sig, n, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GSTABLE_FOR(name, sig, n, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GSTABLE_FOR (name, sig, n, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GSTABLE_FOR(name, sig, n, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GSTABLE_FOR (name, sig, n, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_STABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_STABLE_AFTER (name, sample, sig, clks_after, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_STABLE_AFTER(name, sample, sig, clks_after, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_STABLE_AFTER (name, sample, sig, clks_after, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GSTABLE_AFTER(name, sample, sig, clks_after, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GSTABLE_AFTER (name, sample, sig, clks_after, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GSTABLE_AFTER(name, sample, sig, clks_after, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GSTABLE_AFTER (name, sample, sig, clks_after, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_GSTABLE_BETWEEN_TICKS(name, sig, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_GSTABLE_BETWEEN_TICKS (name, sig, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_GSTABLE_BETWEEN_TICKS(name, sig, clk, gclk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_GSTABLE_BETWEEN_TICKS (name, sig, clk, gclk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_STABLE_BETWEEN_TICKS_POSEDGE(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_STABLE_BETWEEN_TICKS_POSEDGE (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_STABLE_BETWEEN_TICKS_POSEDGE(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_STABLE_BETWEEN_TICKS_POSEDGE (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTS_STABLE_BETWEEN_TICKS_NEGEDGE(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTS_STABLE_BETWEEN_TICKS_NEGEDGE (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSUMES_STABLE_BETWEEN_TICKS_NEGEDGE(name, sig, clk, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSUMES_STABLE_BETWEEN_TICKS_NEGEDGE (name, sig, clk, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_MUTEXED(fire, label, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_MUTEXED (fire, label, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_ONE_HOT(fire, label, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_ONE_HOT (fire, label, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_SAME_BITS(fire, label, sig, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_SAME_BITS (fire, label, sig, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_AT_MOST_BITS_HIGH(fire, label, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_AT_MOST_BITS_HIGH (fire, label, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_BITS_HIGH(fire, label, sig, n, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_BITS_HIGH (fire, label, sig, n, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_FORBIDDEN(fire, label, prop, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_FORBIDDEN (fire, label, prop, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_MUST(fire, label, prop, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_MUST (fire, label, prop, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERTH_SAME(fire, label, siga, sigb, rst, MSG, TAG) \
  `ifdef TAG \
    `HQM_ASSERTH_SAME (fire, label, siga, sigb, rst, MSG); \
  `endif //TAG

`define HQM_SDG_ASSERT_SIGNAL_IS_PH2(clk,sig,constr_name, TAG) \
  `ifdef TAG \
    `HQM_ASSERT_SIGNAL_IS_PH2 (clk,sig,constr_name); \
  `endif //TAG

`define HQM_SDG_ASSERT_SIGNAL_IS_PH1(clk,sig,constr_name, TAG) \
  `ifdef TAG \
    `HQM_ASSERT_SIGNAL_IS_PH1 (clk,sig,constr_name); \
  `endif //TAG


`endif // INTEL_SVA_OFF
