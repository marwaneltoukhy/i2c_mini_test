// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

module user_project_wrapper_mini4 #(
    parameter BITS = 30,
    parameter COUNT_STEP = 1) (
`ifdef USE_POWER_PINS
    inout VPWR,  // User area 1 1.8V supply
    inout VGND,  // User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [31:0] la_data_in,
    output [31:0] la_data_out,
    input  [31:0] la_oenb,

    // IOs
    input  [35:0] io_in,
    output [35:0] io_out,
    output [35:0] io_oeb,

    // Independent clock (on independent integer divider)
    input user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

`ifdef PnR
    assign io_out = io_in;
`else
    i2c mprj (
            .wb_clk_i(wb_clk_i),
            .wb_rst_i(wb_rst_i),

            // MGMT SoC Wishbone Slave

            .wbs_cyc_i(wbs_cyc_i),
            .wbs_stb_i(wbs_stb_i),
            .wbs_we_i(wbs_we_i),
            .wbs_sel_i(wbs_sel_i),
            .wbs_adr_i(wbs_adr_i),
            .wbs_dat_i(wbs_dat_i),
            .wbs_ack_o(wbs_ack_o),
            .wbs_dat_o(wbs_dat_o),

            // Logic Analyzer

            .la_data_in(la_data_in[0]),
            .la_data_out(la_data_out[0]),
            .la_oenb (la_oenb[0]),

            // IO Pads

            .io_in (io_in[35:34]),
            .io_out(io_out[35:34]),
            .io_oeb(io_oeb[35:34])
        );
`endif

endmodule