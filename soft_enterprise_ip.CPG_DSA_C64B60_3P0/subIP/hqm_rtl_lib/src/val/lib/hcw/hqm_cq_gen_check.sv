//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2018 Intel Corporation All Rights Reserved.
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

typedef struct {
  logic [127:0]       cache_line[3:0];
  bit     [3:0]       cache_line_valid;
  int                 next_cq_index;
  logic               gen[*]; // last generation value for each index
} cq_gen_t;

typedef struct {
  cq_gen_t      dir_cq_gen[hqm_pkg::NUM_DIR_CQ];
  cq_gen_t      ldb_cq_gen[hqm_pkg::NUM_LDB_CQ];
} cq_gen_info_t;

function void do_cq_gen_reset(ref cq_gen_info_t cq_gen_info);
  foreach (cq_gen_info.dir_cq_gen[i]) begin
  `ovm_info("HQM_BASE_TEST",$psprintf("DIR CQ %0d do_cq_gen_reset: reset cq_gen_info.dir_cq_gen",i),OVM_LOW)
    cq_gen_info.dir_cq_gen[i].next_cq_index       = 0;
    cq_gen_info.dir_cq_gen[i].cache_line_valid    = '0;
    cq_gen_info.dir_cq_gen[i].gen.delete();
  end
  foreach (cq_gen_info.ldb_cq_gen[i]) begin
  `ovm_info("HQM_BASE_TEST",$psprintf("LDB CQ %0d do_cq_gen_reset: reset cq_gen_info.ldb_cq_gen",i),OVM_LOW)
    cq_gen_info.ldb_cq_gen[i].next_cq_index       = 0;
    cq_gen_info.ldb_cq_gen[i].cache_line_valid    = '0;
    cq_gen_info.ldb_cq_gen[i].gen.delete();
  end
endfunction

function void do_cq_gen_vas_reset(ref cq_gen_info_t cq_gen_info, input int cq_type,int cq_num);
  if(cq_type) begin
   `ovm_info("HQM_BASE_TEST",$psprintf("LDB CQ 0x%0x do_cq_gen_vas_reset",cq_num),OVM_LOW)
    cq_gen_info.ldb_cq_gen[cq_num].next_cq_index       = 0;
    cq_gen_info.ldb_cq_gen[cq_num].cache_line_valid    = '0;
    cq_gen_info.ldb_cq_gen[cq_num].gen.delete();
  end else begin
   `ovm_info("HQM_BASE_TEST",$psprintf("DIR CQ 0x%0x do_cq_gen_vas_reset",cq_num),OVM_LOW)
    cq_gen_info.dir_cq_gen[cq_num].next_cq_index       = 0;
    cq_gen_info.dir_cq_gen[cq_num].cache_line_valid    = '0;
    cq_gen_info.dir_cq_gen[cq_num].gen.delete();
  end
endfunction

