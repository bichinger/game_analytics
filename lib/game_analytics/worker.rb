require 'digest/md5'
require 'httpclient'

module GameAnalytics
class Worker
  
  include Common


  def initialize(q)
    @queue = q
    @http = HTTPClient.new
    @url_base = "http://api.gameanalytics.com/1/#{options[:game_key]}"
  end
  
  def process(unit)
    klass = unit.is_a?(Array) ? unit.first.class : unit.class
    category = klass.name.demodulize.downcase
    json_data = unit.to_json
    hd = Digest::MD5.hexdigest(json_data + options[:secret_key])
    url = "#{@url_base}/#{category}"
    logger.info "GameAnalytics <: #{url} #{json_data} #{hd}"
    resp = @http.post(url, :body => json_data, :header => { 'Authorization' => hd })
    logger.info "GameAnalytics >: #{resp.content} (#{resp.status})"
  end
  
  def run
    logger.info "GameAnalytics worker running"
    loop do
      process @queue.pop
    end
  end

end
end
