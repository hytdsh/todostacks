require 'google/apis/tasks_v1'
require 'googleauth'

class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:main]
  before_action :refresh_access_token_if_expired!, only: [:main]

  Tasks = Google::Apis::TasksV1

  def main
    if user_signed_in?
      oauth_client = Google::Auth::UserRefreshCredentials.new(
#      oauth = Google::Auth::Credentials.new( # does not work with error "no implicit conversion of nil into String"
        {
          "access_token" => current_user.token,
          "refresh_token" => current_user.refresh_token,
          "expires_at" => current_user.expires_at,
          "client_id" => Rails.application.credentials.google[:client_id],
          "client_secret" => Rails.application.credentials.google[:client_secret]
        }
      )

      service = Tasks::TasksService.new
      service.authorization = oauth_client
#      service.authorization = oauth.client # for Google::Auth::Credentials (if it works)

      @response = service.list_tasklists # max_results: 10 というような指定もできる
    end
  end

  def help
  end

  def contact
  end

  def about
  end
end
