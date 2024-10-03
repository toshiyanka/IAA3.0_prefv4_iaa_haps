case (Node)
    'd0 : begin
		     Tap_Info_Int.Next_Tap[0] = NOTAP;
	  end
    'd1 : begin
        Tap_Info_Int.Next_Tap[0] = dfx_aggregator;
        Tap_Info_Int.Next_Tap[1] = stap0;
        Tap_Info_Int.Next_Tap[2] = stap1;
    end
    'd2 : begin
        Tap_Info_Int.Next_Tap[0] = stap3;
    end
    'd3 : begin
        Tap_Info_Int.Next_Tap[0] = stap4;
        Tap_Info_Int.Next_Tap[2] = stap5;
        Tap_Info_Int.Next_Tap[3] = stap6;
    end
    'd4 : begin
        Tap_Info_Int.Next_Tap[0] = stap7;
    end
    'd5 : begin
        Tap_Info_Int.Next_Tap[0] = stap8;
        Tap_Info_Int.Next_Tap[1] = stap_extr;
    end
    'd6 : begin
        Tap_Info_Int.Next_Tap[0] = stap_extr3;
        Tap_Info_Int.Next_Tap[1] = stap_extr4;
    end
    'd7 : begin
        Tap_Info_Int.Next_Tap[0] = stap_extr1;
        Tap_Info_Int.Next_Tap[1] = stap_extr2;
    end
endcase
