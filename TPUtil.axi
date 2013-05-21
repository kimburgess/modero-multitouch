program_name = 'TPUtil'

#if_not_defined __TPUTIL
#define __TPUTIL


define_function setButtonRectangle(devchan btn, integer x, integer y,
		integer w, integer h) {
	send_command btn.device, "'^BMF-', itoa(btn.channel), ',0,%R',
			itoa(x), ',',
			itoa(y), ',',
			itoa(x + w), ',',
			itoa(y + h)"
}

define_function setButtonText(devchan btn, char text[]) {
	send_command btn.device, "'^TXT-', itoa(btn.channel), ',0,', text"
}


#end_if
