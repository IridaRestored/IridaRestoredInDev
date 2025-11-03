import hxvlc.flixel.FlxVideoSprite;
import hxvlc.flixel.FlxVideo;
import openfl.display.BlendMode;

var shits:CustomShader;
var fuck:CustomShader;
var irida:FlxVideoSprite;
var transition:FlxVideoSprite;
var black = new FlxSprite();
var white = new FlxSprite();
var vortex:FlxVideo;
var video:Bool = false;
var bloom = new CustomShader('bloom');

function create() {
    FlxG.cameras.add(vidCam = new FlxCamera(), false).bgColor = 0;
    boyfriend.x = 950;
    boyfriend.y = -400;
    dad.x = 50;
    dad.y = -550;

    dad.scale.x = 1.4;
    dad.scale.y = 1.4;

    boyfriend.cameraOffset.x = -100;
    boyfriend.cameraOffset.y = 50;
    dad.cameraOffset.x = 250;
    dad.cameraOffset.y = 50;

    glow.blend = BlendMode.ADD;
    
    irida = new FlxVideoSprite(200, 100);
    irida.load(Assets.getPath(Paths.video("irida")));
    irida.scale.set(2, 2);
    irida.cameras = [camHUD];
    irida.alpha = 0;
    add(irida);

    white.alpha = 0;
    white.cameras = [camHUD];
    add(white);

    black.makeGraphic(90000, 90000, 0xFF000000);
    black.x = -1550;
    black.y = -1900;
    black.cameras = [camHUD];
    insert(1, black);

    vortex = new FlxVideoSprite(300, -1600);
    vortex.load(Assets.getPath(Paths.video("vortex")), [':input-repeat=65535']);
    vortex.scale.set(4, 3);
    vortex.alpha = 0;
    insert(1, vortex);
    vortex.scrollFactor.set(0, 1);

    transition = new FlxVideoSprite(-500, -1100);
    transition.load(Assets.getPath(Paths.video("transition")), [':input-repeat=65535']);
    transition.scale.set(2, 2);
    transition.alpha = 0;
    insert(1, transition);

    fuck = new CustomShader("blendModes");
    ass = new CustomShader("blendModes");

    darkness1.shader = fuck;
    fuck.blendMode = 9;

    darkness2.blend = BlendMode.INVERT;
    darkness3.blend = BlendMode.MULTIPLY;
}

function postUpdate(elapsed) {
    if (shits != null && shits.data?.iTime != null) {
        shits.data.iTime.value[0] += elapsed;
    }
    if (fuck != null && fuck.data?.iTime != null) {
        fuck.data.iTime.value[0] += elapsed;
    }
}

function onSubstateOpen() {
    if (irida != null) irida.pause();
    if (transition != null) transition.pause();
    if (vortex != null) vortex.pause();
}

function onSubstateClose() {
    if (video) {
        if (irida != null) irida.play();
        if (transition != null) transition.play();
        if (vortex != null) vortex.play();
    }
}

function onDestroy() {
    if (irida != null) {
        irida.stop();
        irida.dispose();
        remove(irida, true);
        irida = null;
    }

    if (transition != null) {
        transition.stop();
        transition.dispose();
        remove(transition, true);
        transition = null;
    }

    if (vortex != null) {
        vortex.stop();
        vortex.dispose();
        remove(vortex, true);
        vortex = null;
    }
}

