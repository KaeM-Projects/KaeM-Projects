`include "uvm_macros.svh"
import uvm_pkg::*;


class my_sequence extends uvm_sequence #(my_transaction);

  int tests_number = 1;
  int count = 1;
  
  `uvm_object_utils(my_sequence);
  
  function new (string name = "my_sequence");
    super.new(name);
  endfunction
  
  task body();
  
    my_transaction tr;
    
    repeat(tests_number) begin
      tr = my_transaction::type_id::create("tr");
      `uvm_info("SEQ", $sformatf("\nSekwencja nr: %0d", count), UVM_MEDIUM);
      start_item(tr);
      if (!tr.randomize()) `uvm_error("SEQ", "Transaction randomization failed");
      finish_item(tr);
      `uvm_info("SEQ", $sformatf("Stworzono transakcje transakcje: data_1=%0d, data_2=%0d", tr.data_1, tr.data_2), UVM_MEDIUM);
      count +=1;
    end
   endtask

endclass


class my_sequence_const extends uvm_sequence #(my_transaction);

  `uvm_object_utils(my_sequence_const);
  
  function new(string name = "my_sequence_const");
    super.new(name);
  endfunction
  
  virtual task body();
    my_transaction tr;
    `uvm_info("SEQ", "Sekwencja startuje", UVM_MEDIUM);
    tr = my_transaction::type_id::create("tr");
    start_item(tr);
    tr.data_1 = 3;
    tr.data_2 = 7;
    finish_item(tr);
    `uvm_info("SEQ", $sformatf("Wyslano transakcje: data_1=%0d, data_2=%0d", tr.data_1, tr.data_2), UVM_MEDIUM);
  endtask 
endclass

