function MakeTowerTexture()
{
	var spr_add = function(name, w, h)
	{
		return sprite_add($"tower/{name}", 1, false, false, 0, 0);
	}
	
	var tower_d_0 = spr_add("tower_d_0.png", 240, 512);
	var tower_d_1 = spr_add("tower_d_1.png", 240, 192);
	var tower_d_2 = spr_add("tower_d_2.png", 240, 56);
	var tower_d_3 = spr_add("tower_d_3.png", 240, 56);
	var tower_d_4 = spr_add("tower_d_4.png", 240, 192);
	
	var tower_e_0 = spr_add("tower_e_0.png", 240, 512);
	var tower_e_1 = spr_add("tower_e_1.png", 240, 192);
	var tower_e_2 = spr_add("tower_e_2.png", 240, 56);
	var tower_e_3 = spr_add("tower_e_3.png", 240, 56);
	var tower_e_4 = spr_add("tower_e_4.png", 240, 192);
	
	var tower_n_0 = spr_add("tower_n_0.png", 240, 512);
	var tower_n_1 = spr_add("tower_n_1.png", 240, 192);
	var tower_n_2 = spr_add("tower_n_2.png", 240, 56);
	var tower_n_3 = spr_add("tower_n_3.png", 240, 56);
	var tower_n_4 = spr_add("tower_n_4.png", 240, 192);
	
	var tower_s_0 = spr_add("tower_s_0.png", 240, 512);
	var tower_s_1 = spr_add("tower_s_1.png", 240, 192);
	var tower_s_2 = spr_add("tower_s_2.png", 240, 56);
	var tower_s_3 = spr_add("tower_s_3.png", 240, 56);
	var tower_s_4 = spr_add("tower_s_4.png", 240, 192);
	
	var draw_tower_013 = function(spr, ox, oy)
	{
		draw_sprite_part(spr, 0, 240-8, 0, 8, 512, ox, oy);
		draw_sprite(spr, 0, ox+8, oy);
		draw_sprite_part(spr, 0, 0, 0, 8, 512, ox+240+8, oy);
	}
	
	var draw_tower_2 = function(spr, ox, oy)
	{
		draw_sprite_part(spr, 0, 240-8, 0, 8, 512, ox, oy);
		draw_sprite(spr, 0, ox+8, oy);
		draw_sprite_part(spr, 0, 0, 0, 8, 512, ox+240+8, oy);
		
		var sprH = sprite_get_height(spr);
		
		for(var i=0; i<8; i++)
		{
			draw_sprite_part(spr, 0, 240-8, sprH-1, 8, 1, ox, oy + sprH + i);
			draw_sprite_part(spr, 0, 0, sprH-1, 240, 1, ox+8, oy + sprH + i);
			draw_sprite_part(spr, 0, 0, sprH-1, 8, 1, ox+240+8, oy + sprH + i);
		}
	}
	
	var draw_tower_4 = function(spr, ox, oy)
	{
		for(var i=0; i<8; i++)
		{
			draw_sprite_part(spr, 0, 240-8, 0, 8, 1, ox, oy + i);
			draw_sprite_part(spr, 0, 0, 0, 240, 1, ox+8, oy + i);
			draw_sprite_part(spr, 0, 0, 0, 8, 1, ox+240+8, oy + i);
		}
		
		draw_sprite_part(spr, 0, 240-8, 0, 8, 512, ox, oy + 8);
		draw_sprite(spr, 0, ox+8, oy + 8);
		draw_sprite_part(spr, 0, 0, 0, 8, 512, ox+240+8, oy + 8);
	}
	
	var draw_part = function(draw_func, spr_rgb, spr_a, ox, oy)
	{
		gpu_set_colourwriteenable(true, true, true, false);
		draw_func(spr_rgb, ox, oy);
		gpu_set_colourwriteenable(false, false, false, true);
		shader_set(sh_InvRedToAlpha);
		draw_func(spr_a, ox, oy);
		shader_reset();
		gpu_set_colourwriteenable(true, true, true, true);
	}
	
	var surf = surface_create(1024, 512);
	surface_set_target(surf);
	draw_clear_alpha(0, 0);
	gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
	
	draw_part(draw_tower_013, tower_d_0, tower_e_0, 0, 0);
	draw_part(draw_tower_013, tower_d_1, tower_e_1, 256, 0);
	draw_part(draw_tower_2,   tower_d_2, tower_e_2, 256, 192);
	draw_part(draw_tower_4,   tower_d_3, tower_e_3, 256, 256);
	draw_part(draw_tower_013, tower_d_4, tower_e_4, 256, 320);
	
	draw_part(draw_tower_013, tower_n_0, tower_s_0, 512 + 0, 0);
	draw_part(draw_tower_013, tower_n_1, tower_s_1, 512 + 256, 0);
	draw_part(draw_tower_2,   tower_n_2, tower_s_2, 512 + 256, 192);
	draw_part(draw_tower_4,   tower_n_3, tower_s_3, 512 + 256, 256);
	draw_part(draw_tower_013, tower_n_4, tower_s_4, 512 + 256, 320);
	
	gpu_reset_blendmode();
	surface_reset_target();
	
	surface_save(surf, "tower.png");
}




