module main
(
    input clock,
    input reset,
    input [7:0]a, 
    input [7:0]b, 
    output [7:0] y
);

  logic  [7:0] r;
  logic  [7:0] s;

  assign s = a + b;

  always_ff @(posedge clock) begin
    if (reset) begin
      r <= 8'b0;
    end else begin
      r <= s;
    end
  end

  assign y = r;
endmodule
