`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2022 15:18:44
// Design Name: 
// Module Name: ALU
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


module ALU #(
    parameter NINPUTS = 8 ,
    parameter WIDTHIN = 8,
    localparam N_bit_result = WIDTHIN + $clog2(NINPUTS),
    localparam N_layer = $clog2(NINPUTS)
)
(
    //input logic clk ,
    input logic [WIDTHIN-1:0] stack_data_A [NINPUTS],
    input logic [WIDTHIN-1:0] stack_data_B[NINPUTS],
    input logic [$clog2(NINPUTS)-1 :0]countRegister , 
    // input logic [31:0] Result_Distance,  
    input logic [3:0] Operation,
    // input logic enable,
    output logic [31:0]Result 
    );

    logic [N_bit_result-1 : 0]sum [2*NINPUTS -1] ;

    logic [WIDTHIN-1:0] Op1_vect [NINPUTS] ;
    logic [WIDTHIN-1:0] Op2_vect[NINPUTS] ; 


 
    always_comb begin
        Result = 'd0 ; 
        for (int i=0 ; i <= NINPUTS -1 ; i = i +1) begin 
                Op1_vect[i] = stack_data_A[i] ; 
                Op2_vect[i] = stack_data_B[i] ;     
        end

        // if(enable)  begin
            case(Operation) 
            'd1:    begin   // suma
                Result = sum[countRegister] ;
            end
            'd2: begin      // avg
                Result = sum[countRegister] >> 1;
            end
        
            // 'd3: begin      // euclidean
            //      mult = (Op1_vect > Op2_vect)? (Op1_vect - Op2_vect): (Op2_vect - Op1_vect);

            //     Result = Result_Distance + Multi_comp_out;
            // end

            'd4: begin      // manhattan
                for (int i=0 ; i <= NINPUTS -1 ; i = i +1) begin 
                        if (stack_data_A[i] > stack_data_B[i])
                             Op2_vect[i] = - stack_data_B[i] ;  
                        else
                            Op1_vect[i] = - stack_data_A[i] ; 

                end

                Result = sum[2*NINPUTS -2] ;
                // Result =  (Op1_vect > Op2_vect)? (Result_Distance +(Op1_vect - Op2_vect)): (Result_Distance +(Op2_vect - Op1_vect));
            end

        endcase
        // end  
    
    end

// mult_gen_Vector_Comp MULT_COMP(
//     .CLK(clk),
//     .A(mult),
//     .B(mult),
//     .P(Multi_comp_out)
// ) ;


adder_tree #(NINPUTS)add(
    .stack_data_A(Op1_vect),
    .stack_data_B(Op2_vect),
    .sum(sum)
    );





endmodule

 
