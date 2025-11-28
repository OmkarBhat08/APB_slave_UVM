class apb_slv_env extends uvm_env;
	
	apb_slv_active_agent act_agnt;
	apb_slv_passive_agent pass_agnt;	
	apb_slv_subscriber subscr;
	apb_slv_scoreboard scb;

	`uvm_component_utils(apb_slv_env)

	function new(string name = "apb_slv_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		act_agnt = apb_slv_active_agent::type_id::create("act_agnt", this);
		pass_agnt = apb_slv_passive_agent::type_id::create("pass_agnt", this);
		subscr = apb_slv_subscriber::type_id::create("subscr", this);
		scb = apb_slv_scoreboard::type_id::create("scb", this);

		set_config_int("act_agnt", "is_active", UVM_ACTIVE);
		set_config_int("pass_agnt", "is_active", UVM_PASSIVE);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		act_agnt.act_mon.active_item_port.connect(subscr.aport_inputs);
		act_agnt.act_mon.active_item_port.connect(scb.inputs_export);

		pass_agnt.pass_mon.passive_item_port.connect(subscr.aport_outputs);
		pass_agnt.pass_mon.passive_item_port.connect(scb.outputs_export);
	endfunction : connect_phase

endclass : apb_slv_env
