
class PassengerCarriage < Carriage
  attr_reader :seats

  self.instances = 0

  def initialize(number, seats)
    super(number)
    @seats = seats.to_i
    validate!
  end

  def to_s
    "#{number}::#{seats}::"
  end

  protected

  def validate!
    super
    raise "Число посадочных мест в вагоне должно быть указано." if seats.nil?
    instruction = "Введённое число посадочных мест некорректно."
    raise instruction if !(seats > 10 && seats < 110)
    true
  end
end
