require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'instance_counter'
require_relative 'company'
require_relative 'accessors.rb'
require_relative 'validation.rb'
require 'byebug'

class Main
  def initialize
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
  end

  def start
    loop do
      puts '++++++++++++++++++++++++++++++++++++++'
      puts 'Enter 1 to create station'
      puts 'Enter 2 to create train'
      puts 'Enter 3 to manage route'
      puts 'Enter 4 to appoint route to the train'
      puts 'Enter 5 to move the train'
      puts 'Enter 6 to see stations'
      puts 'Enter 7 to manage wagons'
      puts 'Enter 8 to create wagons'
      puts 'Enter 9 to see train wagons'
      puts 'Enter 10 to add passenger or cargo to wagons'
      puts '++++++++++++++++++++++++++++++++++++++'

      choice = gets.chomp

      get_action(choice)
    end
  end

  def get_action(choice)
    case choice
    when '1'
      create_station
    when '2'
      create_train
    when '3'
      manage_route
    when '4'
      appoint_route
    when '5'
      move_train
    when '6'
      check_station
    when '7'
      manage_wagons
    when '8'
      create_wagons
    when '9'
      show_train_wagons
    when '10'
      space_in_wagons
    end
  end

  private # c тем что ниже пользователь не будет взаимодействовать

  def create_station
    print 'Enter Station name: '
    station_name = gets.chomp
    station = Station.new(station_name)
    @stations << station
    puts "Station #{station_name} created"
      rescue StandardError => e
        puts "Error: #{e.message}"
      retry
  end

  def create_cargo_train
    print 'Enter number of train: '
    number = gets.chomp
    train = CargoTrain.new(number, 'cargo')
    @trains << train
    puts "Train number #{number} created"
      rescue StandardError => e
        puts "Error: #{e.message}"
      retry
  end

  def create_passenger_train
    print 'Enter number of train: '
    number = gets.chomp
    train = PassengerTrain.new(number, 'passenger')
    @trains << train
    puts "Train number #{number} created"
      rescue StandardError => e
        puts "Error: #{e.message}"
      retry
  end

  def train_action(choice)
    case choice
    when 'cargo'
      create_cargo_train
    when 'passenger'
      create_passenger_train
    else
      puts 'Wrong type!'
      create_train
    end
  end

  def create_train
    print 'What type of train do you want to create? (Cargo/Passenger): '
    choice = gets.chomp.downcase
    train_action(choice)
  end

  def manage_route
    print 'To create new route enter 1; to manage existing route enter 2: '
    x = gets.chomp.to_i
    if x == 1
      puts 'Enter number of first station from list below: '
      puts @stations
      first_station = gets.chomp.to_i
      print 'Enter number of last station from list: '
      last_station = gets.chomp.to_i
      route = Route.new(@stations[first_station - 1], @stations[last_station - 1])
      @routes << route
      puts 'Route created'
      print @routes
    end

    return unless x == 2

    print 'to add station enter 1: '
    x = gets.chomp.to_i

    return unless x == 1

    puts 'Enter station number from list below: '
    puts @stations.name
    y = gets.chomp.to_i
    puts 'Enter route number from list below: '
    puts @routes
    x = gets.chomp.to_i
    @routes[x - 1].add_station(@stations[y - 1])
  end

  def check_station
    puts 'Enter station number from list below: '
    puts @stations
    x = gets.chomp.to_i
    puts @stations[x - 1]
    @stations[x - 1].block do |train|
      puts "Trains : #{train.number} train type: #{train.type}"
    end
  end

  def appoint_route
    puts 'Enter train number from list below: '
    puts @trains
    train_number = gets.chomp.to_i
    print 'Enter route number from list below: '
    puts @routes
    route_number = gets.chomp.to_i
    @trains[train_number - 1].route = (@routes[route_number - 1])
    @routes[route_number - 1].first_station.add_train(@trains[train_number - 1])
  end

  def move_train
    puts 'Enter train number from list below: '
    puts @trains
    train_number = gets.chomp.to_i
    print 'Enter 1 to move forward; enter 2 to move back: '
    y = gets.chomp.to_i
    if y == 1
      @trains[train_number - 1].move_to_next_station
      puts @trains
    end
    return unless y == 2

    @trains[train_number - 1].move_to_prev_station
  end

  def create_cargo_wagon
    print 'Enter number of wagon: '
    number = gets.chomp
    
    print 'Enter max volume: '
    max_volume = gets.chomp.to_i
    wagon = CargoWagon.new(number, max_volume)
    @wagons << wagon
    puts "Cargo wagon #{number} created"
  end

  def create_passenger_wagon
    print 'Enter number of wagon: '
    number = gets.chomp
    
    print 'Enter max number of seats: '
    max_seats = gets.chomp.to_i
    wagon = PassengerWagon.new(number, max_seats)
  end

  def wagon_action(choice)
    case choice
    when 'cargo'
      create_cargo_wagon
    when 'passenger'
      create_passenger_wagon
    else
      puts 'Wrong type!'
      create_wagons
    end
  end

  def create_wagons
    print 'Enter what wagon do you want to create (cargo/passenger): '
    choice = gets.chomp.downcase
    wagon_action(choice)
  end

  def manage_wagons
    puts 'To attach wagon to the train enter 1: / to disconnect wagon press 2: '
    x = gets.chomp.to_i
    if x == 1
      print 'Enter number: '
      puts @wagons
      wagon_number = gets.chomp.to_i
      print 'Enter train number: '
      puts @trains
      train_number = gets.chomp.to_i

      if @trains[train_number - 1].type == @wagons[wagon_number - 1].type
        @trains[train_number - 1].add_wagon(@wagons[wagon_number - 1])
        puts 'Successful'
      else
        puts 'Wrong wagon type'
      end
    end

  return unless x == 2
    puts 'Chose train from list below'
    puts @trains
    train_number = gets.chomp.to_i
    puts 'Chose wagon from list below'
    @trains[train_number - 1].show_wagons
    wagon_number = gets.chomp.to_i
    wagon_number -= 1
    @trains[train_number - 1].delete_wagon(wagon_number)
  end

  def show_train_wagons
    print 'Enter train number: '
    train = gets.chomp.to_i
    @trains[train - 1].block do |wagon|
      puts "Wagons number#{wagon.number} Wagon type: #{wagon.type}"
    end
  end

  def space_in_wagons
    print 'Enter wagon from list below: '
    puts @wagons
    wagon = gets.chomp.to_i
    if @wagons[wagon - 1].type == 'cargo'
      print 'Enter how much volume you want to add: '
      fill = gets.chomp.to_i
      @wagons[wagon - 1].fill_tank(fill)
      puts "Succesfull added #{@wagons[wagon - 1].show_current_space}"
    end
    
    return unless @wagons[wagon - 1].type == 'passenger'
    @wagons[wagon - 1].add_passenger
    puts 'succesfull added 1 passenger'
  end
end
