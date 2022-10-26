extends Node2D

export(int) var id = 0

var lockPortal = false



func doLock():
	lockPortal = true
	yield(get_tree().create_timer(0.3), "timeout")
	lockPortal = false

func _on_Teleporter_body_entered(body):
	for portal in get_tree().get_nodes_in_group("Portal"):
		print(portal.position)
		if self.name != portal.name:
			if id == portal.id:
				if !portal.lockPortal:
					doLock()
					body.position = portal.position
