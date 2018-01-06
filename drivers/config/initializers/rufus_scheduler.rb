require 'rufus-scheduler'
require 'rdkafka'

config = {
  :"bootstrap.servers" => "velomobile-01.srvs.cloudkafka.com:9094, velomobile-02.srvs.cloudkafka.com:9094",
  :"group.id"          => "example",
  :"sasl.username"     => "akz986mn",
  :"sasl.password"     => "_VHudUAXaBKVQiy3_sbRmy6GexAQkRCT",
  :"security.protocol" => "SASL_SSL",
  :"sasl.mechanisms"   => "SCRAM-SHA-256"
}
topic = "akz986mn-default"

rdkafka_consumer = Rdkafka::Config.new(config).consumer
rdkafka_consumer.subscribe(topic)

GMAPS = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')

Rufus::Scheduler.singleton.every '5s' do
  puts "hello, it's #{Time.now}"
  begin
    rdkafka_consumer.each do |message|
      order = JSON.parse(message.payload)
      puts order
      find_driver_for(order)
    end
  rescue Rdkafka::RdkafkaError => e
    retry if e.is_partition_eof?
    raise
  end
end

def find_driver_for(order)
  max_distance = 5
  driver = nil

  Fleet.all.each do |fleet|
    if fleet.service_id == order["service_id"]
      distance = get_distance(fleet.location, order["origin"])
      if distance < max_distance
        driver = fleet
        max_distance = distance
      end
    end
  end

  if driver != nil
    fleet = driver
    id = fleet.id
    order["driver_id"]   = fleet.driver_id
    order["driver_name"] = fleet.driver_name
    order["state"]       = "Completed"
    $rdkafka_producer.produce(payload: order.to_json, topic: $topic)
    fleet.update(location: order["destination"])
    if order["payment_type"] == "Go-Pay"
      Gopay.all.each do |gopay|
        @gopay = gopay if gopay.ref_type == "Driver" && gopay.ref_id == order["driver_id"]
      end
      @gopay.balance += order["price"].to_i
      # @gopay.save
    end
  end
end

def get_distance(driver, pickup)
  distance_matrix = GMAPS.distance_matrix(driver, pickup)
  distance = distance_matrix[:rows][0][:elements][0][:distance][:value] / 1000.0
  distance
end
