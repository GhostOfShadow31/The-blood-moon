class_name Item
extends Resource

# Caractéristiques générales
const CATEGORY_CONSUMABLES: String = "consumables"
const CATEGORY_COLLECTIBLES: String = "collectibles"
const CATEGORY_QUESTS: String = "quests"
const CATEGORY_BESTIARY: String = "bestiary"
const CATEGORY_ABILITIES: String = "abilities"

@export var id: String
@export var item_name: String
@export_multiline var description: String
@export_multiline var lore: String
@export var icon: AtlasTexture

@export_enum("consumables", "collectibles", "quests", "bestiary", "abilities")
var category: String

@export var stakable: bool = false
@export var max_stack: int = 1
@export var persistent: bool = false

# Consumables
@export var effects: Array[ItemEffect] = []

# Collectibles & Bestiary
@export var silhouette: AtlasTexture = null
@export var journal_slot: int = -1
