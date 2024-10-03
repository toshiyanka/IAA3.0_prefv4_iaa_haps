// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
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
//----------------------------------------------------------------------
// Common Package 
//----------------------------------------------------------------------

`ifndef LVM_COMMON_PKG_DEFINE
`define LVM_COMMON_PKG_DEFINE

/**
This package contains typedefs/methods for lvm_lib and extended classes.

Included are the following:

<h3>Packing Control</h3>

<b>lvm_pack_control_t</b> - This is a type that can be used by the byte_pack/byte_unpack
functions to control the endianness of the byte packing for LvmData.  The values 
of this are one-hot encoded so they can be OR'd together.  Currently, 
_REVERSE_WORD_ENDIAN_ and REVERSE_DWORD_ENDIAN_ are defined.  

<b>byte_pack_index</b> - The helper function _int byte_pack_index ( int index, int kind)_
is included to convert a byte index to the correct index.  The "natural" index is 
converted by kind, which is assumed to be a combination of lvm_pack_control_t.

<h3>String Utilities</h3>

#MatchStringFunction
<b>function bit match_string_function ( string name, string pattern)</b> - This returns a 1 if name matches pattern, 0 otherwise.  Pattern supports the following:

   <b>  </b> - If the pattern is an asterisk, then the string matches
<ul>
<li> ^ - If this is the first character, means to match prefix</li>
<li> $ - If this is the last character, means to match suffix</li>
<li> ? - Matches any character</li>
</ul>

For example, the following would match:
<pre>

name "abcdefgh"  matches pattern "^abc"
name "abcdefgh"  matches pattern "fgh$"
name "abcdefgh"  matches pattern "*"  (as does every other string)
name "abcdefgh"  matches pattern "a??def?h"

</pre>


*function string add_char_sep ( input string str, input string sep=",", 
input int num )* - Adds sep every num characters to string

<b>function string del_char_sep ( input string str, input string sep="," )</b>
- removes sep from string

<b>function nice_hex( str)</b> - Takes hex string and inserts underscore (_) every 
4 characters (equivalent to add_char_sep(str, "_", 4)

<b>function nice_dec(str)</b> - Takes decimal string and inserts command (,) every 
3 characters to left of decimal point

For example, the following conversions would take place:
<pre>

nice_hex ( "123456789" ) = "1_2345_6789"
nice_hex ( "123" ) = "123"

nice_dec ( "12345678" ) = "12,345,678"
nice_dec ( "1234.5678" ) = "1,234.5678"

</pre>


<b>function nice_dec_int(int)</b> - Same as nice_dec() but takes an integer as an argument

<b>function explode</b> -- split a string by a string (similar to PHP explode)
this returns a queue of strings, each of which is a substring of instring
formed by splitting it on the boundries formed by the string delimiter.

The return value is 1 if found delimiter at end of instring, 0 otherwise

If limit is set to a non-zero positive value, the returned array will
contain a maximum of limit elements with the last containing the rest
of the instring.

<b>ltrim_string</b> -- left trim a string.  Removes the whitespace from the
left hand side of a string.  Also strips comments
starting with #.

<b>rtrim_string</b> -- right trim a string.  Removes the whitespace from the
right hand side of a string.  Also strips comments
starting with #.

<b>remove_whitespace</b> -- remove all whitespace from a string. Also strips comments
starting with #.

<b>parse_token</b> -- parses a token from a string.  The original string is
modified by this function, as the token is removed
the original string.  Tokens are seperated by whitespace or any delim_char.  
Anything starting with # is a comment.  Comments are removed.

<b>strpos</b> -- Returns the numeric position of the first occurrence of needle in the haystack string.
-1 is returned if needle is not found in hastack.  

<b>token_to_longint, token_to_int</b> -- Attempt to convert a token string into an
int/longint.  Supports hex format (starting with 0x or 0X) and
decimal format.  Returns 0 if the string could not be converted to a longint, 
and returns 1 if it was sucessful.

<b>token_to_byte_queue</b> -- Attempt to convert a token string into a queue of bytes.
If token does not begin with 0x, the token is assumed to be an integer.  Return
values are similar to token_to_int.

<b>token_to_logic_array</b> -- Attempt to convert a token string into a array of bytes (logic).
If token does not begin with 0x, the token is assumed to be an integer.  Return
values are similar to token_to_int.
 
*/

