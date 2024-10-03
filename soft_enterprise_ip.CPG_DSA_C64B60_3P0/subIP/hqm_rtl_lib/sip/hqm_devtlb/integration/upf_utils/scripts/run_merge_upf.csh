#!/usr/intel/bin/tcsh -x

## Example script to run MergeUPF, this script is derived from template given at: ${CHEETAH_RTL_ROOT}/integration/upf_utils/template/run_merge_upf.csh

# Copying UPF global_upf.cfg from $MERGE_INPUT_DIR to local area if exists
if ( -f $MERGE_INPUT_DIR/global_upf.cfg ) then
  /bin/cp -f $MERGE_INPUT_DIR/global_upf.cfg $OUTPUT_DIR/gen/upf
else
# Copying UPF global_upf.cfg from central location to local area as per UPF WG recommendation to make the UPF's env agnostic
  /bin/cp -f /p/hdk/rtl/proj_tools/power_templates/cds/latest/global_upf.cfg $OUTPUT_DIR/gen/upf
endif

# Default value is all upf files in $MERGE_INPUT_DIR
# Applicable if $MERGE_INPUT_DIR is integration/collage hier outputs
set input_files=`find $MERGE_INPUT_DIR -maxdepth 1 -name "*\.upf" -type f`

## START of possible user change ##

# User can provide specific block top_upf for merging. Useful if block top_upf exists in same folder as its children upfs.
# Please make sure the block top_upf are in $MERGE_INPUT_DIR, and give full path
set input_files="${MERGE_INPUT_DIR}/llchspr.upf ${MERGE_INPUT_DIR}/llcp.upf"

## END of possible user change ##

echo "\n=================RUNNING MERGE_UPF=================\n"
## guard condition to ensure input_files are not empty
if (${#input_files} <= 0) then
  echo "-F- No input files found to merge. Please check MERGE_INPUT_DIR and $WORKAREA/scripts/run_merge_upf.csh" >> ${CTH_MERGE_UPF_CENTRAL_LOG}
  exit 1
endif

## Recommended MergeUPF Calling if no tagging is needed
foreach upf (${input_files})
  set block=`echo $upf | sed "s:${MERGE_INPUT_DIR}\/::g" | sed 's:.upf::g'`
  # Use generic config file if no block specific config is needed
  set config_file=${WORKAREA}/integration/upf_utils/config/generic_merge_upf_config.tcl
  if ( -f ${WORKAREA}/integration/upf_utils/config/${block}_merge_upf_config.tcl) then
    set config_file=${WORKAREA}/integration/upf_utils/config/${block}_merge_upf_config.tcl
  endif
  echo "Merge $upf with config file $config_file" |& tee -a ${block}.merge_upf.log ${CTH_MERGE_UPF_CENTRAL_LOG}

## START of possible user change ##

## Some options are not available from config file, therefore have to be used as inline command
## To know if an option is supported in config file, please check: https://wiki.ith.intel.com/display/ConnectivityIntegration/Merge+UPF+Constructs+Information
## UPF_UTILS_ROOT version 20.07.06 is equivalent to COLLAGE version 5.15
## Format MUST BE: $UPF_UTILS_ROOT/MergeUPF/merge_upf.tcl -upf ${upf} -config $config_file <all other inline commands> |& tee -a ${block}.merge_upf.log ${CTH_MERGE_UPF_CENTRAL_LOG}
  $UPF_UTILS_ROOT/MergeUPF/merge_upf.tcl -upf ${upf} -config $config_file -verbose |& tee -a ${block}.merge_upf.log ${CTH_MERGE_UPF_CENTRAL_LOG}

## END of possible user change ##

  /bin/mv ${block}.merge_upf.log $OUTPUT_DIR/work/log/
  /bin/mv ${block}.upf_flat.upf $OUTPUT_DIR/work/report/
  /bin/mv ${block}_inspect_upf_error.log $OUTPUT_DIR/work/report/
end

################################################

## Recommended MergeUPF Calling if no tagging is needed

## START of possible user change ##

# User can provide specific block top_upf for merging. Useful if block top_upf exists in same folder as its children upfs.
# Please make sure the block top_upf are in $MERGE_UPF_INPUT_DIR, and give full path
set input_files="${MERGE_INPUT_DIR}/llchspr.upf ${MERGE_INPUT_DIR}/llcp.upf"

## Tag example is merged_syn, merged_sim, merged_vcs, merged_dc; can be any project required names
## Generated output will be ${block}.${tag}.upf
set tag=merged_syn

## multiple tag can be configured into foreach loop too1. Dont forget to close the foreach loop with an 'end'
# set tag_list="merged_syn merged_sim merged_vcs merged_dc"
# foreach tag (${tag_list})

## END of possible user change ##

foreach upf (${input_files})
  set block=`echo $upf | sed "s:${MERGE_INPUT_DIR}\/::g" | sed 's:.upf::g'`
  set config_file=${WORKAREA}/integration/upf_utils/config/generic_merge_upf_config.tcl
  if ( -f ${WORKAREA}/integration/upf_utils/config/${block}_merge_upf_config.tcl) then
    set config_file=${WORKAREA}/integration/upf_utils/config/${block}_merge_upf_config.tcl
  endif
  echo "Merge $upf with config file $config_file"

## START of possible user change ##

## Some options are not available from config file, therefore have to be used as inline command
## To know if an option is supported in config file, please check: https://wiki.ith.intel.com/display/ConnectivityIntegration/Merge+UPF+Constructs+Information
## UPF_UTILS_ROOT version 20.07.06 is equivalent to COLLAGE version 5.15
## Format MUST BE: $UPF_UTILS_ROOT/MergeUPF/merge_upf.tcl -upf ${upf} -config $config_file <all other inline commands> |& tee -a ${block}.${tag}.merge_upf.log ${CTH_MERGE_UPF_CENTRAL_LOG}
  $UPF_UTILS_ROOT/MergeUPF/merge_upf.tcl -upf ${upf} -tag ${tag} -config $config_file -verbose |& tee -a ${block}.${tag}.merge_upf.log ${CTH_MERGE_UPF_CENTRAL_LOG}

## END of possible user change ##

  /bin/mv ${block}.${tag}.merge_upf.log $OUTPUT_DIR/work/log/
  /bin/mv ${block}.upf_flat.upf $OUTPUT_DIR/work/report/${block}.${tag}.upf_flat.upf
  /bin/mv ${block}_inspect_upf_error.log $OUTPUT_DIR/work/report/${block}.${tag}_inspect_upf_error.log 
end

## START of possible user change ##

## If additional end if foreach loop is used for tag
#end

## END of possible user change ##
