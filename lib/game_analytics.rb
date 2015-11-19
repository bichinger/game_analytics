require 'logger'
require 'game_analytics/common'
require 'game_analytics/client'
require 'game_analytics/metric'
require 'game_analytics/version'
require 'game_analytics/worker'


module GameAnalytics

  class << self
    attr_accessor :options, :logger, :disabled
  end

  self.logger = const_defined?('Rails') ? Rails.logger : Logger.new(STDOUT)

  def self.config(opts)
    @options = opts
    @logger = opts[:logger] if opts[:logger]
    @disabled = opts[:disabled]
  end

  def self.client
    @client ||= Client.new
  end

end
