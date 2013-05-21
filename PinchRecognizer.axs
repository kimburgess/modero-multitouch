module_name='PinchRecognizer'(dev comm, dev touchTracker)


include 'TouchListener'


// TODO add velocity (per second)


define_variable

volatile integer activeTouchPoints
volatile integer touch1
volatile integer touch2
volatile float initialD


define_function long dotP(Point a, Point b) {
	stack_var slong dx
	stack_var slong dy

	// This is a bit odd but we need to make sure the math operations use a
	// signed type
	dx = -1 * -1 * a.x - b.x
	dy = -1 * -1 * a.y - b.y

	return type_cast(dx * dx + dy * dy)
}

define_function handleTouchStart(TouchPoint t) {
	activeTouchPoints++

	switch (activeTouchPoints) {

		case 1: {
			touch1 = t.id
		}

		case 2: {
			touch2 = t.id
			initialD = dotP(touch[touch1].p, touch[touch2].p)
			// TODO only start the gesture after x pixels movement
			updateScale(1)
			updateMidPoint((touch[touch1].p.x + touch[touch2].p.x) / 2,
				(touch[touch1].p.y + touch[touch2].p.y) / 2)
			updateActive(true)
		}

		default: {
			updateActive(false)
		}

	}
}

define_function handleTouchEnd(TouchPoint t) {
	activeTouchPoints--

	if (activeTouchPoints == 1) {
		if (t.id == touch1) {
			touch1 = touch2
		}
		updateActive(false)
	}
}

define_function handleTouchMove(TouchPoint t) {
	if (activeTouchPoints == 2) {
		stack_var float d

		d = dotP(touch[touch1].p, touch[touch2].p)
		updateScale(d / initialD)

		updateMidPoint((touch[touch1].p.x + touch[touch2].p.x) / 2,
				(touch[touch1].p.y + touch[touch2].p.y) / 2)
	}
}

define_function updateScale(float x) {
	send_level comm, 1, x
}

define_function updateActive(char isActive) {
	[comm, 1] = isActive
}

define_function updateMidPoint(integer x, integer y) {
	send_level comm, 2, encodePosition(x, y)
}


define_start

setTouchTracker(touchTracker)
