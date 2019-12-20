class ApplicationController < ActionController::Base

  private
    def refresh_access_token_if_expired!
      current_user.refresh_access_token_if_expired!
    end

    def connect_google_tasks
      if user_signed_in?
        oauth_client = Google::Auth::UserRefreshCredentials.new(
          {
            "access_token" => current_user.token,
            "refresh_token" => current_user.refresh_token,
            "expires_at" => current_user.expires_at,
            "client_id" => Rails.application.credentials.google[:client_id],
            "client_secret" => Rails.application.credentials.google[:client_secret]
          }
        )
        @service = Google::Apis::TasksV1::TasksService.new
        @service.authorization = oauth_client
      end
    end
end
