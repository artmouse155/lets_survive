extends Node

const BASE_MUSIC_VOLUME = 0.15

@onready var music: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(music)

func play_song(song: AudioStream) -> void:
	assert(is_node_ready())
	music.volume_linear = BASE_MUSIC_VOLUME
	music.stream = song
	music.play()
