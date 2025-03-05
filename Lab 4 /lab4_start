/* Author: Jennifer Stander
 * Course: ECE3829
 * Project: Lab 4
 * Description: Starting project for Lab 4.
 * Implements two functions
 * 1- reading switches and lighting their corresponding LED
 * 2 - It outputs a middle C tone to the AMP2
 * It also initializes the anode and segment of the 7-seg display
 * for future development
 */


// Header Inclusions
/* xparameters.h set parameters names
 like XPAR_AXI_GPIO_0_DEVICE_ID that are referenced in you code
 each hardware module as a section in this file.
*/
#include "xparameters.h"
/* each hardware module type as a set commands you can use to
 * configure and access it. xgpio.h defines API commands for your gpio modules
 */
#include "xgpio.h"
/* this defines the recommend types like u32 */
#include "xil_types.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "sleep.h"
#include "xtmrctr.h"


void check_switches(u32 *sw_data, u32 *sw_data_old, u32 *sw_changes);
void update_LEDs(u32 led_data);
void update_amp2(u32 *amp2_data, u32 target_count, u32 *last_count);
void check_buttons(u32 *btn_data, u32 *btn_data_old, u32 *btn_changes);
u32 find_count(u32 sw_data, u32 btn_data);
void update_sevenseg (u32 btn_data);


// Block Design Details
/* Timer device ID
 */
#define TMRCTR_DEVICE_ID XPAR_TMRCTR_0_DEVICE_ID
#define TIMER_COUNTER_0 0


/* LED are assigned to GPIO (CH 1) GPIO_0 Device
 * DIP Switches are assigned to GPIO2 (CH 2) GPIO_0 Device
 */
#define GPIO0_ID XPAR_GPIO_0_DEVICE_ID
#define GPIO0_LED_CH 1
#define GPIO0_SW_CH 2
// 16-bits of LED outputs (not tristated)
#define GPIO0_LED_TRI 0x00000000
#define GPIO0_LED_MASK 0x0000FFFF
// 16-bits SW inputs (tristated)
#define GPIO0_SW_TRI 0x0000FFFF
#define GPIO0_SW_MASK 0x0000FFFF

/*  7-SEG Anodes are assigned to GPIO (CH 1) GPIO_1 Device
 *  7-SEG Cathodes are assined to GPIO (CH 2) GPIO_1 Device
 */
#define GPIO1_ID XPAR_GPIO_1_DEVICE_ID
#define GPIO1_ANODE_CH 1
#define GPIO1_CATHODE_CH 2
//4-bits of anode outputs (not tristated)
#define GPIO1_ANODE_TRI 0x00000000
#define GPIO1_ANODE_MASK 0x0000000F
//8-bits of cathode outputs (not tristated)
#define GPIO1_CATHODE_TRI 0x00000000
#define GPIO1_CATHODE_MASK 0x000000FF

// Push buttons are assigned to GPIO (CH_1) GPIO_2 Device
#define GPIO2_ID XPAR_GPIO_2_DEVICE_ID
#define GPIO2_BTN_CH 1
// 4-bits of push button (not tristated)
#define GPIO2_BTN_TRI 0x00000000
#define GPIO2_BTN_MASK 0x0000000F

// AMP2 pins are assigned to GPIO (CH1 1) GPIO_3 device
#define GPIO3_ID XPAR_GPIO_3_DEVICE_ID
#define GPIO3_AMP2_CH 1
#define GPIO3_AMP2_TRI 0xFFFFFFF4
#define GPIO3_AMP2_MASK 0x00000001

#define CLOCKS_PER_SECOND 100000000
#define NOTE_PERIOD (CLOCKS_PER_SECOND/4)

// Timer Device instance
XTmrCtr TimerCounter;

// GPIO Driver Device
XGpio device0;
XGpio device1;
XGpio device2;
XGpio device3;

