
`ifndef LVM_DUMP_VPD_MGR_CLASS_DEFINE
`define LVM_DUMP_VPD_MGR_CLASS_DEFINE

////////////////////////////////////////////////////////////////////////
// class lvmDumpVpdMgr
////////////////////////////////////////////////////////////////////////
class lvmDumpVpdMgr extends ovm_component;

  `ovm_component_utils(lvmDumpVpdMgr)

   protected bit vpdEnable=0;
   protected string file="dump.vpd";
   protected longint startTime=-1;
   protected longint stopTime=-1;
   protected longint enableTime=-1;
   protected longint flushInterval=0;
   protected bit memOn=0; 
   protected bit deltaOn=0;
   protected bit glitchOn=0;
   protected bit powerOn=0;

   bit isStarted = 0;

   typedef enum int {FILE, DELTA, GLITCH, MEM, POWER, START, STOP, FLUSH} cmd_type_e;
   typedef struct {
     cmd_type_e  cmd_type;
     int         ivalue;
     string      svalue;
   } cmd_s;

   mailbox #(cmd_s) cmd_mbox;

   extern function new(
                        string          name,
                        ovm_component   parent);

   extern virtual task run();
   extern virtual task setVpdDumpFile(string fname);
   extern virtual task setVpdDumpDeltaOn();
   extern virtual task setVpdDumpDeltaOff();
   extern virtual task setVpdDumpGlitchOn();
   extern virtual task setVpdDumpGlitchOff();
   extern virtual task setVpdDumpMemOn();
   extern virtual task setVpdDumpMemOff();
   extern virtual task setVpdDumpPowerOn();
   extern virtual task setVpdDumpPowerOff();
   extern virtual task startVpdDump();
   extern virtual task stopVpdDump();
   extern virtual task flushVpdDump();

   // Get options and Return String of options
   extern virtual function void get_options();
   extern virtual function string option_string ( string prefix="" );

`ifdef VPD_ENABLE
`endif
endclass


////////////////////////////////////////////////////////////////////////
// consturctor
////////////////////////////////////////////////////////////////////////
function lvmDumpVpdMgr::new (
                                 string         name,
                                 ovm_component  parent) ;

   super.new ( name, parent ) ;

   cmd_mbox = new();

   get_options();

endfunction

////////////////////////////////////////////////////////////////////////
// getOpts
////////////////////////////////////////////////////////////////////////
function void lvmDumpVpdMgr::get_options();
   bit is_set;

   $value$plusargs("lvm_dump_vpd_enable=%d",vpdEnable);
   $value$plusargs("lvm_dump_vpd_mem_enable=%d",memOn);
   $value$plusargs("lvm_dump_vpd_file=%s",file);
   $value$plusargs("lvm_dump_vpd_start_time=%d",startTime);
   $value$plusargs("lvm_dump_vpd_stop_time=%d",stopTime);
   $value$plusargs("lvm_dump_vpd_enable_time=%d",enableTime);
   $value$plusargs("lvm_dump_vpd_delta_cycle_on=%d",deltaOn);
   $value$plusargs("lvm_dump_vpd_glitch_on=%d",glitchOn);
   $value$plusargs("lvm_dump_vpd_power_on=%d",powerOn);
   $value$plusargs("lvm_dump_vpd_flush_interval=%d",flushInterval);

   if ((startTime <  0) && (stopTime <  0) && (enableTime <  0)) begin
     startTime = 0;
     stopTime = -1;
     enableTime = -1;
   end else if ((startTime >= 0) && (stopTime <  0) && (enableTime <  0)) begin
     startTime = startTime;
     stopTime = -1;
     enableTime = -1;
   end else if ((startTime <  0) && (stopTime >= 0) && (enableTime <  0)) begin
     startTime = 0;
     stopTime = stopTime;
     enableTime = stopTime - startTime;
   end else if ((startTime <  0) && (stopTime <  0) && (enableTime >= 0)) begin
     `ovm_info("lvmDumpVpdMgr",$psprintf("stopTime set to enableTime(%d) when only enableTime is defined",
                                enableTime),OVM_LOG);
     startTime = 0;
     stopTime = enableTime;
     enableTime = stopTime - startTime;
   end else if ((startTime <  0) && (stopTime >= 0) && (enableTime >= 0)) begin
     if (enableTime > stopTime) begin
       `ovm_info("lvmDumpVpdMgr",$psprintf("enableTime(%d) > stopTime(%d) when startTime not defined, ignoring enableTime",
                                  enableTime,stopTime),OVM_LOG);
       startTime = 0;
       stopTime = stopTime;
       enableTime = stopTime - startTime;
     end else begin
       `ovm_info("lvmDumpVpdMgr",$psprintf("startTime set to (stopTime(%d) - enableTime(%d)) when startTime is not defined",
                                  stopTime,enableTime),OVM_LOG);
       startTime = stopTime - enableTime;
       stopTime = stopTime;
       enableTime = stopTime - startTime;
     end
   end else if ((startTime >= 0) && (stopTime <  0) && (enableTime >= 0)) begin
     `ovm_info("lvmDumpVpdMgr",$psprintf("stopTime set to (startTime(%d) + enableTime(%d)) when stopTime is not defined",
                                startTime,enableTime),OVM_LOG);
     startTime = startTime;
     stopTime = startTime + enableTime;
     enableTime = stopTime - startTime;
   end else if ((startTime >= 0) && (stopTime >= 0) && (enableTime <  0)) begin
     if (stopTime < startTime) begin
       `ovm_fatal("lvmDumpVpdMgr",$psprintf("stopTime(%d) < startTime(%d) when enableTime not defined",
                                   stopTime,startTime));
     end else begin
       startTime = startTime;
       stopTime = stopTime;
       enableTime = stopTime - startTime;
     end
   end else if ((startTime >= 0) && (stopTime >= 0) && (enableTime >= 0)) begin
     if (stopTime < startTime) begin
       `ovm_warning("lvmDumpVpdMgr",$psprintf("stopTime(%d) < startTime(%d) when enableTime(%d) defined, ignoring stopTime",
                                     stopTime,startTime,enableTime));
       startTime = startTime;
       stopTime = startTime + enableTime;
       enableTime = stopTime - startTime;
     end else begin
       startTime = startTime;
       if (enableTime > (stopTime - startTime)) begin
         `ovm_info("lvmDumpVpdMgr",$psprintf("enableTime(%d) > (stopTime(%d) - startTime(%d)), ignoring stopTime",
                                  enableTime,stopTime,startTime),OVM_LOG);
         stopTime = startTime + enableTime;
         enableTime = stopTime - startTime;
       end else if (enableTime < (stopTime - startTime)) begin
         `ovm_info("lvmDumpVpdMgr",$psprintf("enableTime(%d) < (stopTime(%d) - startTime(%d)), ignoring enableTime",
                                    enableTime,stopTime,startTime),OVM_LOG);
         stopTime = stopTime;
         enableTime = stopTime - startTime;
       end else begin
         stopTime = stopTime;
         enableTime = stopTime - startTime;
       end
     end
   end

   `ovm_info("lvmDumpVpdMgr",option_string(),OVM_LOG);
