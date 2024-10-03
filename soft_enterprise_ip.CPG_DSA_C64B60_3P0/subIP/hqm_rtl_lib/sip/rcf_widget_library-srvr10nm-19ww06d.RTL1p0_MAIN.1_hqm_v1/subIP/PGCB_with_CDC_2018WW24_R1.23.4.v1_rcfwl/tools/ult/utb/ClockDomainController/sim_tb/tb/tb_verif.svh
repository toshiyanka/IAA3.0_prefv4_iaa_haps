// This file is `included in the tb module. 
// You can place any code that you can write inside a verilog module in this file.
//
// Some Examples:
//
// task DriveData ();
//    forever begin : DriveDataWhenRequested
//       if ( reqforData )  
//            data <= 123456; 
//       else
//            data <= 0;
//    end : DriveDataWhenRequested
// endtask : DriveData
//
// initial begin
//    fork 
//            DriveData();
//    join_none 
// end
// 
// task TaskName ();
// endtask : TaskName
