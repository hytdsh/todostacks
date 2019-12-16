require 'google/apis/tasks_v1'
require 'google/api_client/client_secrets.rb'

class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:main]
  before_action :refresh_access_token_if_expired!, only: [:main]

  Tasks = Google::Apis::TasksV1

  def main
    if user_signed_in?
      secrets = Google::APIClient::ClientSecrets.new(
        {
          "web" =>
            {
              "access_token" => current_user.token,
              "refresh_token" => current_user.refresh_token,
              "expires_at" => current_user.expires_at,
              "client_id" => Rails.application.credentials.google[:client_id],
              "client_secret" => Rails.application.credentials.google[:client_secret]
            }
        }
      )

      service = Tasks::TasksService.new
      service.authorization = secrets.to_authorization

      @response = service.list_tasklists # max_results: 10 というような指定もできる
      #render json: @response
    end
  end

  def help
  end

  def contact
  end

  def about
  end
end
