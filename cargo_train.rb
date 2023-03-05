# frozen_string_literal: true
require_relative 'validation.rb'

class CargoTrain < Train
  validate :speed, :type, Integer
  validate :number, :format, NUMBER_FORMAT
end