package lvm_common_pkg ;


  `include "uvm_macros.svh"
  `include "slu_macros.svh"

  import uvm_pkg::*;
  
`ifdef XVM
   import ovm_pkg::*;
   import xvm_pkg::*;
   `include "ovm_macros.svh"
   `include "sla_macros.svh"
`endif

import sla_pkg::*;

  //======================================================================
  /**
    lvm_pack_control_t - This is a type that can be used by the byte_pack/byte_unpack 
    functions in lvm_data to control the endianness of the byte packing for LvmData. 
    The values of this are one-hot encoded so they can be OR'd together. 
    Currently, REVERSE_WORD_ENDIAN, REVERSE_DWORD_ENDIAN, REVERSE_QWORD_ENDIAN are defined. 
  */

  typedef enum int { NORMAL               = 0 ,
                     REVERSE_WORD_ENDIAN  = 1<<0,
                     REVERSE_DWORD_ENDIAN = 1<<1,
                     REVERSE_QWORD_ENDIAN = 1<<2,
                     USER_KIND_0          = 1<<3,
                     USER_KIND_1          = 1<<4,
                     USER_KIND_2          = 1<<5,
                     USER_KIND_3          = 1<<6 }  lvm_pack_control_t ;
  /**
    Helper function to reverse endian - returns index taking into account
    endianness - can OR together endian reversal bits
  */

  function int byte_pack_index ( int i, int kind ) ;
    automatic int j ;

    j = i ;

    if ( kind == -1 ) return j ;

    if ( ( kind & REVERSE_QWORD_ENDIAN ) != 0 ) begin
      j = ( ( j + 8 ) % 16 ) + ( ( j / 16 ) * 16 ) ;
    end

    if ( ( kind & REVERSE_DWORD_ENDIAN ) != 0 ) begin
      j = ( ( j + 4 ) % 8 ) + ( ( j / 8 ) * 8 ) ;
    end

    if ( ( kind & REVERSE_WORD_ENDIAN ) != 0 ) begin
      j = ( 3 - ( j % 4 ) ) + ( ( j / 4 ) * 4 ) ;
    end

    return j ;
  endfunction

  /**
    Helper function to match string.

    This function sees if name matches pattern.  pattern does allow some primative wildcarding, specifically:

    <ul>
    <li>* - If the pattern is an asterisk, everything matches</li>
    <li>^ - If this is the first character, means to match prefix</li>
    <li>$ - If this is the lastt character, means to match suffix</li>
    <li>? - Matches any character</li>
    </ul>

    This retruns 1 if a match, 0 if not a match
  */

  function bit match_string_function ( string name, string pattern ) ;

    automatic int m         ; // Length of match pattern
    automatic int n         ; // Length of n
    automatic int i         ; // counting variable
    automatic string sname  ;
    automatic string spat   ;

    // Global Match - always 1

    if ( pattern == "*"  ) return 1 ;

    // Get some info

    m = pattern.len()  ;
    n = name.len()   ;

    sname  = name ;
    spat   = pattern ;
   
    // ^ at start - just take prefix of sname

    if ( spat.substr ( 0, 0 ) == "^" ) begin
      spat = spat.substr (1,m-1 ) ;
      if ( n > m-2 ) begin 
        sname  = sname.substr  (0,m-2 ) ;
      end
      m = spat.len()  ;
      n = sname.len()  ;
    end

    // $ at end - just take suffix of sname

    if ( spat.substr ( m-1, m-1 ) == "$" ) begin
      spat = spat.substr (0,m-2 ) ;
      if ( n + 1 - m > 0 ) begin 
        sname  = sname.substr (n-m+1,n-1 ) ;
      end
      m = spat.len()  ;
      n = sname.len()  ;
    end

    // Default - make sure same length 

    if ( n != m ) return 0 ;

    // Replace ? in name and compare
 
    for ( i = 0 ; i < m ; i++ ) begin
      if ( spat.substr(i,i)== "?" ) begin
        sname.putc ( i, "?" ) ; 
      end
    end

    return ( sname == spat ) ;

 endfunction : match_string_function

