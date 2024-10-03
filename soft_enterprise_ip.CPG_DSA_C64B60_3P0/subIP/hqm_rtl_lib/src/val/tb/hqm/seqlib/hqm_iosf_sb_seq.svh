//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  IOSF_SVC_2016WW05
//
//------------------------------------------------------------------------------
`ifndef INC_hqm_iosf_sb_seq
`define INC_hqm_iosf_sb_seq 

typedef enum opcode_t {
    OP_SETIDVALUE     = 8'b0110_0111} hqm_opcode_e; //8'h67

/**
 * Sequence to send xactions using ovm_do_on_with macro or
 * with send_xaction API
 */
//class hqm_iosf_sb_seq extends iosf_sb_seq;
typedef class hqm_iosf_sb_seq;
class hqm_iosf_sb_seq extends base_seq;
  // ============================================================================
  // Data members 
  // ============================================================================

  iosfsbm_cm::comp_xaction rx_compl_xaction;

  iosfsbm_cm::simple_xaction simple_txn;
  iosfsbm_cm::msgd_xaction msgd_txn;
  iosfsbm_cm::regio_xaction regio_txn;
  iosfsbm_cm::comp_xaction comp_txn;
  iosfsbm_cm::xaction req;
  rand iosfsbm_cm::xaction_class_e xaction_class_i;
  rand iosfsbm_cm::xaction_type_e xaction_type_i;
  rand iosfsbm_cm::pid_t src_pid_i;
  rand iosfsbm_cm::pid_t dest_pid_i;
  rand iosfsbm_cm::opcode_t opcode_i;
  rand iosfsbm_cm::flit_t data_i[];
  rand iosfsbm_cm::flit_t addr_i[];
  rand iosfsbm_cm::tag_t tag_i;
  rand bit[1:0] rsp_i;
  rand bit[3:0] fbe_i;
  rand bit[3:0] sbe_i;
  rand bit[7:0] fid_i;
  rand bit[2:0] bar_i;
  rand bit[3:0] misc_i;
  rand bit[3:0] xaction_delay_i;
  rand bit exp_rsp_i;
  rand int unsigned xact_id;
  rand bit compare_completion_i;
  rand iosfsbm_cm::flit_t exp_data_i[];
  rand bit eh_i;
  rand flit_t ext_headers_i[];
  rand int data_size_dw;
  rand bit parity_err_i; 

  // Meta data
  ep_cfg m_ep_cfg;
  local common_cfg m_common_cfg;
  local iosfsbm_cm::xaction_type_e xtype;
  local bit [15:0] m_sai_value;

  //Constraints
  constraint src_pid_range;
  constraint fe_with_mcast_bcast_nposted;
  constraint dest_pid_range;
  constraint no_read_with_bcast_mcast;
  constraint opcode_range;
  constraint supported_opcode_for_dest_pid;
  constraint dest_pid_neq_src_pid;
  constraint set_xaction_class;
  constraint opcode_value_083;
  constraint opcode_value_12;
  constraint bar_range;
  constraint fid_value_082;
  constraint misc_field_value;
  constraint set_xaction_type;
  constraint set_eh_field;
  constraint data_size_range;
  constraint addr_size_range;
  constraint addr_value;
  constraint class_value;
  constraint parity_err_con;
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name="",
                      ovm_sequencer_base sequencer = null,
		      ovm_sequence#(iosfsbm_cm::xaction,iosfsbm_cm::xaction) parent_seq = null);      
  extern task body();
  extern function void pre_randomize();
  extern function void post_randomize();
  
  // ============================================================================
  // APIs 
  // ============================================================================
  extern task send_xaction (
  input iosfsbm_cm::iosfsbc_sequencer  iosfsbc_seqr,                           
  input iosfsbm_cm::xaction_class_e xaction_class_i,
  input iosfsbm_cm::pid_t src_pid_i,
  input iosfsbm_cm::pid_t dest_pid_i,
  input iosfsbm_cm::opcode_t opcode_i,
  input iosfsbm_cm::tag_t tag_i,
  `ifndef MODEL_TECH                                
  input iosfsbm_cm::flit_t addr_i[]='{},                      
  input iosfsbm_cm::flit_t data_i[]='{}, 
  `else
  input iosfsbm_cm::flit_t addr_i[]=null,
  input iosfsbm_cm::flit_t data_i[]=null,                            
  `endif                              
  input bit[3:0] fbe_i = 4'h0,  
  input bit[3:0] sbe_i = 4'h0,  
  input bit[7:0] fid_i = 8'h00,  
  input bit[2:0] bar_i = 4'h0,                         
  input bit[3:0] misc_i = 4'h0,
  input bit[3:0] xaction_delay_i=0,     
  input int unsigned xact_id = 0,
  input bit exp_rsp_i = 0,
  `ifndef MODEL_TECH   
  iosfsbm_cm::flit_t exp_data_i[]='{},
  `else
  iosfsbm_cm::flit_t exp_data_i[]=null,
  `endif                         
  input bit compare_completion_i=1'b0,
  input bit[1:0] rsp_i = 2'b00,
  input bit eh_i=0,
  `ifndef MODEL_TECH                                                                 
  input flit_t ext_headers_i[] = '{},
  `else
  input flit_t ext_headers_i[] = null,
  `endif                                                               
  input bit parity_err_i = 0                                                                    
  );

 `ovm_sequence_utils(hqm_iosf_sb_seq, iosfsbm_cm::iosfsbc_sequencer);
    
endclass :hqm_iosf_sb_seq

/**
 * Map allowed source PID range. 
 */
constraint hqm_iosf_sb_seq::src_pid_range {
  src_pid_i inside {m_ep_cfg.my_ports, 8'hfe};
  ! (src_pid_i inside {m_common_cfg.mcast_ports});
}

/**
 * Map allowed dest PID range. 
 */
constraint hqm_iosf_sb_seq::dest_pid_range {
  dest_pid_i inside {m_common_cfg.all_ports, 8'hff}; //edited
  ! (dest_pid_i inside {m_ep_cfg.my_ports});
}

/**
 * Map multicast part 2.
 */
constraint hqm_iosf_sb_seq::fe_with_mcast_bcast_nposted {
  (src_pid_i == 8'hFE) -> (dest_pid_i inside {m_common_cfg.mcast_ports, 8'hFF}); 
  (src_pid_i == 8'hFE) -> (xaction_class_i == iosfsbm_cm::NON_POSTED);
}

/**
 * Cannot have nonposted read register broadcast/multicast requests 
 */
constraint hqm_iosf_sb_seq::no_read_with_bcast_mcast {
  (dest_pid_i inside {m_common_cfg.mcast_ports, 8'hFF}) -> 
                                              ((opcode_i != OP_IORD) && 
                                               (opcode_i != OP_CFGRD) && 
                                               (opcode_i !=OP_CRRD) && 
                                               (opcode_i != OP_MRD)) ;                 
}

/** 
 * Set EH field
 */
constraint hqm_iosf_sb_seq::set_eh_field {
  (m_ep_cfg.ext_header_support && 
   (m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_090) &&
   (!m_ep_cfg.ctrl_ext_header_support && !m_ep_cfg.ext_headers_per_txn)) -> (eh_i==1'b1);

  (m_ep_cfg.rs_support && 
   (m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_11) &&
   (!m_ep_cfg.ctrl_ext_header_support && !m_ep_cfg.ext_headers_per_txn)) -> (eh_i==1'b1);
                                      
  (!m_ep_cfg.ext_header_support && !m_ep_cfg.rs_support) -> (eh_i==1'b0);
                                      
  (m_ep_cfg.iosfsb_spec_rev < iosfsbm_cm::IOSF_090) -> (eh_i == 1'b0);                                               
}
                    
/**
 * Map opcode.
 */
constraint hqm_iosf_sb_seq::opcode_range {
  (xaction_type_i == iosfsbm_cm::SIMPLE)  -> opcode_i inside {[iosfsbm_cm::SIMPLE_GLOBAL_OPCODE_START:iosfsbm_cm::SIMPLE_EPSPEC_OPCODE_END]};
  (xaction_type_i == iosfsbm_cm::MSGD)    -> opcode_i inside {[iosfsbm_cm::MSGD_GLOBAL_OPCODE_START:iosfsbm_cm::MSGD_EPSPEC_OPCODE_END]} || opcode_i  inside {[iosfsbm_cm::OP_BOOTPREP:iosfsbm_cm::OP_FORCE_PWRGATE_POK]}; 
  (xaction_type_i == iosfsbm_cm::REGIO)   -> opcode_i inside {[iosfsbm_cm::REGIO_GLOBAL_OPCODE_START:iosfsbm_cm::REGIO_EPSPEC_OPCODE_END]};
  (xaction_type_i == iosfsbm_cm::COMP)   -> opcode_i inside {[iosfsbm_cm::OP_CMP:iosfsbm_cm::OP_CMPD]}; 
}



constraint hqm_iosf_sb_seq::data_size_range {
if ((opcode_i[0] == 0) && (xaction_type_i == iosfsbm_cm::REGIO)) (data_i.size == 0);
else if ((opcode_i[0] == 1) && (xaction_type_i == iosfsbm_cm::REGIO) && (sbe_i != 4'b0)) (data_i.size == 8);
else if ((opcode_i[0] == 1) && (xaction_type_i == iosfsbm_cm::REGIO) && (sbe_i == 4'b0)) (data_i.size == 4); 
else if ((opcode_i inside {OP_PM_REQ,OP_PM_DMD,OP_PM_RSP}) && (xaction_type_i == iosfsbm_cm::MSGD)) (data_i.size == 8);

else if ((opcode_i == OP_LTR) && 
        (m_ep_cfg.iosfsb_spec_rev >= IOSF_1) && 
        (xaction_type_i == iosfsbm_cm::MSGD))

    (data_i.size == 4); 
                                      
else if ((opcode_i == iosfsbm_cm::OP_CMPD)&& 
          (xaction_type_i == iosfsbm_cm::COMP)) 

    (data_i.size inside { [1:m_ep_cfg.m_max_data_size], [1:20]});

else if ((opcode_i == iosfsbm_cm::OP_CMP)&& 
          (xaction_type_i == iosfsbm_cm::COMP)) 

    (data_i.size inside {0});

else   
    data_size_dw dist { 1:=1, 2:=1, 3:=1, 4:=1, [5:15]:/5, 16:=1, [17:m_ep_cfg.m_max_data_size]:=1 };
    data_i.size == data_size_dw * 4;
  

}

constraint hqm_iosf_sb_seq::addr_size_range {
 if((opcode_i inside {iosfsbm_cm::OP_IORD, 
                  iosfsbm_cm::OP_IOWR, 
                  iosfsbm_cm::OP_CFGRD, 
                  iosfsbm_cm::OP_CFGWR}) && (xaction_type_i == iosfsbm_cm::REGIO)) 
     addr_i.size == 2;
                                   
  else 
     addr_i.size inside {2, 6}; 
}



constraint hqm_iosf_sb_seq::addr_value {
 (xaction_type_i == iosfsbm_cm::REGIO) && (opcode_i inside {iosfsbm_cm::OP_CFGRD, iosfsbm_cm::OP_CFGWR}) 
                    -> (addr_i[0][1] == 1'b0) && (addr_i[1][7:4] == 4'b0000);
 (xaction_type_i == iosfsbm_cm::REGIO) &&  (sbe_i != 4'b0 ) -> (addr_i[0][2] == 0); 
 (xaction_type_i == iosfsbm_cm::REGIO) &&  ((opcode_i inside   { iosfsbm_cm::OP_IORD, 
                                                                 iosfsbm_cm::OP_MRD, 
                  						 iosfsbm_cm::OP_IOWR, 
                 						 iosfsbm_cm::OP_MWR}) 
    &&  (m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_083))  -> (addr_i[0][1:0] == 2'b0);


 (xaction_type_i == iosfsbm_cm::REGIO) && ((m_ep_cfg.iosfsb_spec_rev >= IOSF_11)
 && (opcode_i inside {iosfsbm_cm::OP_CRRD,iosfsbm_cm::OP_CRWR}))
                     -> (addr_i[0][1:0] == 2'b0);
}

constraint hqm_iosf_sb_seq::class_value {
  (opcode_i inside {
                  OP_PM_REQ, 
                  OP_PM_DMD, 
                  OP_PM_RSP,
                  `ifdef SVC_USE_OLD_OPCODE
                  OP_PCI_PM, 
                  `else
                  OP_PCIE_PM,
                  `endif
                  OP_PCI_ERROR,
                  OP_LTR,
                  OP_DOPME,
                  OP_PMON,
                  OP_MCA,
                  OP_SYNCSTARTCMD,
                  OP_ASSERT_PME_WITHDATA,
                  OP_DEASSERT_PME_WITHDATA,
                  OP_ASSERT_IRQN, 
                  OP_DEASSERT_IRQN,
                  OP_BOOTPREP ,
                  OP_BOOTPREP_ACK,
                  OP_RESETPREP,
                  OP_RESETPREP_ACK,
                  OP_RST_REQ,
                  OP_VIRTUAL_WIRE,
                  OP_FORCE_PWRGATE_POK}) -> (xaction_class_i == iosfsbm_cm::POSTED);
 
  (opcode_i inside {FUSE_MSG, OP_LOCALSYNC}) -> (xaction_class_i == iosfsbm_cm::NON_POSTED);


}

constraint hqm_iosf_sb_seq::parity_err_con {
    parity_err_i == 0;
}

/**
 * Map supported opcode for dest PID.
 */
constraint hqm_iosf_sb_seq::supported_opcode_for_dest_pid {
 foreach(m_common_cfg.opcode_map[i])
   (dest_pid_i == i) -> (opcode_i inside {m_common_cfg.opcode_map[i].data});
 solve dest_pid_i before opcode_i;                                                     
}

/**
 * Map dest PID not equal source PID. 
 */
constraint hqm_iosf_sb_seq::dest_pid_neq_src_pid {
  dest_pid_i != src_pid_i;
}

/**
 * xaction_type.
 */
constraint hqm_iosf_sb_seq::set_xaction_type {
  (xaction_type_i inside {iosfsbm_cm::SIMPLE, 
                          iosfsbm_cm::MSGD,
                          iosfsbm_cm::REGIO,
                          iosfsbm_cm::COMP});
}

/** 
 * Set xaction_class
 */
constraint hqm_iosf_sb_seq::set_xaction_class {
  ((m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_083) && 
   (opcode_i inside {OP_ASSERT_INTA,
                     OP_ASSERT_INTB,
                     OP_ASSERT_INTC,
                     OP_ASSERT_INTD,
                     OP_DEASSERT_INTA,
                     OP_DEASSERT_INTB,
                     OP_DEASSERT_INTC,
                     OP_DEASSERT_INTD,
                     OP_DO_SERR,
                     OP_ASSERT_SCI,
                     OP_DEASSERT_SCI, 
                     OP_ASSERT_SSMI, 
                     OP_ASSERT_SMI, 
                     OP_DEASSERT_SSMI,
                     OP_DEASSERT_SMI, 
                     OP_SMI_ACK, 
                     OP_ASSERT_PME, 
                     OP_DEASSERT_PME, 
                     OP_SYNCCOMP,
                     OP_ASSERT_NMI,
                     OP_DEASSERT_NMI
                  })) 
                                           -> (xaction_class_i == iosfsbm_cm::POSTED);
                                           
   (opcode_i inside {
                     iosfsbm_cm::OP_PM_REQ, 
                     iosfsbm_cm::OP_PM_DMD, 
                     iosfsbm_cm::OP_PM_RSP,
                     `ifdef SVC_USE_OLD_OPCODE
                     iosfsbm_cm::OP_PCI_PM,
                     `else
                     iosfsbm_cm::OP_PCIE_PM,
                     `endif
                     iosfsbm_cm::OP_PCI_ERROR,
                     iosfsbm_cm::OP_LTR,
                     iosfsbm_cm::OP_SYNCSTARTCMD,
                     iosfsbm_cm::OP_ASSERT_PME_WITHDATA,
                     iosfsbm_cm::OP_DEASSERT_PME_WITHDATA,
                     iosfsbm_cm::OP_ASSERT_IRQN ,
                     iosfsbm_cm::OP_DEASSERT_IRQN ,
                     iosfsbm_cm::OP_BOOTPREP ,
                     iosfsbm_cm::OP_BOOTPREP_ACK,
                     iosfsbm_cm::OP_RESETPREP,
                     iosfsbm_cm::OP_RESETPREP_ACK,
                     iosfsbm_cm::OP_RST_REQ,
                     iosfsbm_cm::OP_VIRTUAL_WIRE,
                     iosfsbm_cm::OP_FORCE_PWRGATE_POK
                     }) 
                                           -> (xaction_class_i == iosfsbm_cm::POSTED);

   (opcode_i inside {
                  iosfsbm_cm::OP_LOCALSYNC}) -> (xaction_class_i == iosfsbm_cm::NON_POSTED);


  
                                           
   ((opcode_i[0] == 0) && (xaction_type_i == iosfsbm_cm::REGIO)) 
                                           -> (xaction_class_i == iosfsbm_cm::NON_POSTED);
                                           
   ((m_ep_cfg.iosfsb_spec_rev >= IOSF_083) && 
    (opcode_i inside {iosfsbm_cm::OP_IOWR, iosfsbm_cm::OP_CFGWR})) 
                                           -> (xaction_class_i == iosfsbm_cm::NON_POSTED);
  (opcode_i inside {
                     iosfsbm_cm::OP_CMPD, 
                     iosfsbm_cm::OP_CMP}) 
                                           -> (xaction_class_i == iosfsbm_cm::POSTED);                                            
}


/**
 * Ensure pm_cfg is not used when spec version is set to 0.83
 */
constraint hqm_iosf_sb_seq::opcode_value_083 {
 (m_ep_cfg.iosfsb_spec_rev inside {iosfsbm_cm::IOSF_083, iosfsbm_cm::IOSF_090}) -> (opcode_i != iosfsbm_cm::OP_LTR);
 (m_ep_cfg.iosfsb_spec_rev <= IOSF_090) -> (opcode_i != iosfsbm_cm::OP_DO_SERR);
 (m_ep_cfg.iosfsb_spec_rev < iosfsbm_cm::IOSF_11) -> (!(opcode_i inside {[iosfsbm_cm::OP_ASSERT_SCI:iosfsbm_cm::OP_SYNCCOMP]}));
 (m_ep_cfg.iosfsb_spec_rev < iosfsbm_cm::IOSF_11) -> (!(opcode_i inside {[iosfsbm_cm::OP_SYNCSTARTCMD:iosfsbm_cm::OP_LOCALSYNC]})); 
}

/**
 * Ensure misc field can only be set when spec version is 1.2 above
 */
constraint hqm_iosf_sb_seq::opcode_value_12 {
	(m_ep_cfg.iosfsb_spec_rev < IOSF_12) -> (opcode_i != iosfsbm_cm::FUSE_MSG);
}

/**
 * Set ...
 */
constraint hqm_iosf_sb_seq::bar_range {
  bar_i inside { [iosfsbm_cm::BAR_0:iosfsbm_cm::BAR_7] };
}

/**
 * FID is applicable only for Memory mapped, IO mapped and configuration space
 */
constraint hqm_iosf_sb_seq::fid_value_082 {
  ((m_ep_cfg.iosfsb_spec_rev <= IOSF_082) &&
   (opcode_i inside {iosfsbm_cm::OP_CRRD,iosfsbm_cm::OP_CRWR})) -> (fid_i == 8'h00);
}

/**
 * misc field used to be reserved field
 */
 
 constraint hqm_iosf_sb_seq::misc_field_value {
	(m_ep_cfg.iosfsb_spec_rev < IOSF_12) -> misc_i == 4'b0000;
 }
    
/**
 * Standard SV pre_randomize function, used here to disable and enable constraints
 * according to the config structures passes  
 */
function void hqm_iosf_sb_seq::pre_randomize(); 
      m_ep_cfg = p_sequencer.get_ep_cfg();
      m_common_cfg = p_sequencer.get_common_cfg();
      m_common_cfg.add_opcode_map(8'h21, {OP_SETIDVALUE});
      
      if(m_ep_cfg.iosfsb_spec_rev == IOSF_081)
        no_read_with_bcast_mcast.constraint_mode(1);
      else if((m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_082))      
        no_read_with_bcast_mcast.constraint_mode(0);

      if ( m_ep_cfg.turn_off_txn_constraints)
        begin
           src_pid_range.constraint_mode(0);
           dest_pid_range.constraint_mode(0);
           fe_with_mcast_bcast_nposted.constraint_mode(0);
           supported_opcode_for_dest_pid.constraint_mode(0);
        end

      if (m_ep_cfg.allow_reserved_opcode)
        opcode_range.constraint_mode(0);
           
      if (m_ep_cfg.turn_off_bar_constraint)
        bar_range.constraint_mode(0);

      if (m_ep_cfg.loopback_support)
        begin
           dest_pid_neq_src_pid.constraint_mode(0);
           dest_pid_range.constraint_mode(0);
        end
endfunction       
      
function void hqm_iosf_sb_seq::post_randomize(); 
  if (ext_headers_i.size() == 0 && eh_i == 1)
  begin     
    m_sai_value = $urandom_range(2**(m_ep_cfg.sai_width+1) - 1);
    ext_headers_i = new[m_ep_cfg.num_tx_ext_headers *4];
    foreach (ext_headers_i[j]) if(j%4 ==0) ext_headers_i[j][6:0] = 'h0; 
    foreach (ext_headers_i[j]) if(j/4 ==m_ep_cfg.num_tx_ext_headers-1 && j%4 ==0) ext_headers_i[j][7] = 1'b0; 
                               else if(j%4 ==0)  ext_headers_i[j][7] = 1'b1;
    if (m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_11)
    begin
      foreach (ext_headers_i[j])
        if(j%4 ==3)  // RS Field
          if (m_ep_cfg.rs_support) ext_headers_i[j][7:0] = $urandom_range(2**(m_ep_cfg.rs_width+1)-1);
          else                     ext_headers_i[j][7:0] = 8'h00;
      foreach (ext_headers_i[j]) if (j%4 ==1) ext_headers_i[j][7:0] = m_sai_value[7:0];
      foreach (ext_headers_i[j]) if (j%4 ==2) ext_headers_i[j][7:0] = m_sai_value[15:8];
    end
    else
      foreach (ext_headers_i[j]) if(j%4 !=0) ext_headers_i[j][7:0] = $random;

  end
endfunction      

/**
 *  hqm_iosf_sb_seq class constructor
 *  @param name OVM name
 *  @return Constructed component of type hqm_iosf_sb_seq
 */
function hqm_iosf_sb_seq::new(string name="",
           ovm_sequencer_base sequencer=null,
	   ovm_sequence#(iosfsbm_cm::xaction,iosfsbm_cm::xaction) parent_seq=null);
  super.new(name,sequencer,parent_seq);
      
endfunction :new
  
/** 
 * Body
 */
task hqm_iosf_sb_seq::body();

  // Locals
  iosfsbm_cm::xaction_type_e xtype = iosfsbm_cm::utils::get_type_from_opcode(opcode_i);
  bit addrlen_i;  
  ovm_sequence_item rsp;
  string msg;
  int addr_size_byte_i,data_size_dw_i;
    
  if(xtype == iosfsbm_cm::REGIO && opcode_i[0] == 0)//No data for read
    begin
       data_i = new[0];
       data_size_dw_i = 0;
    end
  else
    data_size_dw_i = data_i.size()/4;
      
  // Create xaction according to type
  case(xtype)
    iosfsbm_cm::SIMPLE:
     begin
      `ovm_create(simple_txn)
       simple_txn.set_cfg(m_ep_cfg,m_common_cfg);
       simple_txn.xaction_delay_field.constraint_mode(0);
       simple_txn.set_expect_rsp.constraint_mode(0);
       simple_txn.parity_err_con.constraint_mode(0);

       if (xaction_class_i == iosfsbm_cm::POSTED)
         exp_rsp_i = 0;
        
       if( ! simple_txn.randomize() with {
          simple_txn.xaction_class == xaction_class_i;
          simple_txn.src_pid       == src_pid_i;
          simple_txn.dest_pid      == dest_pid_i;
          simple_txn.opcode        == opcode_i;
          simple_txn.xaction_delay == xaction_delay_i;    
	      simple_txn.tag           == tag_i;
	      simple_txn.misc[3:0]     == misc_i;
          simple_txn.EH            == eh_i;                                
          simple_txn.expect_rsp    == exp_rsp_i;
          simple_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                
          foreach (ext_headers_i[i]) simple_txn.ext_headers_per_txn[i] == ext_headers_i[i];              
          simple_txn.parity_err == parity_err_i;
       })
       begin
         //`ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters",iosfsbm_cm::VERBOSE_ERROR)
         `ovm_error("IOSF_SB_FILE_SEQ",$psprintf("Not able to generate a xaction with the specified parameters"))
         return;
       end // if ( ! simple_txn.randomize() with {...
 
        //Clone xaction before sending it
        if( !($cast(req, simple_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast simple_txn xaction")
       
        //Set transaction id
        req.set_transaction_id(xact_id); 
        req.set_sequencer(get_sequencer());
       
        `ovm_info(get_type_name(),
                        $psprintf ("Sending SIMPLE tx %s", 
                                   req.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)

       `ovm_send(req)

        //Get response back
        if(req.expect_rsp && (req.xaction_class == iosfsbm_cm::NON_POSTED))
          begin
             $sformat(msg, "get response for xact_id-%0d", xact_id);
             `ovm_info("hqm_iosf_sb_seq", msg,iosfsbm_cm::VERBOSE_DEBUG_2)
             get_response(rsp, xact_id);
             assert($cast(rx_compl_xaction, rsp)) else
               `ovm_error("hqm_iosf_sb_seq", "Message with incorrect message type received")
               //`ovm_error("IOSF_SB_FILE_SEQ",$psprintf("Not able to generate a xaction with the specified parameters"))

             $sformat(msg, "got response for xact_id-%0d, %s", 
                      xact_id, rx_compl_xaction.sprint_header()); 
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)            
          end       
     end  
    iosfsbm_cm::MSGD:
     begin
      `ovm_create(msgd_txn)
       msgd_txn.set_cfg(m_ep_cfg,m_common_cfg);
       msgd_txn.xaction_delay_field.constraint_mode(0);
       msgd_txn.set_expect_rsp.constraint_mode(0);    
       msgd_txn.parity_err_con.constraint_mode(0);

       if (xaction_class_i == iosfsbm_cm::POSTED)
         exp_rsp_i = 0;
        
       if( ! msgd_txn.randomize() with {
          msgd_txn.xaction_class == xaction_class_i;
          msgd_txn.src_pid       == src_pid_i;
          msgd_txn.dest_pid      == dest_pid_i;
          msgd_txn.opcode        == opcode_i;   
	  	  msgd_txn.tag           == tag_i;
	      msgd_txn.misc[3:0]	 == misc_i;
          msgd_txn.EH            == eh_i;                                              
	      msgd_txn.data_size_dw  == data_i.size()/4;
          foreach (data_i[i]) msgd_txn.data[i] == data_i[i];
          msgd_txn.xaction_delay == xaction_delay_i; 
          msgd_txn.expect_rsp == exp_rsp_i; 
          msgd_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                      
          foreach (ext_headers_i[i]) msgd_txn.ext_headers_per_txn[i] == ext_headers_i[i]; 
          msgd_txn.parity_err == parity_err_i;
       })
       begin
         `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
         return;
       end // if ( ! msgd_txn.randomize() with {...

        //Clone xaction before sending it
        if( !($cast(req, msgd_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast msgd_txn xaction")
        
        //Set transaction id
        req.set_transaction_id(xact_id);
        req.set_sequencer(get_sequencer());
        
        `ovm_info(get_type_name(),
                        $psprintf ("Sending MSGD tx %s", 
                                   req.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)
        
       `ovm_send(req)
        
        //Get response back
        if(req.expect_rsp && (req.xaction_class == iosfsbm_cm::NON_POSTED))
          begin
             $sformat(msg, "get response for xact_id-%0d", xact_id);
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
             get_response(rsp, xact_id);
             assert($cast(rx_compl_xaction, rsp)) else
               `ovm_error("hqm_iosf_sb_seq", "Message with incorrect message type received")
             $sformat(msg, "got response for xact_id-%0d, %s", 
                      xact_id, rx_compl_xaction.sprint_header()); 
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
          end               
     end  
    iosfsbm_cm::REGIO:
      begin
         `ovm_create(regio_txn)
         regio_txn.set_cfg(m_ep_cfg,m_common_cfg);
         regio_txn.xaction_delay_field.constraint_mode(0);
         regio_txn.set_expect_rsp.constraint_mode(0);
         regio_txn.parity_err_con.constraint_mode(0);

         //Set address length
         if(addr_i.size() == 2)
           begin
              addrlen_i = 1'b0;
              addr_size_byte_i = 2;
           end
         else
           begin
              addrlen_i = 1'b1;
              addr_size_byte_i = 6;
           end

         if (xaction_class_i == iosfsbm_cm::POSTED)
           exp_rsp_i = 0;
         
         if( ! regio_txn.randomize() with {
          regio_txn.xaction_class == xaction_class_i;
          regio_txn.src_pid       == src_pid_i;
          regio_txn.dest_pid      == dest_pid_i;
          regio_txn.opcode        == opcode_i;
	  regio_txn.tag           == tag_i;
	  regio_txn.fbe           == fbe_i;
	  regio_txn.sbe           == sbe_i;
	  regio_txn.fid           == fid_i;
	  regio_txn.bar           == bar_i;                                           
          regio_txn.EH            == eh_i; 
          regio_txn.addr_size_byte == addr_size_byte_i;                                 
          regio_txn.data_size_dw == data_size_dw_i;                                                  
          foreach (addr_i[i]) 
            regio_txn.addr[i]     == addr_i[i];                                   
          regio_txn.addrlen       == addrlen_i;                                  
          foreach (data_i[i]) 
            regio_txn.data[i]     == data_i[i];                       
          regio_txn.xaction_delay == xaction_delay_i;    
          regio_txn.expect_rsp == exp_rsp_i; 
          regio_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                    
          foreach (ext_headers_i[i]) regio_txn.ext_headers_per_txn[i] == ext_headers_i[i]; 
          regio_txn.parity_err == parity_err_i;
       })
       begin
         `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
         return;
       end // if ( ! regio_txn.randomize() with {...

        //Clone xaction before sending it
        if( !($cast(req, regio_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast regio_txn xaction")
         
       //Set compare completion and expected_data field
       //for nonposted read messages  
       if (req.xaction_class == iosfsbm_cm::NON_POSTED &&
          !req.opcode[0])
         begin
            req.compare_completion = compare_completion_i;
            req.expected_data = exp_data_i;
         end

         //Set transaction id
         req.set_transaction_id(xact_id); 
         req.set_sequencer(get_sequencer());
        
         `ovm_info(get_type_name(),
                         $psprintf ("Sending REGIO tx %s", 
                                    req.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)           
         
       `ovm_send(req)

        //Get response back
        if(req.expect_rsp && (req.xaction_class == iosfsbm_cm::NON_POSTED))
          begin
             $sformat(msg, "get response for xact_id-%0d", xact_id);
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
             get_response(rsp, xact_id);
             assert($cast(rx_compl_xaction, rsp)) else
               `ovm_error("hqm_iosf_sb_seq", "Message with incorrect message type received")
             $sformat(msg, "got response for xact_id-%0d, %s", 
                      xact_id, rx_compl_xaction.sprint_header());
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
          end      
         
     end
    iosfsbm_cm::COMP:
      begin
         `ovm_create(comp_txn)
         comp_txn.set_cfg(m_ep_cfg,m_common_cfg);
         comp_txn.parity_err_con.constraint_mode(0);

         if (xaction_class_i == iosfsbm_cm::POSTED)
           exp_rsp_i = 0;
         
         if( ! comp_txn.randomize() with {
          comp_txn.xaction_class == xaction_class_i;
          comp_txn.src_pid       == src_pid_i;
          comp_txn.dest_pid      == dest_pid_i;
          comp_txn.opcode        == opcode_i;
	  comp_txn.tag           == tag_i;
	  comp_txn.rsp           == rsp_i;    
          comp_txn.EH            == eh_i;  
          comp_txn.data_size_dw  == data_i.size()/4;                              
          foreach (data_i[i]) 
            comp_txn.data[i]     == data_i[i];
          comp_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                
          foreach (ext_headers_i[i]) comp_txn.ext_headers_per_txn[i] == ext_headers_i[i]; 
          comp_txn.parity_err == parity_err_i;
       })
           begin
              `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
              return;
           end // if ( ! comp_txn.randomize() with {...

        //Clone xaction before sending it
        if( !($cast(req, comp_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast comp_txn xaction")

         req.set_sequencer(get_sequencer());
         
         `ovm_info(get_type_name(),
                         $psprintf ("Sending COMP tx %s", 
                                    req.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)
         
         `ovm_send(req)
         
     end
  endcase
      
endtask :body

/*
 * Send a xaction
 */
task hqm_iosf_sb_seq::send_xaction (                               
  input iosfsbm_cm::iosfsbc_sequencer  iosfsbc_seqr,                           
  input iosfsbm_cm::xaction_class_e xaction_class_i,
  input iosfsbm_cm::pid_t src_pid_i,
  input iosfsbm_cm::pid_t dest_pid_i,
  input iosfsbm_cm::opcode_t opcode_i,
  input iosfsbm_cm::tag_t tag_i,
  `ifndef MODEL_TECH                                                                   
  input iosfsbm_cm::flit_t addr_i[]='{},                      
  input iosfsbm_cm::flit_t data_i[]='{},
  `else
  input iosfsbm_cm::flit_t addr_i[]=null,
  input iosfsbm_cm::flit_t data_i[]=null,
  `endif                                                                 
  input bit[3:0] fbe_i = 4'h0,  
  input bit[3:0] sbe_i = 4'h0,  
  input bit[7:0] fid_i = 8'h00,  
  input bit[2:0] bar_i = 4'h0, 
  input bit[3:0] misc_i = 4'h0,
  input bit[3:0] xaction_delay_i=0,     
  input int unsigned xact_id = 0,
  input bit exp_rsp_i = 0,
  `ifndef MODEL_TECH    
  input iosfsbm_cm::flit_t exp_data_i[]='{},
  `else
  input iosfsbm_cm::flit_t exp_data_i[]=null,
  `endif                                                                 
  input bit compare_completion_i=1'b0 ,
  input bit[1:0] rsp_i = 2'b00,
  input bit eh_i = 0,
  `ifndef MODEL_TECH                                                                 
  input flit_t ext_headers_i[] = '{},
  `else
  input flit_t ext_headers_i[] = null,
  `endif                              
  input bit parity_err_i = 0
);

  // Locals
  iosfsbm_cm::xaction_type_e xtype = iosfsbm_cm::utils::get_type_from_opcode(opcode_i);
  bit addrlen_i;    
  ovm_sequence_item rsp;
  string msg;
  int addr_size_byte_i,data_size_dw_i;
  iosfsbm_cm::ep_cfg m_ep_cfg;

  if(xaction_class_i == iosfsbm_cm::POSTED)
    exp_rsp_i = 1'b0;

  if(xtype == iosfsbm_cm::REGIO && opcode_i[0] == 0)//No data for read
    begin
       data_i = new[0];
       data_size_dw_i = 0;
    end
  else
    data_size_dw_i = data_i.size()/4;

  m_ep_cfg = iosfsbc_seqr.get_ep_cfg();
            
  //set eh field
  if ((m_ep_cfg.ext_header_support) &&
      (m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_090) &&
      ((!m_ep_cfg.ctrl_ext_header_support && !m_ep_cfg.ext_headers_per_txn)))
    eh_i = 1;
  else if (!m_ep_cfg.ext_header_support && 
           (m_ep_cfg.iosfsb_spec_rev >= iosfsbm_cm::IOSF_090)) 
    eh_i = 1'b0;
  else if (m_ep_cfg.iosfsb_spec_rev < iosfsbm_cm::IOSF_090) 
    eh_i = 1'b0;
               
  // Create xaction according to type
  case(xtype)
    iosfsbm_cm::SIMPLE:
     begin
      `ovm_create(simple_txn)
       simple_txn.set_cfg(iosfsbc_seqr.get_ep_cfg(),iosfsbc_seqr.get_common_cfg());        
       simple_txn.xaction_delay_field.constraint_mode(0);
       simple_txn.set_expect_rsp.constraint_mode(0);
       simple_txn.parity_err_con.constraint_mode(0);
       if( ! simple_txn.randomize() with {
          simple_txn.xaction_class == xaction_class_i;
          simple_txn.src_pid       == src_pid_i;
          simple_txn.dest_pid      == dest_pid_i;
          simple_txn.opcode        == opcode_i;
		  simple_txn.misc[3:0]	   == misc_i;
          simple_txn.xaction_delay == xaction_delay_i;    
	  simple_txn.tag           == tag_i;
          simple_txn.EH            == eh_i;                                                
          simple_txn.expect_rsp == exp_rsp_i;
          simple_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                
          foreach (ext_headers_i[i]) simple_txn.ext_headers_per_txn[i] == ext_headers_i[i];              
          simple_txn.parity_err == parity_err_i;
       })
       begin
         `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
         return;
       end // if ( ! simple_txn.randomize() with {...

        //Clone xaction before sending it
        if( !($cast(req, simple_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast simple_txn xaction")
        
        //Set transaction id
        req.set_transaction_id(xact_id);
        req.set_sequencer(iosfsbc_seqr);

        `ovm_info(get_type_name(),
                        $psprintf ("Sending SIMPLE tx %s", 
                                   req.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)
                
       `ovm_send(req)

        //Get response back
        if(req.expect_rsp && (req.xaction_class == iosfsbm_cm::NON_POSTED))
          begin
             $sformat(msg, "get response for xact_id-%0d", xact_id);
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
             get_response(rsp, xact_id);
             assert($cast(rx_compl_xaction, rsp)) else
               `ovm_error("hqm_iosf_sb_seq", "Message with incorrect message type received")
             $sformat(msg, "got response for xact_id-%0d, %s", 
                      xact_id, rx_compl_xaction.sprint_header()); 
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)            
          end       
     end  
    iosfsbm_cm::MSGD:
     begin
      `ovm_create(msgd_txn)
       msgd_txn.set_cfg(iosfsbc_seqr.get_ep_cfg(),iosfsbc_seqr.get_common_cfg());
       msgd_txn.xaction_delay_field.constraint_mode(0);
       msgd_txn.set_expect_rsp.constraint_mode(0);        
       msgd_txn.parity_err_con.constraint_mode(0);
       if( ! msgd_txn.randomize() with {
          msgd_txn.xaction_class == xaction_class_i;
          msgd_txn.src_pid       == src_pid_i;
          msgd_txn.dest_pid      == dest_pid_i;
          msgd_txn.opcode        == opcode_i;   
		  msgd_txn.misc[3:0]	 == misc_i;
	  msgd_txn.tag           == tag_i;
          msgd_txn.EH            == eh_i;                                              
	  msgd_txn.data_size_dw  == data_i.size()/4;
          foreach (data_i[i]) msgd_txn.data[i] == data_i[i];
          msgd_txn.xaction_delay == xaction_delay_i; 
          msgd_txn.expect_rsp == exp_rsp_i;
          msgd_txn.ext_headers_per_txn.size() == ext_headers_i.size();                              
          foreach (ext_headers_i[i]) msgd_txn.ext_headers_per_txn[i] == ext_headers_i[i]; 
          msgd_txn.parity_err == parity_err_i;
       })
       begin
         `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
         return;
       end // if ( ! msgd_txn.randomize() with {...
	   
        //Clone xaction before sending it
        if( !($cast(req, msgd_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast msgd_txn xaction")
        
       //Set transaction id
        req.set_transaction_id(xact_id);
        req.set_sequencer(iosfsbc_seqr);
        
        `ovm_info(get_type_name(),
                        $psprintf ("Sending MSGD tx %s", 
                                   req.sprint_header()), iosfsbm_cm::VERBOSE_DEBUG_2)  

       `ovm_send(req)
        
        //Get response back
        if(req.expect_rsp && (req.xaction_class == iosfsbm_cm::NON_POSTED))
          begin
             $sformat(msg, "get response for xact_id-%0d", xact_id);
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
             get_response(rsp, xact_id);
             assert($cast(rx_compl_xaction, rsp)) else
               `ovm_error("hqm_iosf_sb_seq", "Message with incorrect message type received")
             $sformat(msg, "got response for xact_id-%0d, %s", 
                      xact_id, rx_compl_xaction.sprint_header()); 
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
          end               
     end  
    iosfsbm_cm::REGIO:
      begin
         `ovm_create(regio_txn)
         regio_txn.set_cfg(iosfsbc_seqr.get_ep_cfg(),iosfsbc_seqr.get_common_cfg());
         regio_txn.xaction_delay_field.constraint_mode(0);
         regio_txn.set_expect_rsp.constraint_mode(0);
         regio_txn.parity_err_con.constraint_mode(0);
         //Set address length
         if(addr_i.size() == 2)
           begin
              addrlen_i = 1'b0;
              addr_size_byte_i = 2;
           end
         else
           begin
              addrlen_i = 1'b1;
              addr_size_byte_i = 6;
           end
     
         if( ! regio_txn.randomize() with {
          regio_txn.xaction_class == xaction_class_i;
          regio_txn.src_pid       == src_pid_i;
          regio_txn.dest_pid      == dest_pid_i;
          regio_txn.opcode        == opcode_i;
	  regio_txn.tag           == tag_i;
          regio_txn.fbe           == fbe_i;   
          regio_txn.sbe           == sbe_i;   
          regio_txn.fid           == fid_i;   
          regio_txn.bar           == bar_i;
          regio_txn.EH            == eh_i;   
          regio_txn.addr_size_byte == addr_size_byte_i;                                 
          regio_txn.data_size_dw == data_size_dw_i;                                         
          foreach (addr_i[i]) 
            regio_txn.addr[i]     == addr_i[i];  
          regio_txn.addrlen       == addrlen_i;                                  
          foreach (data_i[i]) 
            regio_txn.data[i]     == data_i[i];          
          regio_txn.xaction_delay == xaction_delay_i;    
          regio_txn.expect_rsp == exp_rsp_i;
          regio_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                  
          foreach (ext_headers_i[i]) regio_txn.ext_headers_per_txn[i] == ext_headers_i[i]; 
          regio_txn.parity_err == parity_err_i;
       })
       begin
         `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
         return;
       end // if ( ! regio_txn.randomize() with {...

        //Clone xaction before sending it
        if( !($cast(req, regio_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast regio_txn xaction")

         //Set transaction id
         req.set_transaction_id(xact_id);
         req.set_sequencer(iosfsbc_seqr);
         
         //Set compare completion and expected_data field
         //for nonposted read messages
         if(req.xaction_class == iosfsbm_cm::NON_POSTED &&
            !req.opcode[0])
           begin  
              req.compare_completion = compare_completion_i;
              req.expected_data = exp_data_i;
           end
         `ovm_info(get_type_name(),
                         $psprintf ("Sending REGIO tx %s", 
                                    regio_txn.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)
                                
         `ovm_send(req)

        //Get response back
        if(req.expect_rsp && (regio_txn.xaction_class == iosfsbm_cm::NON_POSTED))
          begin
             $sformat(msg, "get response for xact_id-%0d", xact_id);
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
             get_response(rsp, xact_id);
             assert($cast(rx_compl_xaction, rsp)) else
               `ovm_error("hqm_iosf_sb_seq", "Message with incorrect message type received")
             $sformat(msg, "got response for xact_id-%0d, %s", 
                      xact_id, rx_compl_xaction.sprint_header());
             `ovm_info(get_type_name(), msg,iosfsbm_cm::VERBOSE_DEBUG_2)
          end      
         
     end
    iosfsbm_cm::COMP:
      begin
         `ovm_create(comp_txn)
         comp_txn.set_cfg(iosfsbc_seqr.get_ep_cfg(),iosfsbc_seqr.get_common_cfg());
         comp_txn.parity_err_con.constraint_mode(0);
         if( ! comp_txn.randomize() with {
          comp_txn.xaction_class == xaction_class_i;
          comp_txn.src_pid       == src_pid_i;
          comp_txn.dest_pid      == dest_pid_i;
          comp_txn.opcode        == opcode_i;
	  comp_txn.tag           == tag_i;
	  comp_txn.rsp           == rsp_i; 
	  comp_txn.EH            == eh_i;  
          comp_txn.data_size_dw  == data_i.size()/4;                                
          foreach (data_i[i]) 
            comp_txn.data[i]     == data_i[i];
          comp_txn.ext_headers_per_txn.size() == ext_headers_i.size();                                 
          foreach (ext_headers_i[i]) comp_txn.ext_headers_per_txn[i] == ext_headers_i[i]; 
          comp_txn.parity_err == parity_err_i;
       })
           begin
              `ovm_error(get_type_name(),"Not able to generate a xaction with the specified parameters")
              return;
           end // if ( ! comp_txn.randomize() with {...

        //Clone xaction before sending it
        if( !($cast(req, comp_txn.clone())))
          `ovm_fatal(get_type_name(), "Cannot cast comp_txn xaction")

         req.set_sequencer(iosfsbc_seqr);
         
         `ovm_info(get_type_name(),
                         $psprintf ("Sending COMP tx %s", 
                                    req.sprint_header()),iosfsbm_cm::VERBOSE_DEBUG_2)

         `ovm_send(req)  
     end
  endcase

endtask:send_xaction 

`endif //INC_hqm_iosf_sb_seq
