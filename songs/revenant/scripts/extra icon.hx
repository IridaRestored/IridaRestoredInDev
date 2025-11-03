var isPlayer:Bool = true;
var iconP3:HealthIcon;
var iconP4:HealthIcon;

function postCreate(){    
    iconP3 = new HealthIcon(gf != null && gf.icon!=null?gf.icon:gf.curCharacter, isPlayer);
    iconP3.cameras = [camHUD];
    add(iconP3);

    iconP3.setPosition(iconP1.x-20, iconP2.y - (!downscroll ? 35 : -15));
    iconP3.scale.set(0.8, 0.8);

    iconP4 = new HealthIcon(strumLines.members[3].characters[0] != null && strumLines.members[3].characters[0].icon!=null?strumLines.members[3].characters[0].icon:strumLines.members[3].characters[0].curCharacter, isPlayer);
    iconP4.cameras = [camHUD];
    add(iconP4);

    iconP4.setPosition(iconP1.x-20, iconP2.y - (!downscroll ? 35 : -15));
    iconP4.scale.set(0.8, 0.8);
}

function update(elapsed:Float){
    iconP3.flipX = true;
    iconP3.health = isPlayer? iconP1.health : iconP2.health;
    iconP3.x = iconP1.x - 70;

    iconP4.flipX = true;
    iconP4.health = isPlayer? iconP1.health : iconP2.health;
    iconP4.x = iconP1.x - 70;
    iconP4.y = iconP1.y + 30;
}

function beatHit(){
    for (i in [iconP3, iconP4]){
        i.scale.set(1, 1);
        FlxTween.tween(i.scale, {x: 0.8, y: 0.8}, (0.5 * (1 / (Conductor.bpm / 60))), {ease: FlxEase.circOut});
    }
}