`constraint_wrapper_class_begin(test_constraints)

`constraint_class_begin(hqm_vf_constraints, base_hqm_picker, hqm)
   constraint hqm_vf_constraints{
      hqm.num_hqm_vfs == 16;
   }
`constraint_class_end
`apply_constraint_class(hqm_vf_constraints)
`constraint_wrapper_class_end
