(* use_dsp = "yes" *)
module simd_quad_add (input [47:0] a, b, output [47:0] out);
  assign {out[47:36], out[35:24], out[23:12], out[11:0]} 
   = {a[47:36] + b[47:36], a[35:24] + b[35:24], a[23:12] + b[23:12], a[11:0] + b[11:0]};
endmodule
