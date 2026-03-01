#macro CLocalizationSettings global.sCLocalizationSettings
CLocalizationSettings = sCLocalizationSettings;

/// @ignore
function sCLocalizationSettings() : sCOptionGroup("Localization") constructor
{
	singleton_struct;
	
	Language = new sCOption(CLocalization.CurrentCode(), function(value) {
		return CLocalization.HasCode(value) ? string_upper(value) : CLocalization.DefaultCode();
	});
	
	InitOptions();
}


#macro CLocalization global.sCLocalization
CLocalization = sCLocalization;

/// @ignore
function sCLocalization(languages=undefined) constructor
{
	singleton_struct;
	
	languages ??= [
		{ EN: "English" },
		{ RU: "Русский" }
	];
	
	/// @ignore
	var _initLanguages = function(languages)
	{
		var n = array_length(languages);
		for(var i=0; i<n; i++)
		{
			var language = languages[i];
			var code = struct_get_names(language)[0];
			var name = struct_get(language, code);
			array_push(_codes, code);
			array_push(_names, name);
		}
	}
	
	/// @return {Array<String>}
	static Codes = function() { return _codes; }
	
	/// @return {Array<String>}
	static Names = function() { return _names; }
	
	/// @return {String}
	static DefaultCode = function() { return _codes[0]; }
	
	/// @return {String}
	static DefaultName = function() { return _names[0]; }
	
	/// @return {String}
	static CurrentCode = function() { return _codes[ _codeIndex ]; }
	
	/// @return {String}
	static CurrentName = function() { return _names[ _codeIndex ]; }
	
	/// @param {String} code
	/// @return {Bool}
	static HasCode = function(code) { return array_contains(_codes, string_upper(code)); }
	
	/// @return {Real}
	static CurrentCodeIndex = function() { return _codeIndex; }
	
	/// @param {String} code
	/// @return {Real}
	static GetCodeIndex = function(code)
	{
		var codeUpper = string_upper(code);
		var n = array_length(_codes);
		for(var i=0; i<n; i++)
		{
			if(codeUpper==_codes[i])
			{
				return i;
			}
		}
		return -1;
	}
	
	/// @return {Real}
	static GetAutoDetectedCodeIndex = function()
	{
		var code = string_upper(os_get_language());
		return array_find_index_by_value(_codes, code, 0);
	}
	
	/// @ignore
	_codes = [];
	
	/// @ignore
	_names = [];
	
	_initLanguages(languages);
	
	/// @ignore
	_codeIndex = GetAutoDetectedCodeIndex();
	
	/// @ignore
	static _updateCodeIndex = function()
	{
		_codeIndex = array_find_index_by_value(_codes, CLocalizationSettings.Language.Get(), 0);
	}
	
	Settings = new sCLocalizationSettings();
	CLocalizationSettings.Language.BindOnChanged(self, _updateCodeIndex);
	_updateCodeIndex();
}


function sLocVar(structOrValue) constructor
{
	/// @return {Any}
	static Get = function()
	{
		return self[$ CLocalization.CurrentCode() ] ?? self[$ CLocalization.DefaultCode() ];
	}
	
	/// @param {Struct,Any} structOrValue
	static Set = function(structOrValue)
	{
		if(is_struct(structOrValue))
		{
			_fromStruct(structOrValue);
		}
		else
		{
			_fromValue(structOrValue);
		}
		
		return self;
	}
	
	/// @ignore
	static _fromStruct = function(struct)
	{
		static varNames = CLocalization.Codes();
		for(var i=0, n=array_length(varNames); i<n; i++)
		{
			var varName = varNames[i];
			var newVarValue = struct[$ varName];
			struct_set(self, varName, newVarValue);
		}
		
		return self;
	}
	
	/// @ignore
	static _fromValue = function(value)
	{
		static varNames = CLocalization.Codes();
		for(var i=0, n=array_length(varNames); i<n; i++)
		{
			var varName = varNames[i];
			struct_set(self, varName, value);
		}
		
		return self;
	}
	
	Set(structOrValue);
}


function sLocText(structOrString="") : sLocVar(structOrString) constructor
{
	/// @desc Built-in method used in the string(value) function.
	/// @ignore
	static toString = function()
	{
		return Get();
	}
	
	/// @param {Struct,String} structOrString
	/// @return {Struct.sLocText}
	static Append = function(structOrString)
	{
		var locText = new sLocText(structOrString);
		
		static varNames = CLocalization.Codes();
		for(var i=0, n=array_length(varNames); i<n; i++)
		{
			var varName = varNames[i];
			var newVarValue = struct_get(self, varName) + locText[$ varName];
			struct_set(self, varName, newVarValue);
		}
		
		return self;
	}
}

