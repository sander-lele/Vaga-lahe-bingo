extends Node

var rng = RandomNumberGenerator.new()

var Songs : Array[AudioStreamMP3] = [load("res://music/Cumbia.mp3"),load("res://music/Dawnofchange.mp3"),
load("res://music/Hope.mp3"),load("res://music/Light.mp3"),load("res://music/Marcy.mp3"),
load("res://music/punkar_).mp3"),load("res://music/Soulstice.mp3"),load("res://music/Crazy Bus Title Screen.mp3")]
var SongWeights : Array[float] = [1.0, 1.0, 1.0, 1.0, 1.0, 0.1, 1.0,0.1]
var CurrentlyPlaying = null

func _ready() -> void:
	select_song()

func select_song():
	var SongArray : Array[AudioStreamMP3] = Songs
	if CurrentlyPlaying == null:
		CurrentlyPlaying = SongArray[rng.rand_weighted(SongWeights)]
	else:
		SongArray.erase(CurrentlyPlaying)
	$Music.stream = SongArray[rng.rand_weighted(SongWeights)]
	$Music.play()


func _on_music_finished() -> void:
	select_song()
