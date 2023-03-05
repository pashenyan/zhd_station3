# frozen_string_literal: true

require_relative 'validation'
class Wagon
  attr_reader :number, :type
  include Validation
  
  def initialize(number, max_space)
    @number = number
    @max_space = max_space
    @current_space = 0
  end

  def show_current_space
    puts @current_space
  end

  def show_free
    @free_space = @max_space - @current_space
    puts @free_space
  end
end
