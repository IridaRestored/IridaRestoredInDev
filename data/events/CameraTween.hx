import flixel.camera.FlxCameraFollowStyle;

var camLock:Bool = false;
var camFollowTween:FlxTween;

function onEvent(_) {
	switch (_.event.name){
        case 'CameraTween':
            target = _.event.params[0];
            var targetcameraX = strumLines.members[target].characters[0].getCameraPosition().x +  _.event.params[1];
            var targetcameraY = strumLines.members[target].characters[0].getCameraPosition().y +  _.event.params[2];
            var TweenType = _.event.params[4];
            var duration = (Conductor.stepCrochet / 1000) *_.event.params[3];

            camLock = true;
            FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 10);
            
            if(camFollowTween != null) camFollowTween.cancel();
            switch (TweenType.toUpperCase()){
                case "NORMAL":
                    camFollow.setPosition(targetcameraX, targetcameraY);
                    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
                case "INSTANT":
                    camFollow.setPosition(targetcameraX, targetcameraY);
                    FlxG.camera.focusOn(camFollow.getPosition());
                default: camFollowTween =  FlxTween.tween(camFollow, {x: targetcameraX, y: targetcameraY}, duration, {ease: Reflect.field(FlxEase, TweenType)});
            }
        case 'Camera Movement':
            if(camFollowTween != null) camFollowTween.cancel();
            if(camLock){
                camLock = false;
                FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
            }
        
    }
}


function onCameraMove(_){
    switch(camLock){
        case true: _.cancelled = true;
        case false: _.cancelled = false;
    }
}