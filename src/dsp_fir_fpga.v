module dsp_fir_fpga(
    input  wire [7:0] DATA_IN,
    output wire [7:0] DATA_OUT,
    input  wire CLK,
    input  wire MODE,
    input  wire RST_N,
    output wire CLK_ADC,
    output wire CLK_DAC,
    // Debug wires
    output wire [17:0] LEDR,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5,
    output wire [6:0] HEX6,
    output wire [6:0] HEX7,
    input  wire [3:0] KEY
);
    assign LEDR[7:0] = DATA_IN; // For debugging: show input on LEDs
    assign LEDR[15:8] = DATA_OUT; // For debugging: show output on LEDs
    assign LEDR[16] = MODE; // For debugging: show mode on LED
    assign LEDR[17] = RST_N; // For debugging: show reset state
    
    // if either one is low, trigger reset
    wire module_rst_n = RST_N & KEY[0];
    // wire module_rst_n = RST_N;

    // DEBUG WIRES ONLY TO VIEW 4 OF THE COEFFICIENTS
    wire [7:0] fir_coeff_0, fir_coeff_1, fir_coeff_2, fir_coeff_3;

    dsp_fir m1 (
        .data_in(DATA_IN),
        .data_out(DATA_OUT),
        .clk_adc(CLK_ADC),
        .clk_dac(CLK_DAC),
        .mode(MODE),
        .rst_n(module_rst_n),
        .clk(CLK),
        // .clk(KEY[1]), // For manual debug
        // DEBUG ONLY
        .fir_coeff_0(fir_coeff_0),
        .fir_coeff_1(fir_coeff_1),
        .fir_coeff_2(fir_coeff_2),
        .fir_coeff_3(fir_coeff_3)
    );

    binary_to_7seg b1 (
        .bcd(fir_coeff_0[3:0]),
        .display(HEX0)
    );
    binary_to_7seg b2 (
        .bcd(fir_coeff_0[7:4]),
        .display(HEX1)
    );

    binary_to_7seg b3 (
        .bcd(fir_coeff_1[3:0]),
        .display(HEX2)
    );
    binary_to_7seg b4 (
        .bcd(fir_coeff_1[7:4]),
        .display(HEX3)
    );

    binary_to_7seg b5 (
        .bcd(fir_coeff_2[3:0]),
        .display(HEX4)
    );
    binary_to_7seg b6 (
        .bcd(fir_coeff_2[7:4]),
        .display(HEX5)
    );

    binary_to_7seg b7 (
        .bcd(fir_coeff_3[3:0]),
        .display(HEX6)
    );
    binary_to_7seg b8 (
        .bcd(fir_coeff_3[7:4]),
        .display(HEX7)
    );

endmodule

module binary_to_7seg(
    input [3:0] bcd,
    output reg [6:0] display
);

    always @(*) begin
        case(bcd)
            4'h0 : display = 7'b1000000;            
            4'h1 : display = 7'b1111001;
            4'h2 : display = 7'b0100100;
            4'h3 : display = 7'b0110000;
            4'h4 : display = 7'b0011001;
            4'h5 : display = 7'b0010010;
            4'h6 : display = 7'b0000010;
            4'h7 : display = 7'b1111000;
            4'h8 : display = 7'b0000000;
            4'h9 : display = 7'b0010000;
            4'hA : display = 7'b0001000;
            4'hB : display = 7'b0000011;
            4'hC : display = 7'b1000110;
            4'hD : display = 7'b0100001;
            4'hE : display = 7'b0000110;
            4'hF : display = 7'b0001110;
            default: display = 7'b1111111; // optional safety
        endcase
    end

endmodule
