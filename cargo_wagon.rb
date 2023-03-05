# frozen_string_literal: true

require_relative 'wagon'
class CargoWagon < Wagon
  def fill_tank(volume)
    @volume = volume
    if @max_space > @current_space + @volume
      @current_space += @volume
    else
      puts 'Not enough space'
    end
  end
end
