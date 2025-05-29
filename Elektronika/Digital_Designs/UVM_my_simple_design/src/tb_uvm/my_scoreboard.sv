`include "uvm_macros.svh"
import uvm_pkg::*;

class my_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(my_scoreboard);
  
  uvm_analysis_imp #(my_transaction, my_scoreboard) my_analysis_export;

  function new(string name = "my_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    
  endfunction
  
  bit [7:0] data_1_mem = 0;
  bit [7:0] data_2_mem = 0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    my_analysis_export = new("my_analysis_export",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  
  virtual function void write(my_transaction tr);
     if (!({tr.cy_comb,tr.data_out_comb} == tr.data_1 + tr.data_2)) begin
        `uvm_error("SCOREBOARD", $sformatf("sumator komnbinacyjny, zly wynik %0d != %0d + %0d",{tr.cy_comb,tr.data_out_comb},tr.data_1, tr.data_2));
      end
     else begin 
        `uvm_info("SCOREBOARD",$sformatf("wynik kombinacyjny OK %0d = %0d + %0d",{tr.cy_comb,tr.data_out_comb},tr.data_1, tr.data_2),UVM_MEDIUM);
      end
     if (!({tr.cy_sync,tr.data_out_sync} == data_1_mem + data_2_mem)) begin
        `uvm_error("SCOREBOARD", $sformatf("sumator sekwencyjny, zly wynik %0d = %0d + %0d",{tr.cy_sync,tr.data_out_sync},data_1_mem, data_2_mem));
      end
     else begin
       `uvm_info("SCOREBOARD",$sformatf("wynik sekwencyjny OK %0d = %0d + %0d",{tr.cy_sync,tr.data_out_sync},data_1_mem, data_2_mem),UVM_MEDIUM);
       end
     data_1_mem = tr.data_1;
     data_2_mem = tr.data_2;
  endfunction
  
endclass