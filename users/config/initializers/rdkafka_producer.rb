require 'rdkafka'

config = {
          :"bootstrap.servers" => "velomobile-01.srvs.cloudkafka.com:9094, velomobile-02.srvs.cloudkafka.com:9094",
          :"group.id"          => "example",
          :"sasl.username"     => "akz986mn",
          :"sasl.password"     => "_VHudUAXaBKVQiy3_sbRmy6GexAQkRCT",
          :"security.protocol" => "SASL_SSL",
          :"sasl.mechanisms"   => "SCRAM-SHA-256"
}
$topic = "akz986mn-default"

$rdkafka_producer = Rdkafka::Config.new(config).producer
