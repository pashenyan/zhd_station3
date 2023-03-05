# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation
  attr_reader :name
  
  validate :name, :presence

  @@stations = []
  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
  end

  def self.all
    puts @@stations
  end

  def show_trains
    puts @trains
  end

  def add_train(cargotrain)
    @trains << cargotrain
  end

  def show_type(type)
    @trains.select(type)
  end

  def send_train(train)
    @trains.delete(train)
  end

  def block(&block)
    @trains.each do |train|
      block.call(train)
    end
  end
end