endfunction


////////////////////////////////////////////////////////////////////////
// option_string
////////////////////////////////////////////////////////////////////////
function string lvmDumpVpdMgr::option_string ( string prefix="") ;
   option_string = { //NA super.option_string ( prefix, verbosity ),
		     $psprintf ( "%0sdump_vpd_enable            = %0d\n", prefix, vpdEnable),
		     $psprintf ( "%0sdump_vpd_mem_enable        = %0d\n", prefix, memOn),
		     $psprintf ( "%0sdump_vpd_file              = %0s\n", prefix, file),
		     $psprintf ( "%0sdump_vpd_start_time        = %0d\n", prefix, startTime),
		     $psprintf ( "%0sdump_vpd_stop_time         = %0d\n", prefix, stopTime),
		     $psprintf ( "%0sdump_vpd_enable_time       = %0d\n", prefix, enableTime),
		     $psprintf ( "%0sdump_vpd_delta_cycle_on    = %0d\n", prefix, deltaOn),
		     $psprintf ( "%0sdump_vpd_glitch_on         = %0d\n", prefix, glitchOn),
		     $psprintf ( "%0sdump_vpd_power_on          = %0d\n", prefix, powerOn),
		     $psprintf ( "%0sdump_vpd_flush_interval    = %0d\n", prefix, flushInterval)
		     };

endfunction : option_string

//-----------------------------------------------------------
// Run - Main Run Loop - spawns other processes
//-----------------------------------------------------------

task lvmDumpVpdMgr::run ( ) ;

