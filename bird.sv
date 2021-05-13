
module  bird ( input Reset, frame_clk, bird_stop,
					input [7:0] keycode,
               output[9:0] BirdX, BirdY, BirdS);

	logic [9:0] Bird_Y_Pos, Bird_Y_Velocity, Bird_Size, Counter;

	parameter [9:0] Bird_X_Center=190;  // Center position on the X axis
	parameter [9:0] Bird_Y_Center=240;  // Center position on the Y axis
	parameter [9:0] Bird_X_Min=0;       // Leftmost point on the X axis
	parameter [9:0] Bird_X_Max=639;     // Rightmost point on the X axis
	parameter [9:0] Bird_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Bird_Y_Max=479;     // Bottommost point on the Y axis
	parameter [9:0] Bird_X_Step=1;      // Step size on the X axis
	parameter [9:0] Bird_Y_Step=1;      // Step size on the Y axis

	assign Bird_Size = 6;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	assign Gravity = 1;

	always_ff @ (posedge Reset or posedge frame_clk )
	begin: Move_Bird
		if (Reset)  // Asynchronous Reset
		begin
			Bird_Y_Velocity <= 10'd0;
			Bird_Y_Pos <= Bird_Y_Center;
		end
		
		else if (bird_stop)
		begin
			Bird_Y_Velocity <= 10'd0;
			Bird_Y_Pos <= Bird_Y_Pos;
		end

		else // Movement
		begin
			Counter <= Counter + 1;
			if ( (Bird_Y_Pos + Bird_Size) >= Bird_Y_Max )  // Bird is at the bottom edge, BOUNCE!
				Bird_Y_Velocity <= (~ (Bird_Y_Step) + 1'b1);  // 2's complement.

			else if ( (Bird_Y_Pos - Bird_Size) <= Bird_Y_Min )  // Bird is at the top edge, BOUNCE!
				Bird_Y_Velocity <= Bird_Y_Step;

			else
				Bird_Y_Velocity <= Bird_Y_Velocity;  // Bird is somewhere in the middle, don't bounce, just keep moving

			case (keycode)
				8'h1A : begin // W
					Bird_Y_Velocity <= -5;
					// Bird_Y_Acceleration <= 0;
				end
				8'h16 : begin // S
					Bird_Y_Velocity <= 1;
				end
				default: ;
			endcase

			if(Counter == 5)
			begin
				Bird_Y_Velocity <= (Bird_Y_Velocity + Gravity); // Update bird speed
				Counter <= 0;
			end
			// Bird_Y_Velocity <= (Bird_Y_Velocity + Gravity); // Update bird speed
			Bird_Y_Pos <= (Bird_Y_Pos + Bird_Y_Velocity);  // Update bird position
			
		end
	end

	assign BirdX = Bird_X_Center;
	assign BirdY = Bird_Y_Pos;	
	assign BirdS = Bird_Size;

endmodule
