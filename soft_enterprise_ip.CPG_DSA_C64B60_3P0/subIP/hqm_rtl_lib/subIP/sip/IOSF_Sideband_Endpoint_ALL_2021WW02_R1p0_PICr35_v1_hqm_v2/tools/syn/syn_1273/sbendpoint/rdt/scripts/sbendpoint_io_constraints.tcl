# Side clock should always be valid for the IOSF interface
set side_clk_period  [get_attribute [get_clock side_clk]  period]
# Agent clock needs to be set to the side clock for synchronous designs.
if {[sizeof_collection [get_cells {gen_async_rst_blk_agent_rst_sync}]] > 0} {
   set agent_clk_period [get_attribute [get_clock agent_clk] period]
   set agent_clk        [get_clock agent_clk]
   puts "Sideband Endpoint is in Async Mode, using agent_clk for agent interface"
} else {
   set agent_clk_period [get_attribute [get_clock side_clk] period]
   set agent_clk        [get_clock side_clk]
   puts "Sideband Endpoint is in Sync Mode, using side_clk for agent interface"
}

#set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {agent_clk     }]
#set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {side_clk      }]
#set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {gated_side_clk}]
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_rst_b}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {side_rst_b}] -add_delay

set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {side_clkack}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {side_clkreq}]

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {agent_clkreq}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {agent_clkreq}] -add_delay

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {agent_idle}]

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_usync }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {agent_usync}]
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {usyncselect}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {usyncselect}] -add_delay

set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tx_ext_headers*}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_ism_lock_b}]

set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_clkreq}] -add_delay
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_clkreq}] -add_delay

set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_clk_valid}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_idle     }]
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_comp_exp }]
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_parity_err_out}]

set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {gated_side_clk}]

set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {meom            }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {mnpcup          }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mnpput          }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mpayload*       }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mparity*        }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {mpccup          }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mpcput          }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {side_ism_agent* }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_ism_fabric*}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {teom            }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {tnpcup          }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tnpput          }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tpayload*       }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tparity*        }]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {tpccup          }]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tpcput          }]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_npeom*    }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_npirdy*   }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mmsg_npmsgip   }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_nppayload*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_npparity* }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mmsg_npsel*    }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mmsg_nptrdy    }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_pceom*    }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_pcirdy*   }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mmsg_pcmsgip   }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_pcpayload*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mmsg_pcparity* }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mmsg_pcsel*    }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mmsg_pctrdy    }]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {do_serr*       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ext_parity_err_detected}]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_addr*      }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_addrlen    }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_bar*       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_be*        }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_dest*      }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_fid*       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_irdy       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mreg_nmsgip     }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_npwrite    }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_opcode*    }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mreg_pmsgip     }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_source*    }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_tag*       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {mreg_trdy       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_wdata*     }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_sairs_valid}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_sai*       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {mreg_rs*        }]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {tmsg_npclaim*    }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_npeom       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {tmsg_npfree*     }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_npmsgip     }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_nppayload*  }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_npparity*   }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_npput       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_npvalid     }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pccmpl      }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pceom       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {tmsg_pcfree*     }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pcmsgip     }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pcpayload*  }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pcparity*   }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pcput       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {tmsg_pcvalid     }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ur_csairs_valid  }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ur_csai*         }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ur_crs*          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {ur_rx_sairs_valid}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {ur_rx_sai*       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {ur_rx_rs*        }]

set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_addr*         }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_addrlen       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_bar*          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_be*           }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {treg_cerr          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_dest*         }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_eh            }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_eh_discard    }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_ext_header*   }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_fid*          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_irdy          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_np            }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_opcode*       }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {treg_rdata*        }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_source*       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_tag*          }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {treg_trdy          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_wdata*        }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {treg_csairs_valid  }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {treg_csai*         }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {treg_crs*          }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_rx_sairs_valid}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_rx_sai*       }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {treg_rx_rs*        }]

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {visa_all_disable     }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {visa_customer_disable}] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {visa_ser_cfg_in*     }] -add_delay
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {avisa_data_out*      }] -add_delay
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {avisa_clk_out*       }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_all_disable     }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_customer_disable}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_ser_cfg_in*     }] -add_delay
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {avisa_data_out*      }] -add_delay
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {avisa_clk_out*       }] -add_delay

set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_agent_tier1_ag*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_agent_tier2_ag*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier1_ag* }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier2_ag* }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_reg_tier1_ag*  }]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_reg_tier2_ag*  }]

set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier1_sb*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier2_sb*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_port_tier1_sb*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_port_tier2_sb*}]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {cgctrl_clkgatedef}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {cgctrl_clkgaten  }]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {cgctrl_idlecnt*  }]

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fdfx_rst_b}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fdfx_rst_b}] -add_delay

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fdfx_sbparity_def}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fdfx_sbparity_def}] -add_delay

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_byprst_b     }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_clkungate    }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_clkungate_syn}] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_latchclosed_b}] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_latchopen    }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_mode         }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_rstbypen     }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {fscan_shiften      }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_byprst_b     }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_clkungate    }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_clkungate_syn}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_latchclosed_b}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_latchopen    }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_mode         }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_rstbypen     }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_shiften      }] -add_delay

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {jta_clkgate_ovrd   }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {jta_force_clkreq   }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {jta_force_creditreq}] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {jta_force_idle     }] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]   [get_ports {jta_force_notidle  }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_clkgate_ovrd   }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_clkreq   }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_creditreq}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_idle     }] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_notidle  }] -add_delay
