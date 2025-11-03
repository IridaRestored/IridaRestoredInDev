import openfl.display.BlendMode;
import hxvlc.flixel.FlxVideoSprite;

var cutscene:FlxVideoSprite;
var text:FlxSprite;
var run:FlxVideoSprite;
var door:FlxVideoSprite;
var black:FlxSprite;

var ass = new CustomShader('ColorCorrection');
var bloom = new CustomShader('bloom');
var rtxd = new CustomShader('RTXLighting');
var rtxr = new CustomShader('RTXLighting');
var rtxm = new CustomShader('RTXLighting');

import Shadow;

var camOv:FlxCamera;
var camMove = true;

function create() {
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(camOv = new FlxCamera(), false).bgColor = 0;
    FlxG.cameras.add(vidCam = new FlxCamera(), false).bgColor = 0;
    FlxG.cameras.add(camHUD, false);

    light.origin.y = 0;
    glow.origin.y = 0;

    darkness2.cameras = [camOv];
    darkness2.screenCenter();
    darkness2.blend = BlendMode.MULTIPLY;

    glow3.blend = BlendMode.ADD;
    glow.blend = BlendMode.ADD;
    glow2.blend = BlendMode.MULTIPLY;

    chairglow.blend = BlendMode.OVERLAY;
    chairdark.blend = BlendMode.MULTIPLY;
    chairglow.cameras = [camOv];
    chairdark.cameras = [camOv];

    text = new FlxSprite(280, 130).loadGraphic(Paths.image('stages/shucks/ShucksText'));
    text.frames = Paths.getSparrowAtlas('stages/shucks/ShucksText');
    text.animation.addByPrefix('text', "ShucksText ShucksText", 24);
    text.antialiasing = false;
    text.alpha = 0;
    text.cameras = [camOv];
    text.scale.set(1.9,1.9);
    add(text);

    darknessred.blend = BlendMode.MULTIPLY;
    darknessred.screenCenter();
    glow2.screenCenter();
    darknessred.cameras = [camOv];
    glow2.cameras = [camOv];

    bloom.Threshold = 0.05;
    bloom.Intensity = 0.8;
    camGame.addShader(bloom);

    ass.contrast = 30;
    ass.hue = -10;
    camGame.addShader(ass);

    hallway.animation.addByPrefix('beginning', "smallBEGINNING", 24);
    hallway.animation.addByPrefix('run', "smallMIDDLE_DEAD", 24);

    add(black = new FlxSprite().makeSolid(FlxG.width * 3.5, FlxG.height * 3.5, FlxColor.BLACK)).scrollFactor.set();
    black.cameras = [vidCam];
    black.alpha = 1;
    black.screenCenter();

    add(door = new FlxVideoSprite(-335, -200)).load(Assets.getPath(Paths.video('door')));
    door.bitmap.onEndReached.add(function() {
        door.visible = false;
        door.stop();
        door.destroy();
        door = null;
        close();
    });
    door.cameras = [vidCam];
    door.alpha = 0;
    door.scale.set(0.86,0.86);

    add(cutscene = new FlxVideoSprite(0, 0)).load(Assets.getPath(Paths.video('shucks'), [':no-audio']));
    cutscene.bitmap.onEndReached.add(function() {
        cutscene.visible = false;
        cutscene.stop();
        cutscene.destroy();
        cutscene = null;
        close();
    });
    cutscene.cameras = [vidCam];
    cutscene.alpha = 0;

    add(run = new FlxVideoSprite(315, 180)).load(Assets.getPath(Paths.video('run','mov')));
    run.cameras = [vidCam];
    run.alpha = 0;
    run.scale.set(2,2);
}

function postCreate() {
    for (i => r in [rtxd, rtxr, rtxm]) {
        r.overlayColor = getRGB(255, 0, 0, 0.3, 0);
        r.satinColor = getRGB(255, 0, 0, 0.3, 0);
        r.innerShadowColor = getRGB(255, 165, 0, 0.5, 0.6);
        r.innerShadowDistance = 0;
    }
    rtxm.innerShadowAngle = 240 * (Math.PI / 180);
    rtxr.innerShadowAngle = -120 * (Math.PI / 180);
    rtxd.innerShadowAngle = 0 * (Math.PI / 180);
}

