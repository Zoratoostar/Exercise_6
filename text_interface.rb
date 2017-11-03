
class TextInterface
  attr_reader :stations, :cargo_trains, :passenger_trains, :routes

  def initialize
    @stations = []
    @cargo_trains = []
    @passenger_trains = []
    @routes = []
  end

  def start_menu
    loop do
      puts " Выберите вариант путём ввода номера пункта меню:"
      puts " 0 Выход."
      puts " 1 Создать станцию."
      puts " 2 Создать поезд."
      puts " 3 Добавить вагоны к поезду."
      puts " 4 Отцепить вагоны от поезда."
      puts " 5 Создать маршрут."
      puts " 6 Добавить или удалить станции из маршрута."
      puts " 7 Назначить маршрут поезду."
      puts " 8 Переместить поезд по маршруту."
      puts " 9 Получить список станций и поездов."
      print " "
      begin
        case gets.strip
        when '0'
          break
        when '1'
          create_station
        when '2'
          puts "  Выберите вариант:"
          puts "  1 Создать грузовой поезд."
          puts "  2 Создать пассажирский поезд."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            create_cargo_train
          when '2'
            create_passenger_train
          end
        when '3'
          puts "  Выберите вариант:"
          puts "  1 Добавить вагоны к грузовому поезду."
          puts "  2 Добавить вагоны к пассажирскому поезду."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            add_freight_wagons
          when '2'
            add_passanger_carriages
          end
        when '4'
          puts "  Выберите вариант:"
          puts "  1 Отцепить вагоны от грузового поезда."
          puts "  2 Отцепить вагоны от пассажирского поезда."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            unhook_freight_wagons
          when '2'
            unhook_passanger_carriages
          end
        when '5'
          create_route
        when '6'
          puts "  Выберите вариант:"
          puts "  1 Добавить станции к маршруту."
          puts "  2 Удалить станции из маршрута."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            add_stations_to_route
          when '2'
            delete_stations_from_route
          end
        when '7'
          puts "  Выберите вариант:"
          puts "  1 Назначить маршрут грузовому поезду."
          puts "  2 Назначить маршрут пассажирскому поезду."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            assign_route_to_cargo_train
          when '2'
            assign_route_to_passanger_train
          end
        when '8'
          puts "  Выберите вариант:"
          puts "  1 Переместить грузовой поезд по назначенному маршруту."
          puts "  2 Переместить пассажирский поезд по назначенному маршруту."
          puts "  Для перехода к предыдущему меню введите любое другое значение."
          print "  "
          case gets.strip
          when '1'
            shift_cargo_train
          when '2'
            shift_passanger_train
          end
        when '9'
          get_lists
        end
      rescue => error
        puts "Произошла ошибка:"
        puts error.message
        puts error.backtrace
      end
    end
  end

  private

  def print_error(exception, indent = 4)
    puts
    puts "#{' ' * indent}#{exception.message}"
    puts
  end

  def create_station
    print "  Введите название станции: "
    name = gets.strip
    stations << Station.new(name)
  rescue => e
    print_error e
    retry
  end

  def create_cargo_train
    print "   Введите идентификатор грузового поезда: "
    name = gets.strip
    cargo_trains << CargoTrain.new(name)
  rescue => e
    print_error e
    retry
  end

  def create_passenger_train
    print "   Введите идентификатор пассажирского поезда: "
    name = gets.strip
    passenger_trains << PassengerTrain.new(name)
  rescue => e
    print_error e
    retry
  end

  def print_list(array, indent = 3)
    array.each_with_index do |name, index|
      #puts ' '*indent + "#{index + 1}. #{name}"
      puts "#{' ' * indent}#{index + 1}. #{name}"
    end
  end

  def add_freight_wagons
    puts "   Выберите грузовой поезд, которому необходимо добавить вагоны:"
    print_list cargo_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = cargo_trains[index]
    if index >= 0 && train
      loop do
        puts "    Список вагонов поезда \"#{train}\" следующий:"
        puts "    #{train.list_carriages}"
        puts "    Добавить новый вагон ?"
        puts "    Введите 1 или 2 для подтверждения данного действия."
        print "    "
        response = gets.to_i
        if response == 1 || response == 2
          begin
            puts "     Введите номер вагона:"
            print "     "
            number = gets.strip
            puts "     Введите предназначение или тип вагона:"
            print "     "
            purpose = gets.strip
            wagon = FreightWagon.new(number, purpose)
          rescue => e
            print_error(e, 7)
            retry
          end
          train.hitch_carriage(wagon)
        else
          break
        end
      end
    end
  end

  def add_passanger_carriages
    puts "   Выберите пассажирский поезд, которому необходимо добавить вагоны:"
    print_list passenger_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = passenger_trains[index]
    if index >= 0 && train
      loop do
        puts "    Список вагонов поезда \"#{train}\" следующий:"
        puts "    #{train.list_carriages}"
        puts "    Добавить новый вагон ?"
        puts "    Введите 1 или 2 для подтверждения данного действия."
        print "    "
        response = gets.to_i
        if response == 1 || response == 2
          begin
            puts "     Введите номер вагона:"
            print "     "
            number = gets.strip
            puts "     Введите число посадочных мест:"
            print "     "
            seats = gets.to_i
            wagon = PassengerCarriage.new(number, seats)
          rescue => e
            print_error(e, 7)
            retry
          end
          train.hitch_carriage(wagon)
        else
          break
        end
      end
    end
  end

  def unhook_freight_wagons
    puts "   Выберите грузовой поезд, от которого следует отцепить вагоны:"
    print_list cargo_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = cargo_trains[index]
    if index >= 0 && train
      puts "    Список вагонов грузового поезда \"#{train}\" следующий:"
      puts "    #{train.list_carriages}"
      puts "    Сколько вагонов следует отцепить ?"
      print "    "
      count = gets.to_i
      count.times { train.unhook_carriage }
      puts "    Список оставшихся вагонов поезда \"#{train}\":"
      puts "    #{train.list_carriages}"
      print "    "
      gets
    end
  end

  def unhook_passanger_carriages
    puts "   Выберите пассажирский поезд, от которого следует отцепить вагоны:"
    print_list passenger_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = passenger_trains[index]
    if index >= 0 && train
      puts "    Список вагонов пассажирского поезда \"#{train}\" следующий:"
      puts "    #{train.list_carriages}"
      puts "    Сколько вагонов следует отцепить ?"
      print "    "
      count = gets.to_i
      count.times { train.unhook_carriage }
      puts "    Список оставшихся вагонов поезда \"#{train}\":"
      puts "    #{train.list_carriages}"
      print "    "
      gets
    end
  end

  def create_route
    puts "  Выберите начальную станцию маршрута из следующего списка:"
    print_list stations, 2
    print "  "
    index = gets.to_i - 1
    initial_station = stations[index]
    if index >= 0 && initial_station
      puts "  Выберите конечную станцию маршрута из приведённого списка:"
      print "  "
      index = gets.to_i - 1
      final_station = stations[index]
      if index >= 0 && final_station && initial_station != final_station
        routes << Route.new(initial_station, final_station)
      end
    end
  end

  def add_stations_to_route
    puts "  Выберите маршрут для добавления к нему станций:"
    print_list routes, 2
    print "  "
    index = gets.to_i - 1
    route = routes[index]
    if index >= 0 && route
      available_stations = stations.dup
      route.stations.each do |stn|
        available_stations.delete(stn)
      end
      loop do
        puts "   Выберите станцию для добавления из доступных:"
        print_list available_stations
        puts "   Введите номер, любое отличное значение отменит действие."
        print "   "
        index = gets.to_i - 1
        avl_stn = available_stations[index]
        if index >= 0 && avl_stn
          route.add_station(avl_stn)
          available_stations.delete(avl_stn)
          puts "    Маршрут изменён:"
          puts "    #{route}"
          print "    "
          gets
        else
          break
        end
      end
    end
  end

  def delete_stations_from_route
    puts "  Выберите маршрут для удаления из него станций:"
    print_list routes, 2
    print "  "
    index = gets.to_i - 1
    route = routes[index]
    if index >= 0 && route
      loop do
        break if route.stations.length == 2
        puts "   Выберите станцию для удаления:"
        print_list route.stations
        puts "   Введите номер, любое отличное значение отменит действие."
        print "   "
        index = gets.to_i - 1
        stn = route.stations[index]
        if index >= 0 && stn
          route.delete_station(stn)
          puts "    Маршрут изменён:"
          puts "    #{route}"
          print "    "
          gets
        else
          break
        end
      end
    end
  end

  def assign_route_to_cargo_train
    puts "   Выберите грузовой поезд, которому нужно назначить маршрут:"
    print_list cargo_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = cargo_trains[index]
    if index >= 0 && train
      puts "    Выберите маршрут для назначения грузовому поезду \"#{train}\":"
      print_list routes, 4
      print "    "
      index = gets.to_i - 1
      route = routes[index]
      if index >= 0 && route
        train.assign_route(route)
      end
    end
  end

  def assign_route_to_passanger_train
    puts "   Выберите пассажирский поезд, которому нужно назначить маршрут:"
    print_list passenger_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = passenger_trains[index]
    if index >= 0 && train
      puts "    Выберите маршрут для назначения пассажирскому поезду \"#{train}\":"
      print_list routes, 4
      print "    "
      index = gets.to_i - 1
      route = routes[index]
      if index >= 0 && route
        train.assign_route(route)
      end
    end
  end

  def shift_cargo_train
    puts "   Выберите грузовой поезд для перемещения по маршруту:"
    print_list cargo_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = cargo_trains[index]
    if index >= 0 && train && train.route
      loop do
        puts "    Маршрут грузового поезда следующий:"
        puts "    #{train.route}"
        #print_list train.route.list_stations, 4
        puts "    Текущая станция: \"#{train.current_station}\""
        puts "    1 Вперёд к следующей станции."
        puts "    6 Назад к предыдущей станции."
        puts "    0 Выход в главное меню."
        print "    "
        case gets.strip
        when '1'
          train.shift_forward
        when '6'
          train.shift_backward
        when '0'
          break
        end
      end
    end
  end

  def shift_passanger_train
    puts "   Выберите пассажирский поезд для перемещения по маршруту:"
    print_list passenger_trains
    puts "   Для перехода к предыдущему меню введите любое другое значение."
    print "   "
    index = gets.to_i - 1
    train = passenger_trains[index]
    if index >= 0 && train && train.route
      loop do
        puts "    Маршрут пассажирского поезда следующий:"
        puts "    #{train.route}"
        #print_list train.route.list_stations, 4
        puts "    Текущая станция: \"#{train.current_station}\""
        puts "    1 Вперёд к следующей станции."
        puts "    6 Назад к предыдущей станции."
        puts "    0 Выход в главное меню."
        print "    "
        case gets.strip
        when '1'
          train.shift_forward
        when '6'
          train.shift_backward
        when '0'
          break
        end
      end
    end
  end

  def get_lists
    puts "  Доступен следующий список станций:"
    print_list stations, 2
    puts "  Выберите нужную станцию для просмотра списка прибывших поездов."
    puts "  Для перехода к предыдущему меню введите любое другое значение."
    print "  "
    index = gets.to_i - 1
    station = stations[index]
    if index >= 0 && station
      puts "   Выберите вариант получения списка:"
      puts "   1 Грузовые поезда."
      puts "   2 Пассажирские поезда."
      puts "   3 Общий список всех поездов."
      print "   "
      case gets.strip
      when '1'
        puts "    Список грузовых поездов на станции \"#{station}\":"
        print_list(station.list_freight_trains, 4)
        print "    "
        gets
      when '2'
        puts "    Список пассажирских поездов на станции \"#{station}\":"
        print_list(station.list_passenger_trains, 4)
        print "    "
        gets
      when '3'
        puts "    Общий список поездов на станции \"#{station}\":"
        print_list(station.list_all_trains, 4)
        print "    "
        gets
      end
    end
  end
end
