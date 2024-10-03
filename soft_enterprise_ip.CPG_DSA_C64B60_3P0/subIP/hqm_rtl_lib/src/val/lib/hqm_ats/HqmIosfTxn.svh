// -----------------------------------------------------------------------------
// Copyright(C) 2014 - 2019 Intel Corporation, Confidential Information
// -----------------------------------------------------------------------------
// Created By:  Mohammed Hawana, Jason Curtiss
// Created On:  12/31/2014
// Description: IOSF primary transaction class with HQM specific constraints.
// -----------------------------------------------------------------------------


//--AY_HQMV30_ATS--  

//--AY_HQMV30_ATS-- class HqmIosfTxn extends IosfPvcUtilsPkg::IosfPvcTxn;
class HqmIosfTxn extends IosfPkg::IosfTxn;

    bit allowErrs = 0;
    bit has10BitTagSupport = 1;

    rand bit      vc;
    rand bit      vc_en[];
    rand bit[7:0] tc_vc_map[];

    rand bit allowUrErrs;
    rand bit allowCaErrs;
    rand bit allowEpErrs;
    rand bit allowRsvdErrs;
    rand bit allowMtlpErrs;
    rand bit allowDataParityErrs;
    rand bit allowCmdParityErrs;

    constraint allowUrErrors_c {
        allowUrErrs dist {
            0         :/ 6,
            allowErrs :/ 4
        };
    }

    constraint allowCaErrors_c {
        allowCaErrs dist {
            0         :/ 6,
            allowErrs :/ 4
        };
    }

    constraint allowEpErrors_c {
        allowEpErrs dist {
            0         :/ 5,
            allowErrs :/ 5
        };
    }

    constraint allowRsvdErrors_c {
        allowRsvdErrs dist {
            0         :/ 6,
            allowErrs :/ 4
        };
    }

    constraint allowMtlpErrs_c {
        allowMtlpErrs dist {
            0         :/ 7,
            allowErrs :/ 3
        };
    }

    constraint allowDataParityErrs_c {
        allowDataParityErrs dist {
            0         :/ 5,
            allowErrs :/ 5
        };
    }

    constraint allowCmdParityErrs_c {
        allowCmdParityErrs dist {
            0         :/ 7,
            allowErrs :/ 3
        };
    }

    constraint driveBadParity_c { // overrides base PVC constraint in IosfTxnConstraints.h
        solve allowDataParityErrs, cmd, adrs before driveBadDataParity, driveBadDataParityCycle, driveBadDataParityPct;

        if (allowErrs && allowDataParityErrs) {
            driveBadDataParity dist {
                0 :/ 80,
                1 :/ 20
            };

            driveBadDataParityCycle dist {
                0         :/ 25,
                1         :/ 25,
                [2:16]    :/ 25,
                [17:1023] :/ 25
            };

            driveBadDataParityPct dist {
                0        :/ 20,
                [1:30]   :/ 20,
                [31:100] :/ 60
            };
        } else {
            driveBadDataParity      == 0;
            driveBadDataParityCycle == 0;
            driveBadDataParityPct   == 0;
        }
    }

    constraint driveCmdParity_c {
        solve allowCmdParityErrs before driveBadCmdParity;

        if (allowCmdParityErrs) {
            driveBadCmdParity dist {
                1 :/ 7,
                0 :/ 3
            };
        } else {
            driveBadCmdParity == 0;
        }
    }

    constraint errorPresent_c {
        solve allowEpErrs, cmd before errorPresent;

        if (!allowEpErrs ||
            (cmd inside {
                IosfPkg::Iosf::MRd32, IosfPkg::Iosf::MRd64, IosfPkg::Iosf::MRdLk32, IosfPkg::Iosf::MRdLk64,
                IosfPkg::Iosf::LTMRd32, IosfPkg::Iosf::LTMRd64, IosfPkg::Iosf::Cpl,
                IosfPkg::Iosf::IORd, IosfPkg::Iosf::CfgRd0, IosfPkg::Iosf::CfgRd1,
                IosfPkg::Iosf::Msg0, IosfPkg::Iosf::Msg1, IosfPkg::Iosf::Msg2, IosfPkg::Iosf::Msg3,
                IosfPkg::Iosf::Msg4, IosfPkg::Iosf::Msg5, IosfPkg::Iosf::Msg6, IosfPkg::Iosf::Msg7
            })) {

            errorPresent == 0;
        } else if (allowEpErrs) {
            errorPresent dist { 0 :/ 90, 1 :/ 10 };
        }
    }

    constraint rsvd_c {
        solve allowRsvdErrs before rsvdDW0B7, rsvdDW1B1, rsvdDW1B3, rsvdDW1B7;

        if (allowRsvdErrs) {
            rsvdDW1B7 dist { 0 :/ 50, 1 :/ 50 };
            rsvdDW1B3 dist { 0 :/ 50, 1 :/ 50 };
            rsvdDW1B1 dist { 0 :/ 50, 1 :/ 50 };
            rsvdDW0B7 dist { 0 :/ 50, 1 :/ 50 };

            // For models with Gen4 support, following two reserved
            // bits become part of 10-bit tag. So don't constrain them
            if (has10BitTagSupport) {
                rsvdDW1B3 == 1'b0;
                rsvdDW1B7 == 1'b0;
            }
        } else {
            rsvdDW1B7 == 0;
            rsvdDW1B3 == 0;
            rsvdDW1B1 == 0;
            rsvdDW0B7 == 0;
        }
    }

    constraint hqm_chan_c {
       reqChId == 0;
    }

    // TODO: Why is this hardcoded and not just fully random?
    constraint hqm_req_id_field_c {
        soft reqID == 'h9876;
    }

    constraint unsupported_pins_c {
        soft root_space     == 0;
        soft byteEnWithData == 0;
        soft cid            == 0;
        soft destID         == 0;
        soft ecrc_gen       == 0;
        soft ecrc_err       == 0;
        soft opportunistic  == 0;
`ifdef HQM_IOSF_2019_BFM
`else
             ide_t == 0; // new signals in /p/acd/proj/vte/release/IOSF_Primary_VC/5.IOSF_PVC_2021Q1.patch.1/ph4/common/IosfTxn.svh 
             ide_full == 0; // new signals in /p/acd/proj/vte/release/IOSF_Primary_VC/5.IOSF_PVC_2021Q1.patch.1/ph4/common/IosfTxn.svh 
             ide_mac == 0; // new signals in /p/acd/proj/vte/release/IOSF_Primary_VC/5.IOSF_PVC_2021Q1.patch.1/ph4/common/IosfTxn.svh 
`endif
    }

    constraint hqm_pasidtlp_c {
        soft pasidtlp[22] == 0;
    }

    constraint vc_c {
        solve vc_en before vc;

        if (!allowMtlpErrs) {
            foreach (vc_en[i]) {
                if (!vc_en[i]) {
                    vc != i;
                }
            }
        }
    }

    constraint tc_c {
        solve vc, tc_vc_map, allowMtlpErrs before trafficClass;

        if (!allowMtlpErrs) {
            // PCIe 4.0, 2.2.8.4: Unlock messages must be TC==0,
            if (cmd == IosfPkg::Iosf::Msg3 && last_byte_en == 4'h0 && first_byte_en == 4'h0) {
                trafficClass == 0;
            }

            // PCIe 4.0, 2.5.3: Unmapped TCs are MTLP errors when VC0CTL CSR is
            // implemented.  When VC0CTL is not implemented, all TCs are assumed
            // to map to TC0, but when it is implemented PCIe only defines a
            // 3-bit TC, so any TC using the 4th bit is automatically unmapped.
            trafficClass[3] == 0;
            foreach (tc_vc_map[i]) {
                if (i == vc) {
                    foreach (tc_vc_map[i][j]) {
                        if (!tc_vc_map[i][j]) {
                            trafficClass != j;
                        }
                    }
                }
            }
        }
    }

    constraint adrs_c {
        solve cmd before adrs;
        solve last_byte_en before adrs;
        solve first_byte_en before adrs;
        solve cfgBusSelect before adrs;

        // Note: This is a change from base adrs_c constraint
        //       from the PVC.   If procHint is non-0,
        //       allow adrs[1:0] to randomize which become the
        //       processing hints (PH field)
        //
        // memory, io, and atomic operations must be DW aligned
        if ((space inside {Iosf::MEM, Iosf::IO}) || atomic) {
            if (procHint == 1'b0) {
                adrs[1:0] == 0;
            }
        }

        // setup 32 bit operations to not use their upper address
        if (cmd inside { Iosf::MRd32,  Iosf::LTMRd32,  Iosf::MRdLk32,
                         Iosf::MWr32,  Iosf::LTMWr32,  Iosf::IORd,
                         Iosf::IOWr,   Iosf::FAdd32,   Iosf::Swap32,
                         Iosf::CAS32,  Iosf::NPMWr32}) {
            adrs[63:32] == 0;
        }
        // 64 bit commands MUST use upper address
        else if (cmd inside {
            Iosf::MRd64,  Iosf::LTMRd64, Iosf::MRdLk64,
            Iosf::MWr64,  Iosf::LTMWr64, Iosf::FAdd64,
            Iosf::Swap64, Iosf::CAS64,   Iosf::NPMWr64}) {

            adrs[63:32] != 0;

        } else if (cmd inside {
            Iosf::Msg0,  Iosf::Msg1,  Iosf::Msg2,  Iosf::Msg3,  Iosf::Msg4,
            Iosf::Msg5,  Iosf::Msg6,  Iosf::Msg7,  Iosf::MsgD0, Iosf::MsgD1,
            Iosf::MsgD2, Iosf::MsgD3, Iosf::MsgD4, Iosf::MsgD5, Iosf::MsgD6,
            Iosf::MsgD7})
        {
            if (!((last_byte_en == 4'b0111) && (first_byte_en[3:1] == 3'b111))){
                adrs[15:0] == 0;
            }
        } else if (space == Iosf::CFG) {
            // configuration transactions need to use the various cfg cycle attributes
            // to form an address
            adrs[63:32] == 0;
            adrs[31:24] == cfgBus;
            adrs[23:19] == cfgDevice;
            adrs[18:16] == cfgFunction;
            adrs[15:12] == 0;
            adrs[11:2]  == cfgRegister[11:2];
            adrs[1]     == 0;
            // config type dictates whether bit 0 is reserved or a bus select
            // if (cmd inside {READ0, WRITE0}) adrs[0] == cfgBusSelect;
            // else if (cmd inside {READ1, WRITE1}) adrs[0] == 0;
            if (cmd inside {Iosf::CfgRd1, Iosf::CfgWr1}) adrs[0] == 0;
            // TODO:  FIX Env so cfgBusSelect gets set accorinding to Bus Select Strap.
            // and pass that to Compmon. This likely should be a new Parameter.
            // Set to 0 for now
            //     else if (cmd inside {Iosf::CfgRd0, Iosf::CfgWr0})
            //              adrs[0] == cfgBusSelect;
            else if (cmd inside {Iosf::CfgRd0, Iosf::CfgWr0}) adrs[0] == 0;
        }

        // atomic operations must be naturally aligned
        if (cmd inside {Iosf::FAdd32, Iosf::FAdd64, Iosf::Swap32, Iosf::Swap64}) {
            if (length == 2) {
                adrs[2:0] == 3'b000;
            }
        } else if (cmd inside {IosfPkg::Iosf::CAS32, IosfPkg::Iosf::CAS64}) {
            if      (length == 4) adrs[2:0] == 3'b000;
            else if (length == 8) adrs[3:0] == 4'b0000;
        }
    }

    // Base IosfTxn constraint is broken for 4k lengths and also
    // prevents sending MsgD larger than 64 bytes, so overriding to fix
    constraint length_c {
        solve length before adrs;

        (length < 1024) && (length >= 0);

        // messages without data have length of 0
        if (message && (!cmd[6])) {
            length == 0;

        // setup messages which do contain data
        } else if (message && cmd[6]) {
            // Base BFM constraint is broken here
            // (length > 0) && (length <= 16);
            //--AY_TMP-- if (mps < 4096) {
            //--AY_TMP--     (length > 0) && (length <= mps/4);
            //--AY_TMP-- }

        // config operations
        } else if (space == Iosf::CFG) {
            length == 1;

        // IO operations (and Funny IO)
        } else if (space == Iosf::IO) {
            if (adrs >= 'h10003) {
                length inside {1, 2};
                if (length == 2) {
                    adrs[2:0] == 3'b000;
                }
            } else {
                length == 1;
            }

        // setup atomic lengths based on operands
        } else if (atomic) {
            // Table 2-4:
            if (cmd inside {Iosf::CAS32, Iosf::CAS64}) {
                length inside {2, 4, 8};
            } else if (cmd inside {Iosf::FAdd32, Iosf::FAdd64, Iosf::Swap64, Iosf::Swap32}) {
                length inside {1, 2};
            }
        }
    }

    // PVC does not natively constrain reads based on configured MRRS
    constraint mrrs_length_c {
        if (read) {
            // IOSF spec-special case where MRRS=64 means
            // reads cannot cross a 64-byte boundary
            //--AY_TMP-- if (mrrs == 64) {
                length <= (16 - adrs[5:2]);
            //--AY_TMP-- } else if (mrrs != 4096) {
            //--AY_TMP--     length inside {[1:mrrs/4]};
            //--AY_TMP-- }
        }
    }

    // Overide IosfPvcTxn constraint to add allowMtlpErrs flag
    // override, so that the MTLP condition can be generated.
    constraint mps_length_c {
        solve allowMtlpErrs before length;

        // Do not allow lengths greater than hardcoded IMPS in HQM since
        // this causes RTL assertions to fire since the design does not robustly
        // handle this case.
        if (write || cmd == IosfPkg::Iosf::CplD) {
            length != 0 && length <= 128; // 512 bytes
        }

        // Length no greater than MPS (converted to DWs)
        // Note: IOSF encodes 4096 bytes as length==0.
        if (!allowMtlpErrs) {
            if (write || cmd == IosfPkg::Iosf::CplD) {
                //--AY_TMP-- if (mps < 4096) {
                //--AY_TMP--     length > 0 && length <= mps/4;
                    // If MPS is 64, txn cannot cross 64B boundry
                //--AY_TMP--     if (mps == 64) {
                //--AY_TMP--         length <= (16 - adrs[5:2]);
                //--AY_TMP--     }
                //--AY_TMP-- }
            }
        }
    }

    // PVC does not natively constrain requests from crossing a 4k boundary
    constraint boundary_4k_c {
        solve length before adrs;

        if (!allowMtlpErrs) {
            if (read || write) {
                if (length == 0) {
                    // Special 4k read case
                    adrs[11:2] == 0;
                } else {
                    length <= (1024-adrs[11:2]);
                }
            }
        }
    }

    constraint address_c {
        solve adrs before address;
        address == adrs[63:0];
    }

    // IO, Cfg, MSI, and non-VDM not allowed to set certain attributes
    constraint legal_attributes_c {
        solve cmd before nonSnoop, relaxedOrdering, idBasedOrdering;

        if (cmd inside {IosfPkg::Iosf::IOWr, IosfPkg::Iosf::IORd, IosfPkg::Iosf::CfgWr0, IosfPkg::Iosf::CfgWr1, IosfPkg::Iosf::CfgRd0, IosfPkg::Iosf::CfgRd1}) {
            nonSnoop == 0;
            relaxedOrdering == 0;
            idBasedOrdering == 0;
        }

        // Note: 0xFEEx_xxxx is the Intel defined MSI range in the
        // Intel Software Programmers Guide.  The IOSF compliance checker
        // hard-codes this region, as it is the only expected MSI range
        // in IA.
        if (cmd == IosfPkg::Iosf::MWr32 && adrs[32:20] == 12'hFEE) {
            nonSnoop == 0;
            relaxedOrdering == 0;
        }

        // Messages must have NS/RO = 0, except for VDM messagess
        if (cmd inside {[IosfPkg::Iosf::Msg0 : IosfPkg::Iosf::Msg7], [IosfPkg::Iosf::MsgD0 : IosfPkg::Iosf::MsgD7]} &&
            !((last_byte_en == 4'b0111) && (first_byte_en[3:1] == 3'b111)))
        {
            nonSnoop == 0;
            relaxedOrdering == 0;
        }
    }

    // PCI-e spec does not define what a non TA should do it it receives AT=1
    // The RTL ignores the bit entirely, and the IOSF checker flags errors
    // when the DUT returns completions because they do not follow the ATS rules.
    constraint address_type_c {
        atSvc == 0;
    }

    constraint ur_cases_c {
        if (!allowUrErrs) {
            // Unsupported Request Types
            !(cmd inside {
                IosfPkg::Iosf::CfgWr1,  IosfPkg::Iosf::CfgRd1,
                IosfPkg::Iosf::IOWr,    IosfPkg::Iosf::IORd,
                IosfPkg::Iosf::Msg0,    IosfPkg::Iosf::MsgD0,
                IosfPkg::Iosf::MsgD3,
                IosfPkg::Iosf::Swap32,  IosfPkg::Iosf::Swap64,
                IosfPkg::Iosf::FAdd32,  IosfPkg::Iosf::FAdd64,
                IosfPkg::Iosf::CAS32,   IosfPkg::Iosf::CAS64,
                IosfPkg::Iosf::MRdLk32, IosfPkg::Iosf::MRdLk64
            });

            if (cmd == IosfPkg::Iosf::Msg2) {
                {last_byte_en, first_byte_en} == 8'h5; // PRS Response
            }

            if (cmd == IosfPkg::Iosf::MsgD2) {
                {last_byte_en, first_byte_en} == 8'h1; // Invalidation Request
            }

            if (cmd == IosfPkg::Iosf::Msg3) {
                {last_byte_en, first_byte_en} == 8'h00; // Unlock
            }

            if (cmd inside {IosfPkg::Iosf::Msg4, IosfPkg::Iosf::MsgD4}) {
                // Pcie 4.0, Table 2-31, Ignored Messages
                {last_byte_en, first_byte_en} inside {
                    8'h40, 8'h41, 8'h43, 8'h44, 8'h45, 8'h47, 8'h48
                };
            }
        }
    }

    // -------------------------------------------------------------------------
    `ovm_object_utils(HqmIosfTxn)

    // -------------------------------------------------------------------------
    function new(string name = "HqmIosfTxn");
        super.new();
        set_name(name);
    endfunction

endclass

