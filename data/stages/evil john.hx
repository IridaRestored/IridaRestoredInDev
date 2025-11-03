import flx3d.Flx3DView;
import flx3d.Flx3DUtil;
import openfl.system.System;
import away3d.core.base.Geometry;
import flx3d.Flx3DCamera;
import away3d.cameras.lenses.PerspectiveLens;

import away3d.lights.DirectionalLight;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.lights.PointLight;
import away3d.lights.shadowmaps.CascadeShadowMapper;
import away3d.materials.methods.FogMethod;
import openfl.display.BlendMode;
import away3d.materials.TextureMaterial;
import away3d.lights.shadowmaps.DirectionalShadowMapper;

import Shadow;

var forest;
var light;
var light2;
var light3;
var shad;
var shadows;
var fog;
var lightPicker;

var rtx = new CustomShader('RTXLighting');
var blur = new CustomShader('blur');
var bloom = new CustomShader('bloom');
var glitch = new CustomShader('glitch');
var vhs = new CustomShader('vhs');
var sat = new CustomShader('saturation');
//var fogS = new CustomShader('fog');

function create() {
    FlxG.cameras.add(camOv = new FlxCamera(), false).bgColor = 0;
    Flx3DUtil.is3DAvailable();
	view = new Flx3DView(0, 0, FlxG.width * 1.15, FlxG.height * 1.15);
	view.screenCenter();
	view.scrollFactor.set();
	view.antialiasing = true;
	//view.view.camera.lens = new PerspectiveLens(70);
	view.view.camera.lens.far = 100000000;

    for (h in [hud, cardiograph,conditions]) {
        h.cameras = [camOv];
    }
    conditions.animation.addByPrefix('fine', "fine", 6);
    conditions.animation.addByPrefix('panic', "panic", 6);
    conditions.animation.addByPrefix('terminal', "terminal", 6);
    conditions.animation.play('fine');

    camGame.x = -200;
    camGame.y = 100;
    conditions.playAnim('fine');
    FlxG.camera.bgColor = 0xFF000010;

    shad = new CascadeShadowMapper(4);

    fog = new FogMethod(400, 1450, FlxG.camera.bgColor);

	light = new DirectionalLight();
	light.y = 1125;
    light.z = 500;

    light.ambient = 0.17;
    light.ambientColor = 0xFF06005C;

    light._specular = 0;
    light._specularR = 0.01;
    light._specularG = 0.01;
    light._specularB = 0.01;

    light._diffuse = 1;
    light._diffuseR = 0.95;
    light._diffuseG = 0.95;
    light._diffuseB = 1;

    light.castsShadows = true;
    light.shadowMapper = shad;

	if (view != null) view.view.scene.addChild(light);

    shadows = new DirectionalShadowMapper();
    shadows.lightOffset = 50000;
    shadows.autoUpdateShadows = true;

    light.shadowMapper = shadows;

    light2 = new PointLight();
    light2._fallOff *= 2;
    
	lightPicker = new StaticLightPicker([light]);

    view.addModel(Paths.awd('forest'), function(model) {
		if (Std.string(model.asset.assetType) == 'mesh') {
			model.asset.scale(200);
			model.asset.x = 0;
			model.asset.y = -200;
			model.asset.z = -1600;
            model.asset.material.lightPicker = lightPicker;
            //model.asset.material.smooth = true;
            forest = model;

            var m = model.asset.material;

            // code snippet by Ne_Eo, from Funkscop

            if (m is TextureMaterial) {
                m.alphaThreshold = 0.5;
                m.bothSides = true;
                var hasFog = false;
        
                @:privateAccess for (meth in m._screenPass._methodSetup._methods) {
                    if (meth.method == fog) {
                        hasFog = true;
                        break;
                    }
                }
        
                if (!hasFog) m.addMethod(fog);
                //m.alphaBlending = true;
                //m.alphaPremultiplied = true;
            }
		}
	}, null, false);

    insert(1, bg);

}

function postCreate() {
    for (s in [healthBar,healthBarBG,iconP1,iconP2,scoreTxt,accuracyTxt,missesTxt]) remove(s);
    FlxG.camera.followLerp = 0.06;

    for (i in 0...cpuStrums.length) {
        var str = strumLines.members[0].members[i];
        str.x = 800;
        str.y += 160 + i*60;

        str.cameras = [camGame];
        str.scrollFactor.set(0.9, 0.9);
        str.angle = 90;
    }
    for (i in 0...playerStrums.length) {
        var str = strumLines.members[1].members[i];
        str.x = 905 + i*93;
        str.y = 15;
        str.cameras = [camOv];
    }
    insert(3, view);
    remove(dad); insert(14, dad);
    remove(boyfriend); insert(15, boyfriend);

    rtx.overlayColor = [0, 0, 1, 0];
    rtx.satinColor = [0, 0, 1, 0.35];
    rtx.innerShadowColor = [0, 0, 0, 0.4];
    rtx.innerShadowAngle = 240 * (Math.PI / 180);
    rtx.innerShadowDistance = 29;

    dad.shader = boyfriend.shader = rtx;

    /*bloom.Threshold = -0.1;
    bloom.Intensity = 1;
    camGame.addShader(bloom);*/

    sat.sat = 0.5;

    camGame.addShader(new CustomShader('perspective'));
    //camGame.addShader(fogS);

    blur.directions = 16;
    blur.quality = 4;
    blur.size = 10;

    s = new Shadow(dad);
    s.alpha = 0.4;
    s.offset.y -= 40;
    s.color = FlxColor.BLACK;
    s.shader = blur;
    //s.skew.y = 20;

    vhs.sat = 0.9;
    vhs.wiggle = 0.0015;
    vhs.data.iChannel1.input = Assets.getBitmapData('images/game/shader-static.png');

    camGame.addShader(vhs);
}

