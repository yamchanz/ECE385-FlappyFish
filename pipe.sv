module  pipe ( input Reset, frame_clk, pipe_stop, 
					input [9:0] pipe_num, pipe_speed,
					input [9:0] PipeX0, PipeY0,
               output[9:0] PipeX, PipeY,
					output New_Pipe);

	// coordinates point to top-left corner of pipe
	logic [9:0] Pipe_X_Pos, Pipe_Y_Pos, Counter;
	logic flag = 1'b0;
	logic new_pipe = 1'b0;

	parameter [9:0] Pipe_X_Velocity=-1; // Pipe speed fixed and from right to left
	parameter [9:0] Pipe_Width=25;      // Pipe width
	parameter [9:0] Pipe_X_Min=6;       // Leftmost point on the X axis
	parameter [9:0] Pipe_X_Max=639;     // Rightmost point on the X axis
	parameter [9:0] Pipe_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Pipe_Y_Max=479;     // Bottommost point on the Y axis
	
	always_ff @ (posedge Reset or posedge frame_clk)
	begin: Move_Pipe	
		if (Reset)  // Asynchronous Reset
		begin
			flag <= 1'b0;
		end
		
		else if(!flag)
		begin
			Pipe_X_Pos <= PipeX0;
			Pipe_Y_Pos <= PipeY0;
			flag <= 1'b1;
		end
		
		else if(pipe_stop)
		begin
			Pipe_X_Pos <= Pipe_X_Pos;
			Pipe_Y_Pos <= Pipe_Y_Pos;
		end
		
		else
		begin
			Pipe_X_Pos <= Pipe_X_Pos + (Pipe_X_Velocity * pipe_speed);
			new_pipe <= 1'b0;
			if(Pipe_X_Pos < Pipe_X_Min)
			begin
				new_pipe <= 1'b1;
				Pipe_X_Pos <= Pipe_X_Max - Pipe_Width;
				Pipe_Y_Pos <= (Counter % 360) + 100;
			end
			Counter <= Counter + pipe_num;
		end 	
	end
	
	assign PipeX = Pipe_X_Pos;
	assign PipeY = Pipe_Y_Pos;	
	assign New_Pipe = new_pipe;
					
endmodule 