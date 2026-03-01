#macro CAudioSettings global.sCAudioSettings
CAudioSettings = sCAudioSettings;

/// @ignore
function sCAudioSettings() : sCOptionGroup("Audio") constructor
{
	singleton_struct;
	
	MusicVolume = new sCOption(50, function(value) {
		return clamp(round(value), 0, 100);
	});
	
	SoundVolume = new sCOption(50, function(value) {
		return clamp(round(value), 0, 100);
	});
	
	/*
	MusicEnable = new sCOption(true, function(value) {
		return bool(value);
	});
	
	SoundEnable = new sCOption(true, function(value) {
		return bool(value);
	});
	*/
	
	Enable = new sCOption(true, function(value) {
		return bool(value);
	});
	
	InitOptions();
	
	MusicEnable = Enable;
	SoundEnable = Enable;
}

#macro CAudio global.sCAudio
CAudio = sCAudio;

/// @ignore
function sCAudio() constructor
{
	singleton_struct;
	
	Settings = new sCAudioSettings();
	
	/// @ignore
	_pausableSounds = [];
	
	/// @ignore
	_addPausableSound = function(sound)
	{
		array_push(_pausableSounds, sound);
	}
	
	/// @ignore
	_clearUnusedSounds = function()
	{
		var n = array_length(_pausableSounds);
		for(var i=0; i<n; i++)
		{
			if(!audio_is_playing(_pausableSounds[i]))
			{
				array_delete(_pausableSounds, i, 1);
				i--;
				n--;
			}
		}
		
		return n;
	}
	
	/// @ignore
	_pauseAllSFX = function()
	{
		var n = _clearUnusedSounds();
		for(var i=0; i<n; i++)
		{
			audio_pause_sound(_pausableSounds[i]);
		}
	}
	
	/// @ignore
	_resumeAllSFX = function()
	{
		var n = _clearUnusedSounds();
		for(var i=0; i<n; i++)
		{
			audio_resume_sound(_pausableSounds[i]);
		}
	}
	
	LoadBGMAudioGroup = function()
	{
		audio_group_load(agp_BGM);
	}
	
	BGMAudioGroupLoaded = function()
	{
		return audio_group_is_loaded(agp_BGM);
	}
	
	//audio_group_load(agp_BGM);
	//audio_group_load(agp_UI);
	//audio_group_load(agp_Popup);
	//audio_group_load(audiogroup_default); // <- SFX. Loading by default.
	
	/// @ignore
	_bgmAsset = undefined;
	
	/// @ignore
	_bgm = undefined;
	
	/// @ignore
	_bgmVolume = 1;
	
	/// @ignore
	_bgmFadeValue = 1;
	
	/// @ignore
	_bgmPrev = undefined;
	
	/// @ignore
	_bgmMutersNum = 0;
	
	/// @ignore
	_bgmMuteCoef = 0;
	
	/// @ignore
	_popupAudio = undefined;
	
	/// @ignore
	_popupMute = 1;
	
	OnGlobalPause = function()
	{
		audio_pause_all();
	}
	
	OnGlobalResume = function()
	{
		audio_resume_all();
		if(GAMEPLAY_PAUSE)
		{
			_pauseAllSFX();
		}
	}
	
	OnGameplayPause = function()
	{
		if(!GLOBAL_PAUSE)
		{
			_pauseAllSFX();
		}
	}
	
	OnGameplayResume = function()
	{
		_resumeAllSFX();
	}
	
	/// @ignore
	_update = function()
	{
		var masterVolume = 1; //1 - CScreenFader.GetFadeValue();
		audio_master_gain(masterVolume);
		
		if(_bgmMutersNum>0)
		{
			_bgmMuteCoef = value_step_to(_bgmMuteCoef, 1, 1/30);
		}
		else
		{
			_bgmMuteCoef = value_step_to(_bgmMuteCoef, 0, 1/30);
		}
		
		if(_popupAudio!=undefined)
		{
			_popupMute = 0.5;
			if(!audio_is_playing(_popupAudio))
			{
				_popupAudio = undefined;
			}
		}
		else
		{
			if(_popupMute<1)
			{
				_popupMute = value_step_to(_popupMute, 1, 1/60);
			}
		}
		
		var musicVolume = CAudioSettings.MusicVolume.Get() * 0.01 * (CAudioSettings.MusicEnable.Get());
		var bgmVolume = musicVolume * lerp(1, 0.5, _bgmMuteCoef) * _popupMute;
		audio_group_set_gain(agp_BGM, bgmVolume, 0);
		
		var sfxVolume = CAudioSettings.SoundVolume.Get() * 0.01 * (CAudioSettings.SoundEnable.Get());
		audio_group_set_gain(audiogroup_default, sfxVolume, 0);
		audio_group_set_gain(agp_UI, sfxVolume, 0);
		audio_group_set_gain(agp_Popup, sfxVolume, 0);
		
		if(_bgmPrev!=undefined) // and playing?
		{
			_bgmFadeValue = value_step_to(_bgmFadeValue, 0, 1/60);
			
			audio_sound_gain(_bgm, _bgmFadeValue * _bgmVolume, 0);
			
			if(_bgmFadeValue==0)
			{
				audio_stop_sound(_bgmPrev);
				_bgmPrev = undefined;
				_bgmFadeValue = 1;
				_bgm = _bgmAsset!=undefined ? audio_play_sound(_bgmAsset, 100, true, _bgmVolume) : undefined;
			}
		}
		
		//if(_bgm!=undefined)
		//{
		//	audio_sound_gain(_bgm, _bgmFadeValue * _bgmVolume, 0);
		//}
	}
	
	/// @ignore
	_updateTimer = time_source_create(time_source_global, 1, time_source_units_frames, _update, [], -1);
	time_source_start(_updateTimer);
	
	// Background Music
	
	PlayBGM = function(audioAsset, immediately=false, volume=1, loops=true)
	{
		if(audioAsset!=undefined && audio_sound_get_audio_group(audioAsset)!=agp_BGM)
		{
			show_error("Attempting to play BGM audio that is not marked with 'agp_BGM' group.", false);
			return;
		}
		
		if(!immediately)
		{
			if(_bgmAsset==audioAsset)
			{
				return _bgm;
			}
			
			if(_bgm!=undefined)
			{
				_bgmFadeValue = 1;
				if(_bgmPrev!=undefined)
				{
					audio_stop_sound(_bgmPrev);
				}
				_bgmPrev = _bgm;
			}
		}
		else
		{
			if(_bgmPrev!=undefined)
			{
				audio_stop_sound(_bgmPrev);
				_bgmPrev = undefined;
			}
			
			_bgmFadeValue = 0;
			
			if(_bgmAsset!=audioAsset || audioAsset==undefined)
			{
				if(_bgm!=undefined)
				{
					audio_stop_sound(_bgm);
					_bgm = undefined;
				}
			}
			else
			{
				if(_bgm!=undefined)
				{
					_bgmVolume = volume;
					audio_sound_gain(_bgm, _bgmVolume, 0);
				}
				return _bgm;
			}
		}
		
		_bgmVolume = volume;
		_bgmAsset = audioAsset;
		
		if(_bgmPrev==undefined)
		{
			_bgm = _bgmAsset!=undefined ? audio_play_sound(_bgmAsset, 100, loops, _bgmVolume) : undefined;
		}
		
		return _bgm;
	}
	
	StopBGM = function(immediately=false)
	{
		PlayBGM(undefined, immediately);
	}
	
	GetBGMAsset = function()
	{
		return _bgmAsset;
	}
	
	AddBGMMuter = function()
	{
		_bgmMutersNum++;
	}
	
	RemoveBGMMuter = function()
	{
		_bgmMutersNum = max(_bgmMutersNum-1, 0);
	}
	
	// Popup Effect
	
	PlayPopup = function(audioAsset, gain=1, pitch=1, pausable=undefined)
	{
		if(audio_sound_get_audio_group(audioAsset)!=agp_Popup)
		{
			show_error("Attempting to play popup audio that is not marked with 'agp_Popup' group.", false);
			return;
		}
		
		if(_popupAudio!=undefined)
		{
			audio_stop_sound(_popupAudio);
		}
		
		_popupAudio = audio_play_sound(audioAsset, 100, false, gain, 0, pitch);
		
		if(pausable==undefined || pausable)
		{
			_addPausableSound(_popupAudio);
		}
		
		return _popupAudio;
	}
	
	// Sound Effects
	
	PlaySFX = function(audioAsset, gain=1, pitch=1, pausable=undefined, loop=false)
	{
		var agp = audio_sound_get_audio_group(audioAsset);
		if(agp!=audiogroup_default && agp!=agp_UI)
		{
			show_error("Attempting to play SFX audio that is not marked with 'audiogroup_default' or 'agp_UI' group.", false);
			return;
		}
		
		var snd = audio_play_sound(audioAsset, 5, loop, gain, 0, pitch);
		
		if((pausable==undefined && agp!=agp_UI) || pausable)
		{
			_addPausableSound(snd);
		}
		
		return snd;
	}
	
	StopSFX = function(sound)
	{
		audio_stop_sound(sound);
	}
	
	PlaySFXAtLocation = function(audioAsset, locX, locY, locZ, gain=1, pitch=1, pausable=undefined, loop=false)
	{
		/*
		var cam = view_get_camera(0);
		var vx = camera_get_view_x(cam);
		var vy = camera_get_view_y(cam);
		if(px > vx && px < vx + GameScreenW && py > vy && py < vy + GameScreenH)
		{
			audio_play_sound_at(sound, locX, locY, locZ, 1, 1000, 1, loop, 0, gain, 0, pitch);
			PlaySFX(sound, );
			YxAudio_Play(sound, gain, pitch);
		}
		*/
	}
	
	// STOP ALL
	
	StopAll = function()
	{
		audio_stop_all();
		_bgmAsset = undefined;
		_bgm = undefined;
		_bgmVolume = 1;
		_bgmFadeValue = 1;
		_bgmPrev = undefined;
		
		_bgmMutersNum = 0;
		_bgmMuteCoef = 0;
		
		_popupAudio = undefined;
		
		_pausableSounds = [];
	}
}

