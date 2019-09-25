/turf/New()
	var/static/tech/floor_overlay_singleton = init_floor_overlay()

	. = ..()
	if(!density)
		overlays += floor_overlay_singleton


/turf/wall/New()
	. = ..()

	var/static/list/wall_overlays = list()
	var/overlay = wall_overlays[src.wall_smoothing_id]
	if(!overlay)
		overlay = init_wall_overlay(src.wall_smoothing_id)
		wall_overlays[src.wall_smoothing_id] = overlay

	icon_state = "invisible"
	overlays += overlay


/tech/wall_over/outer/New(id)
	src.icon_state = id

/tech/wall_over/inner/New(id, offset, plane)
	src.pixel_y = offset;
	src.icon_state = "[id]-inner"
	src.plane = plane

/tech/wall_over/vert/New(id, plane)
	src.icon_state = "[id]-vert"
	src.plane = plane

/tech/wall_over/horiz/New(id, plane)
	src.icon_state = "[id]-horiz"
	src.plane = plane


/proc/init_floor_overlay()
	var/tech/t = new()

	t.overlays += new/tech/mask{
		icon_state = "outer-corners"
		plane = PLANE_WALLSMOOTH_OUTER
		color = rgb(0,0,0)
		alpha = 127
	}

	t.overlays += new/tech/mask{icon_state = "edge-n"; plane = PLANE_WALLSMOOTH_N; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "edge-s"; plane = PLANE_WALLSMOOTH_S; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "edge-e"; plane = PLANE_WALLSMOOTH_E; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "edge-w"; plane = PLANE_WALLSMOOTH_W; color = rgb(0,0,0)}

	t.overlays += new/tech/mask{icon_state = "corner-ne"; plane = PLANE_WALLSMOOTH_INNER_NE; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "corner-nw"; plane = PLANE_WALLSMOOTH_INNER_NW; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "corner-se"; plane = PLANE_WALLSMOOTH_INNER_SE; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "corner-sw"; plane = PLANE_WALLSMOOTH_INNER_SW; color = rgb(0,0,0)}

	return t

/proc/init_wall_overlay(id)
	var/tech/t = new()

#define edges_color rgb(230,230,230)
	t.overlays += new/tech/mask{icon_state = "edges-se"; plane = PLANE_WALLSMOOTH_INNER_SE; color = edges_color}
	t.overlays += new/tech/mask{icon_state = "edges-sw"; plane = PLANE_WALLSMOOTH_INNER_SW; color = edges_color}
	t.overlays += new/tech/mask{icon_state = "edges-ne"; plane = PLANE_WALLSMOOTH_INNER_NE; color = edges_color}
	t.overlays += new/tech/mask{icon_state = "edges-nw"; plane = PLANE_WALLSMOOTH_INNER_NW; color = edges_color}

	t.overlays += new/tech/wall_over/inner(id, 32, PLANE_WALLSMOOTH_INNER_NE)
	t.overlays += new/tech/wall_over/inner(id, 32, PLANE_WALLSMOOTH_INNER_NW)
	t.overlays += new/tech/wall_over/inner(id, -32, PLANE_WALLSMOOTH_INNER_SE)
	t.overlays += new/tech/wall_over/inner(id, -32, PLANE_WALLSMOOTH_INNER_SW)

	t.overlays += new/tech/wall_over/outer(id)

	t.overlays += new/tech/wall_over/vert(id, PLANE_WALLSMOOTH_E)
	t.overlays += new/tech/wall_over/vert(id, PLANE_WALLSMOOTH_W)
	t.overlays += new/tech/wall_over/horiz(id, PLANE_WALLSMOOTH_N)
	t.overlays += new/tech/wall_over/horiz(id, PLANE_WALLSMOOTH_S)

	return t

/mob/Login()
	. = ..()
	client.screen += new/tech/plane_master/outer_corners {plane = PLANE_WALLSMOOTH_OUTER}

	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_N}
	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_S}
	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_E}
	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_W}

	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_NE}
	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_NW}
	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_SE}
	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_SW}