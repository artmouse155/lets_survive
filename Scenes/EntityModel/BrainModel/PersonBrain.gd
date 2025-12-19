class_name PersonBrain extends Brain

signal movement_vector(direction : Vector2)
signal look_direction(angle_rad : float)

signal attack()
signal go_idle()
# TODO: Server side should make sure selection is within hotbar
signal select(index: int)
signal select_next()
signal select_prev()

signal drop_all_selected_item()
signal drop_selected_item()
