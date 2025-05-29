`include "uvm_macros.svh"
import uvm_pkg::*;


class my_transaction extends uvm_sequence_item;

  rand bit [7:0] data_1;
  rand bit [7:0] data_2;
  bit [7:0] data_out_comb;
  bit [7:0] data_out_sync;
  bit cy_comb;
  bit cy_sync;
  
  `uvm_object_utils(my_transaction);
  
  function new(string name = "my_transaction");
    super.new(name);
  endfunction
  
endclass
