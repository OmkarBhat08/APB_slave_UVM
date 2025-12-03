class apb_slv_base_test extends uvm_test;

	`uvm_component_utils(apb_slv_base_test)

	apb_slv_env env;

	function new(string name = "apb_slv_base_test", uvm_component parent  = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = apb_slv_env::type_id::create("env", this); 
	endfunction : build_phase

	function void end_of_elaboration();
		print();
	endfunction

endclass : apb_slv_base_test

//------------------------------------------------------------------------------------------
class apb_slv_write_read_test extends apb_slv_base_test;

	`uvm_component_utils(apb_slv_write_read_test)

	function new(string name = "apb_slv_write_read_test", uvm_component parent  = null);
		super.new(name, parent);
	endfunction : new

	virtual task run_phase(uvm_phase phase);
		apb_slv_write_read_sequence seq;
		phase.raise_objection(this, "Objection raised");
		seq = apb_slv_write_read_sequence::type_id::create("seq");
		repeat(2)
		begin
			$display("##############################################################################");
			seq.start(env.act_agnt.seqr);
		end
		phase.drop_objection(this, "Objection dropped");
	endtask : run_phase

endclass : apb_slv_write_read_test