/**
Add sep seperator every num char to str

The default values would take a number and insert commas every three
characters starting at the end.
If hex was wanted (a underscore every 4 chars), the call would be
add_char_set (str, "_", 4 ) ;
*/

   function string add_char_sep ( input string str, input string sep =",", 
                                  input int num) ;
  int i, len ;

  len = str.len() ; 

  i = len - num ;
  add_char_sep = str ;

  while ( i > 0 ) begin
     len = add_char_sep.len() ;  
     add_char_sep = { add_char_sep.substr ( 0, i - 1),
                      sep, 
                      add_char_sep.substr( i , len - 1) } ;
     i -= num ; 
  end
   
   endfunction : add_char_sep 
/**
Delete seperator from char

This takes the string, removing all characters that match any of the
seperators in sep.   Sep should be a single char (ie: _)
*/

   function string del_char_sep ( input string str, input string sep ="," ) ; 

  int i, len  ;
  string tmp ;

  len = str.len() ; 
  del_char_sep = "" ;

  for ( i=0 ; i < len ; i++ ) begin
     tmp = str.substr ( i, i ) ;
     if ( tmp != sep ) begin
        del_char_sep = { del_char_sep, tmp } ; 
     end
  end
   
   endfunction : del_char_sep 

/**
Takes hex string, returns nice version (_ separated)
*/

   function string nice_hex ( input string str ) ;
   return lvm_common_pkg::add_char_sep ( str, "_", 4 ) ;
   endfunction : nice_hex

/**
Takes dec string, returns nice version (, separated)
*/

   function string nice_dec ( input string str ) ;
   int i ;
   int pt ;

   // find decimal point
   pt = -1 ;

   for ( i = 1 ; ( pt < 0 ) && ( i < str.len() ) ; i++ ) begin
     if ( str.substr(i,i) == "." ) pt = i ;
   end

   if ( pt < 0 ) begin   // No Decimal Point
      return lvm_common_pkg::add_char_sep ( str, ",", 3 ) ;
   end
   else begin  // Decimal Point
      return { lvm_common_pkg::add_char_sep ( str.substr(0, pt-1), ",", 3 ),
               str.substr (pt, str.len() - 1 ) } ;
   end
   endfunction : nice_dec

/**
Takes dec string, returns nice version (, separated)
*/

   function string nice_dec_int ( input int i ) ;
     return lvm_common_pkg::nice_dec ( $psprintf ( "%0d", i ) ) ;
   endfunction : nice_dec_int 

/**
Split a string by a string (similar to PHP explode)

Returns a queue of strings, each of which is a substring of instring
formed by splitting it on the boundries formed by the string delimiter.

The return value is 1 if found delimiter at end of instring, 0 otherwise

If limit is set to a non-zero positive value, the returned array will
contain a maximum of limit elements with the last containing the rest
of the instring.
*/
   function bit explode(string delimiter, string instring, 
                         inout string string_q[$], input int limit=0) ;

      // local variables
      int q_len = 0, char_pos = 0;
      int delim_len;
      int instr_len;

      // default return value
      explode = 0;

      // init locals
      q_len = 0;
      char_pos = 0;
      
      
      // Handle trivial case where user wants to limit the array to one
      // string
      if (limit == 1) begin
         string_q.push_back(instring);
         return explode;
      end

      instr_len = instring.len();
      delim_len = delimiter.len();

      // Loop through the string looking for the delimiter string                 
      while ((char_pos + delim_len - 1) < instr_len) begin
      
         if (instring.substr(char_pos, char_pos + delim_len - 1) == delimiter) begin
            explode = 1; // delimiter found
            
            // we found the delimiter string, append if not at beginning
            if (char_pos+1 != delim_len) begin
               string_q.push_back(instring.substr(0, char_pos - 1));
               q_len += 1;
            end

            // prune back instring
            instring = instring.substr(char_pos+delim_len, instr_len-1);
            instr_len -= (char_pos + delim_len);

            // book keeping
            char_pos = 0;

            // handle limit
            if (q_len == limit - 1) begin
               string_q.push_back(instring);
               return explode;
            end
         end else begin // if (instring.substr(char_pos, char_pos + delim_len - 1) == delimiter)
            
            char_pos += 1;
         end // else: !if(instring.substr(char_pos, char_pos + delim_len - 1) == delimiter)
      end // while (char_pos + delim_len - 1 < instr_len)

      // push_back last item if not empty
      if (instring != "") begin
        string_q.push_back(instring);
        explode = 0; // no delimiter at end of instring
      end
      
   endfunction : explode

