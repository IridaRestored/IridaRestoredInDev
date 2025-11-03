
import funkin.editors.ui.UIText;
import funkin.menus.ModSwitchMenu;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIState;
//import flixel.text.FlxTextFormat;
import flixel.addons.display.FlxBackdrop;
import hxvlc.flixel.FlxVideoSprite;

var light, heads, shit, video;
var tb:UITextBox;
var freeplay;
var hitbox;
var trophy;
var hitbox2;
var canSelect = true;
var marvin = false;

var list = [
    'shuck' => ['song', 'shucks'],
    'roses' => ['song', 'execretion'],
    'sleep' => ['song', 'the corpse is mocking me'],
    'grief' => ['song', 'revenant'],
    'bloom' => ['song', 'cordyceps'],

    'poop' => ['image'],
    'bart' => ['image'],
    'mew' => ['image'],
    'ratio' => ['image'],
    'chill' => ['image'],
    'boing' => ['image'],
    'dirty' => ['image'],
    'happy' => ['image'],
    'bufftg' => ['image'],
    'smile' => ['image'],
    'iridadog' => ['image'],
    'dctg' => ['image'],

    'aetho' => ['video', 470, 50, 1.62, 0.8],
    'penis' => ['video', -90, -300, 0.36, 0.3],
    'plane' => ['video', 210, 50, 0.65, 0.8],
    'sling' => ['video', 212, 50, 0.65, 0.8],
    'final' => ['video', -10, -100, 0.42, 0.5],
    'sucks' => ['video', 220, -10, 0.6, 0.65],
     'ball' => ['video', 220, -10, 0.6, 0.65],
    'dance' => ['video', 220, -10, 0.6, 0.65],
   'veneno' => ['video', 220, -10, 0.6, 0.65],

    'marvin mode' => ['marvinMode']
];

function postCreate() {
    FlxG.mouse.visible = true;
    FlxG.sound.playMusic(Paths.music('mainmenu'), 0);
	FlxG.sound.music.fadeIn(0.5, 0, 0.8);


    

    var bg = new FlxSprite(10, 500).loadGraphic(Paths.image('menus/code/bg'));
    bg.scrollFactor.set(0.5, 0.5);
    add(bg);

    


    var vortex:FlxSprite = new FlxSprite(348, 70);
    vortex.scale.set(0.9, 0.9);
    vortex.frames = Paths.getSparrowAtlas('menus/code/vortex');
    vortex.animation.addByPrefix('idle', 'idle', 12);
    vortex.animation.play('idle');
    vortex.antialiasing = false;
	add(vortex);
    
    tb = new UITextBox(435, 220, '', 410, 44, false);
    tb.multiline = false;
	tb.label.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.BLACK);

	tb.caretSpr.color = FlxColor.BLACK;
	tb.caretSpr.scale.set(1, 30);
	tb.caretSpr.offset.set(0, -14);
    add(tb);
        
    freeplay = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/code/freeplay'));
    freeplay.frames = Paths.getSparrowAtlas('menus/code/freeplay');
    freeplay.animation.addByPrefix('idle', "idle", 24);
    freeplay.animation.addByPrefix('selected', "selected", 24);
    freeplay.animation.play('idle');
    freeplay.scale.x = 0.52;
    freeplay.scale.y = 0.52;
    freeplay.screenCenter();
    add(freeplay);

    hitbox = new FlxSprite(410, 270).makeSolid(200, 95, 0xFF0000FF);
    hitbox.alpha = 0;
    add(hitbox);

    trophy = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/code/trophies'));
    trophy.frames = Paths.getSparrowAtlas('menus/code/trophies');
    trophy.animation.addByPrefix('idle', "idle", 24);
    trophy.animation.addByPrefix('selected', "selected", 24);
    trophy.animation.play('idle');
    trophy.scale.x = 0.52;
    trophy.scale.y = 0.52;
    trophy.screenCenter();
    add(trophy);

    hitbox2 = new FlxSprite(680, 270).makeSolid(200, 95, 0xFF0000FF);
    hitbox2.alpha = 0;
    add(hitbox2);


    var computer = new FlxSprite().loadGraphic(Paths.image('menus/code/computer'));
    add(computer);

    add(shit = new FlxSprite(140, -120)).scale.set(0.55, 0.45);
    add(video = new FlxVideoSprite()).alpha = shit.alpha = 0;

    var computer2 = new FlxSprite().loadGraphic(Paths.image('menus/code/computer2'));
    add(computer2);

    light = new FlxSprite().loadGraphic(Paths.image('menus/code/light'));
    add(light);

    for (s in [bg, computer, computer2, light]) {
        s.screenCenter();
        s.scale.set(0.55, 0.55);
    }

    var spikes = new FlxSprite().loadGraphic(Paths.image('menus/code/spikes'));
    spikes.screenCenter();
    spikes.scrollFactor.set(0, 0);
    spikes.scale.x = 0.52;
    spikes.scale.y = 0.52;
    add(spikes);

    FlxTween.tween(window, {opacity: 1}, 1, {ease: FlxEase.expoOut});
}