// IP Tutorial  Main
int main() {
	u32 sw_data = 0;
	u32 sw_data_old = 0;
	// bit[3] = SHUTDOWN_L and bit[1] = GAIN, bit[0] = Audio Input
	u32 amp2_data = 0x8;
	u32 target_count = 0xffffffff;
	u32 last_count = 0;
	u32 sw_changes = 0;

	u32 btn_data = 0;
	u32 btn_data_old = 0;
	u32 btn_changes = 0;


	XStatus status;


	//Initialize timer
	status = XTmrCtr_Initialize(&TimerCounter, XPAR_TMRCTR_0_DEVICE_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization Timer failed\n\r");
		return 1;
	}
	//Make sure the timer is working
	status = XTmrCtr_SelfTest(&TimerCounter, TIMER_COUNTER_0);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization Timer failed\n\r");
		return 1;
	}
	//Configure the timer to Autoreload
	XTmrCtr_SetOptions(&TimerCounter, TIMER_COUNTER_0, XTC_AUTO_RELOAD_OPTION);
	//Initialize your timer values
	//Start your timer
	XTmrCtr_Start(&TimerCounter, TIMER_COUNTER_0);



	// Initialize the GPIO devices
	status = XGpio_Initialize(&device0, GPIO0_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_0 failed\n\r");
		return 1;
	}
	status = XGpio_Initialize(&device1, GPIO1_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_1 failed\n\r");
		return 1;
	}
	status = XGpio_Initialize(&device2, GPIO2_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_2 failed\n\r");
		return 1;
	}
	status = XGpio_Initialize(&device3, GPIO3_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_3 failed\n\r");
		return 1;
	}

	// Set directions for data ports tristates, '1' for input, '0' for output
	XGpio_SetDataDirection(&device0, GPIO0_LED_CH, GPIO0_LED_TRI);
	XGpio_SetDataDirection(&device0, GPIO0_SW_CH, GPIO0_SW_TRI);
	XGpio_SetDataDirection(&device1, GPIO1_ANODE_CH, GPIO1_ANODE_TRI);
	XGpio_SetDataDirection(&device1, GPIO1_CATHODE_CH, GPIO1_CATHODE_TRI);
	XGpio_SetDataDirection(&device2, GPIO2_BTN_CH, GPIO2_BTN_TRI);
	XGpio_SetDataDirection(&device3, GPIO3_AMP2_CH, GPIO3_AMP2_TRI);

	xil_printf("Demo initialized successfully\n\r");

	XGpio_DiscreteWrite(&device3, GPIO3_AMP2_CH, amp2_data);

	// this loop checks for changes in the input switches
	// if they changed it updates the LED outputs to match the switch values.
	// target_count = (period of sound)/(2*10nsec)), 10nsec is the processor clock frequency
	// example count is middle C (C4) = 191110 count (261.62 Hz)
	//target_count = (1.0/(2.0*261.62*10e-9));

	//turn on Anode for Display 4
	XGpio_DiscreteWrite(&device1, GPIO1_ANODE_CH, 0b1110);

	double start_freq[] = {130.81, 146.83, 164.81, 174.61, 196};

	for (u32 current_note = 0; current_note < 5; current_note++) {

		u32 starting_count = XTmrCtr_GetValue(&TimerCounter, TIMER_COUNTER_0);
		target_count = (1.0/(2.0*start_freq[current_note]*10e-9));
		u32 current_count = 0;

		while (current_count < (starting_count + NOTE_PERIOD)) {
			update_amp2(&amp2_data, target_count, &last_count);
			current_count = XTmrCtr_GetValue(&TimerCounter, TIMER_COUNTER_0);
		}

	}





	while (1) {
		check_switches(&sw_data, &sw_data_old, &sw_changes);
		if (sw_changes) update_LEDs(sw_data);

		check_buttons(&btn_data, &btn_data_old, &btn_changes);

		if (sw_changes || btn_changes){
			target_count = find_count(sw_data & 0x03, btn_data & 0x07);
		}

		if (btn_changes) update_sevenseg(btn_data);

		update_amp2(&amp2_data, target_count, &last_count);
	}

}