/**
Left trim a string.

Removes the whitespace from the left hand side of a string.  Also strips comments starting with #.

Returns the number of characters removed.
*/
   function int ltrim_string(inout string input_line) ;

      ltrim_string = 0;

      while (input_line.len() > 0) begin
         
         case (input_line.substr(ltrim_string,ltrim_string))
           " ", "\t", "\n", "" : begin
              ltrim_string++ ;

              // Break if we have read to the end of the line
              if (ltrim_string >= input_line.len()) begin
                 input_line = "";
                 break;
              end
           end
           
           "#" : begin
              // strip all comments
              input_line = "";
              break;
           end
        
           default: begin
              input_line = input_line.substr(ltrim_string, input_line.len() - 1);
              break;
           end
         endcase // case (input_line.substr(0,0))
         
      end // while ( input_line.len() > 0)

   endfunction : ltrim_string

/**
Right trim a string.

Removes the whitespace from the right hand side of a string.  Also strips comments starting with #.

Returns the number of characters removed.
*/
   function int rtrim_string(inout string input_line) ;

      for (int i = 0 ; i < input_line.len() ; i++) begin
        if (input_line[i] == "#") begin
          if (i == 0) begin
            input_line = "";
          end else begin
            input_line = input_line.substr(0,i-1);
          end

          break;
        end
      end

      if (input_line.len() == 0) return(0);

      rtrim_string = input_line.len() - 1;

      while (input_line.len() > 0) begin
         
         case (input_line.substr(rtrim_string,rtrim_string))
           " ", "\t", "\n", "" : begin
              rtrim_string-- ;

              // Break if we have read to the end of the line
              if (rtrim_string < 0) begin
                 input_line = "";
                 break;
              end
           end
        
           default: begin
              input_line = input_line.substr(0, rtrim_string);
              break;
           end
         endcase
         
      end

   endfunction : rtrim_string

/**
Remove all whitespace from a string

Removes the whitespace from the string.  Also strips comments starting with #.

Returns the number of characters removed.
*/
   function int remove_whitespace(inout string input_line) ;
      automatic string output_line;

      for (int i = 0 ; i < input_line.len() ; i++) begin
        if (input_line[i] == "#") begin
          if (i == 0) begin
            input_line = "";
          end else begin
            input_line = input_line.substr(0,i-1);
          end

          break;
        end
      end

      if (input_line.len() == 0) begin
        return(0);
      end

      remove_whitespace = 0;
      output_line = "";

      for (int i = 0 ; i < input_line.len() ; i++) begin
         case (input_line.substr(i,i))
           " ", "\t", "\n", "" : begin
              remove_whitespace++ ;
           end
        
           default: begin
              output_line = {output_line,input_line.substr(i,i)};
           end
         endcase
      end

      input_line = output_line;

   endfunction : remove_whitespace

