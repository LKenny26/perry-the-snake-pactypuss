extends Area2D

class_name BodySegment

func _on_body_entered(body: Node2D):
	# ignore collisiosn with the last segment since it'll immediately colide with the player head
	# upon being placed
	if get_index() + 1 == get_parent().get_child_count():
		return

	# ensure the entering body is an instance of the PlayerHead class; might have other things colliding
	# later on like ghosts.9++58**8
	if body is PlayerHead:
		body.alive = false
		
	# checks to see if collided with doof
	if body.is_in_group("doofs"):
		body.body_collision()
		
