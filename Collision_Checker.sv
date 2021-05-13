module collision_checker (input  [9:0] BallX, BallY, PipeX, PipeY, PipeX2, PipeY2, PipeX3, PipeY3, PipeX4, PipeY4, Ball_size,
								  input	[9:0] CoinX, CoinY, CoinX2, CoinY2, CoinX3, CoinY3, CoinX4, CoinY4,
								  output logic Collection_Flag, Collection2_Flag, Collection3_Flag, Collection4_Flag, 
								  output logic Collision);
								  
	logic wall_collision, top_collision, side_collision, bot_collision;
	logic coin_collision, coin2_collision, coin3_collision, coin4_collision;

	parameter [9:0] Bird_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Bird_Y_Max=479;     // Bottommost point on the Y axis
	parameter [9:0] Pipe_Width=25;      // Pipe width
	parameter [9:0] Pipe_Rim_Width=5;	// Pipe Rim Width
	parameter [9:0] Pipe_Rim_Height=10; // Pipe Rim Height
	parameter [9:0] Pipe_Gap=80;        // Gap between top and bottom pipe
	
// # coin logic
	
	always_comb
	begin:Coin1
			if((BallX >= (CoinX - 2)) && (BallX <= (CoinX + 2)) && (BallY >= (CoinY - 2)) && (BallY <= (CoinY + 2)))
				coin_collision <= 1'b1;
			else 
				coin_collision <= 1'b0;
	end
	
	always_comb
	begin:Coin2
			if((BallX >= (CoinX2 - 2)) && (BallX <= (CoinX2 + 2)) && (BallY >= (CoinY2 - 2)) && (BallY <= (CoinY2 + 2)))
				coin2_collision <= 1'b1;
			else 
				coin2_collision <= 1'b0;
	end
	
	always_comb
	begin:Coin3
			if((BallX >= (CoinX3 - 2)) && (BallX <= (CoinX3 + 2)) && (BallY >= (CoinY3 - 2)) && (BallY <= (CoinY3 + 2)))
				coin3_collision <= 1'b1;
			else 
				coin3_collision <= 1'b0;
	end
	
	always_comb
	begin:Coin4
			if((BallX >= (CoinX4 - 2)) && (BallX <= (CoinX4 + 2)) && (BallY >= (CoinY4 - 2)) && (BallY <= (CoinY4 + 2)))
				coin4_collision <= 1'b1;
			else 
				coin4_collision <= 1'b0;
	end
