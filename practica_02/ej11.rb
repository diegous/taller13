class Float
  CONST_DE_CONV = 3.2808

  def aPies
    self * CONST_DE_CONV
  end

  def aMetros
    self / CONST_DE_CONV
  end
end


if ARGV.size == 2
  tipo, numero = ARGV

  puts numero.to_f.aMetros.to_s if tipo == "pies"
  puts numero.to_f.aPies.to_s   if tipo == "metros"
else
  "Parametros insuficientes"
end
