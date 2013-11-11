require_relative 'product.rb'
require 'csv'

class ProductList
  def self.parse(fileName)
    products = Array.new

    CSV.foreach(fileName) do |row|
      products << Product.new(row)
    end

    products
  end
end

