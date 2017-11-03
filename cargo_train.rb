
class CargoTrain < Train
  def hitch_carriage(car)
    super(car) if car.class == FreightWagon
  end
end
