extends AudioStreamPlayer

enum songs {MENU, DUNGEON, BOSS, WIN}
export(songs) var default_song
export(bool) var play_on_start = true

onready var song_resources = {
	songs.MENU: load("res://assets/music/menu.wav"),
	songs.DUNGEON: load("res://assets/music/dungeon.wav"),
	songs.BOSS: load("res://assets/music/boss.wav"),
	songs.WIN: load("res://assets/music/win.wav")
}

func play_song(song):
	stream = song_resources[song]
	play()

func _ready():
	if play_on_start:
		play_song(default_song)

func _process(delta):
	volume_db = GlobalVariables.music_volume - 80
