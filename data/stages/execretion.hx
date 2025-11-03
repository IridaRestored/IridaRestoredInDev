import openfl.display.BlendMode;
import hxvlc.flixel.FlxVideoSprite;
import flixel.addons.display.FlxBackdrop;
import Shadow;

var shits = new CustomShader('bloom');
var rtxr = new CustomShader('RTXLighting');
var rtxp = new CustomShader('RTXLighting');
var white:FlxSprite;
var intro:FlxVideoSprite;
var poopy:FlxVideoSprite;
var twist, snap, healthchange, video = false;
var pictures:FlxBackdrop;

function create() {
    nlight.blend = BlendMode.ADD;
    light.blend = BlendMode.ADD;
    blend.blend = BlendMode.ADD;

    shits.Threshold = 0.05;
    shits.Intensity = 1;
    camGame.addShader(shits);

    FlxG.camera.followLerp = 0.06;

    // Intro Video
    add(intro = new FlxVideoSprite(0,0));
    intro.load(Assets.getPath(Paths.video('poop')));
    intro.play();
    intro.alpha = 0;
    intro.scale.set(1,1);
    intro.cameras = [camHUD];

    // Poopy Video
    insert(1, poopy = new FlxVideoSprite(0,0));
    poopy.load(Assets.getPath(Paths.video('poopybutt')));
    poopy.play();
    poopy.alpha = 0;
    poopy.scale.set(1,1);
    poopy.cameras = [camHUD];

    // Configuración RTX
    for (i => r in [rtxr, rtxp]) {
        r.overlayColor = [0.5, 0.2, 0, 0.2];
        r.satinColor = [0, 0, 0, 0];
        r.innerShadowColor = [0.8375, 0.5125, 0, 0.6];
        r.innerShadowDistance = 29;
    }

    rtxr.innerShadowAngle = 240 * (Math.PI / 180);
    rtxp.innerShadowAngle = 0 * (Math.PI / 180);

    boyfriend.shader = rtxr;
    dad.shader = rtxp;

    // Pictures Backdrop
    pictures = new FlxBackdrop(Paths.image('stages/execretion/moses/Pictures'));
    pictures.frames = Paths.getSparrowAtlas('stages/execretion/moses/Pictures');
    pictures.x = -1400; 
    pictures.y = -1400;
    pictures.alpha = 0;
    pictures.animation.addByPrefix('idle', "The_Pictures", 12);
    pictures.antialiasing = false;
    pictures.scale.set(1.6,1.6);
    pictures.animation.play('idle', true);
    pictures.velocity.y = -400;
    add(pictures);
}

function postUpdate(_) {
    if (curStep >= 3536 && curStep < 3943) {
        if (curCameraTarget == 0) {
            defaultCamZoom = 0.7;
        } else {
            defaultCamZoom = 0.5;
        }
    }
}

function onSubstateOpen() {
    intro.pause();
    poopy.pause();
}

function onSubstateClose() {
    if (video) {
        intro.play();
        poopy.play();
    }
}

