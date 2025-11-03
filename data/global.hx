import funkin.backend.utils.NativeAPI;
import openfl.system.Capabilities;
import flixel.system.scaleModes.RatioScaleMode;
import funkin.backend.utils.NdllUtil;
import lime.graphics.Image;
import sys.FileSystem;
import funkin.backend.system.framerate.Framerate;
import openfl.system.Capabilities;

static var initialized:Bool = false;
static var prevWallpaper = [];
static var setWallpaper = NdllUtil.getFunction("ndll-irida-wallpaper", "change_wallpaper", 1);
static var getWallpaper = NdllUtil.getFunction('ndll-irida-wallpaper', 'get_wallpaper', 0);

var modName = "Jeffy's Infinite Irida";

window.title = modName;
window.x = 320;
window.resizable = true;

static var redirectStates:Map<FlxState, String> = [
    TitleState => "custom/title",
    MainMenuState => "custom/mainmenu",
    FreeplayState => "custom/freeplay"
];

function update(elapsed:Float){
    if (FlxG.keys.justPressed.F5) FlxG.resetState();
}

function preStateSwitch(){
    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function new() {
    FlxG.mouse.useSystemCursor = false;
    FlxG.mouse.load(Paths.image("cursor"));
}

function destroy(){
    FlxG.mouse.useSystemCursor = true;
    FlxG.mouse.unload();
    window.title = "Friday Night Funkin' - Codename Engine";
}

function postStateSwitch() {
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('game/iconJEFF'))));
    Framerate.codenameBuildField.visible = false;

    if (!Std.isOfType(FlxG.state, PlayState)){
        window.title = modName;
        // Se elimina el tween que cambiaba tamaño y posición de la ventana
    } else {
        if (!FlxG.save.data.windowstuff){
            window.title = modName + ' - ' + PlayState.SONG.meta.displayName;
            // También se elimina el tween aquí
        }
    }
}