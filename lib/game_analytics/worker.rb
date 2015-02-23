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
      metric = unit.is_a?(Array) ? unit.first : unit
      klass = metric.class

      json_data = unit.to_json
      header = {'Authorization' => Digest::MD5.hexdigest(json_data + options[:secret_key])}
      header['X-Forwarded-For'] = metric.origin_ip if metric.origin_ip
      category = klass.name.demodulize.downcase
      url = "#{@url_base}/#{category}"
      logger.info "GameAnalytics <: #{url} #{json_data} #{header.inspect}"
      resp = @http.post(url, :body => json_data, :header => header)
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
