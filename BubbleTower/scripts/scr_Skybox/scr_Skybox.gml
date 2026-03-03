function sSkybox(sprite) constructor
{
	// texture
	_texture = sprite_get_texture(sprite, 0);
	
	// vertex format
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	_vformat = vertex_format_end();
	
	// build vertex buffer
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);
	
	// front
	var tc = sprite_get_uvs(sprite, 0);
	vertex_pos_tex(vbuff,  1, -1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff,  1, -1,  1, tc[0], tc[1]);
	vertex_pos_tex(vbuff,  1,  1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff,  1, -1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff,  1,  1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff,  1,  1, -1, tc[2], tc[3]);
	
	// back
	tc = sprite_get_uvs(sprite, 2);
	vertex_pos_tex(vbuff, -1,  1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff, -1,  1,  1, tc[0], tc[1]);
	vertex_pos_tex(vbuff, -1, -1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff, -1,  1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff, -1, -1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff, -1, -1, -1, tc[2], tc[3]);
	
	// left
	tc = sprite_get_uvs(sprite, 3);
	vertex_pos_tex(vbuff, -1, -1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff, -1, -1,  1, tc[0], tc[1]);
	vertex_pos_tex(vbuff,  1, -1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff, -1, -1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff,  1, -1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff,  1, -1, -1, tc[2], tc[3]);
	
	// right
	tc = sprite_get_uvs(sprite, 1);
	vertex_pos_tex(vbuff,  1,  1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff,  1,  1,  1, tc[0], tc[1]);
	vertex_pos_tex(vbuff, -1,  1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff,  1,  1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff, -1,  1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff, -1,  1, -1, tc[2], tc[3]);
	
	// top
	tc = sprite_get_uvs(sprite, 4);
	vertex_pos_tex(vbuff, -1, -1,  1, tc[0], tc[1]);
	vertex_pos_tex(vbuff, -1,  1,  1, tc[2], tc[1]);
	vertex_pos_tex(vbuff,  1, -1,  1, tc[0], tc[3]);
	vertex_pos_tex(vbuff,  1,  1,  1, tc[2], tc[3]);
	vertex_pos_tex(vbuff,  1, -1,  1, tc[0], tc[3]);
	vertex_pos_tex(vbuff, -1,  1,  1, tc[2], tc[1]);
	
	// bottom
	tc = sprite_get_uvs(sprite, 5);
	vertex_pos_tex(vbuff,  1, -1, -1, tc[0], tc[1]);
	vertex_pos_tex(vbuff,  1,  1, -1, tc[2], tc[1]);
	vertex_pos_tex(vbuff, -1, -1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff, -1,  1, -1, tc[2], tc[3]);
	vertex_pos_tex(vbuff, -1, -1, -1, tc[0], tc[3]);
	vertex_pos_tex(vbuff,  1,  1, -1, tc[2], tc[1]);
	
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	
	_vbuff = vbuff;
	
	CleanUp = function() {
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	Draw = function() {
		shader_set(sh_Skybox);
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
	}
}

