
typedef class transaction;

class generator; 
  rand transaction trans;
  mailbox gen_mbx;
  event trans_rdy;
  int  repeat_tests;  
  
  function new(mailbox gen_mbx, event trans_rdy);
    this.gen_mbx = gen_mbx;
    this.trans_rdy = trans_rdy;
  endfunction
  
  task main();
    repeat(repeat_tests)
    begin
      trans = new();
      trans.randomize();    
      gen_mbx.put(trans);
    end
   -> trans_rdy; 
  endtask  
endclass
