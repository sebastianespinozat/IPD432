`timescale 1ns / 1ps

module seggs(
    input logic [6:0] disp0, disp1, disp2, disp3, disp4, disp5, disp6, disp7,
    input logic [3:0] counter,
    output logic [6:0] segmentOutput
    );
    
    always_comb begin
        case(counter)
            3'b000:
                segmentOutput = ~disp0;
            3'b001: 
                segmentOutput = ~disp1;
            3'b010:
                segmentOutput = ~disp2;
            3'b011: 
                segmentOutput = ~disp3;
            3'b100:
                segmentOutput = ~disp4;
            3'b101: 
                segmentOutput = ~disp5;
            3'b110: 
                segmentOutput = ~disp6;
            3'b111:
                segmentOutput = ~disp7;
            default: 
                segmentOutput = ~8'b0000000;
        endcase  
    end
endmodule
