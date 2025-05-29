`include "uvm_macros.svh"
import uvm_pkg::*;

class my_monitor extends uvm_monitor;

  `uvm_component_utils(my_monitor);
  
  uvm_analysis_port #( my_transaction ) my_analysis_port;
  
  function new(string name = "my_monitor", uvm_component parent);
    super.new(name, parent);
    
  endfunction
  
  virtual dut_if iface;
  my_transaction tr;
  
  virtual function void build_phase (uvm_phase phase);
    if(!uvm_config_db#(virtual dut_if)::get(this, "", "vif",iface)) begin
      `uvm_fatal("NO_VIF","Nie udalo sie pobrac konfiguracji interfejsu");
    end 
    my_analysis_port = new("my_analysis_port",this);
  endfunction
  
  task run_phase (uvm_phase phase);
    forever begin
      @(posedge iface.clk);
      tr = my_transaction::type_id::create("tr",this);
      tr.data_1 = iface.data_1;
      tr.data_2 = iface.data_2;
      tr.data_out_comb = iface.data_out_comb;
      tr.data_out_sync = iface.data_out_sync;
      tr.cy_comb = iface.cy_comb;
      tr.cy_sync = iface.cy_sync;
      `uvm_info("MONITOR",$sformatf("Przechwycono na wejsciach data_1: %0d, data_2: %0d, out_comb: %0d, out_sync: %0d", tr.data_1, tr.data_2, {tr.cy_comb,tr.data_out_comb}, {tr.cy_sync,tr.data_out_sync}), UVM_MEDIUM);
      my_analysis_port.write(tr);
    end
  endtask
    
endclass