# encoding 'utf-8'
require 'redis'
require_relative 'pb_scrape'
require 'yaml'

class PBRedis
  def initialize
    path = __dir__
    yml_path = path + '/config.yml'
    config = YAML.load_file(yml_path)
    @r_host = config['redis_host']
    @redis = Redis.new(host: @r_host)
  end

  def check_redis(key, expire)
    r_key_ex = @redis.exists(key)
    if r_key_ex == false
      @redis.setex(key, expire, 1)
      @redis.disconnect!
      @redis.quit
      @res = false
    else
      # indicator that the key already exists in Redis
      @redis.disconnect!
      @redis.quit
      @res = true
    end
  end

  def quit_redis
    @redis.quit
  end
  def redis_update
    @to_write_array
  end

  def go
    k = 'pastebin_key' # key
    k_val = 1 # key value
    ex = 20 # expire
    @redis.setex(k, ex, k_val)
    if @redis.exists(k)
      puts("Key exists, move along as it's already been downloaded.")
    end
    sleep(10)

    puts(@redis.exists(k))
    sleep(10)
    puts(@redis.exists(k))
    sleep(10)
    if @redis.exists(k) == false
      puts('Key no longer exists, download from PB and insert key.')
    end

  end


end

