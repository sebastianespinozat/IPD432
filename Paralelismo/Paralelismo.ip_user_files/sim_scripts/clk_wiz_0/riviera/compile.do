vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic" "+incdir+../../../../Paralelismo.gen/sources_1/ip/clk_wiz_0_2" \
"C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../../Paralelismo.gen/sources_1/ip/clk_wiz_0_2" \
"../../../../Paralelismo.gen/sources_1/ip/clk_wiz_0_2/clk_wiz_0_clk_wiz.v" \
"../../../../Paralelismo.gen/sources_1/ip/clk_wiz_0_2/clk_wiz_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

