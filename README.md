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

```ruby
gem 'game_analytics'
```

And then execute:

  $ bundle

Or install it yourself as:

    $ gem install game_analytics

## Usage

Configure the gem with your GameAnalytics keys by placing code like the following in
your initializer:

```ruby
GameAnalytics.config(
  :game_key => '123451234512345123451234512345',
  :secret_key => '123451234512345123451234512345'
)
```

In your application, create Metric objects of the appropriate GameAnalytics types
(Design, Business, Quality, or User), and send them to the service:

```ruby
m = GameAnalytics::Metric::Business.new(:user_id => '-100', :session_id => '-100',
  :build => 'development', :message => 'test')
GameAnalytics.client.enqueue m
```

GameAnalytics uses the submitting ip to determine the country the user resides in. If you are submitting events
in the name of the user (e.g. client) from another machine (e.g. server), you can pass the original ip using `new_with_ip`:

```ruby
m = GameAnalytics::Metric::Business.new_with_ip('123.123.123.123', :user_id => '-100', :session_id => '-100', :build => 'development', :message => 'test')
GameAnalytics.client.enqueue m
```

You can also send arrays of objects in a single service request:

```ruby
GameAnalytics.client.enqueue [m1, m2]
```

## Events

There are 4 types of events you can send to GameAnalytics. For a general description of events see [General event structure](http://support.gameanalytics.com/hc/en-us/articles/200841486-General-event-structure).

All events **require** the following fields:

| Field      | Type   | Required | Description                                                                                                                                                           |
|:-----------|:-------|:--------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| user_id    | string | **Yes**  | A unique ID representing the user playing your game. This ID should remain the same across different play sessions.                                                   |
| session_id | string | **Yes**  | A unique ID representing the current play session. A new unique ID should be generated at the start of each session, and used for all events throughout that session. |
| build      | string | **Yes**  | Describes the current version of the game being played.                                                                                                               |


### Design Event

Documentation: [Design event structure](http://support.gameanalytics.com/hc/en-us/articles/200841506-Design-event-structure)

#### Additional fields

| Field    | Type   | Required | Description                                                                                                                                                                    |
|:---------|:-------|:--------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| event_id | string | **Yes**  | Identifies the event. This field can be sub-categorized by using ":", eg. "PickedUpAmmo:Shotgun".                                                                              |
| area     | string |    No    | Indicates the area or game level where the event occurred.                                                                                                                     |
| value    | float  |    No    | Numeric value which may be used to enhance the event_id. For example, if the event_id is "PickedUpAmmo:Shotgun", the value could indicate the number of shotgun shells gained. |
| x        | float  |    No    | The x coordinate at which this event occurred.                                                                                                                                 |
| y        | float  |    No    | The y coordinate at which this event occurred.                                                                                                                                 |
| z        | float  |    No    | The z coordinate at which this event occurred.                                                                                                                                 |


### User Event

Documentation: [User event structure](http://support.gameanalytics.com/hc/en-us/articles/200841526-User-event-structure)

#### Additional fields

| Field             | Type    | Required | Description                                                                                             |
|:------------------|:--------|:--------:|:--------------------------------------------------------------------------------------------------------|
| gender            | char    |    No    | The gender of the user (M/F).                                                                           |
| birth_year        | integer |    No    | The year the user was born.                                                                             |
| friend_count      | integer |    No    | The number of friends in the users network.                                                             |
| facebook_id       | string  |    No    | The Facebook ID of the user, in clear.                                                                  |
| googleplus_id     | string  |    No    | The Google Plus ID of the user, in clear.                                                               |
| ios_id            | string  |    No    | The IDFA of the user, in clear.                                                                         |
| android_id        | string  |    No    | The Android ID of the user, in clear.                                                                   |
| adtruth_id        | string  |    No    | The AdTruth ID of the user, in clear.                                                                   |
| platform          | string  |    No    | The platform that this user plays the game on.                                                          |
| device            | string  |    No    | The device that this user plays the game on.                                                            |
| os_major          | string  |    No    | The major version of the OS that this user plays on.                                                    |
| os_minor          | string  |    No    | The minor version of the OS that this user plays on.                                                    |
| install_publisher | string  |    No    | The name of the ad publisher.                                                                           |
| install_site      | string  |    No    | The website or app where the ad for your game was shown.                                                |
| install_campaign  | string  |    No    | The name of your ad campaign this user comes from.                                                      |
| install_adgroup   | string  |    No    | The name of the ad group this user comes from.                                                          |
| install_ad        | string  |    No    | The name of the ad this user comes from.                                                                |
| install_keyword   | string  |    No    | A keyword to associate with this user and the campaign ad.                                              |
| sdk_version       | string  |    No    | Used by the GA team to provide support on specific versions of the different GA SDKs. DO NOT implement. |


### Business Event

Documentation: [Business event structure](http://support.gameanalytics.com/hc/en-us/articles/200841516-Business-event-structure)

#### Additional fields

| Field    | Type    | Required | Description                                                                                                                                                                                                                                                                                                                                                                               |
|:---------|:--------|:--------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| event_id | string  | **Yes**  | Identifies the event. This field can be sub-categorized by using ":", eg. "Purchase:RocketLauncher:Ammo".                                                                                                                                                                                                                                                                                 |
| area     | string  |    No    | Indicates the area or game level where the event occurred.                                                                                                                                                                                                                                                                                                                                |
| value    | float   |    no    | Numeric value which may be used to enhance the event_id. For example, if the event_id is "Purchase:RocketLauncher:Ammo", the value could indicate the number of rocket launcher ammo bought.                                                                                                                                                                                              |
| currency | string  | **Yes**  | A custom string for identifying the currency. The monetization dashboard will only be populated if you use one of the supported currencies, for example "USD", "RON" or "DKK". For all other virtual currency strings, you will need to create your custom dashboards and widgets.                                                                                                        |
| amount   | integer | **Yes**  | Numeric value which corresponds to the cost of the purchase in the monetary unit multiplied by 100. For example, if the currency is "USD", the amount should be specified in cents. Exception: Google Play IAB uses a comma separator for representing EUR currency. Before you multiply by 100 we recommend you replace the comma with a point separator. (Example: 12,68€  -> 12.68€) |
| x        | float   |    No    | The x coordinate at which this event occurred.                                                                                                                                                                                                                                                                                                                                            |
| y        | float   |    No    | The y coordinate at which this event occurred.                                                                                                                                                                                                                                                                                                                                            |
| z        | float   |    No    | The z coordinate at which this event occurred.                                                                                                                                                                                                                                                                                                                                            |


### Error Event

Documentation: [Error and Quality event structure](http://support.gameanalytics.com/hc/en-us/articles/200841476-Error-and-Quality-event-structure)

#### Additional fields

| Field    | Type   | Required | Description                                                                                                                          |
|:---------|:-------|:--------:|:-------------------------------------------------------------------------------------------------------------------------------------|
| message  | string | **Yes**  | Used to describe the event in further detail. For example, in the case of an exception the event could contain the stack trace.      |
| severity | string | **Yes**  | Used to describe the severity of the event. Must be one of the following values: `["critical", "error", "warning", "info", "debug"]` |
| area     | string |    No    | Indicates the area or game level where the event occurred.                                                                           |
| x        | float  |    No    | The x coordinate at which this event occurred.                                                                                       |
| y        | float  |    No    | The y coordinate at which this event occurred.                                                                                       |
| z        | float  |    No    | The z coordinate at which this event occurred.                                                                                       |


### Quality Event (Deprecated)
Documentation: [Error and Quality event structure](http://support.gameanalytics.com/hc/en-us/articles/200841476-Error-and-Quality-event-structure)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
