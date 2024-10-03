# RTL modules for RCB/LCB/LCP

# Created from legacy macros (nhm_clocks etc), updated to use ctech
# Should be uniquified and consumed by IPs

# RCB
make_clk_and_rcb_ph1.sv   
make_clk_and_rcb_ph2_b.sv  
make_clk_and_rcb_free.sv  
make_clk_buf_rcb_ph1.sv   

# LCB
make_lcb_loc_and.sv    
make_lcb_loc_and_ph2_b.sv 

# LCB with LCP control
make_lcb_lcp_loc_and.sv    

# LCP module

make_slcp_msff.sv 

   
# Wrapper for build flow - do not use
   
rcb_lcb.sv           


# LCP update for 10nm
# Most recent legacy modules had 4 bit LCP, via struct e.g.

typedef struct packed {
    node Rd1;
    node Rd0;
    node Fd1;
    node Fd0;
} t_nhm_lcp;

# For 10nm moving back to 2 bit LCP
# RCB (LCB) modules that use LCP have 2 inputs "Fd" & Rd" 
