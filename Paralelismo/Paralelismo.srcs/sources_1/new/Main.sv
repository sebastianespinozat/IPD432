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
    output logic [6:0]SEG,
    output logic [7:0]AN
    );

logic reset ;
assign reset = ~CPU_RESETN ; 
logic [7:0] rx_data , tx_data ;
logic rx_ready , tx_busy , tx_start ;
logic CLK35MHZ; 
logic locked ; 


clk_wiz_0 inst
  (
  // Clock out ports  
  .clk_out1(CLK35MHZ),
  // Status and control signals               
  .reset(reset), 
  .locked(locked),
 // Clock in ports
  .clk_in1(CLK100MHZ)
  );

//UART de 115200 baud , con clk de 10MHZ , 8bit datos , un bit de start , sin paridad.
uart_basic #(.CLK_FREQUENCY(35_000_000))UART(
    .clk(CLK35MHZ),
    .reset(reset),
    .rx(UART_TXD_IN),
    .rx_data(rx_data),
    .rx_ready(rx_ready),
    .tx(UART_TXD),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_busy(tx_busy));


 localparam NINPUTS = 1024 ;

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
    .clk(CLK35MHZ),
	.reset(reset),
	.rx_data(rx_data),
	.rx_ready(rx_ready),
    .OP_BUSY(OP_BUSY),
    .Operacion(Operacion),
    .N_Element_to_transmit(N_Element_to_transmit),
    .countRegister_A(countRegister_A),
    .countRegister_B(countRegister_B),
    .data_in_A(data_in_A),
    .data_in_B(data_in_B),
    .WriteFlag_A(WriteFlag_A), 
    .WriteFlag_B(WriteFlag_B)
);

Command_Decoder #(NINPUTS)Command_Unit(
    .clk(CLK35MHZ), 
    .reset(reset),
    .Operacion(Operacion), 
    .Number_Element_MEM(N_Element_to_transmit),
    .stack_data_A(stack_data_A),
    .stack_data_B(stack_data_B),
    .tx_busy(tx_busy),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .procesing_busy(OP_BUSY), 
    .SEG(SEG),
    .AN(AN) 
     );

    MemoryBlock_Vector #(NINPUTS) Mem_A (
    .clk(CLK35MHZ),
    .reset(reset) , 
    .WriteFlag(WriteFlag_A),
    .countRegister(countRegister_A),
    .data(data_in_A),
    .stack_data(stack_data_A)
);

MemoryBlock_Vector #(NINPUTS) Mem_B (
    .clk(CLK35MHZ),
    .reset(reset) , 
    .WriteFlag(WriteFlag_B),
    .countRegister(countRegister_B),
    .data(data_in_B),
    .stack_data(stack_data_B)
);


endmodule
