`default_nettype none

module i2c(
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
    input  la_data_in,   // Inputs from CPU
    output la_data_out,  // Outputs to CPU
    input  la_oenb,      // Output enable bar

    // IOs (Connected to I2C lines)
    input  [3:0] io_in,          // Inputs from I2C bus
    output [3:0] io_out,         // Outputs to I2C bus
    output [3:0] io_oeb          // Output enable (active low)
);

wire la_irq;              // Interrupt from I2C

// I2C Peripheral Instantiation
EF_I2C_WB i2c_peripheral (
    .ext_clk(),              // Not used
    .clk_i(wb_clk_i),        // Clock input from Wishbone
    .rst_i(wb_rst_i),        // Reset input
    .adr_i(wbs_adr_i),       // Address from Wishbone
    .dat_i(wbs_dat_i),       // Data input from Wishbone
    .dat_o(wbs_dat_o),       // Data output to Wishbone
    .sel_i(wbs_sel_i),       // Byte select from Wishbone
    .cyc_i(wbs_cyc_i),       // Cycle signal
    .stb_i(wbs_stb_i),       // Strobe signal
    .we_i(wbs_we_i),         // Write enable signal
    .ack_o(wbs_ack_o),       // Acknowledge signal
    .IRQ(la_irq),            // Interrupt output

    .scl_i(io_in[0]),        // SCL input from IO
    .scl_o(io_out[0]),       // SCL output to IO
    .scl_oen_o(io_oeb[0]),// SCL output enable control
    .sda_i(io_in[1]),        // SDA input from IO
    .sda_o(io_out[1]),       // SDA output to IO
    .sda_oen_o(io_oeb[1]) // SDA output enable control
);

// Logic Analyzer Outputs for Debugging
assign la_data_out = la_irq;         // Send IRQ to LA

// Set LA pins' output enable (active low)
assign la_oenb = 1'b0;  // IRQ signal is always output

endmodule
`default_nettype wire