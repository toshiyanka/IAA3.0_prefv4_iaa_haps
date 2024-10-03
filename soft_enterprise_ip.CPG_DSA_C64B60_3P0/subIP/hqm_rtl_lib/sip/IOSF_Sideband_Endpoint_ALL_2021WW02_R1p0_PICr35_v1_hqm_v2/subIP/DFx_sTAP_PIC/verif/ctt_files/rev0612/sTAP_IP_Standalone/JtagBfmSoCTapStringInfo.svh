// File output was printed on: Thursday, March 21, 2013 4:21:02 PM
// Chassis TAP Tool version: 0.6.1.2
//----------------------------------------------------------------------
function string StrTap (input int Tap_Val); begin
    string str;
    case (Tap_Val)
        IPLEVEL_STAP    : begin str = "IPLEVEL_STAP"; end
        NOTAP           : begin str = "NOTAP";        end
    endcase
    return str;
end
endfunction : StrTap
