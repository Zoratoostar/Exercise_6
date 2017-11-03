
class Carriage
  include ProducingCompany
  include InstanceCounter

  attr_reader :number

  NUMBER_FORMAT = /\d{7}/

  def initialize(number)
    @number = number.to_s
    register_instance
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise "Номер вагона не может быть пустым." if number.nil?
    instruction = "Допустимый формат номера вагона: ровно семь цифр."
    raise instruction if number.length != 7 || number !~ NUMBER_FORMAT
    true
  end
end
