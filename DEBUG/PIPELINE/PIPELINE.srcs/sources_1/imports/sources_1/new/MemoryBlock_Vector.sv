`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2022 19:07:30
// Design Name: 
// Module Name: MemoryBlock_Vector
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


module MemoryBlock_Vector
#( 
    parameter NINPUTS = 1024
)
(
        input logic clk,
        input logic reset , 
        input logic WriteFlag,
        input logic [$clog2(NINPUTS)- 1:0]countRegister,
        input logic [7:0]data,
        output logic [7:0] stack_data [NINPUTS]
    );

    logic [7:0] stack_data_AUX [NINPUTS]; 

    
    always_ff @(posedge clk) begin
        for ( int  i =  0 ;  i<= NINPUTS - 1 ; i = i + 1) begin 
                if(reset)
                    stack_data[i] <= 'd0 ; 
                else begin 
                    stack_data[i] <= stack_data_AUX[i] ;
                end
        end
    end

    always_comb begin
        for (int i = 0 ; i <= NINPUTS -1 ; i = i + 1) begin
                stack_data_AUX[i] = stack_data[i] ;  
        end

        if(WriteFlag)
            stack_data_AUX[countRegister] = data ; 
    end

endmodule
