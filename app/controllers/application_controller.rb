require 'google/apis/tasks_v1'
require 'google/api_client/client_secrets.rb'

class ApplicationController < ActionController::Base
  Tasks = Google::Apis::TasksV1

  def taskstest
    secrets = Google::APIClient::ClientSecrets.new(
      {
        "web" =>
          {
            "access_token" => current_user.token,
            "refresh_token" => current_user.refresh_token,
            "client_id" => Rails.application.credentials.google[:client_id],
            "client_secret" => Rails.application.credentials.google[:client_secret]
          }
      }
    )

    service = Tasks::TasksService.new
    service.authorization = secrets.to_authorization

    response = service.list_tasklists max_results: 10
    render json: response
  end
end
