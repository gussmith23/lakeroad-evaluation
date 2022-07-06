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

    logic [W-1:0] a_r [N-1:0];
    logic [W-1:0] b_r [N-1:0];
    logic [W-1:0] r [N-1:0];
    logic [W-1:0] s [N-1:0];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin

            always_ff @(posedge clock) begin
                if (reset) begin
                    a_r[i] <= 0;
                end else begin
                    a_r[i] <= a[i];
                end
            end

            always_ff @(posedge clock) begin
                if (reset) begin
                    b_r[i] <= 0;
                end else begin
                    b_r[i] <= b[i];
                end
            end

            assign s[i] = a_r[i] + b_r[i];

            always_ff @(posedge clock) begin
                if (reset) begin
                    r[i] <= 0;
                end else begin
                    r[i] <= s[i];
                end
            end

            assign y[i] = r[i];
        end
    endgenerate
endmodule
