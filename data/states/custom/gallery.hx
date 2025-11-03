import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BlendMode;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;
import funkin.menus.ModSwitchMenu;

var bg:FlxSprite;
var overlay:FlxSprite;
var box:FlxSprite;
var play:FlxSprite;
var songs:FlxSprite;
var art:FlxSprite;
var video:FlxVideoSprite;
var songSelected:Int = 0;
var sus:Int = 0;
var songGRP:FlxTypedSpriteGroup<FlxSprite>;

// Botones móviles
var leftButton:FlxSprite;
var rightButton:FlxSprite;

var songArray:Array<Dynamic> =
[
    ['cordeyceps', 'cordyceps old'],
    ['the corpse is mocking me', 'HELAUGHSATTHEWICKED'],
    ['shucksold', 'shucks-old']
];

function create() {
    add(video = new FlxVideoSprite(0,0)).load(Assets.getPath(Paths.video('static','mov')), [':input-repeat=65535']);
    video.scale.set(1,1);
    video.play();

    glow = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/glow'));
    glow.scale.set(0.517, 0.517);
    glow.blend = BlendMode.ADD;
    glow.screenCenter();
    add(glow);

    songGRP = new FlxTypedSpriteGroup();
    for (i in 0...songArray.length)
    {
        songName = songArray[sus][0].toLowerCase();
        var record:FlxSprite = new FlxSprite(sus * 240, -340).loadGraphic(Paths.image('menus/gallery/songs/' + songName));
        record.ID = i;
        record.scale.set(0.517, 0.517);
        songGRP.add(record);
        sus += 1;
    }
    add(songGRP);
    songGRP.x = -640;

    bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/bg'));
    bg.scale.set(0.517, 0.517);
    bg.blend = BlendMode.MULTIPLY;
    bg.screenCenter();
    add(bg);

    overlay = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/overlay'));
    overlay.scale.set(0.517, 0.517);
    overlay.screenCenter();
    add(overlay);

    play = new FlxSprite(-650, -250).loadGraphic(Paths.image('menus/gallery/play'));
    play.screenCenter();
    play.scale.set(0.517, 0.517);
    play.antialiasing = false;
    add(play);

    box = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/box'));
    box.scale.set(0.517, 0.517);
    box.screenCenter();
    add(box);

    art = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/concept art'));
    art.scale.set(0.517, 0.517);
    art.screenCenter();
    add(art);

    songs = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/scrapped songs'));
    songs.scale.set(0.517, 0.517);
    songs.screenCenter();
    add(songs);

    // Crear botones móviles
    leftButton = new FlxSprite(30, FlxG.height - 150).loadGraphic(Paths.image('Mobile Exclusive/Left Buttom'));
    leftButton.scale.set(0.52, 0.52);
    leftButton.scrollFactor.set();
    add(leftButton);

    rightButton = new FlxSprite(leftButton.x + leftButton.width + 20, FlxG.height - 150).loadGraphic(Paths.image('Mobile Exclusive/Right Buttom'));
    rightButton.scale.set(0.52, 0.52);
    rightButton.scrollFactor.set();
    add(rightButton);
}

var Xpos:Int = -640;
function update(elapsed:Float) {
    trace(songSelected);
    var mfs:Float = FlxMath.bound(elapsed * 6, 0, 1);

    songGRP.forEach(function(spr:FlxSprite) {
        if (spr.ID == songSelected) {
            spr.alpha = FlxMath.lerp(spr.alpha, 1, mfs);
            spr.scale.x = FlxMath.lerp(spr.scale.x, 0.517, mfs);
            spr.scale.y = FlxMath.lerp(spr.scale.y, 0.517, mfs);
        } else {
            spr.alpha = FlxMath.lerp(spr.alpha, 0.4, mfs);
            spr.scale.x = FlxMath.lerp(spr.scale.x, 0.4, mfs);
            spr.scale.y = FlxMath.lerp(spr.scale.y, 0.4, mfs);
        }
    });

    // Teclas normales
    if (controls.LEFT_P){
        changeItem(-1,1);
    }
    if (controls.RIGHT_P){
        changeItem(1,2);
    }
    if (controls.ACCEPT){
        startSong();
    }

    if (controls.BACK){
        new FlxTimer().start(0.5, function(tmr:FlxTimer) {
            FlxG.switchState(new ModState('custom/mainmenu'));
        });
    }

    // Botones móviles: tap sobre ellos
    if (FlxG.mouse.overlaps(leftButton) && FlxG.mouse.justPressed){
        changeItem(-1,1);
    }
    if (FlxG.mouse.overlaps(rightButton) && FlxG.mouse.justPressed){
        changeItem(1,2);
    }

    // Tap global → aceptar si NO tocas los botones
    if (FlxG.mouse.justPressed &&
        !FlxG.mouse.overlaps(leftButton) && !FlxG.mouse.overlaps(rightButton)) {
        startSong();
    }
}

function startSong(){
    PlayState.loadSong(songArray[songSelected][1].toLowerCase(), 'hard');
    FlxG.switchState(new PlayState());
}

function changeItem(huh:Int = 0, dic:Int = 1){
    if (dic == 1){
        if (songSelected == 0)
            Xpos = -880;
        else
            Xpos += 240;
    }
    if (dic == 2){
        if (songSelected == songArray.length - 1)
            Xpos = -640;
        else
            Xpos -= 240;
    }

    songSelected = FlxMath.wrap(songSelected + huh, 0, songArray.length - 1);
    FlxTween.tween(songGRP, {x: Xpos}, 0.3, {ease: FlxEase.expoOut});
}
