`include "uvm_macros.svh"
import uvm_pkg::*;


class my_driver extends uvm_driver #(my_transaction);

  `uvm_component_utils(my_driver);
  
  function new(string name = "my_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual dut_if iface;
  
  
  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", iface)) begin
      `uvm_fatal("NO_VIF", "Nie udalo sie pobrac interfejsu z konfiguracji!");
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    my_transaction req;
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("DRIVER", $sformatf("pobrano wartosci w transakcji: data_1: %0d, data_2 %0d", req.data_1, req.data_2),UVM_MEDIUM);
      @(posedge iface.clk);
      iface.data_1 = req.data_1;
      iface.data_2 = req.data_2;
      seq_item_port.item_done();
    end
  
  endtask
endclass
