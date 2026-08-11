`timescale 1us/1ns

module servo_controller_tb;

    reg clk;
    reg reset;

    reg [1:0] angle;

    wire servo_pwm;

    // Instantiate Servo Controller
    servo_controller #(
        .CLK_FREQ(1_000_000)
    ) uut (
        .clk(clk),
        .reset(reset),
        .angle(angle),
        .servo_pwm(servo_pwm)
    );

    // 1 MHz clock
    always #0.5 clk = ~clk;

    // Measure HIGH pulse width
    real start_time;
    real pulse_width;

    always @(posedge servo_pwm) begin

        start_time = $realtime;

    end

    always @(negedge servo_pwm) begin

        pulse_width = $realtime - start_time;

        $display(
            "Angle = %0d, PWM HIGH Time = %0.3f us",
            angle,
            pulse_width
        );

    end

    initial begin

        clk = 0;
        reset = 1;
        angle = 2'b00;

        // Reset
        #10;

        reset = 0;

        $display("--------------------------------");
        $display("Servo Motor Controller Test");
        $display("--------------------------------");

        // --------------------------------
        // Test 0 degrees
        // --------------------------------

        angle = 2'b00;

        $display("Testing Servo Position = 0 degrees");

        #40000;

        // --------------------------------
        // Test 90 degrees
        // --------------------------------

        angle = 2'b01;

        $display("Testing Servo Position = 90 degrees");

        #40000;

        // --------------------------------
        // Test 180 degrees
        // --------------------------------

        angle = 2'b10;

        $display("Testing Servo Position = 180 degrees");

        #40000;

        // Finish
        $display("--------------------------------");
        $display("Servo Controller Simulation Complete");
        $display("--------------------------------");

        $finish;

    end

    // Generate waveform
    initial begin

        $dumpfile("servo_controller.vcd");
        $dumpvars(0, servo_controller_tb);

    end

endmodule