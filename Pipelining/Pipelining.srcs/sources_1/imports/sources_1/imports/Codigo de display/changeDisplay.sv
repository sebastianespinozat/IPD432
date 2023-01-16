`timescale 1ns / 1ps


module changeDisplay (
    input logic [3:0] counter,
    output logic [7:0] display
    );
   
    always_comb begin
        case(counter)
            3'b000:
                display <= ~8'b00000001;
            3'b001: 
                display <= ~8'b00000010;
            3'b010:
                display <= ~8'b00000100;
            3'b011: 
                display <= ~8'b00001000;
            3'b100:
                display <= ~8'b00010000;
            3'b101: 
                display <= ~8'b00100000;
            3'b110: 
                display <= ~8'b01000000;
            3'b111:
                display <= ~8'b10000000;
            default: 
                display <= ~8'b00000000;
        endcase
        
        
    end
    
    
endmodule
