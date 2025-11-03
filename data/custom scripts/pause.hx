import openfl.display.BlendMode;

var pauseCam = new FlxCamera();
var pauseMusic:FlxSound;
var bar1:FlxSprite;
var bar2:FlxSprite;
var smallbar2:FlxSprite;
var longbar2:FlxSprite;
var fg:FlxSprite;
var resume:FlxSprite;
var restart:FlxSprite;
var exit:FlxSprite;
var resumeglow:FlxSprite;
var restartglow:FlxSprite;
var exitglow:FlxSprite;
var resumeselect:FlxSprite;
var restartselect:FlxSprite;
var exitselect:FlxSprite;
var render:FlxSprite;
var options:Array<FlxText> = ["Resume","Restart Song","Exit to menu"];

function create(event) {
	// cancel default pause menu!!
	event.cancel();

    pauseMusic = FlxG.sound.load(Paths.music('pause' + PlayState.SONG.meta.name), 0, true);
    pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
	pauseMusic.fadeIn(0.5, 0, 0.6);
    FlxG.mouse.visible = true;
    FlxG.cameras.add(pauseCam, false);
    pauseCam.bgColor = 0x88000000;
    pauseCam.alpha = 0;
    pauseCam.zoom = 1.25;
    FlxTween.tween(pauseCam, {alpha: 1, zoom: 1}, .5, {ease: FlxEase.cubeOut});

    bar1 = new FlxSprite().loadGraphic(Paths.image('menus/pause/bar1'));
    bar1.x = -940;
    bar1.y = -340;
    FlxTween.tween(bar1, {x: -640},  1.3, {ease: FlxEase.expoOut});
    bar1.cameras = [pauseCam];
    bar1.scale.set(0.52, 0.52);
    bar1.antialiasing = false;
	add(bar1);

    bar2 = new FlxSprite().loadGraphic(Paths.image('menus/pause/bar2'));
    bar2.x = -340;
    bar2.y = -340;
    FlxTween.tween(bar2, {x: -640},  1.2, {ease: FlxEase.expoOut});
    bar2.cameras = [pauseCam];
    bar2.scale.set(0.52, 0.52);
    bar2.antialiasing = false;
	add(bar2);

    render = new FlxSprite().loadGraphic(Paths.image('menus/pause/renders/' + PlayState.SONG.meta.name));
    render.x = -340;
    render.y = -340;
    FlxTween.tween(render, {x: -640},  1.5, {ease: FlxEase.expoOut});
    render.cameras = [pauseCam];
    render.scale.set(0.52, 0.52);
    render.antialiasing = false;
	add(render);
    
    smallbar2 = new FlxSprite().loadGraphic(Paths.image('menus/pause/smallbar2'));
    smallbar2.x = -40;
    smallbar2.y = -340;
    FlxTween.tween(smallbar2, {x: -640},  2, {ease: FlxEase.expoOut});
    smallbar2.cameras = [pauseCam];
    smallbar2.scale.set(0.52, 0.52);
    smallbar2.antialiasing = false;
	add(smallbar2);

    longbar2 = new FlxSprite().loadGraphic(Paths.image('menus/pause/longbar2'));
    longbar2.x = -340;
    longbar2.y = -340;
    FlxTween.tween(longbar2, {x: -640},  1.5, {ease: FlxEase.expoOut});
    longbar2.cameras = [pauseCam];
    longbar2.scale.set(0.52, 0.52);
    longbar2.antialiasing = false;
	add(longbar2);

    fg = new FlxSprite().loadGraphic(Paths.image('menus/pause/fg'));
    fg.x = -340;
    fg.y = -340;
    FlxTween.tween(fg, {x: -640},  2, {ease: FlxEase.expoOut});
    fg.cameras = [pauseCam];
    fg.scale.set(0.52, 0.52);
    fg.antialiasing = false;
	add(fg);

    resume = new FlxSprite().loadGraphic(Paths.image('menus/pause/resume'));
    resume.x = -940;
    resume.y = -340;
    resume.cameras = [pauseCam];
    resume.scale.set(0.5, 0.5);
    resume.antialiasing = false;
	add(resume);

    restart = new FlxSprite().loadGraphic(Paths.image('menus/pause/restart'));
    restart.x = -940;
    restart.y = -340;
    restart.cameras = [pauseCam];
    restart.scale.set(0.5, 0.5);
    restart.antialiasing = false;
	add(restart);

    exit = new FlxSprite().loadGraphic(Paths.image('menus/pause/exit'));
    exit.x = -940;
    exit.y = -340;
    exit.cameras = [pauseCam];
    exit.scale.set(0.5, 0.5);
    exit.antialiasing = false;
	add(exit);

    resumeglow = new FlxSprite().loadGraphic(Paths.image('menus/pause/resumeglow'));
    resumeglow.x = -940;
    resumeglow.y = -340;
    resumeglow.cameras = [pauseCam];
    resumeglow.scale.set(0.5, 0.5);
    resumeglow.antialiasing = false;
	add(resumeglow);

    restartglow = new FlxSprite().loadGraphic(Paths.image('menus/pause/restartglow'));
    restartglow.x = -940;
    restartglow.y = -340;
    restartglow.cameras = [pauseCam];
    restartglow.scale.set(0.5, 0.5);
    restartglow.antialiasing = false;
	add(restartglow);

    exitglow = new FlxSprite().loadGraphic(Paths.image('menus/pause/exitglow'));
    exitglow.x = -940;
    exitglow.y = -340;
    exitglow.cameras = [pauseCam];
    exitglow.scale.set(0.5, 0.5);
    exitglow.antialiasing = false;
	add(exitglow);

    resumeglow.blend = BlendMode.ADD;
    restartglow.blend = BlendMode.ADD;
    exitglow.blend = BlendMode.ADD;

    resumeselect = new FlxSprite().loadGraphic(Paths.image('menus/pause/resumeselect'));
    resumeselect.x = -940;
    resumeselect.y = -340;
    resumeselect.alpha = 0.1;
    resumeselect.cameras = [pauseCam];
    resumeselect.scale.set(0.5, 0.5);
    resumeselect.antialiasing = false;
	add(resumeselect);

    restartselect = new FlxSprite().loadGraphic(Paths.image('menus/pause/restartselect'));
    restartselect.x = -940;
    restartselect.y = -340;
    restartselect.alpha = 0.1;
    restartselect.cameras = [pauseCam];
    restartselect.scale.set(0.5, 0.5);
    restartselect.antialiasing = false;
	add(restartselect);

    exitselect = new FlxSprite().loadGraphic(Paths.image('menus/pause/exitselect'));
    exitselect.x = -940;
    exitselect.y = -340;
    exitselect.alpha = 0.1;
    exitselect.cameras = [pauseCam];
    exitselect.scale.set(0.5, 0.5);
    exitselect.antialiasing = false;
	add(exitselect);

    resumeselect.blend = BlendMode.ADD;
    restartselect.blend = BlendMode.ADD;
    exitselect.blend = BlendMode.ADD;

    for (o in [resume ,resumeglow , resumeselect]) FlxTween.tween(o, {x: -640}, 3, {ease: FlxEase.expoOut});
    for (o in [restart , restartglow , restartselect]) FlxTween.tween(o, {x: -640}, 4, {ease: FlxEase.expoOut});
    for (o in  [exit, exitglow, exitselect]) FlxTween.tween(o, {x: -640}, 5, {ease: FlxEase.expoOut});

    cameras = [pauseCam];
}

