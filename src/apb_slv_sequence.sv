class apb_slv_sequence extends uvm_sequence #(apb_slv_seq_item);
	`uvm_object_utils(apb_slv_sequence)

	function new(string name = "apb_slv_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		req = apb_slv_seq_item::type_id::create("req");
		wait_for_grant();
		req.randomize();
		send_request(req);
		wait_for_item_done();
	endtask : body

endclass : apb_slv_sequence
//----------------------------------------------------------------------------------------------------------------
class apb_slv_write_read_sequence extends uvm_sequence #(apb_slv_seq_item);

	`uvm_object_utils(apb_slv_write_read_sequence)

	function new(string name = "apb_slv_write_read_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		bit [`ADDR_WIDTH-1:0] write_address;
		`uvm_do_with(req,{req.PSELx == 1; req.PWRITE == 1; req.PSTRB == 1;});
		write_address = req.PADDR;
		`uvm_do_with(req,{req.PSELx == 1; req.PWRITE == 0; req.PADDR == write_address; req.PSTRB == 1;});
	endtask : body

endclass : apb_slv_write_read_sequence
