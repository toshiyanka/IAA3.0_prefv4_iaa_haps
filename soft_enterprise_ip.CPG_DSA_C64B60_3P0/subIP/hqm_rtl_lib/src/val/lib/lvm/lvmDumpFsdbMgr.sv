`ifndef LVM_DUMP_FSDB_MGR_CLASS_DEFINE
`define LVM_DUMP_FSDB_MGR_CLASS_DEFINE

////////////////////////////////////////////////////////////////////////
// class lvmDumpFsdbMgr
////////////////////////////////////////////////////////////////////////
class lvmDumpFsdbMgr extends ovm_component;

  `ovm_component_utils(lvmDumpFsdbMgr)

   protected bit fsdbEnable=0;
   protected string file="dump.fsdb";
   protected longint startTime=-1;
   protected longint stopTime=-1;
   protected longint enableTime=-1;
   protected bit memOn=0; 
   protected int limit=0;
   protected string scope = "";
   protected bit enableSVA=0;
   protected bit enableAutoSwitch=0;
   protected int numFiles=0;
   protected string scope_file = "";
   protected bit enableClass=0;
   protected string class_file = ""; 

   bit isStarted = 0;

   typedef enum int {FILE, MEM, START, STOP} cmd_type_e;
   typedef struct {
     cmd_type_e  cmd_type;
     int         ivalue;
     string      svalue;
   } cmd_s;

   mailbox #(cmd_s) cmd_mbox;

   extern function new(
                        string          name,
                        ovm_component   parent) ;

   extern virtual task run();
   extern virtual task setFsdbDumpFile(string fname);
   extern virtual task setFsdbDumpMemOn();
   extern virtual task setFsdbDumpMemOff();
   extern virtual task startFsdbDump();
   extern virtual task stopFsdbDump();

   // Get options and Return String of options
   extern virtual function void get_options();
   extern virtual function string option_string ( string prefix="" );

endclass


////////////////////////////////////////////////////////////////////////
// consturctor
////////////////////////////////////////////////////////////////////////
function lvmDumpFsdbMgr::new (
                                 string         name,
                                 ovm_component  parent ) ;

   super.new ( name, parent ) ;

   cmd_mbox = new();

   get_options();

endfunction

////////////////////////////////////////////////////////////////////////
// getOpts
////////////////////////////////////////////////////////////////////////
function void lvmDumpFsdbMgr::get_options();
   bit is_set;

   $value$plusargs("lvm_dump_fsdb_enable=%d",fsdbEnable);
   $value$plusargs("lvm_dump_fsdb_mem_enable=%d",memOn);
   $value$plusargs("lvm_dump_fsdb_file=%s",file);
   $value$plusargs("lvm_dump_fsdb_start_time=%d",startTime);
   $value$plusargs("lvm_dump_fsdb_stop_time=%d",stopTime);
   $value$plusargs("lvm_dump_fsdb_enable_time=%d",enableTime);

   $value$plusargs("lvm_dump_fsdb_scope=%s",scope);
   $value$plusargs("lvm_dump_fsdb_limit=%d",limit);
   $value$plusargs("lvm_dump_fsdb_sva=%d",enableSVA);
   $value$plusargs("lvm_dump_fsdb_auto_switch=%d",enableAutoSwitch);
   $value$plusargs("lvm_dump_fsdb_num_files=%d",numFiles);
   $value$plusargs("lvm_dump_fsdb_scope_file=%s",scope_file);
   $value$plusargs("lvm_dump_fsdb_class=%d",enableClass);
   $value$plusargs("lvm_dump_fsdb_class_file=%s",class_file);

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
     `ovm_info("lvmDumpFsdbMgr",$psprintf("stopTime set to enableTime(%d) when only enableTime is defined",
                                enableTime),OVM_LOW);
     startTime = 0;
     stopTime = enableTime;
     enableTime = stopTime - startTime;
   end else if ((startTime <  0) && (stopTime >= 0) && (enableTime >= 0)) begin
     if (enableTime > stopTime) begin
       `ovm_info("lvmDumpFsdbMgr",$psprintf("enableTime(%d) > stopTime(%d) when startTime not defined, ignoring enableTime",
                                  enableTime,stopTime),OVM_LOW);
       startTime = 0;
       stopTime = stopTime;
       enableTime = stopTime - startTime;
     end else begin
       `ovm_info("lvmDumpFsdbMgr",$psprintf("startTime set to (stopTime(%d) - enableTime(%d)) when startTime is not defined",
                                  stopTime,enableTime),OVM_LOW);
       startTime = stopTime - enableTime;
       stopTime = stopTime;
       enableTime = stopTime - startTime;
     end
   end else if ((startTime >= 0) && (stopTime <  0) && (enableTime >= 0)) begin
     `ovm_info("lvmDumpFsdbMgr",$psprintf("stopTime set to (startTime(%d) + enableTime(%d)) when stopTime is not defined",
                                startTime,enableTime),OVM_LOW);
     startTime = startTime;
     stopTime = startTime + enableTime;
     enableTime = stopTime - startTime;
   end else if ((startTime >= 0) && (stopTime >= 0) && (enableTime <  0)) begin
     if (stopTime < startTime) begin
       `ovm_fatal("lvmDumpFsdbMgr",$psprintf("stopTime(%d) < startTime(%d) when enableTime not defined",
                                   stopTime,startTime));
     end else begin
       startTime = startTime;
       stopTime = stopTime;
       enableTime = stopTime - startTime;
     end
   end else if ((startTime >= 0) && (stopTime >= 0) && (enableTime >= 0)) begin
     if (stopTime < startTime) begin
       `ovm_warning("lvmDumpFsdbMgr",$psprintf("stopTime(%d) < startTime(%d) when enableTime(%d) defined, ignoring stopTime",
                                     stopTime,startTime,enableTime));
       startTime = startTime;
       stopTime = startTime + enableTime;
       enableTime = stopTime - startTime;
     end else begin
       startTime = startTime;
       if (enableTime > (stopTime - startTime)) begin
         `ovm_info("lvmDumpFsdbMgr",$psprintf("enableTime(%d) > (stopTime(%d) - startTime(%d)), ignoring stopTime",
                                  enableTime,stopTime,startTime),OVM_LOW);
         stopTime = startTime + enableTime;
         enableTime = stopTime - startTime;
       end else if (enableTime < (stopTime - startTime)) begin
         `ovm_info("lvmDumpFsdbMgr",$psprintf("enableTime(%d) < (stopTime(%d) - startTime(%d)), ignoring enableTime",
                                    enableTime,stopTime,startTime),OVM_LOW);
         stopTime = stopTime;
         enableTime = stopTime - startTime;
       end else begin
         stopTime = stopTime;
         enableTime = stopTime - startTime;
       end
     end
   end

   `ovm_info("lvmDumpFsdbMgr",option_string(),OVM_LOW);
