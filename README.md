# Outreach

outreach is a wrapper for the outreach.io REST API.

You can find the outreach.io api docs here: https://github.com/getoutreach/outreach-platform-sdk

## Installation

First off you need to grab your [outreach.io](https://www.outreach.io) api oauth keys. You can sign up for access [here](http://goo.gl/forms/RWk35DeZAK)

Add this line to your application's Gemfile:

```ruby
gem 'outreach'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install outrach

Set your api access with:
```ruby
Outreach.application_identifier = 'YOUR APPLICATION IDENTIFIER'
Outreach.application_secret = 'YOUR APPLICATION SECRET'
Outreach.scopes = 'SCOPES FOR API ACCESS'
Outreach.redirect_uri = 'YOUR REDIRECT URI UPON OAUTH'
```
(Put this into an initializer i.e. ```app/initializers/outreach.rb``` if using Rails.)

## Authorization
First off you need to grab the authorization key for your user. You do this by getting them to follow the authorization URL:
```ruby
  Outreach::Authorization.authorization_url
```

For example, if using Rails this could be in a view
```
  <%= link_to("Connect to Outreach", Outreach::Authorization.authorization_url)
```

This will take the user through the oauth process - afterwards they will be redirected back to your site to whatever the url you have setup in Outreach.redirect_uri.  This will also provide the authorization key so you can get access for that user using the Outreach::Authorization.create method.

Here's a Rails example:

```ruby
class OutreachController < ApplicationController

  def callback
    user = current_user
    user.auth_code = params[:code]

    codes = Outreach::Authorization.create(params[:code])
    user.access_code = codes.token
    user.refresh_code = codes.refresh_token
    user.save

    flash[:notice] = "Outreach oauth connected"
    redirect_to home_path
  end
end
```

The access code can expire, but this can be refreshed using the refresh token

```ruby
# after authorization exception
codes = Outreach::Authorization.refresh(user.refresh_code)
user.access_code = codes.token
user.refresh_code = codes.refresh_token
user.save
```

## API Client
Once you have the access code for a user you can then create an api client for that user.
```ruby
  client = Outreach::Client.new(user.access_code)
```

## Prospects
To find all prospects:
```ruby
  client.prospects.all
  # returns an array of prospects
```

Filtering is possible by using the following conditions:
```ruby
  # first_name
  # last_name
  # email
  # company_name
  # e.g.
  client.prospects.all({ first_name: "Chris", last_name: "O'Sullivan" })
```

The results of client.prospects.all is paginated. You can control pagination by passing in which page you want to see:
```ruby
  client.prospects.all({ page: 2 })
```

You can find a specific prospect given the prospect id:
```ruby
  clients.prospect.find(2345)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/outreach/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
