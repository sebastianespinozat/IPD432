`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2022 16:44:14
// Design Name: 
// Module Name: Main
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


module Main(
    input logic CLK100MHZ,
    input logic UART_TXD_IN,
    input logic CPU_RESETN,
    output logic UART_TXD,
    output logic [6:0] C,
    output logic [7:0] AN
    );

logic reset ;
assign reset = ~CPU_RESETN ; 
logic [7:0] rx_data , tx_data ;
logic rx_ready , tx_busy , tx_start ;
logic CLK50MHZ; 
logic locked ; 
// logic CLK75MHZ ; 

// CLK_DIVIDER #(50000000) clk50mhz(
//         .clk(CLK100MHZ),
//         .clkOUT(CLK50MHZ)
//     );

//clk_wiz_0 inst
//  (
//  // Clock out ports  
//  .clk_out1(CLK50MHZ),
//  // Status and control signals               
//  .reset(reset), 
//  .locked(locked),
// // Clock in ports
//  .clk_in1(CLK100MHZ)
//  );

clk_wiz_0 clk50
   (
    // Clock out ports
    .clk_out1(CLK50MHZ),     // output clk_out1
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(CLK100MHZ));      // input clk_in1

//assign CLK50MHZ = CLK100MHZ;

//UART de 115200 baud , con clk de 10MHZ , 8bit datos , un bit de start , sin paridad.
uart_basic #(.CLK_FREQUENCY(100_000_000))UART(
    .clk(CLK50MHZ),
    .reset(reset),
    .rx(UART_TXD_IN),
    .rx_data(rx_data),
    .rx_ready(rx_ready),
    .tx(UART_TXD),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_busy(tx_busy));


 localparam NINPUTS = 8 ;

logic [7:0] stack_data_A [NINPUTS] ;  
//logic [7:0] stack_data_A_AUX [NINPUTS] ;
logic [7:0] stack_data_B [NINPUTS] ;  
//logic [7:0] stack_data_B_AUX [NINPUTS] ;
logic [9:0]N_Element_to_transmit ; 
logic OP_BUSY ; 
logic [3:0]Operacion ; 
// logic [2:0]CountDebug ;
// logic  flag_debug ; 
logic [$clog2(NINPUTS)- 1:0]countRegister_A , countRegister_B ;
logic [7:0]data_in_A , data_in_B ;
logic WriteFlag_A , WriteFlag_B ; 


UART_RX_LOGIC #(NINPUTS)UART_RX (
    .clk(CLK50MHZ),
	.reset(reset),
	.rx_data(rx_data),
	.rx_ready(rx_ready),
    .OP_BUSY(OP_BUSY),
    // .stack_data_A_AUX(stack_data_A_AUX),
    //.stack_data_A(stack_data_A),
    // .stack_data_B_AUX(stack_data_B_AUX),
    //.stack_data_B(stack_data_B),
    .Operacion(Operacion),
    .N_Element_to_transmit(N_Element_to_transmit),
    .countRegister_A(countRegister_A),
    .countRegister_B(countRegister_B),
    .data_in_A(data_in_A),
    .data_in_B(data_in_B),
    .WriteFlag_A(WriteFlag_A), 
    .WriteFlag_B(WriteFlag_B)
//     .CountDebug(CountDebug),
//     .flag_debug(flag_debug)
);

localparam N_bit_result = 8 + $clog2(NINPUTS);
localparam N_layer = $clog2(NINPUTS) ;

logic [N_bit_result-1:0] OperacionDEBUG [2*NINPUTS-1] ; 
logic [N_bit_result-1:0] sumDEBUG ; 
logic flag_debug ; 
logic [$clog2(N_layer+1)-1:0]count_debug ; 

Command_Decoder #(NINPUTS)Command_Unit(
    .clk(CLK50MHZ), 
    .reset(reset),
    .Operacion(Operacion), 
    .Number_Element_MEM(N_Element_to_transmit),
    .stack_data_A(stack_data_A),
    .stack_data_B(stack_data_B),
    .tx_busy(tx_busy),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .procesing_busy(OP_BUSY), 
    .SEG(C),
    .AN(AN),
    .OperacionDEBUG(OperacionDEBUG) ,
    .sumDEBUG(sumDEBUG),
    .flag_debug(flag_debug),
    .count_debug(count_debug) 
     );

    MemoryBlock_Vector #(NINPUTS) Mem_A (
    .clk(CLK50MHZ),
    .reset(reset) , 
    .WriteFlag(WriteFlag_A),
    .countRegister(countRegister_A),
    .data(data_in_A),
    .stack_data(stack_data_A)
);

MemoryBlock_Vector #(NINPUTS) Mem_B (
    .clk(CLK50MHZ),
    .reset(reset) , 
    .WriteFlag(WriteFlag_B),
    .countRegister(countRegister_B),
    .data(data_in_B),
    .stack_data(stack_data_B)
);

ila_0 your_instance_name (
	.clk(CLK50MHZ), // input wire clk


	.probe0(flag_debug), // input wire [0:0]  probe0  
	.probe1(OperacionDEBUG[0][3:0]), // input wire [7:0]  probe1 
	.probe2(OperacionDEBUG[8][3:0]), // input wire [7:0]  probe2 
    .probe3(OperacionDEBUG[12][3:0]),
    .probe4(OperacionDEBUG[14][3:0]),
	.probe5(OperacionDEBUG[2*NINPUTS-2][10:0]), // input wire [10:0]  probe3 
	.probe6(count_debug[1:0])
);


endmodule
