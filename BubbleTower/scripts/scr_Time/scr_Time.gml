#macro CTime global._sCTime
CTime = sCTime;

/// @ignore
function sCTime() constructor
{
	singleton_struct;
	
	var dt = game_get_speed(gamespeed_microseconds) * 0.000001;
	RawDeltaTime = dt;
	RawDeltaTimePrev = dt;
	RawDeltaTimeSmooth = dt;
	DeltaTime = dt;
	NonScaledDeltaTime = dt;
	CurrentTime = 0;
	NonScaledCurrentTime = 0;
	DeltaTimeMax = 1/30;
	TimeScale = 1.0;
	Frame = 0;
	
	/// @ignore
	_update = function()
	{
		Frame++;
		RawDeltaTimePrev = DeltaTime;
		RawDeltaTime = delta_time * 0.000001;
		RawDeltaTimeSmooth = (RawDeltaTimePrev + RawDeltaTime) * 0.5;
		
		NonScaledCurrentTime = current_time * 0.000001;
		NonScaledDeltaTime = min(RawDeltaTimeSmooth, DeltaTimeMax);
		DeltaTime = NonScaledDeltaTime * TimeScale;
		CurrentTime += DeltaTime;
	}
	
	/// @ignore
	_ts = time_source_create(time_source_game, 1, time_source_units_frames, _update, [], -1, time_source_expire_nearest);
	time_source_start(_ts);
}

