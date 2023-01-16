`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2022 17:10:59
// Design Name: 
// Module Name: Command_Decoder
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


module Command_Decoder 
#(
    parameter NINPUTS = 1024,
    parameter WIDTHIN = 8,
    localparam N_bit_result = WIDTHIN + $clog2(NINPUTS)
)
(
    input logic clk, 
    input logic reset,
    input logic [3:0]Operacion, 
    input logic [9:0]Number_Element_MEM,
    input logic [7:0]stack_data_A [NINPUTS] ,
    input logic [7:0]stack_data_B [NINPUTS] ,
    input logic tx_busy,
    output logic [7:0]tx_data,
    output logic tx_start,
    output logic procesing_busy,
    output logic [6:0]SEG,
    output logic [7:0]AN,
    output logic [N_bit_result-1:0] OperacionDEBUG [2*NINPUTS-1],
    output logic [N_bit_result-1:0]sumDEBUG ,
    output logic flag_debug 
    );
 
    logic [N_bit_result -1 : 0 ] sum[2*NINPUTS - 1] ;
    logic read_add_flag , read_add_flag_AUX ; 
    logic [1:0] CHOOSE_MEM , CHOOSE_MEM_AUX ;  
    logic [2:0] CHOOSE_OP , CHOOSE_OP_AUX ; 
    logic [3:0] Operacion_Command_decoder , Operacion_Command_decoder_AUX ; 
 
    logic flag_delay_1_cicle , flag_delay_1_cicle_AUX ; 
    logic [3:0]delay_result , delay_result_AUX ;

    logic procesing_busy_AUX ; 

    //transmicion UART tx 
    logic [7:0] tx_data_AUX ; 
    logic tx_start_AUX ; 
 
    logic flag_debug_AUX ; 
    logic flag_display, flag_display_AUX;
    logic [31:0]Result_ALU, Result_display, Result_display_AUX ;

    logic [$clog2(NINPUTS)- 1:0]countRegister , countRegister_AUX ;
    logic [2:0]countBytes, countBytes_AUX ;

    always_ff @(posedge clk) begin
        if(reset) begin 
            tx_data <= 'd0 ; 
            tx_start <= 'd0;  

            procesing_busy <= 'd0 ; 
            read_add_flag <= 'd0 ; 
          
            flag_display <= 'd0;
            flag_delay_1_cicle <= 'd0 ; 
            delay_result <= 'd0 ; 
            Result_display <= 'd0;
            
            countRegister <= 'd0 ; 
            CHOOSE_MEM <= 'd0 ;
            CHOOSE_OP <= 'd0 ;
            countBytes <= 'd0 ;
            flag_debug <= 'd0 ; 
            // Operacion_Command_decoder <= 'd0 ; 
        end else begin 

            //flag de la FSM
            read_add_flag <= read_add_flag_AUX ; 

            //uart TX 
            tx_data <= tx_data_AUX ; 
            tx_start <= tx_start_AUX ; 

            procesing_busy <= procesing_busy_AUX ;

            Result_display <= Result_display_AUX;

            flag_display <= flag_display_AUX;
            flag_delay_1_cicle <= flag_delay_1_cicle_AUX ; 
            delay_result <= delay_result_AUX ; 
            countRegister <= countRegister_AUX ; 
            CHOOSE_MEM <= CHOOSE_MEM_AUX ; 
            CHOOSE_OP <= CHOOSE_OP_AUX ; 
            countBytes <= countBytes_AUX ; 
            flag_debug <= flag_debug_AUX ; 
            // Operacion_Command_decoder <= Operacion_Command_decoder_AUX ;
            
 

        end
    end


 enum logic [2:0] {Mux_command , N_LSB_ELEM_TX , N_MSB_ELEM_TX , ReadVec, Send_Component_TX } state , next_state ; 

// , ALU_FSM , Square_delay 
always_comb begin
    next_state = Mux_command ; 
    read_add_flag_AUX = 'd0 ; 
    Result_display_AUX = Result_display;
    tx_data_AUX = 'd0 ;
    tx_start_AUX = 'd0  ; 
    
    procesing_busy_AUX = procesing_busy ; 

    flag_display_AUX = flag_display;
    flag_delay_1_cicle_AUX = 'd0 ;
    delay_result_AUX = delay_result ; 
    countRegister_AUX = countRegister ;  

    CHOOSE_MEM_AUX = CHOOSE_MEM ; 
    CHOOSE_OP_AUX = CHOOSE_OP ; 
    countBytes_AUX =  countBytes ;
    flag_debug_AUX = 'd0 ; 
    //Operacion_Command_decoder_AUX = 'd0 ; 

    case(state)

    Mux_command: begin 
         procesing_busy_AUX = 'd0 ; 
         countRegister_AUX = 'd0 ;
         CHOOSE_MEM_AUX = 'd0 ; 
         CHOOSE_OP_AUX = 'd0 ;   
         countBytes_AUX = 'd0 ;
         //Operacion_Command_decoder_AUX =  Operacion ; 
        case(Operacion)
            'd11: begin 
                next_state = N_LSB_ELEM_TX ;
                CHOOSE_MEM_AUX = 'd1 ;
                procesing_busy_AUX = 'd1 ;
                flag_display_AUX = 'd0;
                Result_display_AUX = 'd0;
             end

            'd12: begin 
                next_state = N_LSB_ELEM_TX ;
                CHOOSE_MEM_AUX = 'd2 ;
                procesing_busy_AUX = 'd1 ;
                flag_display_AUX = 'd0;
                Result_display_AUX = 'd0;
            end

            'd1: begin 
                next_state = N_LSB_ELEM_TX ;
                CHOOSE_OP_AUX = 'd1 ;
                procesing_busy_AUX = 'd1 ;
                flag_display_AUX = 'd0;
                Result_display_AUX = 'd0;
                flag_debug_AUX = 'd1 ; 
            end

            'd2: begin 
                next_state = N_LSB_ELEM_TX ;
                CHOOSE_OP_AUX = 'd2 ;
                procesing_busy_AUX = 'd1 ;
                flag_display_AUX = 'd0;
                Result_display_AUX = 'd0;
                flag_debug_AUX = 'd1 ;
            end

            'd4: begin 
                next_state = Send_Component_TX;
                CHOOSE_OP_AUX = 'd4 ;
                procesing_busy_AUX = 'd1 ;
                flag_display_AUX = 'd1;
                flag_debug_AUX = 'd1 ;
            end

         endcase
    
    end

     N_LSB_ELEM_TX: begin  
            tx_data_AUX = Number_Element_MEM[7:0] ; 
            tx_start_AUX = 'd1 ; 
            next_state = N_MSB_ELEM_TX ; 
            flag_delay_1_cicle_AUX = 'd1 ; 

     end

      N_MSB_ELEM_TX: begin 
        if(flag_delay_1_cicle)
            next_state = N_MSB_ELEM_TX ;
        else if(tx_busy)
            next_state = N_MSB_ELEM_TX ; 
        else begin 
            tx_data_AUX[1:0] = Number_Element_MEM[9:8] ; 
            tx_start_AUX = 'd1 ;
            flag_delay_1_cicle_AUX = 'd1 ; 
            if (CHOOSE_OP > 'd0) next_state = Send_Component_TX ;
            if (CHOOSE_MEM > 'd0) next_state =  ReadVec ;  
        end

      end

    ReadVec: begin
        if(read_add_flag)
            countRegister_AUX = countRegister + 'd1 ;  
        next_state = Send_Component_TX ;
 
        

    end

    

    Send_Component_TX: begin
          if(flag_delay_1_cicle)
                next_state= Send_Component_TX; 
         else if(tx_busy)
                next_state= Send_Component_TX ; 
            else begin
                if (CHOOSE_MEM > 'd0) begin
                    if(CHOOSE_MEM == 'd1) tx_data_AUX = stack_data_A[countRegister] ;
                    if(CHOOSE_MEM == 'd2) tx_data_AUX = stack_data_B[countRegister] ;
                    tx_start_AUX = 'd1 ;
                    read_add_flag_AUX = 'd1 ;
                    if(Number_Element_MEM == countRegister)
                        next_state = Mux_command ;
                    else
                        next_state = ReadVec ; 
                end else if (CHOOSE_OP == 'd1) begin 
                    case(countBytes)
                    'd0: begin
                        tx_data_AUX = Result_ALU[7:0] ; 
                        tx_start_AUX = 'd1 ;
                        flag_delay_1_cicle_AUX = 'd1 ; 
                        countBytes_AUX =  countBytes + 'd1 ; 
                        next_state = Send_Component_TX ;
                    end

                    'd1: begin 
                        tx_data_AUX = Result_ALU[9:8] ; 
                        tx_start_AUX = 'd1 ;
                        flag_delay_1_cicle_AUX = 'd1 ;
                        countBytes_AUX = 'd0 ; 
                        if(countRegister == Number_Element_MEM) 
                            next_state = Mux_command ;
                        else
                            next_state = Send_Component_TX ; 
                        countRegister_AUX = countRegister + 'd1 ; 
                    end

                    default: next_state = Mux_command ; 

                    endcase
                end
            else if (CHOOSE_OP == 'd2) begin
                        tx_data_AUX = Result_ALU[7:0] ; 
                        tx_start_AUX = 'd1 ;
                        flag_delay_1_cicle_AUX = 'd1 ; 
                        countRegister_AUX = countRegister + 'd1 ;
                        if(countRegister == Number_Element_MEM) 
                            next_state = Mux_command ;
                        else
                            next_state = Send_Component_TX ;

            end

            else if (CHOOSE_OP == 'd4) begin
                    case(countBytes)
                    'd0: begin
                        tx_data_AUX = Result_ALU[7:0] ; 
                        tx_start_AUX = 'd1 ;
                        flag_delay_1_cicle_AUX = 'd1 ; 
                        countBytes_AUX =  countBytes + 'd1 ; 
                        next_state = Send_Component_TX ;
                    end

                    'd1: begin
                        tx_data_AUX = Result_ALU[15:8] ; 
                        tx_start_AUX = 'd1 ;
                        flag_delay_1_cicle_AUX = 'd1 ; 
                        countBytes_AUX =  countBytes + 'd1 ; 
                        next_state = Send_Component_TX ;
                    end

                    'd2: begin
                        tx_data_AUX = Result_ALU[23:16] ; 
                        tx_start_AUX = 'd1 ;
                        flag_delay_1_cicle_AUX = 'd1 ; 
                        countBytes_AUX = countBytes + 'd1 ;  
                        next_state = Send_Component_TX ;
                    end

                     'd3: begin 
                         Result_display_AUX = Result_ALU;
                         tx_data_AUX = Result_ALU[31:24] ; 
                         tx_start_AUX = 'd1 ;
                         flag_delay_1_cicle_AUX = 'd1 ;
                         countBytes_AUX = 'd0 ;  
                         next_state = Mux_command ;
                     end

                    default: next_state = Mux_command ; 

                    endcase

             end 
            end
    
    end
 
endcase
    
end


always_ff @(posedge clk) begin
    if(reset)
        state <= Mux_command ; 
    else
        state <= next_state ; 
end


 


ALU #(NINPUTS)ALU_CONTROL(
    .clk(clk),
    .reset(reset),
    .stack_data_A(stack_data_A),
    .stack_data_B(stack_data_B),
    .countRegister(countRegister),
    // .Result_Distance(Result_Distance),  
    .Operation(CHOOSE_OP),
    .Result(Result_ALU),
    .OperacionDEBUG(OperacionDEBUG),
    .sumDEBUG(sumDEBUG)
    );

//cordic_0 square(
//    .aclk(clk),
//    .s_axis_cartesian_tvalid(flag_square_in),
//    .s_axis_cartesian_tdata(Result_ALU),
//    .m_axis_dout_tvalid(flag_square_out),
//    .m_axis_dout_tdata(Result_Square)
//) ;

 Display_logic Display_OP(
     .clk(clk),
     .reset(reset),
     .number(Result_display),
     .flag_display(flag_display), 
     .SEG(SEG),
     .AN(AN) 
     );


endmodule
