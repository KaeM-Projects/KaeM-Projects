`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;

  my_agent ag;
  my_scoreboard scb;
  
  
  `uvm_component_utils(my_env);
  
  function new(string name = "my_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag = my_agent::type_id::create("ag", this);
    scb = my_scoreboard::type_id::create("scb", this);
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV", "Connecting agent AP to scoreboard export", UVM_LOW)
    if (ag.my_ap == null)
    `uvm_fatal("CONNECT", "ag.my_ap is NULL");
     if (scb.my_analysis_export == null)
    `uvm_fatal("CONNECT", "scb.my_analysis_export is NULL");

    ag.my_ap.connect(scb.my_analysis_export);
  endfunction
  
endclass