/**
Parses a token from a string.

The original string is modified by this function, as the token is removed
the original string.  Tokens are seperated by
whitespace.  Anything starting with # is a comment.  
Comments are removed.

The token_delim argument allows user to pass in a string
of deliminator charactors.  If this is not "", a token
is terminated by any one of the delim chars, and a delim
char by itself is considered a token.
*/
   function string parse_token(inout string input_line, input string token_delim="") ;
      
      string firstchar;
      int end_pos;
      int done;
      
      // init vars
      end_pos = 0;
      done = 0;
      
      parse_token = "";
      
      // left trip line
      ltrim_string(input_line);
      rtrim_string(input_line);
      
      while (!done && (input_line.len() > 0)) begin
         firstchar = input_line.substr(end_pos,end_pos) ;
         
         case (firstchar)
           " ", "\t", "\n", "" : begin
              // we are at end of token
              parse_token = input_line.substr(0, end_pos - 1);
              input_line = input_line.substr(end_pos, input_line.len() - 1);
              done = 1 ;
           end
           
           "#" : begin
              // coment, remove rest of input_line
              input_line = "" ;
           end
           
           default: begin
              // Look for delim characters
              if (token_delim != "") begin
                 for (int i=0; i<token_delim.len(); i++) begin
                    
                    if ( firstchar == token_delim.substr(i,i) ) begin
                       // Bump up end_pos if we are stripping only the delim char
                       if (end_pos == 0) end_pos++ ;
                       
                       parse_token = input_line.substr(0, end_pos - 1);
                       input_line = input_line.substr(end_pos, input_line.len() - 1);
                       done = 1 ;

                       break ;
                    end
                 end
              end // if (token_delim != "")

              end_pos++;
           end
           
         endcase // case (substr)
         
         // We should never hit this state
         if (!done && (end_pos > input_line.len())) begin
            parse_token = input_line;
            done = 1;
         end
         
      end // while (!done && (input_line.len() > 0))
      
   endfunction : parse_token

/**
Parses array specifications from a string. Handles the following syntax:

  my_array[<index 0>][<index 1>]...

Returns the array name and a queue of the indices. Does not modify the string
*/
   function string parse_array_indices(input string input_line, output string indices[$]) ;
      string firstchar;
      string index;
      int char_pos;
      int done;
      int state;
      
      indices.delete();

      // init vars
      char_pos = 0;
      done = 0;
      state = 0;
      
      parse_array_indices = "";
      
      // left trip line
      ltrim_string(input_line);
      rtrim_string(input_line);
      
      while (!done && (char_pos < input_line.len())) begin
        firstchar = input_line.substr(char_pos,char_pos) ;
         
        case (firstchar)
          " ", "\t", "\n", "", "#" : begin // we are at end of token
            done = 1 ;
          end
          default: begin
            case (state)
              0: begin
                if (firstchar == "[") begin
                  index = "";
                  state = 1;
                end else begin
                  parse_array_indices = {parse_array_indices,firstchar};
                end
              end
              1: begin
                if (firstchar == "]") begin
                  indices.push_back(index);
                  state = 2;
                end else begin
                  index = {index,firstchar};
                end
              end
              2: begin
                if (firstchar == "[") begin
                  index = "";
                  state = 1;
                end else begin
                  done = 1;
                end
              end
            endcase
          end
        endcase

        char_pos++;
      end
   endfunction : parse_array_indices

/**
Return numeric position of string needle in string haystack.  (similar to PHP strpos)

Returns numeric position of first occurence of needle in the
the haystack string.  Returns -1 if not found.

The optional offset param allows you to specify which character in haystack
to use to start searching.  The return value is still relative
to the start of haystack.
*/
   function int strpos(string haystack, string needle, int offset=0) ;
      // local variables
      int char_pos, haystack_len, needle_len ;

      char_pos = offset ;

      haystack_len = haystack.len() ;
      needle_len   = needle.len() ;

      // Loop through the string looking for the delimiter string
      while ((char_pos + needle_len - 1) < haystack_len) begin
         if(haystack.substr(char_pos, char_pos + needle_len - 1) == needle) begin
            return char_pos ;
         end else begin
            char_pos++ ;
         end
      end

      // not found, return -1
      return -1 ;

   endfunction : strpos

