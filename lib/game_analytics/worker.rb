require 'base64'
require 'openssl'
require 'httpclient'

module GameAnalytics
  class Worker

    include Common


    def initialize(q)
      @queue = q
      @http = HTTPClient.new
      @url_base = "http://api.gameanalytics.com/v2/#{options[:game_key]}"
    end

    def process(unit)
      metric = unit.is_a?(Array) ? unit.first : unit
      klass = metric.class

      json_data = [unit].to_json

      header = {'Authorization' => Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', options[:secret_key], json_data)) }
      header['X-Forwarded-For'] = metric.origin_ip if metric.origin_ip

      url = "#{@url_base}/events"

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