function setCameraZoom(amount:Float, time:Float, easee:FlxEase = FlxEase.expoOut) {
    zoomTween = FlxTween.tween(camera, {zoom: amount}, time, {ease: easee});
    defaultCamZoom = amount;
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 5:
            video = true;
            irida.play();
            FlxTween.tween(irida, {alpha: 1}, 10, {ease: FlxEase.expoOut});
            FlxTween.tween(window, {opacity: 1}, 40, {ease: FlxEase.expoOut});

        case 247:
            FlxTween.tween(black, {alpha: 0}, 25, {ease: FlxEase.expoOut});
            defaultCamZoom = 1.2;
            remove(irida, true);
        case 513:
            boyfriend.cameraOffset.x = -300;
            boyfriend.cameraOffset.y = -50;

        case 636:
            dad.cameraOffset.x = 50;
            dad.cameraOffset.y = 50;

        case 784:
            dad.cameraOffset.x = 250;
            dad.cameraOffset.y = 50;

        case 895:
            video = true;
            transition.alpha = 1;
            transition.play();
            remove(rose2, true);
            remove(couch, true);
            remove(bg, true);
            remove(city, true);
            remove(puppetwire, true);
            vortex.alpha = 0;
            camZoomingInterval = 2;

        case 1012:
            FlxTween.tween(dad, {alpha: 0}, 1, {ease: FlxEase.expoOut});
            FlxTween.tween(boyfriend, {alpha: 0}, 1, {ease: FlxEase.expoOut});
            FlxTween.tween(catpiano, {alpha: 0}, 1, {ease: FlxEase.expoOut});

        case 1016:
            setCameraZoom(6, 1, FlxEase.cubeInOut);
            FlxTween.tween(white, {alpha: 1}, 0,5, {ease: FlxEase.expoOut});
            FlxTween.tween(transition, {x: transition.x + 200, y: transition.y + 200}, 0.7, {
                ease: FlxEase.cubeOut,
                onUpdate: function(t) {
                    transition.scale.set(8 + t.progress, 8 + t.progress);
                }
            });

        case 1025:
            if (shits == null) {
                bg2.alpha = 0;
                vortex.alpha = 1;
                vortex.play();
            } else {
                bg2.alpha = 1;
            }

            bloom.Threshold = 0.05;
            bloom.Intensity = 0.8;
            camGame.addShader(bloom);

            remove(transition, true);
            FlxTween.tween(white, {alpha: 0}, 2, {ease: FlxEase.expoOut});

            boyfriend.alpha = 1;
            dad.alpha = 1;
            rose.alpha = 0;
            catpiano2.alpha = 1;
            path.alpha = 1;
            fg.alpha = 1;
            wire.alpha = 1;
            wire2.alpha = 1;
            glow.alpha = 1;
            darkness1.alpha = 1;
            darkness2.alpha = 1;
            darkness3.alpha = 1;
            defaultCamZoom = 0.3;

            health = 1;
            white.alpha = 0;

            boyfriend.x = 1450;
            boyfriend.y = -1100;
            boyfriend.scale.set(0.00001, 0.00001);
            boyfriend.cameraOffset.set(-450, 25);

            dad.x = -200;
            dad.y = -1420;
            dad.scale.set(0.00001, 0.00001);
            dad.cameraOffset.set(-50, 25);

            catpiano2.scale.set(0.00001, 0.00001);
            wire.scale.set(0.00001, 0.00001);

            FlxTween.tween(boyfriend.scale, {x: 1.6, y: 1.6}, 0.5, {ease: FlxEase.expoOut});
            FlxTween.tween(dad.scale, {x: 1.8, y: 1.8}, 0.5, {ease: FlxEase.expoOut});
            FlxTween.tween(catpiano2.scale, {x: 1.6, y: 1.6}, 0.5, {ease: FlxEase.expoOut});
            FlxTween.tween(wire.scale, {x: 1.6, y: 1.6}, 0.5, {ease: FlxEase.expoOut});

            


case 1810:
    FlxTween.tween(dad, {alpha: 0}, 70, {ease: FlxEase.expoOut});
    FlxTween.tween(boyfriend, {alpha: 0}, 70, {ease: FlxEase.expoOut});
    FlxTween.tween(catpiano2, {alpha: 0}, 70, {ease: FlxEase.expoOut});
    FlxTween.tween(wire, {alpha: 0}, 70, {ease: FlxEase.expoOut});

    FlxTween.tween(dad.scale, {x: 0.00001, y: 0.00001}, 45, {ease: FlxEase.expoOut});
    FlxTween.tween(boyfriend.scale, {x: 0.00001, y: 0.00001}, 45, {ease: FlxEase.expoOut});
    FlxTween.tween(catpiano2.scale, {x: 0.00001, y: 0.00001}, 45, {ease: FlxEase.expoOut});
    FlxTween.tween(wire.scale, {x: 0.00001, y: 0.00001}, 45, {ease: FlxEase.expoOut});

    FlxTween.tween(FlxG.camera, {zoom: 8}, 8, {ease: FlxEase.cubeInOut});
    FlxTween.tween(black, {alpha: 1}, 1.5, {ease: FlxEase.expoOut});

    video = false;

        case 1968:
            defaultCamZoom = 0.55;
	    rose.alpha = 0;
            catpiano2.alpha = 0;
            path.alpha = 0;
            fg.alpha = 0;
            wire.alpha = 0;
            wire2.alpha = 0;
            glow.alpha = 0;
            darkness1.alpha = 0;
            darkness2.alpha = 0;
            darkness3.alpha = 0;           
	    bg2.alpha = 0;
	    camGame.removeShader(bloom);
            room.alpha = 1;
            tv.alpha = 1;
            health = 1;

            boyfriend.x = 250;
            boyfriend.y = -1550;
            dad.x = 1600;
            dad.y = -1450;
            boyfriend.scale.x = 0.9;
            boyfriend.scale.y = 0.9;
            dad.scale.x = 0.9;
            dad.scale.y = 0.9;
            boyfriend.cameraOffset.x = 400;
            boyfriend.cameraOffset.y = -50;
            dad.cameraOffset.x = -350;
            dad.cameraOffset.y = -150;
            boyfriend.alpha = 1;
            dad.alpha = 1;

        case 1990:
            FlxTween.tween(black, {alpha: 0}, 30, {ease: FlxEase.expoOut});
	case 2775:
	    catpiano2.alpha = 1;
	case 2781:
            bloom.Threshold = 0.05;
            bloom.Intensity = 0.8;
            camGame.addShader(bloom);

            remove(transition, true);
            FlxTween.tween(white, {alpha: 0}, 2, {ease: FlxEase.expoOut});

            boyfriend.alpha = 1;
            dad.alpha = 1;
	    rose.alpha = 1;
            path.alpha = 1;
            fg.alpha = 1;
            wire.alpha = 1;
            wire2.alpha = 1;
            glow.alpha = 1;
            darkness1.alpha = 1;
            darkness2.alpha = 1;
            darkness3.alpha = 1;
            defaultCamZoom = 0.3;

            health = 1;
            white.alpha = 0;

            boyfriend.x = 1450;
            boyfriend.y = -1100;
            boyfriend.scale.set(0.00001, 0.00001);
            boyfriend.cameraOffset.set(-450, 25);

            dad.x = -200;
            dad.y = -1420;
            dad.scale.set(0.00001, 0.00001);
            dad.cameraOffset.set(-50, 25);

            catpiano2.scale.set(0.00001, 0.00001);
            wire.scale.set(0.00001, 0.00001);

            FlxTween.tween(boyfriend.scale, {x: 1.6, y: 1.6}, 0.5, {ease: FlxEase.expoOut});
            FlxTween.tween(dad.scale, {x: 1.8, y: 1.8}, 0.5, {ease: FlxEase.expoOut});
            FlxTween.tween(catpiano2.scale, {x: 1.6, y: 1.6}, 0.5, {ease: FlxEase.expoOut});
            FlxTween.tween(wire.scale, {x: 1.6, y: 1.6}, 0.5, {ease: FlxEase.expoOut});
	    room.alpha = 0;
            tv.alpha = 0;
	    

	
    }
}
