module SPI (
    MOSI,MISO,SS_n,rx_data,rx_valid,tx_data,tx_valid,clk,rst_n
);
    input MOSI,SS_n,clk,rst_n,tx_valid;
    input [7:0] tx_data;
    output reg MISO,rx_valid;
    output reg [9:0] rx_data;
    parameter IDLE=0;
    parameter CHK_CMD=1;
    parameter WRITE=2;
    parameter READ_ADD=3;
    parameter READ_DATA=4;
    reg read_adress_or_read_data;
    reg [3:0] shifting;
    reg [2:0] cs,ns; 
    reg[3:0] counter;
    reg read_data_ready;
    reg [9:0] buffer;
    reg data_captured;
    // First the ns logic
    always @(*) begin
        case(cs)
            IDLE: begin
                if (SS_n) ns=IDLE;
                else ns=CHK_CMD;    
            end
            CHK_CMD: begin
                if (SS_n) ns=IDLE;
                else if(~SS_n&&~MOSI) ns=WRITE;
                else if(~SS_n&&MOSI&&~read_adress_or_read_data) ns=READ_ADD;
                else if(~SS_n&&MOSI&&read_adress_or_read_data) ns=READ_DATA;
            end
            WRITE: begin 
                if (SS_n) ns=IDLE;
                else ns=WRITE;
            end
            READ_ADD: begin
            if(SS_n) ns=IDLE;
            else ns=READ_ADD;
            end
            READ_DATA:begin
            if (SS_n) ns=IDLE;
            else ns=READ_DATA;
            end
            default: ns=IDLE;
        endcase
    end
    //State memory 
    always @(posedge clk ) begin
        if (~rst_n) begin
        cs <= IDLE;
        end
        else 
        cs<=ns;
    end
    //Output logic
    always @(posedge clk) begin
        case(cs)
            WRITE:begin
            if (~data_captured) begin
        
            
            if (counter==4'd9) begin
                counter<=0;
                rx_data<=buffer;
                rx_valid<=1;
                buffer<=0;
                data_captured<=1;
            end    
            else begin
            counter<=counter+1;
            rx_valid<=0;
            buffer<={buffer[8:0],MOSI};
            end
            end
            else begin rx_data<=0;rx_valid<=0; end
            end
            READ_ADD:begin
            if (~data_captured) begin
        
            
            if (counter==4'd9) begin
                counter<=0;
                rx_data<=buffer;
                rx_valid<=1;
                buffer<=0;
                data_captured<=1;
                read_adress_or_read_data<=1;
            end    
            else begin
            counter<=counter+1;
            rx_valid<=0;
            buffer<={buffer[8:0],MOSI};
            end
            end
            else begin rx_data<=0;rx_valid<=0; end
            end
            READ_DATA:begin
            if (~data_captured) begin
            if (counter==4'd9) begin
                counter<=0;
                rx_data<=buffer;
                rx_valid<=1;
                buffer<=0;
                data_captured<=1;
            end    
            else begin
            counter<=counter+1;
            rx_valid<=0;
            buffer<={buffer[8:0],MOSI};
            end
            end
            else begin rx_data<=0;rx_valid<=0; end
            if (tx_valid&&read_data_ready) begin
                if (shifting==3'd8) begin
                    MISO<=0;
                    shifting<=0;
                    read_data_ready<=0;
                end
                else begin
                MISO<=tx_data[7-shifting];
                shifting<=shifting+1;
            end
            end
            end
            default:begin                
                rx_data<=0;                
                rx_valid<=0;
                MISO<=0;
                read_adress_or_read_data <= 0;
                counter<=0;
                shifting<=0;
                buffer<=0;
                data_captured<=0;
            end  
        endcase
    end
endmodule
