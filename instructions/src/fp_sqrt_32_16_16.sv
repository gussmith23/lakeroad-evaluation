module fp_sqrt_32_16_16 #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             go,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out,
    output logic             done
);
    localparam ITERATIONS = WIDTH+FRAC_WIDTH >> 1;
    logic [$clog2(ITERATIONS)-1:0] idx;

    logic [WIDTH-1:0] x, x_next;
    logic [WIDTH-1:0] quotient, quotient_next;
    logic [WIDTH+1:0] acc, acc_next;
    logic [WIDTH+1:0] tmp;
    logic start, running, finished;

    assign start = go && !running;
    /* verilator lint_off WIDTH */
    assign finished = (ITERATIONS - 1) == idx && running;

    always_ff @(posedge clk) begin
      if (reset || finished)
        running <= 0;
      else if (start)
        running <= 1;
      else
        running <= running;
    end

    always_ff @(posedge clk) begin
      if (running)
        idx <= idx + 1;
      else
        idx <= 0;
    end

    always_comb begin
      tmp = acc - {quotient, 2'b01};
      if (tmp[WIDTH+1]) begin
        // tmp is negative.
        {acc_next, x_next} = {acc[WIDTH-1:0], x, 2'b0};
        // Append a 0 to the result.
        quotient_next = quotient << 1;
      end else begin
        // tmp is positive.
        {acc_next, x_next} = {tmp[WIDTH-1:0], x, 2'b0};
        // Append a 1 to the result.
        quotient_next = {quotient[WIDTH-2:0], 1'b1};
      end
    end

    always_ff @(posedge clk) begin
      if (start) begin
        quotient <= 0;
        {acc, x} <= {{WIDTH{1'b0}}, in, 2'b0};
      end else begin
        x <= x_next;
        acc <= acc_next;
        quotient <= quotient_next;
      end
    end

    always_ff @(posedge clk) begin
      if (finished) begin
        done <= 1;
        out <= quotient_next;
      end else if (reset) begin
        done <= 0;
        out <= 0;
      end else begin
        done <= 0;
        out <= out;
      end
    end

endmodule