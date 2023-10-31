import conocimientos.*
import Cumbre.*

class Participante {
	const property pais
	const conocimientos = #{}
	var commits

	method commits() = commits
	method commits(cantidad){
		commits = cantidad
	}
	method esCape()
	method agregarConocimientos(unaLista){
		conocimientos.addAll(unaLista)
	}

	method cumpleConLosRequisitos() = conocimientos.contains(programacionBasica)
	method realizarActividad(unaActividad){
		conocimientos.add(unaActividad.tema())
		commits += unaActividad.tema().commitsPorHora() * unaActividad.horas()
	}
}

class Programador inherits Participante {
	var horasCapacitacion = 0

	override method esCape() = commits > 500

	override method cumpleConLosRequisitos() {
		return super() and commits > cumbre.commitsRequeridos()
	}

	override method realizarActividad(unaActividad) {
		super(unaActividad)
		horasCapacitacion += unaActividad.horas()
	}
}

class Especialista inherits Participante {

	override method esCape() = conocimientos.size() > 2

	override method cumpleConLosRequisitos() {
		return super() and commits > cumbre.commitsRequeridos() - 100 and self.tieneConocimientosEnObjetos()
	}

	method tieneConocimientosEnObjetos(){
		return conocimientos.contains(objetos)
	}
}

class Gerente inherits Participante {
	var empresa

	override method esCape() = empresa.esMultinacional()
	override method cumpleConLosRequisitos() {
		return super() and self.tieneConocimientosEnManejoDeGrupos()
	}

	method tieneConocimientosEnManejoDeGrupos(){
		return conocimientos.contains(manejoDeGrupos)
	}
}

class Empresa {
	const paises = #{}

	method esMultinacional() = paises.size() >= 3
}