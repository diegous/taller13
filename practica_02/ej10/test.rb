require_relative 'contacto.rb'
require_relative 'agenda.rb'
require 'test/unit'

class TestAgenda < MiniTest::Unit::TestCase
  def test_new
    File.new "csv", 'w'
    assert_equal('', Agenda.viewAll)
  end

  def test_add_one_contact
    File.new "csv", 'w'
    contact = Contacto.new 'n', 'fn', 'e', 'tel', 'dir' 
    Agenda.add contact
    assert_equal(contact, Agenda.viewAll.first)
  end

  def test_add_one_contact_in_csv
    file = File.new "csv", 'w'
    contact = Contacto.new 'n', 'fn', 'e', 'tel', 'dir' 
    Agenda.add contact
    assert_equal(file.readline, '"n", "fn", "e", "tel", "dir"')
  end
 

end
    
