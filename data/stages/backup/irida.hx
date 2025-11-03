import hxvlc.flixel.FlxVideoSprite;
import hxvlc.flixel.FlxVideo;
import openfl.display.BlendMode;

var shits:CustomShader;
var fuck:CustomShader;
var irida:FlxVideoSprite;
var transition:FlxVideoSprite;
var black = new FlxSprite();
var vortex:FlxVideo;
var video:Bool = false;
var bloom = new CustomShader('bloom');

function create() {
    boyfriend.x = 950;
    boyfriend.y =  -400;
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
    irida.scale.set(2,2);
    irida.cameras = [camHUD];
    irida.alpha = 0;
    add(irida);
    
    black.makeGraphic(90000, 90000,  0xFF000000);
    black.x = -1550;
    black.y = -1900;
    black.cameras = [camHUD];
    insert(1,black);

    vortex = new FlxVideoSprite(-450, -1900);
    vortex.load(Assets.getPath(Paths.video("vortex new")), [':input-repeat=65535']);
    vortex.scale.set(2,2);
    vortex.alpha = 0;
    insert(1,vortex);
    vortex.scrollFactor.set(0,1);

    transition = new FlxVideoSprite(-500, -1100);
    transition.load(Assets.getPath(Paths.video("transition")), [':input-repeat=65535']);
    transition.scale.set(2,2);
    transition.alpha = 0;
    insert(1,transition);

    shits = new CustomShader("irida");
    shits.data.iTime.value = [0];

    fuck = new CustomShader("blendModes");
    ass = new CustomShader("blendModes");

    bg2.shader = shits;

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
    irida.pause();
    transition.pause();
    vortex.pause();
}

function onSubstateClose() {
    if (video == false){
    }else{
        irida.play();
        transition.play();
        vortex.play();
    }
}

function setCameraZoom(amount:Float, time:Float, easee:FlxEase = FlxEase.expoOut) {
    zoomTween = FlxTween.tween(camera, {zoom: amount}, time, {ease: easee});
    defaultCamZoom = amount;
}

// 🟦 NUEVA FUNCIÓN REUTILIZABLE
function playVortexScene(useAlternatePositions:Bool = false) {
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
    boyfriend.alpha = 1;
    dad.alpha = 1;
    rose.alpha = 1;
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

    if (useAlternatePositions) {
        boyfriend.x = 1600;
        boyfriend.y = -1300;
        dad.x = -250;
        dad.y = -1250;
        boyfriend.cameraOffset.set(-300, 20);
        dad.cameraOffset.set(-20, 20);
    } else {
        boyfriend.x = 1450;
        boyfriend.y = -1100;
        dad.x = -150;
        dad.y = -1350;
        boyfriend.cameraOffset.set(-450, 25);
        dad.cameraOffset.set(-50, 25);
    }

    boyfriend.scale.set(1.6, 1.6);
    dad.scale.set(1.6, 1.6);

    camZoomingInterval = 2;
    camZoomingStrength = 1;
}

