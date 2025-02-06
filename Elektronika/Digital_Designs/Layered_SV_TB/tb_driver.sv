//`include "tb_interface.sv"
//`include "tb_transaction.sv"

//----------------------------------------------------------
typedef class transaction;
class driver;
  int trans_cnt=0; //number of transactions
  virtual alu_acc_unit_intf alu_acc_unit_virtual_intf;
  mailbox driver_mbx;
    
  //constructor
  function new(virtual alu_acc_unit_intf alu_acc_unit_virtual_intf, mailbox driver_mbx);
    this.alu_acc_unit_virtual_intf = alu_acc_unit_virtual_intf;
    this.driver_mbx = driver_mbx;
  endfunction
  
  
  //Reset task
  task reset;
    wait(alu_acc_unit_virtual_intf.aresetn);
    $display("[DRIVER] reset");
    alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.data_in <= 0;
    alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.alu_code <= 0;
    alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.ci <= 0;
    alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.ce <= 0;
  endtask
  
  //++
  task main;
    forever
    begin
      transaction trans;

      driver_mbx.get(trans);
      @(posedge alu_acc_unit_virtual_intf.driver_mode.clk);
      alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.data_in <= trans.data_in;
      alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.alu_code <= trans.alu_code;
      alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.ci <= trans.ci;
      alu_acc_unit_virtual_intf.driver_mode.driver_clk_block.ce <= trans.ce;

      $display("[DRIVER] transfer %0d generated data in: %0h, alu operation value: %0h, ci: %b, ce: %b ", trans_cnt, trans.data_in, /*trans.alu_code.name(),*/ trans.alu_code, trans.ci, trans.ce);
      
      trans_cnt++;

    end
  endtask
         
endclass
