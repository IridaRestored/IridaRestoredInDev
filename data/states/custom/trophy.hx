
import flx3d.Flx3DView;
import flx3d.Flx3DUtil;
import openfl.system.System;
import away3d.core.base.Geometry;
import flx3d.Flx3DCamera;
import flixel.FlxCamera;
import away3d.cameras.lenses.PerspectiveLens;

import flixel.addons.display.FlxBackdrop;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import funkin.menus.MainMenuState;

var selected = 0;
var p = 'menus/trophy/';

// trophy name, trophy description, trophy model (and texture name)
var list = [
    ['Irida', 'I used to tickle my pickle to angry birds', 'trophy'],
    ['Execretion', 'hawk tuah! spit on that thang! haha!', 'trophy2'],
    ['Revenant', 'Oh no. Is this... GAAAH! The evil Slingmingo!!!', 'trophy3']
];

// scale, x, y
var models = [
    'trophy' => [45, 100, -90],
    'trophy2' => [140, 100, -120],
    'trophy3' => [135, 100, -10]
];

var bg;
var headerTxt; var descTxt;
var barHeader; var barDesc;
var topBar; var bottomBar;

var txtArray;
var txtSpeed = 0.05;
var txtTimer = new FlxTimer();

var canSelect = true;

var view; var trophy;

function postCreate() {
    add(bg = new FlxSprite().loadGraphic(Paths.image(p + 'bg'))).screenCenter();
    bg.scale.set(0.6, 0.6);

    add(sml = new FlxBackdrop(Paths.image(p + 'sml'))).velocity.set(-60, 60);
    sml.alpha = 0.5;

    add(barHeader = new FlxSprite().makeSolid(100, 100, FlxColor.BLACK)).alpha = 1;
    add(barDesc = new FlxSprite().makeSolid(100, 100, FlxColor.BLACK)).alpha = 1;

    add(headerTxt = new FlxText(250, 200, 0, ''));
    headerTxt.setFormat(Paths.font('pixel.otf'), 40, FlxColor.WHITE, 'center');

    add(descTxt = new FlxText(250, 300, 250, ''));
    descTxt.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'center');

    add(bottomBar = new FlxSprite().loadGraphic(Paths.image(p + 'bar')));
    add(topBar = new FlxSprite().loadGraphic(Paths.image(p + 'bar')));
    topBar.flipX = topBar.flipY = true;

    for (i => b in [bottomBar, topBar]) {
        b.scale.set(0.5, 0.5);
        b.screenCenter();
        b.y += 300 * ((i>0) ? -1 : 1);
    }

	Flx3DUtil.is3DAvailable();
	view = new Flx3DView(0, 0, FlxG.width * 1, FlxG.height * 1);
	view.screenCenter();
	view.scrollFactor.set();
	view.antialiasing = true;
	//view.view.camera.lens = new PerspectiveLens(70);
	view.view.camera.lens.far = 100000000;
    insert(10, view);

    FlxG.mouse.visible = true;

    change(0);
}

function change(n) {
    selected += n;
    if (selected > list.length-1) selected = 0;
    if (selected < 0) selected = list.length-1;

    var p = list[selected];
    var s = models[p[2]];

    for (m in view.meshes) m.dispose();
    if (trophy != null) trophy.asset.dispose();

    view.addModel(Paths.obj('trophies/' + p[2]), function(model) {
		if (Std.string(model.asset.assetType) == "mesh") {
			model.asset.scale(s[0]);
			model.asset.x = s[1];
			model.asset.y = s[2];
			model.asset.z = -740;
            trophy = model;
		}
	}, Paths.image('textures/trophies/' + p[2]), false);

    if (n != 0) FlxG.sound.play(Paths.sound('menu/scroll'));

    headerTxt.text = p[0];
    headerTxt.x = 400 - headerTxt.fieldWidth / 2;
    headerTxt.updateHitbox();

    txtArray = p[1].split(''); // 'Hello you!' --> ['H','e','l','l','o', ,'y','o','u','!']
    var curLine = 0;

    if (!txtTimer.finished) txtTimer.cancel();
    descTxt.text = '';

    barHeader.scale.set(headerTxt.fieldWidth + 30, headerTxt.fieldHeight + 10);
    barHeader.updateHitbox();
    barHeader.setPosition(headerTxt.getGraphicMidpoint().x - barHeader.scale.x/2, headerTxt.getGraphicMidpoint().y - barHeader.scale.y/2);

    txtTimer.start(txtSpeed, 
        function(_:FlxTimer) {
            curLine += 1;
            descTxt.text = descTxt.text + txtArray[curLine-1];
            descTxt.updateHitbox();

            descTxt.x = headerTxt.getGraphicMidpoint().x - (descTxt.fieldWidth / 2);

            barDesc.scale.set(descTxt.fieldWidth + 30, descTxt.fieldHeight + 10);
            barDesc.updateHitbox();
            barDesc.setPosition(descTxt.getGraphicMidpoint().x - barDesc.scale.x/2, descTxt.getGraphicMidpoint().y - barDesc.scale.y/2);
        },
        txtArray.length
    );

    trace(trophy.asset.material);
}

