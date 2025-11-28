class apb_slv_passive_agent extends uvm_agent;
	apb_slv_passive_monitor pass_mon;
	
	`uvm_component_utils(apb_slv_passive_agent)

	function new(string name = "apb_slv_passive_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active == UVM_PASSIVE)
			pass_mon = apb_slv_passive_monitor::type_id::create("pass_mon", this);
	endfunction : build_phase

endclass : apb_slv_passive_agent
