
typedef class generator;
typedef class monitor;
typedef class scoreboard;

class environment;
  generator gen;
  driver    driv;
  monitor   mon;
  scoreboard scb;
  mailbox   env_mbx_drv;
  mailbox   env_mbx_mon;
  event gen_ended;
  virtual alu_acc_unit_intf alu_acc_unit_virtual_intf;
  
  //constructor
  function new(virtual alu_acc_unit_intf alu_acc_unit_virtual_intf);
    this.alu_acc_unit_virtual_intf = alu_acc_unit_virtual_intf;
    env_mbx_drv = new();
    env_mbx_mon = new();
    gen = new(env_mbx_drv, gen_ended);
    driv = new(alu_acc_unit_virtual_intf, env_mbx_drv);
    mon  = new(alu_acc_unit_virtual_intf, env_mbx_mon);
    scb  = new(env_mbx_mon);
  endfunction

  //
  task pre_test();
    driv.reset();
  endtask
  
  //
  task test();
    fork 
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_tests == driv.trans_cnt);
    wait(mon.trans_cnt == scb.trans_cnt);
  endtask  
  
  task run;
    pre_test();
    test();
    post_test();
    #10 $finish;
  endtask
  
endclass
