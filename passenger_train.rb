
class PassengerTrain < Train
  def hitch_carriage(car)
    super(car) if car.class == PassengerCarriage
  end
end