function stepHit(curStep:Int){
    switch(curStep){
        case 5:
            video = true;
            irida.play();
            FlxTween.tween(irida , {alpha: 1}, 10, {ease: FlxEase.expoOut});
            FlxTween.tween(window , {opacity: 1}, 40, {ease: FlxEase.expoOut});
        case 247: 
            FlxTween.tween(black , {alpha: 0}, 60, {ease: FlxEase.expoOut});
            defaultCamZoom = 1.2;
            remove(irida, true);
        case 507: 
            setCameraZoom(0.6, 1, FlxEase.cubeInOut); 
        case 513:
            boyfriend.cameraOffset.x = -300;
            boyfriend.cameraOffset.y = -50;
        case 636: 
            setCameraZoom(0.9, 1, FlxEase.quartOut); 
            dad.cameraOffset.x = 50;
            dad.cameraOffset.y = 50;
        case 784: 
            setCameraZoom(0.6, 1, FlxEase.cubeInOut); 
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
            setCameraZoom(1.2, 1, FlxEase.cubeInOut);  
            FlxTween.tween(dad , {alpha: 0}, 2, {ease: FlxEase.expoOut});
            FlxTween.tween(boyfriend , {alpha: 0}, 2, {ease: FlxEase.expoOut});
            FlxTween.tween(catpiano , {alpha: 0}, 2, {ease: FlxEase.expoOut});
        case 1025:
            playVortexScene();
        case 1276:
            setCameraZoom(0.7, 1, FlxEase.quartOut); 
        case 1296:
            setCameraZoom(0.3, 0.5, FlxEase.cubeInOut);      
        case 1552:
            setCameraZoom(0.5, 2, FlxEase.expoOut); 
        case 1808:
            setCameraZoom(0.3, 5, FlxEase.expoOut);
            boyfriend.cameraOffset.x = -850;
        case 1810:
            video = false;
            FlxTween.tween(black , {alpha: 1}, 5, {ease: FlxEase.expoOut});
            camZoomingInterval = 4;
            camZoomingStrength = 1;
        case 1968:
            defaultCamZoom = 0.55;
            remove(rose, true);
            remove(bg2, true);
            remove(path, true);
            remove(fg, true);
            remove(wire, true);
            remove(glow, true);
            remove(wire2, true);
            remove(catpiano2, true);
            remove(darkness1, true);
            remove(darkness2, true);
            remove(darkness3, true);
            camGame.removeShader(bloom);
            room.alpha = 1;
            tv.alpha = 1;
            health = 1;
            boyfriend.x = 250;
            boyfriend.y =  -1550;
            dad.x = 1600;
            dad.y = -1450;
            boyfriend.scale.set(0.9, 0.9);
            dad.scale.set(0.9, 0.9);
            boyfriend.cameraOffset.set(400, -50);
            dad.cameraOffset.set(-350, -150);
        case 1990:
            FlxTween.tween(black , {alpha: 0}, 30, {ease: FlxEase.expoOut});
        case 2419:
            setCameraZoom(0.7, 1, FlxEase.cubeInOut); 
            FlxG.camera.followLerp = 0.02;
        case 2623:
            FlxG.camera.followLerp = 0.04;
            setCameraZoom(0.55, 2, FlxEase.expoOut);
        case 2780:
    // Cargar el stage manualmente
    bg2 = new FlxSprite(100, -2000).loadGraphic(Paths.image("stages/jimmy/real/bg"));
    bg2.alpha = 0;
    bg2.scale.set(3.2, 3.2);
    bg2.scrollFactor.set(0, 1);
    add(bg2);

    path = new FlxSprite(-850, -1900).loadGraphic(Paths.image("stages/jimmy/real/path"));
    path.alpha = 0;
    path.scale.set(1.6, 1.6);
    path.scrollFactor.set(0, 1);
    add(path);

    glow = new FlxSprite(-850, -1900).loadGraphic(Paths.image("stages/jimmy/real/glow"));
    glow.alpha = 0;
    glow.scale.set(1.6, 1.6);
    glow.scrollFactor.set(0, 1);
    add(glow);

    rose = new FlxSprite(-850, -1900).loadGraphic(Paths.image("stages/jimmy/real/dead rose"));
    rose.alpha = 0;
    rose.scale.set(1.6, 1.6);
    rose.scrollFactor.set(0.2, 1);
    add(rose);

    wire = new FlxSprite(-850, -1900).loadGraphic(Paths.image("stages/jimmy/real/wires"));
    wire.alpha = 0;
    wire.scale.set(1.6, 1.6);
    wire.scrollFactor.set(0.6, 1);
    add(wire);

    fg = new FlxSprite(-850, -1900).loadGraphic(Paths.image("stages/jimmy/real/fg"));
    fg.alpha = 0;
    fg.scale.set(1.6, 1.6);
    fg.scrollFactor.set(0.8, 1);
    add(fg);

    catpiano2 = new FlxSprite(-850, -1900).loadGraphic(Paths.image("stages/jimmy/real/catpiano"));
    catpiano2.alpha = 0;
    catpiano2.scale.set(1.6, 1.6);
    add(catpiano2);

    // Después de cargar todo, ejecutar la escena vortex
    playVortexScene(true);
    }
}
