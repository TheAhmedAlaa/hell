module wrapper (clk, rst_n, MOSI, MISO, SS_n);
    input  clk, rst_n, MOSI, SS_n;
    output MISO;
    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;
    SPI MASTERSLAVEE (MOSI,MISO,SS_n,rx_data,rx_valid,tx_data,tx_valid,clk,rst_n);
    ram RAM (rx_data,rx_valid,tx_data,tx_valid,clk,rst_n);
endmodule
