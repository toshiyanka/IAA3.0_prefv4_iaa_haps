//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
//-- hqm_tb_agitate
//-- This provides facility to force internal design signals to generate condtions which require very
//-- high simulation time.
//-----------------------------------------------------------------------------------------------------

module hqm_tb_agitate #(
        parameter NAME = "name",
        parameter PATH = "path",
        parameter VALUE = 1
) (
        input  logic    clk,
        input  bit      switch,      //-- 1 = Switch on agitation; 0 = Switch off agitation; --//
        input  bit      power
);

  initial begin


    chandle       handle;

    string        explode_q[$];

    int           agitate_state        = 0;
    bit           released             = 1;

    string        agitate_arg          = "";
    int           agitate_min_off      = 1;
    int           agitate_max_off      = 1;
    int           agitate_min_on       = 0;
    int           agitate_max_on       = 0;


    handle = SLA_VPI_get_handle_by_name(PATH,0);

    $value$plusargs({"agitate_",NAME,"=%s"},agitate_arg);

    explode_q.delete();
    lvm_common_pkg::explode(":",agitate_arg,explode_q);

    case (explode_q.size())
      0: begin
         end
      1: begin
           if (lvm_common_pkg::token_to_int(explode_q[0],agitate_min_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
           end else begin
             agitate_max_off   = agitate_min_off;
             agitate_min_on    = agitate_min_off;
             agitate_max_on    = agitate_min_off;
           end
         end
      2: begin
           if (lvm_common_pkg::token_to_int(explode_q[0],agitate_min_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
           end else begin
             agitate_min_on    = agitate_min_off;
  
             if (lvm_common_pkg::token_to_int(explode_q[1],agitate_max_off) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
             end else begin
               agitate_max_on    = agitate_max_off;
             end
           end
         end
      3: begin
           if (lvm_common_pkg::token_to_int(explode_q[0],agitate_min_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
           end else begin
             if (lvm_common_pkg::token_to_int(explode_q[1],agitate_max_off) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
             end else begin
               if (lvm_common_pkg::token_to_int(explode_q[2],agitate_min_on) == 0) begin
                 `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
               end else begin
                 agitate_max_on    = agitate_min_on;
               end
             end
           end
         end
      default: begin
           if (lvm_common_pkg::token_to_int(explode_q[0],agitate_min_off) == 0) begin
             `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
           end else begin
             if (lvm_common_pkg::token_to_int(explode_q[1],agitate_max_off) == 0) begin
               `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
             end else begin
               if (lvm_common_pkg::token_to_int(explode_q[2],agitate_min_on) == 0) begin
                 `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
               end else begin
                 if (lvm_common_pkg::token_to_int(explode_q[3],agitate_max_on) == 0) begin
                   `ovm_error("HQM_TB_TOP",$psprintf("illegal argument for agitate - %s",agitate_arg))
                 end
               end
             end
           end
         end
    endcase

    agitate_state = $urandom_range(agitate_max_off,agitate_min_off);
  
    forever begin
      @(posedge clk); 
      #0.1;
      if (power == 0) begin
        continue;
      end
      if (switch == 0) begin
        if (released == 0) begin
          SLA_VPI_release_value(handle, 1);
          released = 1;
        end
      end
      else if (switch == 1) begin
        if (agitate_state > 0) begin
          agitate_state--;
  
          if (agitate_state == 0) begin
            agitate_state = -$urandom_range(agitate_max_on,agitate_min_on);
  
            if (agitate_state < 0) begin
              SLA_VPI_force_value(handle, VALUE);
              released = 0;
            end
          end
        end else if (agitate_state < 0) begin
          agitate_state++;
  
          if (agitate_state == 0) begin
            agitate_state = $urandom_range(agitate_max_off,agitate_min_off);
  
            if (agitate_state > 0) begin
              SLA_VPI_release_value(handle, 1);
              released = 1;
            end
          end
        end
      end
    end
  end

endmodule