endfunction


////////////////////////////////////////////////////////////////////////
// option_string
////////////////////////////////////////////////////////////////////////
function string lvmDumpFsdbMgr::option_string ( string prefix="" );
   option_string = { //NA super.option_string ( prefix, verbosity ),
		     $psprintf ( "%0sdump_fsdb_enable           = %0d\n", prefix, fsdbEnable),
		     $psprintf ( "%0sdump_fsdb_mem_enable       = %0d\n", prefix, memOn),
		     $psprintf ( "%0sdump_fsdb_file             = %0s\n", prefix, file),
		     $psprintf ( "%0sdump_fsdb_start_time       = %0d\n", prefix, startTime),
		     $psprintf ( "%0sdump_fsdb_stop_time        = %0d\n", prefix, stopTime),
		     $psprintf ( "%0sdump_fsdb_scope            = %0s\n", prefix, scope),
		     $psprintf ( "%0sdump_fsdb_limit            = %0d\n", prefix, limit),
		     $psprintf ( "%0sdump_fsdb_sva              = %0d\n", prefix, enableSVA),
		     $psprintf ( "%0sdump_fsdb_auto_switch      = %0d\n", prefix, enableAutoSwitch),
		     $psprintf ( "%0sdump_fsdb_num_files        = %0d\n", prefix, numFiles),
		     $psprintf ( "%0sdump_fsdb_scope_file       = %0s\n", prefix, scope_file),
         $psprintf ( "%0sdump_fsdb_class            = %0d\n", prefix, enableClass),
         $psprintf ( "%0sdump_fsdb_class_file       = %0s\n", prefix, class_file)
		     };

endfunction : option_string

