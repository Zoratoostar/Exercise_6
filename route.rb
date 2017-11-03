
class Route
  attr_reader :stations

  def initialize(initial_station, final_station)
    if initial_station.class == Station && final_station.class == Station
      @stations = [initial_station, final_station]
    end
  end

  def add_station(stn)
    if stn.class == Station
      stations.insert(-2, stn)
    end
  end

  def delete_station(stn)
    stations.delete(stn)
  end

  def list_stations
    stations.map &:to_s
  end

  def to_s
    list_stations.inspect
  end
end