var fuck = false;

function update(_) {
    if ((FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT) && canSelect) 
        change(FlxG.keys.justPressed.LEFT ? -1 : 1);

    if (FlxG.keys.justPressed.BACKSPACE) {
        if (canSelect) {FlxG.switchState(new MainMenuState());}

        else if (fuck) {
            fuck = false;
            for (t in [headerTxt,descTxt,barHeader,barDesc]) FlxTween.tween(t, {alpha: 1}, 0.1);

            FlxTween.tween(topBar, {y: topBar.y + 150}, 0.6, {ease: FlxEase.circOut});
            FlxTween.tween(bottomBar, {y: bottomBar.y - 150}, 0.6, {ease: FlxEase.circOut});

            FlxTween.tween(trophy.asset, {z: trophy.asset.z + 30}, 0.6, {ease: FlxEase.circOut});

            FlxTween.tween(view.view.camera, {x: view.view.camera.x - 105}, 0.6, {ease: FlxEase.circOut, onComplete: function(t:FlxTween) {canSelect = true;}});
            //FlxTween.tween(FlxG.camera, {zoom: 1}, 0.6, {ease: FlxEase.circOut});
        }
    }

    if (canSelect) trophy.asset.rotationY += 50 * _;

    Mouse.cursor = (FlxG.mouse.getScreenPosition(FlxG.camera).x >= FlxG.width / 1.8 && canSelect) ? MouseCursor.BUTTON : MouseCursor.ARROW;

    if (((FlxG.mouse.getScreenPosition(FlxG.camera).x >= FlxG.width / 1.8 && FlxG.mouse.justPressed) || FlxG.keys.justPressed.ENTER) && canSelect) {
        canSelect = false;

        for (t in [headerTxt,descTxt,barHeader,barDesc]) FlxTween.tween(t, {alpha: 0}, 0.1);

        FlxTween.tween(topBar, {y: topBar.y - 150}, 0.6, {ease: FlxEase.circOut});
        FlxTween.tween(bottomBar, {y: bottomBar.y + 150}, 0.6, {ease: FlxEase.circOut});

        FlxTween.tween(trophy.asset, {z: trophy.asset.z - 30}, 0.6, {ease: FlxEase.circOut});

        FlxTween.tween(view.view.camera, {x: view.view.camera.x + 105}, 0.6, {ease: FlxEase.circOut, onComplete: function(t:FlxTween) {fuck = true;}});
        //FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.6, {ease: FlxEase.circOut});
    }

    if (!canSelect) {
        if ((FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)) {
            trophy.asset.rotationY += 1.5 * (FlxG.keys.pressed.LEFT ? -1 : 1);
        }
    }

    /*if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT) 
        trophy.asset.x += 20 * (FlxG.keys.pressed.LEFT ? -1 : 1);

    if (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN) 
        trophy.asset.y += 20 * (FlxG.keys.pressed.DOWN ? -1 : 1);

    if (FlxG.keys.pressed.W || FlxG.keys.pressed.S) 
        trophy.asset.z += 20 * (FlxG.keys.pressed.S ? -1 : 1);

    trace(trophy.asset.x + ', ' + trophy.asset.y + ', ' + trophy.asset.z);*/
}

function destroy() {
    view.destroy();
    Mouse.cursor = MouseCursor.ARROW;
}