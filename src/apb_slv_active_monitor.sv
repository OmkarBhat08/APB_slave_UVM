class apb_slv_active_monitor extends uvm_monitor;

	apb_slv_seq_item monitor_sequence_item;
	virtual apb_slv_interfs vif;
	uvm_analysis_port #(apb_slv_seq_item) active_item_port;

	`uvm_component_utils(apb_slv_active_monitor)

	function new(string name = "apb_slv_active_monitor", uvm_component parent = null);
		super.new(name, parent);
		active_item_port = new("active_item_port", this)
		monitor_sequence_item = new();
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual apb_slv_interfs)::get(this, "", "vif", vif))
			`uvm_fatal(get_type_name(), $sformatf("Not set at top"));
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		repeat(1)@(vif.monitor_cb);
		forever
		begin
			wait(vif.PENABLE == 1);
			monitor_sequence_item.PSELX = vif.PSELX;
			monitor_sequence_item.PENABLE = vif.PENABLE;
			monitor_sequence_item.PWRITE = vif.PWRITE;
			monitor_sequence_item.PADDR = vif.PADDR;
			monitor_sequence_item.PWDATA = vif.PWDATA;
			monitor_sequence_item.PSTRB = vif.PSTRB;

			active_item_port.write(monitor_sequence_item);
		end
	endtask : run_phase
endclass : apb_slv_active_monitor
