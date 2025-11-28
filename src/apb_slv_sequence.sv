`include "uvm_macros.svh"
`include "apb_slv_seq_item.sv"
import uvm_pkg::*;

class apb_slv_sequence extends uvm_sequence #(apb_slv_seq_item);
	`uvm_object_utils(apb_slv_sequence)

	function new(string name = "apb_slv_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		req = apb_slv_seq_item::type_id::create(req);
		wait_for_grant();
		req.randomize();
		send_request(req);
		wait_for_item_done();
	endtask : body

endclass : apb_slv_sequence
