@tool
extends Node3D

func _ready() -> void:
	var mesh = $Sponza.mesh
	for index in mesh.get_surface_count():
		var material: Material = mesh.surface_get_material(index)
		material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		material.metallic = 0
		material.roughness = 1
