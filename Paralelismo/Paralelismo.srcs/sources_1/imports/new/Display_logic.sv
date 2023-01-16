`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2022 18:44:10
// Design Name: 
// Module Name: Display_logic
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


module Display_logic(
    input logic clk,
    input logic reset,
    input logic [31:0] number,
    input logic flag_display, 
    output logic [6:0]SEG, 
    output logic [7:0]AN 
    );

    logic [3:0] digitTens, digitUnits, digitHundreds, digitThousands, digitTensThousands, digitHundredsThousands ;
      logic [6:0] SSdigitTens, SSdigitUnits, SSdigitHundreds, SSdigitThousands, SSdigitTensThousands, SSdigitHundredsThousands ; //SS Seven segemnt

    num2digit  Decimal_Number_Distance(
    .number(number),
    .digitTens(digitTens),
    .digitUnits(digitUnits),
    .digitHundreds(digitHundreds),
    .digitThousands(digitThousands),
    .digitTensThousands(digitTensThousands),
    .digitHundredsThousands(digitHundredsThousands)
    );

    BCD_2_7S(
    .inputNum(digitTens),
    .sseg( SSdigitTens)
    );
    
    BCD_2_7S(
    .inputNum(digitUnits),
    .sseg(SSdigitUnits)
    );
    
    BCD_2_7S(
    .inputNum(digitHundreds),
    .sseg(SSdigitHundreds)
    );
    
    BCD_2_7S(
    .inputNum(digitThousands),
    .sseg(SSdigitThousands)
    );
    
    BCD_2_7S(
    .inputNum(digitTensThousands),
    .sseg( SSdigitTensThousands)
    );
    
    BCD_2_7S(
    .inputNum(digitHundredsThousands),
    .sseg(SSdigitHundredsThousands)
    );

    logic CLKDISPLAY ; 

    CLK_DIVIDER #(640) clkDISPLAY_OP(
        .clk(clk),
        .clkOUT(CLKDISPLAY)
    );

    logic [3:0]contador ;

    counter #(4) counterAN(
        .clk(CLKDISPLAY),
        .reset(reset),
        .flag_op(flag_display),
        .count(contador)
    );
    
    changeDisplay UUT2(
    .counter(contador),
    .display(AN)
    );
    
    seggs UniSegments(
    .disp0(SSdigitUnits),       
    .disp1(SSdigitTens),       
    .disp2(SSdigitHundreds),         
    .disp3(SSdigitThousands),       
    .disp4(SSdigitTensThousands),        
    .disp5(SSdigitHundredsThousands),         
    .disp6(7'b0000000), 
    .disp7(7'b0000000),
    .counter(contador),
    .segmentOutput(SEG)
    );
endmodule
