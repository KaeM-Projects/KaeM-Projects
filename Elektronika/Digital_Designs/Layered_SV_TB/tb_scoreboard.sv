
class scoreboard;
  mailbox monitor_mbx;
  int trans_cnt = 0; 

  bit [7:0] expected_data = 0;
  bit expected_co;

  //constructor
  function new(mailbox monitor_mbx);
    this.monitor_mbx = monitor_mbx;
  endfunction
  
  //-----
  task main;
    transaction trans;
    bit [7:0] curr_result = 0;
    bit curr_co;
    forever
    begin
      //prev_data_out = trans.data_out;
      expected_data = curr_result;
      expected_co = curr_co;
      monitor_mbx.get(trans);
      if(trans.ce) begin
        case(trans.alu_code)
          0 : {curr_co,curr_result} = curr_result + trans.data_in + trans.ci;
          1 : {curr_co,curr_result} = curr_result - trans.data_in - trans.ci;
          2 : {curr_co,curr_result} = {1'b0, curr_result & trans.data_in};
          3 : {curr_co,curr_result} = {1'b0, curr_result | trans.data_in};
          4 : {curr_co,curr_result} = {1'b0, curr_result ^ trans.data_in};
          5 : {curr_co,curr_result} = {1'b0, ~curr_result};
          6 : {curr_co,curr_result} = {1'b0, trans.data_in};
          7 : {curr_co,curr_result} = {1'b0, 8'b0};
          default : begin{curr_co,curr_result} = {1'b0, 8'b0}; $error("ALU code unrecognized");end
        endcase
      end
      
      if((expected_data == trans.data_out) && (expected_co == trans.co)) $display("[SCOREBOARD]: <DATA OK> <data expected: %0d>, <data actual: %0d>, <co expected: %b>, <co actual: %b> ", expected_data,  trans.data_out, expected_co, trans.co); else 
      $error("[SCOREBOARD] Fail at time: %0.t, data expected: %0d, data actual: %0d , co expected: %b, co actual: %b ", $time, expected_data,  trans.data_out, expected_co, trans.co);

      trans_cnt++;
    end
  endtask
  
endclass