function bit cq_gen_check(ref cq_gen_info_t cq_gen_info, input int cq_type,int cq_num,int cq_index,int max_cq_index,int cq_gen,logic [127:0] hcw,bit cq_single_hcw_per_cl = 1'b0);
  if (cq_type) begin  // LDB CQ
    if (cq_gen_info.ldb_cq_gen[cq_num].gen.exists(cq_index)) begin
      if (cq_gen_info.ldb_cq_gen[cq_num].gen[cq_index] == cq_gen) begin
        if (cq_single_hcw_per_cl) begin
          `ovm_error("HQM_BASE_TEST",$psprintf("LDB CQ 0x%0x entry written with old gen value %0d - index = 0x%0x written HCW=0x%032x",cq_num,cq_index,cq_gen,hcw))
        end else begin
          if (cq_gen_info.ldb_cq_gen[cq_num].cache_line_valid[cq_index % 4] && (cq_gen_info.ldb_cq_gen[cq_num].cache_line[cq_index % 4] != hcw)) begin
             if(!$test$plusargs("HQM_BYPASS_CQ_CHECK")) begin
                `ovm_error("HQM_CQ_GEN_CHECK",$psprintf("LDB CQ 0x%0x entry rewritten with different data - index = 0x%0x written HCW=0x%032x expected HCW=0x%032x",
                                                 cq_num,cq_index,hcw,cq_gen_info.ldb_cq_gen[cq_num].cache_line[cq_index % 4]))
             end else begin
                `ovm_warning("HQM_CQ_GEN_CHECK",$psprintf("LDB CQ 0x%0x entry rewritten with different data - index = 0x%0x written HCW=0x%032x expected HCW=0x%032x, cq_gen=%0d",
                                                 cq_num,cq_index,hcw,cq_gen_info.ldb_cq_gen[cq_num].cache_line[cq_index % 4], cq_gen))
             end
          end
        end

        return(0);
      end
    end else begin
      if (cq_gen == 1'b0) begin  // if cq_index does not exist, treat as 0
        return(0);
      end
    end

    if (cq_gen_info.ldb_cq_gen[cq_num].next_cq_index != cq_index) begin
      if(!$test$plusargs("HQM_BYPASS_CQ_CHECK")) begin
      `ovm_error("HQM_CQ_GEN_CHECK",$psprintf("Non-consecutive LDB CQ 0x%0x entries written - expected index = 0x%0x  received index = 0x%0x",
                                           cq_num,cq_gen_info.ldb_cq_gen[cq_num].next_cq_index,cq_index))
      end else begin
      `ovm_warning("HQM_CQ_GEN_CHECK",$psprintf("Non-consecutive LDB CQ 0x%0x entries written - expected index = 0x%0x  received index = 0x%0x",
                                           cq_num,cq_gen_info.ldb_cq_gen[cq_num].next_cq_index,cq_index))
      end
      return(0);
    end else begin
      cq_gen_info.ldb_cq_gen[cq_num].gen[cq_index]                        = cq_gen;
      cq_gen_info.ldb_cq_gen[cq_num].cache_line[cq_index % 4]             = hcw;
      cq_gen_info.ldb_cq_gen[cq_num].cache_line_valid[cq_index % 4]       = 1'b1;
      if ((cq_index % 4) == 0) begin
        for (int i = 1 ; i < 4 ; i++) cq_gen_info.ldb_cq_gen[cq_num].cache_line_valid[i]  = 1'b0;
      end

      if (cq_index == max_cq_index) begin
        cq_gen_info.ldb_cq_gen[cq_num].next_cq_index = 0;
      end else begin
        cq_gen_info.ldb_cq_gen[cq_num].next_cq_index++;
      end
      `ovm_info("HQM_CQ_GEN_CHECK",$psprintf("LDB CQ 0x%0x entries written -  received index = 0x%0x cq_gen=%0d written HCW=0x%032x next_cq_index = 0x%0x",
                                           cq_num, cq_index, cq_gen, hcw, cq_gen_info.ldb_cq_gen[cq_num].next_cq_index),OVM_HIGH)
    end

    return(1);
  end else begin      // DIR CQ
    if (cq_gen_info.dir_cq_gen[cq_num].gen.exists(cq_index)) begin
      if (cq_gen_info.dir_cq_gen[cq_num].gen[cq_index] == cq_gen) begin
        if (cq_single_hcw_per_cl) begin
          `ovm_error("HQM_BASE_TEST",$psprintf("DIR CQ 0x%0x entry written with old gen value %0d - index = 0x%0x written HCW=0x%032x",cq_num,cq_index,cq_gen,hcw))
        end else begin
          if (cq_gen_info.dir_cq_gen[cq_num].cache_line_valid[cq_index % 4] && (cq_gen_info.dir_cq_gen[cq_num].cache_line[cq_index % 4] != hcw)) begin
             if(!$test$plusargs("HQM_BYPASS_CQ_CHECK")) begin
            `ovm_error("HQM_CQ_GEN_CHECK",$psprintf("DIR CQ 0x%0x entry rewritten with different data - index = 0x%0x written HCW=0x%032x expected HCW=0x%032x",
                                                 cq_num,cq_index,hcw,cq_gen_info.dir_cq_gen[cq_num].cache_line[cq_index % 4]))
             end else begin
            `ovm_warning("HQM_CQ_GEN_CHECK",$psprintf("DIR CQ 0x%0x entry rewritten with different data - index = 0x%0x written HCW=0x%032x expected HCW=0x%032x",
                                                 cq_num,cq_index,hcw,cq_gen_info.dir_cq_gen[cq_num].cache_line[cq_index % 4]))
             end
          end
        end

        return(0);
      end
    end else begin
      if (cq_gen == 1'b0) begin  // if cq_index does not exist, treat as 0
        return(0);
      end
    end

    if (cq_gen_info.dir_cq_gen[cq_num].next_cq_index != cq_index) begin
      if(!$test$plusargs("HQM_BYPASS_CQ_CHECK")) begin
      `ovm_error("HQM_CQ_GEN_CHECK",$psprintf("Non-consecutive DIR CQ 0x%0x entries written - expected index = 0x%0x  received index = 0x%0x",
                                           cq_num,cq_gen_info.dir_cq_gen[cq_num].next_cq_index,cq_index))
      end else begin
      `ovm_warning("HQM_CQ_GEN_CHECK",$psprintf("Non-consecutive DIR CQ 0x%0x entries written - expected index = 0x%0x  received index = 0x%0x",
                                           cq_num,cq_gen_info.dir_cq_gen[cq_num].next_cq_index,cq_index))
      end
      return(0);
    end else begin
      cq_gen_info.dir_cq_gen[cq_num].gen[cq_index]                = cq_gen;
      cq_gen_info.dir_cq_gen[cq_num].cache_line[cq_index % 4]     = hcw;
      cq_gen_info.dir_cq_gen[cq_num].cache_line_valid[cq_index % 4]       = 1'b1;
      if ((cq_index % 4) == 0) begin
        for (int i = 1 ; i < 4 ; i++) cq_gen_info.dir_cq_gen[cq_num].cache_line_valid[i]  = 1'b0;
      end

      if (cq_index == max_cq_index) begin
        cq_gen_info.dir_cq_gen[cq_num].next_cq_index = 0;
      end else begin
        cq_gen_info.dir_cq_gen[cq_num].next_cq_index++;
      end
      `ovm_info("HQM_CQ_GEN_CHECK",$psprintf("DIR CQ 0x%0x entries written -  received index = 0x%0x cq_gen=%0d written HCW=0x%032x next_cq_index = 0x%0x",
                                           cq_num, cq_index, cq_gen, hcw, cq_gen_info.dir_cq_gen[cq_num].next_cq_index),OVM_HIGH)
    end

    return(1);
  end
endfunction
