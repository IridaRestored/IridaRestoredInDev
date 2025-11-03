import flixel.addons.display.FlxBackdrop;
var spike:FlxBackdrop;
var spike2:FlxBackdrop;
function create() {
    transitionTween.cancel();

    remove(blackSpr);
	remove(transitionSprite);
    var newstate = newState != null;

    spike = new FlxBackdrop(Paths.image('game/spikes'));
    spike.x = -640;
    spike.y = 200;
    spike.scale.x = 0.6;
    spike.scale.y = 0.6;
    spike.velocity.x = 0;
    add(spike);

    spike2 = new FlxBackdrop(Paths.image('game/spikes2'));
    spike2.x = -640;
    spike2.y = -545;
    spike2.scale.x = 0.6;
    spike2.scale.y = 0.6;
    spike2.velocity.x = 0;
    add(spike2);

    if (newstate){
		FlxTween.tween(spike,{y:  -294},1,{ease: FlxEase.circInOut});
		FlxTween.tween(spike2,{y: -78},1,{ease: FlxEase.circInOut,onComplete:
		function(t:FlxTween) {
			nextmenu();
		}
	});
    }else{
        spike.y = -294;
        spike2.y = -88;
        spike2.velocity.x = 0;
        spike.velocity.x = 0;
		FlxTween.tween(spike,{y:  200},1,{ease: FlxEase.circInOut});
		FlxTween.tween(spike2,{y: -545},1,{ease: FlxEase.circInOut,onComplete:
		function(t:FlxTween) {
			nextmenu();
		}
	});
    }
}

function nextmenu(){
    if (newState != null){
        FlxG.switchState(newState);
    }

    new FlxTimer().start(3, function(tmr:FlxTimer)
    {
    FlxTween.tween(spike,{y:  200},1,{ease: FlxEase.circInOut});
    FlxTween.tween(spike2,{y: -545},1,{ease: FlxEase.circInOut});
    });

}