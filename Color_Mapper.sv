//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, PipeX, PipeY, PipeX2, PipeY2, PipeX3, PipeY3, PipeX4, PipeY4, DrawX, DrawY, Ball_size,
							  input 			[9:0] CoinX, CoinY, CoinX2, CoinY2, CoinX3, CoinY3, CoinX4, CoinY4, Difficulty_Flag,
							  input 			Clk, Coin_Flag, Coin2_Flag, Coin3_Flag, Coin4_Flag, Blank, 
                       output logic [7:0] Red, Green, Blue );
							  
    
    logic ball_on, wing_on, eye_on, pupil_on, topgill_on, botgill_on;
	 logic pipe_on, pipe2_on, pipe3_on, pipe4_on;
	 logic coin_on, coin2_on, coin3_on, coin4_on;
	 logic diff_on;
	 
	 parameter [9:0] Pipe_Width=25;      // Pipe width
	 parameter [9:0] Pipe_Rim_Width=5;	 // Pipe Rim Width
	 parameter [9:0] Pipe_Rim_Height=10; // Pipe Rim Height
	 parameter [9:0] Pipe_Gap=80;        // Gap between top and bottom pipe

	 /*
	 logic shape_on;
	 logic [10:0] shape_x = 200;
	 logic [10:0] shape_y = 200;
	 logic [10:0] shape_size_x = 17;
	 logic [10:0] shape_size_y = 12;
	 
	 logic [8:0] sprite_bird_addr;
	 logic [5:0] sprite_bird_data; */
	 
	 // # turn on
	 /* frameRAM   ram(.*,
				  .Clk(Clk),
				  .read_address(sprite_bird_addr),
				  .data_Out(sprite_bird_data) ); */

	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
//bird params  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 int WDistX, WDistY, WSize;
	 assign WDistX = DrawX - (BallX - 4);
    assign WDistY = DrawY - BallY;
    assign WSize = Ball_size - 3;
	 
	 int EDistX, EDistY, ESize;
	 assign EDistX = DrawX - (BallX + 2);
    assign EDistY = DrawY - (BallY - 2);
    assign ESize = Ball_size - 4;
	 
	 int PDistX, PDistY, PSize;
	 assign PDistX = DrawX - (BallX + 3);
    assign PDistY = DrawY - (BallY - 2);
    assign PSize = Ball_size - 5;
	 
	 int TGDistX, TGDistY, TGSize;
	 assign TGDistX = DrawX - (BallX - 5);
    assign TGDistY = DrawY - (BallY - 2);
    assign TGSize = Ball_size - 3;
	 
	 int BGDistX, BGDistY, BGSize;
	 assign BGDistX = DrawX - (BallX - 5);
    assign BGDistY = DrawY - (BallY + 2);
    assign BGSize = Ball_size - 3;
	
	 
// coin params
	 int CDistX, CDistY, Coin_size;
	 assign CDistX = DrawX - CoinX;
    assign CDistY = DrawY - CoinY;
	 assign Coin_size = 5;
	 
	 int C2DistX, C2DistY;
	 assign C2DistX = DrawX - CoinX2;
    assign C2DistY = DrawY - CoinY2;
	 
	 int C3DistX, C3DistY;
	 assign C3DistX = DrawX - CoinX3;
    assign C3DistY = DrawY - CoinY3;
	 
	 int C4DistX, C4DistY;
	 assign C4DistX = DrawX - CoinX4;
    assign C4DistY = DrawY - CoinY4;
	 
