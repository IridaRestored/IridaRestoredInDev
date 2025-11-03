import funkin.menus.ModSwitchMenu;

var bg:FlxSprite;
canPause = false;

function create() {
    bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/stages/old  shucks'));
    bg.screenCenter();
    bg.scale.set(0.6, 0.6);
    insert(1, bg);
    bg.cameras = [camHUD];
}

function postCreate() {
    for (s in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, accuracyTxt, missesTxt]) {
        remove(s);
    }
}

function postUpdate() {
    if (controls.ACCEPT) {
        FlxG.switchState(new ModState('custom/gallery'));
    }
}
