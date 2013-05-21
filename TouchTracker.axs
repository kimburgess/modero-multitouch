module_name='TouchTracker'(dev comm, dev tp)


include 'TouchListener'
include 'TouchEncoder'


define_variable

constant char EVENT_TYPE_PRESS[] = 'Press'
constant char EVENT_TYPE_MOVE[] = 'Move'
constant char EVENT_TYPE_RELEASE[] = 'Release'


define_function configurePanel() {
	send_command tp, "'^TOP-3'"
}

define_function long dotP(Point a, Point b) {
	stack_var slong dx
	stack_var slong dy

	// This is a bit odd but we need to make sure the math operations use a
	// signed type
	dx = -1 * -1 * a.x - b.x
	dy = -1 * -1 * a.y - b.y

	return type_cast(dx * dx + dy * dy)
}

define_function integer getClosest(Point p) {
	stack_var integer i
	stack_var float dot
	stack_var float minDot
	stack_var integer closest

	minDot = 999999

	for (i = max_length_array(touch); i; i--) {
		if (touch[i].isActive) {
			dot = dotP(p, touch[i].p)
			if (dot < minDot) {
				minDot = dot
				closest = i
			}
		}
	}

	return closest
}

define_function integer getNextAvailableID() {
	stack_var integer i

	for (i = 1; i <= max_length_array(touch); i++) {
		if (!touch[i].isActive) {
			return i
		}
	}

	return 0
}

define_function handlePress(Point p) {
	stack_var integer id
	id = getNextAvailableID()
	updateTouchPosition(id, p.x, p.y)
	updateTouchActive(id, true)
}

define_function handleMove(Point p) {
	stack_var integer id
	id = getClosest(p)
	updateTouchPosition(id, p.x, p.y)
}

define_function handleRelease(Point p) {
	stack_var integer id
	id = getClosest(p)
	updateTouchPosition(id, p.x, p.y)
	updateTouchActive(id, false)
}

define_function handleTouchStart(TouchPoint t) {
}

define_function handleTouchEnd(TouchPoint t) {
}

define_function handleTouchMove(TouchPoint t) {
}

define_function updateTouchActive(integer i, char isActive) {
	[comm, i] = isActive
}

define_function updateTouchPosition(integer i, integer x, integer y) {
	send_level comm, i, encodePosition(x, y)
}


define_event

data_event[tp] {

	string: {
		stack_var char eventType[16]
		stack_var Point p

		eventType = remove_string(data.text, "','", 1)
		eventType = left_string(eventType, length_string(eventType) - 1)

		p.x = atoi(remove_string(data.text, "','", 1))
		p.y = atoi(data.text)

		switch (eventType) {
			case EVENT_TYPE_PRESS: handlePress(p)
			case EVENT_TYPE_MOVE: handleMove(p)
			case EVENT_TYPE_RELEASE: handleRelease(p)
		}
	}

	online: {
		configurePanel()
	}

}

data_event[comm] {

	online: {
		set_virtual_channel_count(comm, max_length_array(touch))
		set_virtual_level_count(comm, max_length_array(touch))
		setTouchTracker(comm)
	}

}
