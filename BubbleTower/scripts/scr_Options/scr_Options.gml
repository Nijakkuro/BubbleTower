function sCOption(value, validationFunc=undefined) constructor
{
	/// @ignore
	_value = value;
	
	/// @ignore
	_defaultValue = _value;
	
	/// @ignore
	_validationFunc = validationFunc;
	
	/// @ignore
	_onChanged = new dispatcher();
	
	static Reset = function() { Set(_defaultValue); }
	
	static Set = function(value)
	{
		var valueValid = _validationFunc!=undefined ? _validationFunc(value) : value;
		if(_value!=valueValid)
		{
			_value = valueValid;
			_onChanged.Invoke(_value);
		}
	}
	
	static Get = function() { return _value; }
	
	static BindOnChanged = function(struct, func)
	{
		_onChanged.Bind(struct, func);
	}
	
	static UnbindOnChanged = function(struct, func=undefined)
	{
		_onChanged.Unbind(struct, func);
	}
}

function sCOptionGroup(groupName="Settings", filename="options.ini") constructor
{
	/// @ignore
	_optionsFilename = filename;
	
	/// @ignore
	_optionsGroupName = groupName;
	
	/// @ignore
	_onChanged = new dispatcher();
	
	/// @ignore
	_unsaved = false;
	
	static InitOptions = function()
	{
		var onAnyChanged = function(value) {
			_unsaved = true;
			_onChanged.Invoke();
		}
		
		var varNames = struct_get_names(self);
		
		var n = array_length(varNames);
		for(var i=0; i<n; i++)
		{
			var varValue = struct_get(self, varNames[i]);
			if(is_instanceof(varValue, sCOption))
			{
				varValue.BindOnChanged(self, onAnyChanged);
			}
		}
		
		COptionsSystem.RegisterGroup(_optionsGroupName, self);
		
		LoadOptions();
	}
	
	static LoadOptions = function()
	{
		ini_open(_optionsFilename);
		
		var varNames = struct_get_names(self);
		var n = array_length(varNames);
		for(var i=0; i<n; i++)
		{
			var varName = varNames[i];
			var varValue = struct_get(self, varName);
			if(!is_method(varValue) && is_struct(varValue) && string_char_at(varName, 1)!="_")
			{
				if(ini_key_exists(_optionsGroupName, varName))
				{
					var value = varValue.Get();
					var varValueNew = is_real(value) ?
						ini_read_real(_optionsGroupName, varName, value) :
						ini_read_string(_optionsGroupName, varName, value);
					varValue.Set(varValueNew);
				}
			}
		}
		
		ini_close();
	}
	
	static SaveOptions = function()
	{
		ini_open(_optionsFilename);
		
		var varNames = struct_get_names(self);
		var n = array_length(varNames);
		for(var i=0; i<n; i++)
		{
			var varName = varNames[i];
			var varValue = struct_get(self, varName);
			if(!is_method(varValue) && is_struct(varValue) && string_char_at(varName, 1)!="_")
			{
				var value = varValue.Get(); 
				if(is_string(varName))
				{
					ini_write_string(_optionsGroupName, varName, value);
				}
				else //if(is_real(value)) real
				{
					ini_write_real(_optionsGroupName, varName, value);
				}
			}
		}
		
		ini_close();
		
		_unsaved = false;
	}
	
	static ResetToDefaults = function()
	{
		var varNames = struct_get_names(self);
		var n = array_length(varNames);
		for(var i=0; i<n; i++)
		{
			var varValue = struct_get(self, varNames[i]);
			if(is_instanceof(varValue, sCOption))
			{
				varValue.Reset();
			}
		}
	}
	
	static BindOnChanged = function(struct, func)
	{
		_onChanged.Bind(struct, func);
	}
	
	static IsUnsaved = function() { return _unsaved; }
}


#macro COptionsSystem global._sCOptionsSystem
COptionsSystem = sCOptionsSystem;

/// @ignore
function sCOptionsSystem() constructor
{
	singleton_struct;
	
	/// @ignore
	_groups = {};
	
	/// @ignore
	_unsaved = false;
	
	/// @ignore
	_autosaveTimer = call_later(2, time_source_units_seconds, function(){
		if(_unsaved)
		{
			struct_foreach(_groups, function(name, group){
				if(group.IsUnsaved())
				{
					group.SaveOptions();
				}
			});
			
			_unsaved = false;
		}
	}, true);
	
	static RegisterGroup = function(groupName, group)
	{
		_groups[$ groupName] = group;
		group.BindOnChanged(self, function() { _unsaved = true; });
	}
	
	static LoadAll = function()
	{
		struct_foreach(_groups, function(name, group){ group.LoadOptions(); });
	}
	
	static SaveAll = function()
	{
		struct_foreach(_groups, function(name, group){ group.SaveOptions(); });
	}
}

