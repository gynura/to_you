extends Camera2D

# We need to know the size of our tilemap to stop the camera to go out of bounds. 
# It is exported so it can change dynamically when instantiating the scene. 
@export var tileMap: TileMap 
# Called when the node enters the scene tree for the first time.
func _ready():
	var mapRect = tileMap.get_used_rect() 
	var tileSize = tileMap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize 
	limit_right = worldSizeInPixels.x 
	limit_bottom = worldSizeInPixels.y 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
