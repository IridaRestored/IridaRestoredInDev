import openfl.display.BlendMode;
import hxvlc.flixel.FlxVideoSprite;
import flixel.addons.display.FlxBackdrop;
var darkbgActive:Bool = false;
var shits = new CustomShader('bloom');
var rtxr = new CustomShader('RTXLighting');
var rtxp = new CustomShader('RTXLighting');
var white;
var black;
var intro, poopy;
var twist, snap, healthchange, video = false;
var darkbg:FlxSprite;
var transition:FlxSprite;
import Shadow;
function create() {
    nlight.blend = BlendMode.ADD;
    light.blend = BlendMode.ADD;
    blend.blend = BlendMode.ADD;

    shits.Threshold = 0.05;
    shits.Intensity = 1;
    camGame.addShader(shits);

    FlxG.camera.followLerp = 0.06;

    add(intro = new FlxVideoSprite(0,0)).load(Assets.getPath(Paths.video('poop')));
    intro.play();
    intro.alpha = 0;
    intro.scale.set(1,1);
    intro.cameras = [camHUD];

    insert(1,poopy = new FlxVideoSprite(0,0)).load(Assets.getPath(Paths.video('poopybutt')));
    poopy.play();
    poopy.alpha = 0;
    poopy.scale.set(1,1);
    poopy.cameras = [camHUD];

    for (i => r in [rtxr, rtxp]) {
        r.overlayColor = [0.5, 0.2, 0, 0.2];
        r.satinColor = [0, 0, 0, 0];
        r.innerShadowColor = [ 0.8375, 0.5125, 0, 0.6];
        r.innerShadowDistance = 29;
    }

    rtxr.innerShadowAngle = 240 * (Math.PI / 180);
    rtxp.innerShadowAngle = 0 * (Math.PI / 180);

    boyfriend.shader = rtxr;
    dad.shader = rtxp;

    darkbg = new FlxSprite();
    darkbg.loadGraphic(Paths.image("stages/execretion/poop/blurthingnew"));
    darkbg.x = 0;
    darkbg.y = 1200;
    darkbg.scale.set(3, 3);
    darkbg.alpha = 0;
    darkbg.scrollFactor.set(0, 0);
    add(darkbg);
    if (dad != null)
{
    remove(darkbg, true);
    insert(members.indexOf(dad), darkbg);
}

    transition = new FlxSprite(0, 0);
    transition.frames = Paths.getSparrowAtlas("stages/execretion/poop/pooptransition");
    transition.animation.addByPrefix("transition", "transition", 30, true);
    transition.scale.set(2.5, 2.5);
    transition.alpha = 0;
    transition.scrollFactor.set(0, 0);
    add(transition);

    pictures = new FlxBackdrop(Paths.image('stages/execretion/moses/Pictures'));
    pictures.frames = Paths.getSparrowAtlas('stages/execretion/moses/Pictures');
    pictures.x = -1600; 
     pictures.y = 2500;
     pictures.scrollFactor.set(1, 1);
     pictures.alpha = 0;
      pictures.animation.addByPrefix('idle', "The_Pictures", 12);
     pictures.antialiasing = false;
     pictures.scale.set(1.6,1.6);
     pictures.animation.play('idle', true);
    pictures.velocity.y = -230;
     add(pictures);
}

