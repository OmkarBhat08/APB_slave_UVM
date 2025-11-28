class apb_slv_active_agent extends uvm_agent;
	apb_slv_sequencer seqr;
	apb_slv_driver drv;
	apb_slv_active_monitor act_mon;
	
	`uvm_component_utils(apb_slv_active_agent)

	function new(string name = "apb_slv_active_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active == UVM_ACTIVE)
		begin
			seqr = apb_slv_sequencer::type_id::create("seqr", this);
			drv = apb_slv_driver::type_id::create("drv", this);
		end
		act_mon = apb_slv_active_monitor::type_id::create("act_mon", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction : connect_phase

endclass : apb_slv_active_agent
