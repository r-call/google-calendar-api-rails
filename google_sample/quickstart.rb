require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = './client_secrets.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
  client_secret_config = {"web":{"client_id":"1072088737400-0mufodco7n7utcg21v8mis7s407t5atq.apps.googleusercontent.com","project_id":"test-calendar-access","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://accounts.google.com/o/oauth2/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"OvGF9yxhsSliDyN8sgxbyOsa","redirect_uris":["http://localhost:3000/oauth2callback","http://localhost:3000/authCode"],"javascript_origins":["http://localhost:3000"]}}
  puts Google::Auth::ClientId.inspect
  client_id = Google::Auth::ClientId.from_hash(client_secret_config.to_json)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# # Fetch the next 10 events for the user
# calendar_id = 'primary'
# time_min = Time.now.iso8601
# response = service.list_events(calendar_id,
#   max_results: 10,
#   single_events: true, 
#   order_by: 'startTime',
#   time_min)

# puts "Upcoming events:"
# puts "No upcoming events found" if response.items.empty?
# response.items.each do |event|
#   start = event.start.date || event.start.date_time
#   puts "- #{event.summary} (#{start})"
# end