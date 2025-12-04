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
																				bins deasserted = {0};
																			  bins asserted = {1};
																	  	 }
		PENABLE: coverpoint input_trans.PENABLE{
																						bins deasserted = {0};
																				  	bins asserted = {1};
																					 }
		PWRITE: coverpoint input_trans.PWRITE{
																					bins deasserted = {0};
																				  bins asserted = {1};
																					}
		PADDR: coverpoint input_trans.PADDR{bins PADDR_range0 = {[0:3]};
					                              bins PADDR_range1 = {[4:15]};
					                    	        bins PADDR_range2 = {[16:63]};
					                              bins PADDR_invalid_range = {[64:255]};
					                             }
			PWDATA: coverpoint input_trans.PWDATA{wildcard bins PWDATA_range0 = {16'h000?};
						                              	wildcard bins PWDATA_range1 = {16'h00?0};
						                              	wildcard bins PWDATA_range2 = {16'h0?00};
						                              	wildcard bins PWDATA_range3 = {16'h?000};
	                                      	 }
		PSTRB: coverpoint input_trans.PSTRB{
																				bins deasserted = {0};
																			  bins asserted = {1};
																			 }
		PADDRxPWDATA: cross PADDR, PWDATA;
	endgroup : input_cov
	
	covergroup output_cov();
		PREADY: coverpoint output_trans.PREADY{
																					 bins deasserted = {0};
																					 bins asserted = {1};
																					}
		PSLVERR: coverpoint output_trans.PSLVERR{
																						 bins deasserted = {0};
																						 bins asserted = {1};
																						}
		PRDATA: coverpoint output_trans.PRDATA{wildcard bins PRDATA_range0 = {16'h000?};
			                                     wildcard bins PRDATA_range1 = {16'h00?0};
			                                     wildcard bins PRDATA_range2 = {16'h0?00};
			                                     wildcard bins PRDATA_range3 = {16'h?000};
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
