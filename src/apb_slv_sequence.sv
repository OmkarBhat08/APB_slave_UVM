class apb_slv_base_sequence extends uvm_sequence #(apb_slv_seq_item);
	`uvm_object_utils(apb_slv_base_sequence)

	function new(string name = "apb_slv_base_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		req = apb_slv_seq_item::type_id::create("req");
		wait_for_grant();
		req.randomize();
		send_request(req);
		wait_for_item_done();
		$display("#####################################################################################################");
	endtask : body

endclass : apb_slv_base_sequence
//----------------------------------------------------------------------------------------------------------------
class apb_slv_write_read_sequence extends uvm_sequence #(apb_slv_seq_item);

	`uvm_object_utils(apb_slv_write_read_sequence)

	function new(string name = "apb_slv_write_read_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		bit [`ADDR_WIDTH-1:0] write_address;
		`uvm_do_with(req,{req.PSELx == 1; req.PWRITE == 1; req.PADDR inside{[0:63]};});
		write_address = req.PADDR;
		`uvm_do_with(req,{req.PSELx == 1; req.PWRITE == 0; req.PADDR == write_address;});
		$display("#####################################################################################################");
	endtask : body

endclass : apb_slv_write_read_sequence
//----------------------------------------------------------------------------------------------------------------
class apb_slv_slverr_sequence extends uvm_sequence #(apb_slv_seq_item);

	`uvm_object_utils(apb_slv_slverr_sequence)

	function new(string name = "apb_slv_slverr_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		bit [`ADDR_WIDTH-1:0] write_address;
		`uvm_do_with(req,{req.PSELx == 1; req.PWRITE == 1; req.PADDR inside{[64:255]};});
		write_address = req.PADDR;
		`uvm_do_with(req,{req.PSELx == 1; req.PWRITE == 0; req.PADDR == write_address;});
		$display("#####################################################################################################");
	endtask : body

endclass : apb_slv_slverr_sequence
//----------------------------------------------------------------------------------------------------------------
class apb_slv_regression_sequence extends uvm_sequence #(apb_slv_seq_item);

	apb_slv_base_sequence base_sequence;
	apb_slv_write_read_sequence write_read_sequence;
	apb_slv_slverr_sequence slverr_sequence;

	`uvm_object_utils(apb_slv_regression_sequence)

	function new(string name = "apb_slv_regression_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		`uvm_do(base_sequence);
		repeat(100)
		 `uvm_do(write_read_sequence);
		`uvm_do(slverr_sequence);
	endtask : body

endclass : apb_slv_regression_sequence
