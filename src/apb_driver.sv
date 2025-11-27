class apb_driver extends uvm_driver #(apb_seq_item);

	virtual apb_interfs vif;
	`uvm_component_utils(apb_driver)
	
	function new(string name = "apb_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual apb_interfs)::get(this, "", "vif", vif))
			`uvm_fatal(get_type_name(), $sformatf("Note set at top"));
	endfunction : build_phase

	virtual task run_phase(uvn_phase phase);
		@(posedge vif.driver_cb);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask : run_phase

	virtual task drive();
		$display("---------------------Driver in IDLE State @%0t---------------------", $time);
			// IDLE State
			vif.PSELX <= 0;
			$display("PSELX = %0d", vif.PSELX);
		@(posedge vif.driver_cb);
		$display("---------------------Driver in SETUP State @%0t---------------------", $time);
			// SETUP State
			vif.PSELX <= req.PSELX;
			vif.PENABLE <= 0;
			vif.PWRITE <= req.PWRITE;
			vif.PADDR <= req.PADDR;
			if(req.PWRITE)
				vif.PWDATA <= req.PWDATA;
			vif.PSTRB <= req.PSTRB;
			$display("PSELX = %0d", vif.PSELX);
			$display("PENABLE = %0d", vif.PENABLE);
			$display("PWRITE= %0d", vif.PWRITE);
			$display("PADDR = %0d", vif.PADDR);
			$display("PWDATA = %0d", vif.PWDATA);
			$display("PSTRB = %0d", vif.PSTRB);
		@(posedge vif.driver_cb);
			$display("---------------------Driver in ACCESS State @%0t---------------------", $time);
			// ACCESS State
			wait(vif.PREADY);
			vif.PENABLE <= 1;
			$display("PSELX = %0d", vif.PSELX);
			$display("PENABLE = %0d", vif.PENABLE);
			$display("PWRITE= %0d", vif.PWRITE);
			$display("PADDR = %0d", vif.PADDR);
			$display("PWDATA = %0d", vif.PWDATA);
			$display("PSTRB = %0d", vif.PSTRB);
	endtask : drive
endclass : apb_driver
