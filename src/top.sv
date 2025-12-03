`include "defines.svh"
`include "apb_slv_interfs.sv"
`include "apb_slv_pkg.sv"
`include "apb_slave.v"
`include "apb_slv_assertions.sv"
  `include "uvm_macros.svh"
  import uvm_pkg::*;
	import apb_slv_pkg::*;
module top();
	bit PCLK, PRESETn;
	apb_slv_interfs interfs (PCLK, PRESETn);

	apb_slave #(.ADDR_WIDTH(`ADDR_WIDTH),
    					.DATA_WIDTH(`DATA_WIDTH))
					DUT (
							.PCLK(PCLK),
	 						.PRESETn(PRESETn),
							.PADDR(interfs.PADDR),
							.PSEL(interfs.PSELx),
							.PENABLE(interfs.PENABLE),
							.PWRITE(interfs.PWRITE),
							.PWDATA(interfs.PWDATA),
							.PSTRB(interfs.PSTRB),
							.PRDATA(interfs.PRDATA),
							.PREADY(interfs.PREADY),
							.PSLVERR(interfs.PSLVERR));	
/*
	apb_slave #(.ADDR_WIDTH(`ADDR_WIDTH),
    					.DATA_WIDTH(`DATA_WIDTH))
					DUT (
							.clk(PCLK),
	 						.rst_n(PRESETn),
							.paddr(interfs.PADDR),
							.psel(interfs.PSELx),
							.penable(interfs.PENABLE),
							.pwrite(interfs.PWRITE),
							.pwdata(interfs.PWDATA),
							.pstrb(interfs.PSTRB),
							.prdata(interfs.PRDATA),
							.pready(interfs.PREADY),
							.pslverr(interfs.PSLVERR));	
	*/
	
	bind interfs apb_slv_assertions ASSERTION (.*);
	always
		#5 PCLK = ~PCLK;

	initial
	begin
		uvm_config_db#(virtual apb_slv_interfs)::set(null,"*","vif",interfs);
		PRESETn = 0;
		#10 PRESETn = 1;
	end

	initial
	begin
		run_test("apb_slv_write_read_test");
		$finish;
	end
							endmodule : top
