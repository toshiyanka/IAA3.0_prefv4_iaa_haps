// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//-----------------------------------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name:     lvm_queue.sv
// Created by:    Mike Betker
//-----------------------------------------------------------------------------------------------------
// lvm_queue
//
//wiki(Overview)
// This class supports a fifo of items of type `lvm_data_base with burst capability. The fifo has
// 3 states:
//
// | *FIFO Type* | *Description* |
// | FIFO_EMPTY  | There are no entries in the FIFO |
// | FIFO_STALL  | There are entries in the FIFO but the burst condition has not been met |
// | FIFO_BURST  | The FIFO has a burst in progress |
//
// [[LvmQueue][lvm_queue]] requires a time base to operate. This time base may be established using
// one of two methods. The first method is to pass an instance of nu_clkrst_if interface with the constructor.
// The time base will then be established by the positive edge of the =core_clk= signal within the nu_clkrst_if
// inteface. The other method to establish the time base is to not pass an instance of nu_clkrst_if with the
// constructor and call the task =clock_tick()= every cycle in the environment.
//
// The burst options support bursting of available data, with options to guarantee the queue can always empty.
//
// The enable/disable options control the number of consecutive cycles to enable queue output and disable
// queue output. The distribution used is a normal distribution. The number of cycles saturates for each if
// the random value is less than the minimum value or more than the maximum value.
//endwiki
//
// Command line options:
//
// | *Option* | *Default* | *Description* |
// | lvm_queue_burst_high_watermark | 1 | Number of items required in FIFO before burst |
// | lvm_queue_burst_size | 1 | Number of items in burst |
// | lvm_queue_burst_min_idle | 0 | FIFO_PAUSE minimum timeout |
// | lvm_queue_burst_max_idle | 0 | FIFO_PAUSE maximum timeout |
// | lvm_queue_burst_max_idle_interval | 0 | Number of cycles between items available once FIFO_PAUSE timeout occurs |
// | lvm_queue_enable_mean | 1 | Mean number of consecutive cycles to allow size()>0 |
// | lvm_queue_enable_std_dev | 0 | Standard deviation of number of consecutive cycles to allow size()>0 |
// | lvm_queue_enable_min | 1 | Minimum number of consecutive cycles to allow size()>0 |
// | lvm_queue_enable_max | 1 | Maximum number of consecutive cycles to allow size()>0 |
// | lvm_queue_disable_mean | 0 | Mean number of consecutive cycles to force size()=0 |
// | lvm_queue_disable_std_dev | 0 | Standard deviation of number of consecutive cycles to force size()=0 |
// | lvm_queue_disable_min | 0 | Minimum number of consecutive cycles to force size()=0 |
// | lvm_queue_disable_max | 0 | Maximum number of consecutive cycles to force size()=0 |
// | lvm_queue_sel_algorithm | fifo | Selection algorithm used when calling pop() (fifo %VBAR% lifo %VBAR% random) |
//
//-----------------------------------------------------------------------------------------------------

`ifndef LVM_QUEUE_DEFINE
`define LVM_QUEUE_DEFINE

class lvm_queue extends ovm_report_object;

  `ovm_object_utils(lvm_queue)

  typedef enum {FIFO_EMPTY, FIFO_STALL, FIFO_BURST, FIFO_MIN_IDLE} fifo_status_e;

  bit queue_enable;

  int burst_high_watermark;
  int burst_size;
  int burst_min_idle;
  int burst_max_idle;
  int burst_max_idle_interval;
  int enable_mean;
  int enable_std_dev;
  int enable_min;
  int enable_max;
  int disable_mean;
  int disable_std_dev;
  int disable_min;
  int disable_max;
  string sel_algorithm;

  bit enable_state;
  int enable_count;
  int enable_seed;

  fifo_status_e  fifo_status;

  int idle_count;
  int burst_count;
  int min_idle_count;
  int in_max_idle_mode;

  int fifo_depth;
  int drop_count;

  semaphore burst_semaphore;

  int   data_q[$];

  int use_wait_for_clock;

  event next_cycle;

  function new(string			name = "");

    super.new(name);

    queue_enable = 0;

    enable_state = 1;   // output disabled
    enable_count = 1;   // number of cycles remaining in current enable_state
    enable_seed = $urandom();   // seed for $dist_normal used to set enable_count

    `ovm_info(get_full_name(),$psprintf("enable_state=%1d enable_count=%1d",enable_state, enable_count),OVM_MEDIUM)

    fifo_status = FIFO_EMPTY;

    idle_count = 0;
    burst_count = 0;
    min_idle_count = 0;
    in_max_idle_mode = 0;

    fifo_depth = -1;
    drop_count = 0;

    burst_semaphore = new(1);

    get_options();

  endfunction

