`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2022 20:01:44
// Design Name: 
// Module Name: adder_tree
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


module adder_tree 
#(
    parameter NINPUTS = 1024, // cambiar  a 1204 despues de probar 
    parameter WIDTHIN = 8,
    localparam N_bit_result = WIDTHIN + $clog2(NINPUTS),
    localparam N_layer = $clog2(NINPUTS)
)(
    input logic clk,
    input logic reset,
    input logic  [7:0]stack_data_A [NINPUTS],
    input logic[7:0]stack_data_B[NINPUTS],
    output logic [N_bit_result-1: 0] sum_pipeline  [2*NINPUTS -1 ]
    
);

logic [N_bit_result-1: 0] sum  [2*NINPUTS -1 ] ; 
localparam NumeberSum = 2*NINPUTS -1 ; 

//FULL PIPELINE IN ALL SUM :
always_ff @(posedge clk) begin
        for (int  i=0 ; i <= NumeberSum -1   ; i= i + 1) begin
             if(reset)
                sum_pipeline[i] <=  'd0 ;
            else
                
                    sum_pipeline[i] <= sum[i]  ; 
                end
       
    end
   
int  count ; 
int desfase , LenSave ; 
int StopVertical ;
always_comb begin
    LenSave = 0 ; 
    desfase = 0 ;
    for (int k=0 ; k<= NINPUTS-1 ; k=k+1 ) begin
        sum[k] = stack_data_A[k] + stack_data_B[k] ; 
    end
    for (int  i=0 ; i <= N_layer-1  ; i= i + 1) begin
        count = 0 ;
        
       if(i!=0)
            desfase = desfase +  $ceil(NINPUTS/(2**(i-1)));
        else 
            desfase = 0 ;

        if(i != N_layer-1) begin 
            LenSave = LenSave + $ceil(NINPUTS/(2**i)) ; 
            if($ceil(NINPUTS/(2**i))== 2 )
                StopVertical = $ceil(NINPUTS/(2**i)) ;
            else
                StopVertical = $ceil(NINPUTS/2**i) -1 ;
        end else begin
            LenSave = 2*NINPUTS -2  ; 
            StopVertical =  0 ; 
        end
        for(int j=0  ; j <= StopVertical ; j = j + 2 ) begin 
                            sum[count + LenSave ] = sum_pipeline[j + desfase ] + sum_pipeline[j + 1 + desfase] ; 
                            count = count + 1 ; 
        end
         
        
end

end



    
endmodule
