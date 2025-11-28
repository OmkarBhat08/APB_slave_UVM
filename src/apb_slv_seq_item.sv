`include "defines.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slv_seq_item extends uvm_sequence_item;
	rand bit PSELx;
	rand bit PENABLE;
	rand bit PWRITE;
	rand bit [`ADDR_WIDTH-1:0] PADDR;
	rand bit [`DATA_WIDTH-1:0] PWDATA;
	rand bit [((8*`DATA_WIDTH)+7):(8*`DATA_WIDTH)] PSTRB;

	bit PRDATA;
	bit PREADY;
	bit PSLVERR;

	`uvm_object_utils_begin(apb_slv_seq_item)
		`uvm_field_int(PSELx,UVM_ALL_ON)
		`uvm_field_int(PENABLE,UVM_ALL_ON)
		`uvm_field_int(PWRITE,UVM_ALL_ON)
		`uvm_field_int(PADDR,UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(PSTRB,UVM_ALL_ON | UVM_BIN)

		`uvm_field_int(PWDATA,UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(PREADY,UVM_ALL_ON)
		`uvm_field_int(PSLVERR,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "apb_slv_seq_item");
		super.new(name);
	endfunction : new
endclass : apb_slv_seq_item