var canDoShit = true;
var time:Float = 0;

function update(elapsed:Float) {
    if ((curStep >= 865) && (PlayState.SONG.meta.name == 'execretion')){
        render.loadGraphic(Paths.image('menus/pause/renders/execretion'));
    }else if ((curStep <= 865) && (PlayState.SONG.meta.name == 'execretion')){
        render.loadGraphic(Paths.image('menus/pause/renders/phase1'));
    }

    var curText = options[curSelected];
    if (curSelected == 0){
        resumeselect.alpha = FlxMath.lerp(resumeselect.alpha, 1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
        restartselect.alpha = FlxMath.lerp(restartselect.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
        exitselect.alpha = FlxMath.lerp(exitselect.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
    }
    if (curSelected == 1){
        resumeselect.alpha = FlxMath.lerp(resumeselect.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
        restartselect.alpha = FlxMath.lerp(restartselect.alpha, 1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
        exitselect.alpha = FlxMath.lerp(exitselect.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
    }
    if (curSelected == 2){
        resumeselect.alpha = FlxMath.lerp(resumeselect.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
        restartselect.alpha = FlxMath.lerp(restartselect.alpha, 0.1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
        exitselect.alpha = FlxMath.lerp(exitselect.alpha, 1, FlxMath.bound(FlxG.elapsed * 5, 0, 1));
    }

    if (controls.DOWN_P) changeSelection(1, false);
	if (controls.UP_P) changeSelection(-1);

    // 📱 Detección de toque en pantalla
    if (FlxG.mouse.justPressed) {
        var mx = FlxG.mouse.x;
        var my = FlxG.mouse.y;

        if (resume.overlapsPoint(mx, my)) {
            ejecutarOpcion("Resume");
        }
        else if (restart.overlapsPoint(mx, my)) {
            ejecutarOpcion("Restart Song");
        }
        else if (exit.overlapsPoint(mx, my)) {
            ejecutarOpcion("Exit to menu");
        }
    }

	if (controls.ACCEPT) {
        ejecutarOpcion(options[curSelected]);
	}
}

function ejecutarOpcion(option:String) {
    canDoShit = false;
    if (option == "Exit to menu"){
        pauseMusic.fadeOut(0.5, 0);
        FlxG.sound.play(Paths.sound('menu/cancel'), .3);
        FlxG.switchState(new MainMenuState());
    } else if (option == "Restart Song"){
        pauseMusic.fadeOut(0.5, 0);
        FlxG.sound.play(Paths.sound('menu/confirm'), .3);
        FlxG.resetState();
    } else if (option == "Resume"){
        pauseMusic.fadeOut(0.5, 0);
        curSelected = -1;
        FlxG.sound.play(Paths.sound('menu/confirm'), .3);
        for (o in [resume ,restart , exit, restartglow, resumeglow, exitglow, resumeselect, restartselect, exitselect, bar1])
            FlxTween.tween(o, {x: -9999}, 5, {ease: FlxEase.expoOut});
        for (o in [bar2, smallbar2, longbar2, fg, render])
            FlxTween.tween(o, {x: 650}, 2, {ease: FlxEase.expoOut});
        new FlxTimer().start(0.5, function(tmr:FlxTimer)
            {
                for (o in [resume ,restart , exit, restartglow, resumeglow, exitglow, resumeselect, restartselect, exitselect, bar1, bar2, smallbar2, longbar2, fg, render])
                    o.destroy();
                close();
            });
    }
}

function changeSelection(change){
    FlxG.sound.play(Paths.sound('menu/scroll'), .15);

	curSelected += change;

	if (curSelected < 0) curSelected = options.length - 1;
	if (curSelected >= options.length) curSelected = 0;
}