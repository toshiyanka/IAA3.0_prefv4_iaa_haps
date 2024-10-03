class PowerGatingBaseDriver extends ovm_driver #(PowerGatingSeqItem);
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_component_utils_begin(PowerGatingBaseDriver)
	`ovm_component_utils_end
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	PowerGatingConfig cfg;	
	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
   	protected bit busy;
	protected virtual PowerGatingNoParamIF _vif;       // ptr to the virtual interface
	protected PowerGatingSeqItem xactionQ[$];

	//col change
	protected virtual PowerGatingResetIF reset_vif;
	protected virtual PowerGatingSIPIF sip_vif[string];       	
	protected virtual PowerGatingFabricIF fab_vif[string];  
	protected virtual PowerGatingSIPIF sip_vif_all[string];  
	//END col change
	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================
	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new(name,parent);
	endfunction: new

	virtual function void build();
		super.build();
	endfunction : build

	virtual function void connect();
		super.connect();
	endfunction : connect
    /**************************************************************************
    * Used to pass in virtual interface from Agent during connect
    **************************************************************************/
    function void setVIF (virtual PowerGatingNoParamIF vif_arg);
        _vif = vif_arg;
    endfunction: setVIF

    function void setCfg (PowerGatingConfig cfg_arg);
        cfg = cfg_arg;
    endfunction: setCfg	

	//col change
	function set_intf(virtual PowerGatingResetIF reset, virtual PowerGatingSIPIF sip[string], virtual PowerGatingFabricIF fab[string]);
		reset_vif = reset;
		sip_vif = sip;
		fab_vif = fab;
	endfunction
	function set_static_intf(virtual PowerGatingSIPIF sip[string]);
		sip_vif_all = sip;
	endfunction
	//END col change	
	/**************************************************************************
	* When Reset occurs 
	***************************************************************************/
	virtual task waitForReset();
		@(negedge _vif.reset_b);
		flushXactionQ();
		driveResetSignaling();
		cfg.arb_sem = new(1);
	endtask: waitForReset
	virtual task waitForReset_Col();
		//col change
		//removing this since the probability of reset while in process of PG is only a global reset?
		//cfg.arb_sem = new(1);	
		//TODO: removing flushing of xaction Same comment as above. Maybe should global reset as an input to the VC.
		//flushXactionQ();	
		@(negedge reset_vif.reset_b);
		flushXactionQ();
		cfg.arb_sem_c = new(1);
		//END col change
	endtask: waitForReset_Col
    virtual task flushXactionQ();
        foreach (xactionQ[i]) begin
            xactionQ[i].setComplete();
        end
        xactionQ = {};
    endtask: flushXactionQ
	
	/**************************************************************************
	*  @brief : Wait for Complete bit to be set, with optional timeout. Fatal if timeout triggers.
	**************************************************************************/
     virtual task waitForComplete(time timeout = 0);
        if (timeout > 0) begin
            fork
                #timeout;
                isComplete();
            join_any;
            disable fork;
        end else begin
            isComplete();
        end
    endtask: waitForComplete

    protected virtual function void pruneXactionQ();
        PowerGatingSeqItem xaction;
        while (xactionQ.size() > 0) begin
            xaction = xactionQ[0];
            if (xaction.isComplete() == 0) break;
            xaction = xactionQ.pop_front();
        end
    endfunction: pruneXactionQ
    protected virtual function void addToQ(PowerGatingSeqItem xaction);
        pruneXactionQ();        
        if (!xaction.isComplete()) xactionQ.push_back(xaction);
    endfunction: addToQ
    /****************************************************************************
     * Checks xactionQ for non-complete xactions.  If there are any, it waits
     * until there are none before returning.
     **************************************************************************/
    virtual task isComplete();
        bit idle;
        pruneXactionQ();
        while (xactionQ.size() > 0) begin
            idle = 1;            
            xactionQ[0].waitForComplete();
            pruneXactionQ();
        end
    endtask: isComplete		

    /**************************************************************************
    *  @brief : default driver method. Should get an item and drive on the interface.
    **************************************************************************/
    protected virtual task driveReqs();
        forever begin
            //Get the next item to be driven; usually this is the REQ/req.
            getReq();
            //Prevent a mid-transaction test kill (How to tell test you are not idle)
            busy = 1;
			driveRequestInterface();
			//Set itemDone
			markRequestComplete();             
            //Drop objection to being killed now that transaction is complete. (Tell test you are idle now)
            busy = 0; 
        end
    endtask: driveReqs

	//=========================================================================
	// PROTECTED TASKS
	//=========================================================================

	/**************************************************************************
	*  @brief : Pulls an item from the seq item port and drives on the interface
	*
	*  Basic Agents may pull from multiple sources (ex: Slave Drivers from 
	*  Responders and Sequencers). Override if necessary
	**************************************************************************/
	protected virtual task getReq();
			//Get next item of work. (Similar to CGDriver.getBlocking(cgx)
			seq_item_port.get_next_item(req); 
			addToQ(req);
	endtask: getReq
	/**************************************************************************
	*  @brief : At a minimum, mark the request item complete/done. 
	**************************************************************************/
	protected virtual function markRequestComplete();
		//Notify anyone waiting on this transaction that the transaction is complete (similar to CGXaction.setComplete())
		seq_item_port.item_done();		
	endfunction: markRequestComplete
	/**************************************************************************
	*  @brief :  
	**************************************************************************/
	virtual task driveRequestInterface();
	endtask
	virtual task driveResetSignaling();
	endtask
	virtual task driveResetSignaling_Col();
		foreach(cfg.cfg_sip_pgcb_n[name]) 
		begin
			driveResetSignalingSIP(name);
		end
		foreach(cfg.cfg_sip_pgcb_n[name]) 
		begin
			driveResetSignalingFet(name);
		end
		foreach(cfg.cfg_fab_pgcb_n[name]) 
		begin
			driveResetSignalingFab(name);
		end	
	endtask
	virtual task waitDriveResetSignaling_Col();
		foreach(cfg.cfg_sip_pgcb_n[name]) 
		begin
			fork
				forkdriveResetSignalingSIP(name);
			join_none
		end
		foreach(cfg.cfg_sip_pgcb_n[name]) 
		begin
			fork
				forkdriveResetSignalingFet(name);
			join_none			
		end
		foreach(cfg.cfg_fab_pgcb_n[name]) 
		begin
			fork
				forkdriveResetSignalingFab(name);
			join_none			
		end	
	endtask
	task forkdriveResetSignalingSIP(string name);
		forever begin
			@(negedge sip_vif[name].reset_b);
			driveResetSignalingSIP(name);
		end
	endtask
	task forkdriveResetSignalingFet(string name);
		forever begin
			@(negedge sip_vif[name].reset_b);
			driveResetSignalingFet(name);
		end
	endtask
	task forkdriveResetSignalingFab(string name);
		forever begin
			@(negedge fab_vif[name].reset_b);
			driveResetSignalingFab(name);
		end
	endtask

	virtual task driveResetSignalingSIP(string name);
	endtask
	virtual task driveResetSignalingFab(string name);
	endtask
	virtual task driveResetSignalingFet(string name);
	endtask

	/**************************************************************************
	* delay
	***************************************************************************/
	virtual task delay_t(int del);
		int delay = del;
   		while (delay != 0) begin
			@(posedge _vif.clk);
			delay--;
		end
		@(posedge _vif.clk);
		#1ps;
	endtask
	virtual task delay_t_col(int del);
		int delay = del;
   		while (delay != 0) begin
			@(posedge reset_vif.clk);
			delay--;
		end
		@(posedge reset_vif.clk);
		#1ps;
	endtask

	virtual task delay_sip_col(int del, string source);
		int delay = del;
   		while (delay != 0) begin
			@(posedge sip_vif[source].clk);
			delay--;
		end
		@(posedge sip_vif[source].clk);
		#1ps;
	endtask

	virtual task delay_fab(int del, string source = "");
	if(cfg.phase == PowerGating::PHASE_1) begin
		delay_t(del);
	end
	else begin
		int delay = del;
   		while (delay != 0) begin
			@(posedge fab_vif[source].clk);
			delay--;
		end
		@(posedge fab_vif[source].clk);
		#1ps;
	end
	endtask

	virtual task delay_fet(int del, string source = "");
	if(cfg.phase == PowerGating::PHASE_1) 
		delay_t(del);
	else
		delay_t_col(del);

	endtask

	virtual task delay_sip(int del, string source = "");
	if(cfg.phase == PowerGating::PHASE_1) begin 
		delay_t(del);
	end
	else begin
		delay_sip_col(del, source);
	end
	endtask

	virtual task delay_wake(int del, string source = "");
		delay_sip(del, source);
	endtask

	virtual task delay_pok(int del, string source = "");
		delay_sip(del, source);
	endtask

	virtual task delay_dfx(int del, string source = "");
	if(cfg.phase == PowerGating::PHASE_1) begin
		int delay = del;
   		while (delay != 0) begin
			@(posedge _vif.jtag_tck);
			delay--;
		end
		@(posedge _vif.jtag_tck);
		#1ps;
	end
	else begin
		int delay = del;
   		while (delay != 0) begin
			@(posedge sip_vif[source].jtag_tck);
			delay--;
		end
		@(posedge sip_vif[source].jtag_tck);
		#1ps;
	end
	endtask		

endclass : PowerGatingBaseDriver
