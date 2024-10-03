//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-01 
//-----------------------------------------------------------------
// Description:
// ccu_vc class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_vc
`define INC_ccu_vc 

/**
 * TODO: Add class description
 */
class ccu_vc extends ovm_agent;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   ccu_vc_cfg ccu_vc_cfg_i;
   ccu_crg_agt clk_gen;    
   ccu_ob_agent req_ack_usync_gen;

   ccu_driver ccu_driver_i;
   ccu_seqr ccu_sqr_i;

   dcg_controller dcg_i;
   real div_ratio_l;
   realtime slice_phase_delay;
   realtime dcg_phase_delay[512];
   virtual ccu_np_intf ccu_clk_intf;

   //------------------------------------------
   // Constraints 
   //------------------------------------------
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   
   // Standard OVM Methods 
   extern function       new   (string name = "", ovm_component parent = null);
   extern function void  build ();
   extern function void  connect ();
   extern function void  end_of_elaboration ();
   
   // APIs 
   
   // OVM Macros 
   `ovm_component_utils (ccu_vc_pkg::ccu_vc)
endclass :ccu_vc

/**
 * ccu_vc Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type ccu_vc 
 */
function ccu_vc::new (string name = "", ovm_component parent = null);
 
   // Super constructor
   super.new (name, parent);
	
endfunction :new

/******************************************************************************
 * ccu_vc class OVM build phase
 ******************************************************************************/
