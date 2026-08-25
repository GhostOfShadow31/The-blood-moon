class_name Quest
extends Resource

enum State {
	TRACKED,
	COMPLETED,
	IN_PROGRESS
}

@export var id: String
@export var title: String
@export_multiline var description: String

@export var clues: Array[QuestClue] = []