function postUpdate(_) {
    if ((curStep >= 3536 && curStep < 3943)) {
        if (curCameraTarget == 0)  {
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
    if (video == false){
    }else{
        intro.play();
        poopy.play();
    }
}

function stepHit(s) {
    switch (s) {
        case 0:
            intro.play();
            intro.alpha = 1;
            break;

        case 128:
            intro.destroy();
            break;

        case 256:
            FlxTween.tween(nsun, {y: -550}, 40, {ease: FlxEase.expoOut});
            FlxTween.tween(nlight, {y: -550}, 40, {ease: FlxEase.expoOut});
            break;

        case 784:
            removenormalbg();
                        FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quadOut});
            break;

        case 794:
            for (o in [nbg, nblock, nsun, nlight, sea, npipe1, npipe3, npipe2, nblock4, nblock3, nblock2, nblock1, nfloor, ncloud1, ncloud2, ncloud3]) {
                o.destroy();
                remove(o, true);
            }
            break;

        case 848:
             FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.quadOut});
             break;

        case 864:
            FlxTween.tween(floor, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
            break;

        case 880:
            for (o in [debris, debris2, debris3, pipe, plant]) FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
            break;

        case 896:
            for (o in [block1, block2, fg]) FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
            break;

        case 912:
            for (o in [bg, light, cliff, waterfall2]) FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
            rtxp.satinColor = [0.5, 0.2, 0, 0.3];
            rtxr.satinColor = [0.5, 0.2, 0, 0.3];
            break;

        case 1780:
                transition.animation.play("transition");
                transition.alpha = 1;
                break;   

case 1808:
    changeCharacter(0, 'povpoopdarh', 0);
    iconP1.setIcon('shadow rose');
iconP2.setIcon('shadow poop');
healthBar.createColoredEmptyBar(0xFFB00032);
healthBar.createColoredFilledBar(0xFFFB0148); 
healthBar.updateBar();
    defaultCamZoom = 0.5;
    boyfriend.alpha = 0;
    bg.alpha = 0;
    cliff.alpha = 0;
    waterfall2.alpha = 0;
    light.alpha = 0;
    floor.alpha = 0;
    debris.alpha = 0;
    debris2.alpha = 0;
    debris3.alpha = 0;
    pipe.alpha = 0;
    plant.alpha = 0;
    block1.alpha = 0;
    block2.alpha = 0;
    fg.alpha = 0;
    darkbg.alpha = 0.6;
    darkbgActive = true;
    boyfriend.cameraOffset.set(-900, -150);

    for (i in 0...strumLines.members[1].members.length)
    {
        var note = strumLines.members[1].members[i];
        FlxTween.tween(note, {x: note.x + 80}, 0.25, {ease: FlxEase.quadOut, onComplete: function(_) {
            FlxTween.tween(note, {x: (FlxG.width / 2) - 220 + (i * 110)}, 0.4, {ease: FlxEase.quadInOut});
        }});
    }

    for (i in 0...strumLines.members[0].members.length)
    {
        var note = strumLines.members[0].members[i];
        FlxTween.tween(note, {x: -400}, 0.5, {ease: FlxEase.quadInOut});
    }
    break;

    case 1810:
            remove(transition, true);


case 2320:
    
    if(poopy != null) {
        poopy.pause();
        poopy.frame = 0;
        poopy.alpha = 1;
        poopy.play();
        poopy.x = 0;
        poopy.y = 0;
        poopy.scale.set(1,1);
        poopy.cameras = [camHUD];
    }
    break;


        case 2400:
                iconP1.setIcon('rose');
healthBar.createColoredEmptyBar(0xFFB06E38);
healthBar.createColoredFilledBar(0xFF00E8FF); 
healthBar.updateBar();
            defaultCamZoom = 0.4;
            darkbg.destroy();
            poopy.destroy();
            break;

case 2401:
    dad.shader = rtxp;
    dad.setPosition(-650, -880);
    dad.cameraOffset.set(50, 50);
    dad.scale.set(1.2, 1.2);
    boyfriend.cameraOffset.set(-200, -50);
    boyfriend.alpha = 1;

    for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) {
        if (o != null) o.alpha = 1;
    }

    for (i in 0...strumLines.members[1].members.length) {
        var note = strumLines.members[1].members[i];
        FlxTween.tween(note, {angle: 360, x: 732 + (i * 112)}, 0.6, {
            ease: FlxEase.expoInOut,
            onComplete: function(_) {
                note.angle = 0;
            }
        });
    }

    for (i in 0...strumLines.members[0].members.length) {
        var note = strumLines.members[0].members[i];
        FlxTween.tween(note, {x: 92 + (i * 112)}, 0.6, {ease: FlxEase.expoInOut});
    }
    break;


        case 2672:
            activatewhite();
            break;

        case 2682:
            for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) {
                if (o != null) o.alpha = 0;
            }
            break;

        case 2706:
            desactivatewhite();
            for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) {
                if (o != null) FlxTween.tween(o, {alpha: 1}, 0.5, {ease: FlxEase.expoOut});
            }
            FlxG.camera.flash(FlxColor.BLACK, 1);
            break;

        case 2850:
            activatewhite();
            for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) {
                if (o != null) {
                    o.destroy();
                    remove(o, true);
                }
            }
            break;

        case 3634:
            FlxTween.tween(dad, {alpha: 0}, 5, {ease: FlxEase.expoOut});
            FlxTween.tween(white, {alpha: 0}, 5, {ease: FlxEase.expoOut});
            FlxTween.tween(boyfriend, {alpha: 0}, 5, {ease: FlxEase.expoOut});
            break;

        case 3660:
            boyfriend.alpha = dad.alpha = 0;
            break;

        case 3642:
            desactivatewhite();
                            FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quadOut});
            break;

        case 3662:
            FlxTween.tween(dad, {alpha: 0}, 10, {ease: FlxEase.expoOut});
            break;

        case 3706:
            dad.alpha = 1;
                FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            for (i in 0...4) {
                var dadStrum = strumLines.members[0].members[i];
                var bfStrum = strumLines.members[1].members[i];
                var tempX = dadStrum.x;
                dadStrum.x = bfStrum.x;
                bfStrum.x = tempX;
            }
            break;