// coin # logic end
								  
	always_comb
	begin:Wall_Collision_Logic
		// wall boundaries
			if((BallY < Bird_Y_Min) || (BallY >= (Bird_Y_Max - 20)))
				wall_collision <= 1'b1;
			else
				wall_collision <= 1'b0;
	end
	
	always_comb
	begin:Top_Collision_Logic
		// top of bird : (BallY - Ball_size)
			if ((BallX >= PipeX) && (BallX <= PipeX + Pipe_Width) && ((BallY - Ball_size) >= PipeY))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX - Pipe_Rim_Width) && (BallX <= PipeX + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >= PipeY) && ((BallY - Ball_size) <= PipeY + Pipe_Rim_Height))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX) && (BallX <= PipeX + Pipe_Width) && ((BallY - Ball_size) <= PipeY - Pipe_Gap))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX - Pipe_Rim_Width) && (BallX <= PipeX + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >=  PipeY - Pipe_Gap - Pipe_Rim_Height) && ((BallY - Ball_size) <= PipeY - Pipe_Gap))
				top_collision <= 1'b1;
	
			else if ((BallX >= PipeX2) && (BallX <= PipeX2 + Pipe_Width) && ((BallY - Ball_size) >= PipeY2))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX2 - Pipe_Rim_Width) && (BallX <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >= PipeY2) && ((BallY - Ball_size) <= PipeY2 + Pipe_Rim_Height))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX2) && (BallX <= PipeX2 + Pipe_Width) && ((BallY - Ball_size) <= PipeY2 - Pipe_Gap))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX2 - Pipe_Rim_Width) && (BallX <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >=  PipeY2 - Pipe_Gap - Pipe_Rim_Height) && ((BallY - Ball_size) <= PipeY2 - Pipe_Gap))
				top_collision <= 1'b1;
			
			else if ((BallX >= PipeX3) && (BallX <= PipeX3 + Pipe_Width) && ((BallY - Ball_size) >= PipeY3))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX3 - Pipe_Rim_Width) && (BallX <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >= PipeY3) && ((BallY - Ball_size) <= PipeY3 + Pipe_Rim_Height))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX3) && (BallX <= PipeX3 + Pipe_Width) && ((BallY - Ball_size) <= PipeY3 - Pipe_Gap))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX3 - Pipe_Rim_Width) && (BallX <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >=  PipeY3 - Pipe_Gap - Pipe_Rim_Height) && ((BallY - Ball_size) <= PipeY3 - Pipe_Gap))
				top_collision <= 1'b1;
				
			else if ((BallX >= PipeX4) && (BallX <= PipeX4 + Pipe_Width) && ((BallY - Ball_size) >= PipeY4))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX4 - Pipe_Rim_Width) && (BallX <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >= PipeY4) && ((BallY - Ball_size) <= PipeY4 + Pipe_Rim_Height))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX4) && (BallX <= PipeX4 + Pipe_Width) && ((BallY - Ball_size) <= PipeY4 - Pipe_Gap))
				top_collision <= 1'b1;
			else if ((BallX >= PipeX4 - Pipe_Rim_Width) && (BallX <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && ((BallY - Ball_size) >=  PipeY4 - Pipe_Gap - Pipe_Rim_Height) && ((BallY - Ball_size) <= PipeY4 - Pipe_Gap))
				top_collision <= 1'b1;
				
			else 
				top_collision <= 1'b0;
	end
	
	always_comb 
	begin:Side_Collision_Logic
		// front of bird : (BallX + Ball_size)
			if (((BallX + Ball_size) >= PipeX) && ((BallX + Ball_size) <= PipeX + Pipe_Width) && (BallY >= PipeY))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX + Pipe_Width + Pipe_Rim_Width) && (BallY >= PipeY) && (BallY <= PipeY + Pipe_Rim_Height))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX) && ((BallX + Ball_size) <= PipeX + Pipe_Width) && (BallY <= PipeY - Pipe_Gap))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX + Pipe_Width + Pipe_Rim_Width) && (BallY >=  PipeY - Pipe_Gap - Pipe_Rim_Height) && (BallY <= PipeY - Pipe_Gap))
				side_collision <= 1'b1;
	
			else if (((BallX + Ball_size) >= PipeX2) && ((BallX + Ball_size) <= PipeX2 + Pipe_Width) && (BallY >= PipeY2))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX2 - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && (BallY >= PipeY2) && (BallY <= PipeY2 + Pipe_Rim_Height))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX2) && ((BallX + Ball_size) <= PipeX2 + Pipe_Width) && (BallY <= PipeY2 - Pipe_Gap))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX2 - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && (BallY >=  PipeY2 - Pipe_Gap - Pipe_Rim_Height) && (BallY <= PipeY2 - Pipe_Gap))
				side_collision <= 1'b1;
			
			else if (((BallX + Ball_size) >= PipeX3) && ((BallX + Ball_size) <= PipeX3 + Pipe_Width) && (BallY >= PipeY3))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX3 - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && (BallY >= PipeY3) && (BallY <= PipeY3 + Pipe_Rim_Height))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX3) && ((BallX + Ball_size) <= PipeX3 + Pipe_Width) && (BallY <= PipeY3 - Pipe_Gap))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX3 - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && (BallY >=  PipeY3 - Pipe_Gap - Pipe_Rim_Height) && (BallY <= PipeY3 - Pipe_Gap))
				side_collision <= 1'b1;
				
			else if (((BallX + Ball_size) >= PipeX4) && ((BallX + Ball_size) <= PipeX4 + Pipe_Width) && (BallY >= PipeY4))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX4 - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && (BallY >= PipeY4) && (BallY <= PipeY4 + Pipe_Rim_Height))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX4) && ((BallX + Ball_size) <= PipeX4 + Pipe_Width) && (BallY <= PipeY4 - Pipe_Gap))
				side_collision <= 1'b1;
			else if (((BallX + Ball_size) >= PipeX4 - Pipe_Rim_Width) && ((BallX + Ball_size) <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && (BallY >=  PipeY4 - Pipe_Gap - Pipe_Rim_Height) && (BallY <= PipeY4 - Pipe_Gap))
				side_collision <= 1'b1;
				
			else 
				side_collision <= 1'b0;
			
	end
	
	always_comb
	begin:Bot_Collision_Logic
		// bottom of bird : (BallY + Ball_size)
			if ((BallX >= PipeX) && (BallX <= PipeX + Pipe_Width) && ((BallY + Ball_size) >= PipeY))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX - Pipe_Rim_Width) && (BallX <= PipeX + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >= PipeY) && ((BallY + Ball_size) <= PipeY + Pipe_Rim_Height))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX) && (BallX <= PipeX + Pipe_Width) && ((BallY + Ball_size) <= PipeY - Pipe_Gap))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX - Pipe_Rim_Width) && (BallX <= PipeX + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >=  PipeY - Pipe_Gap - Pipe_Rim_Height) && ((BallY + Ball_size) <= PipeY - Pipe_Gap))
				bot_collision <= 1'b1;
	
			else if ((BallX >= PipeX2) && (BallX <= PipeX2 + Pipe_Width) && ((BallY + Ball_size) >= PipeY2))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX2 - Pipe_Rim_Width) && (BallX <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >= PipeY2) && ((BallY + Ball_size) <= PipeY2 + Pipe_Rim_Height))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX2) && (BallX <= PipeX2 + Pipe_Width) && ((BallY + Ball_size) <= PipeY2 - Pipe_Gap))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX2 - Pipe_Rim_Width) && (BallX <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >=  PipeY2 - Pipe_Gap - Pipe_Rim_Height) && ((BallY + Ball_size) <= PipeY2 - Pipe_Gap))
				bot_collision <= 1'b1;
			
			else if ((BallX >= PipeX3) && (BallX <= PipeX3 + Pipe_Width) && ((BallY + Ball_size) >= PipeY3))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX3 - Pipe_Rim_Width) && (BallX <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >= PipeY3) && ((BallY + Ball_size) <= PipeY3 + Pipe_Rim_Height))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX3) && (BallX <= PipeX3 + Pipe_Width) && ((BallY + Ball_size) <= PipeY3 - Pipe_Gap))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX3 - Pipe_Rim_Width) && (BallX <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >=  PipeY3 - Pipe_Gap - Pipe_Rim_Height) && ((BallY + Ball_size) <= PipeY3 - Pipe_Gap))
				bot_collision <= 1'b1;
				
			else if ((BallX >= PipeX4) && (BallX <= PipeX4 + Pipe_Width) && ((BallY + Ball_size) >= PipeY4))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX4 - Pipe_Rim_Width) && (BallX <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >= PipeY4) && ((BallY + Ball_size) <= PipeY4 + Pipe_Rim_Height))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX4) && (BallX <= PipeX4 + Pipe_Width) && ((BallY + Ball_size) <= PipeY4 - Pipe_Gap))
				bot_collision <= 1'b1;
			else if ((BallX >= PipeX4 - Pipe_Rim_Width) && (BallX <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && ((BallY + Ball_size) >=  PipeY4 - Pipe_Gap - Pipe_Rim_Height) && ((BallY + Ball_size) <= PipeY4 - Pipe_Gap))
				bot_collision <= 1'b1;
				
			else 
				bot_collision <= 1'b0;
	end
		
	assign Collision = wall_collision || top_collision || side_collision || bot_collision;
	assign Collection_Flag = coin_collision;
	assign Collection2_Flag = coin2_collision;
	assign Collection3_Flag = coin3_collision;
	assign Collection4_Flag = coin4_collision;
	 
endmodule
