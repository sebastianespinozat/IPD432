// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Sun Dec 25 19:53:06 2022
// Host        : DESKTOP-01L3MR9 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/USM-2022-2/SuperDigitales/IPD432_Carrasco_Espinoza/Tarea3/Paralelismo/Paralelismo.gen/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2022.1" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[7:0],probe2[7:0],probe3[2:0],probe4[7:0],probe5[0:0],probe6[0:0]" */;
  input clk;
  input [0:0]probe0;
  input [7:0]probe1;
  input [7:0]probe2;
  input [2:0]probe3;
  input [7:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
endmodule
