(* use_dsp = "yes" *)
module simd_quad_acc (input clk, input [47:0] val, output [47:0] acc);
  logic [47:0] acc_internal;
  always @ (posedge clk) acc_internal =
    {acc_internal[47:36] + val[47:36], acc_internal[35:24] + val[35:24], acc_internal[23:12] + val[23:12],
     acc_internal[11:0] + val[11:0]}
  assign acc = acc_internal;
endmodule
