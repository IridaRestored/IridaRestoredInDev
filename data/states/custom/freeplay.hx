import sys.FileSystem;
import openfl.Lib;
import funkin.editors.ui.UIState;

//menu assets
var back:FlxSprite;
var stuff:FlxSprite;
var pause:FlxSprite;
var play:FlxSprite;
var backwindow:FlxSprite;
var songs:FlxSprite;
var bar:FlxSprite;

//functionality
var select:FlxSprite;
var currentPosition: Int = 1;
var hitboxes:Array<FlxSprite> = [];
var songList:Array<String> = ['irida', 'shucks', 'execretion', 'revenant', 'cordyceps', 'the corpse is mocking me']; //temp
var walppaper = StringTools.replace(FileSystem.absolutePath(Assets.getPath("assets/images/menus/freeplay/irida.bmp")), "/", "\\");
var transitioning:Bool = false;

function create() {    
    add(back = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/back')));
    add(stuff = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/stuff')));
    add(pause = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/pause')));
    add(play = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/yt')));
    add(backwindow = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/backwindow')));
    add(songs = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/songs')));
    add(bar = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/bar')));
    add(select = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/select')));

    for (i in 0...6) {
        var hitbox = new FlxSprite(700, 360 + (i * 50)).makeSolid(70, 40, 0xFF0000FF);
        hitbox.alpha = 0;
        add(hitbox);
        hitboxes.push(hitbox);
        if (i >= 2) {
            hitbox.y = 455 + (i - 2) * 45;
        }
    }

    for (i in [back, stuff, pause, play, backwindow, songs, bar, select]) {
        i.scale.set(0.5, 0.5);
        i.screenCenter();
    }
    updateSelectPosition();
}

function updateSelectPosition(): Void {
    select.y = 30 * (currentPosition - 1);
    select.x = FlxG.width / 2 - select.width / 2;
}

function loadAndSwitchState(songName: String): Void {
    PlayState.loadSong(songName, 'hard');
    FlxG.switchState(new PlayState());
}

override function update(elapsed: Float): Void {
    if (transitioning) return;

    if (controls.BACK) {
        FlxG.switchState(new UIState(true, "custom/code"));
    }

    if (FlxG.keys.justPressed.UP) {
        if (currentPosition > 1) {
            currentPosition--;
        } else {
            currentPosition = 6;
        }
        updateSelectPosition();
    } else if (FlxG.keys.justPressed.DOWN) {
        if (currentPosition < 6) {
            currentPosition++;
        } else {
            currentPosition = 1;
        }
        updateSelectPosition();
    }

    for (i in 0...hitboxes.length) {
        var hitbox = hitboxes[i];
        if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed) {
            startTransition(songList[i]);
        }
    }

    if (FlxG.keys.justPressed.ENTER) {
        startTransition(songList[currentPosition - 1]);
    }
}

function startTransition(songName:String):Void {
    transitioning = true;

    var originalX = FlxG.camera.scroll.x;
    var originalY = FlxG.camera.scroll.y;
    var targetX = originalX - 140;
    var targetY = originalY - 110;

    FlxTween.tween(FlxG.camera.scroll, { x: targetX, y: targetY }, 0.5, {
        ease: FlxEase.quadOut,
        onComplete: function(twn) {
            FlxTween.tween(FlxG.camera, { zoom: 105 }, 0.6, {
                ease: FlxEase.quadIn,
                onComplete: function(twn) {
                    loadAndSwitchState(songName);
                }
            });
        }
    });
}

function destroy() {
    setWallpaper(prevWallpaper);
}