`ifdef VPD_ENABLE
  fork
    super.run() ;

    while (1) begin
      wait(isStarted);

      fork
        while (isStarted && (flushInterval > 0)) begin
          #flushInterval;
          flushVpdDump();
        end

        wait(!isStarted);
      join
    end
    begin
      if (vpdEnable) begin
        #startTime;
        startVpdDump();

        if (enableTime >= 0) begin
          #enableTime;
          stopVpdDump();
        end
      end
    end
    while (1) begin
      cmd_s dumpCmd;

      cmd_mbox.get(dumpCmd);

      case (dumpCmd.cmd_type)
        FILE:   begin
                  file = dumpCmd.svalue;
                end
        
        DELTA:  begin
                  deltaOn = dumpCmd.ivalue;
                end
        
        GLITCH: begin
                  glitchOn = dumpCmd.ivalue;
                end
        
        MEM:    begin
                  memOn = dumpCmd.ivalue;
                end
        
        POWER:  begin
                  powerOn = dumpCmd.ivalue;
                end
        
        START:  begin
                  if (isStarted) begin
                    `ovm_error("lvmDumpVpdMgr","lvmDumpVpdMgr START command - dumping already started");
                  end else begin
                    $vcdplusfile( file );
                    if (deltaOn)  $vcdplusdeltacycleon();
                    if (glitchOn) $vcdplusglitchon();
                    if (powerOn)  $vcdpluspowerenableon();
                    if (memOn)    $vcdplusmemon();
`ifndef MIXED_MODE
                    $vcdpluson();
`endif
                    isStarted = 1;
                  end
                end
        
        STOP:   begin
                  if (isStarted) begin
                    $vcdplusoff();
                    $vcdplusclose();
                    isStarted = 0;
                  end else begin
                    `ovm_error("lvmDumpVpdMgr","lvmDumpVpdMgr STOP command - dumping not started");
                  end
                end
        
        FLUSH:  begin
                  if (isStarted) $vcdplusflush;
                end
      endcase
    end
  join_none

`else
   if (vpdEnable) begin
      assert(0) else
        $fatal( 1,"Error: VPD Support was not compiled in." );
   end
   super.run();
`endif
endtask : run

////////////////////////////////////////////////////////////////////////
// setVpdDumpFile
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpFile(string fname);
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = FILE;
  dumpCmd.svalue = fname;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpFile

////////////////////////////////////////////////////////////////////////
// setVpdDeltaOn
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpDeltaOn();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = DELTA;
  dumpCmd.ivalue = 1;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpDeltaOn

////////////////////////////////////////////////////////////////////////
// setVpdDeltaOff
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpDeltaOff();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = DELTA;
  dumpCmd.ivalue = 0;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpDeltaOff

////////////////////////////////////////////////////////////////////////
// setVpdGlitchOn
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpGlitchOn();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = GLITCH;
  dumpCmd.ivalue = 1;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpGlitchOn

////////////////////////////////////////////////////////////////////////
// setVpdGlitchOff
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpGlitchOff();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = GLITCH;
  dumpCmd.ivalue = 0;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpGlitchOff

////////////////////////////////////////////////////////////////////////
// setVpdMemOn
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpMemOn();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = MEM;
  dumpCmd.ivalue = 1;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpMemOn

////////////////////////////////////////////////////////////////////////
// setVpdMemOff
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpMemOff();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = MEM;
  dumpCmd.ivalue = 0;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpMemOff

////////////////////////////////////////////////////////////////////////
// setVpdPowerOn
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpPowerOn();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = POWER;
  dumpCmd.ivalue = 1;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpPowerOn

////////////////////////////////////////////////////////////////////////
// setVpdPowerOff
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::setVpdDumpPowerOff();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = POWER;
  dumpCmd.ivalue = 0;

  cmd_mbox.put(dumpCmd);
endtask : setVpdDumpPowerOff

////////////////////////////////////////////////////////////////////////
// startVpdDump
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::startVpdDump();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = START;

  cmd_mbox.put(dumpCmd);
endtask : startVpdDump

////////////////////////////////////////////////////////////////////////
// stopVpdDump
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::stopVpdDump();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = STOP;

  cmd_mbox.put(dumpCmd);
endtask : stopVpdDump

////////////////////////////////////////////////////////////////////////
// flushVpdDump
////////////////////////////////////////////////////////////////////////
task lvmDumpVpdMgr::flushVpdDump();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = FLUSH;

  cmd_mbox.put(dumpCmd);
endtask : flushVpdDump

`endif //LVM_DUMP_VPD_MGR_CLASS_DEFINE
