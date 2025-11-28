`include "uvm_macros.svh"
`include "apb_slv_seq_item.sv"
import uvm_pkg::*;

class apb_slv_sequencer extends uvm_sequencer #(apb_slv_seq_item);

	`uvm_component_utils(apb_slv_sequencer)

	function new(string name = "apb_slv_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

endclass : apb_slv_sequencer
