module abqm (
  input clk, 
  input reset, 
  input in, 
  input out,
  input [1:0]tcount,
  output wire Full_flag, 
  output wire Empty_flag,
  output wire [6:0]OutputSegmentRight,
  output wire [6:0]OutputSegmentLeft,
  output wire [6:0]OutputSegmentpcount
,output wire [7:0] Wait_Time
,output wire [2:0] pcount
);

  
  reg CLK1Hz;
  clock_divider divider(clk,CLK1Hz);
  
  
  
  
  counter counter_inst (CLK1Hz, reset, in, out, pcount);
  
  FSM fsm_inst (
    .clk(CLK1Hz),
    .reset(reset),
    .in(in),
    .out(out),
    .pcount(pcount),
    .full(Full_flag),
    .empty(Empty_flag)
  );
  wire [1:0] address1;
  wire [3:0] address2;
  assign address1 = {tcount};
  assign address2 = {pcount};



  Rom rom_inst(CLK1Hz, reset, {address1,address2}, Wait_Time);

  
  decoder_7seg segRight(CLK1Hz, reset, Wait_Time[3],Wait_Time[2],Wait_Time[1],Wait_Time[0], OutputSegmentRight[0], OutputSegmentRight[1], OutputSegmentRight[2], OutputSegmentRight[3], 
			OutputSegmentRight[4], OutputSegmentRight[5], OutputSegmentRight[6]);
  decoder_7seg segLeft(CLK1Hz, reset, Wait_Time[7],Wait_Time[6],Wait_Time[5],Wait_Time[4], OutputSegmentLeft[0], OutputSegmentLeft[1], OutputSegmentLeft[2], OutputSegmentLeft[3], 
			OutputSegmentLeft[4], OutputSegmentLeft[5], OutputSegmentLeft[6]);
  decoder_7seg segPcount(CLK1Hz, reset, address2[3],address2[2],address2[1],address2[0], OutputSegmentpcount[0], OutputSegmentpcount[1], OutputSegmentpcount[2], OutputSegmentpcount[3], 
			OutputSegmentpcount[4], OutputSegmentpcount[5], OutputSegmentpcount[6]);


endmodule


module abqm_tb;

  reg clk = 0;
  reg reset = 0;
  reg in = 0;
  reg out = 0;
  reg [1:0] tcount = 1;
  
  // Outputs
  wire Full_flag;
  wire Empty_flag;
  wire [6:0] OutputSegmentRight;
  wire [6:0] OutputSegmentLeft;
  wire [6:0] OutputSegmentpcount;
wire [7:0] Wait_Time;
wire [2:0] pcount;

abqm uut (
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out),
    .tcount(tcount),
    .Full_flag(Full_flag),
    .Empty_flag(Empty_flag),
    .OutputSegmentRight(OutputSegmentRight),
    .OutputSegmentLeft(OutputSegmentLeft),
    .OutputSegmentpcount(OutputSegmentpcount), .Wait_Time(Wait_Time)
    ,.pcount(pcount)
  );

always #5 clk = ~clk;
initial
begin
#10 reset = 1;
#10 reset = 0;
#10 in = 1;out = 0; tcount = 1;
#10 in = 0;out = 1; tcount = 1;
#10 in = 1;out = 0; tcount = 1;
#10 in = 1;out = 0; tcount = 2;
#10 in = 0;out = 1; tcount = 3;
#10 in = 1;out = 0; tcount = 1;
#10 in = 1;out = 0; tcount = 1;



#10 in = 1;out = 0; tcount = 3;
#10 in = 1;out = 0; tcount = 3;
#10 in = 1;out = 0; tcount = 3;

#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 0;out = 1; tcount = 3;
#10 in = 1;out = 0; tcount = 3;
#10 in = 1;out = 0; tcount = 3;

end

endmodule



//////////////////////////////////////////////////////////////
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






