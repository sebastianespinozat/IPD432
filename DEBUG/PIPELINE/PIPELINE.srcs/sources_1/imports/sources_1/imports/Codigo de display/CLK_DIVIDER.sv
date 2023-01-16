`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2022 01:52:24
// Design Name: 
// Module Name: CLK_DIVIDER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLK_DIVIDER #(parameter f = 1)(
    input logic clk,
    output logic clkOUT
    );
    
    logic [63:0] count = 0;
    logic [63:0] stopCount = (35_000_000/(2*f))-1;
    
    always_ff @ (posedge clk) begin
        if(count == stopCount) begin
            count <= 0;
            clkOUT <= ~clkOUT;
        end
        else begin 
            count <= count + 1;
        end
    
    end
endmodule
