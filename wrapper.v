module top_module (clk, rst_n, MOSI, MISO, SS_n);
    input  clk, rst_n, MOSI, SS_n;
    output MISO;

    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;

    SPI inst1 (clk, rst_n, SS_n, MOSI, tx_valid, tx_data, rx_valid, rx_data, MISO);
    RAM inst2 (clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
endmodule
