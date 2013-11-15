require_relative 'contacto.rb'

if ARGV.length < 2
  puts "Not enough parameters"
else
  fileName = ARGV[0]

  case ARGV[1]
  when 'add'
    if ARGV.length < 3
      puts "Missing parameter for ADD"
    else
      c = Contacto.new ARGV[3]
    end
  else
    puts "Not a valid parameter"
  end
end