virtual function void set_name (string  name);
  super.set_name(name);

  get_options();
endfunction : set_name

//wiki(Methods)
//---+++ get_options()
//endwiki
//wiki(Methods)
virtual function void get_options();//endwiki/*wiki(Methods)---*/
  string opt_display;
  bit is_set;

  burst_high_watermark        = 0;
  burst_size                  = 1;
  burst_min_idle              = 0;
  burst_max_idle              = 0;
  burst_max_idle_interval     = 1;
  sel_algorithm               = "fifo";
  enable_mean                 = 1;
  enable_std_dev              = 0;
  enable_min                  = 1;
  enable_max                  = 1;
  disable_mean                = 0;
  disable_std_dev             = 0;
  disable_min                 = 0;
  disable_max                 = 0;

  fifo_depth                  = -1;

  $value$plusargs($psprintf("%s_burst_high_watermark=%s",get_name(),"%d"),burst_high_watermark);
  $value$plusargs($psprintf("%s_burst_size=%s",get_name(),"%d"),burst_size);
  $value$plusargs($psprintf("%s_burst_min_idle=%s",get_name(),"%d"),burst_min_idle);
  $value$plusargs($psprintf("%s_burst_max_idle=%s",get_name(),"%d"),burst_max_idle);
  $value$plusargs($psprintf("%s_burst_max_idle_interval=%s",get_name(),"%d"),burst_max_idle_interval);
  $value$plusargs($psprintf("%s_sel_algorithm=%s",get_name(),"%s"),sel_algorithm);
  $value$plusargs($psprintf("%s_enable_mean=%s",get_name(),"%d"),enable_mean);
  $value$plusargs($psprintf("%s_enable_std_dev=%s",get_name(),"%d"),enable_std_dev);
  $value$plusargs($psprintf("%s_enable_min=%s",get_name(),"%d"),enable_min);
  $value$plusargs($psprintf("%s_enable_max=%s",get_name(),"%d"),enable_max);
  $value$plusargs($psprintf("%s_disable_mean=%s",get_name(),"%d"),disable_mean);
  $value$plusargs($psprintf("%s_disable_std_dev=%s",get_name(),"%d"),disable_std_dev);
  $value$plusargs($psprintf("%s_disable_min=%s",get_name(),"%d"),disable_min);
  $value$plusargs($psprintf("%s_disable_max=%s",get_name(),"%d"),disable_max);

  $value$plusargs($psprintf("%s_fifo_depth=%s",get_name(),"%d"),fifo_depth);

  opt_display = { $psprintf("LVM_QUEUE\n"),
                  $psprintf("Option %s_burst_high_watermark    = %1d\n",get_name(),burst_high_watermark),
                  $psprintf("Option %s_burst_size              = %1d\n",get_name(),burst_size),
                  $psprintf("Option %s_burst_min_idle          = %1d\n",get_name(),burst_min_idle),
                  $psprintf("Option %s_burst_max_idle          = %1d\n",get_name(),burst_max_idle),
                  $psprintf("Option %s_burst_max_idle_interval = %1d\n",get_name(),burst_max_idle_interval),
                  $psprintf("Option %s_enable_mean             = %1d\n",get_name(),enable_mean),
                  $psprintf("Option %s_enable_std_dev          = %1d\n",get_name(),enable_std_dev),
                  $psprintf("Option %s_enable_min              = %1d\n",get_name(),enable_min),
                  $psprintf("Option %s_enable_max              = %1d\n",get_name(),enable_max),
                  $psprintf("Option %s_disable_mean            = %1d\n",get_name(),disable_mean),
                  $psprintf("Option %s_disable_std_dev         = %1d\n",get_name(),disable_std_dev),
                  $psprintf("Option %s_disable_min             = %1d\n",get_name(),disable_min),
                  $psprintf("Option %s_disable_max             = %1d\n",get_name(),disable_max),
                  $psprintf("Option %s_sel_algorithm           = %s\n",get_name(),sel_algorithm),
                  $psprintf("Option %s_fifo_depth              = %1d\n",get_name(),fifo_depth)
                };

                `ovm_info(get_full_name(),opt_display,OVM_MEDIUM)
endfunction

/** The start_clock() method keeps track of time
*/

virtual task start_clock(int delay_count);
  fork
    begin
      while (queue_enable) begin
        int   cnt = delay_count;

        while (cnt-- > 0) begin
          @ (sla_tb_env::sys_clk_r);
        end

        ->next_cycle;
      end
    end
  join_none
endtask : start_clock

  virtual task run();
    `ovm_info(get_full_name(),$psprintf("Starting lvm_queue instance: %s",get_full_name()),OVM_LOW)

    queue_enable = 1;

    start_clock(1);

    while (queue_enable) begin
      @next_cycle;

      burst_semaphore.get();

      if (fifo_status == FIFO_STALL)
        idle_count++;

      if (fifo_status == FIFO_MIN_IDLE)
        min_idle_count++;

      `ovm_info(get_full_name(),$psprintf("start of code enable_state=%1d enable_count=%1d",enable_state, enable_count),OVM_DEBUG)

      enable_count--;

      if (enable_count <= 0) begin
        enable_state = ~enable_state;

        if (enable_state) begin
          enable_count = $dist_normal(enable_seed,enable_mean,enable_std_dev);

          if (enable_count > enable_max) enable_count = enable_max;
          if (enable_count < enable_min) enable_count = enable_min;
        end else begin
          enable_count = $dist_normal(enable_seed,disable_mean,disable_std_dev);

          if (enable_count > disable_max) enable_count = disable_max;
          if (enable_count < disable_min) enable_count = disable_min;

          if (enable_count <= 0) begin
            enable_state = 1;
            enable_count = $dist_normal(enable_seed,enable_mean,enable_std_dev);

            if (enable_count > enable_max) enable_count = enable_max;
            if (enable_count < enable_min) enable_count = enable_min;
          end
        end
      end

      `ovm_info(get_full_name(),$psprintf("end of code enable_state=%1d enable_count=%1d",enable_state, enable_count),OVM_DEBUG)

      burst_semaphore.put();
    end
  endtask

