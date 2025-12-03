`uvm_analysis_imp_decl(_from_input)
`uvm_analysis_imp_decl(_from_output)
class apb_slv_scoreboard extends uvm_component;

	uvm_analysis_imp_from_input #(apb_slv_seq_item, apb_slv_scoreboard) inputs_export;
	uvm_analysis_imp_from_output #(apb_slv_seq_item, apb_slv_scoreboard) outputs_export;

	apb_slv_seq_item input_q[$], output_q[$];
	apb_slv_seq_item input_packet, output_packet;

	bit [(`DATA_WIDTH)-1:0] mem [0:(2**`ADDR_WIDTH)-1];
	bit PSLVERR;
	int index;
	bit [`DATA_WIDTH-1:0] mask;
	
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
						index = 0;
						for(int i=0; i<(`DATA_WIDTH/8); i++) //For each strobe bit
						begin
							for(int j=0; j<8;j++)// for each byte
							begin
								if((input_packet.PSTRB>>i)&'d1)
									mask[index] = 1;	
								else
									mask[index] = 0;	
								index++;
							end
						end
						if(input_packet.PADDR[`ADDR_WIDTH-1:`ADDR_WIDTH-2] == 2'b11)
						begin
							$display("Writing to invalid address, will result in PSLVERR");
							PSLVERR =1;
						end
						else
						begin
            	mem[input_packet.PADDR] = (mem[input_packet.PADDR] & (~mask)) | (input_packet.PWDATA & mask);  // Write operation
							$display("Scoreboard writing %0d  data into memory at address %0d", mem[input_packet.PADDR], input_packet.PADDR);
						end
					end
				end

				begin
					wait(output_q.size() > 0);
					output_packet = output_q.pop_front();
					if(input_packet.PSELx == 1 && input_packet.PENABLE == 1 && input_packet.PWRITE == 0)
					begin
						$display("-------------------------Scoreboard @ %0t-------------------------", $time);
						$display("Field\t\t Expected\tActual");
						$display("PRDATA\t     %0d\t\t %0d", mem[input_packet.PADDR], output_packet.PRDATA);
						$display("PSLVERR\t     %0d\t\t %0d", PSLVERR, output_packet.PSLVERR);
						$display("PREADY\t     1\t\t %0d", output_packet.PREADY);

						if((mem[input_packet.PADDR] == output_packet.PRDATA) && (PSLVERR == output_packet.PSLVERR))
							$display("********************************************TEST PASSED********************************************");
						else
							$display("********************************************TEST FAILED********************************************");
					end
				end
			join

		end
	endtask : run_phase 
	
endclass : apb_slv_scoreboard
