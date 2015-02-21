require 'rubygems'
require 'google/api_client'

# boot bundler
require "bundler"
Bundler.setup

require 'rack'
require 'sinatra'
require 'json'
require 'twilio-ruby'

# hand over exception handling to our handlers defined below
disable :show_exceptions
disable :raise_errors
#disable :dump_errors
set :protection, :except => :json_csrf

client = Google::APIClient.new

# # put your own credentials here
account_sid = 'AC2738c42b6d6a978bb08219565aa2385c'
auth_token = '31bfaaf56b068e1f17de3a41d66178ac'
#
# # set up a client to talk to the Twilio REST API
TWILIO_CLIENT = Twilio::REST::Client.new account_sid, auth_token
key = Google::APIClient::KeyUtils.load_from_pkcs12('food-locator-142509f4f6e5.p12', 'notasecret')
client.authorization = Signet::OAuth2::Client.new(
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience => 'https://accounts.google.com/o/oauth2/token',
    :scope => 'https://www.googleapis.com/auth/calendar',
    :issuer => '295814611034-nnjss8k5vr8lkt09ue9aki1psb6rj96l@developer.gserviceaccount.com',
    :signing_key => key)
client.authorization.fetch_access_token!

calendar = client.discovered_api('calendar', 'v3')

page_token = nil
result = client.execute(:api_method => calendar.events.list,
                          :parameters => {'calendarId' => 'codeforamerica.org_jjcbvgie0a5nr654vsp83cjn5g@group.calendar.google.com'})
response = ""
while true
  events = result.data.items
  events.each do |e|
    response = e.summary + "\n"
  end
  if !(page_token = result.data.next_page_token)
    break
  end
  result = client.execute(:api_method => calendar.events.list,
                            :parameters => {'calendarId' => 'codeforamerica.org_jjcbvgie0a5nr654vsp83cjn5g@group.calendar.google.com',
                                            'pageToken' => page_token})
end


get '/hi' do

FROM_NUMBER = '+19162356999'



def get_next_event
  return {:date => 'Sometime', :location => 'Someloc'}
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



post '/hi' do

  puts "Request: #{request.inspect}"

  "Sup"
  response

end
end