//wiki(Methods)
//---+++ push()
// The =push()= task is used to push an object onto the queue.
//endwiki
  //wiki(Methods)
  virtual task push(int data);//endwiki/*wiki(Methods)---*/
    burst_semaphore.get();

    `ovm_info(get_full_name(),$psprintf("LVM_QUEUE PUSH Received"),OVM_DEBUG)

    if (data_q.size() == fifo_depth) begin
      drop_count ++ ;
      `ovm_info(get_full_name(),$psprintf("LVM_QUEUE PUSH: FIFO (size=%0d) already full, dropping pushed object.", fifo_depth),OVM_DEBUG)
      burst_semaphore.put();
      return ;
    end
    data_q.push_back(data);

    if (fifo_status == FIFO_EMPTY) begin
      if ((burst_size == 1) || (data_q.size() >= burst_high_watermark)) begin
        `ovm_info(get_full_name(),$psprintf("LVM_QUEUE PUSH: Changing fifo_status from FIFO_EMPTY to FIFO_BURST"),OVM_DEBUG)
        fifo_status = FIFO_BURST;
        burst_count = 0;
      end else begin
        `ovm_info(get_full_name(),$psprintf("LVM_QUEUE PUSH: Changing fifo_status from FIFO_EMPTY to FIFO_STALL"),OVM_DEBUG)
        fifo_status = FIFO_STALL;
        burst_count = 0;
      end
    end else if (fifo_status == FIFO_STALL) begin
      idle_count = 0;

      if (in_max_idle_mode) begin
        `ovm_warning("LVM_QUEUE","LVM_QUEUE received push while in max_idle mode");
      end

      in_max_idle_mode = 0;

      if (data_q.size() >= burst_high_watermark) begin
        `ovm_info(get_full_name(),$psprintf("LVM_QUEUE PUSH: Watermark reached, changing fifo_status from FIFO_STALL to FIFO_BURST"),OVM_DEBUG)
        fifo_status = FIFO_BURST;
        burst_count = 0;
      end
    end

    burst_semaphore.put();
  endtask

