`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2022 19:33:11
// Design Name: 
// Module Name: SIM_add_tree
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


module SIM_add_tree(

    );

    localparam NINPUTS = 8 ;
    localparam N_bit_result = NINPUTS + $clog2(NINPUTS);
    // localparam N_layer = $clog2(NINPUTS) ; 
    // logic clk ;
    logic [7:0] stack_A[NINPUTS] ;
    logic [7:0] stack_B [NINPUTS] ; 

    logic [N_bit_result-1 : 0 ]sum[2*NINPUTS-1] ; 

    adder_tree #(NINPUTS)add(
    .stack_data_A(stack_A),
    .stack_data_B(stack_B),
    .sum(sum)
    );

    // always #1 clk =  ~clk ;

    int count ; 
    initial begin


    for(int i=0 ; i <= NINPUTS -1 ; i = i +1 ) begin 
        stack_A[i] = 0 ;
        stack_B[i] = 0 ;
    end

    #6
    count = 1  ;
    for(int i=0 ; i <= NINPUTS -1 ; i = i +1 ) begin 
        stack_A[i] = count ;
        stack_B[i] = 2*count ;
        count = count + 1 ; 
    end

    end
endmodule
