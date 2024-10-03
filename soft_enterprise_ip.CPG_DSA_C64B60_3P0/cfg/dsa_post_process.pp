# -*-perl-*- for Emacs
#--------------------------------------------------------------------------------
# INTEL CONFIDENTIAL
#
# Copyright (June 2005)2 (May 2008)3 Intel Corporation All Rights Reserved.
# The source code contained or described herein and all documents related to the
# source code ("Material") are owned by Intel Corporation or its suppliers or
# licensors. Title to the Material remains with Intel Corporation or its
# suppliers and licensors. The Material contains trade secrets and proprietary
# and confidential information of Intel or its suppliers and licensors. The
# Material is protected by worldwide copyright and trade secret laws and treaty
# provisions. No part of the Material may be used, copied, reproduced, modified,
# published, uploaded, posted, transmitted, distributed, or disclosed in any way
# without Intels prior express written permission.
#
# No license under any patent, copyright, trade secret or other intellectual
# property right is granted to or conferred upon you by disclosure or delivery
# of the Materials, either expressly, by implication, inducement, estoppel or
# otherwise. Any license under such intellectual property rights must be express
# and approved by Intel in writing.
#
#-------------------------------------------------------------------------------
{
################################################################################
# Note: All regular expressions must be placed with single quotes '/dsa/i'
#   instead of double quotes "/dsa/i"
################################################################################
# If this variable is set, the config files in the list are first read in the
#   order listed (so it is possible to overwrite information from an ealier
#   cfgfile.)  Then the remainder of this file is parsed so that the information
#   contained within this file has the highest precedence.
#
# Note: Only one level of hierarchy can exist (so a file listed here cannot then
#   call an additional base config file.)
#
################################################################################
use lib "$ENV{WORKAREA}/verif/tb/tests/base";
use Data::Dumper;
use File::Slurp qw(read_file);

my $code;

@BASE_CFG_FILES = (
);

#my %Adam = (
#   Modes => {
#      FName => "Adam",
#   },
#);


%PATTERNS_DEF = (
    # Each of the defined "modes" are checked inside of postsim.pl.  If no modes
    #   are ever "turned on" the test is automatically a fail.
    Modes => {
        DsaMode    => {
            # Set this attribute to totally ignore the mode
            Ignore       => 1,

            # This flag requires that this mode must be "activated" this many
            #   times during the test (ie. must have this many occurences of
            #   StartString)
            Required     => 0, # 0 false, otherwise true

            # Define the regular expression which "activates" this mode
            StartSting   => '/some expression/i',

            # Define the regular expression which "de-activates" this mode
            EndString    => '/some expression/',

            # Define a list of regular expressions which must all exist within
            #   the start and end expressions each time the mode is activated.
            # Note: An end string must be specified for RequiredText to be
            #   checked
            RequiredText => [
                '/required string 1/',
                '/Another required string/',
            ],

            # Define a list of regular expressions which are ignored within the
            # start and
            #  end expressions.
            okErrors => [
                '/error string 1/',
                '/ERROR string \#2/',
            ],
        },

        AceSpyglass_default => {
            Ignore      => 1,
            Required     => 0,
            StartString  => '/SPYGLASS EXECUTION START/',
            EndString    => '/SPYGLASS EXECUTION DONE/',
            RequiredText => [
                             '/SpyGlass Exit Code 0/',
                            ],
            okErrors     => [
                             '/\(0\s*error\,/',
                             '/[,:]\s*0\s*error/',
                             '/[,:]\s*\(?\s*0 [Ee]rrors*,/',
                             '/NOTE: It is recommended to first fix.*error/',
                             '/Please re-run SpyGlass once .*error clean/',
                             '/checking completed with errors/',
                             # https://hsdes.intel.com/appstore/article/#/1405277325/main
                             '/Please see ErrorAnalyzeBBox/',
                             '/Waived.*Messages.*[Ee]rrors/',
                             '/Total Number of Generated Messages .* errors/',
                            ],
        },

        AceLintra_default => {
            Ignore          => 0,
            Required        => 0,
            StartString     => '/^LINTRA EXECUTION STARTS HERE/',
            EndString       => '/^LINTRA EXECUTION ENDS HERE/',
            RequiredText    => [
                                    '/Lint status PASSED/',
                               ],
            okErrors        => [
                                    '/Arrived At: dsa.mem.[hs]werror[lh]/',
                                    '/severity: Error , count: [0-9]+ violations , waived: [0-9]+, not waived: 0/',
                               ],
        },

        DsaDefault => {
            Required     => 1,
            StartString  => '/SIM OUTPUT START/',
            EndString    => '/SIM OUTPUT DONE/',
            RequiredText => [
                '/TEST_COMPLETED/',
            ],
            okErrors     => [
                # UVM reporter summary lines to be ignored when error/fatal
                #   count is 0
                '/UVM_ERROR :\s*0/',
                '/UVM_FATAL :\s*0/',

                # Author: Adam Conyers
                # Date:   7/17/2023 
                # DSA HW and SW ERROR registers - Allow filter 'UVM_INFO' messages with these names to be OK since
                # Saola in DEBUG prints uses register names and these cause us to fail.  Any ERROR or FATAL should
                # still allow us to fail.
                '/^.*UVM_INFO.*[SH]WERROR[0-3]?.*$/',
                # Author: Sebin Kuriakose
                # Date:   5/16/2024
                # SGCDC Assertion Filters
                '/^.*strap_setid_sai.*sbw_setid.error does not toggle during simulation.*$/',
                # Author: Adil Shaaeldin
                # Date:   6/16/2017
                # ERROR:
                # '/^.*WARNING.*LP_ISO_OUT_TOGGLE.*swerror.*/',

                # Owner: Vijay Arputharaj
                # Date:  05/30/2018
                # Info:  Remove some uvm functions with error in the name that show up
                #        in error list due to calling $stack when uvm_fatal happens.
                '/^.*uvm_report_object::uvm_report_error.*$/',
                '/^.*uvm_sequence_item::uvm_report_error.*$/',
                '/^.*in uvm_report_error at.*uvm_globals\.svh.*$/',

                # Low power UPF normal error summary message
                '/.*ERROR = 0, FATAL = 0.*$/',

            ],
            okErrors_multiLine => [
                ##[<N lines per error message>, <match pattern for first line>, ..   , <line N-1 pattern> , <line N pattern ],
                # Author: Sebin Kuriakose
                # Date:   5/16/2024
                # SGCDC Assertion Filters
                [4, '/^.*SG_SVA_PROP.*ADVCDC_rfp_to_rst_2.ADVCDC_DETECT_RFP_SEQUENCE.*$/', '/^.*Offending.*$/', '/^.*SG_SVA_PROP.*ADVCDC_rfp_to_rst_2.ADVCDC_DETECT_RFP_SEQUENCE.*$/', '/^.*Assumption failure.*aon.aon_common.sb.sbe.i_sbcasyncclkreq_side_clk.clkreq_old, Destination:.*aon.aon_common.sb.side_clkack.*$/'],
                [4, '/^.*ADVCDC_datahold_Ac_datahold01a_.*$/', '/^.*Offending.*$/', '/^.*ADVCDC_datahold_Ac_datahold01a_.*$/','/^.*DataHold failure.*Destination:.*cfg.sfidfxsts.*debug.*12.*$/'],
            ],            
        },

        # For i64b60 specific filters
        DsaI64B60Default => {
            Required     => 0,
            StartString  => '/SIM OUTPUT START/',
            EndString    => '/SIM OUTPUT DONE/',
            okErrors     => [
                '/^.*imhb.*sva_rfip_read_write_exclusive_conflict.*$/',
            ],
        },

        # For CTO specific filters, to avoid test failures due to AER error txns
        DsaCTOAERcrossProduct => {
            Required     => 0,
            StartString  => '/CTOAERCrossProductFilterEnable/',
            EndString    => '/CTOAERCrossProductFilterDisable/',
            okErrors     => [
                # Owner: Renju Rajeev
                # Date:  06/22/2020
                # Info:  filter the IOSF compliance check errors generated by the aertraffic sequence, where we want a cross product with CTO/AER
                '/^.*primary_compmon.iosf_prim_target_completion_compliance_checks.PRI_014_AllResrvedFieldsInCompletionLowerAddressMustBeZero.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_014: Completion ADDRESS=.*Reserved bit\[7\] is not zero for:.*$/',
                '/^.*primary_compmon.iosf_prim_target_completion_compliance_checks.PRI_014_AllResrvedFieldsInCompletionLowerAddressMustBeZero.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_014: Completion ADDRESS=.*Reserved bit\[7\] is not zero for:.*$/',
                '/^.*primary_compmon.iosf_prim_target_completion_compliance_checks.PRI_199_SpuriousCompletionReceived.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_199 \(ERROR_05-01\): Spurious completion received.*$/',
                '/^.*primary_compmon.iosf_prim_target_transaction_compliance_checks.PRI_SOMENUM_RSVD1_7_RSVD_1_3_ZERO_FOR_VALID_COMMAND.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_0-6-21 \(PRI.106\): IOSF iosf_cmd.rsvd1_7 or iosf_cmd.rsvd1_3 is not valid during valid commandRequesterTenBitTagEn=0 CompleterTenBitTagEn=1 RType=2 Dir=T.*$/',
                '/^.*primary_compmon.iosf_prim_target_transaction_compliance_checks.dparity_1bit.PRI_286_DataParityMustBeEven.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_04-12b \(PRI_286\): IOSF Data parity failure DPARITY.*$/',
                '/^.*primary_compmon.iosf_prim_target_completion_compliance_checks.PRI_199_SpuriousCompletionReceived.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_199 \(ERROR_05-01\): Spurious completion received.*$/',
                '/^.*primary_compmon.iosf_prim_target_completion_compliance_checks.PRI_014_AllResrvedFieldsInCompletionLowerAddressMustBeZero.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_014: Completion ADDRESS=.*Reserved bit\[7\] is not zero for:.*$/',
                '/^.*primary_compmon.iosf_prim_target_transaction_compliance_checks.PRI_SOMENUM_RSVD1_1_RSVD_0_7_ZERO_FOR_VALID_COMMAND.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_0-6-21 \(PRI.106\): IOSF iosf_cmd.rsvd1_1 or iosf_cmd.rsvd0_7 is not valid during valid command.*$/',
                '/^.*primary_compmon.iosf_prim_target_completion_compliance_checks.MAX_ADDR_Completion_Check.PRI_014_AllResrvedFieldsInCompletionHigherAddressMustBeZero.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_014: Upper bits of Completion MADDRESS=.*were not zero for: .*$/',
                '/^.*dsa_analysis_checker.*$/',
                '/^UVM_ERROR :\s+\d+.*$/',
            ],
        },

        # Author: Jimmy Shen
        # Date:   04/08/2019
        # Description: The transition from supply_off to supply on causes some assertions in the sram to fire on that transition, so for
        #   this window of time, we filter those assertions.
        DsaSupplyOff => {
            Required => 0,
            StartString  => '/IP POWER GOOD CORRUPTED/',
            EndString    => '/IP POWER GOOD ASSERTED/',

            okErrors => [
                '/.*metastability on reset assert.*$/',
                '/.*ADVCDC_DETECT_QSRDC_NEGEDGE.*/',
            ],
        },

        # Author:      Jason Curtiss
        # Date:        01/25/2019
        # Description: Used when testing MTLP errors which cause IOSF
        #              compliance violations
        DSAMtlpErrFilt  => {
            Required    => 0,
            StartString => '/MTLP ErrFilter FILTER ENABLE/',
            #EndString   => '/MTLP ErrFilter FILTER DISABLE/',
            EndString    => '/^.*SIM OUTPUT END/',

            okErrors => [
                # IOSF Errors
                '/^.*primFabTi.genblk1.primary_compmon.iosf_prim_target_request_compliance_checks.Target_Request_Checks.PRI_078_NoAgentCanBeTargetedByRequestExceedingMaxPayloadSize.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_PRI_078: A request for the agent of length=.*DW exceeds the agent\'s Max_Payload_Size=.*DW in cmd:.*$/',
                '/^.*primFabTi.genblk1.primary_compmon.iosf_prim_target_completion_compliance_checks.target_completion_checks.PRI_048_NoAgentCanBeTargetedByCompletionExceedingMaxPayloadSize.*$/',
                '/^.*COMPLIANCE ERROR: ERROR_PRI_048: A completion of length=.* bytes exceeded the agent\'s Max_Payload_Size=.* for:.*$/',
                '/^.*primFabTi.genblk1.primary_compmon.agent_ism_compliance.ISMPM_081_InterfaceIdleForSixteenClocks.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_ISMPM_081: Agent ISM moved from ACTIVE to IDLE_REQtoo soon --- less than 16 clocks of inactivity.*$/',
                '/^.*primFabTi.genblk1.primary_compmon.iosf_prim_target_request_compliance_checks.PRI_(190|228)_Mem(Write|Read)AddressCombinedWithLengthDoesNotPass4KBBoundary.*$/',
                '/^.*COMPLIANCE ERROR: ERROR_PRI_(190|228): IOSF memory (write|read) request crossed a 4KB boundary with MADDRESS=.*plus MLENGTH=.*total of DW=.*for cmd:.*$/',

                # ICXL Errors
                '/^.*compmon.h2d_req_io.mps_length.*$/',
                '/^.*ICXL COMPLIANCE ERROR: DOWNSTREAM: CplD has length = .* \(dw\) which is larger than MPS = .* \(bytes\).*$/',

                # MTLP errors can leave the DUT not responding to outstanding NP on interface
                # resulting in hung ISM, leading to inability to deassert pok for reset sequence
                # Halt states can cause IOSF primary to get stuck in Active state
                # because credits can not be returned.  This leads to prim_pok not
                # being able to deassert, forcing PMC to timeout and issue a
                # reset. The testbench and RTL have errors that fire in this case
                # which must be filtered for Halt state error testing.
                '/^.*centralResetSeq.*prim_pok.*side_pok were not asserted.*$/',
                '/^.*base.crp.VALID_PRIM_RST_ASSERT.*$/',
                '/^.*base.crp.VALID_SIDE_RST_ASSERT.*$/',
                '/^.*UVM_ERROR :    \d+.*$/',
            ],
        },

        # Author:      Jason Curtiss
        # Date:        01/31/2019
        # Description: Used when testing Halt errors
        DSAHaltErrFilt  => {
            Required    => 0,
            StartString => '/Halt ErrFilter FILTER ENABLE/',
            #EndString   => '/Halt ErrFilter FILTER DISABLE/',
            EndString    => '/^.*SIM OUTPUT END/',

            okErrors => [
                # Halt states can cause IOSF primary to get stuck in Active state
                # because credits can not be returned.  This leads to prim_pok not
                # being able to deassert, forcing PMC to timeout and issue a
                # reset. The testbench and RTL have errors that fire in this case
                # which must be filtered for Halt state error testing.
                '/^.*centralResetSeq.*prim_pok.*side_pok were not asserted.*$/',
                '/^.*base.crp.VALID_PRIM_RST_ASSERT.*$/',
                '/^.*base.crp.VALID_SIDE_RST_ASSERT.*$/',
                '/^.*base.core.atc.pri.TOO_MANY_PRMS.*$/',
                '/^.*UVM_ERROR :    \d+.*$/',

                # UC + Command Parity error results in ISM transitioning to idle too soon
                # but this is a Halt condition that requires a reset, so not a platform issue.
                '/^.*primFabTi.genblk1.primary_compmon.agent_ism_compliance.ISMPM_081_InterfaceIdleForSixteenClocks.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_ISMPM_081: Agent ISM moved from ACTIVE to IDLE_REQtoo soon --- less than 16 clocks of inactivity.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        04/23/2019
        # Description: Used when testing various errors from Dsa2_err_007. This appears here instead of the test specific filter for cases where
        #   the test sequence may be resused in other test scenarios.
        Dsa2Err007Filt  => {
            Required    => 0,
            StartString => '/Dsa2_err_007_seq FILTER START/',
            EndString   => '/Dsa2_err_007_seq FILTER END"/',

            okErrors => [
                '/^.*primary_compmon.iosf_prim_target_transaction_compliance_checks.dparity_.bit.PRI_286_DataParity\d?MustBeEven.*$/',
                '/^.*primary_compmon.iosf_prim_master_transaction_compliance_checks.dparity_.bit.PRI_286_DataParity\d?MustBeEven.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_04-12b \(PRI_286\): IOSF Data parity failure DPARITY.*$/',
                '/^.*\.mem\.AS_CB_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCPA_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCVA_P_ERR.*$/',
                '/^.*\.mem\.AS_DEXD_P_ERR.*$/',
                '/^.*\.mem\.AS_DEXR_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCCF_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCINV_P_ERR.*$/',
                '/^.*\.mem\.AS_DB_P_ERR.*$/',
                '/^.*\.mem\.AS_BEXD_P_ERR.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        03/17/2021
        # Description: Used when testing various errors from Dsa2_err_062 (internal error injection)
        Dsa2Err062Filt  => {
            Required    => 0,
            StartString => '/Dsa2_err_062_seq FILTER START/',
            EndString   => '/Dsa2_err_062_seq FILTER END"/',

            okErrors => [
                '/^.*primary_compmon.iosf_prim_target_transaction_compliance_checks.dparity_.bit.PRI_286_DataParity\d?MustBeEven.*$/',
                '/^.*primary_compmon.iosf_prim_master_transaction_compliance_checks.dparity_.bit.PRI_286_DataParity\d?MustBeEven.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_04-12b \(PRI_286\): IOSF Data parity failure DPARITY.*$/',
                '/^.*\.mem\.AS_CB_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCPA_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCVA_P_ERR.*$/',
                '/^.*\.mem\.AS_DEXD_P_ERR.*$/',
                '/^.*\.mem\.AS_DEXR_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCCF_P_ERR.*$/',
                '/^.*\.mem\.AS_ATCINV_P_ERR.*$/',
                '/^.*\.mem\.AS_DB_P_ERR.*$/',
                '/^.*\.mem\.AS_BEXD_P_ERR.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        05/21/2019
        # Description: Temporary filter for ATS failures until error manager support is ready. This is a conditional filter turned
        #   on for a specific test under a specific error condition scenario
        Dsa2Err007PrsCplRecTempFilt  => {
            Required    => 0,
            StartString => '/Dsa2_err_007_seq PRS_CPLREC_TEMP FILTER START/',
            EndString   => '/Dsa2_err_007_seq PRS_CPLREC_TEMP FILTER END"/',

            okErrors => [
                '/^.*ERRCORSTS[:]ANF should be \'h0.*$/',
                '/^.*DEVSTS[:]CED should be \'h0.*$/',
                '/^.*ERRUNCSTS[:]UC should be \'h0.*$/',
                '/^.*DEVSTS[:]FED.*$/',
                '/^.*PCISTS[:]SSE should be \'h0.*$/',
                '/^.*No unaffiliated err, but we found extra sbErrMsg remaining.*$/',
                '/^.*UVM_ERROR :    \d+.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        03/30/2021
        # Description: MTLP filter
        Dsa2Err061MtlpFilt  => {
            Required    => 0,
            StartString => '/Dsa2_err_061_seq MTLP FILTER START/',
            EndString   => '/Dsa2_err_061_seq MTLP FILTER END"/',

            okErrors => [
                '/^.*VALID_PRIM_RST_ASSERT.*$/',
                '/^.*VALID_SIDE_RST_ASSERT.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        03/30/2021
        # Description: VC sends completions larger than DUT programmed MPS
        Dsa2Err061MtlpMpsFilt  => {
            Required    => 0,
            StartString => '/Dsa2_err_061_seq MTLP MPS FILTER START/',
            EndString   => '/Dsa2_err_061_seq MTLP MPS FILTER END"/',

            okErrors => [
                '/^.*PRI_048_NoAgentCanBeTargetedByCompletionExceedingMaxPayloadSize_ASSERT.*$/',
                '/^.*ERROR_PRI_048.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        04/08/2020
        # Description: Filter for RTL assertions that fire when internal error injection is done
        #   on for a specific test under a specific error condition scenario
        Dsa3Err029Filt  => {
            Required    => 0,
            StartString => '/Dsa3_err_029_seq FILTER START/',
            EndString   => '/Dsa3_err_029_seq FILTER END/',

            okErrors => [
                '/^.*\.mem\.AS_DEXD_P_ERR.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        04/10/2019
        # Description: Used when a 'dirty' reset is issued (no reset prep issued during a 'chassis' reset)
        DsaChassisDirtyReset  => {
            Required    => 0,
            StartString => '/Start Chassis Dirty Reset/',
            EndString   => '/End Chassis Dirty Reset/',

            okErrors => [
                # During the reset flow, the RTL attempts to protected certain assertions from firing via a 'reset_pending' state.
                # When no reset_prep is issued, it no longer knows it's in the reset flow, which causes these to fire.
                '/^.*base.crp.VALID_PRIM_RST_ASSERT.*$/',
                '/^.*base.crp.VALID_SIDE_RST_ASSERT.*$/',
            ],
        },


        #HSD hsd_22018341930
        #BFM bug if reset aligns with the very final cycle of a sideband packet where EOM is going to be asserted.  The reset thread emptied out the queue, and then the driving thread calls “pop_item” but the queue is already empty so the error fires.
        DsaSVCResetVsCreditRace  => {
            Required    => 0,
            StartString => '/SVC RESET VS CREDIT RACE FILTER ENABLE/',
            EndString   => '/SVC RESET VS CREDIT RACE FILTER DISABLE/',

            okErrors => [
                '/^.*sbcport.mpccup_ism_not_active.*$/',
                '/^.*SVC_INIT.*Not able to find xaction in the que.*$/',
            ],
        },

        # Author:      Jimmy Shen
        # Date:        10/19/2020
        # Description: Filters specific to FLR Flow (for the 'recommeneded' PCIE flow that involves clearing PCICMD)
        DsaRecommendedPcieFLR  => {
            Required    => 0,
            StartString => '/Recommended PCIE FLR Flow FILTER ENABLE/',
            EndString   => '/Recommended PCIE FLR Flow FILTER DISABLE/',

            okErrors => [
                # When MSE is cleared, RTL will return UR on mem space register reads (which can come from the Driver during this flow)
                '/^.*PVC read operation completed with bad completion status.*.*$/',
            ],
        },

        # This filter is attached to the above filter. The above filter activates during a specific window, this filter is only to disable
        # the UVM_ERROR count at the end (since the above error is an UVM_ERROR)
        DsaRecommendedPcieFLROvm  => {
            Required    => 0,
            StartString => '/Recommended PCIE FLR Flow FILTER DISABLE/',
            EndString   => '/finish called from file/',

            okErrors => [
                '/^.*UVM_ERROR :\s*\d+\s*$/',
            ],
        },

        # Author:      Chaithra Venkategowda
        # Date:        01/21/2020
        # Description: Filter IOSF Sideband errors when Sideband illegal messages are sent from TB for Sideband band error testing
        #    This partciular case is when opcodes OP_MRD, OP_MWR are sent with data size > 8B
        DsaSBIllegalDataSize => {
            Required    => 0,
            StartString => '/ENABLE SB ILLEGAL DATA SIZE FILTER/',
            EndString   => '/# merge_fail_logs.pl DONE/',

            okErrors => [
                # During the  flow, the RTL and BFM reports few error related to illegal SB messages.
                '/^.*SBMI_034_053_RegWriteIsValid_NonZeroSBE_ASSERT.*$/',
                '/^.*SBMI_034_053_RegWriteIsValid_ZeroSBE_ASSERT.*$/',
                '/^.*IOSF COMPLIANCE ERROR: ERROR_SBMI_034_053: Register write with SBE .* and size = .*W .*ignoring expanded headers.* does not have .* of data.*$/',
                '/^.*UVM_ERROR.*vr_sbc_0089.*$/',
                '/^.*UVM_ERROR.*vr_sbc_0109.*$/',
                '/^.*UVM_ERROR.*vr_sbc_0214.*$/',
                '/^.*UVM_ERROR :   \d.*$/',
                '/^.*UVM_ERROR :    \d.*$/',
            ],
        },

    },


    # List of classified errors to look for.
    # The parser searchs for 'All' first. Then tries to classify
    # For instance,
    # # ** Error: static memory checker error : C17 : - SRAM - ....
    # The above error is matches first with the 'All' regular expression.
    # Then it matches with the '1 Static_Mem' classification.
    # The Number in front of classification is used to order the
    # error types, ie, 1 is more serious than 2.
    #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # NOTE: These errors are only matched when one of the above "modes" is
    #   active, otherwise they are IGNORED!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    Errors => [
        # Error regular expr          Category    Severity
        [ '/Error/i',                 "ALL",      1       ],
        [ '/UVM_FATAL/',              "ALL",      3       ],
        [ '/ failed at /',            "ALL",      2       ],
    ],

    # Timeout strings which result in a postsim.fail with status of "Timeout"
    TimeoutErrors => [
        '/Simulation TIMEOUT reached/i',
        '/^.*\[PH_TIMEOUT\] Explicit timeout of .* hit\, indicating a probable testbench issue.*$/',
    ],

    # This is a list of errors which are to be considered FATAL errors
    #   regardless of whether they show up before or after the "StartOn" or
    #   "EndOn" conditions.
    FatalErrors => [
    ],

    # Defines a list of warnings to look for
    Warnings => [
        '/warning/i',
    ],

    # Defines a list of errors which are 'safe' to ignore
    #
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # NOTE: These errors will be ignored globally (ie. for any of the "modes")
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    okErrors => [
        # Note: Please place global errors in DsaDefault above.
    ],

    okErrors_multiLine => [
        ##[<N lines per error message>, <match pattern for first line>, ..   , <line N-1 pattern> , <line N pattern ],
        #[3, "/ERROR.*\(introduced error\)/", "/At time/", "/ERROR - dsa multi-line error/"],
    ],

    # Any additional information that is required from the logfile can be
    #   entered here:
    #
    # This is what is already extracted:
    #   Test name:
    #   Test type:  (Verilog procedural or Xscale assembly)
    #   Status:
    #   Cause: (for fails only)
    #   Error Count:
    #   Warning Count:
    #   SIMPLI Error Count:
    #   SIMPLI Check Count:

    # Default test type is "proc" procedural.  Gets changed to "asm" for
    #   assembly if the following regular expression matches in the transcript.
    TestType => {
        Default => {
            regex   => undef,
            keyword => "Proc",
        },
        Assembly => {
            regex   => '/Reading test memory image/',
            keyword => "Asm",
        },
    },

    TestInfo => [
        # Use this to add to, or overwrite the standards
        #   defined in $ACE_HOME/udf/ace_test_info.pp
    ],

    # Simple calulations based on contents of the 'TestInfo' array
    Calculations => {
        SimRate => '($TestInfo{Runtime} != 0) ?
                   $TestInfo{Cycles}/$TestInfo{Runtime} : 0',
    },
);

# This pulls in generated file from our test area which has all the run_modes for
# tests that need special handling
my $code = read_file("$ENV{WORKAREA}/verif/tb/tests/base/DsaOKError.pm");
eval $code;

};
