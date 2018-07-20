extends Node

const radio = 50
const posinicialx = (2 * radio) + 20 #Un tercio de la pantalla en largo
const posinicialy = 720 - radio - 20 #Mitad de la pantalla en altura
const centrox = posinicialx + radio
const centroy = posinicialy
const v_angulo_ini = 0.0025
const g = 0.004
const tacho_x_min = 1135
const tacho_x_max = 1227
const tacho_y = 590

var angulo = 0 
var v_angulo = v_angulo_ini
var vx
var vy
var estado = "qieta"

func _ready():
	$Bola.position.x = posinicialx #Pongo la pelota donde dije antes
	$Bola.position.y = posinicialy
	$Label.hide()
	angulo = 0
	v_angulo = v_angulo_ini

func giro():
	v_angulo += 0.000075
	angulo -= v_angulo
	$Bola.position.x = centrox - (cos(angulo) * radio)
	$Bola.position.y = centroy - (sin(angulo) * radio)

func disparo():
	vy += g #La gravedad la hace caer
	$Bola.position.x += vx #Le voy sumando la velocidad a la qe iba (sumar la velocidad es integrar la posicion)
	$Bola.position.y += vy

func _process(delta):
	var xant = $Bola.position.x
	var yant = $Bola.position.y

	if estado == "qieta" and Input.is_action_pressed("ui_accept"):
		estado = "girando"
	if estado == "girando" and Input.is_action_just_released("ui_accept"):
		estado = "disparo"

	if estado == "girando":
		giro()
		vx = $Bola.position.x - xant
		vy = $Bola.position.y - yant

	if estado == "disparo":
		disparo()
		if tacho_x_min < $Bola.position.x and $Bola.position.x < tacho_x_max and abs($Bola.position.y - tacho_y) < 10:
			$Label.show()
			$Bola.hide()
			estado = "cayo"

	if $Bola.position.y >= 720:
		estado = "cayo"

	if (estado == "cayo" or estado == "disparo") and Input.is_action_just_pressed("ui_cancel"):
		estado = "qieta"
		_ready()