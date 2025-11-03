import funkin.menus.ModSwitchMenu;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;

var logo:FlxSprite;
var text:FlxSprite;
var centerpillar:FlxSprite;
var pillar1:FlxSprite;
var pillar2:FlxSprite;
var pillar3:FlxSprite;
var edgepillars:FlxSprite;
var textglow:FlxSprite;
var textglow2:FlxSprite;
var dark:FlxSprite;
var glow:FlxSprite;
var spike:FlxBackdrop;
var bg:FlxSprite;

var exit:Bool = false;

function preloadImages() {
    var images = [
        'menus/titlescreen/bg',
        'menus/titlescreen/pillar1',
        'menus/titlescreen/pillar2',
        'menus/titlescreen/pillar3',
        'menus/titlescreen/centerpillar',
        'menus/titlescreen/edgepillars',
        'menus/titlescreen/darkness',
        'menus/titlescreen/logo',
        'menus/titlescreen/glow',
        'menus/titlescreen/text',
        'menus/titlescreen/textglow',
        'menus/titlescreen/textglow2',
        'menus/titlescreen/spike'
    ];
    for (img in images) Paths.image(img);
}

function addLayer(path:String, scrollX:Float = 1, scrollY:Float = 1):FlxSprite {
    var spr = new FlxSprite(-320, -900).loadGraphic(Paths.image(path));
    spr.screenCenter();
    spr.scrollFactor.set(scrollX, scrollY);
    spr.scale.set(0.52, 0.52);
    add(spr);
    return spr;
}

function create() {
    preloadImages();

    FlxG.sound.playMusic(Paths.music('mainmenu'), 0);
    FlxG.sound.music.fadeIn(0.5, 0, 0.8);

    bg = addLayer('menus/titlescreen/bg', 0.2, 0.2);
    pillar3 = addLayer('menus/titlescreen/pillar3', 0.3, 0.3);
    pillar2 = addLayer('menus/titlescreen/pillar2', 0.4, 0.4);
    pillar1 = addLayer('menus/titlescreen/pillar1', 0.5, 0.5);
    centerpillar = addLayer('menus/titlescreen/centerpillar');
    edgepillars = addLayer('menus/titlescreen/edgepillars');

    spike = new FlxBackdrop(Paths.image('menus/titlescreen/spike'));
    spike.y = -340;
    spike.scale.set(0.52, 0.52);
    spike.velocity.x = 30;
    add(spike);

    dark = new FlxSprite(-320, -900).loadGraphic(Paths.image('menus/titlescreen/darkness'));
    dark.screenCenter();
    dark.scale.set(0.6, 0.6);
    add(dark);

    logo = new FlxSprite(-697, 950).loadGraphic(Paths.image('menus/titlescreen/logo'));
    logo.screenCenter();
    logo.scale.set(0.52, 0.52);
    add(logo);

    glow = new FlxSprite(-697, 950).loadGraphic(Paths.image('menus/titlescreen/glow'));
    glow.screenCenter();
    glow.scale.set(0.52, 0.52);
    glow.alpha = 1;
    add(glow);

    FlxTween.tween(glow, {alpha: 0}, 5, {type: FlxTween.PINGPONG, ease: FlxEase.smootherStepInOut});

    text = new FlxSprite(-640, 950).loadGraphic(Paths.image('menus/titlescreen/text'));
    text.scale.set(0.52, 0.52);
    add(text);

    textglow = new FlxSprite(-640, 950).loadGraphic(Paths.image('menus/titlescreen/textglow'));
    textglow.scale.set(0.52, 0.52);
    textglow.blend = BlendMode.ADD;
    add(textglow);

    textglow2 = new FlxSprite(-640, 950).loadGraphic(Paths.image('menus/titlescreen/textglow2'));
    textglow2.scale.set(0.52, 0.52);
    textglow2.alpha = 0.1;
    textglow2.blend = BlendMode.ADD;
    add(textglow2);

    prevWallpaper = getWallpaper();
}

function update(elapsed:Float) {
    var mouse = FlxG.mouse.getScreenPosition(FlxG.camera);
    FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, (mouse.x / 60) - 20, FlxG.elapsed * 15);
    FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, (mouse.y / 60) - 5, FlxG.elapsed * 15);

    var targetY = -340;
    text.y = FlxMath.lerp(text.y, targetY, FlxMath.bound(FlxG.elapsed * 6, 0, 1));
    textglow.y = text.y;
    textglow2.y = text.y;

    if (exit) {
        textglow2.alpha = FlxMath.lerp(textglow2.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 3, 0, 1));
        FlxTween.tween(spike, {alpha: 0}, 0.5, {ease: FlxEase.circInOut});
    }

    // Detecta tanto ENTER/ESPACIO/etc como tap/click en móvil
    if (controls.ACCEPT || FlxG.mouse.justPressed) {
        FlxG.sound.play(Paths.sound('START'), 0.3);
        exit = true;
        textglow2.alpha = 1;
        FlxG.sound.music.fadeOut(0.5, 0);

        new FlxTimer().start(1, function(tmr:FlxTimer) {
            FlxG.switchState(new MainMenuState());  
        });
    }
}
