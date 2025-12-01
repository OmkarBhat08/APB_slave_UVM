class apb_slv_driver extends uvm_driver #(apb_slv_seq_item);

	virtual apb_slv_interfs vif;
	`uvm_component_utils(apb_slv_driver)

	int transaction_count = 0;
	apb_slv_seq_item prev_transaction;
	
	function new(string name = "apb_slv_driver", uvm_component parent = null);
		super.new(name, parent);
		prev_transaction = new();
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual apb_slv_interfs)::get(this, "", "vif", vif))
			`uvm_fatal(get_type_name(), $sformatf("Note set at top"));
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		//@(posedge vif.driver_cb);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask : run_phase

	virtual task drive();

		if(transaction_count==0 || prev_transaction.PSELx != req.PSELx);
		begin
			$display("---------------------Driver in IDLE State @%0t---------------------", $time);
				// IDLE State
				vif.PSELx <= 0;
				$display("PSELx = %0d", vif.PSELx);
		end

		@(posedge vif.driver_cb);
		$display("---------------------Driver in SETUP State @%0t---------------------", $time);
			// SETUP State
			vif.PSELx <= req.PSELx;
			vif.PENABLE <= 0;
			vif.PWRITE <= req.PWRITE;
			vif.PADDR <= req.PADDR;
			if(req.PWRITE)
				vif.PWDATA <= req.PWDATA;
			vif.PSTRB <= req.PSTRB;
			$display("PSELx = %0d", vif.PSELx);
			$display("PENABLE = %0d", vif.PENABLE);
			if(req.PWRITE)
				$display("PWRITE= %0d", vif.PWRITE);
			$display("PADDR = %0d", vif.PADDR);
			$display("PWDATA = %0d", vif.PWDATA);
			$display("PSTRB = %0d", vif.PSTRB);
		@(posedge vif.driver_cb);
			$display("---------------------Driver in ACCESS State @%0t---------------------", $time);
			// ACCESS State
			//wait(vif.PREADY);
			vif.PENABLE <= 1;
			$display("PSELx = %0d", vif.PSELx);
			$display("PENABLE = %0d", vif.PENABLE);
			$display("PWRITE= %0d", vif.PWRITE);
			$display("PADDR = %0d", vif.PADDR);
			$display("PWDATA = %0d", vif.PWDATA);
			$display("PSTRB = %0d", vif.PSTRB);

			transaction_count++;
			prev_transaction.PSELx = req.PSELx;	
	
			repeat(1)@(posedge vif.driver_cb);

	endtask : drive
endclass : apb_slv_driver
