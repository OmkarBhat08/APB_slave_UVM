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
		forever
		begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask : run_phase

	virtual task drive();
		
	endtask : drive
endclass : apb_driver