function void ccu_vc::build ();
   ovm_object tmp;
   string ccu_crg_ti_name;
   sla_vif_container #(virtual ccu_np_intf) slaAgentIFContainer;
   ovm_object tmpPtrToAgentIFContainer;
 
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
   assert (get_config_object("CCU_VC_CFG", tmp));
   assert ($cast(ccu_vc_cfg_i , tmp));
   assert (get_config_string("CCU_VC_ccu_crg_TI_NAME", ccu_crg_ti_name));
   if(ccu_crg_ti_name !== "") begin
   	assert (get_config_object("ccu_vc_if_container", tmpPtrToAgentIFContainer));
   	assert($cast(slaAgentIFContainer, tmpPtrToAgentIFContainer)) begin
		   ccu_clk_intf = slaAgentIFContainer.get_v_if();
   end
   end
   assert(get_config_int("CCU_VC_IS_ACTIVE_TI", ccu_vc_cfg_i.is_active_ti));
      if(ccu_vc_cfg_i.is_active_ti == 0) begin
	   ccu_vc_cfg_i.i_ccu_crg_cfg.set_state(OVM_PASSIVE);
	   ccu_vc_cfg_i.i_ccu_ob_cfg.is_active = OVM_PASSIVE;
	   ccu_vc_cfg_i.is_active = OVM_PASSIVE;
   end
   assert (get_config_int("CCU_VC_NUM_SLICES", ccu_vc_cfg_i.num_slices));
   if (ccu_vc_cfg_i.num_slices > MAX_NUM_SLICES)
     `ovm_error("CCU VC CFG", $psprintf("NUM_SLICES (%0d) value is bigger than the max(%0d)", ccu_vc_cfg_i.num_slices, MAX_NUM_SLICES))
	
   // Construct children
   // ------------------
   
   if(ccu_vc_cfg_i.is_active == OVM_ACTIVE) begin 
   ccu_driver_i = ccu_driver::type_id::create ("ccu_driver" ,this);
   dcg_i = dcg_controller::type_id::create("dcg_controller", this);
   clk_gen = ccu_crg_agt::type_id::create ("clk_generator" ,this);
   req_ack_usync_gen = ccu_ob_agent::type_id::create("req_ack_usync_gen", this);
   ccu_sqr_i = ccu_seqr::type_id::create ("ccu_sequencer" ,this);
   end  
   // Configure children
   // ------------------
   set_config_object("clk_generator*","ccu_crg_cfg", ccu_vc_cfg_i.i_ccu_crg_cfg, 0);
   set_config_object("req_ack_usync_gen*","ccu_ob_cfg", ccu_vc_cfg_i.i_ccu_ob_cfg, 0);
   ccu_vc_cfg_i.i_ccu_crg_cfg.set_ti_name(ccu_crg_ti_name);
   
endfunction :build

/******************************************************************************
 * ccu_vc class OVM connect phase
 ******************************************************************************/
function void ccu_vc::connect ();
   super.connect ();

   if(ccu_vc_cfg_i.is_active == OVM_ACTIVE) begin
   dcg_i.req_ack_sqr = req_ack_usync_gen.ccu_ob_seqncr;
   ccu_driver_i.usync_sqr = req_ack_usync_gen.ccu_ob_seqncr;
   ccu_driver_i.seq_item_port.connect(ccu_sqr_i.seq_item_export);
   ccu_driver_i.ccu_crg_seqr_i = clk_gen.get_sequencer() ;
   dcg_i.ccu_crg_seqr_i = clk_gen.get_sequencer() ;
   req_ack_usync_gen.ccu_ob_port.connect(dcg_i.req_ack_usync_ap);
   end

endfunction :connect

/******************************************************************************
 * ccu_vc class OVM end_of_elaboration phase
 ******************************************************************************/
function void ccu_vc::end_of_elaboration ();
   super.end_of_elaboration ();
   if(ccu_vc_cfg_i.is_active == OVM_ACTIVE)
  	`ovm_info ("CCU VC CFG", {"\n", ccu_vc_cfg_i.sprint()}, OVM_INFO)

   set_report_id_action_hier("ccu_ob_driver", OVM_NO_ACTION);

   if (ccu_vc_cfg_i.clk_sources.size() == 0)
   begin
     `ovm_warning("CCU CFG", "CLK Sources not initialized. Initiliazing randomly")
     ccu_vc_cfg_i.randomize_clk_sources ();
   end
	
   if(ccu_vc_cfg_i.slices.size() > ccu_vc_cfg_i.num_slices) 
	`ovm_error("CCU VC", $psprintf("Test is programming slices = %0d when param NUM_SLICES is %0d",ccu_vc_cfg_i.slices.size(),ccu_vc_cfg_i.num_slices))

   foreach (ccu_vc_cfg_i.slices[i])
   begin
	 if(ccu_vc_cfg_i.slices[i].half_divide_ratio === 1) div_ratio_l = (int'(ccu_vc_cfg_i.slices[i].divide_ratio) + 0.5);
	 else div_ratio_l = ccu_vc_cfg_i.slices[i].divide_ratio;
	 slice_phase_delay = (ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.slices[i].clk_src].period * (div_ratio_l)) * 0.1 * $urandom_range(8,2);
	 if(ccu_vc_cfg_i.slices[i].enable_random_phase == 1 && ccu_vc_cfg_i.slices[i].dcg_blk_num == 1024 &&
		 ccu_vc_cfg_i.slices[i].in_phase_with_slice_num == 1024) begin
	 	ccu_vc_cfg_i.i_ccu_crg_cfg.set_clock_domain(ccu_vc_cfg_i.slices[i].slice_name, slice_phase_delay);
	 end else if(ccu_vc_cfg_i.slices[i].enable_random_phase == 1 && ccu_vc_cfg_i.slices[i].dcg_blk_num !== 1024 &&
		 ccu_vc_cfg_i.slices[i].in_phase_with_slice_num == 1024 )begin
		 if(this.dcg_phase_delay[ccu_vc_cfg_i.slices[i].dcg_blk_num] == 0) 
		 this.dcg_phase_delay[ccu_vc_cfg_i.slices[i].dcg_blk_num] = (ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.slices[i].clk_src].period * (div_ratio_l)) * 0.1 * $urandom_range(8,2);
		 ccu_vc_cfg_i.i_ccu_crg_cfg.set_clock_domain(ccu_vc_cfg_i.slices[i].slice_name, this.dcg_phase_delay[ccu_vc_cfg_i.slices[i].dcg_blk_num]);
	 end
	 else if(ccu_vc_cfg_i.slices[i].enable_random_phase == 0 || ccu_vc_cfg_i.slices[i].in_phase_with_slice_num !== 1024) begin
		 ccu_vc_cfg_i.i_ccu_crg_cfg.set_clock_domain(ccu_vc_cfg_i.slices[i].slice_name,0);
	 end

	 // def on or clock ungated from the start should drive clkack to 1
	 if(ccu_vc_cfg_i.slices[i].def_status == ccu_types::DEF_ON || 
		 ccu_vc_cfg_i.slices[i].clk_status == ccu_types::CLK_UNGATED) 
		 ccu_vc_cfg_i.i_ccu_ob_cfg.set_def_val(i,1'b1);

     ccu_vc_cfg_i.i_ccu_crg_cfg.add_clock(
                ccu_vc_cfg_i.slices[i].slice_num,
                ccu_vc_cfg_i.slices[i].slice_name,
                ccu_vc_cfg_i.slices[i].slice_name,
                //ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.slices[i].clk_src].period * (2 ** int'(ccu_vc_cfg_i.slices[i].divide_ratio)),
                ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.slices[i].clk_src].period * (div_ratio_l),
				bit'(ccu_vc_cfg_i.slices[i].clk_status),
				ccu_vc_cfg_i.slices[i].dcg_blk_num,
		   		ccu_vc_cfg_i.slices[i].in_phase_with_slice_num,
				ccu_vc_cfg_i.slices[i].duty_cycle		
     );

   end
   ccu_vc_cfg_i.i_ccu_crg_cfg.set_clock_domain("GUSYNC_REF_CLK", 0);
   ccu_vc_cfg_i.i_ccu_crg_cfg.add_clock(
              ccu_vc_cfg_i.get_num_slices(),
              "GUSYNC_REF_CLK","GUSYNC_REF_CLK",
              ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.gusync_ref_clk].period
   );

endfunction :end_of_elaboration

`endif //INC_ccu_vc

