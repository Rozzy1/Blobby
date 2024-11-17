@tool
extends StaticBody2D



func _ready() -> void:
	# It's easier to create a CollisionPolygon2D hitbox on the fly that matches the Polygon2D's points.
	# When the game starts, this code will run and add a CollisionPolygon2D child to the land.
	if not Engine.is_editor_hint():
		var coll := CollisionPolygon2D.new()
		coll.polygon = $Polygon2D.polygon # Copies the polygon points
		add_child(coll)