function getRGB(r, g, b, sat, blend){
    [FlxMath.remapToRange(r, 0, 255, 0, 1) - sat,
     FlxMath.remapToRange(g, 0, 255, 0, 1) - sat,
     FlxMath.remapToRange(b, 0, 255, 0, 1) - sat,
     blend];
}

var rtxshader = false;

function postUpdate() {
    if (rtxshader == true){
        gf.shader = rtxr;
        dad.shader = rtxd;
        boyfriend.shader = rtxm;
    }else{
        gf.shader = null;
        dad.shader = null;
        boyfriend.shader = null;
    }

    updateCamera();

    if (curStep <= 2306){
        if (curCameraTarget == 0){
            gf.animation.play('idle', false);
        }
        if (curCameraTarget == 1){
            gf.animation.play('idle-alt', false);
        }
    }
    //if (Conductor.curStep > 2814 && Conductor.curStep < 2817) gf.idleSuffix = '-alt';
}

function updateCamera() {
    if (curCameraTarget == 2) {
        if ((curStep >= 2306 && curStep < 2560)) {
            gf.cameraOffset.set(-150, 100);
        }
    }
}

function beatHit(){
    switch(curBeat % 16){
        case 0:
            FlxTween.angle(light, light.angle, -10, 3, {ease: FlxEase.cubeInOut});
            FlxTween.angle(glow, glow.angle, -10, 3, {ease: FlxEase.cubeInOut});
        case 8:
            FlxTween.angle(light, light.angle, 10, 3, {ease: FlxEase.cubeInOut});
            FlxTween.angle(glow, glow.angle, 10, 3, {ease: FlxEase.cubeInOut});
    }
}

