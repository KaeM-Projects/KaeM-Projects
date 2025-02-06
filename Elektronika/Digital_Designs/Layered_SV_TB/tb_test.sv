program test(alu_acc_unit_intf intf);
  environment env;
  
  initial 
  begin
    env = new(intf);
    env.gen.repeat_tests = 1000;
    env.run();
  end
endprogram
