interface apb_slv_interfs(input bit PCLK, PRESETn);
	// Output
	bit PRDATA;
	bit PREADY;
	bit PSLVERR;

	// Input
	bit PSELx;
	bit PENABLE;
	bit PWRITE;
	bit [`ADDR_WIDTH-1:0] PADDR;
	bit [`DATA_WIDTH-1:0] PWDATA;
	bit [(`PSTRB_WIDTH/8)-1:0] PSTRB;

	clocking driver_cb @(posedge PCLK);
		output PSELx;
		output PENABLE;
		output PWRITE;
		output PADDR;
		output PWDATA;
		output PSTRB;

		input PREADY;
	endclocking : driver_cb

	clocking monitor_cb @(posedge PCLK);
		input PSELx;
		input PENABLE;
		input PWRITE;
		input PADDR;
		input PWDATA;
		input PSTRB;

		input PRDATA;
		input PREADY;
		input PSLVERR;
	endclocking : monitor_cb

	modport DRIVER (clocking driver_cb, input PCLK, PRESETn);
	modport MONITOR (clocking monitor_cb, input PCLK, PRESETn);
endinterface
