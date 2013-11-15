class Fibb
  include Comparable

  attr :value, :oldValue

  def initialize(n = 0, old = 1, new = 1)
    case n
    when 0
      @oldValue = old
      @value = new
    when 1
      @oldValue = 0
      @value = 1
    when 2
      @oldValue = 1
      @value = 1
    else
      a = Fibb.new 1

      (n - 1).times do
        a = a.succ
      end

      @oldValue = a.oldValue
      @value = a.value
    end
  end

  def succ
    Fibb.new(0, @value, @oldValue+@value)
  end

  def <=>(other)
    @value <=> other.value
  end
end