function stepHit(s) {
    if (s == 0) {
        intro.play();
        intro.alpha = 1;
    }

    if (s == 128) intro.destroy();

    if (s == 256) {
        FlxTween.tween(nsun, {y: -550}, 40, {ease: FlxEase.expoOut});
        FlxTween.tween(nlight, {y: -550}, 40, {ease: FlxEase.expoOut});
    }

    if (s == 784) removenormalbg();

    if (s == 794) {
        for (o in [nbg, nblock, nsun, nlight, sea, npipe1, npipe3, npipe2, nblock4, nblock3, nblock2, nblock1, nfloor, ncloud1, ncloud2, ncloud3]) {
            o.destroy();
            remove(o, true);
        }
    }

    if (s == 864) FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});

    if (s == 880) {
        for (o in [debris, debris2, debris3, pipe, plant]) 
            FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
    }

    if (s == 896) {
        for (o in [block1, block2, fg]) 
            FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
    }

    if (s == 912) {
        for (o in [bg, light, cliff, waterfall2]) 
            FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
        rtxp.satinColor = [0.5, 0.2, 0, 0.3];
        rtxr.satinColor = [0.5, 0.2, 0, 0.3];
    }

    if (s == 2320) {
        poopy.play();
        poopy.alpha = 1;
    }

    if (s == 2400) poopy.destroy();

    if (s == 2401) {
        dad.shader = rtxp;
        dad.setPosition(-650, -880);
        dad.cameraOffset.set(50, 50);
        dad.scale.set(1.2, 1.2);
    }

    if (s == 2672) activatewhite();

    if (s == 2682) {
        for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) remove(o, true);
    }

    if (s == 3464) {
        for (o in [dad, white, boyfriend])
            FlxTween.tween(o, {alpha: 0}, 5, {ease: FlxEase.expoOut});
    }

    if (s == 3529) boyfriend.alpha = dad.alpha = 0;

    if (s == 3534) {
        white.destroy();
        remove(white, true);
        rtxr.innerShadowAngle = 0;
        rtxp.innerShadowAngle = 0;
        rtxp.satinColor = [0.5, 0.2, 0, 0.6];
        rtxr.satinColor = [0.5, 0.2, 0, 0.6];
        boyfriend.shader = rtxr;
        dad.shader = rtxp;
        FlxTween.tween(boyfriend, {alpha: 1}, 10, {ease: FlxEase.expoOut});
    }

    if (s == 3662) FlxTween.tween(dad, {alpha: 1}, 10, {ease: FlxEase.expoOut});

    if (s == 3784) moses();

    if (s == 3946) {
        for (o in [black, clouds, blend, sun, land, wave, rocks]) {
            o.destroy();
            remove(o, true);
        }
        pictures.alpha = 1;
    }

    if (s == 4200) {
        for (o in [dad, boyfriend, pictures])
            FlxTween.tween(o, {alpha: 0}, 2, {ease: FlxEase.expoOut});
    }

    if (s == 4232) {
        castle();
        pictures.destroy();
        remove(pictures, true);
    }

    if (s == 4233) {
        rtxr.innerShadowAngle = 240 * (Math.PI / 180);
        rtxp.innerShadowAngle = 0;
        rtxp.satinColor = [0.5, 0.2, 0, 0.3];
        rtxr.satinColor = [0.5, 0.2, 0, 0.3];
        boyfriend.shader = rtxr;
        dad.shader = rtxp;
        boyfriend.alpha = dad.alpha = 1;
        boyfriend.color = dad.color = 0xFFFFFF;

        dad.setPosition(-650, -900);
        dad.cameraOffset.set(50, 50);
        dad.scale.set(1.2, 1.2); 
        boyfriend.setPosition(650, -520);
        boyfriend.cameraOffset.set(0, -200);
    }
}

function changeHealth() {
    healthchange = true;
    new FlxTimer().start(2, () -> healthchange = false);
}

function removenormalbg() {
    for (o in [nbg, nblock, nsun, nlight, sea, npipe1, npipe3, npipe2, nblock4, nblock3, nblock2, nblock1, nfloor, ncloud1, ncloud2, ncloud3]) {
        FlxTween.tween(o, {alpha: 0}, 0.5, {ease: FlxEase.expoOut});
        o.destroy();
        remove(o, true);
    }
}

function activatewhite() {
    for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) o.alpha = 0;
    
    insert(1, white = new FlxSprite().makeSolid(FlxG.width * 3.5, FlxG.height * 3.5, FlxColor.WHITE));
    white.scrollFactor.set();
    white.screenCenter();

    boyfriend.color = 0xFF000000;
    dad.color = 0xFF000000;
}

function moses() {
    for (i in [black, clouds, blend, sun, land, wave, rocks]) i.alpha = 1;
    fg.alpha = 0;
}

function castle() {
    for (i in [thesky, back, wall, fort, fort_light, flag, flag2, pillars, statue, window_pillars, window_light, sign, base, fence]) i.alpha = 1;
    fg.alpha = 0;
    setCameraZoom(0.4, 5);
}
