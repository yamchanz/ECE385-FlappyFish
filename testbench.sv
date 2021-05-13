module testbench ();

timeunit 1ns;

timeprecision 1ns;

logic [9:0] BallX, BallY, PipeX, PipeY, PipeX2, PipeY2, PipeX3, PipeY3, PipeX4, PipeY4, DrawX, DrawY, Ball_size;
logic [9:0] CoinX, CoinY, CoinX2, CoinY2, CoinX3, CoinY3, CoinX4, CoinY4, Difficulty_Flag;
logic	Clk, Coin_Flag, Coin2_Flag, Coin3_Flag, Coin4_Flag, Blank;
logic [7:0] Red, Green, Blue;


color_mapper cm(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION
Clk = 0;
end

always begin 
	Blank = 1;
#2;
	DrawX = 207;
#2;
	DrawY = 200;
#2;
	DrawX = 208;
#2;
	DrawX = 209;
#2;
	DrawX = 210;
#2;
	DrawX = 211;
#2;
	DrawX = 212;
#2;
	DrawX = 213;
#4;

end

/* 
logic [8:0] read_address;
logic CLK;
logic [5:0] data_Out;

frameRAM ram_test(.*, 
				.Clk(CLK));

always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin : CLOCK_INITIALIZATION
CLK = 0;
end

always begin 
	read_address = 9'd9;
#4
	read_address = 9'd23;
end

*/

endmodule
