
class Train
  include ProducingCompany

  attr_reader :unique_number, :route, :carriages
  attr_accessor :speed, :current_station_index
  protected :speed, :current_station_index

  NUMBER_FORMAT = /[a-z\d]{3}-?[a-z\d]{2}/i

  @@trains = {}

  def self.find(uid)
    @@trains[uid.to_s]
  end

  def initialize(uid)
    @unique_number = uid.to_s
    validate!
    @carriages = []
    @speed = 0
    @@trains[unique_number] = self
  end

  def add_speed(amount)
    self.speed += amount
  end

  def stop
    self.speed = 0
  end

  def hitch_carriage(car)
    if speed == 0 && (car.class.ancestors.include? Carriage)
      carriages << car
      car
    end
  end

  def unhook_carriage
    if speed == 0 && carriages.length > 0
      carriages.pop
    end
  end

  def list_carriages
    carriages.map &:to_s
  end

  def assign_route(route)
    if route.class == Route
      @route = route
      self.current_station_index = 0
      current_station.receive_train(self)
    end
  end

  def shift_forward
    if next_station
      current_station.send_train(self)
      self.current_station_index += 1
      current_station.receive_train(self)
    end
  end

  def shift_backward
    if previous_station
      current_station.send_train(self)
      self.current_station_index -= 1
      current_station.receive_train(self)
    end
  end

  def to_s
    unique_number
  end

  def current_station
    route.stations[current_station_index]
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise "Номер поезда не может быть пустым." if unique_number.nil?
    instruction = <<-EOM
    Допустимый формат: три буквы или цифры в любом порядке,
    необязательный дефис (может быть, а может нет)
    и еще 2 буквы или цифры после дефиса.
    EOM
    mresult = NUMBER_FORMAT.match(unique_number)
    if !mresult || mresult[0].length != unique_number.length
      raise instruction
    end
    instruction = "Номер поезда должен быть уникальным."
    raise instruction if self.class.find(unique_number)
    true
  end

  def next_station
    route.stations[current_station_index + 1]
  end

  def previous_station
    if current_station_index > 0
      route.stations[current_station_index - 1]
    end
  end
end
