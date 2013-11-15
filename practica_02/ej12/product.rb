class Product
  attr :id, :title, :price

  def initialize(arr)
    @id = arr[0]
    @title = arr[1]
    @price = arr[2]
  end

  def ==(other)
    @id == other.id
  end
end
