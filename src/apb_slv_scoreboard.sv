`uvm_analysis_imp_decl(_from_input)
`uvm_analysis_imp_decl(_from_output)
class apb_slv_scoreboard extends uvm_component;

	uvm_analysis_imp_from_input #(apb_slv_seq_item, apb_slv_scoreboard) inputs_export;
	uvm_analysis_imp_from_output #(apb_slv_seq_item, apb_slv_scoreboard) outputs_export;

	apb_slv_seq_item input_q[$], output_q[$];
	bit [(2**`ADDR_WIDTH)-1:0] mem [`DATA_WIDTH-1:0];
	apb_slv_seq_item input_packet, output_packet;

	`uvm_component_utils(apb_slv_scoreboard)

	function new (string name = "apb_slv_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		inputs_export = new("inputs_export", this);
		outputs_export = new("outputs_export", this);
		input_packet  = new();
		output_packet  = new();
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
			$display("-------------------------Scoreboard @ %0t-------------------------", $time);
			fork
				begin
					wait(input_q.size() > 0);
					write_task();
				end

				begin
					wait(output_q.size() > 0);
					read_task();
				end
			join_any			
		end
	endtask : run_phase 

	virtual task write_task();
		bit [31:0] mask;
		input_packet = input_q.pop_front();
		if(input_packet.PSELx == 1 && input_packet.PENABLE == 1 && input_packet.PWRITE == 1)
		begin
			$display("Scoreboard writing %0h data into memory at address %0h", input_packet.PWDATA, input_packet.PADDR);
			// Prepare mask as per PSTRB
			/*
			if(input_packet.PSTRB[0])
				mask[7:0] = 8'hFF;

			if(input_packet.PSTRB[1])
				mask[15:8] = 8'hFF;

			if(input_packet.PSTRB[2])
				mask[23:16] = 8'hFF;

			if(input_packet.PSTRB[3])
				mask[31:24] = 8'hFF;
*/
			mem[input_packet.PADDR] =	input_packet.PWDATA;
		end
	endtask : write_task
	
	virtual task read_task();
		output_packet = output_q.pop_front();
		$display("Field\t Expected\t Actual", output_packet.PRDATA, mem[input_packet.PADDR]);
		$display("PRDATA\t %0d\t %0d", mem[input_packet.PADDR], output_packet.PRDATA);

		if(output_packet.PRDATA == mem[input_packet.PADDR])
			$display("Data matches");
		else
			$display("Data doesn't match");
	endtask : read_task

endclass : apb_slv_scoreboard
