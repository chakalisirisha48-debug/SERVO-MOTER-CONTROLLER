module servo_controller #(
    parameter CLK_FREQ = 1_000_000
)(
    input  wire       clk,
    input  wire       reset,

    input  wire [1:0] angle,

    output reg        servo_pwm
);

    // 20 ms period at 1 MHz clock
    localparam integer PERIOD_COUNT = CLK_FREQ / 50;

    // Pulse widths
    localparam integer PULSE_0   = CLK_FREQ / 1000;       // 1 ms
    localparam integer PULSE_90  = (CLK_FREQ * 3) / 2000; // 1.5 ms
    localparam integer PULSE_180 = CLK_FREQ / 500;        // 2 ms

    reg [31:0] counter;

    reg [31:0] pulse_width;

    // Select pulse width according to angle
    always @(*) begin

        case (angle)

            2'b00:
                pulse_width = PULSE_0;

            2'b01:
                pulse_width = PULSE_90;

            2'b10:
                pulse_width = PULSE_180;

            default:
                pulse_width = PULSE_0;

        endcase

    end

    // PWM generation
    always @(posedge clk or posedge reset) begin

        if (reset) begin

            counter   <= 32'd0;
            servo_pwm <= 1'b0;

        end

        else begin

            if (counter >= PERIOD_COUNT - 1) begin

                counter <= 32'd0;

            end

            else begin

                counter <= counter + 1'b1;

            end

            // Generate PWM pulse
            if (counter < pulse_width)
                servo_pwm <= 1'b1;
            else
                servo_pwm <= 1'b0;

        end

    end

endmodule