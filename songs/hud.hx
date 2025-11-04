import flixel.text.FlxTextBorderStyle;

var hud, image;
var songstart, songsend = false;
var flip = false;
var shadow = false;
doIconBop = false;

var hudS = [];

var healthbarImg = Paths.image('game/healthbarnew');
var healthbarShadowImg = Paths.image('game/Healthbarnew shadow');
var shadowDownImg = Paths.image('game/shadow_down');
var flowerbarImg = Paths.image('game/flowerbar');
var healthbarDownscrollImg = Paths.image('game/healthbar_downscroll');
var cordycepsNoteImg = 'game/notes/CordycepsNOTE_assets';

function preCacheAssets() {
    FlxG.bitmap.add(healthbarImg);
    FlxG.bitmap.add(healthbarShadowImg);
    FlxG.bitmap.add(shadowDownImg);
    FlxG.bitmap.add(flowerbarImg);
    FlxG.bitmap.add(healthbarDownscrollImg);
    FlxG.bitmap.add(Paths.font("SuperMario256.ttf"));
    FlxG.bitmap.add(Paths.image(cordycepsNoteImg)); 
}

function postCreate() {
    preCacheAssets();

    insert(members.indexOf(iconP1), hud = new FlxSprite(-375, -75).loadGraphic(healthbarImg)).cameras = [camHUD];
    hud.scale.set(0.6, 0.6);

    healthBar.scale.set(1.6, 2.5);
    remove(healthBarBG);

    scoreTxt.x = 615;
    accuracyTxt.x = 115;

    hudS = [hud, healthBar, iconP1, iconP2, scoreTxt, accuracyTxt, missesTxt];

    for (o in [scoreTxt, accuracyTxt, missesTxt]) {
        o.setFormat(Paths.font("SuperMario256.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        o.borderSize = 3;
        o.y = 667;
    }

    if (downscroll) {
        healthBar.y = 631;
        hud.y = -80;
        hud.loadGraphic(healthbarDownscrollImg);
    }

    switch(PlayState.SONG.meta.name) {
        case 'irida':
        case 'execretion':
            for (o in hudS) o.alpha = 0;

        case 'shucks':
            hud.loadGraphic(healthbarShadowImg);
            shadow = true;
            if (downscroll) hud.loadGraphic(shadowDownImg);

        case 'cordyceps':
            hud.loadGraphic(flowerbarImg);
            hud.scale.set(0.6, 0.6);
            hud.updateHitbox();

            // Centrado horizontal
            hud.x = (FlxG.width - hud.width) / 2;
            // Alinear verticalmente con el healthBar
            hud.y = healthBar.y - ((hud.height - healthBar.height) / 1.9);

            if (downscroll) {
                healthBar.y = 631;
                hud.y = healthBar.y - ((hud.height - healthBar.height) / 2.1);
            }

        case 'revenant':
            flip = true;
    }

    iconP2.flipX = iconP1.flipX = healthBar.flipX = flip;
}

function beatHit() {
    for (i in [iconP1, iconP2]) {
        i.scale.set(1.2, 1.2);
        FlxTween.tween(i.scale, {x: 1, y: 1}, (0.5 * (1 / (Conductor.bpm / 60))), {ease: FlxEase.circOut});
    }
}

var c = (PlayState.SONG.meta.name == 'cordyceps') ? 0xFF6A0053 : 0xFF8B0000;

function postUpdate() {
    iconP2.x = (flip ? 1070 : 70);
    iconP1.x = (flip ? 70 : 1070);

    for (i => o in [scoreTxt, accuracyTxt, missesTxt, accFormat]) {
        o.borderColor = 0xFF000000;

        if (i > 2) o.format.color = c;
        else o.color = c;
    }

    if (shadow && PlayState.SONG.meta.name == 'shucks') {
        for (o in [accuracyTxt, scoreTxt, missesTxt]) {
            o.color = FlxColor.WHITE;
        }
        accFormat.format.color = FlxColor.WHITE;
    } else if (!shadow && PlayState.SONG.meta.name == 'shucks') {
        for (o in [accuracyTxt, scoreTxt, missesTxt]) {
            o.color = 0xFF8B0000;
        }
        accFormat.format.color = 0xFF8B0000;
    }
}

function onNoteCreation(note) {
    if (PlayState.SONG.meta.name == 'cordyceps') note.noteSprite = cordycepsNoteImg;
}

function onStrumCreation(strum) {
    if (PlayState.SONG.meta.name == 'cordyceps') strum.sprite = cordycepsNoteImg;
}

function stepHit(s) {
    switch(PlayState.SONG.meta.name) {
        case 'irida':
            switch(s) {
                case 246:
                    for (o in hudS) FlxTween.tween(o, {alpha: 1}, 10, {ease: FlxEase.expoOut});
                case 1810:
                    for (o in hudS) FlxTween.tween(o, {alpha: 0}, 10, {ease: FlxEase.expoOut});
                case 1966:
                    iconP2.flipX = iconP1.flipX = healthBar.flipX = flip = true;
                case 1990:
                    for (o in hudS) FlxTween.tween(o, {alpha: 1}, 10, {ease: FlxEase.expoOut});
		case 2725:
                    iconP2.flipX = iconP1.flipX = healthBar.flipX = flip = false;


            }

        case 'shucks':
            switch(s) {
                case 435:
                    shadow = false;
                    hud.loadGraphic(healthbarImg);
                    if (downscroll) hud.loadGraphic(healthbarDownscrollImg);
                case 3172:
                    for (o in hudS) FlxTween.tween(o, {alpha: 0}, 2, {ease: FlxEase.expoOut});
                case 3448:
                    for (o in hudS) o.alpha = 1;
            }

        case 'execretion':
            if (s == 128) {
                for (o in hudS) o.alpha = 1;
            }
    }
}
