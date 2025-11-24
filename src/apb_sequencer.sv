`include "uvm_macros.svh"
`include "apb_seq_item.sv"
import uvm_pkg::*;

class apb_sequencer extends uvm_sequencer #(apb_seq_item);

	`uvm_component_utils(apb_sequencer)

	function new(string name = "apb_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

endclass : apb_sequencer
