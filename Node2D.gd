xtends Node2D

var screen_size
const X0 = 100.0 #Donde empieza
const Y0 = 300.0 #Donde empieza
const PorDondeVuelve = 1 #-1 para qe vuelva por abajo

const hmax = 300.0 #Parametros parabola
const xhmax = 500.0
const xcayo = 1000.0
const Radio = 300.0

var dx = 1 #Para qe lado avanza
var xant
var yant

func aparabola(hmax, xhmax, xcayo):
	var r = hmax/(xhmax*xhmax - xhmax * xcayo)
	return(r)

func bparabola(aparabola, xcayo):
	return(-aparabola * xcayo)

func _ready():
  #  pad_size = get_node("left").get_texture().get_size()
	print(screen_size)
	position.x = X0
	position.y = Y0
	get_node("../Flecha").hide()

func distancia():
	var xc = X0 + (2 * Radio - X0)/2.0
	var d = pow(pow(position.x - xc, 2.0) + pow(position.y - Y0, 2.0), 0.5)
	return d

func _process_parabola():
# En general le sumo uno a x, le sumo f'(x) a y
# Para una linea:
# y = f(x) = mx+b => f'(x) = m
# Para una parabola:
# y = f(x) = ax^2 + bx + c => f'(x) = 2ax + b
# Para calcular a y b, despejamos b en funcion de a. Y despues despejamos a "a" sabiendo valores qe qeriamos qe de
# (El punto maximo y los ceros)
	var a = aparabola(hmax, xhmax, xcayo) #OJO, qe si no tienen decimales, redondea
	var b = bparabola(a, xcayo)
	#print(position.x)
	position.x += dx
	if dx == 1: #Voy de izqierda a derecha
		if position.x <= xcayo:
			position.y -= (2 * a * position.x) + b
		else:
			dx = -1 #Llege al final, empiezo a volver
	if dx == -1: #Voy de derecha a izqierda
		if position.x > X0:
			position.y += PorDondeVuelve * ((2 * a * position.x) + b)
		else:
			dx = 1 #Volvi al inicio

func _process_circulo():
	var xc = X0 + ((2.0 * Radio + X0) - X0)/2.0
	position.x += dx * 0.5
	if dx > 0:
		if position.x <= (X0 + (2.0 * Radio)):
			position.y = Y0 + sqrt(pow(Radio, 2.0) - pow(position.x - xc, 2.0))
		else:
			dx = -1
	if dx < 0:
		if position.x >= X0:
			position.y = Y0 - sqrt(pow(Radio, 2.0) - pow(position.x - xc, 2.0))
		else:
			dx = 1

func disparo():
	pass

func _process(delta):
	xant = position.x
	yant = position.y #A: Me guarde para derivar numericamente

	if Input.is_action_pressed("ui_accept"):
		# _process_parabola()
		_process_circulo()
		$Label.text = str(distancia())
		#A: _process_circulo cambio la posicion y calculo la derivada
		var dx = position.x - xant
		var dy = position.y - yant
		var yp = dy / dx
	
		var flecha = get_node("../Flecha")
		flecha.show()
		flecha.position.x = position.x
		flecha.position.y = position.y
		var hip = sqrt(pow(dy, 2) + pow(dx, 2))
		var rot = atan2(dy, dx)
		flecha.rotation = rot
		flecha.scale = Vector2(hip, 1)

	if Input.is_action_just_released("ui_accept"):
		disparo()