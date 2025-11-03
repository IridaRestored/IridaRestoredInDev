var __vocalSyncTimer:Float = 0;
var __vocalOffsetTimer:Float = 0;
var __sounds:Array<Array<Dynamic>>;

// Modified by https://github.com/HEIHUAa

public var usePitchCorrection:Bool = true; // set to false to disable pitch correction

function postUpdate(e:Float) {
	if (!usePitchCorrection || FlxG.sound.music == null) return;

	__vocalSyncTimer -= e;
	if (__vocalSyncTimer > 0) return;
	__vocalSyncTimer = (__vocalSyncTimer < -0.1) ? -0.1 : __vocalSyncTimer + 0.1; // max 10fps

	if (__sounds == null) soundUpdate(); // initialize sound list if not done yet
	var soundCount = __sounds.length;
	if (soundCount == 0) return; // no sounds to sync

	var mt = FlxG.sound.music.getActualTime(); // in ms
	var vs = usePitchCorrection ? 625 : 144; // 12ms for no pitch correction, 25ms for pitch correction
	var pf = 0.00025; // pitch factor
	var sm = 0.1; // smoothing

	// account for offset changes
	var i = soundCount;
	while (i-- > 0) {
		var sd = __sounds[i];
		var s = sd[0];
		var ct = s.getActualTime();

		var diff = mt - ct;
		sd[1] += (diff - sd[1]) * sm; // smooth the difference

		s.pitch = 1 + sd[1] * pf; // pitch adjustment

		var os = sd[1];
		if (os * os > vs) {
			sd[1] = 0;
			s.play(true, Conductor.songPosition); // restart sound at music position
		}
	}
}

// Call this function whenever you load new sounds
// to make sure the sound list is up to date
public function soundUpdate() {
	var sounds = [];
	var idx = 0;

	// add main vocals
	if (vocals.loaded) sounds[idx++] = [vocals, 0];

	// also add strumline vocals
	var sl = strumLines.members;
	var sln = sl.length;
	for (i in 0...sln) {
		var sv = sl[i].vocals;
		if (sv.loaded) sounds[idx++] = [sv, 0]; // [sound, offset]
	}

	__sounds = sounds; // update sound list
}