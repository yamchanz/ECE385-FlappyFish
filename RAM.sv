/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameRAM
(
		input [8:0] read_address,
		//input we, Clk,
		input Clk,

		output logic [5:0] data_Out
);

// mem has width of 6 bits and a total of 204 addresses
logic [5:0] mem [0:203];

initial
begin
	 $readmemh("C:/Users/nyl20/Desktop/FlappyBird/sprite_bytes/redbird-midflap.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out <= mem[read_address];
end

endmodule
