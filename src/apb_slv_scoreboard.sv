`uvm_analysis_imp_decl(_from_input)
`uvm_analysis_imp_decl(_from_output)
class apb_slv_scoreboard extends uvm_component;

	uvm_analysis_imp_from_input #(apb_slv_seq_item, apb_slv_scoreboard) inputs_export;
	uvm_analysis_imp_from_output #(apb_slv_seq_item, apb_slv_scoreboard) outputs_export;

	apb_slv_seq_item input_q[$], output_q[$];
	bit [(`DATA_WIDTH)-1:0] mem [0:(2**`ADDR_WIDTH)-1];
	apb_slv_seq_item input_packet, output_packet;

	`uvm_component_utils(apb_slv_scoreboard)

	function new (string name = "apb_slv_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		inputs_export = new("inputs_export", this);
		outputs_export = new("outputs_export", this);
	endfunction : new

	function void write_from_input(apb_slv_seq_item incoming_input_transaction);
		input_q.push_back(incoming_input_transaction);
	endfunction : write_from_input

	function void write_from_output(apb_slv_seq_item incoming_output_transaction);
		output_q.push_back(incoming_output_transaction);
	endfunction : write_from_output

	virtual task run_phase(uvm_phase phase);
		forever
		begin
			fork 
				begin
					wait(input_q.size() > 0);
					input_packet = input_q.pop_front();
					if(input_packet.PSELx == 1 && input_packet.PENABLE == 1 && input_packet.PWRITE == 1)
					begin
						$display("-------------------------Scoreboard @ %0t-------------------------", $time);
						$display("Scoreboard writing %0d data into memory at address %0d", input_packet.PWDATA, input_packet.PADDR);
						mem[input_packet.PADDR] =	input_packet.PWDATA;
					end
				end

				begin
					wait(output_q.size() > 0);
					output_packet = output_q.pop_front();
					$display("PRDATA = %0d", output_packet.PRDATA);
					if(input_packet.PSELx == 1 && input_packet.PENABLE == 1 && input_packet.PWRITE == 0)
					begin
						$display("-------------------------Scoreboard @ %0t-------------------------", $time);
						$display("Field\t\t Expected\t\t Actual");
						$display("PRDATA\t     %0d\t\t %0d", mem[input_packet.PADDR], output_packet.PRDATA);

						$display("PADDR = %0d", input_packet.PADDR);

						if(output_packet.PRDATA == mem[input_packet.PADDR])
							$display("Data matches");
						else
							$display("Data doesn't match");
					end
				end
			join

		end
	endtask : run_phase 
	
endclass : apb_slv_scoreboard
