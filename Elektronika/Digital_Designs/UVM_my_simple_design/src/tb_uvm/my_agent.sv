`include "uvm_macros.svh"
import uvm_pkg::*;

class my_agent extends uvm_agent;

  my_sequencer seqr;
  my_driver drv;
  my_monitor mon;
  
  uvm_analysis_port #(my_transaction) my_ap;
  
  virtual dut_if iface;
  
  `uvm_component_utils(my_agent);
  
  function new(string name = "my_agent", uvm_component parent = null);
    super.new(name,parent);
    
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    my_ap = new("my_ap",this);
    mon = my_monitor::type_id::create("mon",this);
    uvm_config_db#(virtual dut_if)::set(this,"mon","vif",iface);
    
    if(is_active == UVM_ACTIVE) begin
      seqr = my_sequencer::type_id::create("seqr",this);
      drv = my_driver::type_id::create("drv",this);
      uvm_config_db#(virtual dut_if)::set(this,"drv","vif",iface);
    end
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "Setting my_ap = mon.my_analysis_port", UVM_LOW)
    mon.my_analysis_port.connect(my_ap);
    if(is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass
