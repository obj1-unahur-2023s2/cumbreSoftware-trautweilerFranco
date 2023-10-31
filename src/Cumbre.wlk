import Participantes.*

class Pais {
	const paisesConficto = #{}

	method registrarConflicto(unPais){
		paisesConficto.add(unPais)
	}
	method esConflictivoParaLaCumbre() = paisesConficto.any({p=>p.esPaisAuspicianteDeLaCumbre()})
	method esPaisAuspicianteDeLaCumbre() = cumbre.esPaisAuspiciante(self)
}

object cumbre {
	const paisesAuspiciantes = #{}
	const participantes = #{}
	var commitsRequeridos = 300
	const actividadesRealizadas = #{}

	method agregarActividad(unaActividad) {
		actividadesRealizadas.add(unaActividad)
	}

	method commitsRequeridos() = commitsRequeridos
	method setCommitsRequeridos(unValor){
		commitsRequeridos = unValor
	}

	method agregarAuspiciantes(paises) {
		paisesAuspiciantes.addAll(paises)
	}

	method registrarParticipante(unParticipante){
		if (not self.puedeIngresarALaCumbre(unParticipante)) {
			self.error("El participante no puede ingresar!")
		}
		participantes.add(unParticipante)	
	}

	method estaRegistrado(unParticipante) = participantes.contains(unParticipante)
	method esPaisAuspiciante(unPais) = paisesAuspiciantes.contains(unPais)

	method paisesDeLosParticipantes() {
		return participantes.map({p=>p.pais()}).asSet()
	}

	method cantidadDeParticipantesDePais(unPais) {
		return participantes.count({p=>p.pais() == unPais})
	}

	method paisConMasParticipantes(){
		return self.paisesDeLosParticipantes().max({p=>self.cantidadDeParticipantesDePais(p)})
	}

	method participantesExtranjeros(){
		return participantes.filter({p=>self.esExtranjero(p.pais())})
	}	
	method esExtranjero(unPais){
		return not paisesAuspiciantes.contains(unPais)
	}

	method esRelevante() = participantes.all({p=>p.esCape()})

	method puedeIngresarALaCumbre(unParticipante) {
		return unParticipante.cumpleConLosRequisitos() and not self.tieneRestringidoElAcceso(unParticipante) 
	}

	method tieneRestringidoElAcceso(unParticipante) {
		return self.esParticipanteDePaisConflictivo(unParticipante) or (self.esExtranjero(unParticipante.pais()) and self.participantesExtranjeros().size() >= 2)  
	}

	method esParticipanteDePaisConflictivo(unParticipante) {
		return unParticipante.pais().esConflictivoParaLaCumbre()
	}

	method esSegura() = participantes.all({p=>self.puedeIngresarALaCumbre(p)})

	method registrarActividad(unaActividad) {
		self.agregarActividad(unaActividad)
		participantes.forEach({p=>p.realizarActividad(unaActividad)})
	}

	method horasRealizadas() {
		return actividadesRealizadas.sum({a=>a.horas()})
	}
}
