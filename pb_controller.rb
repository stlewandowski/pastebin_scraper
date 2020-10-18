#!/usr/bin/ruby
# encoding 'utf-8'
require_relative 'pb_scrape'
require_relative 'pb_redis'
require_relative 'pb_mongo'
require_relative 'pb_kafka'

class PBController
  def run
    x = PBScrape.new
    x.scrape_pastebin
    pb_val = x.pb_values
    y = PBRedis.new
    z = PBMongo.new
    k = PBKafka.new
    mongo_ins_array = []
    pb_val.each do |hsh|
      hsh_key = hsh['key']
      if y.check_redis(hsh_key, 600) == false
        mongo_ins_array.push(hsh)
      end
    end
    y.quit_redis
    x.scrape_pb_docs(mongo_ins_array)
    pb_doc_array = x.mongo_values
    z.insert(pb_doc_array)
    k.send(pb_doc_array)
    z.close
    # log info:
    # orig_len = x.pb_length
    # response_code = x.pb_code
    # total_inserted = z.num_inserted
    # time_s = Time.new.to_s
    # log_arr = [time_s, response_code, orig_len, total_inserted, "\n"]
    # log_data = log_arr.join(',')
    # File.write('<filepath>', log_data,mode: 'a')

  end

end



a = PBController.new

puts '#' * 50
puts 'Pastebin scrape and Mongo insert starting...'
time = Time.new
puts time.to_s
a.run
