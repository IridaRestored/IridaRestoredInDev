import hxvlc.flixel.FlxVideoSprite;
import psychlua.LuaUtils;

var videoSprites:Array<FlxVideoSprite> = [];

createGlobalCallback('makeVideoSprite', function(tag:String, videoName:String, ?x:Float, ?y:Float, ?camera:String, ?looped:Bool) {
    if (game.variables.exists(tag)) {
        debugPrint('Video sprite with tag "'+tag+'" already exists!', 0xFFFF0000);
        return;
    }

    x ??= 0;
    y ??= 0;
    camera ??= 'camHUD';
    looped ??= false;

    var video = new FlxVideoSprite(x, y);
    video.antialiasing = ClientPrefs.data.antialiasing;
    video.camera = LuaUtils.cameraFromString(camera);
    video.load(Paths.video(videoName), looped ? ['input-repeat=65545'] : null);
    if (!looped) {
        video.bitmap.onEndReached.add(()->{
            remove(video);
            removeVar(tag);
            videoSprites.remove(video);
        });
    }
    videoSprites.push(video);
    game.variables.set(tag, video);
});
createGlobalCallback('playVideoSprite', function(tag:String) {
    if (!game.variables.exists(tag)) {
        debugPrint('Video sprite with tag "'+tag+'" doesn\'t exist!', 0xFFFF0000);
        return;
    }

    add(game.variables.get(tag));
    game.variables.get(tag).play();
});

function onPause() {
    for (video in videoSprites) {
        video.pause();
        if (FlxG.signals.focusLost.has(video.pause)) {
            FlxG.signals.focusLost.remove(video.pause);
        }
        if (FlxG.signals.focusGained.has(video.resume)) {
            FlxG.signals.focusGained.remove(video.resume);
        }
    }
}

function onResume() {
    for (video in videoSprites) {
        video.resume();
        if (!FlxG.signals.focusLost.has(video.pause)) {
            FlxG.signals.focusLost.add(video.pause);
        }
        if (!FlxG.signals.focusGained.has(video.resume)) {
            FlxG.signals.focusGained.add(video.resume);
        }
    }
}