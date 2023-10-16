(* use_dsp = "yes" *)
module simd_quad_add (input [47:0] a, b, output [47:0] out);
  assign {out[47:24], out[23:0]} 
   = {a[47:24] + b[47:24], a[23:0] + b[23:0]};
endmodule