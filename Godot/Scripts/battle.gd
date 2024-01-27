extends Control

# Custom Signal: lesson 3.Combat Functions
signal textboxClosed

@export var enemy : Resource = null

var currentEnemyHealth = 0
var currentPlayerHealth = 0

var isDefending = false

func _ready():
	setHealth(enemy.health, enemy.health, $VBoxContainer/HealthBar)
	setHealth(PlayerState.health, PlayerState.maxHealth, $PlayerPanel/HBoxContainer/HealthBar)
	
	currentEnemyHealth = enemy.health
	currentPlayerHealth = PlayerState.health
	
	# hide the "console" textbox
	$TextBox.hide()
	# hide actions
	$PlayerPanel/PlayerActions.hide()
	
	displayText("A wild " + enemy.name + " appears!")
	# waiting for the signals of textbox closed
	await self.textboxClosed
	$PlayerPanel/PlayerActions.show()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textboxClosed")
		

func setHealth(health, maxHealth, healthBar):
	healthBar.value = health
	healthBar.max_value = maxHealth
	healthBar.get_node("Label").text = "HP: " + str(health) + " / " + str(maxHealth)

func displayText(text):
	
	#unhide the textbox
	$TextBox.show()
	$TextBox/Text.text = text


func enemyTurn():
	$PlayerPanel/PlayerActions.hide()
	displayText(enemy.name + " attacked you!")
	await self.textboxClosed
	
	if isDefending:
		isDefending = false
		var chance = randi_range(0, 1)
		if (chance == 0):
			displayText("You defended " + enemy.name + "'s attack!")
		else:
			$AnimationPlayer.play("PlayerDamaged")
			currentPlayerHealth = max(0, currentPlayerHealth - (enemy.damage / 2)) # half damage if unsuccessfully defended
			setHealth(currentPlayerHealth, PlayerState.maxHealth, $PlayerPanel/HBoxContainer/HealthBar)
			displayText("Partial defence, " + enemy.name + " dealt " + str(enemy.damage / 2) + " damage!")
		await self.textboxClosed
			
	else:
		$AnimationPlayer.play("PlayerDamaged")
		currentPlayerHealth = max(0, currentPlayerHealth - enemy.damage) # full damage
		setHealth(currentPlayerHealth, PlayerState.maxHealth, $PlayerPanel/HBoxContainer/HealthBar)
		displayText(enemy.name + " dealt " + str(enemy.damage) + " damage!")
		await self.textboxClosed
	
	# is the player still alive?
	if currentPlayerHealth > 0:
		$PlayerPanel/PlayerActions.show()
	else:
		PlayerDeath()
	

func _on_run_pressed():
	print ("Trying to run away!")
	
	# hide other buttons
	$PlayerPanel/PlayerActions.hide()
	
	var chance = randi_range(0, 1)
	if chance == 0:
		displayText("You couldn't run away!")
		await self.textboxClosed
		$PlayerPanel/PlayerActions.show()
		return #exit the function, back to the battle field!
	else:
		displayText("You ran away safely!")
		await self.textboxClosed
	
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	

func _on_attack_pressed():
	print ("Attack!")
	
	# hide other buttons
	$PlayerPanel/PlayerActions.hide()
	displayText("You chose to attack!")
	await self.textboxClosed
	$AnimationPlayer.play("EnemyDamaged") # Damaged anim effect
	currentEnemyHealth = max(0, currentEnemyHealth - PlayerState.damage) #sceglie il valore più alto
	setHealth(currentEnemyHealth, enemy.health, $VBoxContainer/HealthBar)
	displayText("you dealth " + str(PlayerState.damage) + " damage!")
	await self.textboxClosed
	
	if currentEnemyHealth > 0:
		enemyTurn()
	else:
		EnemyDeath()


func _on_defend_pressed():
	print ("Defend...")
	
	# hide other buttons
	$PlayerPanel/PlayerActions.hide()
	displayText("You chose to defend!")
	await self.textboxClosed
	
	isDefending = true
	await get_tree().create_timer(1.0).timeout # a bit of suspence
	
	enemyTurn()


func EnemyDeath():
	displayText(enemy.name + " has been defeated!")
	await self.textboxClosed
	$AnimationPlayer.play("EnemyDeath")
	await $AnimationPlayer.animation_finished
	
	# gain XP and maybe level up
	PlayerState.xp += randi_range(enemy.minXP, enemy.maxXP)
	if PlayerState.xp >= PlayerState.xpNeeded:
		PlayerState.level += 1
		PlayerState.xp = PlayerState.xp - PlayerState.xpNeeded
		PlayerState.getRequiredXP(PlayerState.level + 1)
		PlayerState.upgradeStats()
	
	# update global variable for player health
	PlayerState.health = currentPlayerHealth
	
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func PlayerDeath():
	displayText("You have been defeated!")
	await self.textboxClosed
	PlayerState.health = PlayerState.maxHealth
	PlayerState.lastPosition = PlayerState.resetPosition
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
