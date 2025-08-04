module ram(
    din,rx_valid,dout,tx_valid,clk,rst_n
);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input [9:0] din;
input clk,rx_valid,rst_n;
output reg [7:0]dout;
output reg tx_valid;
reg [7:0] read_address,write_address;
reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
always @(posedge clk) begin
    if (~rst_n) begin
        dout<=0;
        tx_valid<=0;
    end
    else begin
        if (rx_valid) begin
            if (din[9:8]==2'b00) begin
                write_address<=din[7:0];
            end
            else if (din[9:8]==2'b01) begin
                mem[write_address]<=din[7:0];
            end
            else if(din[9:8]==2'b10) begin
                read_address<=din[7:0];
            end
            else if (din[9:8]==2'b11) begin
                tx_valid<=1;
                dout<=mem[read_address];
            end
        end
        else begin
            tx_valid<=0;
        end
    end
end
endmodule
