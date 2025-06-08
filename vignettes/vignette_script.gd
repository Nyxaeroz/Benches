extends Control

var order : Array[String] = ["wijnhaven","metro","wittedewith","nieuwemaas","boompjes","chabot","dirk","beurs","maashaven","depot","zuidplein","centraal","leuvehoofd","museumpark","willemskade","erasmusbrug", "brienenoord"] 
var speed : Array[float]  = [5,          5,      7,            10,           12,        15,      25,     30,     20,         10,    5,         4,         3,         2,           1,             0.5,          0.1]
var words : Array[String] = ["Wijnhaven","metro","Witte de Withstraat","Nieuwe Maas","Boompjes","Chabot Museum","Dirk","Beurs","Maashaven","Depot","Zuidplein","Centraal Station","Leuvehoofd","Museumpark","Willemskade","Erasmusbrug", "Brienenoord"] 
var bench_index = -1
var text_duration = 3
var bench_duration = 15
var paused = false

@onready var grid : GridContainer = $MarginContainer/GridContainer
@onready var top_middle_panel : PanelContainer = $"MarginContainer/GridContainer/top-middle"
@onready var qte : PanelContainer = $"MarginContainer/GridContainer/bottom-middle/QTE"

func _ready() -> void:
	print("vignette: ready")
	await get_tree().create_timer(text_duration).timeout
	show_next_bench_scene()
	#for i in range(grid.get_node(order[bench_index]).coordinates.size():
		#print(i)
		#grid.get_node(order[bench_index]).place_purple_at(grid.get_node(order[bench_index]).coordinates[i].x)
		#await get_tree().create_timer(1).timeout

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		print("detected: input in main vignette")
		print("          input ui_accept")
		trigger_sit()

func trigger_sit() -> void:
	if qte.active:
		print("          stopping qte")
		stop_qte()
		qte.emit_position()
		
		print("          starting audio")
		grid.get_node(order[bench_index]).play_audio()
		
		# only proceed to next scene if we're not at the end
		await get_tree().create_timer(bench_duration).timeout
		print("          stopping audio")
		if bench_index == order.size() - 1:
			end_vignette()
			return
		grid.get_node(order[bench_index]).stop_audio()
		
		
		print("          showing next text")
		show_text()
		await get_tree().create_timer(text_duration).timeout
		
		print("          showing next bench scene")
		show_next_bench_scene()

func show_text() -> void:
	if bench_index < order.size():
		grid.get_node(order[bench_index]).visible = false
	top_middle_panel.get_node("Text").text = "[center](location: " + words[(bench_index + 1) % words.size()] + ")[/center]"
	top_middle_panel.visible = true

func show_next_bench_scene() -> void:
	print("function: show_next_bench_scene")
	top_middle_panel.visible = false
	
	if bench_index >= 0:
		grid.get_node(order[bench_index]).visible = false
	bench_index += 1
	
	#if bench_index >= order.size() - 1:
		#show_final_bench_scene() 
		#return
	
	print("          showing scene: ", order[bench_index], " (index ", bench_index,")")
	grid.get_node(order[bench_index]).visible = true
	start_qte()

# function only to use qte_move_marker_to_end
func show_final_bench_scene() -> void:
	print("function: show_final_bench_scene")
	top_middle_panel.visible = true
	#qte.move_marker_to_end()
	#await qte.marker_moved_to_end
	#print("detected: signal marker_moved_to_end")
	
	switch_to_bench_panel()
	top_middle_panel.get_node("Text").text = "[center]" + words[bench_index + 1] + "[/center]"
	
	start_qte()

func end_vignette() -> void:
	print("vignette: finished\n")
	
	await get_tree().create_timer(text_duration).timeout
	top_middle_panel.get_node("Text").text = "[center](thank you for playing)[/center]"
	switch_to_text_panel()
	
	await get_tree().create_timer(2 * text_duration).timeout
	grid.get_node(order[order.size() - 1]).stop_audio()
	await get_tree().create_timer(text_duration).timeout
	get_tree().change_scene_to_file("res://menu/menu_scene.tscn")

func start_qte() -> void:
	print("function: start_qte")
	qte.speed = speed[bench_index]
	qte.active = true
	
func stop_qte() -> void:
	print("function: stop_qte")
	qte.active = false

func switch_to_text_panel():
	grid.get_node(order[bench_index]).visible = false
	top_middle_panel.visible = true

func switch_to_bench_panel():
	grid.get_node(order[bench_index]).visible = true
	top_middle_panel.visible = false	

func _on_qte_finished(pos: Variant) -> void:
	print("detected: signal qte_finished")
	print("          position: ", pos)
	stop_qte()
	grid.get_node(order[bench_index]).place_purple_at(pos)

# not used in current build
func _on_button_sit_pressed() -> void:
	print("detected: button sit pressed")
	trigger_sit()

# not used in current build
func _on_button_pause_pressed() -> void:
	print("detected: button pause pressed")
	if paused:
		print("          unpausing")
		switch_to_bench_panel()
		start_qte()
	elif top_middle_panel.visible:
		print("          supressing pause while in transition")
		# suppress pausing if game is transitioning to next bench scene
		return
	else:
		print("          pausing")
		stop_qte()
		top_middle_panel.get_node("Text").text = "[center](the game is now paused)[/center]"
		switch_to_text_panel()
	paused = not paused

func _on_button_mute_pressed() -> void:
	print("detected: button mute pressed")
	print("          muting all audio")
	$"MarginContainer/GridContainer/bottom-left/Button-Mute".visible = false
	$"MarginContainer/GridContainer/bottom-left/Button-Unmute".visible = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func _on_button_unmute_pressed() -> void:
	print("detected: button unmute pressed")
	print("          unmuting all audio")
	$"MarginContainer/GridContainer/bottom-left/Button-Unmute".visible = false
	$"MarginContainer/GridContainer/bottom-left/Button-Mute".visible = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
