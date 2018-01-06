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
topic = "akz986mn-go-cli"

rdkafka_consumer = Rdkafka::Config.new(config).consumer
rdkafka_consumer.subscribe(topic)

Rufus::Scheduler.singleton.every '5s' do
  puts "hello, it's #{Time.now}"
  begin
    rdkafka_consumer.each do |message|
      payload = JSON.parse(message.payload)
      puts payload
      Order.find(payload["id"].to_i).update(driver_id: payload["driver_id"], driver_name: payload["driver_name"], state: payload["state"])
    end
  rescue Rdkafka::RdkafkaError => e
    retry if e.is_partition_eof?
    raise
  end
end