//wiki(Methods)
//---+++ pop()
// The =pop()= task is used to pop an object from the queue. It will generate an error if you try
// to pop when the queue is in an empty state. You should call =size()= before attempting a =pop()=
// to make sure there is an item available.
//endwiki
  //wiki(Methods)
  virtual task pop(output int pop_data);//endwiki/*wiki(Methods)---*/
    burst_semaphore.get();

    `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP Received"),OVM_DEBUG)

    case (fifo_status)
      FIFO_EMPTY: begin
                    pop_data = null;
                    `ovm_error("LVM_QUEUE","LVM_QUEUE ERROR: pop called when in FIFO_EMPTY state");
                  end
      FIFO_STALL: begin
                    if ((!in_max_idle_mode && (idle_count >= burst_max_idle)) ||
                        ( in_max_idle_mode && (idle_count >= burst_max_idle_interval))) begin
                      if (data_q.size() > 0) begin
                        case (sel_algorithm)
                          "fifo": begin
                                    pop_data = data_q.pop_front();
                                  end
                          "lifo": begin
                                    pop_data = data_q.pop_back();
                                  end
                          "random": begin
                                      int q_index;

                                      q_index = $urandom_range(0, data_q.size() - 1);

                                      pop_data = data_q[q_index];
                                      data_q.delete(q_index);
                                    end
                          default: begin
                                     `ovm_fatal("LVM_QUEUE",
                                                    $psprintf("LVM_QUEUE: illegal lvm_queue_sel_algorithm option (%s)",
                                                    sel_algorithm)
                                                   );
                                   end
                        endcase

                        idle_count = 0;
                        in_max_idle_mode = 1;

                        if (data_q.size() > 0) begin
                          `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP: Keeping fifo_status at FIFO_STALL"),OVM_DEBUG)
                          fifo_status = FIFO_STALL;
                        end else begin
                          `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP: Changing fifo_status from FIFO_STALL to FIFO_EMPTY"),OVM_DEBUG)
                          fifo_status = FIFO_EMPTY;
                        end
                      end else begin
                        pop_data = null;
                        `ovm_error("LVM_QUEUE","LVM_QUEUE ERROR in FIFO_STALL state : pop called when queue empty");
                      end
                    end else begin
                      pop_data = null;
                      `ovm_error("LVM_QUEUE","LVM_QUEUE ERROR: pop called when in FIFO_STALL state");
                    end
                  end
      FIFO_BURST: begin
                    if (data_q.size() > 0) begin
                      case (sel_algorithm)
                        "fifo": begin
                                  pop_data = data_q.pop_front();
                                end
                        "lifo": begin
                                  pop_data = data_q.pop_back();
                                end
                        "random": begin
                                    int q_index;

                                    q_index = $urandom_range(0, data_q.size() - 1);

                                    pop_data = data_q[q_index];
                                    data_q.delete(q_index);
                                  end
                        default: begin
                                   `ovm_fatal("LVM_QUEUE",
                                                  $psprintf("LVM_QUEUE: illegal lvm_queue_sel_algorithm option (%s)",
                                                  sel_algorithm)
                                                 );
                                 end
                      endcase

                      idle_count = 0;

                      burst_count++;

                      if (burst_count >= burst_size) begin
                        burst_count = 0;

                        if (burst_min_idle > 0) begin
                          min_idle_count = 0;
                          `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP: Changing fifo_status from FIFO_BURST to FIFO_MIN_IDLE"),OVM_DEBUG)
                          fifo_status = FIFO_MIN_IDLE;
                        end else begin
                          if (data_q.size() == 0) begin
                            `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP: Changing fifo_status from FIFO_BURST to FIFO_EMPTY"),OVM_DEBUG)
                            fifo_status = FIFO_EMPTY;
                          end else if ((burst_size == 1) || (data_q.size() >= burst_high_watermark)) begin
                            `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP: Watermark reached, keeping fifo_status at FIFO_BURST"),OVM_DEBUG)
                            fifo_status = FIFO_BURST;
                          end else begin
                            `ovm_info(get_full_name(),$psprintf("LVM_QUEUE POP: Changing fifo_status from FIFO_BURST to FIFO_STALL"),OVM_DEBUG)
                            fifo_status = FIFO_STALL;
                          end
                        end

                      end
                    end else begin
                      pop_data = null;
                      `ovm_error("LVM_QUEUE","LVM_QUEUE ERROR in FIFO_BURST state : pop called when queue empty");
                    end

                    
                  end
      FIFO_MIN_IDLE:
                  begin
                    if (min_idle_count < burst_min_idle) begin
                      pop_data = null;
                      `ovm_error("LVM_QUEUE","LVM_QUEUE ERROR in FIFO_MIN_IDLE state : pop called when queue empty");
                    end
                  end
    endcase
    
    burst_semaphore.put();
  endtask

