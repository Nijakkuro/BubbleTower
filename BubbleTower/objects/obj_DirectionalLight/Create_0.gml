_surfW = 256;
_surfH = 512;
_surf = surface_create(_surfW, _surfH);
_cleared = false;

CastShadows = true;
Forward = [ 1, 0, 0, 1 ];
Color = [ 0.9, 0.85, 0.8 ];
NearClip = 16;
FarClip = 4096;
AreaSizeX = 128;
AreaSizeY = 256;
ViewMat = matrix_build_identity();
ProjMat = matrix_build_identity();
ProjMatFix = matrix_build_identity();
ShadowBias = 5.0;

TextureSizeX = _surfW;
TextureSizeY = _surfH;
TexelSizeX = 1 / _surfW;
TexelSizeY = 1 / _surfH;

GetDepthTexture = function() {
	return surface_get_texture(_getSurf());
}

SetPosition = function(px, py, pz, xto, yto, zto) {
	matrix_build_lookat(px, py, pz, xto, yto, zto, 0, 0, 1, ViewMat);
	matrix_build_projection_ortho(AreaSizeX, AreaSizeY, NearClip, FarClip, ProjMat);
	array_copy(ProjMatFix, 0, ProjMat, 0, 16);
	if(os_type==os_linux || os_type==os_gxgames || os_type==os_android || os_browser!=browser_not_a_browser) {
		ProjMatFix[@ 5] = -ProjMatFix[@ 5];
	}
	
	var d = point_distance_3d(px, py, pz, xto, yto, zto);
	var dx = ( xto - px ) / d;
	var dy = ( yto - py ) / d;
	var dz = ( zto - pz ) / d;
	Forward[0] = dx;
	Forward[1] = dy;
	Forward[2] = dz;
	//matrix_transform_vertex(ViewMat, 1, 0, 0, 1, Forward);
}

_cleanUp = function() {
	surface_free(_surf);
}

_getSurf = function() {
	if(!surface_exists(_surf)) {
		_surf = surface_create(_surfW, _surfH);
		_cleared = false;
	}
	return _surf;
}

_updateDepthMap = function() {
	if(!CastShadows && !_cleared) {
		matrix_viewproj_push();
		
		var surf = _getSurf();
		surface_set_target(surf);
		draw_clear(c_white);
		surface_reset_target();
		
		matrix_viewproj_pop();
		
		_cleared = true;
		return;
	}
	
	matrix_viewproj_push();
	
	var surf = _getSurf();
	surface_set_target(surf);
	
	matrix_set(matrix_view, ViewMat);
	matrix_set(matrix_projection, ProjMatFix);
	matrix_set(matrix_world, matrix_identity);
	
	draw_clear(c_white);
	gpu_set_blendmode_ext(bm_one, bm_zero);
	_renderDepth();
	gpu_reset_blendmode();
	surface_reset_target();
	
	matrix_viewproj_pop();
}

_renderDepth = function() {
	with(obj_SceneObject) {
		event_user(0);
	}
}

SetPosition(200, 0, 750, 0, 0, 0);

