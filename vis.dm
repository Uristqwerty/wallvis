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

/tech/wall_over/vert/New(id, dir, plane)
	src.icon_state = "[id]-vert"
	// TODO: Probably doesn't have to be explicit icon procs, but MVP first; polish later
	var/const/f = 0.09
	var/icon/I = icon('walls.dmi', "edge-fade-[dir]")
	I.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, -f,-f,-f,0, f,f,f,1)
	src.icon -= I
	src.plane = plane

/tech/wall_over/horiz/New(id, dir, plane)
	src.icon_state = "[id]-horiz"
	var/const/f = 0.08
	var/icon/I = icon('walls.dmi', "edge-fade-[dir]")
	I.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, -f,-f,-f,0, f,f,f,1)
	src.icon -= I
	src.plane = plane

/tech/wall_over/vert_hard/New(id, plane)
	src.icon_state = "[id]-vert"
	src.plane = plane

/tech/wall_over/horiz_hard/New(id, plane)
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

	t.overlays += new/tech/mask{icon_state = "edge-n-fade"; plane = PLANE_WALLSMOOTH_N; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "edge-s-fade"; plane = PLANE_WALLSMOOTH_S; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "edge-e-fade"; plane = PLANE_WALLSMOOTH_E; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "edge-w-fade"; plane = PLANE_WALLSMOOTH_W; color = rgb(0,0,0)}

	t.overlays += new/tech/mask{icon_state = "corner-ne"; plane = PLANE_WALLSMOOTH_INNER_NE; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "corner-nw"; plane = PLANE_WALLSMOOTH_INNER_NW; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "corner-se"; plane = PLANE_WALLSMOOTH_INNER_SE; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "corner-sw"; plane = PLANE_WALLSMOOTH_INNER_SW; color = rgb(0,0,0)}

	t.overlays += new/tech/mask2{icon_state = "horiz-hard"; plane = PLANE_WALLSMOOTH_HORIZ_HARD; color = rgb(0,0,0)}
	t.overlays += new/tech/mask2{icon_state = "vert-hard"; plane = PLANE_WALLSMOOTH_VERT_HARD; color = rgb(0,0,0)}

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
/*
	t.overlays += new/tech/mask{icon_state = "center"; plane = PLANE_WALLSMOOTH_N; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "center"; plane = PLANE_WALLSMOOTH_S; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "center"; plane = PLANE_WALLSMOOTH_E; color = rgb(0,0,0)}
	t.overlays += new/tech/mask{icon_state = "center"; plane = PLANE_WALLSMOOTH_W; color = rgb(0,0,0)}
*/
	t.overlays += new/tech/wall_over/horiz(id, "n", PLANE_WALLSMOOTH_N)
	t.overlays += new/tech/wall_over/horiz(id, "s", PLANE_WALLSMOOTH_S)
	t.overlays += new/tech/wall_over/vert(id, "e", PLANE_WALLSMOOTH_E)
	t.overlays += new/tech/wall_over/vert(id, "w", PLANE_WALLSMOOTH_W)

	t.overlays += new/tech/wall_over/horiz_hard(id, PLANE_WALLSMOOTH_HORIZ_HARD)
	t.overlays += new/tech/wall_over/vert_hard(id, PLANE_WALLSMOOTH_VERT_HARD)

	return t

/mob/Login()
	. = ..()
	client.screen += new/tech/plane_master/outer_corners {plane = PLANE_WALLSMOOTH_OUTER}

	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_N}
	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_S}
	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_E}
	client.screen += new/tech/plane_master/edges {plane = PLANE_WALLSMOOTH_W}

	client.screen += new/tech/plane_master/edges_hard {plane = PLANE_WALLSMOOTH_HORIZ_HARD}
	client.screen += new/tech/plane_master/edges_hard {plane = PLANE_WALLSMOOTH_VERT_HARD}

	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_NE}
	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_NW}
	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_SE}
	client.screen += new/tech/plane_master/inner_corners {plane = PLANE_WALLSMOOTH_INNER_SW}