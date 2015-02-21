require 'rubygems'
require 'google/api_client'

# boot bundler
require "bundler"
Bundler.setup

require 'rack'
require 'sinatra'
require 'json'
require 'twilio-ruby'

require './lib/food_event_locator'


# hand over exception handling to our handlers defined below
disable :show_exceptions
disable :raise_errors
#disable :dump_errors
set :protection, :except => :json_csrf

# # put your own credentials here
account_sid = 'AC2738c42b6d6a978bb08219565aa2385c'
auth_token = '31bfaaf56b068e1f17de3a41d66178ac'
#
# # set up a client to talk to the Twilio REST API
TWILIO_CLIENT = Twilio::REST::Client.new account_sid, auth_token


FROM_NUMBER = '+19162356999'

FOOD_LOCATOR = FoodEventLocator.new

def get_next_event
  FOOD_LOCATOR.get_latest_event
end


def format_event(event)
  "Next food distribution is on #{event[:date]} located at #{event[:location]}"
end

post '/sms' do

  puts "Inbound sms from #{@params['From']} with message #{@params['Body']}"

  event = get_next_event

  TWILIO_CLIENT.messages.create(
      from: FROM_NUMBER,
      to: @params['From'],
      body: format_event(event)
  )

  "OK"
end



