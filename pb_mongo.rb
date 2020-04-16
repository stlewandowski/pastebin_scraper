# encoding 'utf-8'
require_relative 'pb_redis'
require 'mongo'
require 'yaml'

Mongo::Logger.logger.level = ::Logger::WARN


class PBMongo
  def initialize
    path = __dir__
    yml_path = path + '/config.yml'
    config = YAML.load_file(yml_path)
    usr = ENV['MONGO_USR']
    pass = ENV['MONGO_PASS']
    m_array = config['mongo_hosts']
    m_db = config['mongo_db']
    m_rs = config['replica_set']
    # for single Mongo instances, remove 'replica_set' key below and
    # put single host:port combination in 'mongo_db' in config.yml
    @client = Mongo::Client.new(m_array, database: m_db, replica_set: 'rs', user: usr, password: pass)
  end

  def insert(doc_array)
    coll = @client[:pb_data]
    result = coll.insert_many(doc_array)
    puts 'Number Inserted into Mongo:'
    @num_inserted = result.inserted_count
    puts(@num_inserted)

  end

  attr_reader :num_inserted

  def close
    @client.close
  end

end
