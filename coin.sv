module coin (  input Reset, frame_clk, coin_stop, //coin_disappear,
					input [9:0] PipeX, PipeY,
               output[9:0] CoinX, CoinY);
					
	logic [9:0] Coin_X_Pos, Coin_Y_Pos;
	
	parameter [9:0] Pipe_Width=25;      // Pipe width
	parameter [9:0] Pipe_Gap=80;        // Gap between top and bottom pipe
	
	always_ff @ (posedge Reset or posedge frame_clk)
	begin: Move_Coin	
		Coin_X_Pos <= (PipeX + Pipe_Width / 2);
		Coin_Y_Pos <= (PipeY - Pipe_Gap /2);
	end
	
	assign CoinX = Coin_X_Pos;
	assign CoinY = Coin_Y_Pos;
					
endmodule 