module main #
(
    parameter W = 8,
    parameter N = 4
)
(
    input clock,
    input reset,
    input [W-1:0] a [N-1:0],
    input [W-1:0] b [N-1:0],
    output [W-1:0] y [N-1:0]
);
    logic [W-1:0] ra [N-1:0];
    logic [W-1:0] rb [N-1:0];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            always_ff @(posedge clock) begin
                if (reset) begin
                    ra[i] <= 0;
                    rb[i] <= 0;
                end else begin
                    ra[i] <= a[i];
                    rb[i] <= b[i];
                end
            end
            assign y[i] = ra[i] + rb[i];
        end
    endgenerate
    
    //logic [W-1:0] r [N-1:0];
    //genvar i;
    //generate
    //    for (i = 0; i < N; i = i + 1) begin
    //        always_ff @(posedge clock) begin
    //            if (reset) begin
    //                r[i] <= 0;
    //            end else begin
    //                r[i] <= a[i] + b[i];
    //            end
    //        end
    //        assign y[i] = r[i];
    //    end
    //endgenerate

    //genvar i;
    //generate
    //    for (i = 0; i < N; i = i + 1) begin
    //        assign y[i] = a[i] + b [i];
    //    end
    //endgenerate
endmodule