function GameFieldDrawDebug(gameField, px, py)
{
	// TODO: get values from gameField
	
	if(display_get_gui_width() < 1200)
	{
		return;
	}
	
	var scl = 3;
	
	var r = BallRadius * scl-1;
	
	var x1 = px;
	var y1 = py;
	var x2 = x1 + FieldW * scl;
	var y2 = y1 + FieldH * scl;
	
	draw_set_color(c_black);
	draw_rectangle(x1, y1, x2, y2 + BallDiameter * scl * 2, false);
	
	for(var i=0; i<CellNumTotal; i++)
	{
		var ball = Grid[i];
		if(ball!=undefined)
		{
			//color = color_from_color_index(ball.ColorIndex);
			//draw_set_color(color);
			var posX = (PositionsLUT2D_X[i] + ball.OffsetX) * scl;
			var posY = (PositionsLUT2D_Y[i] + ball.OffsetY) * scl;
			draw_circle(px + posX, py + posY, r, false);
		}
	}
	
	
	draw_set_color(c_red);
	draw_rectangle(x1, y1, x2, y2, true);
	
	draw_rectangle(x1, y2, x2, y2 + BallDiameter * scl * 2, true);
	
	draw_set_color(c_white);
	var cannonX = x1 + _cannonX * scl;
	var cannonY = y1 + _cannonY * scl;
	draw_circle(cannonX, cannonY, r, false);
	
	draw_line(cannonX, cannonY, cannonX + lengthdir_x(scl * FieldH, _cannonAngle + 90), cannonY + lengthdir_y(scl * FieldH, _cannonAngle + 90));
	
	draw_set_color(c_red);
	draw_circle(px + _cannonTraceResultX * scl, py + + _cannonTraceResultY * scl, 4, false);
	
	if(!device_mouse_check_button(0, mb_left)) {
		return;
	}
	
	x1 = px;
	y1 = py;
	x2 = x1 + FieldW * scl;
	y2 = y1 + FieldH * scl;
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if(!point_in_rectangle(mx, my, x1, y1, x2, y2))
	{
		return;
	}
	
	var i = _snapToIndex((mx - px) / scl, (my - py)/scl);
	if(i==-1)
	{
		return;
	}
	
	var cx = px + PositionsLUT2D_X[i] * scl;
	var cy = py + PositionsLUT2D_Y[i] * scl;
	
	draw_set_color(c_white);
	draw_circle(cx, cy, r, true);
	draw_set_alpha(1);
	
	draw_set_color(c_white);
	draw_circle(mx, my, 2, false);
	
	draw_set_colour(c_maroon);
	draw_text(4, 4, $"index = {i}");
}

