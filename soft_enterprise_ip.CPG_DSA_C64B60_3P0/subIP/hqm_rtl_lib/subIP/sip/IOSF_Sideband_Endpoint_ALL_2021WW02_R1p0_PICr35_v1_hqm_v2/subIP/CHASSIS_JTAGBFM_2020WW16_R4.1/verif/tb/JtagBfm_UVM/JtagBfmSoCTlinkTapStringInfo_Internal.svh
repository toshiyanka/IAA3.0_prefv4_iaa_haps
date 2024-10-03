function string StrTap (input int Tap_Val); begin
	string str;
	case (Tap_Val)
		 cltap          : begin str = "cltap"; end
       dfx_aggregator          : begin str = "dfx_aggregator"; end
       stap0          : begin str = "stap0"; end
       stap1          : begin str = "stap1"; end
       stap3          : begin str = "stap3"; end
       stap4          : begin str = "stap4"; end
       stap5          : begin str = "stap5"; end
       stap6          : begin str = "stap6"; end
       stap7          : begin str = "stap7"; end
       stap8          : begin str = "stap8"; end
       stap_extr          : begin str = "stap_extr"; end
       stap_extr3          : begin str = "stap_extr3"; end
       stap_extr4          : begin str = "stap_extr4"; end
       stap_extr1          : begin str = "stap_extr1"; end
       stap_extr2          : begin str = "stap_extr2"; end
       NOTAP           : begin str = "NOTAP"; end
   endcase // case
	return str;
end
endfunction : StrTap
