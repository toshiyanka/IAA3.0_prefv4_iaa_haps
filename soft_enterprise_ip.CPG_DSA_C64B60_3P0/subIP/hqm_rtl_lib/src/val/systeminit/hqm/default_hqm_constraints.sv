`constraint_class_begin(default_hqm_fuse_constraints,hqm_agent_picker, hqm)


    constraint fuse_speedup_en_c {
      soft hqm.fuse_speedup_en == 1;
    }

    constraint hqm_fuse_download_c {
      soft hqm.hqm_fuse_no_bypass == 0;
    }
`constraint_class_end

`constraint_wrapper_class_begin(default_hqm_constraints)
    `apply_constraint_class(default_hqm_fuse_constraints)
`constraint_wrapper_class_end 
