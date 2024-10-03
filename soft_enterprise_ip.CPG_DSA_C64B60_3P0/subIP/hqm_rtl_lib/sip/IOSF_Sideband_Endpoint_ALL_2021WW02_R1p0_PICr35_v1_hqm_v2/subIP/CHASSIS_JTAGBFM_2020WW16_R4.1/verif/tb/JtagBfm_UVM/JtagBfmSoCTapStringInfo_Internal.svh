// File output was printed on: Wednesday, March 20, 2013 9:00:22 AM
// Chassis TAP Tool version: 0.6.1.2
//----------------------------------------------------------------------
function string StrTap (input int Tap_Val); begin
    string str;
    case (Tap_Val)
        CLTAP     : begin str = "CLTAP";  end
        STAP0     : begin str = "STAP0";  end
        STAP1     : begin str = "STAP1";  end
        STAP2     : begin str = "STAP2";  end
        STAP3     : begin str = "STAP3";  end
        STAP4     : begin str = "STAP4";  end
        STAP5     : begin str = "STAP5";  end
        STAP6     : begin str = "STAP6";  end
        STAP7     : begin str = "STAP7";  end
        STAP8     : begin str = "STAP8";  end
        STAP9     : begin str = "STAP9";  end
        STAP10    : begin str = "STAP10"; end
        STAP11    : begin str = "STAP11"; end
        STAP12    : begin str = "STAP12"; end
        STAP13    : begin str = "STAP13"; end
        STAP14    : begin str = "STAP14"; end
        STAP15    : begin str = "STAP15"; end
        STAP16    : begin str = "STAP16"; end
        STAP17    : begin str = "STAP17"; end
        STAP18    : begin str = "STAP18"; end
        STAP19    : begin str = "STAP19"; end
        STAP20    : begin str = "STAP20"; end
        STAP21    : begin str = "STAP21"; end
        STAP22    : begin str = "STAP22"; end
        STAP23    : begin str = "STAP23"; end
        STAP24    : begin str = "STAP24"; end
        STAP25    : begin str = "STAP25"; end
        STAP26    : begin str = "STAP26"; end
        STAP27    : begin str = "STAP27"; end
        STAP28    : begin str = "STAP28"; end
        STAP29    : begin str = "STAP29"; end
        NOTAP     : begin str = "NOTAP";  end
    endcase
    return str;
end
endfunction : StrTap
