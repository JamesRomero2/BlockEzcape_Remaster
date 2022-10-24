extends CanvasLayer


func _changeScene(target: String):
	$AnimationPlayer.play("DissolveAnim")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards("DissolveAnim")

#func _pixelatedTransition(target: String):
#	var img = get_viewport().get_texture().get_data()
#	img.resize(1280, 720)
#	print(get_viewport().get_texture().get_size())
#	img.flip_y()
#	var ss = ImageTexture.new()
#	ss.create_from_image(img)
#	$Pixel.texture = ss
#	$Pixel.visible = true
#	$AnimationPlayer.play_backwards("PixelatedAnim")
#	yield($AnimationPlayer, "animation_finished")
#	get_tree().change_scene(target)
#	$AnimationPlayer.play("PixelatedAnim")
#	$Pixel.visible = false
