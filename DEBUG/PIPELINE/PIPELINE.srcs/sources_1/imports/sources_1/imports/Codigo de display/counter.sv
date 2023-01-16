`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2022 07:40:39
// Design Name: 
// Module Name: counter
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


module counter #(parameter N=3)(
    input logic clk, reset, flag_op,
    output logic [N-1:0] count
    );

    logic [N-1:0]count_AUX ; 
    
    always_ff @(posedge clk) begin
        if(reset)
            count <= 'd0;
        else
            count <= count_AUX;
    end

     always_comb begin
        if(~flag_op)
            count_AUX = 'd10 ; //caso para que se apaguen los dsipaly
        else begin
            if(count >= 'd7)
                count_AUX= 'd0 ;
            else
                count_AUX = count + 'd1 ; 
        end


     end
    
    
endmodule
