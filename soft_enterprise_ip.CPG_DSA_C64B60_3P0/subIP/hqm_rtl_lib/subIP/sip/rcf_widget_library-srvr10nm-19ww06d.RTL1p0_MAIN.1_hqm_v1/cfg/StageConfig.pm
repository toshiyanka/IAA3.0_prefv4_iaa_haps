%StageParamMap = (
    '.*' => { 'pre_run' => undef,
              'resource' => undef,
              'use_flow_digest' => 1,
             },

     'ip_turnin.unit.rcfwl_dft_reset_sync.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.rcfwl_cdc_wrapper.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'ip_turnin.unit.rcfwl_fuse_hip_glue.dc' => { 'resource' => 'CLASS_FAST_8G', },
     'bman.rcfwl.vcs.*elab_dft_reset_sync' => { 'resource' => 'CLASS_4G', },
     'bman.rcfwl.vcs.*elab_cdc_wrapper' => { 'resource' => 'CLASS_4G', },
     'bman.rcfwl.vcs.*elab_fuse_hip_glue' => { 'resource' => 'CLASS_4G', },

     # Override netbatch autoretry policy of all simbuild substages by adding one retry for exit status == 1.
     # Override netbatch autoretry policy of all simbuild substages by adding one retry for exit status == 1.
     # That is because lots of spurious failures with exit status = 1. (as of Q1 2015).
     # That is because lots of spurious failures with exit status = 1. (as of Q1 2015).
     # Some of those spurious failures are I/O errors (cod, cpp stages), some are
     # Some of those spurious failures are I/O errors (cod, cpp stages), some are
     # due to race conditions in build flows that we hopefully hunt down soon.
     # due to race conditions in build flows that we hopefully hunt down soon.
     #
     #
     # The override here will affect both GK runs and user runs.
     # The override here will affect both GK runs and user runs.
     #
     #
     # So... by default flow gives us:
     # So... by default flow gives us:
     #    (ExitStatus<=254&&ExitStatus>=2):Requeue(4),
     #    (ExitStatus<=254&&ExitStatus>=2):Requeue(4),
     # We will add line to have instead the following for stages that need it:
     # We will add line to have instead the following for stages that need it:
     #    (ExitStatus<=254&&ExitStatus>=1):Requeue(1),
     #    (ExitStatus<=254&&ExitStatus>=1):Requeue(1),
     #
     #
     # (where 1:254 is range of exit statuses)... and for now we only want one unconditional retry.
     # (where 1:254 is range of exit statuses)... and for now we only want one unconditional retry.
     'ip_turnin.*' => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.vcs.*'                      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.ascot.*'                    => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.chef.*'                     => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.cod.*'                      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.collage.collage_assemble*'  => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.cpp.*'                      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     # Skip the collage build stage as replays don't play well
     # Skip the collage build stage as replays don't play well
     'bman.*.cpu_beh_new.*'              => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.creg.*'                     => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.debug_dump.*'               => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.emu.*'                      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.espf.*'                     => { 'resubmit_status' => '1:254', 'retries' => 1 },
     '.*genrtl.*'                        => { 'resource' => 'CLASS_16G', 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.jem.*'                      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.lintra.lintra_create*'      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     # Skip lintra_load for reruns as run time is long in case of failure
     # Skip lintra_load for reruns as run time is long in case of failure
     'bman.*.lintra_ol.lt_ol_createlib*' => { 'resubmit_status' => '1:254', 'retries' => 1 },
     # Skip Open Latch for reruns as run time is long in case of failure
     # Skip Open Latch for reruns as run time is long in case of failure
     'bman.*.nebulon.*'                  => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.socfusegen.*'               => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.specman.*'                  => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.tlm_xml.*'                  => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.FLG.*'                      => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.hip_listgen.*'              => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.qcdc.qcdc_createlib*'       => { 'resubmit_status' => '1:254', 'retries' => 1 },
     # QCDC TEST reruns are long when violations
     # QCDC TEST reruns are long when violations
     'bman.*.sglp.sglp_createlib*'       => { 'resubmit_status' => '1:254', 'retries' => 1 },
     'bman.*.sgcdc.sgcdc_createlib*'     => { 'resubmit_status' => '1:254', 'retries' => 1 },
     # Skip SGLP, SGCDC, and SGDFT test reruns which are long if a failure
     # Skip SGLP, SGCDC, and SGDFT test reruns which are long if a failure

);
