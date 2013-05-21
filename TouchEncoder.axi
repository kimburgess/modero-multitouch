program_name = 'TouchEncoder'

#if_not_defined __TOUCH_ENCODER
#define __TOUCH_ENCODER


define_function integer getX(long embeddedPoint) {
	return type_cast(embeddedPoint >> 16)
}

define_function integer getY(long embeddedPoint) {
	return type_cast(embeddedPoint & $ffff)
}

define_function long encodePosition(integer x, integer y) {
	return (x << 16) | y
}


#end_if