//-----------------------------------------------------------
// run - Main Run Loop - spawns other processes
//-----------------------------------------------------------

task lvmDumpFsdbMgr::run ( ) ;

`ifdef FSDB_ENABLE
  fork
    super.run() ;

    begin
      if (fsdbEnable) begin
        #startTime;
        startFsdbDump();

        if (enableTime >= 0) begin
          #enableTime;
          stopFsdbDump();
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
        
        MEM:    begin
                  memOn = dumpCmd.ivalue;
                end
        
        START:  begin
                  if (isStarted) begin
                    `ovm_error("lvmDumpFsdbMgr","lvmDumpFsdbMgr START command - dumping already started");
                  end else begin
                    if ( enableAutoSwitch ) begin
                      assert( limit > 1 ) else 
                      $fatal( 1, "Error: In FSDB auto switch mode, the FSDB limit must be set to a value greater than 1. %0d\n", limit );
                      $fsdbAutoSwitchDumpfile( limit, file, numFiles );
                    end else begin
                      if ( limit ) begin //Limit must be set first
                            $fsdbDumplimit( limit );
                      end
                      $fsdbDumpfile( file );
                    end

                    if ( scope.len() ) begin
                    integer fhScope = $fopen( "fsdb_scope.txt", "w" );
                      $fwrite( fhScope, "0 %0s\n", scope );
                      $fclose( fhScope );
                      $fsdbDumpvarsToFile( "fsdb_scope.txt" );
                    end else if ( scope_file.len() ) begin
                      $fsdbDumpvarsToFile( scope_file );
                    end else begin
                      $fsdbDumpvars("+struct");
                    end
   
                    if ( memOn  ) begin
                      $fsdbDumpMDA();
                    end

                    if ( enableSVA ) begin
                      $fsdbDumpSVA();
                    end
   
                    if ( enableClass ) begin
                       if ( class_file.len() ) begin
                         $fsdbDumpClassMethod( class_file );
                       end
                       else begin
                         $fsdbDumpClassMethod();
                       end
                    end   

                    isStarted = 1;
                  end
                end
        
        STOP:   begin
                  if (isStarted) begin
                    $fsdbDumpFinish();
                    $fsdbDumpoff();
                    isStarted = 0;
                  end else begin
                    `ovm_error("lvmDumpFsdbMgr","lvmDumpFsdbMgr STOP command - dumping not started");
                  end
                end
      endcase
    end
  join_none

`else
   if (fsdbEnable) begin
      assert(0) else
        $fatal( 1,"Error: FSDB Support was not compiled in." );
   end
   super.run();
`endif
endtask : run

////////////////////////////////////////////////////////////////////////
// setFsdbDumpFile
////////////////////////////////////////////////////////////////////////
task lvmDumpFsdbMgr::setFsdbDumpFile(string fname);
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = FILE;
  dumpCmd.svalue = fname;

  cmd_mbox.put(dumpCmd);
endtask : setFsdbDumpFile

////////////////////////////////////////////////////////////////////////
// setFsdbDumpMemOn
////////////////////////////////////////////////////////////////////////
task lvmDumpFsdbMgr::setFsdbDumpMemOn();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = MEM;
  dumpCmd.ivalue = 1;

  cmd_mbox.put(dumpCmd);
endtask : setFsdbDumpMemOn

////////////////////////////////////////////////////////////////////////
// setFsdbDumpMemOff
////////////////////////////////////////////////////////////////////////
task lvmDumpFsdbMgr::setFsdbDumpMemOff();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = MEM;
  dumpCmd.ivalue = 0;

  cmd_mbox.put(dumpCmd);
endtask : setFsdbDumpMemOff

////////////////////////////////////////////////////////////////////////
// startFsdbDump
////////////////////////////////////////////////////////////////////////
task lvmDumpFsdbMgr::startFsdbDump();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = START;

  cmd_mbox.put(dumpCmd);
endtask : startFsdbDump

////////////////////////////////////////////////////////////////////////
// stopFsdbDump
////////////////////////////////////////////////////////////////////////
task lvmDumpFsdbMgr::stopFsdbDump();
  automatic cmd_s dumpCmd;

  dumpCmd.cmd_type = STOP;

  cmd_mbox.put(dumpCmd);
endtask : stopFsdbDump

`endif //LVM_DUMP_FSDB_MGR_CLASS_DEFINE

