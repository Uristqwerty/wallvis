#define PLANE_WALLSMOOTH_INNER_NE 40
#define PLANE_WALLSMOOTH_INNER_NW 41
#define PLANE_WALLSMOOTH_INNER_SE 42
#define PLANE_WALLSMOOTH_INNER_SW 43

#define PLANE_WALLSMOOTH_N 44
#define PLANE_WALLSMOOTH_S 45
#define PLANE_WALLSMOOTH_E 46
#define PLANE_WALLSMOOTH_W 47

#define PLANE_WALLSMOOTH_OUTER 48

/world
	turf = /turf/space

/mob
	icon = 'misc_icons.dmi'
	icon_state = "mob"

/turf
	icon = 'misc_icons.dmi'

/turf/space
	icon_state = "space"

/turf/floor
	icon_state = "tile"


/turf/wall
	var/wall_smoothing_id = "wall"
	density = 1
	opacity = 1
	icon = 'walls.dmi'
	icon_state = "wall"

/turf/wall/reinforced
	wall_smoothing_id = "reinforced"
	icon_state = "reinforced"

/turf/wall/shuttle
	wall_smoothing_id = "shuttle"
	icon_state = "shuttle"

/turf/wall/debug
	wall_smoothing_id = "debug"
	icon_state = "debug"


/tech
	parent_type = /obj

// A very arbitrary number.
#define MASK_LAYER 42

/tech/mask
	icon = 'wall-masks.dmi'
	pixel_x = -24
	pixel_y = -24
	alpha = 127
	blend_mode = BLEND_ADD
	layer = MASK_LAYER


/tech/wall_over
	icon = 'walls.dmi'
	blend_mode = BLEND_MULTIPLY
	layer = MASK_LAYER + 1

/tech/wall_over/outer
	plane = PLANE_WALLSMOOTH_OUTER
	blend_mode = BLEND_ADD
	alpha = 127

/tech/wall_over/inner

/tech/wall_over/vert
	blend_mode = BLEND_ADD
	alpha = 127

/tech/wall_over/horiz
	blend_mode = BLEND_ADD
	alpha = 127


/tech/plane_master
	screen_loc = "CENTER"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	mouse_opacity = 0

var/const/over_zero = 127/255
var/const/over_alpha = over_zero
var/const/over_one = over_zero+over_alpha - over_zero*over_alpha
var/const/over_mul = 1/(over_one-over_zero)
var/const/over_sub = over_mul*over_one - 1
var/const/cc = over_one / over_zero

/tech/plane_master/edges
	color = list(cc,0,0,0, 0,cc,0,0, 0,0,cc,0, 0,0,0,over_mul, 0,0,0,-over_sub)


var/const/over_zero3 = 1 - over_zero*over_zero
var/const/over_one3 = 1 - over_zero*over_zero*over_zero
var/const/over_mul3 = 1/(over_one3-over_zero3)
var/const/over_sub3 = over_mul3*over_one3 - 1
var/const/cc3 = 1.8

/tech/plane_master/inner_corners
	color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,over_mul3, 0,0,0,-over_sub3)

/tech/plane_master/outer_corners
	color = list(cc3,0,0,0, 0,cc3,0,0, 0,0,cc3,0, 0,0,0,over_mul3, 0,0,0,-over_sub3)
