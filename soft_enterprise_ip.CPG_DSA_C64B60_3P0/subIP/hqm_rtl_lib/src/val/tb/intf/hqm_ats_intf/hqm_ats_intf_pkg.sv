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
// File   : hqm_ats_intf.sv
// Author : 
//
// Description :
// Package: hqm_ats_intf_pkg
//
// -----------------------------------------------------------------------------
`ifndef __hqm_ats_intf_pkg_sv__
`define __hqm_ats_intf_pkg_sv__


package hqm_ats_intf_pkg;

    // Type: instid_t
    typedef int      val_t;




/* Class: hqm_ats_intf
 *
 * Represents configuration interface to get information related to a Inter Socket Routing
 *
 */

interface class hqm_ats_intf;

    pure virtual function  string   get_agent_name();
    pure virtual function  val_t    get_interface_bus();
    pure virtual function  val_t    get_active();
    pure virtual function  val_t    get_iommubdf();
    pure virtual function  val_t    get_dis_tracker();
    pure virtual function  val_t    get_dis_checker();
    pure virtual function  val_t    get_dis_ats_check();
    pure virtual function  val_t    get_dis_invats_check();
    pure virtual function  val_t    get_disable_tb_report_severity();


endclass

endpackage

`endif

