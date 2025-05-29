`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequencer extends uvm_sequencer #(my_transaction);

  `uvm_component_utils(my_sequencer);
  
  function new (string name = "my sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass