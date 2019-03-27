
################################################################
# This is a generated script based on design: hdmi_in
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source hdmi_in_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART digilentinc.com:arty-z7-20:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name hdmi_in

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
digilentinc.com:ip:axi_dynclk:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconstant:1.1\
ops.org:ops:hdmi2rgb:1.0\
openpixelsystems.org:ops:ov5640_modder:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
ops.org:ip:rgb2hdmi:1.3\
xilinx.com:ip:v_axi4s_vid_out:4.0\
xilinx.com:ip:v_tc:6.1\
xilinx.com:ip:v_vid_in_axi4s:4.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 DDC ]
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set HDMI [ create_bd_intf_port -mode Slave -vlnv digilentinc.com:interface:tmds_rtl:1.0 HDMI ]
  set TMDS_1 [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_1 ]

  # Create ports

  # Create instance: axi_dynclk_0, and set properties
  set axi_dynclk_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 axi_dynclk_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {100.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {139.594} \
   CONFIG.CLKOUT1_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150.000} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {132.221} \
   CONFIG.CLKOUT2_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {221.734} \
   CONFIG.CLKOUT3_PHASE_ERROR {249.865} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT4_JITTER {228.638} \
   CONFIG.CLKOUT4_PHASE_ERROR {335.459} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT4_USED {false} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.OVERRIDE_MMCM {false} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_IN_FREQ {100} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: gnd_1, and set properties
  set gnd_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd_1

  # Create instance: hdmi2rgb_0, and set properties
  set hdmi2rgb_0 [ create_bd_cell -type ip -vlnv ops.org:ops:hdmi2rgb:1.0 hdmi2rgb_0 ]
  set_property -dict [ list \
   CONFIG.kEdidFileName {720p_edid.data} \
 ] $hdmi2rgb_0

  # Create instance: ov5640_modder_0, and set properties
  set ov5640_modder_0 [ create_bd_cell -type ip -vlnv openpixelsystems.org:ops:ov5640_modder:1.0 ov5640_modder_0 ]

  # Create instance: proc_sys_reset_100M, and set properties
  set proc_sys_reset_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_100M ]

  # Create instance: proc_sys_reset_150M, and set properties
  set proc_sys_reset_150M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_150M ]

  # Create instance: proc_sys_reset_200M, and set properties
  set proc_sys_reset_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_200M ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 9} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {1} \
   CONFIG.PCW_EN_EMIO_I2C1 {1} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_I2C1 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C1_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C1_I2C1_IO {EMIO} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {HSTL 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {fast} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {fast} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {fast} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {fast} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {fast} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {fast} \
   CONFIG.PCW_MIO_46_DIRECTION {out} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {inout} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {out} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#ENET Reset#GPIO#GPIO#GPIO#GPIO#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#reset#gpio[10]#gpio[11]#gpio[12]#gpio[13]#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#gpio[47]#gpio[48]#gpio[49]#gpio[50]#gpio[51]#gpio[52]#gpio[53]} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 46} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
 ] $processing_system7_0

  # Create instance: rgb2hdmi_0, and set properties
  set rgb2hdmi_0 [ create_bd_cell -type ip -vlnv ops.org:ip:rgb2hdmi:1.3 rgb2hdmi_0 ]
  set_property -dict [ list \
   CONFIG.kGenerateSerialClk {false} \
   CONFIG.kRstActiveHigh {false} \
 ] $rgb2hdmi_0

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_VTG_MASTER_SLAVE {0} \
 ] $v_axi4s_vid_out_0

  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
  set_property -dict [ list \
   CONFIG.HAS_AXI4_LITE {false} \
   CONFIG.SYNC_EN {false} \
   CONFIG.auto_generation_mode {false} \
   CONFIG.enable_detection {false} \
   CONFIG.horizontal_blank_detection {true} \
   CONFIG.horizontal_blank_generation {true} \
   CONFIG.vertical_blank_detection {true} \
   CONFIG.vertical_blank_generation {true} \
 ] $v_tc_0

  # Create instance: v_vid_in_axi4s_0, and set properties
  set v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {11} \
   CONFIG.C_HAS_ASYNC_CLK {0} \
 ] $v_vid_in_axi4s_0

  # Create instance: vcc_1, and set properties
  set vcc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $vcc_1

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net TMDS_0_1 [get_bd_intf_ports HDMI] [get_bd_intf_pins hdmi2rgb_0/TMDS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_dynclk_0/s00_axi] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net hdmi2rgb_0_DDC [get_bd_intf_ports DDC] [get_bd_intf_pins hdmi2rgb_0/DDC]
  connect_bd_intf_net -intf_net ov5640_modder_0_axis_out [get_bd_intf_pins ov5640_modder_0/axis_out] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net rgb2hdmi_0_TMDS [get_bd_intf_ports TMDS_1] [get_bd_intf_pins rgb2hdmi_0/TMDS]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_video_out [get_bd_intf_pins ov5640_modder_0/axis_in] [get_bd_intf_pins v_vid_in_axi4s_0/video_out]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins hdmi2rgb_0/aRst_n] [get_bd_pins hdmi2rgb_0/pRst_n] [get_bd_pins proc_sys_reset_200M/peripheral_aresetn]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins proc_sys_reset_100M/interconnect_aresetn]
  connect_bd_net -net axi_dynclk_0_LOCKED_O [get_bd_pins axi_dynclk_0/LOCKED_O] [get_bd_pins rgb2hdmi_0/aRst_n]
  connect_bd_net -net axi_dynclk_0_PXL_CLK_5X_O [get_bd_pins axi_dynclk_0/PXL_CLK_5X_O] [get_bd_pins rgb2hdmi_0/SerialClk]
  connect_bd_net -net axi_dynclk_0_PXL_CLK_O [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins rgb2hdmi_0/PixelClk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
  connect_bd_net -net clk_200M [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins hdmi2rgb_0/RefClk] [get_bd_pins proc_sys_reset_200M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins hdmi2rgb_0/IntVid_Clk] [get_bd_pins ov5640_modder_0/clk] [get_bd_pins proc_sys_reset_150M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_vid_in_axi4s_0/aclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_150M/dcm_locked] [get_bd_pins proc_sys_reset_200M/dcm_locked]
  connect_bd_net -net hdmi2rgb_0_PixelClk [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins hdmi2rgb_0/PixelClk]
  connect_bd_net -net hdmi2rgb_0_vid_pData [get_bd_pins hdmi2rgb_0/vid_pData] [get_bd_pins v_vid_in_axi4s_0/vid_data]
  connect_bd_net -net hdmi2rgb_0_vid_pHSync [get_bd_pins hdmi2rgb_0/vid_pHSync] [get_bd_pins v_vid_in_axi4s_0/vid_hsync]
  connect_bd_net -net hdmi2rgb_0_vid_pVDE [get_bd_pins hdmi2rgb_0/vid_pVDE] [get_bd_pins v_vid_in_axi4s_0/vid_active_video]
  connect_bd_net -net hdmi2rgb_0_vid_pVSync [get_bd_pins hdmi2rgb_0/vid_pVSync] [get_bd_pins v_vid_in_axi4s_0/vid_vsync]
  connect_bd_net -net hdmi2rgb_0_vid_pValid [get_bd_pins hdmi2rgb_0/vid_pValid] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_ce]
  connect_bd_net -net proc_sys_reset_100M_peripheral_aresetn [get_bd_pins axi_dynclk_0/s00_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins proc_sys_reset_100M/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_150M_peripheral_aresetn [get_bd_pins hdmi2rgb_0/IntVid_Rst_n] [get_bd_pins ov5640_modder_0/resetn] [get_bd_pins proc_sys_reset_150M/peripheral_aresetn] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_vid_in_axi4s_0/aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dynclk_0/s00_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins proc_sys_reset_100M/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_100M/ext_reset_in] [get_bd_pins proc_sys_reset_150M/ext_reset_in] [get_bd_pins proc_sys_reset_200M/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net v_axi4s_vid_out_0_vid_active_video [get_bd_pins rgb2hdmi_0/vid_pVDE] [get_bd_pins v_axi4s_vid_out_0/vid_active_video]
  connect_bd_net -net v_axi4s_vid_out_0_vid_data [get_bd_pins rgb2hdmi_0/vid_pData] [get_bd_pins v_axi4s_vid_out_0/vid_data]
  connect_bd_net -net v_axi4s_vid_out_0_vid_hsync [get_bd_pins rgb2hdmi_0/vid_pHSync] [get_bd_pins v_axi4s_vid_out_0/vid_hsync]
  connect_bd_net -net v_axi4s_vid_out_0_vid_vsync [get_bd_pins rgb2hdmi_0/vid_pVSync] [get_bd_pins v_axi4s_vid_out_0/vid_vsync]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken] [get_bd_pins v_tc_0/resetn]
  connect_bd_net -net vcc_1_dout [get_bd_pins hdmi2rgb_0/IntVid_read_enable] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins v_tc_0/clken] [get_bd_pins v_vid_in_axi4s_0/aclken] [get_bd_pins v_vid_in_axi4s_0/axis_enable] [get_bd_pins vcc_1/dout]
  connect_bd_net -net vcc_2_dout [get_bd_pins gnd_1/dout] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_reset]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dynclk_0/s00_axi/reg0] SEG_axi_dynclk_0_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


