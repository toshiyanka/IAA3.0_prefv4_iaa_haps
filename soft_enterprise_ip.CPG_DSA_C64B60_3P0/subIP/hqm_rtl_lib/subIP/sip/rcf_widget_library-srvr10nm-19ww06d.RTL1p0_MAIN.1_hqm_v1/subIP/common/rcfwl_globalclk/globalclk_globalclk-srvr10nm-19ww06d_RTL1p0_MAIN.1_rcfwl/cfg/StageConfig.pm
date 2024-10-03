%StageParamMap = (
    '.*' => { 'pre_run' => undef,
              'resource' => undef,
              'use_flow_digest' => 1,
             },

     'ip_turnin.unit.gclk_fxr_clkdist.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_clkdist_mux.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_psyncdist.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_pccdu.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_refclkdist.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_pclkdist.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_clkdist_repeater.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_horizontal_clkdist.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_clkreqaggr.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_mesh_clkdist.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.gclk_pcu_clkdist.dc' => { 'resource' => 'CLASS_FAST_6G', },
     'ip_turnin.unit.gclk_psocclkdist.dc' => { 'resource' => 'CLASS_FAST_6G', },
     'ip_turnin.unit.gclk_rcb_lcb.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'bman.globalclk.vcs.elab_refclkdist' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_rcb_lcb' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_psyncdist' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_psocsyncdist' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_psocclkdist' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_pclkdist' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_pccdu' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_mesh_clkdist' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_divsync_gen' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_clkreqaggr' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_clkdist_repeater' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_clkdist_mux' => { 'resource' => 'CLASS_4G', },
     'bman.globalclk.vcs.elab_clkdist_clkmux' => { 'resource' => 'CLASS_4G', },
   #SGCDC libs with DW components
   #SGCDC libs with DW components
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_cda_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_clkdist_clkmux_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_clkdist_mux_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_clkdist_repeater_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_clkreqaggr_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_divsync_gen_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_glitchfree_clkmux_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_mesh_clkdist_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_pccdu_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_pclkdist_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_psocclkdist_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_psocsyncdist_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_psyncdist_rtl_lib' => { 'resource' => 'CLASS_32G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_rcb_lcb_rtl_lib' => { 'resource' => 'CLASS_48G', },
   'bman.globalclk.sgcdc.sgcdc_createlib_rcfwl_gclk_refclkdist_rtl_lib' => { 'resource' => 'CLASS_32G', },

);
