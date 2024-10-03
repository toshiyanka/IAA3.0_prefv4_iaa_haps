#!/usr/bin/tcsh -f

if ("${SPYGLASS_LD_LIBRARY_PATH}" == "NOT_NEEDED") then

  ${IP_ROOT}/tools/spyglasslp/runSpyglass \
      -file_list ${RTL_FILE_LIST} \
      -lib_list ${LIB_LIST} \
      -upf ${TOP_UPF_FILE} \
      -top_module ${RTLTOP} \
      -waiver ${WAIVER_FILE} 

else

  ${IP_ROOT}/tools/spyglasslp/runSpyglass \
      -file_list ${RTL_FILE_LIST} \
      -lib_list ${LIB_LIST} \
      -upf ${TOP_UPF_FILE} \
      -top_module ${RTLTOP} \
      -opts "set_option I ${SPYGLASS_LD_LIBRARY_PATH}" \
      -waiver ${WAIVER_FILE} 

endif

