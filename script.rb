require 'rubygems'
require 'google/api_client'

  client = Google::APIClient.new

  key = Google::APIClient::KeyUtils.load_from_pkcs12('food-locator-142509f4f6e5.p12', 'notasecret')
  client.authorization = Signet::OAuth2::Client.new(
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience => 'https://accounts.google.com/o/oauth2/token',
    :scope => 'https://www.googleapis.com/auth/calendar',
    :issuer => '295814611034-nnjss8k5vr8lkt09ue9aki1psb6rj96l@developer.gserviceaccount.com',
    :signing_key => key)
  client.authorization.fetch_access_token!

  calendar = client.discovered_api('calendar', 'v3')

now = Time.now
page_token = nil
  result = client.execute(:api_method => calendar.events.list,
                          :parameters => {'calendarId' => 'codeforamerica.org_jjcbvgie0a5nr654vsp83cjn5g@group.calendar.google.com'})
  while true
    events = result.data.items
    events.each do |e|
      puts e.summary + "\n"
    end
    if !(page_token = result.data.next_page_token)
      break
    end
    result = client.execute(:api_method => calendar.events.list,
                            :parameters => {'calendarId' => 'codeforamerica.org_jjcbvgie0a5nr654vsp83cjn5g@group.calendar.google.com',
                                            'pageToken' => page_token})
  end

