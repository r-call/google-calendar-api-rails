require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'
require 'json'

class PagesController < ApplicationController

def about

  client_opts = JSON.parse(session[:credentials])
  puts client_opts.inspect
  auth_client = Signet::OAuth2::Client.new(client_opts)
  puts auth_client.inspect
  service = Google::Apis::CalendarV3::CalendarService.new
  puts service.inspect
  service.client_options.application_name = 'Ryan testing Google Calendar API'

  service.authorization = auth_client

  @calendar_list = service.list_calendar_lists
end

end
