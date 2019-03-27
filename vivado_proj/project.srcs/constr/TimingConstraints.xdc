create_clock -period 13.333 -name TMDS_clk_p -waveform {0.000 6.667} [get_ports HDMI_clk_p]
#create_clock -period 8.000 -name ext_clk -waveform {0.000 4.000} -add [get_ports ext_clk]

#create_clock -period 1.333 -name VIRTUAL_CLK_OUT_5x_hdmi_clk -waveform {0.000 0.667}
#set_input_delay -clock [get_clocks VIRTUAL_CLK_OUT_5x_hdmi_clk] -clock_fall -max -add_delay 2.000 [get_ports {TMDS_data_n[*]}]
#set_input_delay -clock [get_clocks VIRTUAL_CLK_OUT_5x_hdmi_clk] -max -add_delay 2.000 [get_ports {TMDS_data_n[*]}]
#set_input_delay -clock [get_clocks VIRTUAL_CLK_OUT_5x_hdmi_clk] -clock_fall -max -add_delay 2.000 [get_ports {TMDS_data_p[*]}]
#set_input_delay -clock [get_clocks VIRTUAL_CLK_OUT_5x_hdmi_clk] -max -add_delay 2.000 [get_ports {TMDS_data_p[*]}]
#set_input_delay -clock [get_clocks clk_fpga_2] -max -add_delay 9.000 [get_ports DDC_scl_io]
#set_input_delay -clock [get_clocks clk_fpga_2] -max -add_delay 9.000 [get_ports DDC_sda_io]

#set_output_delay -clock [get_clocks clk_fpga_2] -max -add_delay 9.000 [get_ports DDC_sda_io]
#set_output_delay -clock [get_clocks clk_fpga_0] -max -add_delay 9.000 [get_ports {hdmi_hpd_tri_o[0]}]

#set_clock_groups -asynchronous -group [get_clocks dvi2rgb_0_PixelClk] -group [get_clocks clk_fpga_0]
#set_clock_groups -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks dvi2rgb_0_PixelClk]
#set_clock_groups -asynchronous -group [get_clocks clk_fpga_1] -group [get_clocks axi_dynclk_0_PXL_CLK_O]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins hdmi_in_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]] -group [get_clocks hdmi_in_i/dvi2rgb_1/U0/RefClk]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins hdmi_in_i/hdmi2rgb_1/U0/TMDS_ClockingX/PixelClkBuffer/O]] -group [get_clocks hdmi_in_i/hdmi2rgb_1/U0/RefClk]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins hdmi_in_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins hdmi_in_i/axi_dynclk_0/U0/BUFR_inst/O]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins hdmi_in_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins hdmi_in_i/dvi2rgb_1/U0/TMDS_ClockingX/PixelClkBuffer/O]]
set_clock_groups -asynchronous -group [get_clocks hdmi_in_i/hdmi2rgb_0/U0/RefClk] -group [get_clocks -of_objects [get_pins hdmi_in_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]

set_false_path -from [get_pins {hdmi_in_i/rgb2hdmi_0/U0/LockLostReset/SyncAsyncx/oSyncStages_reg[1]/C}] -to [get_pins hdmi_in_i/rgb2hdmi_0/U0/*/*/RST]
set_false_path -from [get_pins hdmi_in_i/hdmi2rgb_0/U0/TMDS_ClockingX/aLocked_reg/C] -to [get_pins hdmi_in_i/hdmi2rgb_0/U0/OutputFifo/RST] 
set_false_path -from [get_pins hdmi_in_i/hdmi2rgb_0/U0/TMDS_ClockingX/aLocked_reg/C] -to [get_pins hdmi_in_i/hdmi2rgb_0/U0/OutputFifo/WREN] 
set_false_path -from [get_pins {hdmi_in_i/proc_sys_reset_200M/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N/C}] -to [get_pins {hdmi_in_i/hdmi2rgb_0/U0/*/pAlignRst_reg/D}] 





