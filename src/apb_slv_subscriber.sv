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
		PSELX: coverpoint input_trans.PSELx;
		PENABLE: coverpoint input_trans.PENABLE;
		PWRITE: coverpoint input_trans.PWRITE;
		PADDR: coverpoint input_trans.PADDR;
		/*
		{bins PADDR0 = {[0:50]};
					                              bins PADDR1 = {[51:100]};
					                              bins PADDR2 = {[101:150]};
					                    	        bins PADDR3 = {[151:200]};
					                              bins PADDR4 = {[201:255]};
					                             }
		*/
			PWDATA: coverpoint input_trans.PWDATA;
		/*
		{bins PWDATA0 = {[0:50]};
						                              bins PWDATA1 = {[51:100]};
						                              bins PWDATA2 = {[101:150]};
						                              bins PWDATA3 = {[151:200]};
						                              bins PWDATA4 = {[201:255]};
	                                       }
		*/
		PSTRB: coverpoint input_trans.PSTRB;
		PADDRxPWDATA: cross PADDR, PWDATA;
	endgroup : input_cov
	
	covergroup output_cov();
		PREADY: coverpoint output_trans.PREADY;
		PSLVERR: coverpoint output_trans.PSLVERR;
		PRDATA: coverpoint output_trans.PRDATA{bins PRDATA0 = {[0:50]};
						                               bins PRDATA1 = {[51:100]};
						                               bins PRDATA2 = {[101:150]};
						                               bins PRDATA3 = {[151:200]};
						                               bins PRDATA4 = {[201:255]};
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
