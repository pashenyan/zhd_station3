# frozen_string_literal: true

require_relative 'wagon'
class PassengerWagon < Wagon
  attr_reader :seats

  def add_passenger
    if @current_space < @max_space
      @current_space += 1
    else
      puts 'not enough space'
    end
  end
end
