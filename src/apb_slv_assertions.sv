program apb_slv_assertions(PCLK, PRESETn, PSELx, PWRITE, PADDR, PWDATA, PSTRB, PRDATA, PREADY, PSLVERR);

	input PCLK, PRESETn, PSELx, PENABLE, PWRITE;
	input [`ADDR_WIDTH-1:0] PADDR;
	input [`DATA_WIDTH-1:0] PWDATA;
	input [(`DATA_WIDTH/8)-1:0] PSTRB;
	input PRDATA, PREADY, PSLVERR;

endprogram : apb_slv_assertions
