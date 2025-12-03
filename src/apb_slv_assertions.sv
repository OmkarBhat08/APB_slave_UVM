program apb_slv_assertions(PCLK, PRESETn, PSELx, PENABLE, PWRITE, PADDR, PWDATA, PSTRB, PRDATA, PREADY, PSLVERR);

	input PCLK, PRESETn, PSELx, PENABLE, PWRITE;
	input [`ADDR_WIDTH-1:0] PADDR;
	input [`DATA_WIDTH-1:0] PWDATA, PRDATA;
	input [(`DATA_WIDTH/8)-1:0] PSTRB;
	input PREADY, PSLVERR;

endprogram : apb_slv_assertions
