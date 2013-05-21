program_name='demo'


include 'TouchListener'
include 'TPUtil'


define_device

tp = 10001:1:0
touchTracker = 33001:1:0
pinch = 33001:2:0


define_variable

devchan uiTouchPoints[] = {{tp, 1}, {tp, 2}, {tp, 3}}

devchan uiPinchScale = {tp, 4}


define_function handleTouchStart(TouchPoint t) {
	setButtonRectangle(uiTouchPoints[t.id], t.p.x - 37, t.p.y - 37, 75, 75)
	on[uiTouchPoints[t.id]]
}

define_function handleTouchEnd(TouchPoint t) {
	setButtonRectangle(uiTouchPoints[t.id], t.p.x - 37, t.p.y - 37, 75, 75)
	off[uiTouchPoints[t.id]]
}

define_function handleTouchMove(TouchPoint t) {
	setButtonRectangle(uiTouchPoints[t.id], t.p.x - 37, t.p.y - 37, 75, 75)
}


define_module 'TouchTracker' mdlMultitouch(touchTracker, tp)
define_module 'PinchRecognizer' mdlPinch(pinch, touchTracker)


define_event

level_event[pinch, 1] {
	setButtonText(uiPinchScale, "'scale ', format('%1.3f', level.value)")
}

level_event[pinch, 2] {
	setButtonRectangle(uiPinchScale, getX(level.value) - 75,
			getY(level.value) - 25, 150, 50)
}

channel_event[pinch, 1] {
	on: on[uiPinchScale]
	off: off[uiPinchScale]
}


define_start

setTouchTracker(touchTracker)
