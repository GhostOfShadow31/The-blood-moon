extends Node2D

@onready var recoverypoints: Node2D = $RecoveryPoints
@onready var spawnpoints: Node2D = $SpawnPoints
@onready var death_positions: Node2D = $DeathPositions
@onready var spike_layer: TileMapLayer = $Map/Frontground_spike
@onready var canva_modulate: CanvasModulate = $CanvasModulate

const CANVAS_MODULATE_SHADE: Dictionary[String, Color] = {
	"default": Color("3f3654"),
	"death": Color("303832")
}

const CAMERA_BOUNDS: Rect2 = Rect2(
	Vector2.ZERO,
	Vector2(2000, 1712)
)

const rooms: Array[Dictionary] = [
	{
		"id": 1,
		"bounds": Rect2(Vector2(832.0, 1456.0), Vector2(432.0, 192.0)),
		"focus": Vector2(1048.0, 1552.0)
	},
	{
		"id": 2,
		"bounds": Rect2(Vector2(496.0, 1168.0), Vector2(336.0, 240.0)),
		"focus": Vector2(664.0, 1288.0)
	},
	{
		"id": 3,
		"bounds": Rect2(Vector2(208.0, 1264.0), Vector2(192.0, 144.0)),
		"focus": Vector2(304.0, 1336.0)
	},
	{
		"id": 4,
		"bounds": Rect2(Vector2(928.0, 1072.0), Vector2(384.0, 240.0)),
		"focus": Vector2(1120.0, 1192.0)
	},
	{
		"id": 5,
		"bounds": Rect2(Vector2(1024.0, 784.0), Vector2(480.0, 192.0)),
		"focus": Vector2(1264.0, 880.0)
	},
	{
		"id": 6,
		"bounds": Rect2(Vector2(784.0, 496.0), Vector2(192.0, 384.0)),
		"focus": Vector2(880.0, 688.0)
	},
	{
		"id": 7,
		"bounds": Rect2(Vector2(736.0, 16.0), Vector2(768.0, 336.0)),
		"focus": Vector2(1120.0, 184.0)
	},
	{
		"id": 8,
		"bounds": Rect2(Vector2(1408.0, 1408.0), Vector2(240.0, 240.0)),
		"focus": Vector2(1528.0, 1528.0)
	},
	{
		"id": 9,
		"bounds": Rect2(Vector2(1744.0, 1504.0), Vector2(144.0, 144.0)),
		"focus": Vector2(1816.0, 1576.0)
	},
	{
		"id": 10,
		"bounds": Rect2(Vector2(1600.0, 1072.0), Vector2(288.0, 144.0)),
		"focus": Vector2(1744.0, 1144.0)
	},
	{
		"id": 11,
		"bounds": Rect2(Vector2(1840.0, 640.0), Vector2(144.0, 288.0)),
		"focus": Vector2(1912.0, 784.0)
	},
	{
		"id": 12,
		"bounds": Rect2(Vector2(1264.0, 448.0), Vector2(432.0, 288.0)),
		"focus": Vector2(1480.0, 592.0)
	},
	{
		"id": 13,
		"bounds": Rect2(Vector2(352.0, 736.0), Vector2(240.0, 240.0)),
		"focus": Vector2(472.0, 856.0)
	},
	{
		"id": 14,
		"bounds": Rect2(Vector2(688.0, 928.0), Vector2(144.0, 192.0)),
		"focus": Vector2(760.0, 1024.0)
	},
	{
		"id": 15,
		"bounds": Rect2(Vector2(160.0, 352.0), Vector2(480.0, 288.0)),
		"focus": Vector2(400.0, 496.0)
	},
]

func is_spike(from_position: Vector2) -> bool:
	var local_position: Vector2 = spike_layer.to_local(from_position)
	var cell: Vector2 = spike_layer.local_to_map(local_position)
	
	return spike_layer.get_cell_source_id(cell) != -1
