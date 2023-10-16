(* use_dsp = "yes" *)
module simd_dual_acc (input clk, input [47:0] val, output [47:0] acc);
  logic [47:0] acc_internal;
  always @ (posedge clk) acc_internal =
    {acc_internal[47:24] + val[47:24], acc_internal[23:0] + val[23:0]}
  assign acc = acc_internal;
endmodule
