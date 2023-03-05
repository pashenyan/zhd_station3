# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'company'
require_relative 'validation'
NUMBER_FORMAT = /^\w{3}-?\w{2}$/i.freeze
class Train
  include Company
  include InstanceCounter
  include Validation
  
  attr_accessor :speed
  attr_reader :route, :number, :type

  @@trains = []

  def initialize(number, type)
    @wagons = []
    @speed = 0
    @number = number
    @current_station_index = 0
    @type = type
    validate!
    @@trains << self
  end

  def self.trains
    @@trains
  end

  def self.all
    puts @@trains
  end

  def self.find(num)
    result = @@trains.find { |train| train.number == num }
    puts result
    return unless result.nil?

    puts 'Wrong number or train doesnt exist'
  end

  def break_speed
    self.speed = 0
  end

  def show_wagons
    puts @wagons
  end

  def route=(route)
    @route = route
    @current_station = route.stations.first
  end

  def move_forward
    route.stations.each_with_index do |station, index|
      next unless station == current_station
      next if index == route.stations.size - 1

      self.current_station = route.stations[index + 1]
      break
    end
  end

  def move_back
    route.stations.each_with_index do |station, index|
      next unless station == current_station
      next if index.zero?

      self.current_station = route.stations[index - 1]
    end
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def delete_wagon(wagon)
    @wagons.delete_at(wagon)
  end

  def move_to_next_station
    raise 'Firstly add route' if @route.nil?

    if next_station
      current_station.send_train(self)
      next_station.add_train(self)
      @current_station_index += 1
    else
      puts 'You are on the last station'
    end
  end

  def move_to_prev_station
    raise 'Firstly add route' if @route.nil?

    if previous_station
      current_station.send_train(self)
      previous_station.add_train(self)
      @current_station_index -= 1
    else
      puts 'You are on the first station'
    end
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def next_station
    @route.stations[@current_station_index + 1] if @current_station_index + 1 <= @route.stations.count - 1
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @current_station_index - 1 >= 0
  end

  def block(&block)
    @wagons.each(&block)
  end
end
