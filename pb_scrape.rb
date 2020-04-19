# encoding 'utf-8'
require 'net/http'
require 'json'

class PBScrape
  def scrape_pastebin
    url = 'https://scrape.pastebin.com/api_scraping.php?limit=100'
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    @r_code = response.code
    puts @r_code
    if @r_code == '200'
      json_response = JSON.parse(response.body)
      @pb_redis_array = []
      @pb_redis_array2 = []
      json_response.each do |doc|

        pb_key = doc['key']
        pb_url = doc['scrape_url']
        pb_date = doc['date']
        pb_size = doc['size']
        pb_expire = doc['expire']
        pb_title = doc['title']
        pb_syntax = doc['syntax']
        pb_user = doc['user']
        pb_redis_hash = {'key' => pb_key,
                         'url' => pb_url,
                         'date' => pb_date,
                         'size' => pb_size,
                         'expiration' => pb_expire,
                         'title' => pb_title,
                         'syntax' => pb_syntax,
                         'user' => pb_user }
        @pb_redis_array.push(pb_redis_hash)
        @pb_redis_array2.push(doc)
      end
      puts 'Original length from pastebin:'
      @pb_length = @pb_redis_array2.length
      puts @pb_length
    end

  end

  def pb_values
    @pb_redis_array2
  end

  def pb_length
    @pb_length
  end

  def pb_code
    @r_code
  end

  def scrape_pb_docs(in_array)
    url1 = 'https://scrape.pastebin.com/api_scrape_item.php?i='
    @mongo_docs = []
    in_array.each do |hsh|
      url2 = url1 + hsh['key']
      uri = URI.parse(url2)
      response = Net::HTTP.get_response(uri)
      if response.code == '200'
        raw_response = response.body.force_encoding("UTF-8")
        hsh[:raw_paste] = raw_response
        @mongo_docs.push(hsh)
      else
        error = 'Error' + response.code
        hsh[:raw_paste] = error
        @mongo_docs.push(hsh)
      end

    end

  end

  def mongo_values
    @mongo_docs
  end

end
