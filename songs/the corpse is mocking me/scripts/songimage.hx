import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

var image:FlxSprite;
var songstart:Bool = false;
var songsend:Bool = false;
playCutscenes = true;

function onCountdown(e) {
    e.cancel();
}

function postCreate() {
    image = new FlxSprite().loadGraphic(Paths.image('songimage/the corpse is mocking me'));
    image.cameras = [camHUD];
    image.scale.set(0.6, 0.6);
    image.updateHitbox();
    image.screenCenter();

    // Empieza invisible (alpha 0)
    image.alpha = 0;
}

function stepHit(curStep:Int){
    switch(curStep){
        case 2:
            add(image);
            // Fade in (0 → 1 en 1 segundo)
            FlxTween.tween(image, {alpha: 1}, 1, {ease: FlxEase.quadOut});

            // Espera 3 segundos y luego fade out (1 → 0 en 1 segundo)
            new FlxTimer().start(3, function(tmr:FlxTimer) {
                FlxTween.tween(image, {alpha: 0}, 1, {
                    ease: FlxEase.quadIn,
                    onComplete: function(twn) {
                        remove(image, true);
                    }
                });
            });
        case 768:
            FlxTween.tween(image, {x: -100}, 2, {ease: FlxEase.expoOut});
            new FlxTimer().start(3, function(tmr:FlxTimer) {
                FlxTween.tween(image, {x: 1700}, 3, {ease: FlxEase.backInOut});
            });
    }
}

