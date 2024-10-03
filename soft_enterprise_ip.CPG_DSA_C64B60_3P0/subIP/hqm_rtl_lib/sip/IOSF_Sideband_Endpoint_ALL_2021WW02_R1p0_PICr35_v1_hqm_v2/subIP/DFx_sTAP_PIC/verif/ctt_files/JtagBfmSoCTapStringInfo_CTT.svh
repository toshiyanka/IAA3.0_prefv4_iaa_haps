function string StrTap (input int Tap_Val); begin
    string str;
    case (Tap_Val)
        IPLEVEL_STAP   : begin str = "IPLEVEL_STAP";  end
        NOTAP          : begin str = "NOTAP";         end
    endcase
    return str;
end
endfunction : StrTap
