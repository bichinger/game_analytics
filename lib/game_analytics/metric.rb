module GameAnalytics
class Metric
  
  include Common
  
  
  def initialize(data={})
    @data = data
    needs = required_keys - data.keys
    raise "missing required fields #{needs}" unless needs.empty?
  end
  
  def as_json(options={})
    @data
  end
  
  def required_keys
    [:user_id, :session_id, :build, :event_id]
  end


  class Design < Metric
  end
  
  class User < Metric
  end
  
  class Business < Metric
    
    def required_keys
      super + [:currency, :amount]
    end
    
  end
  
  class Quality < Metric
  end


end
end