//wiki(Methods)
//---+++ size()
// The =size()= task is used to get the number of items available from the queue. The
// return value is provided throught the =size_out= output.
// This is a task because semaphores are used to protect the data structures.
//endwiki
  //wiki(Methods)
  virtual task size(output int size_out);//endwiki/*wiki(Methods)---*/
    burst_semaphore.get();

    `ovm_info(get_full_name(),$psprintf("LVM_QUEUE %s SIZE Received, fifo_status=%s  burst_count=%1d  idle_count=%1d  in_max_idle_mode=%1d  min_idle_count=%1d  data_q.size=%1d",
                                     get_full_name(),fifo_status.name(),burst_count,idle_count,in_max_idle_mode,min_idle_count,data_q.size()),OVM_DEBUG)

    if (!enable_state) begin
      size_out = 0;
      burst_semaphore.put();
      return;
    end

    case (fifo_status)
      FIFO_EMPTY: size_out = 0;
      FIFO_STALL: begin
                    if ((!in_max_idle_mode && (idle_count >= burst_max_idle)) ||
                        ( in_max_idle_mode && (idle_count >= burst_max_idle_interval))) begin
                      size_out = 1;
                    end else begin
                      size_out = 0;
                    end
                  end
      FIFO_BURST: begin
                    if ((burst_high_watermark == 0) || ((burst_size - burst_count) >= data_q.size()))
                      size_out = data_q.size();
                    else
                      size_out = burst_size - burst_count;
                  end
      FIFO_MIN_IDLE:
                  begin
                    if (min_idle_count >= burst_min_idle) begin
                      burst_count = 0;

                      if (data_q.size() == 0) begin
                        `ovm_info(get_full_name(),$psprintf("LVM_QUEUE SIZE: Changing fifo_status from FIFO_MIN_IDLE to FIFO_EMPTY"),OVM_DEBUG)
                        fifo_status = FIFO_EMPTY;
                        size_out = 0;
                      end else if ((burst_size == 1) || (data_q.size() >= burst_high_watermark)) begin
                        `ovm_info(get_full_name(),$psprintf("LVM_QUEUE SIZE: Watermark reached, changin fifo_status from FIFO_MIN_IDLE to FIFO_BURST"),OVM_DEBUG)
                        fifo_status = FIFO_BURST;
                        if ((burst_high_watermark == 0) || ((burst_size - burst_count) >= data_q.size()))
                          size_out = data_q.size();
                        else
                          size_out = burst_size - burst_count;
                      end else begin
                        idle_count = 0;
                        `ovm_info(get_full_name(),$psprintf("LVM_QUEUE SIZE: Changing fifo_status from FIFO_MIN_IDLE to FIFO_STALL"),OVM_DEBUG)
                        fifo_status = FIFO_STALL;
                        size_out = 0;
                      end
                    end else begin
                      size_out = 0;
                    end
                  end
    endcase

    `ovm_info(get_full_name(),$psprintf("LVM_QUEUE %s SIZE Returned size_out=%1d", get_full_name(),size_out),OVM_DEBUG)

    burst_semaphore.put();
  endtask

//wiki(Methods)
//---+++ abs_size()
// The =abs_size()= task returns the total number of items in the queue, whether they are
// currently available to be popped or not.
//endwiki
  //wiki(Methods)
  virtual task abs_size(output int size_out);//endwiki/*wiki(Methods)---*/
    burst_semaphore.get();

    size_out = data_q.size();

    burst_semaphore.put();
  endtask

endclass

`endif    

