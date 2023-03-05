# frozen_string_literal: true

class PassengerTrain < Train
  validate :speed, :type, Integer
  validate :number, :format, NUMBER_FORMAT
end