function stepHit(curStep) {
    switch (curStep) {
        case 1:
            FlxTween.tween(door, {alpha: 1}, 3, {ease: FlxEase.quartOut});
            door.play();
        case 71:
            FlxTween.tween(black, {alpha: 0}, 3, {ease: FlxEase.quartOut});
            door.destroy();
        case 75:
            FlxTween.tween(boyfriend, {alpha: 1}, 5, {ease: FlxEase.quartOut});
        case 144:
            FlxTween.tween(dad, {alpha: 1}, 3, {ease: FlxEase.quartOut});
        case 416:
            FlxTween.tween(dad, {alpha: 0}, 3, {ease: FlxEase.quartOut});
            FlxTween.tween(boyfriend, {alpha: 0}, 3, {ease: FlxEase.quartOut});
            FlxTween.tween(camHUD, {alpha: 0}, 3, {ease: FlxEase.quartOut});
        case 435:
            FlxTween.tween(dad, {alpha: 1}, 2, {ease: FlxEase.quartOut});
            activateScene();
            defaultCamZoom = 0.4;
        case 436:
            rtxshader = true;
        case 512:
            defaultCamZoom = 0.3;
            dad.shader = rtxd;
            FlxTween.tween(camHUD, {alpha: 1}, 3, {ease: FlxEase.quartOut});
        case 513:
            dad.shader = rtxd;
        case 1280:
            for (o in [glow3]) {
                FlxTween.tween(o, {alpha: 0}, 3, {ease: FlxEase.quartOut});
            }
            FlxTween.num(0, -50, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.brightness = val;});
            FlxTween.num(-10, -10, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.hue = val;});
            FlxTween.num(0, 50, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.saturation = val;});
            FlxTween.num(30, 100, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.contrast = val;});
        case 1536:
            for (o in [glow3]) {
                FlxTween.tween(o, {alpha: 1}, 3, {ease: FlxEase.quartOut});
            }
            FlxTween.num(-50, 0, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.brightness = val;});
            FlxTween.num(-10, -10, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.hue = val;});
            FlxTween.num(50, 0, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.saturation = val;});
            FlxTween.num(100, 30, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.contrast = val;});
        case 2345:
            dad.shader = rtxd;
        case 2560:
            gf.debugMode = true;
            FlxTween.tween(camHUD, {alpha: 0}, 0.2);
        case 2816:
            FlxTween.tween(camHUD, {alpha: 1}, 0.2);
            for (o in [glow3]) {
                FlxTween.tween(o, {alpha: 0}, 3, {ease: FlxEase.quartOut});
            }
            FlxTween.num(0, -50, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.brightness = val;});
            FlxTween.num(-10, -10, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.hue = val;});
            FlxTween.num(0, 50, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.saturation = val;});
            FlxTween.num(30, 100, 3, {ease: FlxEase.quartOut}, (val:Float) -> {ass.contrast = val;});
        case 3136:
            cutscene.play();
        case 3160:
            FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.circOut});
            FlxTween.tween(camHUD, {alpha: 0}, 0.2, {ease: FlxEase.circOut});
        case 3169:
            FlxTween.tween(cutscene, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
        case 3456:
            black.alpha = 0;
            cutscene.alpha = 0;
            cutscene.stop();
            cutscene.destroy();
            ass.brightness = 0;
            ass.hue = -10;
            ass.saturation = 0;
            ass.contrast = 30;
            text.alpha = 1;
            text.animation.play('text');
            FlxTween.tween(text, {alpha: 0}, 4.5, {ease: FlxEase.cubeInOut});
            gf.setPosition(40, -205);
            dad.setPosition(120, 225);
            for (o in [light, hook, chain, bg, glow, glow2,glow3,darknessred,darkness2]) {
                o.alpha = 0;
            }
            for (o in [chairbg, torture, chairdark]) {
                o.alpha = 1;
            }
            camHUD.alpha = 1;
            chairglow.alpha = 0.4;
        case 3457:
            rtxm.innerShadowDistance = 29;
            rtxd.innerShadowDistance = 29;
            rtxr.innerShadowDistance = 29;
            rtxm.innerShadowAngle = 120 * (Math.PI / 180);
            rtxd.innerShadowAngle = 120 * (Math.PI / 180);
            rtxr.innerShadowAngle = 120 * (Math.PI / 180);
        case 3696:
            run.alpha = 1;
            run.play();
        case 3712:
            hallway.alpha = 1;
            gf.alpha = 0;
            torture.alpha = 0;
            rtxshader = false;
            detgleg.alpha = 1;
            marvinleg.alpha = 1;
            detgleg.animation.play('DETG LEGS');
        case 3726:
            run.visible = false;
            run.stop();
            run.destroy();
            run = null;
        case 4480:
            FlxTween.tween(black, {alpha: 1}, 3, {ease: FlxEase.quartOut});
    }
}

function resetCamera() {
    defaultCamZoom = 0.3;
    gf.cameraOffset.set(-300, 350);
}

function onChangeCharacter() {
    s = new Shadow(dad);
    if (dad.curCharacter == 'dbtg') s.offset.set( -2075, 665);
    s.alpha = 0.4;
    s.skew.x = -46;
    s.color = FlxColor.BLACK;

    b = new Shadow(boyfriend);
    b.alpha = 0.4;
    if (boyfriend.curCharacter == 'marvin shucks bloody') b.offset.set (700,100);
    if (boyfriend.curCharacter == 'marvin shucks') b.offset.set (700,0);
    b.skew.x = 30;
    b.color = FlxColor.BLACK;

    if (boyfriend.curCharacter == 'marvin shucks chair') b.alpha = 0;
    if (boyfriend.curCharacter == 'marvin shucks run') b.alpha = 0;
    if (dad.curCharacter == 'chairsaw') s.alpha = 0;
    if (dad.curCharacter == 'dbtg bloody') s.alpha = 0;
    if (dad.curCharacter == 'detgrunbody') s.alpha = 0;
}

function activateScene() {
    health = 1;
    for (o in [light, hook, chain, bg, gf, boyfriend, extralight, glow, glow2,darkness2, lightbase]) {
        o.alpha = 1;
    }
    glow3.alpha = 0.6;
    darknessred.alpha = 0.7;
    FlxG.camera.followLerp = 0.1;
}
