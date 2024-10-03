    /**************************************************************************
    *  @brief : default driver method. Should get an item and drive on the interface.
    **************************************************************************/
	 protected virtual task forkDriveFetAck(int index);
		forever begin
			PGCBAgentResponseSeqItem rsp;
			int i = index;
			int delay;
			rsp = PGCBAgentResponseSeqItem::type_id::create({get_name(), "_rsp"});
			@(_vif.fet_en_b[i]);
			rsp.randomize();
			delay = rsp.delay_fet_en_ack;
			while (delay != 0) begin
				@(posedge _vif.clk);
				delay--;
			end			
			_vif.fet_en_ack_b[i] = _vif.fet_en_b[i];
		end
     endtask : forkDriveFetAck

	 protected virtual task forkDriveFetAck_Col(string name);
		forever begin
			PGCBAgentResponseSeqItem rsp;
			string i = name;
			int delay;
			rsp = PGCBAgentResponseSeqItem::type_id::create({get_name(), "_rsp"});
			@(sip_vif[name].fet_en_b);
			rsp.randomize();
			delay = rsp.delay_fet_en_ack;
			while (delay != 0) begin
				@(posedge sip_vif[name].clk);
				delay--;
			end			
			sip_vif[name].fet_en_ack_b = sip_vif[name].fet_en_b;
		end
     endtask : forkDriveFetAck_Col

