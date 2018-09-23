module GameAnalytics
  class Client

    include Common


    def initialize
      @queue = Queue.new
      @worker_mutex = Mutex.new
    end

    def enqueue(metric)
      return if disabled
      ensure_worker_running
      @queue << metric
      nil
    end


  private

    def ensure_worker_running
      return if worker_running?
      @worker_mutex.synchronize do
        return if worker_running?
        start_worker
      end
    end

    def worker_running?
      @worker_thread && @worker_thread.alive?
    end

    def start_worker
      @worker_thread = Thread.new do
        #begin
          Worker.new(@queue).run
        #rescue => ex
          #logger.info "GameAnalytics worker thread exception: #{ex}"
        #end
      end
    end

  end
end