// reads the value of the input switches and outputs if there were changes from last time
void check_switches(u32 *sw_data, u32 *sw_data_old, u32 *sw_changes) {
	*sw_data = XGpio_DiscreteRead(&device0, GPIO0_SW_CH);
	*sw_data &= GPIO0_SW_MASK;
	*sw_changes = 0;
	if (*sw_data != *sw_data_old) {
		// When any bswitch is toggled, the LED values are updated
		//  and report the state over UART.
		*sw_changes = *sw_data ^ *sw_data_old;
		*sw_data_old = *sw_data;
	}
}

// writes the value of led_data to the LED pins
void update_LEDs(u32 led_data) {
	led_data = (led_data) & GPIO0_LED_MASK;
	XGpio_DiscreteWrite(&device0, GPIO0_LED_CH, led_data);
}

// if the current count is - last_count > target_count toggle the amp2 output
void update_amp2(u32 *amp2_data, u32 target_count, u32 *last_count) {
	u32 current_count = XTmrCtr_GetValue(&TimerCounter, TIMER_COUNTER_0);
	if ((current_count - *last_count) > target_count) {
		// toggling the LSB of amp2 data
		*amp2_data = ((*amp2_data & 0x01) == 0) ? (*amp2_data | 0x1) : (*amp2_data & 0xe);
		XGpio_DiscreteWrite(&device3, GPIO3_AMP2_CH, *amp2_data );
		*last_count = current_count;
	}
}


// reads the value of the buttons and outputs if there were changes from last time
void check_buttons(u32 *btn_data, u32 *btn_data_old, u32 *btn_changes) {
	*btn_data = XGpio_DiscreteRead(&device2, GPIO2_BTN_CH);
	*btn_data &= GPIO2_BTN_MASK;
	*btn_changes = 0;
	if (*btn_data != *btn_data_old) {
		// When any button is pressed, the audio output is updated
		//  and report the state over UART.
		*btn_changes = *btn_data ^ *btn_data_old;
		*btn_data_old = *btn_data;
	}
}


u32 find_count(u32 sw_data, u32 btn_data) {

	double frequency;

	if (sw_data == 0) {
		switch (btn_data) {
		case 0: frequency = 0; break;
		case 1: frequency = 130.81; break;
		case 2: frequency = 146.83; break;
		case 3: frequency = 164.81; break;
		case 4: frequency = 174.61; break;
		case 5: frequency = 196; break;
		case 6: frequency = 220; break;
		case 7: frequency = 246.94; break;
		default: frequency = 0; break;
		}
	}

	if (sw_data == 1) {
			switch (btn_data) {
			case 0: frequency = 0; break;
			case 1: frequency = 261.63; break;
			case 2: frequency = 293.66; break;
			case 3: frequency = 329.63; break;
			case 4: frequency = 349.23; break;
			case 5: frequency = 392; break;
			case 6: frequency = 440; break;
			case 7: frequency = 493.88; break;
			default: frequency = 0; break;
			}
		}

	if (sw_data == 2) {
			switch (btn_data) {
			case 0: frequency = 0; break;
			case 1: frequency = 523.25; break;
			case 2: frequency = 587.33; break;
			default:  frequency = 0; break;
			}
		}
	if (frequency == 0) return 0xFFFFFFFF;
    return (u32)(1.0 / (2.0* frequency * 10e-9));
}

void update_sevenseg (u32 btn_data){
	u32 cathode;

	switch (btn_data) {
		case 0: cathode = 0xFF; break; //off
		case 1: cathode = 0x46; break; //C
		case 2: cathode = 0x21; break; //D
		case 3: cathode = 0x06; break; //E
		case 4: cathode = 0x0E; break; //F
		case 5: cathode = 0x10; break; //G
		case 6: cathode = 0x08; break; //A
		case 7: cathode = 0x03; break; //B
		default: cathode = 0xFF; break;
	}
	XGpio_DiscreteWrite(&device1, GPIO1_CATHODE_CH, cathode);
}
