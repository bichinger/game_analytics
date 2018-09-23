module GameAnalytics
  class Metric

    include Common

    attr_accessor :origin_ip

    def self.new_with_ip(ip, data={})
      metric = self.new(data)
      metric.origin_ip = ip
      metric
    end

    def initialize(data={})
      data = shared_required_default_keys.merge(data)

      @data = data
      needs = required_keys - data.keys
      raise "missing required fields #{needs}" unless needs.empty?
    end

    def as_json(options={})
      @data
    end

    def required_keys
      self.class.const_get("REQUIRED_KEYS")
    end

    def shared_required_default_keys
      {
        category: self.class.name.demodulize.downcase,
        device: 'unknown',
        v: 2,
        sdk_version: 'rest api v2',
        os_version: 'linux 0.0',
        manufacturer: 'unknown',
        platform: 'linux',
        client_ts: Time.zone.now.to_i
      }
    end


    class Design < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :session_num, :event_id]

    end

    class User < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :session_num, :event_id]

    end

    class Business < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :session_num, :event_id, :currency, :amount]

    end

    class Error < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :session_num]

    end

    class Progression < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :session_num]

    end

  end
end
