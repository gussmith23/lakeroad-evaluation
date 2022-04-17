module example(input a: [15:0], input b: [15:0], output out: [15:0]);
  assign out = a & b;
endmodule