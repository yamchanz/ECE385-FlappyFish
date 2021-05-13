// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

#define KEY0 	(*KEY_PIO & 0x1)
#define KEY1	(*KEY_PIO & 0x2)

int main()
{
	int i = 0;
	int WAIT = 0;
	unsigned int temp = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO  = (unsigned int*)0x60;
	volatile unsigned int *KEY_PIO = (unsigned int*)0x70;


	*LED_PIO = 0; //clear all LEDs
	while (1) //infinite loop
	{
		/* accumulation
		if(!KEY0){ // active low reset
			*LED_PIO = 0;
		}
		if(!KEY1 && !WAIT) { // active low accu
			temp += *SW_PIO;
			if(temp > 255) temp -= 255;
			*LED_PIO = temp;
			WAIT = 1;
		}
		if(KEY1) {
			WAIT = 0;
		} */
		/* blinking */
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}
