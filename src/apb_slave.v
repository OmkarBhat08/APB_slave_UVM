/*
module apb_slave #(parameter ADDR_WIDTH=8, DATA_WIDTH = 8)(
    input         PCLK,      // Peripheral Clock
    input         PRESETn,   // Active Low Reset
    input         PSEL,      // Slave Select
    input         PENABLE,   // Enable Signal
    input         PWRITE,    // Write (1) / Read (0)
    input  [`ADDR_WIDTH-1:0]  PADDR,     // Address of Slave
    input  PSTRB,
    input  [`DATA_WIDTH-1:0]  PWDATA,    // Write Data
    output reg [`DATA_WIDTH-1:0] PRDATA, // Read Data
    output reg       PREADY,
    output reg       PSLVERR
);

  parameter N = 4;  // Number of wait states

  reg [7:0] mem [0:7]; // 8x8-bit memory
  reg [2:0] wait_counter;  // Counter for wait states
  reg transaction_active = 0;  //  indicate an active transaction

  always @(posedge PCLK or negedge PRESETn) 
	begin
    if (!PRESETn) 
		begin
			$display("\n\n ENtered reset");
      PREADY  <= 0;
      PSLVERR <= 0;
      PRDATA  <= 8'b0;
      transaction_active <= 0;
      wait_counter <= 0;

      for (integer i = 0; i < 8; i = i + 1) 
			begin
        mem[i] <= 8'b0;
      end
    end
    else 
		begin
      PSLVERR <= 0; // Default no error

      if (PSEL && PENABLE && !transaction_active) 
			begin
        transaction_active <= 1; // Start kardenge transaction
        wait_counter <= 0;       //  counter==0
        PREADY <= 0;             // Enter wait state
      end

      if (transaction_active) 
			begin
				$display("\n\n Entered transaction");
        if (wait_counter < N - 1) 
				begin
          wait_counter <= wait_counter + 1; // Incrementing wait counter
        end
        else 
				begin
					$display("\n\n Entered working");
          PREADY <= 1;  // Transaction complete hogya
          transaction_active <= 0; // Reset transaction flag

          if (PWRITE) 
					begin
            if (PADDR == 8'h10 || PADDR == 8'h11) begin
              PSLVERR <= 1;  // Invalid address, assert error
            end
            else 
						begin
              mem[PADDR[2:0]] <= PWDATA;  // Write operation
							$display("\n\n Design writing into memory");
            end
          end
          else begin
            PRDATA <= mem[PADDR[2:0]]; // Read operation
          end
        end
      end
      else begin
        PREADY <= 0;
      end
    end
  end
endmodule
*/
module apb_slave #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 8)
(
  input                        clk,
  input                        rst_n,
  input        [ADDR_WIDTH-1:0] paddr,
  input                        pwrite,
  input                        psel,
  input                        penable,
  input        [DATA_WIDTH-1:0]     pwdata,
  input                  pstrb,
  output logic [DATA_WIDTH-1:0]     prdata,
  output logic                 pready, 
  output logic                 pslverr
);
 
 //pslverr = 0 ;
 logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

 typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
 state_t present_state, next_state;

 // State Register
 always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n)
   present_state <= IDLE;
  else
   present_state <= next_state;
 end

 // Next State and Output Logic
 always_comb begin
  // Default values
  next_state = IDLE;
  pready = 1'b0;
  prdata = '0;
  pslverr = 0 ;
  case (present_state)
   IDLE: 
		begin
		$display("Design in IDLE");
    if (psel)
     next_state = SETUP;
    else
     next_state = IDLE;
   end
   SETUP: begin
		$display("Design in SETUP psel=%b | penable =%b", psel, penable);
    pready = 1'b0;
    if (penable)
     next_state = ACCESS;
    else
     next_state = SETUP;
   end
   ACCESS: begin
		$display("Design in ACCESS");
    pready = 1'b1;
    if(pwrite) begin
		$display("Writing in Design paddr:%0d pwdata:%0d",paddr,pwdata );
     mem[paddr] = pwdata;
    end else begin
		$display("Reading in Design paddr:%0d pwdata:%0d",paddr,pwdata);
     prdata = mem[paddr];
    end
    next_state = IDLE;
   end
   default: next_state = IDLE;
  endcase
 end

endmodule
