import funkin.editors.ui.UIState;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.menus.credits.CreditsMain;
import funkin.backend.system.framerate.Framerate;

var keys:Array<FlxSprite>;
var backkeys:FlxSprite;
var extrakeys:FlxSprite;
var bg:FlxSprite;
var fakeCrashWhite:FlxSprite;

var wave = new CustomShader('water');
var curSelected = 0;
var crash:Bool = false;

// Botones móviles (forzados a aparecer siempre para test)
var upButton:FlxSprite;
var downButton:FlxSprite;

function create() {
    var bgPaths = [
        'menus/mainmenu/bgs/story',
        'menus/mainmenu/bgs/codes',
        'menus/mainmenu/bgs/gallery',
        'menus/mainmenu/bgs/credits',
        'menus/mainmenu/bgs/options'
    ];
    for (path in bgPaths) {
        var cacheBg = new FlxSprite().loadGraphic(Paths.image(path));
    }

    var keysInfo = [
        {img: 'key 4', idle: 'key 4 idle', selected: 'key 4 selected'},
        {img: 'key 2', idle: 'key 2 idle', selected: 'key 2 selected'},
        {img: 'key 1', idle: 'key 1 idle', selected: 'key 1 selected'},
        {img: 'key 3', idle: 'key 3 idle', selected: 'key 3 selected'},
        {img: 'key 5', idle: 'key 5 idle', selected: 'key 5 selected'}
    ];
    for (info in keysInfo) {
        var cacheKey = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/' + info.img));
        var cacherames = Paths.getSparrowAtlas('menus/mainmenu/' + info.img);
    }

    FlxG.sound.playMusic(Paths.music('mainmenu'), 0);
    FlxG.sound.music.fadeIn(0.5, 0, 0.8);

    bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/bgs/story'));
    bg.scale.set(0.517, 0.517);
    bg.shader = wave;
    bg.screenCenter();
    add(bg);

    backkeys = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/back keys'));
    backkeys.scale.set(0.52, 0.52);
    backkeys.screenCenter();
    add(backkeys);

    keys = [];
    for (info in keysInfo) {
        var key = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/' + info.img));
        key.frames = Paths.getSparrowAtlas('menus/mainmenu/' + info.img);
        key.animation.addByPrefix('idle', info.idle, 24);
        key.animation.addByPrefix('selected', info.selected, 24);
        key.animation.play('idle');
        key.scale.set(0.52, 0.52);
        key.screenCenter();
        add(key);
        keys.push(key);
    }

    extrakeys = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/extra keys'));
    extrakeys.scale.set(0.52, 0.52);
    extrakeys.screenCenter();
    add(extrakeys);

    fakeCrashWhite = new FlxSprite().makeGraphic(1920, 1080, 0xFFF0F0F0);
    fakeCrashWhite.alpha = 0;
    add(fakeCrashWhite);

    // Botones móviles
    upButton = new FlxSprite().loadGraphic(Paths.image('Mobile Exclusive/Up buttom'));
    upButton.scale.set(0.52, 0.52);
    upButton.x = FlxG.width - upButton.width - 20;
    upButton.y = FlxG.height / 2 - upButton.height - 20;
    upButton.scrollFactor.set();
    add(upButton);

    downButton = new FlxSprite().loadGraphic(Paths.image('Mobile Exclusive/Down buttom'));
    downButton.scale.set(0.52, 0.52);
    downButton.x = FlxG.width - downButton.width - 20;
    downButton.y = FlxG.height / 2 + 20;
    downButton.scrollFactor.set();
    add(downButton);

    FlxTween.tween(window, {opacity: 1}, 1, {ease: FlxEase.expoOut});
}

