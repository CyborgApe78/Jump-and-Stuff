extends Resource
class_name  Inventory


var keys: int = 0:
	set(v):
		keys = v
		EventBus.checkKeys.emit()


func can_use_keys(amount: int) -> bool:
	if amount <= keys:
		keys -= amount
		return true
	
	return false
