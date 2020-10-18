require 'kafka'
require 'yaml'
require 'json'

class PBKafka
  def initialize
    path = __dir__
    yml_path = path + '/config.yml'
    config = YAML.load_file(yml_path)
    brokers = config['kafka_brokers']
    @topic = config['kafka_topic']
    kafka_id = config['kafka_client_id']
    @kafka = Kafka.new(brokers, client_id:kafka_id)
  end

  def send(doc_array)
    producer = @kafka.producer
    length = doc_array.length()
    doc_array.each do |item|
      jsonItem = JSON.dump(item)
      producer.produce(jsonItem, topic: @topic)
    end
    producer.deliver_messages
    puts "Number of messages sent to Kafka:"
    puts length
  end
  end