////////////////////////////////////////////////////
module counter (
  input clk, 
  input reset, 
  input in, 
  input out,
  output reg [2:0] pcount // max 7
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      pcount <= 3'b000; // 0
    end else if (in && (pcount < 3'b111)) begin 
      pcount <= pcount + 1; 
    end else if (out && (pcount > 3'b000)) begin
      pcount <= pcount - 1; 
    end
  end

endmodule

/////////////////////////////////////////////////

module clock_divider (clk, reset, CLK1Hz);

input clk, reset;

output CLK1Hz;

// ------------------------------------------------- //

reg CLK1Hz;

reg [24:0] count; // log2(25 million)

// ------------------------------------------------- //

always @(posedge clk or posedge reset)

begin

if(reset) 

begin

count <= 0;

CLK1Hz <= 0;

end

else

begin

if(count < 25_000_000)

count <= count + 1; 

else

begin

CLK1Hz = ~CLK1Hz; 

count <= 0;

end

end

end


endmodule



///////////////////////////////////////////////////////
module Rom(
input clk, 
input reset, 
input [4:0] address,
           
output reg [7:0] data_out);
           
    always @(posedge clk or posedge reset) begin
if(reset)
begin
data_out = 8'b00000000;
end
else
begin
        case(address)
            5'b01000 : data_out = 8'b00000000;
            5'b01001 : data_out = 8'b00000011;
            5'b01010 : data_out = 8'b00000110;
            5'b01011 : data_out = 8'b00001001;
            5'b01100 : data_out = 8'b00010010;
            5'b01101 : data_out = 8'b00010101;
            5'b01110 : data_out = 8'b00011000;
            5'b01111 : data_out = 8'b00100001;
            5'b10000 : data_out = 8'b00000000;
            5'b10001 : data_out = 8'b00000011;
            5'b10010 : data_out = 8'b00000100;
            5'b10011 : data_out = 8'b00000110;
            5'b10100 : data_out = 8'b00000111;
            5'b10101 : data_out = 8'b00001001;
            5'b10110 : data_out = 8'b00010000;
            5'b10111 : data_out = 8'b00010010;
            5'b11000 : data_out = 8'b00000000;
            5'b11001 : data_out = 8'b00000011;
            5'b11010 : data_out = 8'b00000100;
            5'b11011 : data_out = 8'b00000101;
            5'b11100 : data_out = 8'b00000110;
            5'b11101 : data_out = 8'b00000111;
            5'b11110 : data_out = 8'b00001000;
            5'b11111: data_out = 8'b00001001;
            default: data_out = 8'b00000000;
        endcase
end
    end
    
endmodule


///////////////////////////////////
module decoder_7seg (clk, reset, A, B, C, D, led_a, led_b, led_c, led_d, led_e, led_f, led_g);
input A, B, C, D, clk, reset;
output reg led_a; 
output reg led_b;
output reg led_c; 
output reg led_d; 
output reg led_e; 
output reg led_f; 
output reg led_g;
always @(posedge clk or posedge reset) begin
if(reset)
begin
led_a = 1'b0;
led_b = 1'b0;
led_c = 1'b0;
led_d = 1'b0;
led_e = 1'b0;
led_f = 1'b0;
led_g = 1'b0;
end
else
begin
led_a = ~(A | C | B&D | ~B&~D);
led_b = ~(~B | ~C&~D | C&D);
led_c = ~(B | ~C | D);
led_d = ~(~B&~D | C&~D | B&~C&D | ~B&C |A);
led_e = ~(~B&~D | C&~D);
led_f = ~(A | ~C&~D | B&~C | B&~D);
led_g = ~(A | B&~C | ~B&C | C&~D);
end
end

endmodule




module tb_decoder_7seg;
  // Inputs
  reg clk;
  reg reset;
  reg A;
  reg B;
  reg C;
  reg D;

  // Outputs
  wire led_a;
  wire led_b;
  wire led_c;
  wire led_d;
  wire led_e;
  wire led_f;
  wire led_g;

 
  decoder_7seg uut (
    .clk(clk), 
    .reset(reset), 
    .A(A), 
    .B(B), 
    .C(C), 
    .D(D), 
    .led_a(led_a), 
    .led_b(led_b), 
    .led_c(led_c), 
    .led_d(led_d), 
    .led_e(led_e), 
    .led_f(led_f), 
    .led_g(led_g)
  );

  
  always #5 clk = ~clk; 

  initial begin
    // Initialize Inputs
    clk = 0;
    reset = 0;
    A = 0;
    B = 0;
    C = 0;
    D = 0;

    // Apply reset
    reset = 1;
    #10;
    reset = 0;

    // Apply test cases
    // Test case for 0
    {A, B, C, D} = 4'b0000; #10;
    // Test case for 1
    {A, B, C, D} = 4'b0001; #10;
    // Test case for 2
    {A, B, C, D} = 4'b0010; #10;
    // Test case for 3
    {A, B, C, D} = 4'b0011; #10;
    // Test case for 4
    {A, B, C, D} = 4'b0100; #10;
    // Test case for 5
    {A, B, C, D} = 4'b0101; #10;
    // Test case for 6
    {A, B, C, D} = 4'b0110; #10;
    // Test case for 7
    {A, B, C, D} = 4'b0111; #10;
    // Test case for 8
    {A, B, C, D} = 4'b1000; #10;
    // Test case for 9
    {A, B, C, D} = 4'b1001; #10;
    // Test case for A
    {A, B, C, D} = 4'b1010; #10;
    // Test case for B
    {A, B, C, D} = 4'b1011; #10;
    // Test case for C
    {A, B, C, D} = 4'b1100; #10;
    // Test case for D
    {A, B, C, D} = 4'b1101; #10;
    // Test case for E
    {A, B, C, D} = 4'b1110; #10;
    // Test case for F
    {A, B, C, D} = 4'b1111; #10;

    // End simulation
    //$finish;
  end
      
endmodule











