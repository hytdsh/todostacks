require 'google/apis/tasks_v1'
require 'googleauth'

class ApplicationController < ActionController::Base

  Tasks = Google::Apis::TasksV1

  private
    def check_access_token
      begin
        current_user.refresh_access_token_if_expired! # raise error with revoke on google side when `exipres_at` has expired.
      rescue OAuth2::Error => e
        redirect_to destroy_user_session_path
      end
    end

    def check_signet
      if user_signed_in?
        @signet_oauth_client = Google::Auth::UserRefreshCredentials.new(
          {
            "access_token" => current_user.token,
            "refresh_token" => current_user.refresh_token,
            "expires_at" => current_user.expires_at,
            "client_id" => Rails.application.credentials.google[:client_id],
            "client_secret" => Rails.application.credentials.google[:client_secret]
          }
        )
        begin
          @signet_oauth_client.fetch_access_token # raise error with revoke on google side when `expires_at` has not expired.
        rescue Signet::AuthorizationError => e
          redirect_to destroy_user_session_path
        end
#        @service = Tasks::TasksService.new
#        @service.authorization = signet_oauth_client
      end
    end

    def connect_google_tasks
      service = Tasks::TasksService.new
      service.authorization = @signet_oauth_client
      return service
    end
end
