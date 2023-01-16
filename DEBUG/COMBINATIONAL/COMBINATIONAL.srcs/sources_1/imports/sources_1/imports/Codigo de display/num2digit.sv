`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2022 04:25:23
// Design Name: 
// Module Name: timeManager
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


module num2digit(
    input logic [31:0] number,
    output logic [3:0] digitTens, digitUnits, digitHundreds, digitThousands, digitTensThousands, digitHundredsThousands
    );
           
    assign digitUnits = number % 10; 
    assign digitTens = (number / 10) % 10;
    assign digitHundreds = (number / 100) % 10;
    assign digitThousands = (number / 1000) % 10;
    assign digitTensThousands = (number / 10000) % 10;
    assign digitHundredsThousands = (number / 100000) % 10;
endmodule