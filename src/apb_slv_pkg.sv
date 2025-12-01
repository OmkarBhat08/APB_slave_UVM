`include "uvm_macros.svh"

package apb_slv_pkg;
	import uvm_pkg::*;
	`include "apb_slv_seq_item.sv"
	`include "apb_slv_sequence.sv"
	`include "apb_slv_sequencer.sv"
	`include "apb_slv_driver.sv"
	`include "apb_slv_active_monitor.sv"
	`include "apb_slv_passive_monitor.sv"
	`include "apb_slv_active_agent.sv"
	`include "apb_slv_passive_agent.sv"
	`include "apb_slv_scoreboard.sv"
	`include "apb_slv_subscriber.sv"
	`include "apb_slv_env.sv"
	`include "apb_slv_test.sv"
endpackage
