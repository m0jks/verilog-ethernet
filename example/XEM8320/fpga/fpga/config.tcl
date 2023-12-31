# Copyright (c) 2023 Dave Pegler
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Transceiver configuration
set eth_xcvr_freerun_freq {125}
set eth_xcvr_line_rate {10.3125}
set eth_xcvr_refclk_freq {156.25}
set eth_xcvr_qpll_fracn [expr {int(fmod($eth_xcvr_line_rate*1000/2 / $eth_xcvr_refclk_freq, 1)*pow(2, 24))}]
set eth_xcvr_rx_eq_mode {DFE}

# SFP_1
set xcvr_config_sfp_1 [dict create]
#
dict set xcvr_config_sfp_1 CONFIG.TX_LINE_RATE $eth_xcvr_line_rate
dict set xcvr_config_sfp_1 CONFIG.TX_QPLL_FRACN_NUMERATOR $eth_xcvr_qpll_fracn
dict set xcvr_config_sfp_1 CONFIG.TX_REFCLK_FREQUENCY $eth_xcvr_refclk_freq
dict set xcvr_config_sfp_1 CONFIG.RX_LINE_RATE $eth_xcvr_line_rate
dict set xcvr_config_sfp_1 CONFIG.RX_QPLL_FRACN_NUMERATOR $eth_xcvr_qpll_fracn
dict set xcvr_config_sfp_1 CONFIG.RX_REFCLK_FREQUENCY $eth_xcvr_refclk_freq
dict set xcvr_config_sfp_1 CONFIG.RX_EQ_MODE $eth_xcvr_rx_eq_mode
dict set xcvr_config_sfp_1 CONFIG.CHANNEL_ENABLE {X0Y8}
dict set xcvr_config_sfp_1 CONFIG.RX_MASTER_CHANNEL {X0Y8}
dict set xcvr_config_sfp_1 CONFIG.RX_REFCLK_SOURCE {X0Y8 clk1-2}
dict set xcvr_config_sfp_1 CONFIG.TX_MASTER_CHANNEL {X0Y8}
dict set xcvr_config_sfp_1 CONFIG.TX_REFCLK_SOURCE {X0Y8 clk1-2}
dict set xcvr_config_sfp_1 CONFIG.FREERUN_FREQUENCY $eth_xcvr_freerun_freq
#
set_property -dict $xcvr_config_sfp_1 [get_ips eth_xcvr_gt_full]

# SFP_2
set xcvr_config_sfp_2 [dict create]
#
dict set xcvr_config_sfp_2 CONFIG.TX_LINE_RATE $eth_xcvr_line_rate
dict set xcvr_config_sfp_2 CONFIG.TX_QPLL_FRACN_NUMERATOR $eth_xcvr_qpll_fracn
dict set xcvr_config_sfp_2 CONFIG.TX_REFCLK_FREQUENCY $eth_xcvr_refclk_freq
dict set xcvr_config_sfp_2 CONFIG.RX_LINE_RATE $eth_xcvr_line_rate
dict set xcvr_config_sfp_2 CONFIG.RX_QPLL_FRACN_NUMERATOR $eth_xcvr_qpll_fracn
dict set xcvr_config_sfp_2 CONFIG.RX_REFCLK_FREQUENCY $eth_xcvr_refclk_freq
dict set xcvr_config_sfp_2 CONFIG.RX_EQ_MODE $eth_xcvr_rx_eq_mode
dict set xcvr_config_sfp_2 CONFIG.CHANNEL_ENABLE {X0Y9}
dict set xcvr_config_sfp_2 CONFIG.RX_MASTER_CHANNEL {X0Y9}
dict set xcvr_config_sfp_2 CONFIG.RX_REFCLK_SOURCE {X0Y9 clk1-2}
dict set xcvr_config_sfp_2 CONFIG.TX_MASTER_CHANNEL {X0Y9}
dict set xcvr_config_sfp_2 CONFIG.TX_REFCLK_SOURCE {X0Y9 clk1-2}
dict set xcvr_config_sfp_2 CONFIG.FREERUN_FREQUENCY $eth_xcvr_freerun_freq
#
set_property -dict $xcvr_config_sfp_2 [get_ips eth_xcvr_gt_channel]