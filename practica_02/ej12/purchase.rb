require_relative 'productList.rb'

class Purchase
  def initialize
    @products = Array.new
    @listFile = Dir.getwd+'/list.csv'
  end

  def add(new)
    @products << new unless ProductList.parse(@listFile).include?(new)
  end

  def total
    @products.inject(0) { |sum,product| sum + product.price }
  end
end
