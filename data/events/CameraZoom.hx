
function onEvent(_) {
	switch (_.event.name){
        case 'CameraZoom':
            var amount =_.event.params[0];
            var TweenType = _.event.params[2];
            var duration = (Conductor.stepCrochet / 1000) *_.event.params[1];

        zoomTween = FlxTween.tween(camera, {zoom: amount}, duration, {ease: Reflect.field(FlxEase, TweenType)});
        defaultCamZoom = amount;

    }
}
