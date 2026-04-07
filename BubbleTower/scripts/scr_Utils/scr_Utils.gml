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

