import funkin.menus.ModSwitchMenu;

var bg:FlxSprite;
canPause = false;

function create() {
    bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/gallery/stages/tcimm'));
    bg.screenCenter();
    bg.scale.set(0.6, 0.6);
    insert(1, bg);
    bg.cameras = [camHUD];
}

function postCreate() {
    for (s in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, accuracyTxt, missesTxt]) {
        remove(s);
    }

    // Centro vertical
    var centerY = FlxG.height / 2;

    // Número de notas (usualmente 4 por lado)
    var numNotes = 4;

    // Separación horizontal entre notas
    var spacing = 112; // ajusta si lo ves muy separado o muy junto

    // Calcular inicio horizontal para que todo el strumline quede centrado
    var totalWidth = (numNotes - 1) * spacing;
    var startX = (FlxG.width / 2) - (totalWidth / 2);

    // Si downscroll está activado, centrar verticalmente
    if (ClientPrefs.downScroll) {
        for (i in 0...numNotes) {
            playerStrums.members[i].y = centerY;
            opponentStrums.members[i].y = centerY;
        }
    }

    // Centrar horizontalmente ambos strumlines
    for (i in 0...numNotes) {
        playerStrums.members[i].x = startX + i * spacing;
        opponentStrums.members[i].x = startX + i * spacing;
    }
}

function postUpdate() {
    if (controls.ACCEPT) {
        FlxG.switchState(new ModState('custom/gallery'));
    }
}
