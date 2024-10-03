// =====================================================================================================
// FileName          : dfx_tap_util.dv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Tue Jun 15 17:41:28 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// TAP Utility functions collected in one place
//
// This class provides miscellaneous utility functions geared towards TAP operations.  It has no
// variable members of its own - all operations are on arguments supplied by users/callers.
//
// Because this class has no member variables, it is a static class - all function members are
// static.  It's really more like a namespace than a class.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_UTIL_SV
`define DFX_TAP_UTIL_SV

class dfx_vif_container #(type T = int) extends ovm_object;
  protected T v_if;

  function new(string name = "dfx_vif_container");
    super.new(name);
  endfunction

  virtual function void set_v_if(T virt_if);
    v_if = virt_if;
  endfunction : set_v_if

  virtual function T get_v_if();
    return(v_if);
  endfunction : get_v_if

  virtual function ovm_object clone();
    dfx_vif_container #(T) temp = new this;
    clone = temp;
  endfunction : clone

endclass : dfx_vif_container

class dfx_tap_util;

  // Write a bit stream (data/instruction bit array) to a string in hexadecimal.  There will be no
  // spaces between the bits.  Assuming the bit array was/is scanned in/out via a TAP/JTAG port,
  // print the bits in this order:
  //
  //   ary[$size(ary) - 1] ... ary[1] ary[0]
  //
  // No newline is printed before or after the bit array.
  //
  // The streaming operator does not work correctly for IDC.
  // Alternate version for IDC without streaming operator.
  static function string writeh(const ref dfx_node_t bitz[]);
    dfx_node_t [0:3] h_ary[];
    dfx_node_t [0:3] tmp; // IDC
    int bitz_size = bitz.size();
    int rem = bitz_size % 4;
    int k; // IDC
    dfx_node_t bitz_n[] = new[bitz_size + (rem ? (4 - rem) : 0)](bitz);
    string s1, s2;
    $sformat(s1, "%0d'h", bitz_size);

    for (int i = bitz_n.size() - 1; i >= bitz_size; i--)
      bitz_n[i] = 1'b0;

    // {>> {h_ary}} = {<< {bitz_n}}; <-- No streaming operator for IDC
    // Instead:
    h_ary = new [bitz_n.size() / 4] ;
    k = bitz_n.size() - 1;
    for (int i = 0; i < h_ary.size(); i++) begin
      tmp = 4'h0;
      for (int j = 3; j >= 0; j--)
        tmp = tmp | (bitz_n[k--] << j);
      h_ary[i] = tmp;
    end

    foreach (h_ary[i]) begin
      $sformat(s2, "%0h", h_ary[i]);
      s1 = {s1, s2};
    end

    return s1;
  endfunction : writeh

  static function string writex(const ref dfx_node_t bitz[]);
    dfx_node_t [0:3] h_ary[];
    dfx_node_t [0:3] tmp; // IDC
    int bitz_size = bitz.size();
    int rem = bitz_size % 4;
    int k; // IDC
    dfx_node_t bitz_n[] = new[bitz_size + (rem ? (4 - rem) : 0)](bitz);
    string s1, s2;
    s1 = "0x";

    for (int i = bitz_n.size() - 1; i >= bitz_size; i--)
      bitz_n[i] = 1'b0;

    // {>> {h_ary}} = {<< {bitz_n}}; <-- No streaming operator for IDC
    // Instead:
    h_ary = new [bitz_n.size() / 4] ;
    k = bitz_n.size() - 1;
    for (int i = 0; i < h_ary.size(); i++) begin
      tmp = 4'h0;
      for (int j = 3; j >= 0; j--)
        tmp = tmp | (bitz_n[k--] << j);
      h_ary[i] = tmp;
    end

    foreach (h_ary[i]) begin
      $sformat(s2, "%0h", h_ary[i]);
      s1 = {s1, s2};
    end

    return s1;
  endfunction : writex

  // Append a dfx_node_t/bit array to another dfx_node_t/bit array, expanding the size of the target/destination
  // array as needed.
  //
  // After appending "src" to "dest", the new "dest" looks like this:
  //   dest[0], dest[1], ..., src[0], src[1], ...
  //
  // "dest" and "src" cannot be the same array.
  //
  static function void append_array(ref dfx_node_t dest[], const ref dfx_node_t src[]);
    int new_dest_i, src_i,
        dest_size = dest.size(),
        src_size = src.size(),
        new_size = dest_size + src_size;
    dfx_node_t tmp[];

    tmp = dest;

    dest = new[new_size](tmp);

    new_dest_i = dest_size;
    src_i = 0;
    while (new_dest_i < new_size) begin
      dest[new_dest_i] = src[src_i];
      new_dest_i++;
      src_i++;
    end

  endfunction : append_array

  // Prepend a dfx_node_t/bit array to another dfx_node_t/bit array, expanding the size of the target array as needed.
  //
  // After prepending "src" to "dest", the new "dest" looks like this:
  //   src[0], src[1], ..., dest[0], dest[1], ...,
  //
  // "dest" and "src" cannot be the same array.
  //
  static function void prepend_array(ref dfx_node_t dest[], const ref dfx_node_t src[]);
    int new_dest_i, dest_i,
        dest_size = dest.size(),
        src_size = src.size(),
        new_size = dest_size + src_size;
    dfx_node_t tmp[];

    tmp = dest;

    dest = new[new_size](src);

    new_dest_i = src_size;
    dest_i = 0;
    while (new_dest_i < new_size) begin
      dest[new_dest_i] = tmp[dest_i];
      new_dest_i++;
      dest_i++;
    end
  endfunction : prepend_array

  // Extract a range from an array.
  //
  // "dest" and "src" can be the same array, but it is not recommended.
  //
  static function extract_array(const ref dfx_node_t src[], ref dfx_node_t dest[], input int start_index, int size);
    // dest = src[start_index : start_index + size];

    dest = new[size];

    for (int i = 0; i < size; i++)
      dest[i] = src[start_index + i];

  endfunction : extract_array

  // Get the alphabetical (non-numeric, really) prefix of a string.  This prefix may have digits in it, but must end
  // with a non-numeric character.  Everything after this character in the string is numeric.  In other words, this
  // function returns the string minus any numeric characters at the end.
  //
  static function string a_prefix(string in);
    int i;
    byte c;

    for (i = in.len() - 1; i >= 0; i--) begin
      c = in.getc(i);
      if (c < 48 || c > 57)
        break;
    end

    return in.substr(0, i);

  endfunction : a_prefix

endclass : dfx_tap_util

`endif // `ifndef DFX_TAP_UTIL_SV
