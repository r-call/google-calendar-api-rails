require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'
require 'json'

class SessionsController < ApplicationController
  
  def new
    if session.has_key?(:credentials)
      redirect_to '/pages/about'

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

    else
      redirect_to '/sessions/create'
    end
  end

  def create
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/calendar',
      :redirect_uri => 'http://localhost:3000/sessions/create'
    )
    if request['code'] == nil
      auth_uri = auth_client.authorization_uri.to_s
      redirect_to auth_uri
    else
      auth_client.code = request['code']
      auth_client.fetch_access_token!
      auth_client.client_secret = nil
      session[:credentials] = auth_client.to_json
      redirect_to '/pages/about'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_path, notice: "Adios!"
  end

end