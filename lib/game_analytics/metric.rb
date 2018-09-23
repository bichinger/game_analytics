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
      data = data.merge(shared_required_default_keys)

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
        devise: 'unknown',
        v: 2,
        sdk_version: 'rest api v2',
        os_version: 'unknown',
        manufacturer: 'unknown',
        platform: 'unknown',
        client_ts: Time.zone.now.to_i
      }
    end


    class Design < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :build, :event_id]

    end

    class User < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :build, :event_id]

    end

    class Business < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :build, :event_id, :currency, :amount]

    end

    class Quality < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :build, :event_id]

      def initialize(data={})
        super
        logger.warn('Deprecation Warning: the Quality metric is deprecated, please use the Error metric instead')
      end

    end

    class Error < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :build]

    end

    class Progression < Metric

      REQUIRED_KEYS = [:user_id, :session_id, :build]

    end

  end
end
