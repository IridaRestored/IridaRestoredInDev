function stepHit(curStep:Int){
    switch(curStep){
        case 130: 
            for(i in 0...4) {
            FlxTween.tween(strumLines.members[0].members[i] , {alpha: 0}, 0.15, {ease: FlxEase.expoOut});
            FlxTween.tween(strumLines.members[1].members[i] , {alpha: 0}, 0.15, {ease: FlxEase.expoOut});
            }
            case 262: 
                for(i in 0...4) {
                FlxTween.tween(strumLines.members[1].members[i] , {alpha: 1}, 4, {ease: FlxEase.expoOut});
                FlxTween.tween(strumLines.members[1].members[i] , {y: 50}, 1, {ease: FlxEase.expoOut});
                }
        case 512:
            for(i in 0...4) {
                FlxTween.tween(strumLines.members[0].members[i] , {alpha: 1}, 4, {ease: FlxEase.expoOut});
                FlxTween.tween(strumLines.members[0].members[i] , {y: 50}, 1, {ease: FlxEase.expoOut});
                }
            
            
            case 1810:
                for(i in 0...4) {
                    FlxTween.tween(strumLines.members[0].members[i] , {alpha: 0}, 4, {ease: FlxEase.expoOut});
                    FlxTween.tween(strumLines.members[1].members[i] , {alpha: 0}, 4, {ease: FlxEase.expoOut});
                    }
                    case 1840:
                        for(i in 0...4) {
                            strumLines.members[0].visible = false;
                        strumLines.members[1].visible = false;
                            }
                case 1990:
                    for(i in 0...4) {
                        strumLines.members[0].members[i].x = strumLines.members[0].members[i].x + 641;
                        strumLines.members[1].members[i].x = strumLines.members[1].members[i].x - 641;
                        FlxTween.tween(strumLines.members[0].members[i] , {alpha: 1}, 6, {ease: FlxEase.expoOut});
                        FlxTween.tween(strumLines.members[1].members[i] , {alpha: 1}, 6, {ease: FlxEase.expoOut});
                        strumLines.members[0].visible = true;
                        strumLines.members[1].visible = true;
                        }
                    
                    
        }
    }