//difficulty
	 int DiffX, DiffY, Diff_size;
	 assign DiffX = DrawX - 620;
    assign DiffY = DrawY - 10;
    assign Diff_size = 3;
	 
	 // # turn on
	 /* always_comb
	 begin:Ball_on_proc
			if((DrawX >= shape_x) && (DrawX < shape_x + shape_size_x) && (DrawY >= shape_y) && (DrawY < shape_y + shape_size_y))
			begin
				shape_on = 1'b1;
				//sprite_bird_addr = (DrawY - shape_y + 16*'h48); // x_diff + width * y_diff  
				sprite_bird_addr = (DrawX - shape_x) + (DrawY - shape_y) * shape_size_x;
			end 
				
			else 
			begin
				shape_on = 1'b0;
				sprite_bird_addr = 10'b0;
			end
	 end */
	 
	 always_comb
    begin:Diff_on_proc
        if ( ( DiffX*DiffX + DiffY*DiffY) <= (Diff_size * Diff_size) ) 
            diff_on = 1'b1;
        else 
            diff_on = 1'b0;
    end 
	  
	 // # turn off
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end 
	 
	 always_comb
    begin:Wing_on_proc
        if ( ( WDistX*WDistX + WDistY*WDistY) <= (WSize * WSize) ) 
            wing_on = 1'b1;
        else 
            wing_on = 1'b0;
    end 
	 
	 always_comb
    begin:Eye_on_proc
        if ( ( EDistX*EDistX + EDistY*EDistY) <= (ESize * ESize) ) 
            eye_on = 1'b1;
        else 
            eye_on = 1'b0;
    end 
	 
	 always_comb
    begin:Pupil_on_proc
        if ( ( PDistX*PDistX + PDistY*PDistY) <= (PSize * PSize) ) 
            pupil_on = 1'b1;
        else 
            pupil_on = 1'b0;
    end 
 
	 always_comb
    begin:Topgill_on_proc
        if ( ( TGDistX*TGDistX + TGDistY*TGDistY) <= (TGSize * TGSize) ) 
            topgill_on = 1'b1;
        else 
            topgill_on = 1'b0;
    end 
	 
	 always_comb
    begin:Botgill_on_proc
        if ( ( BGDistX*BGDistX + BGDistY*BGDistY) <= (BGSize * BGSize) ) 
            botgill_on = 1'b1;
        else 
            botgill_on = 1'b0;
    end 
	 
	 
	 always_comb
    begin:Coin_Logic
        if ( ( CDistX*CDistX + CDistY*CDistY) <= (Coin_size * Coin_size) ) 
            coin_on = 1'b1;
        else 
            coin_on = 1'b0;
    end
	 
	 always_comb
    begin:Coin2_Logic
        if ( ( C2DistX*C2DistX + C2DistY*C2DistY) <= (Coin_size * Coin_size) ) 
            coin2_on = 1'b1;
        else 
            coin2_on = 1'b0;
    end
	 
	 always_comb
    begin:Coin3_Logic
        if ( ( C3DistX*C3DistX + C3DistY*C3DistY) <= (Coin_size * Coin_size) ) 
            coin3_on = 1'b1;
        else 
            coin3_on = 1'b0;
    end
	 
	 always_comb
    begin:Coin4_Logic
        if ( ( C4DistX*C4DistX + C4DistY*C4DistY) <= (Coin_size * Coin_size) ) 
            coin4_on = 1'b1;
        else 
            coin4_on = 1'b0;
    end
	  
	 always_comb 
	 begin:Pipe_Logic
		// bottom pipe
		if ((DrawX >= PipeX) && (DrawX <= PipeX + Pipe_Width) && (DrawY >= PipeY))
				pipe_on = 1'b1;
		// bottom rim 
		else if ((DrawX >= PipeX - Pipe_Rim_Width) && (DrawX <= PipeX + Pipe_Width + Pipe_Rim_Width) && (DrawY >= PipeY) && (DrawY <= PipeY + Pipe_Rim_Height))
				pipe_on = 1'b1;
		// top pipe
		else if ((DrawX >= PipeX) && (DrawX <= PipeX + Pipe_Width) && (DrawY <= PipeY - Pipe_Gap))
				pipe_on = 1'b1;
		// top rim
		else if ((DrawX >= PipeX - Pipe_Rim_Width) && (DrawX <= PipeX + Pipe_Width + Pipe_Rim_Width) && (DrawY >=  PipeY - Pipe_Gap - Pipe_Rim_Height) && (DrawY <= PipeY - Pipe_Gap))
				pipe_on = 1'b1;
		else
				pipe_on = 1'b0;
	 end
    
	 always_comb 
	 begin:Pipe2_Logic
		if ((DrawX >= PipeX2) && (DrawX <= PipeX2 + Pipe_Width) && (DrawY >= PipeY2))
				pipe2_on = 1'b1;
		else if ((DrawX >= PipeX2 - Pipe_Rim_Width) && (DrawX <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && (DrawY >= PipeY2) && (DrawY <= PipeY2 + Pipe_Rim_Height))
				pipe2_on = 1'b1;
		else if ((DrawX >= PipeX2) && (DrawX <= PipeX2 + Pipe_Width) && (DrawY <= PipeY2 - Pipe_Gap))
				pipe2_on = 1'b1;
		else if ((DrawX >= PipeX2 - Pipe_Rim_Width) && (DrawX <= PipeX2 + Pipe_Width + Pipe_Rim_Width) && (DrawY >=  PipeY2 - Pipe_Gap - Pipe_Rim_Height) && (DrawY <= PipeY2 - Pipe_Gap))
				pipe2_on = 1'b1;
		else
				pipe2_on = 1'b0;
	 end
	 
	 always_comb 
	 begin:Pipe3_Logic
		if ((DrawX >= PipeX3) && (DrawX <= PipeX3 + Pipe_Width) && (DrawY >= PipeY3))
				pipe3_on = 1'b1;
		else if ((DrawX >= PipeX3 - Pipe_Rim_Width) && (DrawX <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && (DrawY >= PipeY3) && (DrawY <= PipeY3 + Pipe_Rim_Height))
				pipe3_on = 1'b1;
		else if ((DrawX >= PipeX3) && (DrawX <= PipeX3 + Pipe_Width) && (DrawY <= PipeY3 - Pipe_Gap))
				pipe3_on = 1'b1;
		else if ((DrawX >= PipeX3 - Pipe_Rim_Width) && (DrawX <= PipeX3 + Pipe_Width + Pipe_Rim_Width) && (DrawY >=  PipeY3 - Pipe_Gap - Pipe_Rim_Height) && (DrawY <= PipeY3 - Pipe_Gap))
				pipe3_on = 1'b1;
		else
				pipe3_on = 1'b0;
	 end
	 
	 always_comb 
	 begin:Pipe4_Logic
		if ((DrawX >= PipeX4) && (DrawX <= PipeX4 + Pipe_Width) && (DrawY >= PipeY4))
				pipe4_on = 1'b1;
		else if ((DrawX >= PipeX4 - Pipe_Rim_Width) && (DrawX <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && (DrawY >= PipeY4) && (DrawY <= PipeY4 + Pipe_Rim_Height))
				pipe4_on = 1'b1;
		else if ((DrawX >= PipeX4) && (DrawX <= PipeX4 + Pipe_Width) && (DrawY <= PipeY4 - Pipe_Gap))
				pipe4_on = 1'b1;
		else if ((DrawX >= PipeX4 - Pipe_Rim_Width) && (DrawX <= PipeX4 + Pipe_Width + Pipe_Rim_Width) && (DrawY >=  PipeY4 - Pipe_Gap - Pipe_Rim_Height) && (DrawY <= PipeY4 - Pipe_Gap))
				pipe4_on = 1'b1;
		else
				pipe4_on = 1'b0;
	 end
		 
    always_comb
    begin:RGB_Display
		if(Blank == 1)
		begin			
			// # turn off
		  
		  if ((pupil_on == 1'b1))
		  begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
		  end
		  
		  else if ((eye_on == 1'b1))
		  begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  
		  else if ((wing_on == 1'b1))
		  begin
				Red = 8'hff;
				Green = 8'hdd;
				Blue = 8'hbb;
		  end
		  
		  else if ((ball_on == 1'b1)) 
		  begin 
				Red = 8'hff;
				Green = 8'h71;
				Blue = 8'h5e;
		  end 
		  
		  else if ((topgill_on == 1'b1)) 
		  begin 
				Red = 8'hff;
				Green = 8'h71;
				Blue = 8'h5e;
		  end 
		  
		  else if ((botgill_on == 1'b1)) 
		  begin 
				Red = 8'hff;
				Green = 8'h71;
				Blue = 8'h5e;
		  end 


			// # turn on
		  /* if (shape_on == 1'b1)
		  begin
			case(sprite_bird_data)
				6'h0:
				begin
					Red = 8'hfa;
					Green = 8'hfa;
					Blue = 8'hfa;
				end
				6'h1:
				begin
					Red = 8'hd4;
					Green = 8'h2b;
					Blue = 8'h00;
				end
				6'h2:
				begin
					Red = 8'hfc;
					Green = 8'h35;
					Blue = 8'h00;
				end
				6'h3:
				begin
					Red = 8'hfc;
					Green = 8'h74;
					Blue = 8'h07;
				end
				6'h4:
				begin
					Red = 8'hf8;
					Green = 8'hb8;
					Blue = 8'h30;
				end
				6'h5:
				begin
					Red = 8'hd8;
					Green = 8'he7;
					Blue = 8'hcd;
				end
				default:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
			endcase
		  end */
			
		  else if ((coin_on == 1'b1) && (Coin_Flag == 1'b1))
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  
		  else if ((coin2_on == 1'b1) && (Coin2_Flag == 1'b1))
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  
		  else if ((coin3_on == 1'b1) && (Coin3_Flag == 1'b1))
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  
		  else if ((coin4_on == 1'b1) && (Coin4_Flag == 1'b1))
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  
		  else if ((pipe_on == 1'b1))
		  begin
				Red = 8'h15;
				if(DrawX < PipeX)
					Green = 8'hdd;
				else if(DrawX - PipeX > 20)
					Green = 8'h82;
				else if (DrawX - PipeX > 10)
					Green = 8'hb8;
				else
					Green = 8'hdd;
            Blue = 8'h34;
		  end
		  
		  else if ((pipe2_on == 1'b1))
		  begin
				Red = 8'h15;
				if(DrawX < PipeX2)
					Green = 8'hdd;
				else if(DrawX - PipeX2 > 20)
					Green = 8'h82;
				else if (DrawX - PipeX2 > 10)
					Green = 8'hb8;
				else
					Green = 8'hdd;
            Blue = 8'h34;
		  end
		  
		  else if ((pipe3_on == 1'b1))
		  begin
				Red = 8'h15;
				if(DrawX < PipeX3)
					Green = 8'hdd;
				else if(DrawX - PipeX3 > 20)
					Green = 8'h82;
				else if (DrawX - PipeX3 > 10)
					Green = 8'hb8;
				else
					Green = 8'hdd;
            Blue = 8'h34;
		  end
		  
		  else if ((pipe4_on == 1'b1))
		  begin
				Red = 8'h15;
				if(DrawX < PipeX4)
					Green = 8'hdd;
				else if(DrawX - PipeX4 > 20)
					Green = 8'h82;
				else if (DrawX - PipeX4 > 10)
					Green = 8'hb8;
				else
					Green = 8'hdd;
            Blue = 8'h34;
		  end
		  
        else 
        begin 
            Red = 8'h38; 
            Green = 8'hb4;
				// Blue = 8'h7f - DrawX[9:3];
				Blue = 8'hd6;
        end 
		end
		else
		begin
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
		end
		
		//grass
		if(DrawY > 465 && DrawY <= 469)
		begin
				Red = 8'h00;
            Green = 8'hb8;
            Blue = 8'h34;
		end
		
		//ground
		if(DrawY > 469 && DrawY <= 479)
		begin
				Red = 8'hff;
            Green = 8'hce;
            Blue = 8'h80;
		end
			
		//difficulty
		if((diff_on == 1'b1))
		begin
			case(Difficulty_Flag)
				10'h1: 
				begin
					Red = 8'h00;
					Green = 8'hff;
					Blue = 8'h00;
				end
				10'h2:
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'h00;
				end
				10'h3:
				begin
					Red = 8'hff;
					Green = 8'h00;
					Blue = 8'h00;
				end
				default:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
			endcase
		end
    end 
    
endmodule
