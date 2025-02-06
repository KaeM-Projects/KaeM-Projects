//----------------------------------------------------------
class monitor;
  virtual alu_acc_unit_intf alu_acc_unit_virtual_intf;
  mailbox moninor_mbx;
  int trans_cnt=0; 
  
  //constructor
  function new(virtual alu_acc_unit_intf alu_acc_unit_virtual_intf, mailbox moninor_mbx);
    this.alu_acc_unit_virtual_intf = alu_acc_unit_virtual_intf;
    this.moninor_mbx = moninor_mbx;
  endfunction
  
  //++
  task main;
    forever
    begin
      transaction trans;
      trans = new();

      @(posedge alu_acc_unit_virtual_intf.monitor_mode.clk);
      
        trans.data_in = alu_acc_unit_virtual_intf.monitor_mode.monitor_clk_block.data_in;
        trans.alu_code = alu_acc_unit_virtual_intf.monitor_mode.monitor_clk_block.alu_code;
        trans.co = alu_acc_unit_virtual_intf.monitor_mode.monitor_clk_block.co;
        trans.data_out = alu_acc_unit_virtual_intf.monitor_mode.monitor_clk_block.data_out;
        trans.ci = alu_acc_unit_virtual_intf.monitor_mode.monitor_clk_block.ci;
        trans.ce = alu_acc_unit_virtual_intf.monitor_mode.monitor_clk_block.ce;
      
      
      
   //   wait(fifo_virt_intf.monitor_mode.monitor_clk_block.m_axis_ready || fifo_virt_intf.monitor_mode.monitor_clk_block.s_axis_valid);
//      
//      if(fifo_virt_intf.monitor_mode.monitor_clk_block.s_axis_valid)
//      begin
//        trans.valid_in = fifo_virt_intf.monitor_mode.monitor_clk_block.s_axis_valid;
//        trans.data_in = fifo_virt_intf.monitor_mode.monitor_clk_block.s_axis_data;
//		trans.ready_out = fifo_virt_intf.monitor_mode.monitor_clk_block.s_axis_ready;
//      end
//
//      if(fifo_virt_intf.monitor_mode.monitor_clk_block.m_axis_ready)
//      begin
//        trans.ready_in = fifo_virt_intf.monitor_mode.monitor_clk_block.m_axis_ready;
//        trans.data_out = fifo_virt_intf.monitor_mode.monitor_clk_block.m_axis_data;
//		trans.valid_out = fifo_virt_intf.monitor_mode.monitor_clk_block.m_axis_valid;
//      end      
      
      $display("[MONITOR] transfer at time: %0.t data_in: %0d, alu_op: %0h, data_out: %0d, carry_out: %0b ", $time, trans.data_in, trans.alu_code,  trans.data_out, trans.co);
      
      moninor_mbx.put(trans);
      trans_cnt ++;
    end
  endtask
  
endclass
