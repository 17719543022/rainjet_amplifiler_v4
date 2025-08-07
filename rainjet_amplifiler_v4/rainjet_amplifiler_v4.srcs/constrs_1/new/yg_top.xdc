

############## clock define##################
create_clock -period 20.834 [get_ports clk]
set_property PACKAGE_PIN Y18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

##################################################################################
###################################    LED   #####################################
##################################################################################
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN N17 [get_ports {led[2]}]
set_property PACKAGE_PIN P16 [get_ports {led[1]}]
set_property PACKAGE_PIN P15 [get_ports {led[0]}]

##################################################################################
###################################   UART   #####################################
##################################################################################
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_property PACKAGE_PIN AA4 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property PACKAGE_PIN AA5 [get_ports uart_txd]

set_property IOSTANDARD LVCMOS33 [get_ports scl]
set_property PACKAGE_PIN V19 [get_ports scl]
set_property IOSTANDARD LVCMOS33 [get_ports sda]
set_property PACKAGE_PIN U17 [get_ports sda]

##################################################################################
################################ USB68013 INF ####################################
##################################################################################
set_property IOSTANDARD LVCMOS33 [get_ports SLV_RST]
set_property IOSTANDARD LVCMOS33 [get_ports USB_IFCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_WR]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_RD]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_FLAGA]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_FLAGB]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_OE]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_CS]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_ADD0]
set_property IOSTANDARD LVCMOS33 [get_ports SLV_ADD1]

set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {USB_DATA[15]}]

set_property PACKAGE_PIN C15 [get_ports SLV_RST]
set_property PACKAGE_PIN G22 [get_ports USB_IFCLK]
set_property PACKAGE_PIN D21 [get_ports SLV_WR]
set_property PACKAGE_PIN D22 [get_ports SLV_RD]
set_property PACKAGE_PIN E22 [get_ports SLV_FLAGA]
set_property PACKAGE_PIN C22 [get_ports SLV_FLAGB]
set_property PACKAGE_PIN D15 [get_ports SLV_OE]
set_property PACKAGE_PIN C18 [get_ports SLV_CS]
set_property PACKAGE_PIN C17 [get_ports SLV_ADD0]
set_property PACKAGE_PIN D17 [get_ports SLV_ADD1]
set_property PACKAGE_PIN G21 [get_ports {USB_DATA[0]}]
set_property PACKAGE_PIN E21 [get_ports {USB_DATA[1]}]
set_property PACKAGE_PIN F20 [get_ports {USB_DATA[2]}]
set_property PACKAGE_PIN F19 [get_ports {USB_DATA[3]}]
set_property PACKAGE_PIN A20 [get_ports {USB_DATA[4]}]
set_property PACKAGE_PIN B20 [get_ports {USB_DATA[5]}]
set_property PACKAGE_PIN A21 [get_ports {USB_DATA[6]}]
set_property PACKAGE_PIN B21 [get_ports {USB_DATA[7]}]
set_property PACKAGE_PIN E16 [get_ports {USB_DATA[8]}]
set_property PACKAGE_PIN C19 [get_ports {USB_DATA[9]}]
set_property PACKAGE_PIN E17 [get_ports {USB_DATA[10]}]
set_property PACKAGE_PIN C20 [get_ports {USB_DATA[11]}]
set_property PACKAGE_PIN D19 [get_ports {USB_DATA[12]}]
set_property PACKAGE_PIN F18 [get_ports {USB_DATA[13]}]
set_property PACKAGE_PIN E19 [get_ports {USB_DATA[14]}]
set_property PACKAGE_PIN E18 [get_ports {USB_DATA[15]}]

##################################################################################
###################################    ADC   #####################################
##################################################################################
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_cs]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_sck]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_din]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_sync]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_18]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_17]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_16]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_15]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_14]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_13]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_12]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_11]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_10]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_9]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_8]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_7]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_6]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_5]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_4]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_3]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_2]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_1]
set_property IOSTANDARD LVCMOS33 [get_ports ad7177_dout_0]