case 3963:
    moses();
    changeCharacter(0, 'poopypoop', 0);
    changeCharacter(1, 'rose_exereal', 0);
        FlxTween.tween(FlxG.camera, {zoom: 0.5}, 4, {ease: FlxEase.expoOut});
    defaultCamZoom = 0.5;
    break;


case 4124:
            for(o in [black, fg, clouds, blend, sun, land, wave, rocks]) {
                if(o != null) {
                    o.destroy();
                    remove(o, true);
                }
            }
            for(i in 0...4) {
                var dadStrum = strumLines.members[0].members[i];
                if(dadStrum != null) {
                    dadStrum.visible = false;
                    dadStrum.x = 10000;
                }
            }
            var midX = FlxG.width / 2;
            var spacing = 120;
            for(i in 0...4) {
                var bfStrum = strumLines.members[1].members[i];
                if(bfStrum != null) bfStrum.x = midX - (spacing * 1.5) + (i * spacing);
            }
            pictures.alpha = 1;
            break;

        case 4378:
            FlxTween.tween(camGame, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            pictures.destroy();
            remove(pictures, true);

        case 4410:
            castle();
            FlxTween.tween(camGame, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            rtxr.innerShadowAngle = 240 * (Math.PI / 180);
            rtxp.innerShadowAngle = 0 * (Math.PI / 180);
            rtxp.satinColor = [0.5, 0.2, 0, 0.3];
            rtxr.satinColor = [0.5, 0.2, 0, 0.3];
            boyfriend.shader = rtxr;
            dad.shader = rtxp;
            boyfriend.alpha = 1;
            dad.alpha = 1;
            boyfriend.color = dad.color = 0xFFFFFF;
            dad.cameraOffset.set(50, 50);
            dad.scale.set(1.2, 1.2);
            boyfriend.cameraOffset.set(0, -200);
            break;
}
}


function changeHealth() {
    healthchange = true;
    new FlxTimer().start(2, () -> {
        healthchange = false;
    });
}


function removenormalbg() {
    for (o in [nbg, nblock, nsun, nlight, sea, npipe1, npipe3, npipe2, nblock4, nblock3, nblock2, nblock1, nfloor, ncloud1, ncloud2, ncloud3]) {
        FlxTween.tween(o, {alpha: 0}, 0.5, {ease: FlxEase.expoOut});
        o.destroy();
        remove(o, true);
    }
}

function activatewhite() {
    for (o in [bg, light, cliff, waterfall2,block1,block2, fg,debris, debris2, debris3, pipe, plant,floor]) o.alpha = 0;
    
    insert(1, white = new FlxSprite().makeSolid(FlxG.width * 3.5, FlxG.height * 3.5, FlxColor.WHITE)).scrollFactor.set();
    white.screenCenter();

    boyfriend.color = 0xFF000000;
    dad.color = 0xFF000000;
}

function desactivatewhite() {
    if (white != null) {
        white.destroy();
        remove(white, true);
    }

    for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) {
        if (o != null) o.alpha = 1;
    }

    boyfriend.color = 0xFFFFFF;
    dad.color = 0xFFFFFF;
}

function activateblack() {
    for (o in [bg, light, cliff, waterfall2, block1, block2, fg, debris, debris2, debris3, pipe, plant, floor]) {
        if (o != null) o.alpha = 1;
    }

    if (black != null) {
        black.destroy();
        remove(black, true);
    }

    black = new FlxSprite().makeSolid(FlxG.width * 3.5, FlxG.height * 3.5, FlxColor.BLACK);
    black.scrollFactor.set();
    black.screenCenter();
    insert(1, black);

    boyfriend.color = 0xFFFFFFFF;
    dad.color = 0xFFFFFFFF;

}


function desactivateblack() {
    if (black != null) {
        black.destroy();
        remove(black, true);
        black = null;
    }

    boyfriend.color = 0xFFFFFF;
    dad.color = 0xFFFFFF;
}

function moses() {
    for (i in [black,clouds,blend,sun,land,wave,rocks]) i.alpha = 1;
        
    fg.alpha = 0;
}

function castle() {
    for (i in [thesky,back,wall,fort,fort_light,flag,flag2,pillars,statue,window_pillars,window_light,sign,base,fence]) i.alpha = 1;

    fg.alpha = 0;
    setCameraZoom(0.4, 5);

    add(boyfriend);
    add(dad);
}

function beatHit(curBeat:Int)
{
    if (darkbgActive && darkbg != null)
    {
        var originalY = 900;

        FlxTween.cancelTweensOf(darkbg);

        FlxTween.tween(darkbg, {y: originalY - 60}, 0.05, {
            ease: FlxEase.circOut,
            onComplete: function(_)
            {
                FlxTween.tween(darkbg, {y: originalY}, 0.25, {ease: FlxEase.bounceOut});
            }
        });
    }
}