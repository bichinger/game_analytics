# GameAnalytics

The GameAnalytics gem saves metrics data to gameanalytics.com.  It is lightweight and performs the metrics
update on a separate worker thread to avoid interfering with normal request processing.

The gem prioritizes avoiding disruption to the host application over rigorously saving all
metrics data whatever the circumstances.  That is, if there are problems talking to gameanalytics.com,
some metrics data may be dropped, but the host application should continue on as normal.

Metrics data is held in memory in the worker process until it is either saved on gameanalytics.com or
dropped due to falling behind.  The latter should be an unusual circumstance when gameanalytics.com is
available.

## Installation

Add this line to your application's Gemfile:

    gem 'game_analytics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install game_analytics

## Usage

Configure the gem with your GameAnalytics keys by placing code like the following in
your initializer:

    GameAnalytics.config(
      :game_key => '123451234512345123451234512345',
      :secret_key => '123451234512345123451234512345'
    )

In your application, create Metric objects of the appropriate GameAnalytics types
(Design, Business, Quality, or User), and send them to the service:

    m = GameAnalytics::Metric::Business.new(:user_id => '-100', :session_id => '-100',
      :build => 'development', :message => 'test')
    GameAnalytics.client.enqueue m

GameAnalytics uses the submitting ip to determine the country the user resides in. If you are submitting events
in the name of the user (e.g. client) from another machine (e.g. server), you can pass the original ip using `new_with_ip`:

    m = GameAnalytics::Metric::Business.new_with_ip('123.123.123.123', :user_id => '-100', :session_id => '-100',
          :build => 'development', :message => 'test')
        GameAnalytics.client.enqueue m

You can also send arrays of objects in a single service request:

    GameAnalytics.client.enqueue [m1, m2]


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
