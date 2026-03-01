global._room_transition_inst_counter++;

if(instance_number(obj_RoomTransitionBase)>1 || Params==undefined)
{
	instance_destroy();
}

var rm = Params[$ "Room"];
if(rm==undefined || rm==noone)
{
	instance_destroy();
}

persistent = true;

_room = rm;
_transitionValue = 0;
_transitionValueStep = 0.05;
_transitionHalfDelay = 2;

_stage = 0;
_playing = false;
_finished = false;
_transitionDelayCurrent = 0;

OnBegin = Params[$ "OnBegin"];
OnTransit = Params[$ "OnTransit"];
OnFinished = Params[$ "OnFinished"];
_skipHalf = Params[$ "SkipHalf"];

TextureGroups = Params[$ "TextureGroups"] ?? [];

_loadTextureGroups = function()
{
	var n = array_length(TextureGroups);
	for(var i=0; i<n; i++)
	{
		var name = TextureGroups[i];
		if(texturegroup_get_status(name)!=texturegroup_status_fetched)
		//if(wdt_get_texture_group_status(name)!=wdt_status_ready)
		{
			texturegroup_load(name, true);
			//wdt_load_texture_group(name);
		}
	}
}

_checkTextureGroups = function()
{
	var n = array_length(TextureGroups);
	for(var i=0; i<n; i++)
	{
		var name = TextureGroups[i];
		if(texturegroup_get_status(name)!=texturegroup_status_fetched)
		//if(wdt_get_texture_group_status(name)!=wdt_status_ready)
		{
			return false;
		}
	}
	
	return true;
}

_onPlay = function()
{
	_playing = true;
	if(_skipHalf!=undefined)
	{
		if(_skipHalf==1) // first half
		{
			_stage = 1;
			_transitionValue = 1;
		}
	}
}

_transit = function()
{
	if(OnTransit!=undefined)
	{
		OnTransit();
	}
	room_goto(_room);
}

_finish = function()
{
	if(OnFinished!=undefined)
	{
		OnFinished();
	}
	instance_destroy();
}

_step = function()
{
	if(GLOBAL_PAUSE)
	{
		return;
	}
	
	if(!_playing)
	{
		if(!_finished)
		{
			_onPlay();
		}
		return;
	} 
	
	switch(_stage)
	{
		case 0:
			_transitionValue = value_step_to(_transitionValue, 1, _transitionValueStep);
			if(_transitionValue==1)
			{
				_stage = 1;
				_transitionDelayCurrent = _transitionHalfDelay;
			}
			break;
			
		case 1:
			if(_transitionDelayCurrent>0)
			{
				_transitionDelayCurrent--;
			}
			else
			{
				_loadTextureGroups();
				_transit();
				_stage = 2;
				_transitionDelayCurrent = _transitionHalfDelay;
			}
			break;
			
		case 2:
			if(!_checkTextureGroups())
			{
				return;
			}
			
			if(_transitionDelayCurrent>0)
			{
				_transitionDelayCurrent--;
			}
			else
			{
				_stage = 3;
			}
			break;
			
		case 3:
			_transitionValue = value_step_to(_transitionValue, 0, _transitionValueStep);
			if(_transitionValue==0)
			{
				_stage = 0;
				_playing = false;
				_finished = true;
				_finish();
			}
			break;
	}
}

_drawGUIEnd = function()
{
	draw_set_color(c_black);
	draw_set_alpha(clamp(_transitionValue * 1.2, 0, 1));
	var w = display_get_gui_width();
	var h = display_get_gui_height();
	draw_rectangle(-1, -1, w + 2, h + 2, false);
	draw_set_alpha(1);
}

