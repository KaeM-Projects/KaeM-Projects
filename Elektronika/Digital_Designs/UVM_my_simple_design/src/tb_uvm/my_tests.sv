`include "uvm_macros.svh"
import uvm_pkg::*;


class my_test extends uvm_test;

  `uvm_component_utils(my_test);
  
  my_env env;
  virtual dut_if vif;
  
  function new (string name = "my_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif)) begin
      `uvm_fatal("NO_VIF","Nie udalo sie pobrac interfejsu z config_db");
    end
    
    uvm_config_db#(virtual dut_if)::set(this,"env.ag","vif",vif);
    
    env = my_env::type_id::create("env", this);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    my_sequence seq;
    phase.raise_objection(this);
    wait(vif.arstn == 1);
    #10;
    `uvm_info("TEST", "Start run phase", UVM_LOW);
    seq = my_sequence::type_id::create("seq");
    seq.tests_number = 10;
    seq.start(env.ag.seqr);
    phase.drop_objection(this);
  endtask
  
endclass 


class my_test_const_vals extends uvm_test;

  `uvm_component_utils(my_test_const_vals);
  
  my_env env;
  virtual dut_if vif;
  
  function new (string name = "my_test_const_vals", uvm_component parent = null);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif)) begin
      `uvm_fatal("NO_VIF","Nie udalo sie pobrac interfejsu z config_db");
    end
    
    uvm_config_db#(virtual dut_if)::set(this,"env.ag","vif",vif);
    
    env = my_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    my_sequence_const seq;
    phase.raise_objection(this);
    wait(vif.arstn == 1);
    #10;
    `uvm_info("TEST", "Start run phase", UVM_LOW);
    seq = my_sequence_const::type_id::create("seq");
    seq.start(env.ag.seqr);
    repeat (5) @(posedge vif.clk);
    phase.drop_objection(this);
  endtask
  
endclass 

class test_autoseq extends uvm_test;
  
  `uvm_component_utils(test_autoseq);
  
  my_env env;
  virtual dut_if vif;
  
  function new (string name = "test_autoseq", uvm_component parent = null);
    super.new(name, null);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif)) begin
      `uvm_fatal("NO_VIF","Nie udalo sie pobrac interfejsu z config_db");
    end
    
    uvm_config_db#(virtual dut_if)::set(this,"env.ag","vif",vif);
    
    env = my_env::type_id::create("env", this);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.ag.seqr.main_phase", "default_sequence", my_sequence::get_type());
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("TEST", "Test uruchomiony", UVM_LOW);
    #100;
  endtask
  
  

endclass