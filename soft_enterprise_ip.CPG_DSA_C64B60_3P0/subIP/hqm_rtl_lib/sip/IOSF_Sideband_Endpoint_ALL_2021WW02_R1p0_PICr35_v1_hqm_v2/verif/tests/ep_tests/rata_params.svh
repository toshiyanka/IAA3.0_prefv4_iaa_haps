`define SET_EP_PARAM(P,V1,V2) \
  `ifndef IS_RATA_ENV \
     parameter P = V1; \
  `else \
     parameter P = V2; \
  `endif \


`ifdef IS_RATA_ENV
parameter IS_RATA_ENV=1;
`else
parameter IS_RATA_ENV=0;
`endif
// defparam MAXPCTRGT=1;
