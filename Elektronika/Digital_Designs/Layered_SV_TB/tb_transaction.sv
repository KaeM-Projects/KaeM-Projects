//----------------------------------------------------------
class transaction;
       bit [7:0]  data_out;
  rand bit [7:0]  data_in;  
  rand bit [2:0]  alu_code;  
       bit        co; 
  rand bit        ci; 
  rand bit        ce; 


  
//  constraint alu_op_sel { 
//  alu_code inside {3'd5};
//  ce inside {1'b1};
  
//  }; 
  

endclass