/**
Attempt to convert a token string into a real.

Supports decimal format.  
Returns 0 if the string could not
be converted to a longint, and returns 1 if it was
sucessful.
*/
   function token_to_real(string token, inout real val) ;
      
      string twochars ;
      string ch;
      int i, first_i, decimal_point_found;
      bit minus ;
      
      if (token == "") begin
         token_to_real = 0;
         val = 0;
      end else begin
         token_to_real = 1;
         val = 0;
         twochars = token.substr(0,1);
         if (twochars == "0x" || twochars == "0X") begin
            // hex format, strip 0x
			token_to_real = 0;
         end else begin // if (twochars == "0x" || twochars == "0X")
            // make sure token is in fact a decimal value

            token = del_char_sep ( token, "," ) ;  // Remove Comma(s)

            first_i = 0 ; minus = 0 ;
            decimal_point_found = 0 ;
            ch = token.substr(0,0);
            if ( ch == "-" ) begin
                first_i = 1 ; minus = 1 ;
            end

            for (i=first_i; i < token.len(); i++) begin
               ch = token.substr(i,i);
               case (ch)
                 "0": val = (val * 10);
                 "1": val = (val * 10) + 1;
                 "2": val = (val * 10) + 2;
                 "3": val = (val * 10) + 3;
                 "4": val = (val * 10) + 4;
                 "5": val = (val * 10) + 5;
                 "6": val = (val * 10) + 6;
                 "7": val = (val * 10) + 7;
                 "8": val = (val * 10) + 8;
                 "9": val = (val * 10) + 9;
                 ".": decimal_point_found=i;
                 default: begin
                   token_to_real = 0;
                   return token_to_real;
                 end
               endcase
            end // for (i=0; i < token.len(); i++)
	
			  if(decimal_point_found > 0)	begin
				  val = val / (10**(i-(decimal_point_found+1)) ) ;//+1 for decimal point char
			  end	

            if ( minus ) val = - val ;
		end	// else (twochars == "0x" || twochars == "0X")
      end // else: !if(token == "")
      
   endfunction : token_to_real
  
/**
Attempt to convert a token string into a longint.

Supports hex format (starting with 0x or 0X) and
decimal format.  Returns 0 if the string could not
be converted to a longint, and returns 1 if it was
sucessful.
*/
   function bit token_to_longint(string token, inout longint val) ;
      
      string twochars ;
      string ch;
      int i, first_i;
      bit minus ;
      
      if (token == "") begin
         token_to_longint = 0;
         val = 0;
      end else begin
         token_to_longint = 1;
         val = 0;
         twochars = token.substr(0,1);
         if (twochars == "0x" || twochars == "0X") begin
            // hex format, strip 0x
            token = token.substr(2, token.len() - 1);
            // Strip "_"
            token = del_char_sep ( token, "_" ) ;
            
            // make sure token is in fact a hex value
            for (i=0; i < token.len(); i++) begin
               ch = token.substr(i,i);
               case (ch)
                 "0": val = (val << 4);
                 "1": val = (val << 4) + 1;
                 "2": val = (val << 4) + 2;
                 "3": val = (val << 4) + 3;
                 "4": val = (val << 4) + 4;
                 "5": val = (val << 4) + 5;
                 "6": val = (val << 4) + 6;
                 "7": val = (val << 4) + 7;
                 "8": val = (val << 4) + 8;
                 "9": val = (val << 4) + 9;
                 "a","A": val = (val << 4) + 10;
                 "b","B": val = (val << 4) + 11;
                 "c","C": val = (val << 4) + 12;
                 "d","D": val = (val << 4) + 13;
                 "e","E": val = (val << 4) + 14;
                 "f","F": val = (val << 4) + 15;
                 default: begin
                   token_to_longint = 0;
                   return token_to_longint;
                 end
               endcase
            end // for (i=0; i < token.len(); i++)
         end else begin // if (twochars == "0x" || twochars == "0X")
            // make sure token is in fact a decimal value

            token = del_char_sep ( token, "," ) ;  // Remove Comma(s)

            first_i = 0 ; minus = 0 ;
            ch = token.substr(0,0);
            if ( ch == "-" ) begin
                first_i = 1 ; minus = 1 ;
            end

            for (i=first_i; i < token.len(); i++) begin
               ch = token.substr(i,i);
               case (ch)
                 "0": val = (val * 10);
                 "1": val = (val * 10) + 1;
                 "2": val = (val * 10) + 2;
                 "3": val = (val * 10) + 3;
                 "4": val = (val * 10) + 4;
                 "5": val = (val * 10) + 5;
                 "6": val = (val * 10) + 6;
                 "7": val = (val * 10) + 7;
                 "8": val = (val * 10) + 8;
                 "9": val = (val * 10) + 9;
                 default: begin
                   token_to_longint = 0;
                   return token_to_longint;
                 end
               endcase
            end // for (i=0; i < token.len(); i++)
            if ( minus ) val = - val ;
         end
      end // else: !if(token == "")
      
   endfunction : token_to_longint
