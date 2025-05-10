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


