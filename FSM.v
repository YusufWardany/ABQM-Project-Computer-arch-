module FSM(clk, reset, pcount, in, out, full, empty);
input clk, reset, in, out;
input [2:0] pcount;
reg [1:0] state;
output reg full, empty;
parameter 	s0 = 2'b00, 
		s1 = 2'b01, 
		s2 = 2'b10, 
		s3 = 2'b11; 

always @(posedge clk or posedge reset)

begin
if(reset)
begin
state = 0;
empty = 1;
full = 0;
end
else
begin


case(state)

s0: if(in == 1 && out == 0)
    begin
      state =  s1;
      empty = 0;
      full = 0;
    end
s1: if(in == 1 && out == 0 && pcount == 3'b111)
    begin
      state = s3;
      empty = 0;
      full = 1;
    end
  else if(in == 1 && out == 0 && pcount != 3'b111)
    begin
      state = s1;
      empty = 0;
      full = 0;
    end
  else if(in == 0 && out == 1)
    begin
    state = s2;
    empty = 0;
    full = 0;
  end
s2: if(in == 0 && out == 1 && pcount == 3'b000)
  begin
    state = s0;
    empty = 1;
    full = 0;
  end
else if(in == 0 && out == 1 && pcount != 3'b000)
  begin
    state = s2;
    empty = 0;
    full = 0;
  end
else if(in == 1 && out == 0)
  begin
    state = s1;
    empty = 0;
    full = 0;
  end
s3: if(in == 0 && out == 1)
begin
  state = s2;
  empty = 0;
  full = 0;
end

  
    
		
endcase 



end


end

endmodule


/*module tb_FSM;
  // Inputs
  reg clk;
  reg reset;
  reg in;
  reg out;
  reg [2:0] pcount;

  // Outputs
  wire full;
  wire empty;

  // Instantiate the FSM module
  FSM uut (
    .clk(clk),
    .reset(reset),
    .pcount(pcount),
    .in(in),
    .out(out),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    in = 0;
    out = 0;
    pcount = 3'b000;

    // Wait for global reset
    #10;
    reset = 0;

    // Test case: Transition from empty to full
    $display("Transition from empty to full");
    in = 1; out = 0; pcount = 3'b000;
    #10; // Move to state s1
    pcount = 3'b001; #10; // Stay in state s1
    pcount = 3'b111; #10; // Move to state s3 (full)

    // Test case: Transition from full to empty
    $display("Transition from full to empty");
    in = 0; out = 1; pcount = 3'b111;
    #10; // Move to state s2
    pcount = 3'b000; #10; // Move to state s0 (empty)

    // End of simulation
    $stop;
  end

  // Monitor the output states
  initial begin
    //$monitor("Time: %d, State: %b, pcount: %b, in: %b, out: %b, full: %b, empty: %b", $time, uut.state, pcount, in, out, full, empty);
  end
endmodule*/

module tb_FSM;
  // Inputs
  reg clk;
  reg reset;
  reg in;
  reg out;
  reg [2:0] pcount;

  // Outputs
  wire full;
  wire empty;

  // Instantiate the FSM module
  FSM uut (
    .clk(clk),
    .reset(reset),
    .pcount(pcount),
    .in(in),
    .out(out),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    in = 0;
    out = 0;
    pcount = 3'b000;

    // Wait for global reset
    #10;
    reset = 0;

    // Test case: Transition from empty to add state
    in = 1; out = 0; pcount = 3'b000;
    #10;

    // Test case: Transition within add state
    in = 1; out = 0; pcount = 3'b001;
    #10;

    // Test case: Transition to full state
    in = 1; out = 0; pcount = 3'b111;
    #10;

    // Test case: Transition from full to subtract state
    in = 0; out = 1; pcount = 3'b111;
    #10;

    // Test case: Transition from subtract to empty state
    in = 0; out = 1; pcount = 3'b000;
    #10;

    // End of simulation
  end
endmodule





