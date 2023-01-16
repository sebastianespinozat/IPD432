`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2022 16:22:52
// Design Name: 
// Module Name: UART_RX_LOGIC
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


module UART_RX_LOGIC
#(
    parameter NINPUTS = 1024
)
(
    input logic clk,
	input logic  reset,
	input logic [7:0] rx_data,
	input logic rx_ready,
    input logic OP_BUSY,
    // output logic [7:0] stack_data_A_AUX [NINPUTS], 
    //input logic [7:0] stack_data_A [NINPUTS],
    // output logic [7:0] stack_data_B_AUX [NINPUTS], 
    //input logic [7:0] stack_data_B [NINPUTS],
    output logic [3:0]Operacion,
    output logic [9:0] N_Element_to_transmit,
    output logic [$clog2(NINPUTS)- 1:0]countRegister_A,
    output logic [$clog2(NINPUTS)- 1:0]countRegister_B,
    output logic [7:0]data_in_A ,
    output logic [7:0]data_in_B ,
    output logic WriteFlag_A, 
    output logic WriteFlag_B
//     output logic [2:0] CountDebug ,
//     output logic flag_debug
    );

 
    // logic [7:0] stack_data_AUX [8] ;
    logic [9:0] N_Element_to_transmit_AUX; 
    logic [7:0]N_LSB_ELEMENT , N_LSB_ELEMENT_AUX ; 
    logic [1:0]N_MSB_ELEMENT  , N_MSB_ELEMENT_AUX  ; 

    assign N_Element_to_transmit_AUX = {N_MSB_ELEMENT , N_LSB_ELEMENT} ;

    logic START_DECODER , START_DECODER_AUX ; 
    logic[1:0] MEM_BLOCK_CHOOSE , MEM_BLOCK_CHOOSE_AUX;
    logic flag_counterRegister , flag_counterRegister_AUX ; 
    logic flag_delay_1_cicle , flag_delay_1_cicle_AUX ;
    logic WriteFlag_A_AUX , WriteFlag_B_AUX ; 
    logic [$clog2(NINPUTS)- 1:0]countRegister_A_AUX , countRegister_B_AUX ;
    logic [7:0] data_in_A_AUX ,  data_in_B_AUX ; 
    // logic [7:0] stack_data_AUX [8] ;

    logic [3:0]Operacion_AUX ;

    enum logic [2:0] {WAIT_FUNCTION , CHOOSE_INSTRUCTION, N_LSB_VECT , N_MSB_VECT , WORD_OF_FF , COMAND_DECODER} state , next_state ;
    
//,STORE_iN_FF_A , STORE_iN_FF_B
    always_ff @(posedge clk) begin
        if(reset) begin  

            N_LSB_ELEMENT <= 'd0 ; 
            N_MSB_ELEMENT <= 'd0 ; 

            N_Element_to_transmit <= 'd0 ;  

            flag_delay_1_cicle <= 'd0 ;
            flag_counterRegister <= 'd0 ;
            countRegister_A <= 'd0 ; 
            countRegister_B <= 'd0 ; 
            Operacion <= 'd0 ;
            data_in_A <= 'd0 ;
            data_in_B <= 'd0 ;   
            MEM_BLOCK_CHOOSE <= 'd0 ; 
            START_DECODER <= 'd0 ; 
            WriteFlag_A <= 'd0 ;
            WriteFlag_B <= 'd0 ; 

        end else  begin
            
            N_LSB_ELEMENT <= N_LSB_ELEMENT_AUX ; 
            N_MSB_ELEMENT  <= N_MSB_ELEMENT_AUX ; 

            N_Element_to_transmit <= N_Element_to_transmit_AUX ;  
            Operacion <= Operacion_AUX ; 

            data_in_A <= data_in_A_AUX ;
            data_in_B <= data_in_B_AUX ;  

            flag_delay_1_cicle <= flag_delay_1_cicle_AUX ;
            flag_counterRegister <= flag_counterRegister_AUX ;
            countRegister_A <= countRegister_A_AUX ; 
            countRegister_B <= countRegister_B_AUX ;
//             CountDebug <= countRegister_A_AUX ; 
//             flag_debug <= flag_delay_1_cicle_AUX ;

            MEM_BLOCK_CHOOSE <= MEM_BLOCK_CHOOSE_AUX ; 
            START_DECODER <= START_DECODER_AUX ;
            WriteFlag_A <= WriteFlag_A_AUX ;
            WriteFlag_B <= WriteFlag_B_AUX ;

            // stack_data[countRegister] <= data_in_AUX ;

        end    
    end
    
    always_comb begin

        N_LSB_ELEMENT_AUX = N_LSB_ELEMENT ; 
        N_MSB_ELEMENT_AUX = N_MSB_ELEMENT ;


        Operacion_AUX = Operacion ; 

        next_state         =  WAIT_FUNCTION ; 

        data_in_A_AUX = data_in_A ;
        data_in_B_AUX = data_in_B ;  
        flag_counterRegister_AUX = flag_counterRegister ;
        flag_delay_1_cicle_AUX = 'd0 ;
        countRegister_A_AUX = countRegister_A ;
        countRegister_B_AUX = countRegister_B ;

        MEM_BLOCK_CHOOSE_AUX = MEM_BLOCK_CHOOSE ; 
        START_DECODER_AUX = START_DECODER ;
        WriteFlag_A_AUX = 'd0 ;
        WriteFlag_B_AUX = 'd0 ;  

        // for (int i = 0  ; i <= NINPUTS - 1 ; i = i + 1 ) begin 
        //                 stack_data_A_AUX[i] = stack_data_A[i] ;
        //                 stack_data_B_AUX[i] = stack_data_B[i] ;
        // end
        
        case(state)
        WAIT_FUNCTION: begin
            Operacion_AUX = 'd0 ;
            if(~OP_BUSY) begin 
                data_in_A_AUX = 'd0 ; 
                data_in_B_AUX = 'd0 ;
                flag_counterRegister_AUX = 'd0 ;
                countRegister_A_AUX = 'd0 ; 
                countRegister_B_AUX = 'd0 ;
                MEM_BLOCK_CHOOSE_AUX = 'd0 ; 
                START_DECODER_AUX = 'd0 ;  
                if(rx_ready) next_state = CHOOSE_INSTRUCTION ; 
             end
        end

        CHOOSE_INSTRUCTION: begin  
            case(rx_data)
            'd1:begin 
                 next_state = N_LSB_VECT ;
                 MEM_BLOCK_CHOOSE_AUX = 'd1 ;
            end
            'd2:begin
                 next_state = N_LSB_VECT ;
                 MEM_BLOCK_CHOOSE_AUX = 'd2 ;  
            end
           'd3: next_state = COMAND_DECODER ; 

            endcase
        end

        N_LSB_VECT: begin 
            if(rx_ready) begin 
                N_LSB_ELEMENT_AUX = rx_data ; 
                next_state = N_MSB_VECT ;
            end else
                next_state = N_LSB_VECT ; 
        end

        N_MSB_VECT: begin
            if(rx_ready) begin 
                N_MSB_ELEMENT_AUX = rx_data[1:0] ; 
                next_state = WORD_OF_FF ; 
            end else
                next_state = N_MSB_VECT ; 

        end

        WORD_OF_FF: begin 
            if(rx_ready) begin 
                 
                if (MEM_BLOCK_CHOOSE == 'd1) begin
                    //  next_state = STORE_iN_FF_A ;
                    next_state = WORD_OF_FF ; 
//                    next_state = DELAY_STATE;
                     data_in_A_AUX  = rx_data ;
                     if (flag_counterRegister)
                            countRegister_A_AUX = countRegister_A + 'd1 ; 
                    flag_counterRegister_AUX = 'd1 ;
                    WriteFlag_A_AUX = 'd1 ;
                end
                if (MEM_BLOCK_CHOOSE == 'd2) begin 
                    next_state = WORD_OF_FF ;
//                    next_state = DELAY_STATE;
                    //  next_state = STORE_iN_FF_B ;
                     data_in_B_AUX  = rx_data ;
                     if (flag_counterRegister)
                            countRegister_B_AUX = countRegister_B + 'd1 ; 
                    flag_counterRegister_AUX = 'd1 ;
                     WriteFlag_B_AUX = 'd1 ;
                end
            end else if (countRegister_A == N_Element_to_transmit || countRegister_B == N_Element_to_transmit)
                next_state = WAIT_FUNCTION ;
            else
                next_state = WORD_OF_FF ;


        end

//        DELAY_STATE:    begin
//            next_state = WORD_OF_FF;
//        end

        // STORE_iN_FF_A: begin 

        //         stack_data_A_AUX[countRegister_A] = data_in_A ; 
        //         next_state = WORD_OF_FF ;

        // end
        //   STORE_iN_FF_B: begin 
        //         stack_data_B_AUX[countRegister_B] = data_in_B ;  // se hacen 2 para redcuir los LUT 
        //         next_state = WORD_OF_FF ;
        // end


         COMAND_DECODER: begin
            if(~START_DECODER) begin
                if(rx_ready) begin
                    Operacion_AUX = rx_data[3:0] ; 
                    START_DECODER_AUX = 'd1 ; 
                end
                next_state = COMAND_DECODER ; 
            end else begin
                if(~OP_BUSY)
                    next_state = COMAND_DECODER ;
                else
                    next_state = WAIT_FUNCTION ; 
         end
         end

        endcase
    end

    always_ff @(posedge clk) begin
        if(reset) begin 
            state <= WAIT_FUNCTION ; 
        end else
            state <= next_state ;  
    end

 




endmodule
