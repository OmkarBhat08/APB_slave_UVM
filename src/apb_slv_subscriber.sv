`uvm_analysis_imp_decl(_from_inp)
`uvm_analysis_imp_decl(_from_out)
class apb_slv_subscriber extends uvm_component;

	uvm_analysis_imp_from_inp #(apb_slv_seq_item, apb_slv_subscriber) aport_inputs;
	uvm_analysis_imp_from_out #(apb_slv_seq_item, apb_slv_subscriber) aport_outputs;

	apb_slv_seq_item input_trans, output_trans;
	real input_coverage, output_coverage;

	`uvm_component_utils(apb_slv_subscriber)

	covergroup input_cov();
		//PRESETn: coverpoint input_trans.PRESETn;
		PSELX: coverpoint input_trans.PSELx{
																			  bins asserted = {1};
																	  	 }
		PENABLE: coverpoint input_trans.PENABLE{
																				  	bins asserted = {1};
																					 }
		PWRITE: coverpoint input_trans.PWRITE{
																					bins deasserted = {0};
																				  bins asserted = {1};
																					}
		PADDR: coverpoint input_trans.PADDR{
																				option.auto_bin_max = 4;
					                             }
			PWDATA: coverpoint input_trans.PWDATA{
																						option.auto_bin_max = 4;
	                                      	 }
		PSTRB: coverpoint input_trans.PSTRB;

		PADDRxPWDATA: cross PADDR, PWDATA;
	endgroup : input_cov
	
	covergroup output_cov();
		PREADY: coverpoint output_trans.PREADY{
																					 bins asserted = {1};
																					}
		PSLVERR: coverpoint output_trans.PSLVERR{
																						 bins deasserted = {0};
																						 bins asserted = {1};
																						}
		PRDATA: coverpoint output_trans.PRDATA{
																					option.auto_bin_max = 4;
			                                    }
	endgroup : output_cov

	function new (string name = "apb_slv_subscriber", uvm_component parent = null);
		super.new(name, parent);
		aport_inputs = new("aport_inputs", this);
		aport_outputs = new("aport_outputs", this);
		input_cov = new();
		output_cov = new();
		input_trans = new();
		output_trans = new();
	endfunction : new

	function void write_from_inp(apb_slv_seq_item incoming_input_transaction);
		input_trans = incoming_input_transaction;
		input_cov.sample();
	endfunction : write_from_inp

	function void write_from_out(apb_slv_seq_item incoming_output_transaction);
		output_trans = incoming_output_transaction;
		output_cov.sample();
	endfunction : write_from_out

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		input_coverage = input_cov.get_coverage();
		output_coverage = output_cov.get_coverage();
	endfunction : extract_phase

	function void report_phase(uvm_phase phase);
	super.report_phase(phase);
			`uvm_info(get_type_name(), $sformatf("[Input]: Coverage --> %0.2f", input_coverage), UVM_MEDIUM);
	    `uvm_info(get_type_name(), $sformatf("[Output]: Coverage --> %0.2f", output_coverage), UVM_MEDIUM);
	endfunction : report_phase

endclass : apb_slv_subscriber
