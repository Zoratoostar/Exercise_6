
class FreightWagon < Carriage
  attr_reader :purpose

  self.instances = 0

  def initialize(number, purpose)
    super(number)
    @purpose = purpose.to_s
    validate!
  end

  def to_s
    "#{number}=#{purpose}="
  end

  protected

  def validate!
    super
    raise "Назначение вагона должно быть указано." if purpose.nil?
    true
  end
end
