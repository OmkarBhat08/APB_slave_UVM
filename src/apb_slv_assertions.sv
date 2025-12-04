program apb_slv_assertions(PCLK, PRESETn, PSELx, PENABLE, PWRITE, PADDR, PWDATA, PSTRB, PRDATA, PREADY, PSLVERR);

	input PCLK, PRESETn, PSELx, PENABLE, PWRITE;
	input [`ADDR_WIDTH-1:0] PADDR;
	input [`DATA_WIDTH-1:0] PWDATA, PRDATA;
	input [(`DATA_WIDTH/8)-1:0] PSTRB;
	input PREADY, PSLVERR;

	int count = 0;

	// PRESETn_check
	property PRESETn_check;
		@(posedge PCLK) disable iff(PRESETn) !PRESETn |-> PSELx == 0 && ~PENABLE && ~PREADY && ~PSLVERR && PRDATA==0;
	endproperty

	assert property (PRESETn_check)
		$display("ASSERTION PASS: Reset assertion passed");
	else
		$display("ASSERTION FAIL: Reset assertion failed");

	// PRDATA latch
	property PRDATA_latch;
		@(posedge PCLK) disable iff(!PRESETn || count >0) PWRITE |-> PRDATA == $past(PRDATA); 
	endproperty

	assert property (PRDATA_latch)
	begin
		$display("ASSERTION PASS: PRDATA latched when PWRITE is 0");
		count++;
	end
	else
		$display("ASSERTION FAIL: PRDATA not latched when PWRITE is 0");
	
	// FSM check
	property fsm_check();
		@(posedge PCLK) disable iff(!PRESETn) (~PSELx &&  ~PENABLE) |-> ##1 (PSELx && ~PENABLE) |-> ##[1:$] (PSELx && PENABLE);
	endproperty

	assert property (fsm_check)
		$display("ASSERTION PASS: FSM works as intended");
	else
		$display("ASSERTION FAIL: FSM does not work as intended");

	// Stability check
	property stability_check();
		@(posedge PCLK) disable iff(!PRESETn) PSELx |=> $stable({PWDATA, PADDR, PSTRB});
	endproperty

	assert property (stability_check)
		$display("ASSERTION PASS: Signals are stable throughout the SETUP and ACCESS States");
	else
		$display("ASSERTION FAIL: Signals are not stable throughout the SETUP and ACCESS States");

endprogram : apb_slv_assertions
