//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module FlappyFish (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output    [1:0]       DRAM_DQM,
     // output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, Continue_h, vssig, blank, sync, VGA_Clk;
logic [9:0] num_coins = 0;
logic [9:0] num_pipes = 0;
logic [9:0] difficulty = 1;
logic game_off = 1;
logic collision = 0;
logic coinfl = 1;
logic coinfl2 = 1;
logic coinfl3 = 1;
logic coinfl4 = 1;
logic pipefl = 0;
logic pipefl2 = 0;
logic pipefl3 = 0;
logic pipefl4 = 0;
logic collfl = 0;
logic collfl2 = 0;
logic collfl3 = 0;
logic collfl4 = 0;

//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [9:0] pipexsig, pipeysig, pipexsig2, pipeysig2, pipexsig3, pipeysig3, pipexsig4, pipeysig4;
	logic [9:0] coinxsig, coinysig, coinxsig2, coinysig2, coinxsig3, coinysig3, coinxsig4, coinysig4;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);
	//Assign one button to continue
	assign {Continue_h}=~ (KEY[1]);
	
	always_ff @ (posedge Reset_h or posedge Continue_h)
	begin
		if(Reset_h)
		begin
			game_off <= 1'b1;
			collision_on <= 1'b0;
			num_coins <= 10'b0;
			num_pipes <= 10'b0;
		end
		
		else if(Continue_h)
		begin
			game_off <= ~game_off;
			collision_on <= 1'b1;
		end
	end
	
	always_ff @ (posedge VGA_VS)
	begin
		case (keycode)
			8'h1E : begin // difficulty 1
				difficulty <= 1;
			end
			8'h1F : begin // difficulty 2
				difficulty <= 2;
			end
			8'h20 : begin // difficulty 3
				difficulty <= 3;
			end
			default: ;
		endcase 
	end
		
	always_ff @ (posedge pipefl or posedge pipefl2 or posedge pipefl3 or posedge pipefl4
				 or posedge collfl or posedge collfl2 or posedge collfl3 or posedge collfl4)
	begin
		if(pipefl)
		begin
			coinfl <= 1'b1;
			num_pipes  <= num_pipes + 1;
		end
		else if (pipefl2)
		begin
			coinfl2 <= 1'b1;
			num_pipes  <= num_pipes + 1;
		end
		else if (pipefl3)
		begin
			coinfl3 <= 1'b1;
			num_pipes  <= num_pipes + 1;
		end
		else if (pipefl4)
		begin
			coinfl4 <= 1'b1;
			num_pipes  <= num_pipes + 1;
		end
		else if (collfl)
		begin
			coinfl <= 1'b0;
			num_coins <= num_coins + 1;
		end
		else if (collfl2)
		begin
			coinfl2 <= 1'b0;
			num_coins <= num_coins + 1;
		end
		else if (collfl3)
		begin
			coinfl3 <= 1'b0;
			num_coins <= num_coins + 1;
		end
		else if (collfl4)
		begin
			coinfl4 <= 1'b0;
			num_coins <= num_coins + 1;
		end
	end

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm(DRAM_DQM),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
		//vga_controller
		vga_controller	 		vga(.*,
										.Clk(MAX10_CLK1_50),
										.Reset(Reset_h),
										.hs(VGA_HS),
										.vs(VGA_VS), 
										.pixel_clk(VGA_Clk),
										.blank(blank),
										.sync(sync),
										.DrawX(drawxsig),
										.DrawY(drawysig)
										);
		//bird
		bird 	Bird(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.bird_stop(game_off  || (collision_flag && collision_on)),
						.keycode(keycode),
						.BirdS(ballsizesig),
						.BirdX(ballxsig),
						.BirdY(ballysig),
						//.bird_speed(difficulty)
										);	
		
		//pipes
		pipe Pipe1(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.pipe_stop(game_off || (collision_flag && collision_on)),
						.PipeX0(0),
						.PipeY0(100),
						.PipeX(pipexsig),
						.PipeY(pipeysig),
						.pipe_num(3),
						.New_Pipe(pipefl),
						.pipe_speed(difficulty)
										);	
		pipe Pipe2(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.pipe_stop(game_off || (collision_flag && collision_on)),
						.PipeX0(152),
						.PipeY0(200),
						.PipeX(pipexsig2),
						.PipeY(pipeysig2),
						.pipe_num(7),
						.New_Pipe(pipefl2),
						.pipe_speed(difficulty)
										);	
		pipe Pipe3(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.pipe_stop(game_off || (collision_flag && collision_on)),
						.PipeX0(304),
						.PipeY0(300),
						.PipeX(pipexsig3),
						.PipeY(pipeysig3),
						.pipe_num(11),
						.New_Pipe(pipefl3),
						.pipe_speed(difficulty)
										);	
		pipe Pipe4(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.pipe_stop(game_off || (collision_flag && collision_on)),
						.PipeX0(456),
						.PipeY0(200),
						.PipeX(pipexsig4),
						.PipeY(pipeysig4),
						.pipe_num(13),
						.New_Pipe(pipefl4),
						.pipe_speed(difficulty)
										);	
		
		//coins
		coin Coin1(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.coin_stop(game_off || (collision_flag && collision_on)),
						.PipeX(pipexsig),
						.PipeY(pipeysig),
						.CoinX(coinxsig),
						.CoinY(coinysig)
										);	
		
		coin Coin2(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.coin_stop(game_off || (collision_flag && collision_on)),
						.PipeX(pipexsig2),
						.PipeY(pipeysig2),
						.CoinX(coinxsig2),
						.CoinY(coinysig2)
										);	
		
		coin Coin3(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.coin_stop(game_off || (collision_flag && collision_on)),
						.PipeX(pipexsig3),
						.PipeY(pipeysig3),
						.CoinX(coinxsig3),
						.CoinY(coinysig3)
										);	
		
		coin Coin4(.*,
						.Reset(Reset_h),
						.frame_clk(VGA_VS),
						.coin_stop(game_off || (collision_flag && collision_on)),
						.PipeX(pipexsig4),
						.PipeY(pipeysig4),
						.CoinX(coinxsig4),
						.CoinY(coinysig4)
										);	
		
		//Color_mapper
		color_mapper 	color(.*,
									.Clk(VGA_VS),
									.DrawX(drawxsig),
									.DrawY(drawysig),
									.Ball_size(ballsizesig),
									.BallX(ballxsig),
									.BallY(ballysig),
									.PipeX(pipexsig),
									.PipeY(pipeysig),
									.PipeX2(pipexsig2),
									.PipeY2(pipeysig2),		
									.PipeX3(pipexsig3),
									.PipeY3(pipeysig3),		
									.PipeX4(pipexsig4),
									.PipeY4(pipeysig4),
									.CoinX(coinxsig),
									.CoinY(coinysig),
									.Coin_Flag(coinfl),
									.CoinX2(coinxsig2),
									.CoinY2(coinysig2),
									.Coin2_Flag(coinfl2),
									.CoinX3(coinxsig3),
									.CoinY3(coinysig3),
									.Coin3_Flag(coinfl3),
									.CoinX4(coinxsig4),
									.CoinY4(coinysig4),
									.Coin4_Flag(coinfl4),
									.Difficulty_Flag(difficulty),
									.Red(Red),
									.Blue(Blue),
									.Green(Green),
									.Blank(blank)
						);	
		
		//Collision_Checker
		collision_checker cc(.*,
									.Ball_size(ballsizesig),
									.BallX(ballxsig),
									.BallY(ballysig),
									.PipeX(pipexsig),
									.PipeY(pipeysig),
									.PipeX2(pipexsig2),
									.PipeY2(pipeysig2),
									.PipeX3(pipexsig3),
									.PipeY3(pipeysig3),
									.PipeX4(pipexsig4),
									.PipeY4(pipeysig4),
									.CoinX(coinxsig),
									.CoinY(coinysig),
									.Collection_Flag(collfl),
									.CoinX2(coinxsig2),
									.CoinY2(coinysig2),
									.Collection2_Flag(collfl2),
									.CoinX3(coinxsig3),
									.CoinY3(coinysig3),
									.Collection3_Flag(collfl3),
									.CoinX4(coinxsig4),
									.CoinY4(coinysig4),
									.Collection4_Flag(collfl4),
									.Collision(collision_flag)
						);	
	
endmodule
