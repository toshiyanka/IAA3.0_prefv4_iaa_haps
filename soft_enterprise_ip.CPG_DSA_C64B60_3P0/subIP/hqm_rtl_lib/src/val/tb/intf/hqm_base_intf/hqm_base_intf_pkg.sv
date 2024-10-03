// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2016) Intel Corporation All Rights Reserved.
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_base_intf.sv
// Author : 
//
// Description :
// Package: hqm_base_intf_pkg
// rootbus/secbus/subordbus and hi/low base/limit interface types and abstract interface.
//
// -----------------------------------------------------------------------------
`ifndef __hqm_base_intf_pkg_sv__
`define __hqm_base_intf_pkg_sv__


package hqm_base_intf_pkg;

    // Type: instid_t
    typedef int      instid_t;

    // Type: rootbus_t
    typedef int      rootbus_t;

    // Type: secbus_t
    typedef int      secbus_t;

    // Type: subordbus_t
    typedef int      subordbus_t;

    // Type: hqm_busnum_ctrl_t
    typedef int      hqm_busnum_ctrl_t;


    typedef  struct packed {
       bit[63:0] addr_lo;
       bit[63:0] addr_hi;
    } hqm_addrmap_t;



/* Class: hqm_base_intf
 *
 * Represents configuration interface to get information related to a Inter Socket Routing
 *
 */

interface class hqm_base_intf;

    pure virtual function  string      get_inst_suffix_val();
    pure virtual function  instid_t    get_instid_val();
    pure virtual function  rootbus_t   get_rootbus_val();
    pure virtual function  secbus_t    get_secbus_val();
    pure virtual function  subordbus_t get_subordbus_val();
    pure virtual function  hqm_busnum_ctrl_t  get_busnumctrl_val();
    pure virtual function  hqm_busnum_ctrl_t  get_ralbdfctrl_val();
    pure virtual function  hqm_busnum_ctrl_t  get_raloverridectrl_val();
    pure virtual function  hqm_busnum_ctrl_t  get_bdf_val();
    pure virtual function  string      get_register_access_type();

    //--returns hqm_addrmap_t object
    pure virtual function  hqm_addrmap_t get_hqm_addrmap_func_pf_val();

    //--returns hqm_addrmap_t object
    pure virtual function  hqm_addrmap_t get_hqm_addrmap_func_vf_val();

    //--returns hqm_addrmap_t object
    pure virtual function  hqm_addrmap_t get_hqm_addrmap_csr_pf_val();

    //--returns hqm_addrmap_t object
    pure virtual function  hqm_addrmap_t get_hqm_addrmap_dram_val();

endclass

endpackage

`endif

