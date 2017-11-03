
class Station
  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.to_s
    validate!
    @trains = []
    @@stations << self
  end

  def receive_train(trn)
    if (trn.class.ancestors.include? Train) && !(trains.include? trn)
      trains << trn
      trn
    end
  end

  def send_train(trn)
    trains.delete(trn)
  end

  def get_passenger_trains
    trains.select { |trn| trn.class == PassengerTrain }
  end

  def get_freight_trains
    trains.select { |trn| trn.class == CargoTrain }
  end

  def list_all_trains
    trains.map &:to_s
  end

  def list_passenger_trains
    get_passenger_trains.map &:to_s
  end

  def list_freight_trains
    get_freight_trains.map &:to_s
  end

  def to_s
    name
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise "Название станции должно быть указано." if name.nil?
    instruction = "Название станции не должно быть столь кратким."
    raise instruction if name.length < 3
    true
  end
end
