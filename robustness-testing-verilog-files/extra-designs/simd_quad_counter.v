(* use_dsp = "yes" *)
module simd_quad_counter (input clk, input enable, output [47:0] acc);
  logic [47:0] acc_internal = 0;
  always @ (posedge clk) if (enable) acc_internal =
    {acc_internal[47:36] + 1, acc_internal[35:24] + 1, acc_internal[23:12] + 1, acc_internal[11:0] + 1}
  assign acc = acc_internal;
endmodule
