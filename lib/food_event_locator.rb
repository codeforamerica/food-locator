require 'google/api_client'
require 'time'
require 'tzinfo'

class FoodEventLocator

  def initialize
    @client = Google::APIClient.new
    @key = Google::APIClient::KeyUtils.load_from_pkcs12('food-locator-142509f4f6e5.p12', 'notasecret')

  end


  def get_latest_event

    @client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :audience => 'https://accounts.google.com/o/oauth2/token',
        :scope => 'https://www.googleapis.com/auth/calendar',
        :issuer => '295814611034-nnjss8k5vr8lkt09ue9aki1psb6rj96l@developer.gserviceaccount.com',
        :signing_key => @key)

    @client.authorization.fetch_access_token!

    calendar = @client.discovered_api('calendar', 'v3')

    now = Time.now.strftime('%FT%T%:z')
    result = @client.execute(:api_method => calendar.events.list,
                            :parameters => {'calendarId' => 'codeforamerica.org_jjcbvgie0a5nr654vsp83cjn5g@group.calendar.google.com',
                                            'maxResults' => '1',
                                            'singleEvents' => 'true',
                                            'timeMin' => now})


    item = result.data.items[0].start.dateTime

    # time = Time.parse item.created

    # eventually get senders timezone
    tz = TZInfo::Timezone.get('America/Los_Angeles')

    {:date => tz.utc_to_local(item.created).strftime('%m/%d/%Y %I:%M%p'), :location => item.location}
  end

end