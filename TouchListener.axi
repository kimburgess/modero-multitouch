program_name = 'TouchListener'

#if_not_defined __TOUCH_LISTENER
#define __TOUCH_LISTENER


define_type

structure Point {
	integer x
	integer y
}

structure TouchPoint {
	char isActive
	integer id
	Point p
}


define_variable

constant integer MAXIMUM_TOUCH_POINTS = 3

volatile dev TouchTrackerCommDevice

volatile TouchPoint touch[MAXIMUM_TOUCH_POINTS]


define_function setTouchTracker(dev comm) {
	stack_var integer i

	for (i = max_length_array(touch); i; i--) {
		touch[i].id = i
	}

	TouchTrackerCommDevice = comm

	rebuild_event()
}


include 'TouchEncoder'


define_event

channel_event[TouchTrackerCommDevice, 0] {
	on: {
		stack_var integer i
		i = channel.channel
		touch[i].isActive = true
		// cordinates get updated prior to this firing
		handleTouchStart(touch[i])
	}
	off: {
		stack_var integer i
		i = channel.channel
		touch[i].isActive = false
		handleTouchEnd(touch[i])
	}
}

level_event[TouchTrackerCommDevice, 0] {
	stack_var integer i
	i = level.input.level
	touch[i].p.x = getX(level.value)
	touch[i].p.y = getY(level.value)
	if (touch[i].isActive) {
		handleTouchMove(touch[i])
	}
}


#end_if