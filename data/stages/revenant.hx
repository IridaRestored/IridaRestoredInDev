import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import hxvlc.flixel.FlxVideoSprite;

var bg:FlxSprite;
var stove:FlxSprite;
var oven:FlxSprite;
var timer:FlxSprite;

var blackFade:FlxSprite;
var fireVideo:FlxVideoSprite;

// === CONFIGURACIÓN AJUSTABLE ===
var BLACK_W:Int = 5000;  // ancho pantalla negra
var BLACK_H:Int = 5200;  // alto pantalla negra
var BLACK_X:Int = -700;  // posición X pantalla negra
var BLACK_Y:Int = -700;  // posición Y pantalla negra

var FIRE_W:Int =   3;   // ancho del video
var FIRE_H:Int =   3;   // alto del video
var FIRE_X:Int = -200;   // posición X del video
var FIRE_Y:Int = -100;   // posición Y del video
// ===============================

var rtxj = new CustomShader('RTXLighting');
var rtxp = new CustomShader('RTXLighting');
var rtx = new CustomShader('RTXLighting');
var rtxc = new CustomShader('RTXLighting');

function create() {
    boyfriend.x = 0;
    boyfriend.y =  200;
    dad.x = 1000;
    dad.y = -100;
    gf.x = -200;
    gf.y = 150;
    strumLines.members[3].characters[0].x = 200;
    strumLines.members[3].characters[0].y = 150;

    dad.scale.set(0.8, 0.8);
    boyfriend.scale.set(0.8, 0.8);
    gf.scale.set(0.8, 0.8);
    strumLines.members[3].characters[0].scale.set(0.8, 0.8);

    for (i => r in [rtxp, rtxc, rtx, rtxj]) {
        r.overlayColor = getRGB(255, 0, 0, 0.6, 0.3);
        r.satinColor = getRGB(255, 0, 0, 0.6, 0.4);
        r.innerShadowColor = getRGB(255, 165, 0, 0.3, 0.6);
        r.innerShadowAngle = 240 * (Math.PI / 180);
    }
    rtxp.innerShadowDistance = 25;
    rtxc.innerShadowDistance = 25;
    rtxj.innerShadowDistance = 30;
    rtx.innerShadowDistance = 30;

    dad.shader = rtxp;
    boyfriend.shader = rtx;
    gf.shader = rtxc;
    strumLines.members[3].characters[0].shader = rtxj;
    
    boyfriend.cameraOffset.set(150, -100);
    dad.cameraOffset.set(-250, 0);
    gf.scrollFactor.set(1,1);
    strumLines.members[3].characters[0].scrollFactor.set(1,1);

    // --- Sprite negro ajustable ---
    blackFade = new FlxSprite();
    blackFade.makeGraphic(1, 1, FlxColor.BLACK); // 1x1 y luego se escala
    blackFade.scrollFactor.set(0, 0);
    blackFade.alpha = 0;
    blackFade.setGraphicSize(BLACK_W, BLACK_H);
    blackFade.updateHitbox();
    blackFade.x = BLACK_X;
    blackFade.y = BLACK_Y;
    add(blackFade);

    // --- Video Fire ajustable ---
    fireVideo = new FlxVideoSprite();
    fireVideo.load(Paths.video("Fire"));
    fireVideo.scrollFactor.set(0, 0);
    fireVideo.alpha = 0.5; // medio transparente
    fireVideo.visible = false;
    fireVideo.antialiasing = true;
    fireVideo.setGraphicSize(FIRE_W, FIRE_H);
    fireVideo.updateHitbox();
    fireVideo.x = FIRE_X;
    fireVideo.y = FIRE_Y;
    add(fireVideo);
}

function stepHit(curStep:Int) {
    // Step 2748: Fade a negro
    if (curStep == 2748) {
        FlxTween.tween(blackFade, {alpha: 1}, 0.8, {ease: FlxEase.quadOut}); 
    }

    // Step 3158: quitar negro y activar video Fire
    if (curStep == 3158) {
        blackFade.alpha = 0;
        FlxTween.cancelTweensOf(blackFade);

        fireVideo.visible = true;
        fireVideo.play();
        fireVideo.loop = true;
    }
}

function getRGB(r, g, b, sat, blend){
    return [
        FlxMath.remapToRange(r, 0, 255, 0, 1) - sat, 
        FlxMath.remapToRange(g, 0, 255, 0, 1) - sat,
        FlxMath.remapToRange(b, 0, 255, 0, 1) - sat,
        blend
    ];
}