set_property PACKAGE_PIN G3 [get_ports ad7177_cs]
set_property PACKAGE_PIN R1 [get_ports ad7177_sck]
set_property PACKAGE_PIN P2 [get_ports ad7177_din]
set_property PACKAGE_PIN G4 [get_ports ad7177_sync]
set_property PACKAGE_PIN G2 [get_ports ad7177_dout_18]
set_property PACKAGE_PIN K6 [get_ports ad7177_dout_17]
set_property PACKAGE_PIN M3 [get_ports ad7177_dout_16]
set_property PACKAGE_PIN M5 [get_ports ad7177_dout_15]
set_property PACKAGE_PIN M6 [get_ports ad7177_dout_14]
set_property PACKAGE_PIN N5 [get_ports ad7177_dout_13]
set_property PACKAGE_PIN P4 [get_ports ad7177_dout_12]
set_property PACKAGE_PIN P5 [get_ports ad7177_dout_11]
set_property PACKAGE_PIN P6 [get_ports ad7177_dout_10]
set_property PACKAGE_PIN H4 [get_ports ad7177_dout_9]
set_property PACKAGE_PIN H3 [get_ports ad7177_dout_8]
set_property PACKAGE_PIN H5 [get_ports ad7177_dout_7]
set_property PACKAGE_PIN J4 [get_ports ad7177_dout_6]
set_property PACKAGE_PIN J5 [get_ports ad7177_dout_5]
set_property PACKAGE_PIN K4 [get_ports ad7177_dout_4]
set_property PACKAGE_PIN J6 [get_ports ad7177_dout_3]
set_property PACKAGE_PIN L3 [get_ports ad7177_dout_2]
set_property PACKAGE_PIN L4 [get_ports ad7177_dout_1]
set_property PACKAGE_PIN L5 [get_ports ad7177_dout_0]

##################################################################################
###################################    595   #####################################
##################################################################################
set_property IOSTANDARD LVCMOS33 [get_ports FPGA_DOUT_OE]
set_property IOSTANDARD LVCMOS33 [get_ports FPGA_DOUT_LCK]
set_property IOSTANDARD LVCMOS33 [get_ports FPGA_DOUT_RST]
set_property IOSTANDARD LVCMOS33 [get_ports FPGA_DOUT_SCK]
set_property IOSTANDARD LVCMOS33 [get_ports FPGA_DOUT_SIN]

set_property PACKAGE_PIN T1 [get_ports FPGA_DOUT_OE]
set_property PACKAGE_PIN R4 [get_ports FPGA_DOUT_LCK]
set_property PACKAGE_PIN U2 [get_ports FPGA_DOUT_RST]
set_property PACKAGE_PIN U1 [get_ports FPGA_DOUT_SCK]
set_property PACKAGE_PIN W1 [get_ports FPGA_DOUT_SIN]


##################################################################################
#################################    JI LIAN   ###################################
##################################################################################
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_cs_out]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_sck_out]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_data_out0]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_data_out1]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_cs_in]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_sck_in]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_data_in0]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com1_data_in1]

set_property PACKAGE_PIN V2 [get_ports jl_com1_cs_out]
set_property PACKAGE_PIN W2 [get_ports jl_com1_sck_out]
set_property PACKAGE_PIN T5 [get_ports jl_com1_data_out0]
set_property PACKAGE_PIN T6 [get_ports jl_com1_data_out1]
set_property PACKAGE_PIN AA8 [get_ports jl_com1_cs_in]
set_property PACKAGE_PIN AB8 [get_ports jl_com1_sck_in]
set_property PACKAGE_PIN T4 [get_ports jl_com1_data_in0]
set_property PACKAGE_PIN AB7 [get_ports jl_com1_data_in1]

set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_cs_out]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_sck_out]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_data_out0]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_data_out1]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_cs_in]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_sck_in]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_data_in0]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com2_data_in1]

set_property PACKAGE_PIN J1 [get_ports jl_com2_cs_out]
set_property PACKAGE_PIN K1 [get_ports jl_com2_sck_out]
set_property PACKAGE_PIN L1 [get_ports jl_com2_data_out0]
set_property PACKAGE_PIN M1 [get_ports jl_com2_data_out1]
set_property PACKAGE_PIN AB2 [get_ports jl_com2_cs_in]
set_property PACKAGE_PIN AB3 [get_ports jl_com2_sck_in]
set_property PACKAGE_PIN AA1 [get_ports jl_com2_data_in0]
set_property PACKAGE_PIN AB1 [get_ports jl_com2_data_in1]

set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_cs_out]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_sck_out]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_data_out0]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_data_out1]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_cs_in]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_sck_in]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_data_in0]
set_property IOSTANDARD LVCMOS33 [get_ports jl_com3_data_in1]

set_property PACKAGE_PIN B2 [get_ports jl_com3_cs_out]
set_property PACKAGE_PIN C2 [get_ports jl_com3_sck_out]
set_property PACKAGE_PIN D2 [get_ports jl_com3_data_out0]
set_property PACKAGE_PIN E2 [get_ports jl_com3_data_out1]
set_property PACKAGE_PIN B1 [get_ports jl_com3_cs_in]
set_property PACKAGE_PIN A1 [get_ports jl_com3_sck_in]
set_property PACKAGE_PIN E1 [get_ports jl_com3_data_in0]
set_property PACKAGE_PIN D1 [get_ports jl_com3_data_in1]

set_property IOSTANDARD LVCMOS33 [get_ports sw0]
set_property IOSTANDARD LVCMOS33 [get_ports sw1]

set_property PACKAGE_PIN AA6 [get_ports sw0]
set_property PACKAGE_PIN AB5 [get_ports sw1]


##################################################################################
#################################  SPI CONFIG  ###################################
##################################################################################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]


