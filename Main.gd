extends Node2D

const THREADS_NR : int = 10
var threads_finished_count : int = 0
var threads : Array = []

const MAP_SIZE : Vector2 = Vector2(1000.0, 1000.0)
var y_counter : int = 0
var map : Array = []

func _ready() -> void:
	for i in range (THREADS_NR):
		threads.append(Thread.new())
		_map_gen_y(i)

func _map_gen_y(thread_i : int) -> void:
	var thread_data : PoolIntArray = [] as PoolIntArray
	thread_data.append(thread_i)
	thread_data.append(y_counter)
	threads[thread_i].start(self, "_map_gen_x", thread_data)
	y_counter += 1

func _map_gen_x(thread_data : PoolIntArray) -> PoolIntArray:
	var map_x : PoolIntArray = [] as PoolIntArray
	map_x.resize(MAP_SIZE.x)
	var y : int = thread_data[1]
	for x in int(MAP_SIZE.x):
			###### ADD HERE YOUR MAP GEN LOGIC ######
			map_x[x] = 0
			###### ADD HERE YOUR MAP GEN LOGIC ######
	call_deferred("_map_gen_thread_finished", thread_data)
	return(map_x)

func _map_gen_thread_finished(thread_data : Array) -> void:
	map.append(threads[thread_data[0]].wait_to_finish())
	threads_finished_count += 1
	if y_counter < MAP_SIZE.y:
		threads_finished_count -= 1
		_map_gen_y(thread_data[0])
	elif threads_finished_count >= THREADS_NR:
		_next_step_XYZ()

func _next_step_XYZ() -> void:
	###### ADD HERE WHATEVER WILL FOLLOW THE INITIAL MAP-GEN ######
	print("done")

func _exit_tree() -> void:
	for i in range (THREADS_NR):
		if threads[i].is_active():
			threads[i].wait_to_finish()
