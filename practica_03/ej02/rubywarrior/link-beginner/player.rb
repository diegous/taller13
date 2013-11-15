class Player
  def play_turn(warrior)
    # add your code here
    @health ||= 20
    @paredAtras ||= false
    @meCure ||= false

    if warrior.feel(:backward).captive?
      warrior.rescue!(:backward)
    elsif warrior.feel.enemy?
      warrior.attack!
    else
      if warrior.health < 20
        if warrior.health >= @health
          warrior.rest!
          @meCure = true
        else 
          if @meCure
            warrior.walk!
          else
            warrior.walk!(:backward)
          end
        end
      else
        @paredAtras = warrior.feel(:backward).wall? || @paredAtras 
        if @paredAtras 
          warrior.walk!
        else
          warrior.walk!(:backward)
        end
          
      end
    end

    @health = warrior.health

  end
end
