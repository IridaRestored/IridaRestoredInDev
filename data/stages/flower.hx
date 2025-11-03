
import openfl.display.BlendMode;
import Shadow;

var bloom = new CustomShader('bloom');
var blur = new CustomShader('blur');
var rain = new CustomShader('rain');
function create() {
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(camOv = new FlxCamera(), false).bgColor = 0;
    FlxG.cameras.add(camHUD, false);
    defaultCamZoom = 0.46;
    
    boyfriend.x = 1300;
    boyfriend.y = 150;
    dad.x = -400;
    dad.y = 150;

    gf.alpha = 0;
    gf.cameraOffset.x = 300;
    gf.cameraOffset.y = -200;

    dad.scale.x = 1.4;
    dad.scale.y = 1.4;
    boyfriend.scale.x = 1.6;
    boyfriend.scale.y = 1.6;

    boyfriend.cameraOffset.x = -150;
    boyfriend.cameraOffset.y = -50;
    dad.cameraOffset.x = 50;
    dad.cameraOffset.y = 0;


    blur.directions = 10;
    blur.quality = 2;
    blur.size = 1.5;
    camGame.addShader(blur);

    s = new Shadow(dad);
    s.alpha = 0.3;
    s.offset.y = 370;
    s.offset.x = -810;
    s.skew.x = -30;
    s.color = FlxColor.BLACK;

    b = new Shadow(boyfriend);
    b.alpha = 0.3;
    b.offset.y = 600;
    b.offset.x = 810;
    b.skew.x = 30;
    b.color = FlxColor.BLACK;

    blue.blend = BlendMode.MULTIPLY;
    blue.cameras = [camOv];
    blue.screenCenter();
    
	
	camGame.addShader(rain);
    rain.iIntensity = 0.01;
    rain.iTimescale = 0.7;
}

var localTime:Float = 0;
function update(elapsed:Float) {
localTime += elapsed;
rain.iTime = localTime;

}

function setCameraBop(interval:Float, strength:Float, followLerp:Float = 0.2) {
    camZoomingInterval = interval;
    camZoomingStrength = strength;
    FlxG.camera.followLerp = followLerp;
}

function setCameraZoom(amount:Float, time:Float, easee:FlxEase = FlxEase.expoOut) {
    zoomTween = FlxTween.tween(camera, {zoom: amount}, time, {ease: easee});
    defaultCamZoom = amount;
}

function stepHit(curStep) {
    switch (curStep) {
        case 132: FlxTween.tween(boyfriend, {alpha: 1}, 5, {ease: FlxEase.circOut});
        case 356: FlxTween.tween(boyfriend, {alpha: 0}, 5, {ease: FlxEase.circOut});   
        case 388: FlxTween.tween(dad, {alpha: 1}, 5, {ease: FlxEase.circOut});
        case 624: FlxTween.tween(dad, {alpha: 0}, 5, {ease: FlxEase.circOut});
        case 644: FlxTween.tween(boyfriend, {alpha: 1}, 5, {ease: FlxEase.circOut});
        case 708: FlxTween.tween(dad, {alpha: 1}, 5, {ease: FlxEase.circOut});
        case 896: 
            setCameraZoom(0.3, 5, FlxEase.quartOut); 
            for (o in [moon, bg, outside, fg1, fg2, blue]) {
                FlxTween.tween(o, {alpha: 1}, 10, {ease: FlxEase.circOut});
            }
        case 1180: setCameraZoom(0.46, 0.5, FlxEase.quartOut); 
        case 1188: setCameraZoom(0.6, 0.5, FlxEase.quartOut); 
        case 1216: setCameraZoom(0.3, 1, FlxEase.quartOut); 
        case 1245: setCameraZoom(0.46, 0.5, FlxEase.quartOut); 
        case 1252: setCameraZoom(0.6, 0.5, FlxEase.quartOut); 
        case 1276: setCameraZoom(0.3, 5, FlxEase.cubeInOut); FlxG.camera.followLerp = 0; FlxTween.tween(camGame.scroll, {x: 0, y: -300}, 5, {ease: FlxEase.cubeInOut});
        case 1408:
            setCameraZoom(0.46, 5, FlxEase.quartOut); 
            for (o in [moon, bg, outside, fg1, fg2, boyfriend, dad, blue]) {
                FlxTween.tween(o, {alpha: 0}, 3, {ease: FlxEase.circOut});
            }
        case 1472:
            setCameraBop(4,2,0.1);
            for (o in [moon, bg, outside, fg1, fg2, boyfriend, dad, blue]) {
                o.alpha = 1;
            }
        case 1732: 
             FlxTween.num(0.01,  0.09, 3, {ease: FlxEase.quartOut}, (val:Float) -> {rain.iIntensity = 0.09;});
            FlxTween.num(0.7,  0.5, 3, {ease: FlxEase.quartOut}, (val:Float) -> {rain.iTimescale = 0.5;});
            setCameraBop(2 , 2 , 0.1); 
            setCameraZoom(0.3, 0.5, FlxEase.circOut);

        case 1984: setCameraZoom(0.46, 0.5, FlxEase.circOut);
        case 2241: setCameraBop(4 , 2 , 0.05); 
        case 2496: setCameraBop(2 , 2 , 0.1); 
        case 2748:
            setCameraBop(0 , 0 , 0.1); 
            for (o in [moon, bg, outside, fg1, fg2, boyfriend, dad]) {
                FlxTween.tween(o, {alpha: 0}, 5, {ease: FlxEase.circOut});
            }
        case 2888: FlxTween.tween(dad, {alpha: 1}, 3, {ease: FlxEase.circOut}); 
        case 3636: FlxTween.tween(dad, {alpha: 0}, 5, {ease: FlxEase.circOut});
    }
}