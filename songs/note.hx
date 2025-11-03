// --- Script unificado de control de notas y strums ---
// Compatible con Codename Engine (HScript)

function postCreate() {
    var songName = PlayState.SONG.meta.name;

    if (songName == 'the corpse is mocking me') {
        // Forzar cambio de sprites para todas las notas ya cargadas
        for (note in PlayState.notes) {
            if (note.mustPress) { // Jugador
                note.noteSprite = Paths.image('game/notes/TCIMM_NOTE_assets');
                note.mustPress = true;
            } else { // Oponente
                note.noteSprite = Paths.image('game/notes/johnnotes');
                note.mustPress = false; // No afectan al jugador
            }
        }
    }
}

function onNoteCreation(event:NoteCreationEvent) {
    var songName = PlayState.SONG.meta.name;

    // Cordyceps → todos usan las notas de Cordyceps
    if (songName == 'cordyceps') {
        event.noteSprite = 'game/notes/CordycepsNOTE_assets';
        return;
    }

    // The corpse is mocking me → Jugador y oponente diferentes
    if (songName == 'the corpse is mocking me') {
        if (event.mustPress || event.player == 1) { // Jugador
            event.noteSprite = 'game/notes/TCIMM_NOTE_assets';
            event.mustPress = true;
        } else { // Oponente
            event.noteSprite = 'game/notes/johnnotes';
            event.mustPress = false;
        }
        return;
    }

    // Todas las demás canciones
    event.noteSprite = 'game/notes/sml';
}

function onStrumCreation(event:StrumCreationEvent) {
    var songName = PlayState.SONG.meta.name;

    if (songName == 'cordyceps') {
        event.sprite = 'game/notes/CordycepsNOTE_assets';
        return;
    }

    if (songName == 'the corpse is mocking me') {
        if (event.player == 1) { // Jugador
            event.sprite = 'game/notes/TCIMM_NOTE_assets';
        } else { // Oponente
            event.sprite = 'game/notes/johnnotes';
        }
        return;
    }

    event.sprite = 'game/notes/sml';
}