/**
Attempt to convert a token string into an integer.

Supports hex format (starting with 0x or 0X) and
decimal format.  Returns 0 if the string could not
be converted to an int, and returns 1 if it was
sucessful.
*/
   function token_to_int(string token, inout int val) ;
      
      longint long_val;

      token_to_int = token_to_longint(token, long_val);

      val = long_val;
      
   endfunction : token_to_int


/**
Attempt to convert a token string into a queue of bytes.

If token does not begin with 0x, the token is assumed 
to be an integer.  Return values are similar to token_to_int.
*/

   function bit token_to_byte_queue(string token, inout reg [7:0] data[$], input bit rjustify = 0) ;
     string twochars ;
     string next_word;
     int num_words;
     int num_bytes;
     longint next_data;
     int i;

     if (token == "") begin
        token_to_byte_queue = 1;
     end else begin
        token_to_byte_queue = 1;
        twochars = token.substr(0,1);
        if (twochars == "0x" || twochars == "0X") begin
           // hex format, strip 0x
           token = token.substr(2, token.len() - 1);

           // Strip any underscores (_)

           token = lvm_common_pkg::del_char_sep ( token, "_" ) ;

           if (rjustify) begin
             if (token.len() & 1) token = {"0",token};
           end

           num_words = (token.len() + 7) / 8;

           for (i=0 ; i < num_words ; i++) begin
             if (token.len() <= 8) begin
               num_bytes = (token.len() + 1) / 2;
               token = {"0x",token};
               token_to_byte_queue = lvm_common_pkg::token_to_longint(token,next_data) & token_to_byte_queue;
               token = "";
               if (num_bytes >= 4) data.push_back((next_data>>24) & 'hff);
               if (num_bytes >= 3) data.push_back((next_data>>16) & 'hff);
               if (num_bytes >= 2) data.push_back((next_data>>8)  & 'hff);
               if (num_bytes >= 1) data.push_back((next_data)     & 'hff);
             end else begin
               next_word = {"0x",token.substr(0,7)};
               token_to_byte_queue = lvm_common_pkg::token_to_longint(next_word,next_data) & token_to_byte_queue;
               token = token.substr(8,token.len()-1);
               data.push_back((next_data>>24) & 'hff);
               data.push_back((next_data>>16) & 'hff);
               data.push_back((next_data>>8)  & 'hff);
               data.push_back((next_data)     & 'hff);
             end
           end
        end else begin // if (twochars == "0x" || twochars == "0X")
           token_to_byte_queue = lvm_common_pkg::token_to_longint(token,next_data) & token_to_byte_queue;
           if ( next_data>>32 != 0 ) begin
              data.push_back((next_data>>56) & 'hff);
              data.push_back((next_data>>48) & 'hff);
              data.push_back((next_data>>40) & 'hff);
              data.push_back((next_data>>32) & 'hff);
           end
           data.push_back((next_data>>24) & 'hff);
           data.push_back((next_data>>16) & 'hff);
           data.push_back((next_data>>8)  & 'hff);
           data.push_back((next_data)     & 'hff);
        end
     end

   endfunction : token_to_byte_queue


/**
Attempt to convert a token string into a array of bytes (logic).

If token does not begin with 0x, the token is assumed to be an integer.  Return
values are similar to token_to_int.
*/

   function bit token_to_logic_array (string token, inout logic [7:0] data[]) ;

      reg [7:0] dataq [$] ;

      dataq.delete() ;

      token_to_logic_array = token_to_byte_queue(token, dataq ) ;

      data = new [ dataq.size() ] ;

      foreach ( dataq [ i ] ) data[i] = dataq[i] ;

   endfunction : token_to_logic_array
   

/**
Extracts the class scope from a fullScope string (%m string).
*/

   function string class_scope( string fullScope );

      int i=0;
      string classScope = "";

      //Get rid of \$root .\ prefix if it exists
      if (fullScope.substr(0,8)=="\\$root .\\") begin
         i+=9;
      end
      while( i < (fullScope.len()-1) ) begin
         string next2char = "";
         next2char = fullScope.substr(i,i+1);
         if (next2char == ".\\") begin
            //Replace .\ with :: for better readability and consistency with system verilog
            classScope = {classScope, "::"};
            i+=2;
         end else if (next2char == "::") begin
            break;
         end else begin
            classScope = {classScope, fullScope.substr(i,i) };
            ++i;
         end
      end

      return(classScope);
   endfunction


/**
Provides access to the RTL function AW_logb2
*/
   function integer AW_logb2;
     input  [31:0]  d;

     integer        i;
     integer        x;

     begin
       x=0; for (i=0; i<32; i=i+1) if (|(d >> i)) x=i; AW_logb2=x; // spyglass disable W244
     end
   endfunction


/**
The replace_1st indicate replace 1st occurrence of sub_str in source with the replaced_str; otherwise, all of the occurrence will be replaced, the returned value is the number of occurrence that were replaced.
*/
   function automatic int str_substitute (ref string source, input string sub_str,  input string replaced_str, input bit replace_1st=0,input string escape_prefix = "");

int matched_pass;
int src_index;
int sub_index;
int src_len;
int sub_len;
int src_max_index;
int sub_max_index;
int src_index_queue[$];
int replaced_len;
int diff_len;
int esp_pre_len;
bit escape_match;

matched_pass=0;
src_index=0;
sub_index=0;
escape_match= 0;
src_len=source.len();
sub_len=sub_str.len();
esp_pre_len=escape_prefix.len();
src_max_index=src_len-1;
sub_max_index=sub_len-1;
src_index_queue.delete();
replaced_len=replaced_str.len();
diff_len=replaced_len-sub_len;

if(sub_len > src_len)
  return matched_pass;

while(src_index<=src_max_index)
begin
  //not match current position but matches the first one is still a real match
  if(source[src_index]==sub_str[sub_index] || source[src_index]==sub_str[0])
    begin
      if(source[src_index]==sub_str[0])begin
         sub_index=0;
      end
      escape_match = 0;
      if(sub_index ==0)begin
         if(esp_pre_len>0 && src_index>=esp_pre_len)begin
            if(source.substr(src_index-esp_pre_len,src_index-1) == escape_prefix)begin
               escape_match = 1;
            end
         end
      end
      if(escape_match)begin
         sub_index=0;
         src_index++;
         continue;
      end
      //final match
      if(sub_index==sub_max_index)
        begin
          src_index_queue.push_back(src_index-sub_max_index);
          sub_index=0;
          src_index++;
        end
      else
        begin
          sub_index++;
          src_index++;
        end
    end
  else begin
      sub_index=0;
      src_index++;
  end
end//while

foreach (src_index_queue[i])
  begin
    int start_pos;
    int source_len;

    start_pos=src_index_queue[i]+diff_len*i;
    source_len=source.len();
    
    matched_pass=i+1;
    source={source.substr(0, start_pos-1), replaced_str, source.substr(start_pos+sub_len, source_len-1)};
    if(replace_1st==1)
      break;
  end

  return matched_pass;
endfunction

`ifndef HQM_IP_TB_OVM 
  `include "lvm_queue_uvm.sv"
`else
  `include "lvm_queue.sv"
`endif

endpackage : lvm_common_pkg 

`endif