function update(elapsed:Float) {
    wave.iTime = Conductor.songPosition / 10000;

    var bgPaths = [
        'menus/mainmenu/bgs/story',
        'menus/mainmenu/bgs/codes',
        'menus/mainmenu/bgs/gallery',
        'menus/mainmenu/bgs/credits',
        'menus/mainmenu/bgs/options'
    ];

    var selectedKeyIndex = [0,1,4,3,2][curSelected];
    bg.loadGraphic(Paths.image(bgPaths[curSelected]));

    for (i in 0...keys.length) {
        if (i == selectedKeyIndex) {
            if (keys[i].animation.curAnim.name != "selected")
                keys[i].animation.play('selected');
            keys[i].x = FlxMath.lerp(keys[i].x, -640, FlxMath.bound(FlxG.elapsed * 6, 0, 1));
        } else {
            if (keys[i].animation.curAnim.name != "idle")
                keys[i].animation.play('idle');
            keys[i].x = FlxMath.lerp(keys[i].x, -650, FlxMath.bound(FlxG.elapsed * 6, 0, 1));
        }
    }

    if (!crash) {
        if (controls.UP_P) {
            FlxG.sound.play(Paths.sound('1meow'), 0.3);
            curSelected = (curSelected <= 0) ? 4 : curSelected - 1;
        }
        if (controls.DOWN_P) {
            FlxG.sound.play(Paths.sound('2meow'), 0.3);
            curSelected = (curSelected >= 4) ? 0 : curSelected + 1;
        }

        // Tap en botones → mover arriba/abajo
        if (FlxG.mouse.overlaps(upButton) && FlxG.mouse.justPressed) {
            FlxG.sound.play(Paths.sound('1meow'), 0.3);
            curSelected = (curSelected <= 0) ? 4 : curSelected - 1;
        }
        if (FlxG.mouse.overlaps(downButton) && FlxG.mouse.justPressed) {
            FlxG.sound.play(Paths.sound('2meow'), 0.3);
            curSelected = (curSelected >= 4) ? 0 : curSelected + 1;
        }

        // Tap global → aceptar, pero solo si NO tocamos los botones
        if (FlxG.mouse.justPressed && 
            !FlxG.mouse.overlaps(upButton) && 
            !FlxG.mouse.overlaps(downButton)) {
            doAccept();
        }
    }

    if (controls.ACCEPT) {
        doAccept();
    }

    if (controls.BACK) {
        FlxG.sound.music.fadeOut(0.5, 0);
        new FlxTimer().start(0.5, function(_) {
            FlxG.switchState(new TitleState());
        });
    }

    if (FlxG.keys.justPressed.FIVE) {
        FlxG.sound.music.fadeOut(0.5, 0);
        FlxTween.tween(window, {opacity: 0}, 0.5, {ease: FlxEase.expoOut});
        new FlxTimer().start(1, function(_) {
            FlxG.switchState(new UIState(true, "custom/code"));
        });
    }

    if (controls.SWITCHMOD || FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(controls.SWITCHMOD ? new ModSwitchMenu() : new EditorPicker());
    }
}

function doAccept() {
    FlxG.sound.music.fadeOut(0.01, 0);
    if (curSelected == 0) iridathing();

    if (curSelected == 1) {
        FlxG.sound.music.fadeOut(0.5, 0);
        FlxTween.tween(window, {opacity: 0}, 0.5, {ease: FlxEase.expoOut});
        new FlxTimer().start(1, function(_) {
            FlxG.switchState(new UIState(true, "custom/code"));
        });
    }

    if (curSelected == 2) FlxG.switchState(new ModState('custom/gallery'));
    if (curSelected == 3) FlxG.switchState(new CreditsState());
    if (curSelected == 4) FlxG.switchState(new OptionsMenu());
}

function iridathing() {
    crash = true;
    FlxTween.tween(Framerate.offset, {y: -900}, 0.0005, {ease: FlxEase.cubeOut});
    new FlxTimer().start(3, function(_) {
        window.title += " (Not Responding)";
        FlxTween.tween(fakeCrashWhite, {alpha: 0.6}, 0.5, {ease: FlxEase.linear});
    });
    new FlxTimer().start(8, function(_) {
        window.opacity = 0;
    });
    new FlxTimer().start(10, function(_) {
        PlayState.loadSong('irida', 'hard');
        FlxG.switchState(new PlayState());
    });
}