function update() {
    FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, (FlxG.mouse.getScreenPosition(FlxG.camera).x / 60) - 20, FlxG.elapsed * 15);
    FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, (FlxG.mouse.getScreenPosition(FlxG.camera).y / 60) - 30, FlxG.elapsed * 15);

    if (FlxG.mouse.overlaps(hitbox)) {
        freeplay.animation.play('selected');
    }else{
        freeplay.animation.play('idle');
    }

    if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed) {
        FlxG.switchState(new FreeplayState());
    }

    if (FlxG.mouse.overlaps(hitbox2)) {
        trophy.animation.play('selected');
    }else{
        trophy.animation.play('idle');
    }

    if (FlxG.mouse.overlaps(hitbox2) && FlxG.mouse.pressed) {
        
    }

    if (FlxG.keys.justPressed.ESCAPE) {
        FlxTween.tween(window, {opacity: 0}, 0.5, {ease: FlxEase.expoOut});
        FlxG.sound.music.fadeOut(0.5, 0);
        
        new FlxTimer().start(1, () -> {FlxG.switchState(new ModState('custom/mainmenu'));});
    }

    if (controls.SEVEN) tb.label.text == '';

    if (controls.ACCEPT && canSelect) {
        var t = list[tb.label.text];

        if (t != null) {
            switch(t[0]) {
                case 'song':
                    PlayState.loadSong(t[1], 'hard');
                    FlxG.switchState(new PlayState());

                case 'image':
                    canSelect = tb.selectable = false;
                    shit.alpha = 1;
                    shit.loadGraphic(Paths.image('menus/code/shitpost/' + tb.label.text));
                    new FlxTimer().start(1, function(t:FlxTimer) {
                        FlxTween.tween(shit, {alpha: 0}, 2.5, {ease: FlxEase.circOut, onComplete: function(t:FlxTween) {canSelect = tb.selectable = true;}});
                    });

                case 'video':
                    canSelect = tb.selectable = false;
                    video.alpha = 1;
                    video.setPosition(t[1], t[2]);
                    video.load(Assets.getPath(Paths.video('codes/' + tb.label.text)));
                    video.scale.set(t[3], t[4]);
                    video.play();

                    video.bitmap.onEndReached.add(vidEnd);
                    FlxG.sound.music.fadeOut(0.5, 0);
                
                case 'marvinMode':
                    marvin = !marvin;

                    if (marvin) {
                        insert(1, heads = new FlxBackdrop(Paths.image('menus/code/shitpost/heads'))).scrollFactor.set(0.5, 0.5);
                        heads.screenCenter();
                        heads.velocity.x = -45; 
                    }
                    else remove(heads, true);
            }
        }
    }
}

function vidEnd() {
    FlxTween.tween(video, {alpha: 0}, 2.5, {ease: FlxEase.circOut, onComplete: () -> {
        canSelect = tb.selectable = true;
        video.bitmap.dispose();
    }});

    FlxG.sound.music.fadeIn(0.5, 0, 0.8);
    video.stop();
}