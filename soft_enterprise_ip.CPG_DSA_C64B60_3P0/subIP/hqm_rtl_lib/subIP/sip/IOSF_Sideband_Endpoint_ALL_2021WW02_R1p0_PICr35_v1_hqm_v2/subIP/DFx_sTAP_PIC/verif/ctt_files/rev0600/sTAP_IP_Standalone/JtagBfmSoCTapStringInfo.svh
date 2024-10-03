// File output was printed on: Saturday, January 19, 2013 2:59:29 PM
// Chassis TAP Tool version: 0.6.0.0
//----------------------------------------------------------------------
function string StrTap (input int Tap_Val); begin
    string str;
    case (Tap_Val)
        IPLEVEL_STAP   : begin str = "IPLEVEL_STAP";  end
        NOTAP          : begin str = "NOTAP";        end
    endcase
    return str;
end
endfunction : StrTap
