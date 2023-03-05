# frozen_string_literal: true

class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add_station(sname)
    @stations.insert(-2, sname)
    puts @stations
  end

  def show_allstations
    puts @stations
  end

  def first_station
    @stations[0]
  end

  def delete_station(name)
    @stations.delete(name)
  end
end
