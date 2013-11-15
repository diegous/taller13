class Jugador
  attr_reader :nombre

  def initialize(nombre, jugadas)
    @nombre = nombre
    @jugadas = jugadas
  end

  def jugada(nro_turno)
    @jugadas[nro_turno-1]
  end

end