function onEvent(_) {
    if (_.event.name == 'Camera Movement') 
        defaultCamZoom = (_.event.params[0] == 0) ? 1.1 : 0.8;
}

var lol = 0;
var fuck = 0;

function onNoteCreation(_) {
    _.note.frameOffset.x = 25;
    if (_.strumLineID == 0) {
        _.note.shader = sat;

        if (_.note.isSustainNote) {
            if (_.note.prevNote.isSustainNote) {
                _.note.prevNote.frameOffset.x = 146;
                _.note.prevNote.frameOffset.y = 0;
            }
            _.note.frameOffset.x = 25;
            _.note.frameOffset.y = 150;
        }

        /*if (!_.note.isSustainNote) _.note.scrollSpeed = FlxG.random.float(2.7, 6);
        else _.note.scrollSpeed = _.note.prevNote.scrollSpeed;*/
    }
}

function update(_) {
    boyfriend.scale.x = boyfriend.scale.y = 0.6 + ((camGame.zoom - 0.75) * 2);
    boyfriend.alpha = lerp(boyfriend.alpha, (curCameraTarget == 0) ? 0.4 : 1, _ * 6);

    var f = light.sceneDirection;

    light.sceneDirection.x = 0.15;
    light.sceneDirection.y = -0.25;
    light.sceneDirection.z = 0.61;

    lol += _ / 2;
    fog.maxDistance = 1200 - Math.sin(lol) * 250;
    //fogS.iTime = lol;

    light.sceneDirection.x = 0.15;
    light.sceneDirection.y = -0.25;
    light.sceneDirection.z = 0.41 - Math.sin(lol) / 8;

    fuck += _;
    vhs.iTime = fuck;

    //if (tcimm != null) tcimm.asset.material.lightPicker = lightPicker;

    view.view.camera.x = FlxG.camera.scroll.x/3.5 + 200;
    view.view.camera.y = -FlxG.camera.scroll.y/3.5 - 50;
    view.view.camera.z = -1150 + (FlxG.camera.zoom * 10);

    /*if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT) 
        f.x += 0.1 * (FlxG.keys.pressed.LEFT ? -1 : 1);

    if (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN) 
        f.y += 0.1 * (FlxG.keys.pressed.DOWN ? -1 : 1);

    if (FlxG.keys.pressed.W || FlxG.keys.pressed.S) 
        f.z += 0.1 * (FlxG.keys.pressed.S ? -1 : 1);

    trace(light.sceneDirection.z);

    if (FlxG.keys.pressed.A || FlxG.keys.pressed.D) 
        forest.asset.rotationY += 2 * (FlxG.keys.pressed.D ? -1 : 1);*/

    //trace(f.x + ', ' + f.y + ', ' + f.z);

    if (health >= 1){
        conditions.animation.play('fine');
    }
    if ((0.5 < health)&&(health < 1)){
        conditions.animation.play('panic');
    }
    if (health < 0.5){
        conditions.animation.play('terminal');
    }
}

function beatHit(b) {
    switch(b) {
        case 147:
            camGame.addShader(glitch);
            glitch.prob = 0;
            glitch.intensityChromatic = 0;

        case 212:
            camGame.removeShader(glitch);
    }

    if (b > 147 && b < 212) {
        FlxTween.num(0.4, 0, Conductor.stepCrochet / 270, {ease: FlxEase.quadOut}, (v) -> {glitch.intensityChromatic = v;});
        FlxTween.num(2.5, 3.2, Conductor.stepCrochet / 300, {ease: FlxEase.quadOut}, (v) -> {scrollSpeed = v;});

        FlxTween.completeTweensOf(camGame, ['angle']);
        camGame.angle = (b % 2 != 0) ? 3.5 : -3.5;
        FlxTween.tween(camGame, {angle: 0}, Conductor.stepCrochet / 330, {ease: FlxEase.circOut});
    } 
}

function onCountdown(_) _.cancel();
function onStrumCreation(_) _.cancelAnimation();

function destroy() {
    view.destroy();
    FlxG.camera.bgColor = 0;
    FlxG.game.setFilters();
}