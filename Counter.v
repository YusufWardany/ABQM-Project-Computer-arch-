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
