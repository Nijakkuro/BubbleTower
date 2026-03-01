/// package: gml_dispatcher
/// version: 1.1.0
/// dependencies: -
/// author: NikkoTC

function dispatcher() constructor
{
	/// @ignore
	_bindedStructs = [];
	
	/// @ignore
	_bindedFunctions = [];
	
	/// @ignore
	_bindedMethods = [];
	
	/// @ignore
	_bindedStructsBuffer = [];
	
	/// @ignore
	_bindedMethodsBuffer = [];
	
	/// @ignore
	_bufferUpdated = true;
	
	/// @param {Struct,Id.Instance} struct
	/// @param {Function} func
	static Bind = function(struct, func)
	{
		if((is_struct(struct) || typeof(struct)=="struct") && is_callable(func))
		{
			array_push( _bindedStructs, weak_ref_create(struct) );
			array_push( _bindedFunctions, func );
			array_push( _bindedMethods, method_get_self(func)==struct ? func : method(struct, func) );
			_bufferUpdated = false;
		}
	}
	
	/// @param {Struct,Id.Instance} struct
	/// @param {Function,Undefined} func
	/// @return {Bool}
	static IsBinded = function(struct, func=undefined)
	{
		var n = array_length(_bindedStructs);
		for(var i=0; i<n; i++)
		{
			var bindedStruct = _bindedStructs[i];
			if( weak_ref_alive(bindedStruct) && bindedStruct.ref==struct && (func==undefined || _bindedFunctions[i]==func) )
			{
				return true;
			}
		}
		return false;
	}
	
	/// @param {Struct,Id.Instance} struct
	/// @param {Function,Undefined} func
	static Unbind = function(struct, func=undefined)
	{
		var n = array_length(_bindedStructs);
		for(var i=0; i<n; i++)
		{
			var bindedStruct = _bindedStructs[i];
			if( weak_ref_alive(bindedStruct) && bindedStruct.ref==struct && (func==undefined || _bindedFunctions[i]==func) )
			{
				array_delete(_bindedStructs, i, 1);
				array_delete(_bindedFunctions, i, 1);
				array_delete(_bindedMethods, i, 1);
				i--;
				n--;
				_bufferUpdated = false;
			}
		}
	}
	
	static UnbindAll = function()
	{
		_bindedStructs = [];
		_bindedFunctions = [];
		_bindedMethods = [];
		_bindedStructsBuffer = [];
		_bindedMethodsBuffer = [];
		_bufferUpdated = true;
	}
	
	static Invoke = function()
	{
		var n = array_length(_bindedStructs);
		for(var i=0; i<n; i++)
		{
			if(!weak_ref_alive(_bindedStructs[i]))
			{
				array_delete(_bindedStructs, i, 1);
				array_delete(_bindedFunctions, i, 1);
				array_delete(_bindedMethods, i, 1);
				i--;
				n--;
				_bufferUpdated = false;
			}
		}
		
		if(!_bufferUpdated)
		{
			array_copy(_bindedStructsBuffer, 0, _bindedStructs, 0, n);
			array_copy(_bindedMethodsBuffer, 0, _bindedMethods, 0, n);
			_bufferUpdated = true;
		}
		
		for(var i=0; i<n; i++)
		{
			if(weak_ref_alive(_bindedStructsBuffer[i]))
			{
				var func = _bindedMethodsBuffer[i];
				switch(argument_count)
				{
					case 0: func(); break;
					case 1: func(argument[0]); break;
					case 2: func(argument[0], argument[1]); break;
					case 3: func(argument[0], argument[1], argument[2]); break;
					case 4: func(argument[0], argument[1], argument[2], argument[3]); break;
					case 5: func(argument[0], argument[1], argument[2], argument[3], argument[4]); break;
					case 6: func(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5]); break;
					case 7: func(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]); break;
					case 8: func(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]); break;
				}
			}
		}
	}
}

