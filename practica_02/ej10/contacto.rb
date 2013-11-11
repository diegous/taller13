class Contacto
  include Comparable
  attr :nombre, :fecha_nacimiento, :email, :telefono, :direccion

  def initialize(nombre, fecha_nacimiento, email, telefono, direccion)
    @nombre = nombre
    @fecha_nacimiento = fecha_nacimiento
    @email = email
    @telefono = telefono
    @direccion = direccion
  end

  def == (other)
    (@nombre            == other.nombre)            &
    (@fecha_nacimiento  == other.fecha_nacimiento)  & 
    (@email             == other.email)             & 
    (@telefono          == other.telefono)          & 
    (@direccion         == other.direccion)
  end

  def toString
    @nombre           +", "+
    @fecha_nacimiento +", "+
    @email            +", "+
    @telefono         +", "+
    @direccion
  end
end

