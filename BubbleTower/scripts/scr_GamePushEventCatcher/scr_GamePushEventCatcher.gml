function sGamePushEventCatcher() constructor
{
	_eventHandlers = {};
	
	RegisterHandler = function(eventName, handler)
	{
		var eventHandlers = _eventHandlers[$ eventName];
		var handlerWeak = weak_ref_create(handler);
		
		if(eventHandlers==undefined)
		{
			_eventHandlers[$ eventName] = [ handlerWeak ];
		}
		else
		{
			array_push(eventHandlers, handlerWeak);
		}
	}
	
	UnregisterHandler = function(eventName, handler)
	{
		var eventHandlers = _eventHandlers[$ eventName];
		if(eventHandlers==undefined)
		{
			return;
		}
		
		for(var i=0, n=array_length(eventHandlers); i<n; i++)
		{
			if(eventHandlers[i].ref==handler)
			{
				array_delete(eventHandlers, i, 1);
				return;
			}
		}
	}
	
	_fixUpHandlersArray = function(arr)
	{
		for(var i=0, n=array_length(arr); i<n; i++)
		{
			var eventHandlerWeak = arr[i];
			if(!weak_ref_alive(eventHandlerWeak))
			{
				array_delete(arr, i, 1);
				i--;
			}
		}
	}
	
	CatchEvent = function()
	{
		var showDebug = CCore.DevMode;
		
		var type = async_load[? "type"];
		if(type!="GamePush")
		{
			return false;
		}
		
		if(showDebug)
		{
			show_debug_message($"--- GAMEPUSH EVENT ---");
		}
		
		var eventName = async_load[? "event"];
		if(showDebug)
		{
			show_debug_message($"event = {eventName}");
			
			var keys = ds_map_keys_to_array(async_load);
			var n = array_length(keys);
			for(var i=0; i<n; i++)
			{
				var key = keys[i];
				if(key!="type" && key!="event")
				{
					var val = async_load[? key ];
					show_debug_message($"{key} = {val}");
				}
			}
		}
		
		var eventHandlers = _eventHandlers[$ eventName];
		if(eventHandlers!=undefined)
		{
			_fixUpHandlersArray(eventHandlers);
			var n = array_length(eventHandlers);
			
			if(n==0)
			{
				if(showDebug)
				{
					show_debug_message($"--- event has no handlers ---");
				}
				return false;
			}
			
			if(showDebug)
			{
				show_debug_message($"--- calling for {n} handlers ---");
			}
			
			for(var i=0; i<n; i++)
			{
				var eventHandlerWeak = eventHandlers[i];
				if(weak_ref_alive(eventHandlerWeak))
				{
					var eventHandler = eventHandlerWeak.ref;
					eventHandler.Function();
				}
			}
			
			return true;
		}
		else if(showDebug)
		{
			show_debug_message($"--- event has no handlers ---");
		}
		
		return false;
	}
}

function GamePushEventCatcher()
{
	static inst = new sGamePushEventCatcher();
	return inst;
}

function sGamePushEventHandler(eventName, func, enable=true) constructor
{
	_eventName = eventName;
	Function = func;
	_registered = false;
	
	if(enable)
	{
		Enable();
	}
	
	static CleanUp = function()
	{
		Disable();
	}
	
	static Enable = function()
	{
		if(!_registered)
		{
			GamePushEventCatcher().RegisterHandler(_eventName, self);
			_registered = true;
		}
	}
	
	static Disable = function()
	{
		if(_registered)
		{
			GamePushEventCatcher().UnregisterHandler(_eventName, self);
			_registered = false;
		}
	}
}

